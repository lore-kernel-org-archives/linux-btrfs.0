From: Brendan Smithyman <smithyman@gmail.com>
Subject: Re: Subdirectory creation on snapshot
Date: Wed, 9 May 2012 10:38:30 -0700
Message-ID: <F39B4ABB-65D7-467D-BB57-FD9EBB70F1FB@gmail.com>
References: <821DC50D-8451-4AD1-8CCA-DE1238D4788B@gmail.com> <20120509165802.GN19331@twin.jikos.cz>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: multipart/signed; boundary="Apple-Mail=_89886E83-FD93-454D-B1B5-303C6AFB5F90"; protocol="application/pkcs7-signature"; micalg=sha1
Cc: linux-btrfs@vger.kernel.org
To: dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120509165802.GN19331@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_89886E83-FD93-454D-B1B5-303C6AFB5F90
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Thanks David,

If I understand you correctly, this would be the case with nested =
subvolumes; i.e., if subvolume A is exists within the directory tree =
subvolume B, and B is snapshotted.  I expected this, and it sounds =
totally consistent with my understanding of how btrfs subvolumes work.  =
However, the behaviour I'm seeing seems to be a different thing, so I =
just want to double-check:

In my case I am executing the "btrfs subvolume snapshot @working =
newsnapshot" command (or something like it).  The "@working" subvolume =
exists in the filesystem root, and does not contain any other subvolumes =
within its own subdirectory tree.  In the new subvolume, "newsnapshot", =
there is an entry called "@working" that is identified as inode number 2 =
as you say.  But this isn't due to a subvolume in the directory tree of =
the original "@working", since it still happens, e.g., if it is the only =
subvolume on the system (apart from the root, of course).

The naive assumption is that (excepting nested subvolumes), the snapshot =
should be indistinguishable from the original.  Additionally, I'm a bit =
perplexed by the behaviour on some of my volumes and not others.  It's =
not a big deal, and I'm happy to take your word for it (or look at the =
code, if you'd be willing to point me in the right direction; I'm not =
averse to learning).  I just wanted to double-check that we're talking =
about the same thing.

I appreciate the help!

Cheers,
Brendan

On 2012-05-09, at 9:58 AM, David Sterba wrote:

> On Mon, May 07, 2012 at 05:10:08PM -0700, Brendan Smithyman wrote:
>> I'm experiencing some odd-seeming behaviour with btrfs on Ubuntu
>> 12.04, using the Ubuntu x86-64 generic 3.2.0-24 kernel and =
btrfs-tools
>> 0.19+20120328-1~precise1 (backported from the current Debian version
>> using Ubuntu's backportpackage).  When I snapshot a subvolume on some
>> of my drives, it creates an empty directory inside the snapshot with
>> the same name as the original subvolume.  Example case and details
>> below:
>=20
> This is known and it's not a problem, though I was surprised when I =
had
> first seen it myself. Snapshotting is not recursive, the case of
> file->file, directory->directory is straightforward, and when a
> subvolume is encountered, a new file sub-type is created, it's
> identified by BTRFS_EMPTY_SUBVOL_DIR_OBJECTID internally, so it's a =
kind
> of a "stub" subvolume.  It is identified by inode number 2 in stat
> output. The object cannot be modified and just sits there.
>=20
>=20
> david


--Apple-Mail=_89886E83-FD93-454D-B1B5-303C6AFB5F90
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIINUzCCBjQw
ggQcoAMCAQICAR4wDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0
Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxKTAn
BgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3MTAyNDIxMDE1NVoX
DTE3MTAyNDIxMDE1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSsw
KQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFy
dENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAMcJg8zOLdgasSmkLhOrlr6KMoOMpohBllVHrdRvEg/q6r8jR+EK
75xCGhR8ToREoqe7zM9/UnC6TS2y9UKTpT1v7RSMzR0t6ndl0TWBuUr/UXBhPk+Kmy7bI4yW4urC
+y7P3/1/X7U8ocb8VpH/Clt+4iq7nirMcNh6qJR+xjOhV+VHzQMALuGYn5KZmc1NbJQYclsGkDxD
z2UbFqE2+6vIZoL+jb9x4Pa5gNf1TwSDkOkikZB1xtB4ZqtXThaABSONdfmv/Z1pua3FYxnCFmdr
/+N2JLKutIxMYqQOJebr/f/h5t95m4JgrM3Y/w7YX9d7YAL9jvN4SydHsU6n65cCAwEAAaOCAa0w
ggGpMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRTcu2SnODaywFc
fH6WNU7y1LhRgjAfBgNVHSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRa
MFgwJwYIKwYBBQUHMAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYh
aHR0cDovL3d3dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5j
b20vc2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBAAqDCH14qywG
XLhjjF6uHLkjd02hcdh9hrw+VUsv+q1eeQWB21jWj3kJ96AUlPCoEGZ/ynJNScWy6QMVQjbbMXlt
UfO4n4bGGdKo3awPWp61tjAFgraLJgDk+DsSvUD6EowjMTNx25GQgyYJ5RPIzKKR9tQW8gGK+2+R
HxkUCTbYFnL6kl8Ch507rUdPPipJ9CgJFws3kDS3gOS5WFMxcjO5DwKfKSETEPrHh7p5shuuNktv
sv6hxHTLhiMKX893gxdT3XLS9OKmCv87vkINQcNEcIIoFWbP9HORz9v3vQwR4e3ksLc2JZOAFK+s
sS5XMEoznzpihEP0PLc4dCBYjbvSD7kxgDwZ+Aj8Q9PkbvE9sIPP7ON0fz095HdThKjiVJe6vofq
+n6b1NBc8XdrQvBmunwxD5nvtTW4vtN6VY7mUCmxsCieuoBJ9OlqmsVWQvifIYf40dJPZkk9YgGT
zWLpXDSfLSplbY2LL9C9U0ptvjcDjefLTvqSFc7tw1sEhF0n/qpA2r0GpvkLRDmcSwVyPvmjFBGq
Up/pNy8ZuPGQmHwFi2/14+xeSUDG2bwnsYJQG2EdJCB6luQ57GEnTA/yKZSTKI8dDQa8Sd3zfXb1
9mOgSF0bBdXbuKhEpuP9wirslFe6fQ1t5j5R0xi72MZ8ikMu1RQZKCyDbMwazlHiMIIHFzCCBf+g
AwIBAgIDA4+SMA0GCSqGSIb3DQEBBQUAMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRD
b20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYG
A1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcN
MTIwMTE4MjIwMzAzWhcNMTMwMTE4MDc1MTM0WjBdMRkwFwYDVQQNExBHRHd3NWp2dWU4dzJrOXBS
MRwwGgYDVQQDDBNzbWl0aHltYW5AZ21haWwuY29tMSIwIAYJKoZIhvcNAQkBFhNzbWl0aHltYW5A
Z21haWwuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzRO+LZl4dkRGVIC4CtCu
gB3JCKCB4jPJQUXIlvpA7xxF+VAl/PIyO7vbehBshp4vao/qtGKzVQsRkboour3sxPE154xQ+jfF
E6xQFLkXIWXZ9iw0sTzDL7JFKBaS8vqQhFQ5cFLJZQ2BI79jOmn7f4U1he53uICPpFJebuOVppex
NM8y4DRY1muqYkd7/vNP813VrZRVA07iWv5w+TlCks7I8hVrkwDLE3m/DSDmD7W+/2TfnrkomeZI
qFp5aTk47NvC8Ho/Zwm0dwstPp2dbl2mg6RMQqrxPlGva64kASk9wUytxxg01vks4m0OqA3aeRPd
/ASHd86YjFy2SNZ5SQIDAQABo4IDrjCCA6owCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQWBBRE9wJXgf1w2DAZBrWX6mI5sRzBoTAf
BgNVHSMEGDAWgBRTcu2SnODaywFcfH6WNU7y1LhRgjAeBgNVHREEFzAVgRNzbWl0aHltYW5AZ21h
aWwuY29tMIICIQYDVR0gBIICGDCCAhQwggIQBgsrBgEEAYG1NwECAjCCAf8wLgYIKwYBBQUHAgEW
Imh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwgfcGCCsGAQUFBwICMIHqMCcWIFN0YXJ0
Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MAMCAQEagb5UaGlzIGNlcnRpZmljYXRlIHdhcyBp
c3N1ZWQgYWNjb3JkaW5nIHRvIHRoZSBDbGFzcyAxIFZhbGlkYXRpb24gcmVxdWlyZW1lbnRzIG9m
IHRoZSBTdGFydENvbSBDQSBwb2xpY3ksIHJlbGlhbmNlIG9ubHkgZm9yIHRoZSBpbnRlbmRlZCBw
dXJwb3NlIGluIGNvbXBsaWFuY2Ugb2YgdGhlIHJlbHlpbmcgcGFydHkgb2JsaWdhdGlvbnMuMIGc
BggrBgEFBQcCAjCBjzAnFiBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTADAgECGmRM
aWFiaWxpdHkgYW5kIHdhcnJhbnRpZXMgYXJlIGxpbWl0ZWQhIFNlZSBzZWN0aW9uICJMZWdhbCBh
bmQgTGltaXRhdGlvbnMiIG9mIHRoZSBTdGFydENvbSBDQSBwb2xpY3kuMDYGA1UdHwQvMC0wK6Ap
oCeGJWh0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL2NydHUxLWNybC5jcmwwgY4GCCsGAQUFBwEBBIGB
MH8wOQYIKwYBBQUHMAGGLWh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9zdWIvY2xhc3MxL2NsaWVu
dC9jYTBCBggrBgEFBQcwAoY2aHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2VydHMvc3ViLmNsYXNz
MS5jbGllbnQuY2EuY3J0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tLzANBgkq
hkiG9w0BAQUFAAOCAQEASzwE73jDGNk8fdRJCmF9k5LMY1a+EvFqwwXC1oRBt82N9wu5UvNkRzIp
0/qnJJiwbvQ+4fZvEY0oA85S9esPz9wpG9DdAgs5VpTlsp6m9wEgGC5ITFqhI67vEU5DJ15smFfh
trexNWdd54irRmOeRpfhA5shz7ZhVXD68eP+AaWcaxP+UOWvcapy3FpYvmIqWK4HkL9qgOIrOF1b
AJtT71+gAFJmN2wfUNk8HufzQ51MQIkD/NN/fW40hu16sLkGM46YlnayNZarWE3iMg5CAv+dI54G
hsgBfl2VVH/dw6OHKw9jp97D46gHhE8HTwb3xC++47+CGwCVuyMeiKalpjGCA28wggNrAgEBMIGU
MIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJl
IERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQ
cmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAwOPkjAJBgUrDgMCGgUAoIIBrzAYBgkqhkiG
9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMjA1MDkxNzM4MzBaMCMGCSqGSIb3
DQEJBDEWBBQ1hWGjo84upHmguJpelSv2ybuCZjCBpQYJKwYBBAGCNxAEMYGXMIGUMIGMMQswCQYD
VQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwg
Q2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IElu
dGVybWVkaWF0ZSBDbGllbnQgQ0ECAwOPkjCBpwYLKoZIhvcNAQkQAgsxgZeggZQwgYwxCzAJBgNV
BAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBD
ZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1hcnkgSW50
ZXJtZWRpYXRlIENsaWVudCBDQQIDA4+SMA0GCSqGSIb3DQEBAQUABIIBALkSA8RKZm3moVVYy849
GrREWe8qFr+8h9vXOvCIvX7eL3XJs1oS7kEu2T3CfD+n74oZKBV0zRWpyKeMtuv1glUVhZRe3kHw
psGn5kBXO0GB6gHePVPvWKl9y2jkeYrn+oROK9kjUw2SEVWuvWjAcMwXR20T3UJgk/RZrEITGcti
kko5nXZZd9rDhybX1XTb/UDK7nFCXOJk67/kejBa9837zD9FcTFi4Ugv/WahmGWLwmxBDARX3VAw
5ejGNJafMgjXjGabq5S/zT/elDWITVkh1cFAwH/FUQeyzLS/160Ra5rvwNp7hxbgJKEKDV/g8C2T
2qE2S1R0+NIiwLJ2CssAAAAAAAA=

--Apple-Mail=_89886E83-FD93-454D-B1B5-303C6AFB5F90--
