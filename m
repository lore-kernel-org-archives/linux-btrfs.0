Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:54642 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbaAAKxS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jan 2014 05:53:18 -0500
Received: by mail-ie0-f178.google.com with SMTP id lx4so13784534iec.37
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jan 2014 02:53:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAM6NUi5hmX3vwPsG1rOQbCH+KNS=P927Hxbhc8Vt8bu1qCv6pw@mail.gmail.com>
References: <CAM6NUi5hmX3vwPsG1rOQbCH+KNS=P927Hxbhc8Vt8bu1qCv6pw@mail.gmail.com>
Date: Wed, 1 Jan 2014 18:53:17 +0800
Message-ID: <CAM6NUi6O2LpqbJpvyYrBwAJD3+Ugodb3+rk6Y0Rcc+sGjxVzaA@mail.gmail.com>
Subject: Re: btrfs corruption after resuming from suspend to disk
From: Nicolas Boichat <nicolas@boichat.ch>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,

(sorry for the strange formatting, I was not subscribed to the list
and didn't get your message by email, now I am subscribed)

First, thank you for your reply.

> Duncan <1i5t5.duncan <at> cox.net> 2014-01-01 09:21:28 GMT
>
> Nicolas Boichat posted on Wed, 01 Jan 2014 14:01:16 +0800 as excerpted:
>
> > I've been running btrfs for less than a month now, on my /home
> > directory. Not sure if it is relevant, but I had a number of kernel
> > panics over that month (unrelated to btrfs). Yesterday, upon resuming
> > from suspend to disk, the partition was remounted as read-only, so I
> > rebooted, hoping to fix the problem.
> >
> > Since then, I'm unable to mount the partition.
>
> Just another btrfs user here so no dev insights, but similar altho less
> serious resume from suspend (to RAM in my case, s2disk didn't work on
> this machine last I tried and I don't even have a swap/suspend partition
> ATM) issues...
>
> In my case (with dual-SSD btrfs in raid1 data/metadata), the root of the
> problem seems to be the supercapacitor on the SSDs taking too long to
> recharge if the system has been in s2ram too long (with the SSDs powered
> down).  For original boot, the kernel has the rootwait commandline
> option, which waits until the drives respond properly before attempting
> to continue.  But apparently that doesn't apply to s2ram, so if the
> system has been in suspend more than about four hours and supercapacitor
> is mostly discharged, it takes too long to charge and that drive drops
> out of the mount.
> That forces the mount read-only for safety even tho there's still one
> device left in the raid1, which triggers various I/O stalls, and
> ultimately a system live-lock within a few minutes, from which I have to
> reboot.
>
> After the reboot, the affected filesystems have always mounted, but a
> scrub turns up and fixes errors, as expected when one of the pair of a
> raid1 drops out.
> That forces the mount read-only for safety even tho there's still one
> device left in the raid1, which triggers various I/O stalls, and
> ultimately a system live-lock within a few minutes, from which I have to
> reboot.
>
> After the reboot, the affected filesystems have always mounted, but a
> scrub turns up and fixes errors, as expected when one of the pair of a
> raid1 drops out.

Interesting... Not quite sure it applies here... More details on my setup:
 - Dell XPS 15 Haswell, brand new (1 month, same as the btrfs partition)
 - 256 GB SSD mSATA (PLEXTOR PX-256M5M firmware 1.04): Contains ext4
'/' and btrfs '/home' .
 - 1TB HDD (not relevant here I believe)
 - I've done a lot of suspend to RAM, sometimes overnight (8h),
without any problem.
 - This is the first time I do a long suspend to disk (about 3 days
long: I did short s2disk for testing, but only few minutes long)

I have root partition on the SSD as well (ext4), and the suspend to
disk is on a swap file in the ext4 partition.

Checksumming and compression are enabled in the disk image, so the
first thing the laptop did on resume was to read a lot of valid data
(~1GB probably?) from the SSD (and the last thing before suspend to
write a lot of data). I'm not saying it's impossible that some data on
the btrfs partition was left in the SSD cache (and then corrupted),
but that doesn't seem very likely... Also, the systemd log I posted
was written to that same SSD device, and I got no corruption on the
ext4 partition.

> > I tried a number of repair commands, see the output there:
> > https://gist.github.com/drinkcat/8193276
> >
> > I also tried git://repo.or.cz/btrfs-progs-unstable/devel.git, branch
> > integration-20131219, without success (./btrfs rescue chunk-recover -v
> > /dev/sdb3 does not throw any errors though, but that doesn't fix the
> > filesystem).
>
> Your problem may be too serious for this to work, but if you tried it, I
> missed it, and it did work for me with some fail-to-mount issues I had
> quite some time ago.
>
> In that case the corruption was apparently only in the space-cache, and
> mounting with clear_cache was all I needed to do.  After that, the
> filesystem mounted normally, and I could do a scrub to ensure it was fine.

That doesn't help...

> With a bit of luck that'll work for you too, tho I'd guess one things you
> tried would have cleared that too... but I don't know.
>
> I'd also try (and didn't see) btrfs-zero-log, and btrfs restore, possibly
> in combination with btrfs-find-root.

I did try btrfs-restore (file 04 in https://gist.github.com/drinkcat/8193276).
I just added the output of find-root in the gist (07), it finds the
root easily...

> Btrfs-zero-log is covered in the problem FAQ (wrapped link):
>
> https://btrfs.wiki.kernel.org/index.php/
> Problem_FAQ#I_can.27t_mount_my_filesystem.2C_and_I_get_a_kernel_oops.21
>
> Be sure to work on a copy with zero-log as it can make the problem worse
> if it doesn't fix it.

I did also try zero-log, added as 08 in the gist. It basically fails
in a very similar way to all other commands (I don't think it actually
writes anything to the disk)...

Thanks for your input,

Best,

Nicolas
