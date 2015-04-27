Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35440 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbbD0LrF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 07:47:05 -0400
Received: by igbyr2 with SMTP id yr2so60010257igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 04:47:05 -0700 (PDT)
Message-ID: <553E21B7.2030808@gmail.com>
Date: Mon, 27 Apr 2015 07:47:03 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>,
        "'linux-btrfs@vger.kernel.org'" <linux-btrfs@vger.kernel.org>
Subject: Re: rollback of a snapshot is just read-only
References: <15785B7E063D464C86DD482FCAE4EBA501CAC3EF69DB@XCH11.scidom.de>
In-Reply-To: <15785B7E063D464C86DD482FCAE4EBA501CAC3EF69DB@XCH11.scidom.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080400030404060207010308"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080400030404060207010308
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-04-24 10:26, Lentes, Bernd wrote:
> Hi,
>
> it should be just a small problem, but it is one. How can I rollback to=
 a snapshot of my root filesystem ?
> Googeling, I found a lot of solutions, each different.
> I finally choosed this one: https://btrfs.wiki.kernel.org/index.php/Use=
Cases#I_want_to_be_able_to_do_rollbacks_with_Btrfs
>
> I made the snapshot, changed some configuration, and afterwards I'd lik=
e to rollback to the snapshot:
>
> - btrfs subvolume snapshot -r  /  /.snapshots/vor_nvidia
>
> - change some configuration
>
> - btrfs subvolume set-default 625 (id of the snapshot)
>
> - reboot
>
> My /-folder is again the old one, that's ok. The change of the configur=
ation has disappeared. But it is just read-only:
> pc63422:~ # touch /test
> touch: cannot touch '/test': Read-only file system
>
> mount says:
>
> ...
> /dev/sda1 on /  type btrfs (rw,ssd,space_cache)
> ...
>
> It seems to be rw !?
>
> OS: SLES 12 64bit
> kernel: 3.12.38-44-default
>
> pc63422:~ # rpm -qa|grep -i btrfs
> btrfsprogs-3.16.2-7.1.x86_64
> libbtrfs0-3.16.2-7.1.x86_64
> btrfsmaintenance-0.1-7.1.noarch
>
> pc63422:~ # btrfs --version
> Btrfs v3.16.2+20150127
>
> pc63422:~ # btrfs fi show
> Label: none  uuid: 7edcb64a-4ca6-47ec-8979-54e158c96ac2
>          Total devices 1 FS bytes used 145.19GiB
>          devid    1 size 450.00GiB used 150.04GiB path /dev/sda1
>
> pc63422:~ # btrfs fi df /
> Data, single: total=3D146.01GiB, used=3D142.74GiB
> System, single: total=3D32.00MiB, used=3D16.00KiB
> Metadata, single: total=3D4.00GiB, used=3D2.44GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>
> Thanks for any hint.
>
>
So, a snapshot being read-only is totally different from the FS being=20
mounted read-only.  There is a special property on the snapshot that=20
determines whether it is read-only or writable, which is first set when=20
the snapshot is created.  To change that property so that the snapshot=20
is writable, you can use the following command from the top directory of =

the snapshot:
     btrfs property set . ro false



--------------ms080400030404060207010308
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDQyNzExNDcwM1owIwYJKoZIhvcNAQkE
MRYEFBeBw0txQlo/sYfEiT6TLa7Q+BFJMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAEY2gmywC7S5ZJnLyb+OCD624ynn3ov8Q7XDEphhTniZ0pjw
xd3XoMUGfgi6h8ZELJnP3RaIyQziCxHmVLp2tc5AXfW82pHI9k/1yeCCRVsXvF/tcxUaEC+/
nWmplNNRQYePuqmzaRr2kwynHReO7bkfu+W6j1upxruWXqW+2T06wFOQaTPXDRvV6vJjg89p
2P+BycJdqnN0/BzDYePTMJ847xGJgc9KdTU52rG5DGxZ19uFw/8+3NcwvS/CFQWVhK59CoGo
BEqMxY61fMkzXZ3/PvxXnr+8k9dnUKRTt/HD+Bib8j3caLWY6jK14dPdDbSpHfmPAffzp+32
JeZoi2Tik2A3cL1uvhCX3G6i/Xy5H9SVxGtIunHkCjK+oRohTLZtt5L+LjBFzYv5opBm82yk
YA9weTBoMxZzB7s1oGGHkt/Fewejdxg16ZVEqKU9Dsx6XIlFkGvGu8vJi6X17ZAdQxePOdJD
Y62wsOniMrRqSMF8RHlbPWCIByMiNjjN7h7FsFfwNFSEGP1kNSZmuahli6Q+90jmeDQOnqIj
gnPY7qqAt5ziQZ24iOo2T2CgGbdgKcCEaMUhM0Mg6PowzUeiFf1kGeF4UlfR/5lYioF9vPOL
0YTn4frOJjNJBJstgZY7NyQZkco4qarPWF7IMoVBNmxDcbPQ/ziwlbXyiyLxAAAAAAAA
--------------ms080400030404060207010308--
