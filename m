Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48927 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1727187AbeITNbT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 09:31:19 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1g2tfp-000823-S1
        for linux-btrfs@vger.kernel.org; Thu, 20 Sep 2018 09:46:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: very poor performance / a lot of writes to disk with space_cache
 (but not with space_cache=v2)
Date: Thu, 20 Sep 2018 07:46:47 +0000 (UTC)
Message-ID: <pan$8a2d3$e62c6eb2$b0b216d6$e8a34c25@cox.net>
References: <e0f21dace16885d1bd615dd723235d57@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Wed, 19 Sep 2018 10:43:18 +0200 as excerpted:

> I have a mysql slave which writes to a RAID-1 btrfs filesystem (with
> 4.17.14 kernel) on 3 x ~1.9 TB SSD disks; filesystem is around 40% full.
> 
> The slave receives around 0.5-1 MB/s of data from the master over the
> network, which is then saved to MySQL's relay log and executed. In ideal
> conditions (i.e. no filesystem overhead) we should expect some 1-3 MB/s
> of data written to disk.
> 
> MySQL directory and files in it are chattr +C (since the directory was
> created, so all files are really +C); there are no snapshots.
> 
> 
> Now, an interesting thing.
> 
> When the filesystem is mounted with these options in fstab:
> 
> defaults,noatime,discard
> 
> 
> We can see a *constant* write of 25-100 MB/s to each disk. The system is
> generally unresponsive and it sometimes takes long seconds for a simple
> command executed in bash to return.
> 
> 
> However, as soon as we remount the filesystem with space_cache=v2 -
> writes drop to just around 3-10 MB/s to each disk. If we remount to
> space_cache - lots of writes, system unresponsive. Again remount to
> space_cache=v2 - low writes, system responsive.
> 
> 
> That's a huuge, 10x overhead! Is it expected? Especially that
> space_cache=v1 is still the default mount option?

The other replies are good but I've not seen this pointed out yet...

Perhaps you are accounting for this already, but you don't /say/ you are, 
while you do mention repeatedly toggling the space-cache options, which 
would trigger it so you /need/ to account for it...

I'm not sure about space_cache=v2 (it's probably more efficient with it 
even if it does have to do it), but I'm quite sure that space_cache=v1 
takes some time after initial mount with it to scan the filesystem and 
actually create the map of available free space that is the space_cache.

Now you said ssds, which should be reasonably fast, but you also say 3-
device btrfs raid1, with each device ~2TB, and the filesystem ~40% full, 
which should be ~2 TB of data, which is likely somewhat fragmented so 
it's likely rather more than 2 TB of data chunks to scan for free space, 
and that's going to take /some/ time even on SSDs!

So if you're toggling settings like that in your tests, be sure to let 
the filesystem rebuild its cache that you just toggled and give it time 
to complete that and quiesce, before you start trying to measure write 
amplification.

Otherwise it's not write-amplification you're measuring, but the churn 
from the filesystem still trying to reset its cache after you toggled it!


Also, while 4.17 is well after the ssd mount option (usually auto-
detected, check /proc/mounts, mount output, or dmesg, to see if the ssd 
mount option is being added) fixes that went in in 4.14, if the 
filesystem has been in use for several kernel cycles and in particular 
before 4.14, with the ssd mount option active, and you've not rebalanced 
since then, you may well still have serious space fragmentation from 
that, which could increase the amount of data in the space_cache map 
rather drastically, thus increasing the time it takes to update the 
space_cache, particularly v1, after toggling it on.

A balance can help correct that, but it might well be easier and should 
result in a better layout to simply blow the filesystem away with a 
mkfs.btrfs and start over.


Meanwhile, as Remi already mentioned, you might want to reconsider nocow 
on btrfs raid1, since nocow defeats checksumming and thus scrub, which 
verifies checksums, simply skips it, and if the two copies get out of 
sync for some reason...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
