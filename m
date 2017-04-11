Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:39256 "EHLO
        torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752733AbdDKHeK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 03:34:10 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
        (envelope-from <mh+linux-btrfs@zugschlus.de>)
        id 1cxq1U-0000rS-0T
        for linux-btrfs@vger.kernel.org; Tue, 11 Apr 2017 09:15:32 +0200
Date: Tue, 11 Apr 2017 09:15:31 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs won't mount any more
Message-ID: <20170411071531.GK3699@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have wrecked another btrfs file system, probably for good this time.

It's a 80 GB filesystem from 2015, in my secondary notebook, on an
encrypted SSD. The btrfs holds the root filesystem and the rest of the
system as well.

I have a cronjob that makes snapshots of the system directories daily,
and of /home every ten minutes. A second cronjob cleans up old snapshots
so that the number of snapshots present is about between 400 and 600.
This is the key feature that made me decide for btrfs in the first
place.

Last week (I was on kernel 4.10.8 with Debian unstable), I was forced to
promote the secondary laptop to the primary one which resulted in
serious work being done on the first time. Over time, the filesystem
filled up without me noticing and was finally 100% full.

I then cleaned up about four gigs by deleting a couple of redundant ISO
images and some snapshots that were not due for regular deletion yet. I
then started a btrfs balance / -d50, unfortunately without stopping the
snapshot-making cronjob. This resulted in the notebook becoming
unuseable for extended periods of time, without even being able to log
in. After running for some 30 hours, the notebook ran out of battery
(don't ask, stupid me).

After rebooting, the btrfs balance proceeded immediately after mounting
the root fs. System unuseable again. After a day, I finally had a root
shell and was able to issue a btrfs cancel /. Unfortunately, the system
didn't care about that command and happily continued to balance. After
some more 30 hours, I lost patience and resetted the system.

To be able to keep control of the system and to monitor operations from
remote, I installed a fresh copy of Debian unstable with the same 4.10.8
kernel on an USB stick and booted the notebook from the stick. I brought
up the system and tried to mount the btrfs. The mount process quickly
went up to 100 % CPU usage and stayed that way until I went to bed last
night. This morning, the machine had dropped off the network (couldn't
ping the default gateway any more despite the network looked fine), and
spewed kernel oopses of about 80 lines (too long to scroll back even)
every few seconds.

I will try to tweak kernel.printk tonight so that I get my console back
and see whether the oopses are also in journal, dmesg or syslog so that
I can copypaste them. I also have a reasonably current backup of the
filesystem so nuking it from orbit is an option, I would however hate
losing my snapshots.

Is it worthwhile to save information about the borked filesystem, or
does the btrfs community just dont care about a heavily snapshotted two
years old filesystem?

I would like to hear comments and opinions about what has happened here
and how to avoid things like that in the future. Do more recently
created btrfs filesystems have safeguards against damage that may occur
when a filesystem fills up?

Greetings
Marc


-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
