Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34232 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbbKJMTy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 07:19:54 -0500
Received: by iody8 with SMTP id y8so216968972iod.1
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2015 04:19:53 -0800 (PST)
Subject: Re: btrfs-progs send | receive error: no such file or directory
To: Glen H <glen.hertz@gmail.com>
References: <CABtZWNH4rzzTtBwvt6Xs+nf=8aiJrbsCAVZB3QzPEnEfi-Cs5A@mail.gmail.com>
 <5640A497.2060701@gmail.com>
 <CABtZWNHRiUOA1tcj2NmqBJs8N6SzXFbs1iVhj73D45Xb7sNojw@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5641E0B4.1040504@gmail.com>
Date: Tue, 10 Nov 2015 07:19:00 -0500
MIME-Version: 1.0
In-Reply-To: <CABtZWNHRiUOA1tcj2NmqBJs8N6SzXFbs1iVhj73D45Xb7sNojw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020800020508050705090209"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020800020508050705090209
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-09 22:11, Glen H wrote:
> On Mon, Nov 9, 2015 at 8:50 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-11-08 16:28, Glen H wrote:
>>>
>>> Hi,
>>>
>>> I really enjoy the features of btrfs but send|receive is failing me s=
o
>>> my backups are not working.  I'm using "btrbk" to backup my drives
>>> (all local) and one of the three subvolumes errors out.  When I run
>>> this command from the terminal it errors out:
>>>
>>>> btrfs send /mnt/ssd/_btrbk_snap/@.20151108 | btrfs receive
>>>> /mnt/backup2tb/
>>>
>>> At subvol /mnt/ssd/_btrbk_snap/@.20151108
>>> At subvol @.20151108
>>> ERROR: send ioctl failed with -2: No such file or directory
>>> ERROR: unexpected EOF in stream.
>>
>> Have you ever run any kind of data deduplication (bedup, duperemove, o=
r
>> something else) on the source filesystem?  I've seen errors like this =
in the
>> past when trying to send from a filesystem that I had run deduplicatio=
n on
>> (and I don't think that the patches to fix it made into the version of=
 Mint
>> you're using).
>>
>> That aside, there are two things that I've found that can fix some (bu=
t not
>> all) send/receive errors:
>> 1. Run a balance on the filesystem (either a full balance, or use filt=
ers to
>> select just the block in question).
>> 2. Force the file that it's choking on to be re-written (you can use '=
btrfs
>> receive -vv' to see what files it's processing, although be prepared f=
or _a
>> lot_ of output).
>
> Thanks Austin for the suggestions.  I haven't done any deduping, it is
> a pretty fresh install too (two weeks old).  I tried a full balance a
> few times:
>
> # btrfs balan /
> Done, had to relocate 28 out of 28 chunks
> # btrfs balan /
> Done, had to relocate 28 out of 28 chunks
>
> After balancing the first time should there be less to rebalance the
> second time?
Not usually, unless you had a lot of chunks that were partially full.
>
> I tried receive -vv and then deleted the file that was causing the
> issue but running again the issue happens on a different file:
>
> ...
> utimes var/lib/sudo/hertz
> truncate var/lib/sudo/hertz/2 size=3D40
> chown var/lib/sudo/hertz/2 - uid=3D0, gid=3D1000
> chmod var/lib/sudo/hertz/2 - mode=3D0600
> utimes var/lib/sudo/hertz/2
> mkfile o189735-35-0
> truncate o189735-35-0 size=3D0
> chown o189735-35-0 - uid=3D1000, gid=3D1000
> chmod o189735-35-0 - mode=3D0600
> ERROR: unexpected EOF in stream.
When I see this type of error on my system, it's usually with multiple=20
files, and deleting/rewriting each one sequentially does eventually fix i=
t.
>
> I'm not using any kind of raid.  Do you think reformatting the
> partition or something else might help?  Should I try to upgrade the
> kernel?
Reformatting would definitely fix it, although that of course means you=20
have to restore from a backup or re-install the system.  Upgrading the=20
kernel probably won't fix the issue (in this case it appears to be=20
something in the on-disk structures), but it should make it less likely=20
to happen again.


--------------ms020800020508050705090209
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTEwMTIxOTAwWjBPBgkq
hkiG9w0BCQQxQgRAjOmIa4bY1OERRFYWxwOaSB+VuyP/1f8hf04vByNvFx09o7m1RG7dGdWe
+xuBVZWDQ6KOUT2LrJeH/8KO4QY1UTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCGQBqvF7mv67ueFylXgtEwrw84zbWIecTi/tPBa7V6JTWFlaFy
bazytpmrym258veGgjgrXAwzoQpWrj/tp+VgTGoLJyz7ALiQblX2+WBF3hD1FyhYTr7iXPJq
hND6NXsrsEbgE2H2kzgFCHJOPfP6NJTvsUkKzxOOfhp1KNl807pVSiVkmtWnAV9z2QbTGIb7
jX4C/1SVjBN2xmB/2h0L86lLAVE1mfkm1glDNto7mhP3ColmuIqDTmR4cv27xT/bjfK8AFTW
uRHpqxBwh0AZkUnW6GU4PwbCCGYmjj32kmaEBbkBJCXO+09m+FavURkV8N6QU2c5VWaX5Z/F
KIe2Xx1eColV1PHt7oHYWhpAum0JCINdZf7rVGC9QXxOLRhYZ5WYjX8xKuZ4A2eJtsXRwh51
aytNF6iF3xb3/y6I6cEKoJpJHlCiosdi893Lyzqw1pCOwV5rj5uC+sLhP0bAjHC4OQ+woopQ
HPlHaWg8jH3QOclgu71DAeroDOB49SOMt2SyR+fs+W4zFIwsdFUFzHthz3VZlVbxEV9jjEDG
uaxaqUikBX+Eof++iJ0RhJ4Mgc2L8kc5IqH2/a1yDnGjgXomXhEKyG84SB2yGBmcLLhnAZ4Y
QtqqjFLfeDd4bWD0Lgols2UqL8PlSwSWlDcjTVVYKQbVE0s3ltKJAlZ/mQAAAAAAAA==
--------------ms020800020508050705090209--
