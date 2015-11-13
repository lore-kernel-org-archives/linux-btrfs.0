Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33793 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbbKMTlT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 14:41:19 -0500
Received: by ioir85 with SMTP id r85so67059538ioi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 11:41:18 -0800 (PST)
Subject: Re: illegal snapshot, cannot be deleted
To: Hugo Mills <hugo@carfax.org.uk>, Vedran Vucic <vedran.vucic@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAHTEL3=r8kUJOU=xUAg2iG52HuWmqQ16QxUjY6d+zqbziW5+gw@mail.gmail.com>
 <564486F3.5020804@gmail.com>
 <CAHTEL3mEGmc5BhbGMEAbyPNU90nFQGZprLkWrh1WaEh5sSiH8w@mail.gmail.com>
 <56461034.3070209@gmail.com>
 <CAHTEL3m0uGWZGWUH_SLmg8TqMe4DcXU77p+S=4Aebukr1BZ-Bg@mail.gmail.com>
 <56462784.2060601@gmail.com> <20151113184227.GF24333@carfax.org.uk>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56463CBC.70808@gmail.com>
Date: Fri, 13 Nov 2015 14:40:44 -0500
MIME-Version: 1.0
In-Reply-To: <20151113184227.GF24333@carfax.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060300050505080504000605"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060300050505080504000605
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-13 13:42, Hugo Mills wrote:
> On Fri, Nov 13, 2015 at 01:10:12PM -0500, Austin S Hemmelgarn wrote:
>> On 2015-11-13 12:30, Vedran Vucic wrote:
>>> Hello,
>>>
>>> Here are outputs of commands as you requested:
>>>   btrfs fi df /
>>> Data, single: total=3D8.00GiB, used=3D7.71GiB
>>> System, DUP: total=3D32.00MiB, used=3D16.00KiB
>>> Metadata, DUP: total=3D1.12GiB, used=3D377.25MiB
>>> GlobalReserve, single: total=3D128.00MiB, used=3D0.00B
>>>
>>> btrfs fi show
>>> Label: none  uuid: d6934db3-3ac9-49d0-83db-287be7b995a5
>>>          Total devices 1 FS bytes used 8.08GiB
>>>          devid    1 size 18.71GiB used 10.31GiB path /dev/sda6
>>>
>>> btrfs-progs v4.0+20150429
>>>
>> Hmm, that's odd, based on these numbers, you should be having no
>> issue at all trying to run a balance. You might be hitting some
>> other bug in the kernel, however, but I don't remember if there were
>> any known bugs related to ENOSPC or balance in the version you're
>> running.
>
>     There's one specific bug that shows up with ENOSPC exactly like
> this. It's in all versions of the kernel, there's no known solution,
> and no guaranteed mitigation strategy, I'm afraid. Various things like
> balancing, or adding, balancing, and removing a device again have been
> tried. Sometimes they seem to help; sometimes they just make the
> problem worse.
>
>     We average maybe one report a week or so with this particular
> set of symptoms.
We should get this listed on the Wiki on the Gotcha's page ASAP,=20
especially considering that it's a pretty significant bug (not quite as=20
bad as data corruption, but pretty darn close).

Vedran, could you try running the balance with just '-dusage=3D40' and=20
then again with just '-musage=3D40'?  If just one of those fails, it coul=
d=20
help narrow things down significantly.

Hugo, is there anything else known about this issue (I don't recall=20
seeing it mentioned before, and a quick web search didn't turn up much)? =

  In particular:
1. Is there any known way to reliably reproduce it (I would assume not,=20
as that would likely lead to a mitigation strategy.  If someone does=20
find a reliable reproducer, please let me know, I've got some=20
significant spare processor time and storage space I could dedicate to=20
getting traces and filesystem images for debugging, and already have=20
most of the required infrastructure set up for something like this)?
2. Is it contagious (that is, if I send a snapshot from a filesystem=20
that is affected by it, does the filesystem that receives the snapshot=20
become affected; if we could find a way to reproduce it, I could easily=20
answer this question within a couple of minutes of reproducing it)?
3. Do we have any kind of statistics beyond the rate of reports (for=20
example, does it happen more often on bigger filesystems, or possibly=20
more frequently with certain chunk profiles)?


--------------ms060300050505080504000605
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTEzMTk0MDQ0WjBPBgkq
hkiG9w0BCQQxQgRAvusH9jMuGMqXABZZH13kbkAcu2toc1+4DUu8G+3IkUjkDBwmZGzu9eXV
Am7lhEvJaw1uLvK6sOf7iff++5gGXTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCOQoX+kpnkjFola0PNJl4l6LcNX7VFkyIonr/WDmVFw/2eyNAE
KmglSR7Wt0m1imHkbKqKlZH6xmI/IyToP66pNpX/WdDBzVJqaG7rRBW5lzXphk9ZDE7qFCvR
Mo1NdsijvCRnRROWulZ8iTsDxywpnxGDk9kCCjU/hXKZED2UgzkyWP0eW4rQKcJJNd1xAAkV
bPLqq7Ez62RbtWi3crrm0zIyWeGIR9dGXzgHVccXpAKROQHMu+TcrbiQJiWO0j3oDwN19cVB
/kHmT22Ur/A2qdcrHguRWtomgzBzaujRQ8lsg1C/ktyVJ6cxTr/SE8GvHnlNj7YQVGaLPha4
vVrxbaqIBywSrdFjdxQ/m9S6ytra5seDFeIaA3h5gYYtkFtvGvsaAwak0F+DETYEzSFj/5T3
G9D23dv85oSqV/Zjldm5wzew+wsZZZp8psAVsCeUQkyAepd2kJh3huDnuqgg/HldO2IQy9rI
wyeD2XS10RLDpvcIE+hO8tz80c7ps6F1OnDcrmLf6gdXXhWWCt/wlR8ONGFeKq/z3ARdSKuo
apkTc11d6FP6rbb7JVS3oZ2XiHtQdlA7UQNk/Hg/grMAgj4F+mylDBRl2U8TpSu0nYwZyFKe
UoNEPmHBoGPrluktQmMgVUs2IhO8w4rlMqqebjF7rAwFPjjsEmp9c9EArwAAAAAAAA==
--------------ms060300050505080504000605--
