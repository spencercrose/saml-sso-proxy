# SAML SSO Configuration settings

If strict is True, then the Python Toolkit will reject unsigned
or unencrypted messages if it expects them to be signed or encrypted.
Also it will reject the messages if the SAML standard is not strictly
followed. Destination, NameId, Conditions ... are validated too.

`"strict": true,`

Enable debug mode (outputs errors).

`"debug": true,`

## Service Provider Data that we are deploying.
- `entityId` Identifier of the SP entity  (must be a URI)
- `assertionConsumerService` Specifies info about where and how the `<AuthnResponse>` message MUST be
returned to the requester, in this case our SP.
 - `url` URL Location where the `<Response>` from the IdP will be returned
 - `binding` SAML protocol binding to be used when returning the `<Response>`
message. OneLogin Toolkit supports this endpoint for the HTTP-POST binding only.
- `singleLogoutService` Specifies info about where and how the `<Logout Request/Response>` message MUST be sent.
 - `url` URL Location where the `<LogoutRequest>` from the IdP will be sent (IdP-initiated logout)
  `<LogoutResponse>` from the IdP will sent (SP-initiated logout, reply)
 - [OPTIONAL] `responseUrl` Only specify if different from url parameter
 - `binding` SAML protocol binding to be used when returning the `<Response>` message. OneLogin Toolkit supports the HTTP-Redirect binding only for this endpoint.
 - Usually X.509 cert and privateKey of the SP are provided by files placed at
 the certs folder. But we can also provide them with the following parameters

```
"sp": {
    "entityId": "https://<sp_domain>/metadata/",
    "assertionConsumerService": {
        "url": "https://<sp_domain>/?acs",
        "binding": "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
    },
    "singleLogoutService": {
        "url": "https://<sp_domain>/?sls",
        "binding": "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"
    },
    "NameIDFormat": "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified",
    "x509cert": "",
    "privateKey": ""
},
```

## Identity Provider Data that we want connected with our SP.

- `entityId` Identifier of the IdP entity  (must be a URI)
- `singleSignOnService` SSO endpoint info of the IdP. (Authentication Request protocol)
 - `url` URL Target of the IdP where the Authentication Request Message
 will be sent.
 - `binding` SAML protocol binding to be used when returning the `<Response>`
 message. OneLogin Toolkit supports the HTTP-Redirect binding
 only for this endpoint.
- `singleLogoutService` SLO endpoint info of the IdP.
will be sent.
 - `url` URL Location where the <LogoutResponse> from the IdP will sent (SP-initiated logout, reply)
  - [OPTIONAL] `responseUrl` Only specify if different from url parameter
 - `binding` SAML protocol binding to be used when returning the `<Response>`
 message. OneLogin Toolkit supports the HTTP-Redirect binding
 only for this endpoint.
- `x509cert` Public X.509 certificate of the IdP

```
"idp": {
    "entityId": "<IdP Metadata URI>",
    "singleSignOnService": {
        "url": "<IdP Login URI>",
        "binding": "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"
    },
    "singleLogoutService": {
        "url": "<IdP Logout URI>",
        "binding": "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"
    },
    "x509cert": ""
}
```

Instead of using the whole X.509cert you can use a fingerprint in order to
validate a SAMLResponse (but you still need the X.509cert to validate LogoutRequest and LogoutResponse using the HTTP-Redirect binding).

But take in mind that the algortithm for the fingerprint should be as strong as the algorithm in a normal certificate signature (e.g. SHA256 or strong)

If a fingerprint is provided, then the certFingerprintAlgorithm is required in order to
let the toolkit know which algorithm was used. Possible values: sha1, sha256, sha384 or sha512 'sha1' is the default value.

Notice that if you want to validate any SAML Message sent by the HTTP-Redirect binding, you will need to provide the whole X.509cert.

In some scenarios the IdP uses different certificates for
signing/encryption, or is under key rollover phase and
more than one certificate is published on IdP metadata.
In order to handle that the toolkit offers that parameter.
(when used, 'X.509cert' and 'certFingerprint' values are
ignored).
