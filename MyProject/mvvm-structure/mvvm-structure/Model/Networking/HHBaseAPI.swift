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

public enum HTTPRouter {
    // base url
    private static var baseURLString: String {
        return "https://jsonplaceholder.typicode.com/"
    }
    public var URLString: String {
        let path: String = {
            switch self {
            case .allPosts:
                return "posts"
            }
        }()
        return HTTPRouter.baseURLString + path
    }
    // APIs
    case allPosts
}

class HHBaseAPI {
    static var alamofireManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 30 // seconds
        return Alamofire.SessionManager(configuration:configuration)
    }()
    // base post
    func post<T: Mappable>(
        route: HTTPRouter,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil) -> Promise<T?> {
        return self.httpOperation(method: .post, route: route, parameters: parameters, headers: headers)
    }
    // base get
    func get<T: Mappable>(
        route: HTTPRouter,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil) -> Promise<T?> {
        return self.httpOperation(method: .get, route: route, parameters : parameters, headers: headers)
    }
    // uploading
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
    func handleJsonValue<T: Mappable>(
        jsonValue:Any?,
        fulfill: @escaping (T?) -> Void,
        reject: @escaping (Error) -> Void ) {
        // handle success request, map data
        if let response = Mapper<T>().map(JSONObject: jsonValue) {
            let res = response as? HHResponseModel
            if let code = res?.code, code >= 300 {
                var errorCode = code
                if let errCode = res?.errors?.first?.code {
                    errorCode = errCode
                }
                let anError = NSError(domain: "Internal Server Error",
                                      code: errorCode ,
                                      userInfo: [NSLocalizedDescriptionKey: "Error: \(code)"])
                // return internal error
                reject(anError)
                // connect successful with no error
            } else if let tokenError = res?.tokenError {//access token is not valid
                let anError = NSError(domain: "Internal Server Error",
                                      code: 401 ,
                                      userInfo: [NSLocalizedDescriptionKey: tokenError])
                // return internal error
                reject(anError)
            } else {
                fulfill(response)
            }
        } else {
            let err = NSError(domain: "Parsing Error", code: 400, userInfo: nil)
            reject(err)
        }
    }
}
