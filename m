Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:64385 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaGKB5P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 21:57:15 -0400
Received: by mail-qg0-f41.google.com with SMTP id i50so401119qgf.14
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 18:57:14 -0700 (PDT)
Message-ID: <53BF4477.4030704@gmail.com>
Date: Thu, 10 Jul 2014 21:57:11 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs transaction checksum corruption & losing root of the tree
 & bizarre UUID change.
References: <CAKinxcW7X=tc8GBBjkGNHKL8wM6dD=a9UkWBpXOsAbLpaOBmYA@mail.gmail.com>
In-Reply-To: <CAKinxcW7X=tc8GBBjkGNHKL8wM6dD=a9UkWBpXOsAbLpaOBmYA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010603050004050002010004"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010603050004050002010004
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/10/2014 07:32 PM, Tomasz Kusmierz wrote:
> Hi all !
>=20
> So it been some time with btrfs, and so far I was very pleased, but
> since I've upgraded to ubuntu from 13.10 to 14.04 problems started to
> occur (YES I know this might be unrelated).
>=20
> So in the past I've had problems with btrfs which turned out to be a
> problem caused by static from printer generating some corruption in
> ram causing checksum failures on the file system - so I'm not going to
> assume that there is something wrong with btrfs from the start.
>=20
> Anyway:
> On my server I'm running 6 x 2TB disk in raid 10 for general storage
> and 2 x ~0.5 TB raid 1 for system. Might be unrelated, but after
> upgrading to 14.04 I've started using Own Cloud which uses Apache &
> MySql for backing store - all data stored on storage array, mysql was
> on system array.
>=20
> All started with csum errors showing up in mysql data files and in
> some transactions !!!. Generally system imidiatelly was switching to
> all btrfs read only mode due to being forced by kernel (don't have
> dmesg / syslog now). Removed offending files, problem seemed to go
> away and started from scratch. After 5 days problem reapered and now
> was located around same mysql files and in files managed by apache as
> "cloud". At this point since these files are rather dear to me I've
> decided to pull all stops and try to rescue as much as I can.
>=20
> As a excercise in btrfs managment I've run btrfsck --repair - did not
> help. Repeated with --init-csum-tree - turned out that this left me
> with blank system array. Nice ! could use some warning here.
>=20
I know that this will eventually be pointed out by somebody, so I'm
going to save them the trouble and mention that it does say on both the
wiki and in the manpages that btrfsck should be a last-resort (ie, after
you have made sure you have backups of anything on the FS).
> I've moved all drives and move those to my main rig which got a nice
> 16GB of ecc ram, so errors of ram, cpu, controller should be kept
> theoretically eliminated. I've used system array drives and spare
> drive to extract all "dear to me" files to newly created array (1tb +
> 500GB + 640GB). Runned a scrub on it and everything seemed OK. At this
> point I've deleted "dear to me" files from storage array and ran  a
> scrub. Scrub now showed even more csum errors in transactions and one
> large file that was not touched FOR VERY LONG TIME (size ~1GB).
> Deleted file. Ran scrub - no errors. Copied "dear to me files" back to
> storage array. Ran scrub - no issues. Deleted files from my backup
> array and decided to call a day. Next day I've decided to run a scrub
> once more "just to be sure" this time it discovered a myriad of errors
> in files and transactions. Since I've had no time to continue decided
> to postpone on next day - next day I've started my rig and noticed
> that both backup array and storage array does not mount anymore. I was
> attempting to rescue situation without any luck. Power cycled PC and
> on next startup both arrays failed to mount, when I tried to mount
> backup array mount told me that this specific uuid DOES NOT EXIST
> !?!?!
>=20
> my fstab uuid:
> fcf23e83-f165-4af0-8d1c-cd6f8d2788f4
> new uuid:
> 771a4ed0-5859-4e10-b916-07aec4b1a60b
>=20
>=20
> tried to mount by /dev/sdb1 and it did mount. Tried by new uuid and it
> did mount as well. Scrub passes with flying colours on backup array
> while storage array still fails to mount with:
>=20
> root@ubuntu-pc:~# mount /dev/sdd1 /arrays/@storage/
> mount: wrong fs type, bad option, bad superblock on /dev/sdd1,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
>=20
> for any device in the array.
>=20
> Honestly this is a question to more senior guys - what should I do now =
?
>=20
> Chris Mason - have you got any updates to your "old friend stress.sh"
> ? If not I can try using previous version that you provided to stress
> test my system - but I this is a second system that exposes this
> erratic behaviour.
>=20
> Anyone - what can I do to rescue my "bellowed files" (no sarcasm with
> zfs / ext4 / tapes / DVDs)
>=20
> ps. needles to say: SMART - no sata CRC errors, no relocated sectors,
> no errors what so ever (as much as I can see).
First thing that I would do is some very heavy testing with tools like
iozone and fio.  I would use the verify mode from iozone to further
check data integrity.  My guess based on what you have said is that it
is probably issues with either the storage controller (I've had issues
with almost every brand of SATA controller other than Intel, AMD, Via,
and Nvidia, and it almost always manifested as data corruption under
heavy load), or something in the disk's firmware.  I would still suggest
double-checking your RAM with Memtest, and check the cables on the
drives.  The one other thing that I can think of is potential voltage
sags from the PSU (either because the PSU is overloaded at times, or
because of really noisy/poorly-conditioned line power).  Of course, I
may be totally off with these ideas, but the only 2 times that I have
ever had issues like these myself were caused by a bad storage
controller doing writes from the wrong location in RAM, and a
line--voltage sag that happened right as BTRFS was in the middle writing
to the root-tree.



--------------ms010603050004050002010004
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDcxMTAxNTcxMVowIwYJKoZIhvcNAQkE
MRYEFAtJQP3Cm0nTwgFdQaQ8vV9WSdUdMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAHN6RArg3vT3nkzih4VYjoY//0MP9GofLj8p+445S/sO5vUE
4R2p2GrAwzNoZxZsEwr4RO4czkFvgOovBigAnEgYrb8dVpt7N7FC2NLMgOa6S093bDXHDVa5
u4cPMvBqG/iwsxrfDjkeJ/rQFH66df0mamRorMqNicpu4oIn1NZo3Ofva7aAr4P/sMAO1BNK
AnpETmQmJGCfZd5W2eU4tUUYAw159iU+MZu92Z4uFnrlm23fTkJ4PeZNpqCUDKesQuPxHGS5
bepADSaCxgQjFuiRMItZZY0DL7GHkATLbvm3lHrGIN9f9i6pf1px/DYHjNaxhuqhrFN2I53x
qv/tiZmniqu3UW2INZJMUHZGw+t1GwEeEu0Cng/BV852MyjuxVLRDUH4yMFbW0+bmECmnLLt
AHVoScxBUBEnYFRAofeBrolncFYPp9LTIOUHUXkhxSGz0Qhee5RMtTKOmpXy4+ZjZEvFLOrz
W1aujAIGhiqgOS99uyFEi2VsYREBU58Bkn/U/w6+G1beTgRgTY8bw8R6UpoUgRuVH0iX3CHc
ryHkHjHGvYXiaGh+RonjZUMoQfMNLLHxsVRNLpDdDVz/6P8DoLA9JGYH3xaEtrmssUCgGc2p
RKFJZhl9udKVB7ZFvjdV6OEmJ28KHr3wkDzJU5XxVCLW6Mu/IipeH9DqtQohAAAAAAAA
--------------ms010603050004050002010004--
