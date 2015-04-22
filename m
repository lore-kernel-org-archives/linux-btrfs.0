Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35459 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280AbbDVNyM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 09:54:12 -0400
Received: by iejt8 with SMTP id t8so37606067iej.2
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2015 06:54:11 -0700 (PDT)
Message-ID: <5537A7F6.9040003@gmail.com>
Date: Wed, 22 Apr 2015 09:53:58 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: sri <toyours_sridhar@yahoo.co.in>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs snapshot root level and for subvolumes
References: <loom.20150422T130823-598@post.gmane.org>
In-Reply-To: <loom.20150422T130823-598@post.gmane.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020306010004040609020307"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020306010004040609020307
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-04-22 07:19, sri wrote:
> Hi,
> I btrfs file system created with one device /dev/sdb and mounted under
> /btrfs1.
>
> created one file /btrfs1/errno.h, one directory /btrfs1/dir1 and
> 2 subvolumes /btrfs1/subvol1 and /btrfs/subvol2
>
> create directories and files under subvolume /btrfs1/subvol1.
> Nothing inside /btrfs1/subvol2.
>
> Below is tree representation of the file system.
>
> #cd /btrfs1
> #tree /btrfs1
>   - errno.h
>    -dir1
>       - file1
>       - file2
>    -subvol1
>       -dir1
>         -file1
>       -file2
>
>    -subvol2
>
>
> at root level of /btrfs1, i have one file errno.h, dir1, and 2
> subvolumes subvol1, subvol2.
>
> When I create snapshot for subvol1 (say snap_subvol1), I can able to se=
e
> all files and directories of subvol1 are showed in /btrfs1/snap_subvol1=

>
> But when I create snapshot at btrfs1 level by using below command
> "btrfs subvolume snapshot /btrfs1 /btrfs1/root_snap"
>
> and see contents of /btrfs1/root_snap, I can able to see all root level=

> files and directories but cannot find any files and directories inside
> subvol1.
>
> My question is can't we take btrfs root level snapshot and get snapshot=

> of everything under root file system ??
> Is btrfs subvolume snapshot is only to take subvolume snapshot?
>
> If it so, is there a way to take snapshot at root level? (in this case
> /btrfs1)
>
> I am just confused how subvolume snapshot work in this case.

Because of how subvolumes work on btrfs, snapshots currently stop at=20
subvolume boundaries.  This is an intended behavior to people from=20
shooting themselves in the foot with recursive snapshots stored in the=20
subvolume that is being snapshotted.  As far as I know, there is=20
currently no way to do recursive snapshotting of subvolumes without=20
using some form of scripting.



--------------ms020306010004040609020307
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDQyMjEzNTM1OFowIwYJKoZIhvcNAQkE
MRYEFPc5ITZsEsL6JiX2bBx3T/ttUUBrMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAEtjGY3lUh+S5TUsAFso9KJBg5W0kN6eiIJNFXcTgTWNgdLr
SdsyQNCvWb3QrkpC6I10ZVtzmh7yhx++HAbL/BUAjz9ioIo4RLtu+qAXXG5ehqSGNV/oikyw
3txjMXRLrjkT0s8PQdAfjLoL+KBnqBNqumI4RDAgILxKra/OmIxMkilKrM+pMqeQI8m4VHp1
cygtUOTbY2EzfQQOf40kcmTqAVYTmksZ9W48M0zgmFPjsKyP0nlELgsZcwRDe0boZH7CzY8/
RBT3HTukgMZkNYWnGtb+RKB2OzV7xLUz7rfvRidPEf+Y3E7W0HneQ1+tQz7hV5Y8bP7Nu8sE
TGaHNBTaDd8j05VQH651lh2DFtVtRo8ZDlK7/14nZeazH8aulqNB63h+N2BjnQlmVYQFLONQ
yE4M8BUCZji9cuiAos355ev8XiXzbpBH7ZHVZnDKt5lUdzrPmOttjNCf5KuO/gfaOyzgRhOT
iyGBiKiLRhAp0A9iTWderXm9/SPNV9cWqJBeEM9jnHmd/5c0gg5RizIi3uIH99sa/DrV6k69
C1x2KvtXBjxCa3XPbPg9YSu0tavGaY5sHV43slCnDrOjDp4f7z3Kei5aOe/lVuZS6wFlYpxQ
xp3WHJHgXXK9mj8/QBJz/vsN6zH34i8vFTeeI8843MwxwWrS8Qh+nfPBPzyOAAAAAAAA
--------------ms020306010004040609020307--
