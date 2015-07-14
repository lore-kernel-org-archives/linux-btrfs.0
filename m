Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:36234 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbbGNNZZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 09:25:25 -0400
Received: by ieik3 with SMTP id k3so11072214iei.3
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2015 06:25:25 -0700 (PDT)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.googlemail.com with ESMTPSA id v3sm998251igk.1.2015.07.14.06.25.23
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jul 2015 06:25:24 -0700 (PDT)
Message-ID: <55A50DBF.1080602@gmail.com>
Date: Tue, 14 Jul 2015 09:25:19 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS raid6 unmountable after a couple of days of usage.
References: <55A4F74D.9000305@gmail.com>
In-Reply-To: <55A4F74D.9000305@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030600010403030604080203"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030600010403030604080203
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-14 07:49, Austin S Hemmelgarn wrote:
> So, after experiencing this same issue multiple times (on almost a doze=
n different kernel versions since 4.0) and ruling out the possibility of =
it being caused by my hardware (or at least, the RAM, SATA controller and=
 disk drives themselves), I've decided to report it here.
>
> The general symptom is that raid6 profile filesystems that I have are w=
orking fine for multiple weeks, until I either reboot or otherwise try to=
 remount them, at which point the system refuses to mount them.
>
> I'm currently using btrfs-progs v4.1 with kernel 4.1.2, although I've b=
een seeing this with versions of both since 4.0.
>
> Output of 'btrfs fi show' for the most recent fs that I had this issue =
with:
>          Label: 'altroot'  uuid: 86eef6b9-febe-4350-a316-4cb00c40bbc5
> 	Total devices 4 FS bytes used 9.70GiB
> 	devid    1 size 24.00GiB used 6.03GiB path /dev/mapper/vg-altroot.0
> 	devid    2 size 24.00GiB used 6.01GiB path /dev/mapper/vg-altroot.1
> 	devid    3 size 24.00GiB used 6.01GiB path /dev/mapper/vg-altroot.2
> 	devid    4 size 24.00GiB used 6.01GiB path /dev/mapper/vg-altroot.3
>
>          btrfs-progs v4.1
>
> Each of the individual LVS that are in the FS is just a flat chunk of s=
pace on a separate disk from the others.
>
> The FS itself passes btrfs check just fine (no reported errors, exit va=
lue of 0), but the kernel refuses to mount it with the message 'open_ctre=
e failed'.
>
> I've run btrfs chunk recover and attached the output from that.
>
> Here's a link to an image from 'btrfs image -c9 -w': https://www.dropbo=
x.com/s/pl7gs305ej65u9q/altroot.btrfs.img?dl=3D0
> (That link will expire in 30 days, let me know if you need access to it=
 beyond that).
>
> The filesystems in question all see relatively light but consistent usa=
ge as targets for receiving daily incremental snapshots for on-system bac=
kups (and because I know someone will mention it, yes, I do have other ba=
ckups of the data, these are just my online backups).
>
Further updates, I just tried mounting the filesystem from the image=20
above again, this time passing device=3D options for each device in the=20
FS, and it seems to be working fine now.  I've tried this with the other =

filesystems however, and they still won't mount.


--------------ms030600010403030604080203
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDcxNDEzMjUxOVowIwYJKoZIhvcNAQkE
MRYEFOcHzZ+KWjQd7seDdosm0kPhRICPMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAJrb5FAV7qnsMfgmNh8iEHH4xqEXcG0YnGT/j704S3k3rfsa
2oA8Njlm2958zza4ygrFWkQIARk8V3yRniwN6mKoPRWnGbkFYx0JzzmZ9OpzjwPP0V2cnxPj
69TQhd9eiiqDeVQ1JxhaqlnJFgwx6qh52nJZWbug1UTEHPw0H/sBIAwERkiqtJM5cVjiQD4J
EJ5RXBMlm+5SojkbnYQx1IHM4jr9Bj8bStZ9E782kUsPkC8V35tM3t19uNkvrMr4bNBW5rRg
74HTNpc3guxXlrk9PqwfleQrimu09NdskfE2I4jSkGEVJNWFWyHNPvlhEg1STRydFmwIoC8I
mTFrNpM7cUesgrTvP9ISB7IsHoRv3Dv/qd3220UxIhfsyM/pQr2W1w3XF0aUqth5s7Z1/Rai
+ci30bPN+IPE0MBGT9/QS452c3vQzvNPEe3IQf9UNvEm5BjUzJwbsaSBE3ySbx3vNwVRuRZk
vIQ4tvIdZNlR/L8X7khrVsG3K9BhEsZskuoQncI1/SbNZzpM498S/+m80EahTzu4S6VePa00
rdajt0JqDuPnninKdBxCZfIU/AI2BmI0rUvOL6q2xLL3Zm6xnRRtNUUbt6XZ6GPM9p9LB2L3
+jlUZUD+KBF6gD8JPkG+vXVxtlexxL+4Opv7MvINIU5aUsvUVtYPx+2Qo0X4AAAAAAAA
--------------ms030600010403030604080203--
