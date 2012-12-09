Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35664 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934486Ab2LIUmg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Dec 2012 15:42:36 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so1879143oag.19
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Dec 2012 12:42:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50C4E152.2000102@friedels.name>
References: <50BFB3B2.8040405@friedels.name>
	<CAKcLGm_44rjGwyKox0xO1SqWP1SkY-z8vpST6n99Q4g6eN9Lrw@mail.gmail.com>
	<50C4E152.2000102@friedels.name>
Date: Sun, 9 Dec 2012 14:42:35 -0600
Message-ID: <CAKcLGm8wm1Gfe0ESCubGusqe_zojJp=7JORLXuq_EUdY22JOWA@mail.gmail.com>
Subject: Re: segmentation-fault in btrfsck (git-version)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 9, 2012 at 1:06 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Dear Mich,
>
> thanks for your help and suggestion:
>
>> It might be interesting for you to try a newer kernel, and use scrub
>> on this volume if you have the two disks RAIDed.
>
> I have now scrubbed the Disk:
> ./btrfs scrub status /mnt/other/
> scrub status for a15eede9-1a92-47d8-940a-adc7cf97352d
>         scrub started at Sun Dec  9 13:48:57 2012 and finished after 3372
> seconds
>         total bytes scrubbed: 1.10TB with 0 errors
>
>
> That's odd, as in one folder, data is missing (I could have deleted it, but
> I'd be very surprised...)
>
> Also, when I run btrfsck, I get errors:
> On sdc1:
> root 261 inode 64370 errors 400
> root 261 inode 64373 errors 400
>
> root 261 inode 64375 errors 400
> root 261 inode 64376 errors 400
> found 1203899371520 bytes used err is 1
> total csum bytes: 1173983136
> total tree bytes: 1740640256
> total fs tree bytes: 280260608
> btree space waste bytes: 212383383
> file data blocks allocated: 28032005304320
>  referenced 1190305632256
> Btrfs v0.20-rc1-37-g91d9eec
>
> On sdb1:
> root 261 inode 64373 errors 400
>
> root 261 inode 64375 errors 400
> root 261 inode 64376 errors 400
> found 1203899371520 bytes used err is 1
> total csum bytes: 1173983136
> total tree bytes: 1740640256
> total fs tree bytes: 280260608
> btree space waste bytes: 212383383
> file data blocks allocated: 28032005304320
>  referenced 1190305632256
> Btrfs v0.20-rc1-37-g91d9eec
>
>
>
> And when I try to mount one of the two raided disks, I get:
> [ 1173.773861] device fsid a15eede9-1a92-47d8-940a-adc7cf97352d devid 1
> transid 140194 /dev/sdb1
> [ 1173.774695] btrfs: failed to read the system array on sdb1
> [ 1173.774854] btrfs: open_ctree failed
>
> while the other works:
> [ 1177.927096] device fsid a15eede9-1a92-47d8-940a-adc7cf97352d devid 2
> transid 140194 /dev/sdc1
>
> Do you have hints for me?
> The Kernel now is 3.3.7-030307-generic (anything more recent, I would have
> to compile myself, which I will do, if you suggest to)
>

Since btrfs has significant improvements and fixes in each kernel
release, and since very few of these changes are backported, it is
recommended to use the latest kernels available.

The "root ### inode ##### errors 400" are an indication that there is
an inconsistency in the inode size.  There was a patch included in the
3.1 or 3.2 kernel to address this issue
(http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=f70a9a6b94af86fca069a7552ab672c31b457786).
 But I don't believe this patch fixed existing occurrences of this
error.

At this point, the quickest solution for you may be to rebuild and
reformat this RAID assembly, and restore this data from backups.

If you don't have a backup of this data, and since your array seems to
be working pretty well in a degraded state, this would be a really
good time to look at a strategy of getting a backup of this data
before doing many more attempts at rescue.
