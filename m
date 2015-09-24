Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:36958 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbbIXTsZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 15:48:25 -0400
Received: by igbni9 with SMTP id ni9so56745989igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2015 12:48:24 -0700 (PDT)
Subject: Re: btrfs: obtain block checksums from user space
To: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
References: <mu1e38$io1$1@ger.gmane.org> <5604427D.1000708@gmail.com>
 <CAJs94EbJV+VX16dnkFqH21OMV=uLYSCKnG9KNUCrs7B=rULYLg@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56045359.2090202@gmail.com>
Date: Thu, 24 Sep 2015 15:47:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAJs94EbJV+VX16dnkFqH21OMV=uLYSCKnG9KNUCrs7B=rULYLg@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000504030206070109050402"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000504030206070109050402
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-24 14:48, Matwey V. Kornilov wrote:
> 2015-09-24 21:35 GMT+03:00 Austin S Hemmelgarn <ahferroin7@gmail.com>:
>> On 2015-09-24 14:06, Matwey V. Kornilov wrote:
>>>
>>>
>>> Hello,
>>>
>>> I would like to read the list of the checksums for the specific file
>>> stored onto btrfs filesystem. I think I could use the checksums in th=
e
>>> manner like rsync does, but safe both CPU (because csums are already
>>> calculated for the file) and I/O (because I don't need to reread all =
the
>>> file from the hard drive).
>>
>> As of right now, there is no way to do this from userspace without jus=
t
>> directly parsing the on-disk format (which isn't safe or reliable if t=
he
>> filesystem is mounted). It has been discussed before, but the discussi=
ons
>> haven't really gotten anywhere.
>>
>> It's worth noting that the way btrfs does checksums isn't per-file, it=
's
>> per-block. This means that:
>> a. I think (I'm not 100% certain about this) that the checksum in btrf=
s
>> includes the padding up to the end of the block for blocks that aren't=
 full.
>> b. Files that get stored in-line in their metadata block won't have a
>> checksum just for the file data (because the checksum will cover the w=
hole
>> metadata block).
>> c. While it is possible with some checksum algorithms (if I remember r=
ight,
>> CRC32c is one such algorithm, and that is what btrfs uses for it's
>> checksums) to combine the checksums from a group of data blocks to get=
 the
>> checksum for data as a whole, this in and of itself takes a significan=
t
>> amount of CPU time for large amounts of data.
>>
>> All in all, this means that if you just want a checksum of the content=
s of
>> the file, it's almost certainly better to just do it in userspace.
>> If you're trying to figure out what changed, using send/receive and
>> snapshots is more efficient (usually).
>
> I want the checksums of the every block of the file to see which part
> has been changed.
> I cannot use send/receive because my other file replica is on the
> remote host but not on the same filesystem. Compare with how rsync
> works. It calculates checksums of the chunks of both versions of the
> file and then syncs different chunks over the network. I just want to
> utilize the fact that btrfs already has the data I need to calculate.
On current versions of btrfs-progs, btrfs send has a mode that will just =

spit out the metadata, which can then be parsed to figure out what has=20
changed.  The parsing is of course non-trivial, but should still be=20
faster than checksumming everything, and I'm relatively sure (although I =

may be wrong) that the send stream format is well documented.



--------------ms000504030206070109050402
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTI0MTk0NzM3WjBPBgkq
hkiG9w0BCQQxQgRAmLxN/f3HrwedZ4h8yFCaQbxe3jUWf7iXZfnH0sW70l5Bb7vBZJBVj/ln
xT9Y4JP16iowpYBPWuagXHMwbDodUzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgABGxV3h1Dwu/XEZtHBhzY5iNu07NdQ+RpuETEq8eMfr6aJNB0U
7S79mHO9RdHZ3mwnLpJGUoZ5NmODByBHf3dBc8kPiY3ShJK9DQPNN1O4FjPkNc+bW6bDZxn+
xaNf8ZTEtiC11bTgim46a7EC0uc5HLRY2hgo1kqrSDAWzSEBmqqmQU1iOSRH/LphLHFiBF4m
jQTn/M0vyEVyG/UgNHWOKkAzWl3x1Jpav5SkgI5iOxnSS1wXBiwAVdVav34mO5oftqvB9AIS
xeymraN0iJARpe0eXyU+7NfJc8vQnvKWDKiqeWvVK+G0FTXa515qRZ/aEsqGEN7b7hW/piwn
amMVIy+OiWEyAy0vNDMeWbTAtslPjhyLfGMq3vG6aFFT9NznGltNIGaLeObvILEJjwHyf2mv
FBAv0EsUTIi+Clp57+WpHl2+dNhFSwcwrnWwIlOShmtx59zZ6GTN7pYnA8YbApYdj4U7FPRG
kcH987UgVbFZumBp4j46XsYbDEeuA9jMEdC4AquwEcB0QF46QTI1hZL185S1EjTEg1r2SS+k
FnSc6Ak4rPqT/gBXqL/XpZWfL2mrno5RVogOzS5hPPi5EsudCsahxgZRn91VYqpSndAVvoia
egS8rKWuC4jnh9rBsqWLuDKIrifVtgBGI/f1c2nNE39zCrB7CnQmoogHrgAAAAAAAA==
--------------ms000504030206070109050402--
