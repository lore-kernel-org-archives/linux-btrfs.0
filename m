Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:56233 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaF0RQb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 13:16:31 -0400
Received: by mail-ig0-f172.google.com with SMTP id hn18so2209270igb.17
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 10:16:30 -0700 (PDT)
Message-ID: <53ADA6A4.3000303@gmail.com>
Date: Fri, 27 Jun 2014 13:15:16 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: kreijack@inwind.it, Zhe Zhang <zhe.zhang.research@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [Question] Btrfs on iSCSI device
References: <CAMXuLLrhMv82LPveRemDU_v_Kru2US6sKVn377gS3t9p-VFrag@mail.gmail.com> <53AD9D1A.4050703@libero.it>
In-Reply-To: <53AD9D1A.4050703@libero.it>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080602030207070908040505"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080602030207070908040505
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-06-27 12:34, Goffredo Baroncelli wrote:
> Hi,
> On 06/27/2014 05:44 PM, Zhe Zhang wrote:
>> Hi,
>>
>> I setup 2 Linux servers to share the same device through iSCSI. Then I=

>> created a btrfs on the device. Then I saw the problem that the 2 Linux=

>> servers do not see a consistent file system image.
>>
>> Details:
>> -- Server 1 running kernel 2.6.32, server 2 running 3.2.1
>> -- Both running btrfs v0.20-rc1
>> -- Server 2 has device /dev/vdc, exposed as iSCSI target
>>  -- Server 1 mounts the device as /dev/sda
>> -- Server 1 'mount /dev/sda /mnt/btrfs'; server 2 'mount /dev/vdc /mnt=
/btrfs',
>>  -- When server 1 'touch /mnt/btrfs/foo', server 2 doesn't see any
>> file under /mnt/btrfs
>> -- I created /mnt/btrfs/foo on server 2 as well; then I added some
>> content from both server 1 and server 2 to /mnt/btrfs/foo
>> -- After that each server sees the content it adds, but not the
>> content from the other server
>> -- Both server 'umount /mnt/btrfs', and mount it again
>> -- Then both servers see /mnt/btrfs/foo with the content added from
>> server 2 (I guess it's because server 2 created the foo file later
>> than server 1).
>>
>> I did a similar test on ext4 and both servers see a consistent image
>> of the file system. When server 1 creates a foo file server 2
>> immediately sees it.
>>
>> Is this how btrfs is supposed to work?
>=20
> I don't think that it is possible to mount the _same device_ at the _sa=
me time_ on two different machines. And this doesn't depend by the filesy=
stem.
>=20
> The fact that you see it working, I suspect that is is casual.
>=20
> When I tried this (same scsi HD connected to two machines), I had to en=
sure that the two machines never accessed to the HD at the same time.
>=20
>>
>> Thanks,
>>
>> Zhe
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20
>=20
If you need shared storage like that, you need to use a real cluster
filesystem like GFS2 or OCFS2, BTRFS isn't designed for any kind of
concurrent access to shared storage from separate systems.
The reason it appears to work when using iSCSI and not with directly
connected parallel SCSI or SAS is that iSCSI doesn't provide low level
hardware access.


--------------ms080602030207070908040505
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAw8BRDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA1
MTIxNDEwMzJaFw0xNDExMDgxNDEwMzJaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDbLUaL
Gs4JTdU7sgr0MzD57CMUAv307ddC9pxooDMN3PiUvzEd5kLtBCh8KDB1wbMdfm4hte2rDd+j
hM1tIq67BvNbdDPztOcBZwT2/3OVyyG4B1ddCqUyt03zGKw6Y34eHNfapsZiiItX0GBNfjHU
Wv+WDo+XNha/WmGSSMv21HkftF9XA1KC9Bpr9JJI23MKK7T2g/7b3KoGZlx3ekLIJsF5B7+B
DMPPDqOHQbRnccyOHEMyhM13g6WoAbU+3aKYc+C/9UsYtDV+xlvBLWagky1acstD5wOA35V6
uDRbUhD+vOjuMRMCj9jJOIYqa6AeSagBjxRnisJr0RFzQ4f+NjGCHPaFTvRvbkiXh4q22doT
0SxbNBUm7B9ANugIOtS9/VQhTWKDi//WTqZQ7Ecl4yVJbMCUg/iaRHMCGS41vqMICPszRidW
rL04NwS9D2cREEY1y/xrNo0ZvKPZu6tLhxhPf7w+5rsN3+wWxGaR1hNpnVUT9AeacLKZO6W9
FsRT3Unkr91IhQATHTKYr4EAkjN/5lgvA+sxp5TxxsUnoJYrD8IHf8aYfJsAHMleBwx4xSeZ
tw/n5iIjJjFZq9IRZ1zQhK62p+a5vJ2vlJHjTgavhQrfb1pUOjbqsnI4ndQ5hNosL9el4Kxq
Yko+HsxVEmSwSsjq6cV2L3oz0z8NUwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAIokFPcW8+cO2Clu0Ei+ehAmQRBHfV5RWJ8aMVLXOCfiJX0ch
IjVSIt6I3uQaR4J1ZIAjCSPkbpfZQDaLoGFI5j8aYEQhOeKxrvOMzY9/aSUYabCJIhE/sX64
klFV0bzm+PR9cDMWeQ9BoZf0m8UROPSfDnrjEk+p04hGg3pAZMcSwCzxdb604NHjgHJmf2xG
UQVzQgC6Ek/BKat0xuPTuPmtPv9OicK75CPmLZKYW3rFpCD6bhb1mm+ROcCNhniRY2LYm9YN
QdlHQUzTFqj0tvuYrzNI3LNV4PjEfN8z6omPCT2Rq8/uKLseN+m8F0ioqm+cphqpmzKoDUpN
nePLkqDFUFWCeWRxSjBTy4IMVUfdNXriVGihH8hyIICQiOfmmBOzhzUifdomJuTGtoXRuHVT
R2f/YdrJrLnKI4f+Othdp7F3KhB4c6JiOnTEH5J8n9q3rFjt4MPRwcjIHMhmF5nZVQlgxEMo
1cPCmvG1D9tcgXbH79jjqydo9SDXhzLQob7axkzGRY96IstNcvoQ/UNsdPPfFMYlHtGz4TxT
DhBjv4ERskGmKBZrfmxkXkcuTV/gcykct6Xvw9YXb8WTL4qSYHSYk9fReVLgE/L4RBUpX2JJ
QvIR0AJLER165/aZlQXZtuJjnfxJtJTJZZ+Gor9h0G2kuR5Dy0JuYdBO4t4xggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFEMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDYyNzE3MTUxNlowIwYJKoZIhvcNAQkE
MRYEFAcVLgRucjVorT5932yowSyfOayJMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAIymj3bhrj0d/VTsFJyNAmFzOkZRdRTebJAU/IbVJy/AmP1t
K7Af/M88MNnDaL4HHgD4ERDD0qUuVXgW5CW+2mkl08N7r4GS0CFoPVuxVaa8WioKAWxeoT49
mCKFZIbHlx1tYipSl4ja/ucpob8XemLoLFX3cU3JmZNiwl8TQKEx+3Opk019ncl10R12lGkL
9MaMCdkVvWwhji0Nd0nUH9dkM4E+EUCuE0Ru2330uuBknZTWL3pNXMGb8UcoX6ma7sSBE22f
hQFVGzyDEE/ar5P3vUVky3tdM5TM7y5Xdei+wdmAGYLOvRWafipS+rEWMz0ed4DKd1GmCblb
XPGke3LLAOKAp4JtPxwwMUwS2qxaIBUzTOTghQEbbHPqZ1JiFsXTK+/D39i+8mDngKok2kQm
vshCANeMcdiiYus9EAiIx38h1LjXivqz9WUQN50Pvdi/5hU9TwXZc8TFlFCecPViMelbPKLv
4zMEMHn7dXkB4YIIx/gfJ4iDPVogiwcriA07826dQafh4grJSuOfnQQsevJ1xCmgVQ2LqSKH
NKhqrAKaDSohx5JXJZZDhOFCWav3H50XIoUocvwoxZDg8RcX4lnkQlPy808E5Hra5ijb0jEW
7y39E1oIvIlxia0/1E1XdqiuMNcqDLQERI4ufc3ygVr2hHcyBisUPZNWihB7AAAAAAAA
--------------ms080602030207070908040505--
