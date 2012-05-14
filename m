From: Brendan Smithyman <smithyman@gmail.com>
Subject: Re: Subdirectory creation on snapshot
Date: Mon, 14 May 2012 10:11:01 -0700
Message-ID: <687632B7-2461-496A-878C-2357B47128CF@gmail.com>
References: <821DC50D-8451-4AD1-8CCA-DE1238D4788B@gmail.com> <20120509165802.GN19331@twin.jikos.cz> <F39B4ABB-65D7-467D-BB57-FD9EBB70F1FB@gmail.com> <20120514120852.GH25501@twin.jikos.cz> <20120514162707.GA24394@twin.jikos.cz>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: multipart/signed; boundary="Apple-Mail=_3C98112C-7E75-40F9-B7C2-EFA37A5C5910"; protocol="application/pkcs7-signature"; micalg=sha1
Cc: linux-btrfs@vger.kernel.org, miaox@cn.fujitsu.com
To: dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120514162707.GA24394@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_3C98112C-7E75-40F9-B7C2-EFA37A5C5910
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On 2012-05-14, at 9:27 AM, David Sterba wrote:

> On Mon, May 14, 2012 at 02:08:52PM +0200, David Sterba wrote:
>> Seems more like a bug, let's narrow down the conditions before we =
look
>> into the code.
>=20
> And already known bug (with a proposed fix, cc'd author):
>=20
> http://www.spinics.net/lists/linux-btrfs/msg15195.html
>=20
> Quoting:
>=20
> # mkfs.btrfs /dev/sda1
> # mount /dev/sda1 /mnt
> # mkdir /mnt/1
> # cd /mnt/1
> # btrfs subvolume snapshot /mnt snap0
> # ll /mnt/1
> total 0
> drwxr-xr-x 1 root root 10 Jun 30 15:01 1
> 			^^^
> # ll /mnt/1/snap0/
> total 0
> drwxr-xr-x 1 root root 10 Jun 30 15:01 1
> 			^^^
> 			It is also 10, but...
> # ll /mnt/1/snap0/1
> total 0
> [None]
> # cd /mnt/1/snap0/1/snap0
> [Enter a unexisted directory successfully]
> ---
>=20
> Though there's a difference, that in your listing the @working (here
> it'd be snap0) is present.
>=20
>=20
> david

Thanks David,

Yes, it's looking similar, but perhaps not identical.  I checked, and =
the "@working" directory inside the new snapshot has inode 2.  The =
phantom directory shows up on ls, and can be removed by rmdir.

However: since I sent the first email, I moved one of the volumes to =
btrfs RAID1 from btrfs single on top of md raid.  I recreated the =
filesystem (mkfs.btrfs -L reaper -m raid1 -d raid1 /dev/sdc1 /dev/sdd1) =
at that time, and restored data from a backup.  The new filesystem is =
not displaying the issues from before; it is now behaving in-line with =
the SSD I mentioned in my first post, which was similarly set up from =
the command line with mkfs.btrfs.

The disks that *are* still showing the subdirectory creation issue were =
both converted from ext4 (using old tools).  So perhaps that's a =
direction to explore.

Thanks for the help.

Cheers,
Brendan=

--Apple-Mail=_3C98112C-7E75-40F9-B7C2-EFA37A5C5910
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
9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMjA1MTQxNzExMDJaMCMGCSqGSIb3
DQEJBDEWBBSIM61HL425xrV04PvBewVyB6OjeDCBpQYJKwYBBAGCNxAEMYGXMIGUMIGMMQswCQYD
VQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwg
Q2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IElu
dGVybWVkaWF0ZSBDbGllbnQgQ0ECAwOPkjCBpwYLKoZIhvcNAQkQAgsxgZeggZQwgYwxCzAJBgNV
BAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBD
ZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1hcnkgSW50
ZXJtZWRpYXRlIENsaWVudCBDQQIDA4+SMA0GCSqGSIb3DQEBAQUABIIBAKpln2D5E3ZqnNouX7Hh
9zpV375wmRfyFwx9D1EhMl7pKJbOohJlYHgL+28zYmsvLdk7y1N+1v5nxynC6OL08gZTfAnQOW+f
/1uQnArJ83ffNh+MljW1SjoFvoItPmhKvcMBdMpcx6aapnqvPxemlBgtJ9FgiQ/mpqLBOV5TLcdc
C9ApIgUEjZip5XGzd7payYxXGR0+KGMlHpfz/cGMI8Jq23h0qie7iGV3DMovvNUaXt503nKzW+/W
r4QvjVniEsSVGDFb1eURki3Z8Irdhgbtlkf3C42lctpJLNHHkP5tq0OuHzQBO34Sj8loO8ElaIrc
0kd+D8aZNODuh/zpd4EAAAAAAAA=

--Apple-Mail=_3C98112C-7E75-40F9-B7C2-EFA37A5C5910--
