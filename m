Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:33079 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbbJEOTp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 10:19:45 -0400
Received: by igbkq10 with SMTP id kq10so63732445igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2015 07:19:44 -0700 (PDT)
Subject: Re: Issues with unmountable BTRFS raid1 filesystem
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <56126D59.7070505@gmail.com>
 <20151005131426.GP25907@carfax.org.uk>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <561286F2.40607@gmail.com>
Date: Mon, 5 Oct 2015 10:19:30 -0400
MIME-Version: 1.0
In-Reply-To: <20151005131426.GP25907@carfax.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030405080901090604010301"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030405080901090604010301
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-05 09:14, Hugo Mills wrote:
> On Mon, Oct 05, 2015 at 08:30:17AM -0400, Austin S Hemmelgarn wrote:
>> I've been having issues recently with a relatively simple setup
>> using a two device BTRFS raid1 on top of two two device md RAID0's,
>> and every time I've rebooted since starting trying to use this
>> particular filesystem, I've found it unable to mount and had to
>> recreate it from scratch.  This is more of an inconvenience than
>> anything else (while I don't have backups of it, all the data is
>> trivial to recreate (in fact, so trivial that doing backups would be
>> more effort than just recreating the data by hand)), but it's still
>> something that I would like to try and fix.
>>
>> First off, general info:
>> Kernel version: 4.2.1-local+ (4.2.1 with minor modifications,
>> sources can be found here: https://github.com/ferroin/linux)
>> Btrfs-progs version: 4.2
>>
>> I would post output from btrfs fi show, but that's spouting
>> obviously wrong data (it's saying I'm using only 127MB with 2GB of
>> allocations on each 'disk',  I had been storing approximately 4-6GB
>> of actual data on the filesystem).
>>
>> This particular filesystem is composed of BTRFS raid1 across two LVM
>> managed DM/MD RAID0 devices, each of which spans 2 physical hard
>> drives.  I have a couple of other filesystems with the exact same
>> configuration that have not ever displayed this issue.
>>
>> When I run 'btrfs check' on the filesystem when it refuses to mount,
>> I get a number of lines like the following:
>> bad metadata [<bytenr>, <bytenr>) crossing stripe boundary
>>
>> followed eventually by:
>> Errors found in extent allocation tree or chunk allocation
>
>     I _think_ this is a bug in mkfs from 4.2.0, fixed in later
> releases of the btrfs-progs.
If so, that's good news (that is, that it's just a mkfs bug).  I guess=20
it's time for me to quit waiting around for Gentoo to package the newest =

version and build it myself.
>
>> As is typical of a failed mount, dmesg shows a 'failed to read the
>> system array on <device>' 'open_ctree failed'.
>>
>> I doubt that this is a hardware issue because:
>> 1. Memory is brand new, and I ran a 48 hour burn-in test that showed
>> no errors.
>> 2. A failing storage controller, PSU, or CPU would be manifesting
>> with many more issues than just this.
>> 3. A disk failure would mean that two different disks, from
>> different manufacturing lots, are encountering errors on exactly the
>> same LBA's at exactly the same time, which while possible is
>> astronomically unlikely for disks bigger than a few hundred
>> gigabytes (the disks in question are 1TB each).
>>




--------------ms030405080901090604010301
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDA1MTQxOTMwWjBPBgkq
hkiG9w0BCQQxQgRA3LRJ42leqmysig1qPt2zxGUJMKBBoGJwKwao0viJJlgQXZ2RQ7TCr8+3
1SrzxwsWYisuzvyGFmki8+kksAe3ETBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCQk83+lVE82jxcKHJP1y1hPVoLh7ZS3xCf6Fh+VOlGak1xqJL0
LlD690gd43SBILn+7etfA3TrZXvdd5DLdvXW1MJfVMb95onHPrb82ERu55eTDUXl+OEmbOmS
QT5qznFj0caWUWNn9BGPJN+d9Sq8Tcf/6kSjPlbZenIWvVixoBZ0oy4GWYjlkKKg4PCWgWlF
Ue+dsW11W1dgS2u2z1gq35KwhtF4r0XZCzJ4QEgi1qDEZUVpAmS1hc0qj7DKthV/JycHjGjo
unwLAV2v+1xiDa//n/DP2KJmfvDYUn4zqZSw9VbOZtrPikvzJ2cY1e8Q11kTe5AadsWAjYs9
0Jpftu+tIDk07LMbdRlZfHtYauUkSfNlMiA0cluucKizykTs7ZfA0/spMJHQHZkHkkFB77dt
S6Bkz75fD2COCHN+3odnBViPLdfeeHlkEsz30uqXryJcPIckUABpIYEBboQ7Dk5GMxTJYD4l
QU3z0+zHUOglEP0ek7eP3AUH3uW/DQ60Hp7is6C9Ctp9KygGmd1KumwMWSh8OM7h5a3JBLvl
5aLX09FDwcdB9Z9kTUoafLP1d5aJ5CtOsNle2OsLpMrWTbK6gNtKd+nzaKE7vrqi6Nr9ss47
qqA0q72dYspPhhBG28ZluaG/jP2K7bQj+JE2z/I4zrhivplrlkeo0nyfGwAAAAAAAA==
--------------ms030405080901090604010301--
