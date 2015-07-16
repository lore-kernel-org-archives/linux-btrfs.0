Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:35094 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbbGPLlW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jul 2015 07:41:22 -0400
Received: by iecuq6 with SMTP id uq6so53773697iec.2
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2015 04:41:22 -0700 (PDT)
Message-ID: <55A79854.6020309@gmail.com>
Date: Thu, 16 Jul 2015 07:41:08 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS raid6 unmountable after a couple of days of usage.
References: <55A4F74D.9000305@gmail.com>	<55A50DBF.1080602@gmail.com>	<CAJCQCtSEk3cfwWTyzzQft1+eHcUDm_zFiBpYZM15rhZBzF3U2A@mail.gmail.com>	<55A63F03.2080207@gmail.com>	<CAJCQCtRWSvHtH0rjn2twd3yOPFMECE--UJxTUO0r_ydXQ7AhRQ@mail.gmail.com>	<20150715161546.GR10539@carfax.org.uk> <CAJCQCtQFBjbuBHXfZ831YAKQwNDh+kxugFE_iMW6VyRzSpio2Q@mail.gmail.com>
In-Reply-To: <CAJCQCtQFBjbuBHXfZ831YAKQwNDh+kxugFE_iMW6VyRzSpio2Q@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050004090008000303090404"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050004090008000303090404
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-15 17:29, Chris Murphy wrote:
> On Wed, Jul 15, 2015 at 10:15 AM, Hugo Mills <hugo@carfax.org.uk> wrote=
:
>
>>     There is at least one superblock on every device, usually two, and=

>> often three. Each superblock contains the virtual address of the roots=

>> of the root tree, the chunk tree and the log tree. Those are useless
>> without having the chunk tree, so there's also some information about
>> the chunk tree appended to the end of each superblock to bootstrap the=

>> virtual address space lookup.
>
> So maybe Austin can use btrfs-show-super -a on every device and see if
> there's anything different on some of the devices, that shouldn't be
> different? There must be something the kernel is tripping over that
> the use space tools aren't for some reason.
>
>
>
>
I actually did do so when this happened most recently (I just didn't=20
think to mention it in the most recent e-mail), and nothing appeared to=20
be different either between devices or within a given device (IIRC,=20
there's 2 sb per device in each of the filesystems in question).

I'm going to try and reproduce this in a VM for inspection as all the=20
filesystems I had this issue with now seem to be working fine (with the=20
exception of some errors in the data blocks of one that got caught by=20
scrub).


--------------ms050004090008000303090404
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDcxNjExNDEwOFowIwYJKoZIhvcNAQkE
MRYEFAFPk7mfbWREFyy04U85Hf2QhQ+HMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAI8AS55LADUwKu+7zOghFrvj7sJLykpDgXHb9MrosJwHxytF
7G7eT9GyvyvkLG99/jlzUtKlpW+zb4G+7VP7UoA/j8pbDehnT6CSEWRQP+FCTyhwZcq9HpqZ
fnlKSgdafZ8dye6s+vGj6u1GIt+4YToaKtufWoZumC28AsHvjFtm9OvUtyp0is/jLwAJgfUZ
fAhcpBybE5VnM9Q06v5eMnUvOwmIMgsCkpmtlTdn9b4nZBnQDPhTeKKpNIBplJoppZoUn05+
leCQ6CHTLmmcr5bGvxr2585zwofDH3YZvPCHSqf5S4mtyTXG0IvBZS8MVgFPFEeJq8Xwp8/W
dgl2USZN0hrTjQ73oNpHxhOTN44qmvSObF9TjBPGbfz6U1rwboCiS+t9kFAFCu8gq3kKJN0I
WK/FLlp76fsZkmDvOah/1O/CLrUUAR6MZ62SeozxE4MVlZn7dmMFBTqMt4uDEeHQbUCPrS64
Kr8Wqj6ProudEKCwVtr4irpeLnHsbIusIdUiUbu3IpBGAuD2EEH+uy24ZvzAOMDyvkq1AIUE
5sceychnxNVa5yuNaxNo6PWiYv5tw14XA2iFIHaoAuaWjDkwuR+d6Etx3szNW7i89gmwp/+C
SCl8tGboTc8CPvSE2Uh5ONtnMnEJMHia/kE4+vew3bELwc/oy8atQYNpBuqFAAAAAAAA
--------------ms050004090008000303090404--
