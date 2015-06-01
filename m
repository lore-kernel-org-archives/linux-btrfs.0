Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34124 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbFAOJl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 10:09:41 -0400
Received: by oifu123 with SMTP id u123so102125289oif.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 07:09:41 -0700 (PDT)
Message-ID: <556C679A.4050000@gmail.com>
Date: Mon, 01 Jun 2015 10:09:30 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Neal Becker <ndbecker2@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [newb] move /home to subvolume
References: <mkhjkp$hgl$1@ger.gmane.org> <CAO5K3OfGP6SxK0Ch9XSu1dGZgjEx8G7-b19+2m0tGHzpjY++Zg@mail.gmail.com> <mkhl70$fnu$1@ger.gmane.org>
In-Reply-To: <mkhl70$fnu$1@ger.gmane.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020808030507090603020006"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020808030507090603020006
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-06-01 09:03, Neal Becker wrote:
> So I think what I need to do is:
>
> 1. boot off some rescue media
In theory, you may be able to boot do the equivalent of this from single =

user mode or by logging in as root, although it may be safer to do it=20
from rescue media (just make sure the rescue media is relatively up to=20
date).
> 2. mount the target btrfs volume (e.g., /mnt/sysimage/root)
> 3. mv exising home (mv /mnt/sysimage/home /mnt/sysimage/oldhome)
> 4. create new subvolume (btrfs subvolume create /mnt/sysimage/home)
> 5. move all the files from /mnt/sysimage/oldhome /mnt/sysimage/home - n=
ot
> sure easiest way to do this step
I would use either rsync (if you have a lot of free space available on=20
the volume) or 'cp -va --reflink=3Dalways'.
> 6. edit /mnt/sysimage/etc/fstab to mount new /home
>
> I have another machine, setup more or less this way:
> UUID=3D7246327b-1905-4fe2-9b6b-b9376017264f /                       btr=
fs
> subvolid=3D5,subvol=3Droot00 0 0
> UUID=3D2c04be93-34c1-4016-ba41-60fd9fd90616 /boot                   ext=
4
> defaults        1 2
> UUID=3D7246327b-1905-4fe2-9b6b-b9376017264f /home                   btr=
fs
> subvol=3Dhome     0 0



--------------ms020808030507090603020006
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDYwMTE0MDkzMFowIwYJKoZIhvcNAQkE
MRYEFBotziUGXM4UIsFSWrypeMpLVr7hMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAHNwSJ4qIGINUdgNoYq0nWwgkR8ypsVnMihZJVIxckUjgtkV
WQEnYtcJfuyDjaGS9ed/7LqSKQYS4GaXmXm/JpluhyUtxp2M8RUgePkatlDCfzcR4OBMexnH
qbAzX2pRZpL9zvPnJQ/Tk5Oajn/DJ6fr4EyhNeZV7H3E4s32hvuItNFlD6eaYrgsIl1l7AnK
bFp0sCpGRLSoLUwzmFIbghzimAH5VH/IDgL4nYdORO4sm9yOZzm0040s8hrH8jVS7hrSCHk+
PzrGC7SCfbfClHa/CpFXlsA8kmV3wRY2yyWilj9vRiR3hUbB8xBrso6USxo1LJ6EpKNbNhJq
OtdSrzlSK/fNUNxrLky77hymdXqEAV7PVSNnbcoHHZl8KjC4u7IroOwXyFtDai+SxPr8kXEa
6Rbvy8MxIu2GyeSj67uhwu5G6biAx4rVlUiqaHn2wKBW4sKQRQ+HoZe7H8i2clkdgOyBixTk
WJXGtal8uVwYnrbrv8LsUx0qyhyeYcDdQgbsP99KGzhCnhDxe4sxvyRwh8d9QLPK6MwAqETl
0U0jlDpkJBiBd8plgouF0n3xIGqauSEqEa9xFKyl47APWSNOEkG8IFNpBMEaYRS4ATGtdroe
tyGxqkj7U6X/cWIiYwO1X6DxTRP3q2SRz4erjLTAk7XaL/DqbNTlj+suvgLIAAAAAAAA
--------------ms020808030507090603020006--
