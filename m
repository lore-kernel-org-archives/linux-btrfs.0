Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35353 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbbKXMqy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 07:46:54 -0500
Received: by ioc74 with SMTP id 74so18578287ioc.2
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 04:46:53 -0800 (PST)
Subject: Re: btrfs send reproducibly fails for a specific subvolume after
 sending 15 GiB, scrub reports no errors
To: Duncan <1i5t5.duncan@cox.net>, Nils Steinger <nst@voidptr.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <56530608.50906@gmail.com> <20151123211012.GA12286@ny.voidptr.de>
 <pan$7e9cd$79273243$6e85efe7$7ee378ef@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56545C1B.1080507@gmail.com>
Date: Tue, 24 Nov 2015 07:46:19 -0500
MIME-Version: 1.0
In-Reply-To: <pan$7e9cd$79273243$6e85efe7$7ee378ef@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms050801020900060604080009"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050801020900060604080009
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-24 00:42, Duncan wrote:
> Nils Steinger posted on Mon, 23 Nov 2015 22:10:12 +0100 as excerpted:
>
>> Do we anything about what might cause a filesystem to enter a state
>> which `send` chokes on?
>> I've only seen a small sample of the corrupted files before growing
>> tired of the process and just recreating the whole thing, but all of
>> them were database files (presumably SQLite). Could it be that the fil=
es
>> were being written to during an unclean shutdown, leading to some kind=

>> of corruption of the FS? Unfortunately, I was a little triggerhappy wh=
en
>> cleaning up old snapshots, so there aren't any left to aid in
>> troubleshooting this problem further=E2=80=A6
That's OK, I've not been able to figure out much anyway, despite the=20
case of this I had about a month ago with about 200 different files=20
hitting the issue (I had written a script at that time to automate=20
fixing it, but haven't been able to find it for some reason), and the=20
other cases I've had on my systems over the past year (I only started=20
using send about a year ago for backups).  It might be worth noting that =

you're the first person who's directly reported this (I would have, but=20
I hate to report stuff that isn't a critical data safety issue without a =

reliable reproducer).
>
> Austin's the one attempting to trace down the problem, so he'd have the=

> most direct answer there.  (My use-case doesn't involve snapshotting or=

> send/receive at all.)
I stopped using send/receive for backups after hitting this for what I=20
think is the seventh time in the past year about a month ago (I still=20
use snapshots for backups, but now I use them to generate SquashFS=20
images (I really don't care about the block layout or inode numbers or=20
most of the BTRFS related properties), which preserves my desire to have =

bootable backups, and also saves significant storage space both locally=20
and on the cloud storage services I use for off-site backups (and in=20
turn saves money on those too)).  I am still trying to pull together=20
something to reliably reproduce this though, as I still use send/receive =

for some things (like cloning VM's without taking them offline or=20
hitting the issues with block copies of a BTRFS filesystem).
>
> But if any type of files would be likely to create issues, it'd be
> something like database or VM image files, since the random-file-rewrit=
e-
> pattern they typically have is in general the most problematic for copy=
-
> on-write (COW) filesystems such as btrfs.  Without some sort of
> additional fragmentation management (like the autodefrag mount option),=

> these files will end up _highly_ fragmented on btrfs, often thousands o=
f
> fragments, tens of thousands when the files in question are multi-gig.
In general, I've seen this mostly with three types of files:
1. Database files and VM images (In my experience, this has been the=20
majority of the issue on filesystems that have them.  Autodefrag doesn't =

seem to help, at least, not for SQLite or BerkDB/GDBM databases).
2. Shared libraries and executables (these are the majority of the issue =

on filesystems without databases or VM images, although I can't for the=20
life of me figure out why, as they are usually written to very infrequent=
ly)
3. Plain text configuration files.

For example, the last time I had this happen, it was on the root=20
filesystem of one of my systems, and about a third of the problem files=20
were either in /etc or text files under /usr/share, while the remaining=20
2 thirds were mostly stuff under /usr/lib and /lib.  It's probably worth =

noting also that I've never seen certain files trigger this that I would =

expect to based on the above info, in particular:
1. ClamAV virus databases (IIRC, these are similar in structure to=20
SQLite DB's).
2. BOINC applications.
3. Almost anything in /usr/libexec (stuff like GCC and binutils).
4. Almost any kind of script.
It's probably also worth noting that I occasionally see inconsistencies=20
in database files that cause this to happen, but have never seen any=20
corruption in any other types of file, so it doesn't seem to have an=20
impact on data safety.


--------------ms050801020900060604080009
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTI0MTI0NjE5WjBPBgkq
hkiG9w0BCQQxQgRAWMHz9BUB/w7c4R1WXKWHri75/lGqk9T3G4QTFcvny1OxPW4iruG2mBPd
hRQUQ6xTva8thuWpBhCWfP9NlUk2PjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAGcgNPkhPqnLoixwrjEpgzZ+ifsLiEvSXXQN/WMhJO5zrVCOAt
GHH5a+ObPXNabU+JvNNwKdxA854OIklUHxONktcOpEhyq5vlp207BFK4akN5LRww6HOL2DxR
pLTkarqTTwmIJKEGwNdalEhx/o79OYcZpJy7J0Yglgq1RhjNHhUvZQ5tAApYFiMjY7ayEsl6
ubvv+tGDqSLcdwJUPPvTyhPJGEYMeHD5XhS6ctu5ZhSWu89dOAg79+3zBKeTn649THyd6ruQ
IzYL1+kYr+wkeOTrrhpE3ow5YAU67ukCT3t5PZ+KBsBQlEwE6ZYLdJzgb+LGJdoWIHzO3ANX
wIVFX4vSMf+wsn25lyTOnPXfy07/k4aXfgNTMjT3L3/hMV9Q1vLAwFeRN9uFK7JwKNBJr00e
JehuYGJQsaZXWkjypkcPbqdknOkZ0/nmCssvltvAka9oZHgXXGzpKAIWjdx5d62Wkt2XiVTP
dt0BpYZ3HQa/RCvcBpuJRbFQK+LHq//v266dEOWY2csqBewhtMfJ4ku6P6bBqq7v/GTHf3t0
jPgTiug9LkX9qMoH148i+/a5mnJtRdtE3cEt5JezEJcdY2l7ayezJEyl63vHu1tMa+gdq1Ka
DBao0kcpsz8JJ8ZlfzD+rk0+4chX6v3LhWq/p1e9pV3K8Z5jmmJqeLZQnQAAAAAAAA==
--------------ms050801020900060604080009--
