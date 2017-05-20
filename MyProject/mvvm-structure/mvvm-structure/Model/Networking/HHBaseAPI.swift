//
//  BaseAPI.swift
//  mvvm-structure
//
//  Created by Hieu Huynh on 5/20/17.
//  Copyright © 2017 Fraternal Group Pte. Ltd. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import ObjectMapper

/// The route for services
public enum HTTPRouter {
    /// Base URL for the services
    private static var baseURLString: String {
        return "https://reqres.in/"
    }
    /// the full endpoint of the route
    public var URLString: String {
        let path: String = {
            switch self {
            case .listUsers:
                return "api/users?page=2"
            case .singleUser(let userId):
                return "api/users/\(userId)"
            }
        }()
        return HTTPRouter.baseURLString + path
    }
    // APIs
    case listUsers
    case singleUser(userId: Int)
}

class HHBaseAPI {
    static var alamofireManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 30 // seconds
        return Alamofire.SessionManager(configuration:configuration)
    }()
    /// A base function to send a POST request
    ///
    /// - Parameters:
    ///   - route: the route of the request
    ///   - parameters: parameters of the request as a dictionary, nil by default
    ///   - headers: headers of the request as a dictionary, nil by default
    /// - Returns: the promise for the request
    func post<T: Mappable>(
        route: HTTPRouter,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil) -> Promise<T?> {
        return self.httpOperation(method: .post, route: route, parameters: parameters, headers: headers)
    }
    /// A base function to send a GET request
    ///
    /// - Parameters:
    ///   - route: the route of the request
    ///   - parameters: parameters of the request, nil by default
    ///   - headers: headers of the request, nil by default
    /// - Returns: the promise for the request
    func get<T: Mappable>(
        route: HTTPRouter,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil) -> Promise<T?> {
        return self.httpOperation(method: .get, route: route, parameters : parameters, headers: headers)
    }
    /// Method to send multipartData
    ///
    /// - Parameters:
    ///   - route: route of the request
    ///   - images: array of tuples with image names and image datas
    ///   - params: parameters of the request
    /// - Returns: the promise of the request
    func sendMultipartData<T: Mappable>(
        route: HTTPRouter,
        images: [(name: String, data: Data)],
        params: [(name: String, data: Data)]) -> Promise<T?> {
        return Promise<T?> {(fullfill, reject) -> Void in
            upload(multipartFormData: { (multipartFormData) in
                // PREPARE INPUTS
                // add images
                for image in images {
                    multipartFormData.append(
                        image.data,
                        withName: image.name,
                        fileName: "\(Int64(NSDate().timeIntervalSince1970*1000)).jpg",
                        mimeType: "image/jpeg")
                }
                // add parameters
                print("Request params:")
                for param in params {
                    print("\(param.name): \(String.init(data: param.data, encoding: .utf8) ?? "nil" )")
                    multipartFormData.append(param.data, withName: param.name)
                }
            }, to: route.URLString, headers: nil, encodingCompletion: { (encodingResult) in
                // ENCODE THE INPUTS
                switch encodingResult {
                // fail to encode
                case .failure(let error):
                    print("Response: \(route.URLString)\n \(error)")
                    let error = NSError(domain: "Encoding error",
                                        code: 400,
                                        userInfo: [NSLocalizedDescriptionKey: "\(error)"])
                    reject(error)
                    break
                case .success(let upload, _, _):
                    // success to encode
                    // BEGIN UPLOAD
                    upload.responseJSON(completionHandler: { (response) in
                        switch response.result {
                        case .success(let jsonValue):
                            print("Response: \(route.URLString)\n \(jsonValue)")   // result of response serialization
                            self.handleJsonValue(jsonValue: jsonValue, fulfill: fullfill, reject: reject)
                            break
                        case .failure(let error):
                            print("Response: \(route.URLString)\n \(error)")   // result of response serialization
                            reject(error)
                            return
                        }
                    })
                    break
                }
            })
        }
    }
    /// Call this function to send a http request
    ///
    /// - Parameters:
    ///   - method: Method of request e.g. POST or GET
    ///   - route: Route of the request
    ///   - parameters: parameters of the request, nil by default
    ///   - headers: headers of the request, nil by default
    /// - Returns: the returned promise
    private func httpOperation<T: Mappable>(
        method: HTTPMethod,
        route: HTTPRouter,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil) -> Promise<T?> {
        print("Request: \(route.URLString)\n params: \(String(describing: parameters))")
        return Promise<T?> { (fulfill, reject) -> Void in
            request(route.URLString,
                    method: method,
                    parameters: parameters,
                    headers: headers).responseJSON { (response) -> Void in
                        // result of response serialization
                        print("Response: \(route.URLString)\n"
                            + " \(response.result.value as Any)")
                        if let error = response.result.error {
                            reject(error) //network error
                        } else {
                            self.handleJsonValue(jsonValue: response.result.value, fulfill: fulfill, reject: reject)
                        }
            }
        }
    }
    /// Handle returned jsonValue
    ///
    /// - Parameters:
    ///   - jsonValue: the return jsonValue
    ///   - fulfill: the closure to call when fullfill
    ///   - response: the response object
    ///   - reject: the closure to call when reject
    ///   - error: the error of the request
    func handleJsonValue<T: Mappable>(
        jsonValue:Any?,
        fulfill: @escaping (_ response: T?) -> Void,
        reject: @escaping (_ error: Error) -> Void ) {
        // handle success request, map data
        if let response = Mapper<T>().map(JSONObject: jsonValue) {
            fulfill(response)
        } else {
            let err = NSError(domain: "Parsing Error", code: 400, userInfo: nil)
            reject(err)
        }
    }
}
