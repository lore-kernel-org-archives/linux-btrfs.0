Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:58330 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaG2ROp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 13:14:45 -0400
Message-ID: <53D7D680.9080803@gmail.com>
Date: Tue, 29 Jul 2014 13:14:40 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
Subject: Re: Multi Core Support for compression in compression.c
References: <CAPDOMViXEgN1U8Og52Fd7EaM86Ad2Dfex9TVQ-+tRZ9SL9Kcig@mail.gmail.com>	<53D5BBCA.3020109@gmail.com>	<CAPDOMVjB9ErEwA7mf91X7pff5LAkeT=BT4pR7TuoEp3LL333Lg@mail.gmail.com>	<53D6218A.5080401@gmail.com>	<CAPDOMVg869TJJPgrW86XaMT2WyisbT9fg0jLETCAvg59xpvs4Q@mail.gmail.com>	<CAPDOMVh5kFE2kZtnpjQdAv1n+7FN=X_oc3YRyWOxpPmo=qW_cQ@mail.gmail.com>	<53D67828.3040802@gmail.com>	<CAPDOMVhNAqF_KSeT9MamLgk8Mwe1Qb3uZRK9oipE_49ScO8UHQ@mail.gmail.com> <CAPDOMViwEA1HXXCukUfJ0fJgnCKT1cWxyCkcD9v5+2yYu=r6Hw@mail.gmail.com>
In-Reply-To: <CAPDOMViwEA1HXXCukUfJ0fJgnCKT1cWxyCkcD9v5+2yYu=r6Hw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030808090801080106040806"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030808090801080106040806
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-07-29 13:08, Nick Krause wrote:
> On Mon, Jul 28, 2014 at 2:36 PM, Nick Krause <xerofoify@gmail.com> wrot=
e:
>> On Mon, Jul 28, 2014 at 12:19 PM, Austin S Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>> On 2014-07-28 11:57, Nick Krause wrote:
>>>> On Mon, Jul 28, 2014 at 11:13 AM, Nick Krause <xerofoify@gmail.com>
>>>> wrote:
>>>>> On Mon, Jul 28, 2014 at 6:10 AM, Austin S Hemmelgarn
>>>>> <ahferroin7@gmail.com> wrote:
>>>>>> On 07/27/2014 11:21 PM, Nick Krause wrote:
>>>>>>> On Sun, Jul 27, 2014 at 10:56 PM, Austin S Hemmelgarn
>>>>>>> <ahferroin7@gmail.com> wrote:
>>>>>>>> On 07/27/2014 04:47 PM, Nick Krause wrote:
>>>>>>>>> This may be a bad idea , but compression in brtfs seems
>>>>>>>>> to be only using one core to compress. Depending on the
>>>>>>>>> CPU used and the amount of cores in the CPU we can make
>>>>>>>>> this much faster with multiple cores. This seems bad by
>>>>>>>>> my reading at least I would recommend for writing
>>>>>>>>> compression we write a function to use a certain amount
>>>>>>>>> of cores based on the load of the system's CPU not using
>>>>>>>>> more then 75% of the system's CPU resources as my system
>>>>>>>>> when idle has never needed more then one core of my i5
>>>>>>>>> 2500k to run when with interrupts for opening eclipse are
>>>>>>>>> running. For reading compression on good core seems fine
>>>>>>>>> to me as testing other compression software for reads ,
>>>>>>>>> it's way less CPU intensive. Cheers Nick
>>>>>>>> We would probably get a bigger benefit from taking an
>>>>>>>> approach like SquashFS has recently added, that is,
>>>>>>>> allowing multi-threaded decompression fro reads, and
>>>>>>>> decompressing directly into the pagecache. Such an approach
>>>>>>>> would likely make zlib compression much more scalable on
>>>>>>>> large systems.
>>>>>>>>
>>>>>>>>
>>>>>>>
>>>>>>> Austin, That seems better then my idea as you seem to be more
>>>>>>> up to date on brtfs devolopment. If you and the other
>>>>>>> developers of brtfs are interested in adding this as a
>>>>>>> feature please let me known as I would like to help improve
>>>>>>> brtfs as the file system as an idea is great just seems like
>>>>>>> it needs a lot of work :). Nick
>>>>>> I wouldn't say that I am a BTRFS developer (power user maybe?),
>>>>>> but I would definitely say that parallelizing compression on
>>>>>> writes would be a good idea too (especially for things like
>>>>>> lz4, which IIRC is either in 3.16 or in the queue for 3.17).
>>>>>> Both options would be a lot of work, but almost any performance
>>>>>> optimization would.  I would almost say that it would provide a
>>>>>> bigger performance improvement to get BTRFS to intelligently
>>>>>> stripe reads and writes (at the moment, any given worker thread
>>>>>> only dispatches one write or read to a single device at a
>>>>>> time, and any given write() or read() syscall gets handled by
>>>>>> only one worker).
>>>>>>
>>>>>
>>>>> I will look into this idea and see if I can do this for writes.
>>>>> Regards Nick
>>>>
>>>> Austin, Seems since we don't want to release the cache for inodes
>>>> in order to improve writes if are going to use the page cache. We
>>>> seem to be doing this for writes in end_compressed_bio_write for
>>>> standard pages and in end_compressed_bio_write. If we want to cache
>>>> write pages why are we removing then ? Seems like this needs to be
>>>> removed in order to start off. Regards Nick
>>>>
>>> I'm not entirely sure, it's been a while since I went exploring in th=
e
>>> page-cache code.  My guess is that there is some reason that you and =
I
>>> aren't seeing that we are trying for write-around semantics, maybe on=
e
>>> of the people who originally wrote this code could weigh in?  Part of=

>>> this might be to do with the fact that normal page-cache semantics
>>> don't always work as expected with COW filesystems (cause a write goe=
s
>>> to a different block on the device than a read before the write would=

>>> have gone to).  It might be easier to parallelize reads first, and
>>> then work from that (and most workloads would probably benefit more
>>> from the parallelized reads).
>>>
>> I will look into this later today and work on it then.
>> Regards Nick
>=20
> Seems the best way to do is to create a kernel thread per core like in =
NFS and
> depending on the load of the system use these threads.
> Regards Nick
>=20
It might be more work now, but it would probably be better in the long
run to do it using kernel workqueues, as they would provide better
support for suspend/hibernate/resume, and then you wouldn't need to
worry about scheduling or how many CPU cores are in the system.


--------------ms030808090801080106040806
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDcyOTE3MTQ0MFowIwYJKoZIhvcNAQkE
MRYEFHcs5cM/6g1bAP1gGGaMvYMwWgL6MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAGKix6/rrFJIV9A/fIvwnXgNmAj9w0Ltgfl6PvNsHjAeEI+E
3maB6UCYal2XqYhdxXRV8pXabGlA37Zjw3A3PTw0dEAsJwBkE9Iw5E/zohNeHvRioVjUf9nh
bQZywWkey/KUfzN15erPXeE/vHz10K8fMa97KelcB2/1aN8hgsmG1zODCMervzumxJ7T/m5I
2sw2Xf9ebfqRgx0fUqI7wjgADGQHjo8fgLCmFPKkXsTpozkOIr6Nn5EQBMnSCinP7SoaJGZ3
LjnCtiBncSbxdLmDzJXv1ONepFICClLWcbUW0/pGymivuRJgfMWYzRHLpVMo1N1eRa18M3Kc
JkpjQ2eoyPDmzYt9N8yge0DQ5lw8nUdqQJBPqbSooBBc1CSMIOFhqrFkqqxYn8su9IaDB8nm
r4EG0pV3Z8qydW6ZSdTWH/VB+7zBRskoQTBoHicNiwVSWredHbpd5Jws+GNHDKXBowM5jEv/
4vlQUcKyv0XolucSoPtim2+qxbvRvx95SPUL826iLJ3q68eeV/xiwDJ9sSvcLOgB7yuyrobT
ZChslb/ciYQQKnTFxwl6DiXfTfOB2dOvEG+vuUwegeAUGrHEUFPQWtjFhvVce31qvxlC15Vk
RnWtBiOCynKhQ3OZeJVilHgpjbDKhGvDyX2BDSNyU9cRTTmtdS+nHN/hMysEAAAAAAAA
--------------ms030808090801080106040806--
