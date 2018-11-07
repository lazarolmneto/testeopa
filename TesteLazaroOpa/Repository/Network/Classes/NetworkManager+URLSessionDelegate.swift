//
//  NetworkManager+URLSessionDelegate.swift
//
//  Created by Lacir Moraes Neto, Lazaro on 08/06/18.
//

import UIKit

//MARK: URLSessionDelegate
extension NetworkManager: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let serverTrust = challenge.protectionSpace.serverTrust
        
        if let certificates = self.certificates, !certificates.isEmpty {
            let policies = NSMutableArray();
            policies.add(SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString)))
            SecTrustSetPolicies(serverTrust!, policies);
            
            // Evaluate server certificate
            var result: SecTrustResultType = SecTrustResultType(rawValue: 0)!
            SecTrustEvaluate(serverTrust!, &result)
            let isServerTrusted:Bool = result == SecTrustResultType.unspecified || result ==  SecTrustResultType.proceed
            
            // Get local and remote cert data
            var didMathCertificate = false
            
            for index in 0..<SecTrustGetCertificateCount(serverTrust!) {
                // render the tick mark each minute (60 times)
                let certificate = SecTrustGetCertificateAtIndex(serverTrust!, index)
                let remoteCertificateData:NSData = SecCertificateCopyData(certificate!)
                
                for cert in certificates{
                    if (isServerTrusted && remoteCertificateData.isEqual(to: cert)) {
                        didMathCertificate = true
                        break
                    }else{
                        didMathCertificate = false
                    }
                }
            }
            
            if (isServerTrusted && didMathCertificate) {
                let credential:URLCredential = URLCredential(trust: serverTrust!)
                completionHandler(.useCredential, credential)
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }else{
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust!))
        }
    }
}
