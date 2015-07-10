Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34275 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbbGJNg7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 09:36:59 -0400
Received: by igoe12 with SMTP id e12so35320348igo.1
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jul 2015 06:36:58 -0700 (PDT)
Message-ID: <559FCA6D.8020800@gmail.com>
Date: Fri, 10 Jul 2015 09:36:45 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: dsterba@suse.cz, sander@humilis.net, "Fajar A. Nugraha" <list@fajar.net>,
        james harvey <jamespharvey20@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs subvolume clone or fork (btrfs-progs feature request)
References: <CA+X5Wn4YoAByr=OMHHmS5X86iCJos4O=AbwFuy+iH=OrKmVhNg@mail.gmail.com> <CAG1y0scpWEF=590bM6dxkOZLAtCMwZaPCtHRuQjTT5DMu5ATrQ@mail.gmail.com> <559E6411.6090109@gmail.com> <20150709124121.GA25033@panda> <559E6D80.7010607@gmail.com> <20150709183355.GA726@twin.jikos.cz>
In-Reply-To: <20150709183355.GA726@twin.jikos.cz>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000802080005070104050407"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000802080005070104050407
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-09 14:33, David Sterba wrote:
> On Thu, Jul 09, 2015 at 08:48:00AM -0400, Austin S Hemmelgarn wrote:
>> On 2015-07-09 08:41, Sander wrote:
>>> Austin S Hemmelgarn wrote (ao):
>>>>> What's wrong with "btrfs subvolume snapshot"?
>>>>
>>>> Well, personally I would say the fact that once something is tagged =
as
>>>> a snapshot, you can't change it to a regular subvolume without doing=
 a
>>>> non-incremental send/receive.
>>>
>>> A snapshot is a subvolume. There is no such thing as "tagged as a
>>> snapshot".
>>>
>> No, there is a bit in the subvolume metadata that says whether it's
>> considered a snapshot or not.
>
> Technically it's not really a bit. The snapshot relation is determined
> by the parent uuid value of a subvolume.
I'm actually kind of curious, is the parent UUID actually used for=20
anything outside of send/receive?
>
>> Internally, they are handled identically,
>> but it does come into play when you consider things like btrfs subvolu=
me
>> show -s (which only lists snapshots),
>
> That was probably 'btrfs subvol list -s', though the 'subvol show'
> command prints all snapshots of a given subvolume.
You're right, I just have a tendency to get the two confused because my=20
workflow means that I don't use either very frequently.
>
>> which in turn means that certain
>> tasks are more difficult to script robustly.
>
> I don't deny the interface/output is imperfect for scripting purposes,
> maybe we can provide filters that would satisfy your usecase.
>
Personally, I don't really do much direct scripting of BTRFS related=20
tasks (although that might change if I can convince my boss that we=20
should move to BTRFS for our server systems).  Most of my complaint with =

the current arrangement is primarily aesthetic more than anything else.


--------------ms000802080005070104050407
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDcxMDEzMzY0NVowIwYJKoZIhvcNAQkE
MRYEFAL7xVqI39InPLjYTEa2QmMCqVcOMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAHTPZ0kauoI/FYsumwAIklcnTeer1Bq8d12WEUFnm+ImVAV0
C7YPyEy0GR3t6XHyQJHYrM8JS7bnTWx71xsl1+pnaMujtd879vF+ztaSF3cN5PLX1usSo+y8
cLYXLHuUuGSUmxXhvDdP8/hrnNk6d6CdhCxApPPKv4UdRBLlp4AhPNzIBqGnxFpXmnod1vQi
twY6pSnM/qpRFZbBxdxLi5XpVZ6/aPTMGcCbWELTn6mvaUnudkwCeLEVsj5baACiSunkZ4v9
nNLTW768du5N8M0XBoy6Q0eFvlOVKOwWmvJpGGqmvTl2SbloUNn7GhJhtBKHByHA81Qb12iM
ISy4xis+75idljTJynC3vagj0lT7YM2U8pcCbznAJ+b5h0HP7MZqjN6/4FzLXRT4+7pFicuF
n1C4VFW+4J8RscZlqJ8g0uI6kOj9JZz70FgiBXg4D+aO3wp7NdwMDpeQ5WWRXoZISd2IZDr1
DMX9acnYLkp/sFNaQ3d9C+4La/grRrPzL1XWq9Rw6zZEy21PJGHxhmv9VLItlPQEKEOup9Ax
nVgj1ogWZhX4AS1KRPeI8d0ijrQ3P21pTJ1UHSP7smErTBr16QsV8PtVNLKjUrnoxkE3WfX2
lBDVbH2idVLSiXfliwCtzVz5LPiL6nwvM/sljokBQkHBN69CKNDcKj7ENOx6AAAAAAAA
--------------ms000802080005070104050407--
