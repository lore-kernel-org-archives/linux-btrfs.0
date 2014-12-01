Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:55837 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbaLATLE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 14:11:04 -0500
Received: by mail-qg0-f50.google.com with SMTP id i50so7986737qgf.37
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 11:11:02 -0800 (PST)
Message-ID: <547CBD38.4010701@ubuntu.com>
Date: Mon, 01 Dec 2014 14:10:48 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za>	<20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com>	<E47EA20E-375D-49A6-B4B0-C6594CE6A633@colorremedies.com>	<546CB332.3080705@ubuntu.com>	<CAJCQCtTfhxW2w+mT6rqyr+WwVdj8SAEAGV+LB8_S3mcw0agxaw@mail.gmail.com>	<5474F5D1.2070908@ubuntu.com> <CAJCQCtSYFBj=KLZpdB5J+mXZwE5SCAR-H9mz5BXpsukOOp8SZQ@mail.gmail.com>
In-Reply-To: <CAJCQCtSYFBj=KLZpdB5J+mXZwE5SCAR-H9mz5BXpsukOOp8SZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/25/2014 6:13 PM, Chris Murphy wrote:
> The drive will only issue a read error when its ECC absolutely
> cannot recover the data, hard fail.
> 
> A few years ago companies including Western Digital started
> shipping large cheap drives, think of the "green" drives. These had
> very high TLER (Time Limited Error Recovery) settings, a.k.a. SCT
> ERC. Later they completely took out the ability to configure this
> error recovery timing so you only get the upward of 2 minutes to
> actually get a read error reported by the drive. Presumably if the
> ECC determines it's a hard fail and no point in reading the same
> sector 14000 times, it would issue a read error much sooner. But
> again, the linux-raid list if full of cases where this doesn't
> happen, and merely by changing the linux SCSI command timer from 30
> to 121 seconds, now the drive reports an explicit read error with
> LBA information included, and now md can correct the problem.

I have one of those and took it out of service when it started reporting
read errors ( not timeouts ).  I tried several times to write over the
bad sectors to force reallocation and it worked again for a while...
then the bad sectors kept coming back.  Oddly, the SMART values never
indicated anything had been reallocated.

> That's my whole point. When the link is reset, no read error is 
> submitted by the drive, the md driver has no idea what the drive's 
> problem was, no idea that it's a read problem, no idea what LBA is 
> affected, and thus no way of writing over the affected bad sector.
> If the SCSI command timer is raised well above 30 seconds, this
> problem is resolved. Also replacing the drive with one that
> definitively errors out (or can be configured with smartctl -l
> scterc) before 30 seconds is another option.

It doesn't know why or exactly where, but it does know *something* went
wrong.

> It doesn't really matter, clearly its time out for drive commands
> is much higher than the linux default of 30 seconds.

Only if you are running linux and can see the timeouts.  You can't
assume that's what is going on under windows just because the desktop
stutters.

> OK that doesn't actually happen and it would be completely f'n
> wrong behavior if it were happening. All the kernel knows is the
> command timer has expired, it doesn't know why the drive isn't
> responding. It doesn't know there are uncorrectable sector errors
> causing the problem. To just assume link resets are the same thing
> as bad sectors and to just wholesale start writing possibly a
> metric shit ton of data when you don't know what the problem is
> would be asinine. It might even be sabotage. Jesus...

In normal single disk operation sure: the kernel resets the drive and
retries the request.  But like I said before, I could have sworn there
was an early failure flag that md uses to tell the lower layers NOT to
attempt that kind of normal recovery, and instead just to return the
failure right away so md can just go grab the data from the drive that
isn't wigging out.  That prevents the system from stalling on paging IO
while the drive plays around with its deep recovery, and copying back
512k to the drive with the one bad sector isn't really that big of a
deal.

> Then there is one option which is to increase the value of the
> SCSI command timer. And that applies to all raid: md, lvm, btrfs,
> and hardware.

And then you get stupid hanging when you could just get the data from
the other drive immediately.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUfL04AAoJENRVrw2cjl5RFW0H/Rtz4Y8bynWAP2yjiqZMsic+
vXCxuJAFGpOKVyV1FboCuLStp8TQ5aIiJyHrprsCiy4UAY0bFQjzaHOo4jBlCdV/
YaD3HSWGKAFUbIiByCnMfIDMxWSPP8rOeFpotoywAkNe0vIsIKg955IX96+jNMy2
IAjKGQahzp2UW6ggnwwdA/JayUmb1jZ8LvmV58rDVdhTnGPgrrYZnIyf/OphrXqd
R/WJtFDuUBUhtsmXYrY2wGUQNi+3zp+I9YburmeDtEcrbwDLDCiVdE6ChmoCrNBS
nbcfqoWPEk1DsiI9GC/Yu/sXLq2iD0n53e/DHa36z4zc4uWtUjBwSYyCubJfkyI=
=FrB9
-----END PGP SIGNATURE-----
