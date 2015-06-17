Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:34233 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbbFQLap (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 07:30:45 -0400
Received: by yhnv31 with SMTP id v31so5346236yhn.1
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 04:30:44 -0700 (PDT)
Message-ID: <55815A50.3080309@gmail.com>
Date: Wed, 17 Jun 2015 07:30:24 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Arnaud Kapp <kapp.arno@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Replacing a drive from a RAID 1 array
References: <CAOQP4cG2344VZYT8eZ4=MJzi_KsdzH7pxFJ+ZpOTXtdDOrXRyQ@mail.gmail.com> <20150616165832.GN9850@carfax.org.uk>
In-Reply-To: <20150616165832.GN9850@carfax.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000500090103090804070906"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000500090103090804070906
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-06-16 12:58, Hugo Mills wrote:
> On Tue, Jun 16, 2015 at 06:43:23PM +0200, Arnaud Kapp wrote:
>> Hello,
>>
>> Consider the following situation: I have a RAID 1 array with 4 drives.=

>> I want to replace one the drive by a new one, with greater capacity.
>>
>> However, let's say I only have 4 HDD slots so I cannot plug the new
>> drive, add it to the array then remove the other one.
>> If there a *safe* way to change drives in this situation? I'd bet that=

>> booting with 3drives, adding the new one then removing the old, non
>> connected one would work. However, is there something that could go
>> wrong in this situation?
>
>     The main thing that could go wrong with that is a disk failure. If
> you have the SATA ports available, I'd consider operating the machine
> with the case open and one of the drives bare and resting on something
> stable and insulating for the time it takes to do a "btrfs replace"
> operation.
This would be my first suggestion also; although, if you only have 4=20
SATA ports, you might want to invest in a SATA add in card (if you go=20
this way, look for one with an ASmedia chipset, those are the best I've=20
seen as far as reliability for add on controllers).
>
>     If that's not an option, then a good-quality external USB case with=

> a short cable directly attached to one of the USB ports on the
> motherboard would be a reasonable solution (with the proviso that some
> USB connections are just plain unstable and throw errors, which can
> cause problems with the filesystem code, typically requiring a reboot,
> and a restart of the process).
If you decide to go with this option and are using an Intel system,=20
avoid using USB3.0 ports, as a number of Intel's chipsets have known=20
bugs with their USB3 hardware that will likely cause serious issues.
If your system has an eSATA port however, try to use that instead of=20
USB, it will almost certainly be faster and more reliable.
>
>     You might also consider using either NBD or iSCSI to present one of=

> the disks (I'd probably use the outgoing one) over the network from
> another machine with more slots in it, but that's going to end up with
> horrible performance during the migration.
The other possibility WRT this is ATAoE, which generally gets better=20
performance than NBD or iSCSI but has the caveat that both systems have=20
to be on the same network link (ie, no gateways between them).  If you=20
do decide to use ATAoE< look into a program called 'vblade' (most=20
distro's have it in a package with the same name).


--------------ms000500090103090804070906
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDYxNzExMzAyNFowIwYJKoZIhvcNAQkE
MRYEFKpMDpFkadIDIL3dJahd911hhyYkMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICADU4Zwv28NFzyAin3eBYbru5LKHcoyrOeSNANQUSlvPoymKN
JTx6oEEEdn7lmfwN51Lzr7N9k4I3G4WMXRubFyj7WCFXAOy/zUBlAigKcg+DUoABWNuPRM/H
W9UHRm+BAxpsZhJbmDt1KyFINj/KY8YfCzGbcm2K+zyDN+Ll5snYFpHxBvcKqtjs0vKBEnNl
eseQqWGE65PDiGiXK4wvV5HhwDsucdT5u+zjNts/COIEAe6rSjcakW+J3+Cx5rvSJbZwQG/G
/cflE7u9DiMDxAsrRQUS0ohz0qHAEMvvNoXd0UsMiqI9Fzt9gXxGTUj07zy29yTDXH9rwYy6
O3Hkf8Mtr1EyQQQwqOqJXxSNdW2j2FefeJ52d7ZvnxB1wmqcCvI7KB0T4ZybPI3xMw3AF8fQ
feIyHWQw1xg0z5nrTKw18ZH39bh0HgJrvHvgD9W7Do403xkSorpFZIrGrx8SCO+CwvoVOgOA
5FKfm3iuMFbfnoKnHdTC0VzM+eF4GNuRx9SfShWNPswtBj152OGIMpwZgqQfuhgw7hdPxJLM
cGiiNZECyKhdKyJIXlAk5LQcZQO3ZWTA3hSt5BaW+l3Srz12xL23MqCOouUs5e1k8AykdmOi
15oTt9bZwePjgS6DoRTJg/lOg/WJV2UYhtLunDfAqesjKb5OU4BOrdzFMUE0AAAAAAAA
--------------ms000500090103090804070906--
