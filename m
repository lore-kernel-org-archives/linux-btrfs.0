Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37707 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbbKMUVA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 15:21:00 -0500
Received: by igbhv6 with SMTP id hv6so21581884igb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 12:20:59 -0800 (PST)
Subject: Re: illegal snapshot, cannot be deleted
To: Hugo Mills <hugo@carfax.org.uk>, Vedran Vucic <vedran.vucic@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAHTEL3=r8kUJOU=xUAg2iG52HuWmqQ16QxUjY6d+zqbziW5+gw@mail.gmail.com>
 <564486F3.5020804@gmail.com>
 <CAHTEL3mEGmc5BhbGMEAbyPNU90nFQGZprLkWrh1WaEh5sSiH8w@mail.gmail.com>
 <56461034.3070209@gmail.com>
 <CAHTEL3m0uGWZGWUH_SLmg8TqMe4DcXU77p+S=4Aebukr1BZ-Bg@mail.gmail.com>
 <56462784.2060601@gmail.com> <20151113184227.GF24333@carfax.org.uk>
 <56463CBC.70808@gmail.com> <20151113195520.GG24333@carfax.org.uk>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5646460A.1010601@gmail.com>
Date: Fri, 13 Nov 2015 15:20:26 -0500
MIME-Version: 1.0
In-Reply-To: <20151113195520.GG24333@carfax.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000208000900050504010708"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000208000900050504010708
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-13 14:55, Hugo Mills wrote:
> On Fri, Nov 13, 2015 at 02:40:44PM -0500, Austin S Hemmelgarn wrote:
>> On 2015-11-13 13:42, Hugo Mills wrote:
>>> On Fri, Nov 13, 2015 at 01:10:12PM -0500, Austin S Hemmelgarn wrote:
>>>> On 2015-11-13 12:30, Vedran Vucic wrote:
>>>>> Hello,
>>>>>
>>>>> Here are outputs of commands as you requested:
>>>>>   btrfs fi df /
>>>>> Data, single: total=3D8.00GiB, used=3D7.71GiB
>>>>> System, DUP: total=3D32.00MiB, used=3D16.00KiB
>>>>> Metadata, DUP: total=3D1.12GiB, used=3D377.25MiB
>>>>> GlobalReserve, single: total=3D128.00MiB, used=3D0.00B
>>>>>
>>>>> btrfs fi show
>>>>> Label: none  uuid: d6934db3-3ac9-49d0-83db-287be7b995a5
>>>>>          Total devices 1 FS bytes used 8.08GiB
>>>>>          devid    1 size 18.71GiB used 10.31GiB path /dev/sda6
>>>>>
>>>>> btrfs-progs v4.0+20150429
>>>>>
>>>> Hmm, that's odd, based on these numbers, you should be having no
>>>> issue at all trying to run a balance. You might be hitting some
>>>> other bug in the kernel, however, but I don't remember if there were=

>>>> any known bugs related to ENOSPC or balance in the version you're
>>>> running.
>>>
>>>     There's one specific bug that shows up with ENOSPC exactly like
>>> this. It's in all versions of the kernel, there's no known solution,
>>> and no guaranteed mitigation strategy, I'm afraid. Various things lik=
e
>>> balancing, or adding, balancing, and removing a device again have bee=
n
>>> tried. Sometimes they seem to help; sometimes they just make the
>>> problem worse.
>>>
>>>     We average maybe one report a week or so with this particular
>>> set of symptoms.
>> We should get this listed on the Wiki on the Gotcha's page ASAP,
>> especially considering that it's a pretty significant bug (not quite
>> as bad as data corruption, but pretty darn close).
>
>     It's certainly mentioned in the FAQ, in the main entry on
> unexpected ENOSPC. The text takes you through identifying when there's
> the "usual" problem, then goes on to say that if you've hit ENOSPC
> with free space still to be unallocated, you've got this issue.
It should still probably be on the Gotcha's page also, as it definitely=20
fits the general description of the stuff there.
>> Vedran, could you try running the balance with just '-dusage=3D40' and=

>> then again with just '-musage=3D40'?  If just one of those fails, it
>> could help narrow things down significantly.
>>
>> Hugo, is there anything else known about this issue (I don't recall
>> seeing it mentioned before, and a quick web search didn't turn up
>> much)?
>
>     I grumble about it regularly on IRC, where we get many more reports=

> of it than on the mailing list. There have been a couple on here that
> I can recall, but not many.
Ah, that would explain it, I'm almost never on IRC.
>
>>   In particular:
>> 1. Is there any known way to reliably reproduce it (I would assume
>> not, as that would likely lead to a mitigation strategy.  If someone
>> does find a reliable reproducer, please let me know, I've got some
>> significant spare processor time and storage space I could dedicate
>> to getting traces and filesystem images for debugging, and already
>> have most of the required infrastructure set up for something like
>> this)?
>
>     None that I know of. I can start asking people for btrfs-image
> dumps again, if you want to investigate. I did do that for a while, to
> pass them to josef, but he said he didn't need any more of them after
> a while. (He was always planning on investigating it, but kept getting
> diverted by data corruption bugs, which have higher priority).
I don't have the experience to be able to properly debug it myself from=20
images (my expertise has always been finding bugs, not necessarily=20
fixing them), but was more offering to try and generate images (if we=20
could find some series of commands that reproduces this at least some of =

the time, I have the resources to run a couple of VM's doing that over=20
and over again until it hits the bug).  If I could get some, I might be=20
able to put some assertions into the kernel so that it panics when=20
there's an ENOSPC in the balance code, and get a stack trace, but the=20
more I think about it, the more likely it seems that that isn't going to =

be too helpful.
>
>> 2. Is it contagious (that is, if I send a snapshot from a filesystem
>> that is affected by it, does the filesystem that receives the
>> snapshot become affected; if we could find a way to reproduce it, I
>> could easily answer this question within a couple of minutes of
>> reproducing it)?
>
>     No, as far as I know, it doesn't transfer via send/receive.
> send/receive is largely equivalent to copying the data by other means
> -- receive is implemented almost exclusively in userspace, with only a
> couple of ioctls for mucking around with the UUIDs at the end.
I thought that might be the case, but wanted to ask just to be safe (I=20
do local backups on some systems using send/receive, largely because=20
this means if my regular root filesystem gets corrupted, I can directly=20
boot the backups, run a couple of commands, and then have a working=20
system again in about 5 or 10 minutes, but if this could spread through=20
send/receive, then that makes backups done this way less useful (because =

this is something that I would treat similar to regular FS corruption)).
>
>> 3. Do we have any kind of statistics beyond the rate of reports (for
>> example, does it happen more often on bigger filesystems, or
>> possibly more frequently with certain chunk profiles)?
>
>     Not that I've noticed, no. We've had it on small and large,
> single-device and many devices, HDD and SSD, converted and not
> converted. At one point, a couple of years ago, I did think it was
> down to converted filesystems, because we had a run of them, but that
> seems not to be the case.
That would seem to me to indicate it's somewhere in the common path for=20
balance, which narrows things down at least, although not by much.  Have =

we had anyone try balancing just data chunks or just metadata chunks?=20
That might narrow things down even further.  If it's corruption in the=20
FS itself, I would assume it's somewhere either in the system chunks,=20
the metadata chunks, or the space cache (if it's there, mounting with=20
clear_cache should fix it).


--------------ms000208000900050504010708
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTEzMjAyMDI2WjBPBgkq
hkiG9w0BCQQxQgRAiA4IVAL1EzYs9bYuEcy8kpfzJCH4IUyhgPimPtan0dxbvJ0hIyX3ysO0
82eWhX986+j3asLqAfaFIuodyvMK7TBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBFK9CM4lNxnAqBBs9TzIlXoFESGy2E3ghOyl9LUgTj+z3mhgaS
MCO3kq6+co21oOFo4TkImTZvmH2mEh+XR7tP/L7eH9YDAVNOfn/NJui9dcIb52EUkkux5IgR
IYN94lqVXmuejwophPj1NmtAhyEYvWGbgF6l3t37IIS8xA1hTNNGLaA1VlC4k5TX3xKU9/cR
bG6RpIauyG87PIuRBCZExv9faapXH3ueprd/260PSv/loDHsBUaDaDNuegCFyWVkqoorqYev
l/V0UR4tBx/GxaiSXCt9phZgSfp9fLETZR5KrbJLUyxkAdJZNRdHp62oiRhol4NWOtzX57I/
DCDMW+YHRfcU+ly+n+f+wfYIcYJpWI3j6SVBOd3xJnskv47nMYFrcgIOW295LFsqrY4QdJbD
RROR/CgGmkXeODQ3q1vcJWtEIxaabNFXh+sc4Pfhu5L+hQpOJ7KK/bX/WZguPx71ZNd0WCgQ
NLpQIxU48Hqy1m2ve8LhjTZPe1jXXW2eJmfRqr20uUeRiH8roCmz7DWgQ9VcrsOvOrdQNVQl
u1qIR1LB66128Zbgs0kR/Kujv0ipYOAhVFIWIBNYRFwsWLDSeujEmiM/zDwppeMKib27gHj5
J8xsJlv4PMV6xUP8DFXlWnOi2yFZBDFSJJDvl/ALdl+CFqJL2ec1p7K93gAAAAAAAA==
--------------ms000208000900050504010708--
