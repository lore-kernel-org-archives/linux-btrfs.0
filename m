Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46700 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751792AbdJODnQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Oct 2017 23:43:16 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e3ZpL-0000r1-4V
        for linux-btrfs@vger.kernel.org; Sun, 15 Oct 2017 05:42:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
Date: Sun, 15 Oct 2017 03:42:35 +0000 (UTC)
Message-ID: <pan$6c657$fdd187ad$65eeabd8$27c4d54c@cox.net>
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zoltán Ivánfi posted on Sat, 14 Oct 2017 21:00:26 +0200 as excerpted:

> Dear Btrfs Experts,
> 
> A few years ago I tried to use a RAID1 mdadm array of a SATA and a USB
> disk, which lead to strange error messages and data corruption. I did
> some searching back then and found out that using hot-pluggable devices
> with mdadm is a paved road to data corruption. Reading through that old
> bug again I see that it was autoclosed due to old age but still hasn't
> been addressed:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/320638

As pg suggests that bug really doesn't have much to do with hotplug.

Further, SATA is hotplug capable, particularly its ESATA variant (tho 
some specific SATA hardware or drivers may not be, and I believe it's an 
optional feature in the early SATA versions at least), and of course so 
is USB, and SCSI should be as well (tho I know rather less of it), so not 
being able to use hot-pluggable devices with mdadm would make it rather 
useless...

And I take issue with the bug's assertion that "upstream" doesn't have a 
bug tracker as well, as that's an Ubuntu bug, and certainly the mainline 
kernel has a bug tracker, at https://bugzilla.kernel.org , which I've 
been using to report bugs on development kernels for years, since at 
least 2.6.15 in 2006 (the bug above was 2009).  And that definitely was a 
kernelspace bug, tho I'd suggest it wasn't in mdadm so much as in the 
layers on top of it, since by my read mdadm was dealing with and passing 
thru the new due-to-hotplugging values just fine, it was the layers on 
top not dealing with the new values.

Now some kernel projects make more use of the kernel bugzilla than 
others, but there's someone responsible for getting the right people 
involved if necessary, and discussion can and does sometimes move to the 
list after that.  But the bug tracker is certainly there, and certainly 
usable, because as I said I've been using it to report and get fixed bugs 
I've found testing new kernels, since well before that ubuntu bug was 
filed.

And FWIW, btrfs does definitely use the kernel bugzilla, encouraging 
people to file bugs there so they don't drop thru the cracks on the 
mailing list, tho discussion here is useful as well, with links from one 
to the other so people can find both starting with either one.

> I would like to ask whether btrfs may also be prone to data corruption
> issues in this scenario (due to the same underlying issue as the one
> described in the bug above for mdadm), or is btrfs unaffected by the
> underlying issue and is safe to use with a mix of regular and
> hot-pluggable devices as well?

As mentioned, the issue reported there isn't really a hotplug issue...

Meanwhile, I'm not sure about max_sectors changing, but perhaps the 
question you meant to ask was about mixing USB and SATA.

In general, there seems to be a lot of problems reported by people using 
USB for multi-device btrfs connections, due to various issues with USB 
connection reliability.  The problems are often power related, and can be 
traced to anything from trying to drive too much from a limited-current 
port instead of using external power devices, to tripping over the power 
or USB cord and unplugging it in the middle of a write, to performance 
issues due to sharing the USB with other devices, to bad cables or 
otherwise bad connections corrupting the data on its way to the device, 
to...

As a result, I'd suggest, if you can, do SATA or other more robust 
connections for multi-device btrfs, and if you do need to do USB 
connected btrfs, use externally powered devices, and keep to single-
device btrfs.

(Tho a several GiB USB thumb-drive added temporarily can be handy to to 
get out of a bind if you're getting ENOSPC on a balance you're trying to 
do to consolidate chunk usage and free unused space back to chunk-
unallocated.  There's a FAQ entry that discusses that.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

