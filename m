Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38623 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934172Ab3BNOoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 09:44:10 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Rebalancing RAID1
Date: Thu, 14 Feb 2013 15:44:05 +0100
Cc: Fredrik Tolf <fredrik@dolda2000.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> (sfid-20130213_093936_125418_3540CD10)
In-Reply-To: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201302141544.05747.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 13. Februar 2013 schrieb Fredrik Tolf:
> Dear list,

Hi Fredrik,

> I'm sorry if this is a dumb n3wb question, but I couldn't find anything 
> about it, so please bear with me.
> 
> I just decided to try BtrFS for the first time, to replace an old ReiserFS 
> data partition currently on a mdadm mirror. To do so, I'm using two 3 TB 
> disks that were initially detected as sdd and sde, on which I have a 
> single large GPT partition, so the devices I'm using for btrfs are sdd1 
> and sde1.
> 
> I created a filesystem on them using RAID1 from the start (mkfs.btrfs -d 
> raid -m raid1 /dev/sd{d,e}1), and started copying the data from the old 
> partition onto it during the night. As it happened, I immediately got 
> reason to try out BtrFS recovery because sometime during the copying 
> operation /dev/sdd had some kind of cable failure and was removed from the 
> system. A while later, however, it was apparently auto-redetected, this 
> time as /dev/sdi, and BtrFS seems to have inserted it back into the 
> filesystem somehow.
> 
> The current situation looks like this:
> 
> > $ sudo ./btrfs fi show
> > Label: none  uuid: 40d346bb-2c77-4a78-8803-1e441bf0aff7
> >         Total devices 2 FS bytes used 1.64TB
> >         devid    1 size 2.73TB used 1.64TB path /dev/sdi1
> >         devid    2 size 2.73TB used 2.67TB path /dev/sde1
> > 
> > Btrfs v0.20-rc1-56-g6cd836d
> 
> As you can see, /dev/sdi1 has much less space used, which I can only 
> assume is because extents weren't allocated on it while it was off-line. 
> I'm now trying to remedy this, but I'm not sure if I'm doing it right.
> 
> What I'm doing is to run "btrfs fi bal start /mnt &", and it gives me a 
> ton of kernel messages that look like this:
> 
> Feb 12 22:57:16 nerv kernel: [59596.948464] btrfs: relocating block group 2879804932096 flags 17
> Feb 12 22:57:45 nerv kernel: [59626.618280] btrfs_end_buffer_write_sync: 8 callbacks suppressed
> Feb 12 22:57:45 nerv kernel: [59626.621893] lost page write due to I/O error on /dev/sdd1
> Feb 12 22:57:45 nerv kernel: [59626.621893] btrfs_dev_stat_print_on_error: 8 callbacks suppressed
> Feb 12 22:57:45 nerv kernel: [59626.621893] btrfs: bdev /dev/sdd1 errs: wr 66339, rd 26, flush 1, corrupt 0, gen 0
> Feb 12 22:57:45 nerv kernel: [59626.644110] lost page write due to I/O error on /dev/sdd1
> [Lots of the above, and occasionally a couple of lines like these]
> Feb 12 22:57:48 nerv kernel: [59629.569278] btrfs: found 46 extents
> Feb 12 22:57:50 nerv kernel: [59631.685067] btrfs_dev_stat_print_on_error: 5 callbacks suppressed
[…]
> Also, why does it say that the errors are occuring /dev/sdd1? Is it just 
> remembering the whole filesystem by that name since that's how I mounted 
> it, or is it still trying to access the old removed instance of that disk 
> and is that, then, why it's giving all these errors?

You started the balance after above btrfs fi show command?

Then its obvious to me:

For some reason BTRFS is still trying to write to /dev/sdd, which isn´t
there anymore. That perfectly explains those lost page writes for me. If
that is the case, this seems to me like a serious bug in BTRFS.

Also Hugo´s obversation point in that direction. At first I would take those
log messages literally. 

There is a chance that BTRFS still displays /dev/sdd while actually writing
to /dev/sdi, but, I doubt it. I think its possible to find this out by
using iostat -x 1 or atop or something like that. And if it does write to
the correct device file, I think it makes sense to update and fix those
log messages.

I´d restart the machine, see that BTRFS is using both devices again and
then try the balance again.

I´d do this while still having a backup on the ReiserFS volume or another
backup drive. After this I´d do a btrfs scrub start to see whether BTRFS
is happy with all the data on the drives.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
