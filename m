Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47506 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaDUGyz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 02:54:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wc87u-00030l-CD
	for linux-btrfs@vger.kernel.org; Mon, 21 Apr 2014 08:54:50 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Apr 2014 08:54:50 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Apr 2014 08:54:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs fi df "unknown" chunk type
Date: Mon, 21 Apr 2014 06:54:38 +0000 (UTC)
Message-ID: <pan$990fd$3f2660a7$39c8f9c6$1ab46bd7@cox.net>
References: <9C28A5D6-F223-400F-9471-85C0F88FA939@colorremedies.com>
	<1B7A7ABD-FF67-4ED0-A5E8-F24C0BBA4B0D@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 20 Apr 2014 14:26:37 -0600 as excerpted:

> On Apr 20, 2014, at 2:18 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> What is unknown?
> 
> 
> /dev/sd[bcd] are 2GB, 3GB, and 4GB respectively.
> 
> [root@localhost ~]# mkfs.btrfs -d raid0 -m raid1 /dev/sd[bcd]

[...]

> [root@localhost ~]# mount /dev/sdb /mnt
> [root@localhost ~]# btrfs fi show
> Label: none  uuid: ff85abb0-3398-40a0-b06c-8146cb1bfda0
> 	Total devices 3 FS bytes used 112.00KiB
> 	devid    1 size 2.00GiB used 787.94MiB path /dev/sdb
> 	devid    2 size 3.00GiB used 315.19MiB path /dev/sdc
> 	devid    3 size 4.00GiB used 775.94MiB path /dev/sdd
> 
> [root@localhost ~]# btrfs fi df /mnt
> Data, RAID0: total=921.56MiB, used=256.00KiB
> Data, single: total=8.00MiB, used=0.00
> System, RAID1: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=460.75MiB, used=112.00KiB
> Metadata, single: total=8.00MiB, used=0.00
> unknown, single: total=16.00MiB, used=0.00

I have no clue /what/ that unknown is.  If I didn't see the
mkfs.btrfs right above, I'd guess it was filesystem damage
of some sort, but with the mkfs.btrfs, and with all three
devices very specifically trimmed, I haven't the foggiest.

Meanwhile...

> [root@localhost ~]# btrfs balance start /mnt
> Done, had to relocate 6 out of 6 chunks

Count.  There's 7 items listed above including unknown.
Only 6 of 6 chunks relocated.

Conclusion given the below, balance didn't touch that
unknown at all!

> [root@localhost ~]# btrfs fi show
> Label: none  uuid: ff85abb0-3398-40a0-b06c-8146cb1bfda0
> 	Total devices 3 FS bytes used 384.00KiB
> 	devid    1 size 2.00GiB used 0.00 path /dev/sdb
> 	devid    2 size 3.00GiB used 288.00MiB path /dev/sdc
> 	devid    3 size 4.00GiB used 1.19GiB path /dev/sdd
> 
> [root@localhost ~]# btrfs fi df /mnt
> Data, single: total=928.00MiB, used=256.00KiB
> System, RAID1: total=32.00MiB, used=16.00KiB
> Metadata, RAID1: total=256.00MiB, used=112.00KiB
> unknown, single: total=16.00MiB, used=0.00
> 
> 
> An unknown chunk type here too, exists even after a balance.
> Along with a weird allocation different merely due to
> balancing an empty file system.

As I concluded above, unknown untouched by the balance.

The different allocation (raid0 to single) with the
empty-filesystem balance is I believe a known issue.

Meanwhile, based on those numbers, we have

* data single 928 MiB, as one chunk on the 4G (largest) device

* system and metadata raid1 32 + 256 = 288 MiB on each of the
two largest devices (3G and 4G).

* 928 + 256 + 32 = 1216 MiB / 1024 = 1.1875 GiB
= show reported usage, 4G device

* 256 + 32 = 288 MiB, show reported usage, 3G device

* show doesn't seem to report the 16 MiB "unknown" on
any of the three



Out of curiosity...

What does a btrfs balance start -v (verbose) report?

What about btrfs scrub  start -BdR (no-background,
per-device, raw stats)?

What about btrfs check?  (Obviously without the --repair,
so it's read-only)

Of course both the command output and the related dmesg,
if any, for all the above.

And... given the existence of that strange unknown
even after the mkfs.btrfs trims... Does a badblocks
run (with either -n or -w and -v) turn up anything strange?

I'd ask about smartctl -A if it wasn't virtual...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

