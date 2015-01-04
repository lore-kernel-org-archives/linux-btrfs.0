Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47700 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbbADKjZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Jan 2015 05:39:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y7iag-0005iY-Q4
	for linux-btrfs@vger.kernel.org; Sun, 04 Jan 2015 11:39:22 +0100
Received: from battery.modeemi.fi ([130.230.72.137])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 11:39:22 +0100
Received: from flux-btrfs by battery.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 11:39:22 +0100
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: possible bug in balance
Date: 04 Jan 2015 12:39:09 +0200
Message-ID: <m49h9w696eq.fsf@battery.modeemi.fi>
References: <1377898232.24181420209516734.JavaMail.root@shiva> <1256750348.24201420209749292.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

luvar@plaintext.sk writes:

Hello,

> luvar@blackdawn:~$ sudo time btrfs balance start -dconvert=raid1 -dusage=20 /home/luvar/programs/

> Am I doing something forbidden (I have not see any structure where
> raid type is stored per file/subvolume item), or I just hit some
> problem? What should I try?

btrfs doesn't yet support per-subvolume RAID1 levels. I'm not sure how
it should behave with your command line. It probably tries to
rebalance the whole filesystem.

> Than I wanted to convert to raid1 also some data (with balance
> filter) and try if there is some speedup when reading files
> (starting programs)...

Though I can already tell that no, there won't be a speedup, as btrfs
scheduler chooses the device to access by using the process id as a
seed. Therefore a single thread is never able to use 100% RAID1 input
capability. Perhaps in future there will be more sophisticated
schedulers. You may try to use MD raid1 for extra speed, but you would
lose the automatic error recovery of btrfs (but you would still notice
if data gets corrupted).

> [ 8159.300427] attempt to access beyond end of device
> [ 8159.300434] sdb2: rw=1041, want=480110048, limit=473956352
> [ 8159.300440] btrfs: bdev /dev/sdb2 errs: wr 638628, rd 65867, flush 0, corrupt 0, gen 0

I have noticed that 'attempt to access beyond end of device' typically
indicates (with other file systems, I haven't seen that with btrfs)
that the partition table and the filesystem size don't
match. Typically such a situation could occur when one modifies
partition table after creating the file system, though I'm sure there
are other ways to get into such a situation. You may find the
filesystem size with btrfs filesystem show and partition sizes with
cat /proc/partitions (multiply by block size = 1024 bytes).

Should the partition sizes and filesystem sizes match, I would be
quite certain this would indeed be a btrfs bug. But,

> root@blackdawn:/home/luvar# uname -a
> Linux blackdawn 3.13.0-30-generic #55-Ubuntu SMP Fri Jul 4 21:40:53 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
> root@blackdawn:/home/luvar# btrfs v
> Btrfs v0.20-rc1-189-g704a08c

should this turn out to be a bug, I'm certain trying a more recent
kernel version is a terrific idea :). 3.18.x or 3.17.y where y>2 (I
think those were the two versions that were bad in 3.17
series..). They won't have support for raid1'n a subvolume either,
though, as far as I know.

Remember backups :).

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

