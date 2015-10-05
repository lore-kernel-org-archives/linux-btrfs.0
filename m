Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34373 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbbJEQBx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 12:01:53 -0400
Received: by igcpb10 with SMTP id pb10so66310918igc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2015 09:01:52 -0700 (PDT)
Subject: Re: Issues with unmountable BTRFS raid1 filesystem
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <56126D59.7070505@gmail.com>
 <20151005131426.GP25907@carfax.org.uk> <561286F2.40607@gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56129EE0.6060709@gmail.com>
Date: Mon, 5 Oct 2015 12:01:36 -0400
MIME-Version: 1.0
In-Reply-To: <561286F2.40607@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000100000401030109080500"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000100000401030109080500
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-05 10:19, Austin S Hemmelgarn wrote:
> On 2015-10-05 09:14, Hugo Mills wrote:
>> On Mon, Oct 05, 2015 at 08:30:17AM -0400, Austin S Hemmelgarn wrote:
>>> I've been having issues recently with a relatively simple setup
>>> using a two device BTRFS raid1 on top of two two device md RAID0's,
>>> and every time I've rebooted since starting trying to use this
>>> particular filesystem, I've found it unable to mount and had to
>>> recreate it from scratch.  This is more of an inconvenience than
>>> anything else (while I don't have backups of it, all the data is
>>> trivial to recreate (in fact, so trivial that doing backups would be
>>> more effort than just recreating the data by hand)), but it's still
>>> something that I would like to try and fix.
>>>
>>> First off, general info:
>>> Kernel version: 4.2.1-local+ (4.2.1 with minor modifications,
>>> sources can be found here: https://github.com/ferroin/linux)
>>> Btrfs-progs version: 4.2
>>>
>>> I would post output from btrfs fi show, but that's spouting
>>> obviously wrong data (it's saying I'm using only 127MB with 2GB of
>>> allocations on each 'disk',  I had been storing approximately 4-6GB
>>> of actual data on the filesystem).
>>>
>>> This particular filesystem is composed of BTRFS raid1 across two LVM
>>> managed DM/MD RAID0 devices, each of which spans 2 physical hard
>>> drives.  I have a couple of other filesystems with the exact same
>>> configuration that have not ever displayed this issue.
>>>
>>> When I run 'btrfs check' on the filesystem when it refuses to mount,
>>> I get a number of lines like the following:
>>> bad metadata [<bytenr>, <bytenr>) crossing stripe boundary
>>>
>>> followed eventually by:
>>> Errors found in extent allocation tree or chunk allocation
>>
>>     I _think_ this is a bug in mkfs from 4.2.0, fixed in later
>> releases of the btrfs-progs.
> If so, that's good news (that is, that it's just a mkfs bug).  I guess
> it's time for me to quit waiting around for Gentoo to package the newes=
t
> version and build it myself.
It looks like it was indeed a bug in mkfs from 4.2.0, I upgraded to the=20
development branch and everything seems to be working correctly now.=20
Thanks for the help!



--------------ms000100000401030109080500
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDA1MTYwMTM2WjBPBgkq
hkiG9w0BCQQxQgRAMj9vM+IiVxhjksbs8tH5FJrv/UHdBs1uks2JNQYZqMEY0PF3jUwMxF4z
7w/grVisyB+4Kr3RzCAb5Va29/k6sTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgApsA+/nYLQr17xNYWOICcwYrIGBj5+NpFOD/DKVK9yjvEf+OQ7
9jeqtCjVcy1dyRidfVaEGTMcxuZPltZ95YrbB4wmYdTbIXYzdBsN752SJgIXC7UiUIOFUVH1
ZPNpebVkb1PwWvSY98i82AMqz1VltVBD3aA0fccsmUQkSKaiD0EqJeYKfLdz4hnUmBX78zjI
vqzKWBsVW0hoNIvVXLdobt+tYDkWhAMKcP2ClJT0ak0ChQUBNsodqePBCow2ri0ZSLkgBMU/
f0Yod07jloXP4WmKlNrnNoerPDGCZH3u9aig3l1bMJnclGwyhnspVO2vLkM1K4HtPS/dHPtN
1wLblLrEuycO0DA6hmF6hp62q3te08qMI544ZnH6F3Ap3nanVh7kgB6SMhCZLqggMR8g/DgY
qhjTc3hsWcG+dcESVcO07P0V1P46zvzoAy5dRt+cV+iSAsWdDsw030igXtUJnPy8Ltz9Ke50
ITimoTPcktK8udb9QbtR+009awIf1Kk9wpDZ4RZgpLnD3HG++lOatjoL0yu82/n45qjPBuzo
ozMSlW+EOcGFNXLEKih0ZULFMKgVOd23G/o219EbH2IHqwrTRrLLGmTzrLVBCBDpNvCyUTKt
YVBzYCyjmiUw5QIxbfDNTL4pmv8pGuDmCV/9x8ODHl96yfT38Gx3NdzdSwAAAAAAAA==
--------------ms000100000401030109080500--
