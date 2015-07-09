Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:38472 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbbGIMHv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 08:07:51 -0400
Received: by igrv9 with SMTP id v9so191600764igr.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 05:07:51 -0700 (PDT)
Message-ID: <559E6411.6090109@gmail.com>
Date: Thu, 09 Jul 2015 08:07:45 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: "Fajar A. Nugraha" <list@fajar.net>,
        james harvey <jamespharvey20@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs subvolume clone or fork (btrfs-progs feature request)
References: <CA+X5Wn4YoAByr=OMHHmS5X86iCJos4O=AbwFuy+iH=OrKmVhNg@mail.gmail.com> <CAG1y0scpWEF=590bM6dxkOZLAtCMwZaPCtHRuQjTT5DMu5ATrQ@mail.gmail.com>
In-Reply-To: <CAG1y0scpWEF=590bM6dxkOZLAtCMwZaPCtHRuQjTT5DMu5ATrQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090709090908030305060607"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090709090908030305060607
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-09 02:22, Fajar A. Nugraha wrote:
> On Thu, Jul 9, 2015 at 8:20 AM, james harvey <jamespharvey20@gmail.com>=
 wrote:
>> Request for new btrfs subvolume subcommand:
>>
>> clone or fork [-i <qgroupid] <source> [<dest>]<name>
>>     Create a subvolume <name> in <dest>, which is a clone or fork of s=
ource.
>>     If <dest> is not given, subvolume <name> will be created in the
>> current directory.
>>     Options
>>     -i <qgroupid>
>>        Add the newly created subvolume to a qgroup.  This option can b=
e
>> given multiple times.
>>
>> Would (I think):
>> * btrfs subvolume create <dest-subvolume>
>> * cp -ax --reflink=3Dalways <source-subvolume>/* <dest-subvolume>/
>
> What's wrong with "btrfs subvolume snapshot"?
>
Well, personally I would say the fact that once something is tagged as a =

snapshot, you can't change it to a regular subvolume without doing a=20
non-incremental send/receive.


--------------ms090709090908030305060607
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAxBuVTANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNTAz
MjUxOTM0MzhaFw0xNTA5MjExOTM0MzhaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCdD/zW
2rRAFCLnDfXpWxU1+ODqRVUgzHvrRO7ADUxRo1CBDc3JSX5TIW2OGmQ3DAKGOACp8Z0sgxMc
B05tzAZ/M7m4jajVrwwdVCdrwVGxTdAai7Kwg4ZCVfyMVhcwo8R2eW3QahBx34G0RKumK9sZ
ZQSQ+zULAzpY6uz7T1sAk/erMoivRXF6u8WvOsLkOD1F/Xyv1ZccSUG5YeDgZgc0nZUBvyIp
zXSHjgWerFkrxEM3y2z/Ff3eL1sgGYecV/I1F+I5S01V7Kclt/qRW10c/4JEGRcI1FmrJBPu
BtMYPbg/3Y9LZROYN+mVIFxZxOfrmjfFZ96xt/TaMXo8vcEKtWcNEjhGBjEbfMUEm4aq8ygQ
4MuEcpJc8DJCHBkg2KBk13DkbU2qNepTD6Uip1C+g+KMr0nd6KOJqSH27ZuNY4xqV4hIxFHp
ex0zY7mq6fV2o6sKBGQzRdI20FDYmNjsLJwjH6qJ8laxFphZnPRpBThmu0AjuBWE72GnI1oA
aO+bs92MQGJernt7hByCnDO82W/ykbVz+Ge3Sax8NY0m2Xdvp6WFDY/PjD9CdaJ9nwQGsUSa
N54lrZ2qMTeCI9Vauwf6U69BA42xgk65VvxvTNqji+tZ4aZbarZ7el2/QDHOb/rRwlCFplS/
z4l1f1nOrE6bnDl5RBJyW3zi74P6GwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAGvl7xb42JMRH5D/vCIDYvFY3dR2FPd5kmOqpKU/fvQ8ovmJa
p5N/FDrsCL+YdslxPY+AAn78PYmL5pFHTdRadT++07DPIMtQyy2qd+XRmz6zP8Il7vGcEDmO
WmMLYMq4xV9s/N7t7JJp6ftdIYUcoTVChUgilDaRWMLidtslCdRsBVfUjPb1bF5Ua31diKDP
e0M9/e2CU36rbcTtiNCXhptMigzuL3zJXUf2B9jyUV8pnqNEQH36fqJ7YTBLcpq3aYa2XbAH
Hgx9GehJBIqwspDmhPCFZ/QmqUXCkt+XfvinQ2NzKR6P3+OdYbwqzVX8BdMeojh7Ig8x/nIx
mQ+/ufstL1ZYp0bg13fyK/hPYSIBpayaC76vzWovkIm70DIDRIFLi20p/qTd7rfDYy831Hjm
+lDdCECF9bIXEWFk33kA97dgQIMbf5chEmlFg8S0e4iw7LMjvRqMX3eCD8GJ2+oqyZUwzZxy
S0Mx+rBld5rrN7LsXwZ671HsGqNeYbYeU25e7t7/Gcc6Bd/kPfA+adEuUGFcvUKH3trDYqNq
6mOkAd8WO/mQadlc3ztS++XDMhmIpfBre9MPAr6usqf+wc+R8Nk9KLK39kEgrqVfzc/fgf8L
MaD4rHnusdg4gca6Yi+kNrm99anw7SwaBrBvULYBp7ixNRUhaYiNW4YjTrYxggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5VMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDcwOTEyMDc0NVowIwYJKoZIhvcNAQkE
MRYEFIcWQZQBDxoPqhXLMbEam8vQ6PBVMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAI0lavDsPzwONp9j0F9OA/yrJ1VZakIF1eA1vRJXyn49Vlwx
2b9zberJAsaUVpa/dotJFQjxtXoNzeoJ+m8dBP2xva2w58BOfY6aIeujsPprpTNeQP+I0pbU
/SvYIHt8A+i6zmwgXJscZDrvGx50AdlFKf6bpF5wDR3nuvVMYG9ZEtDqDv6vMbgkhXqZP8gL
0bb6XRTEyBI6rbRhcMJ33oigGAOHWYjujTZd3VIrEazU8r+4Z7JSR1G2GSEzUCEkbmcdT5Kg
YgckeG0s050U7uVv7Vnt+JQYYDMbREmFeALjXAZY6YQivhCTQOWfwpbitRSvjnW8GGuPXuUF
KkIRDWYh5Fo1vnt5n3P07bNYoml/UJipwVjJp7O06gLPrBFoQ6qHYQDayvBUaFGey/DglBtb
NIRwKrCFlA/6zDfO1wDUXLeYt3Kx8UYTnWoc020PWF3E6RpXLwh9lZnhdgmFppsGm/p3+9nU
DaRton0uRJC0K3UAauYIXWfuEanrW2XqmxhUC2O8pE3kmOkLY/U/fDHyOHY0eyyjZdK01imi
njs1B8WPNjxd0oqRjP0h4OvDpvin3h0+O/9PSSgpYvhyZrS9dvX78ytQPB+FFdWIoUlhcdWr
S9yJIkxbaQohX/JxTj7ifpfQQM8XFN/35ULq7BY5D77w4uMt3ZyCRkp/qrcPAAAAAAAA
--------------ms090709090908030305060607--
