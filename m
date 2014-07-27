Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54451 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaG0C5T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Jul 2014 22:57:19 -0400
Received: by mail-qa0-f46.google.com with SMTP id v10so6311311qac.33
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Jul 2014 19:57:18 -0700 (PDT)
Message-ID: <53D46A8B.2030002@gmail.com>
Date: Sat, 26 Jul 2014 22:57:15 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: Use backup superblocks if and only if the
 first superblock is valid but corrupted.
References: <1403841234-10393-1-git-send-email-quwenruo@cn.fujitsu.com> <53D17A88.5090905@fb.com>
In-Reply-To: <53D17A88.5090905@fb.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020300060301060205080306"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020300060301060205080306
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/24/2014 05:28 PM, Chris Mason wrote:
>=20
>=20
> On 06/26/2014 11:53 PM, Qu Wenruo wrote:
>> Current btrfs will only use the first superblock, making the backup
>> superblocks only useful for 'btrfs rescue super' command.
>>
>> The old problem is that if we use backup superblocks when the first
>> superblock is not valid, we will be able to mount a none btrfs
>> filesystem, which used to contains btrfs but other fs is made on it.
>>
>> The old problem can be solved related easily by checking the first
>> superblock in a special way:
>> 1) If the magic number in the first superblock does not match:
>>    This filesystem is not btrfs anymore, just exit.
>>    If end-user consider it's really btrfs, then old 'btrfs rescue supe=
r'
>>    method is still available.
>>
>> 2) If the magic number in the first superblock matches but checksum do=
es
>>    not match:
>>    This filesystem is btrfs but first superblock is corrupted, use
>>    backup roots. Just continue searching remaining superblocks.
>=20
> I do agree that in these cases we can trust that the backup superblock
> comes from the same filesystem.
>=20
> But, for right now I'd prefer the admin get involved in using the backu=
p
> supers.  I think silently using the backups is going to lead to surpris=
es.
Maybe there could be a mount non-default mount-option to use backup
superblocks iff the first one is corrupted, and then log a warning
whenever this actually happens?  Not handling stuff like this
automatically really hurts HA use cases.



--------------ms020300060301060205080306
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDcyNzAyNTcxNVowIwYJKoZIhvcNAQkE
MRYEFENAOEkWDvrgdKDqR4P3vkJQA8h+MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAIkSE7gBgreo4QhlS8TgzBdzo1QBa7m8xgdO33HR6h3Hnx7z
ZruemjkBbOoqX1ClJaH5LopK2B5QWEj3Tt9R7u5mWMoIbOY7Tr0J4asGPu/aC3KVvq/xVezx
nIUvWee8MNgk9967iJT4nptzWbahunnWNxenyLVRzEwfDSpo1boJhw5nSHhsHB/5+AwNqUYl
Culvx6zdT3nTus79awzh6wvG5VmhjEchRdPE5IUeho2Ou+JA/E8Yx2uHjOWOO9e+jvCzURdz
RNFj8LN/Un6aRNdPpFkYzbsxY1bjYHRD2nhCmtdeMtLW6GA+Z6m72lxcOOer9bEgDceVF8HE
O+MWGmDnvsMl7uBK2elBKNxfRk7k7Uy7E/SZRVisD710lf06m6vByWbDuL8NvC8e0R7M0BDF
wvYvrj0A8KTJSij7SPwezTphjioZfKXLMYEBcyr+Fsy3k4rxseITgm5ADHUDUj/o+qgVIbeS
ZzFcluNcaXVPC5btO9ySxoIS0ucMes+NNOXIa0YHH9/hWFb+JuZ0HkeG+j83H2USZmVXFkrW
pqG600F/8MgmrpucbQw9TPVBzlT7sHcbvNNIXwdkCa2TfxX39ej3lsFDJvxFsYZ6vO+B+q9t
npMN7CmxnDhoCUiAMiVXV4Pxlo3Rl9dkC63D6e5bl5tHr0S3BGcnb5rSnToHAAAAAAAA
--------------ms020300060301060205080306--
