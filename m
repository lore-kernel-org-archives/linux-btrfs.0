Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33059 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754021AbdIZTvH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 15:51:07 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dwvsX-0007a2-Py
        for linux-btrfs@vger.kernel.org; Tue, 26 Sep 2017 21:50:49 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Give up on bcache?
Date: Tue, 26 Sep 2017 21:50:49 +0200
Message-ID: <20170926215049.5535be8b@jupiter.sol.kaishome.de>
References: <oqe0fo$keo$1@blaine.gmane.org>
        <20170926233319.6324764d@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 26 Sep 2017 23:33:19 +0500
schrieb Roman Mamedov <rm@romanrm.net>:

> On Tue, 26 Sep 2017 16:50:00 +0000 (UTC)
> Ferry Toth <ftoth@telfort.nl> wrote:
> 
> > https://www.phoronix.com/scan.php?page=article&item=linux414-bcache-
> > raid&num=2
> > 
> > I think it might be idle hopes to think bcache can be used as a ssd
> > cache for btrfs to significantly improve performance..  
> 
> My personal real-world experience shows that SSD caching -- with
> lvmcache -- does indeed significantly improve performance of a large
> Btrfs filesystem with slowish base storage.
> 
> And that article, sadly, only demonstrates once again the general
> mediocre quality of Phoronix content: it is an astonishing oversight
> to not check out lvmcache in the same setup, to at least try to draw
> some useful conclusion, is it Bcache that is strangely deficient, or
> SSD caching as a general concept does not work well in the hardware
> setup utilized.

Bcache is actually not meant to increase benchmark performance except
for very few corner cases. It is designed to improve interactivity and
perceived performance, reducing head movements. On the bcache homepage
there's actually tips on how to benchmark bcache correctly, including
warm-up phase and turning on sequential caching. Phoronix doesn't do
that, they test default settings, which is imho a good thing but you
should know the consequences and research how to turn the knobs.

Depending on the caching mode and cache size, the SQlite test may not
show real-world numbers. Also, you should optimize some btrfs options
to work correctly with bcache, e.g. force it to mount "nossd" as it
detects the bcache device as SSD - which is wrong for some workloads, I
think especially desktop workloads and most server workloads.

Also, you may want to tune udev to correct some attributes so other
applications can do their detection and behavior correctly, too:

$ cat /etc/udev/rules.d/00-ssd-scheduler.rules
ACTION=="add|change", KERNEL=="bcache*", ATTR{queue/rotational}="1"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/iosched/slice_idle}="0"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

Take note: on a non-mq system you may want to use noop/deadline/cfq
instead of kyber/bfq.


I'm running bcache since over two years now and the performance
improvement is very very high with boot times going down to 30-40s from
3+ minutes previously, faster app startup times (almost instantly like
on SSD), reduced noise by reduced head movements, etc. Also, it has
easy setup (no split metadata/data cache, you can attach more than one
device to a single cache), and it is rocksolid even when crashing the
system.

Bcache learns by using LRU for caching: What you don't need will be
pushed out of cache over time, what you use, stays. This is actually a
lot like "hot data caching". Given a big enough cache, everything of
your daily needs would stay in cache, easily achieving hit ratios
around 90%. Since sequential access is bypassed, you don't have to
worry to flush the cache with large copy operations.

My system uses a 512G SSD with 400G dedicated to bcache, attached to 3x
1TB HDD draid0 mraid1 btrfs, filled with 2TB of net data and daily
backups using borgbackup. Bcache runs in writeback mode, the backup
takes around 15 minutes each night to dig through all data and stores
it to an internal intermediate backup also on bcache (xfs, write-around
mode). Currently not implemented, this intermediate backup will later
be mirrored to external, off-site location.

Some of the rest of the SSD is EFI-ESP, some swap space, and
over-provisioned area to keep bcache performance high.

$ uptime && bcache-status
 21:28:44 up 3 days, 20:38,  3 users,  load average: 1,18, 1,44, 2,14
--- bcache ---
UUID                        aacfbcd9-dae5-4377-92d1-6808831a4885
Block Size                  4.00 KiB
Bucket Size                 512.00 KiB
Congested?                  False
Read Congestion             2.0ms
Write Congestion            20.0ms
Total Cache Size            400 GiB
Total Cache Used            400 GiB     (100%)
Total Cache Unused          0 B (0%)
Evictable Cache             396 GiB     (99%)
Replacement Policy          [lru] fifo random
Cache Mode                  (Various)
Total Hits                  2364518     (89%)
Total Misses                290764
Total Bypass Hits           4284468     (100%)
Total Bypass Misses         0
Total Bypassed              215 GiB


The bucket size and block size was chosen to best fit with Samsung TLC
arrangement. But this is pure theory, I never benchmarked the benefits.
I just feel more comfortable that way. ;-)


One should also keep in mind: The way how btrfs works cannot optimally
use bcache, as cow will obviously invalidate data in bcache - but
bcache doesn't have knowledge of this. Of course, such data will be
slowly pushed out of bcache but it will never contribute to potential
free cache space. On the other hand, write-back caching in bcache
greatly benefits cow workloads how btrfs does them for similar reasons:
Most metadata writes will go to bcache and return fast, resulting in
fewer head movements. You can improve both details by throwing a bigger
SSD at bcache.

Some people also argue that a writeback cache is a better guarantee in
case of a system crash, because the data will be persisted much faster,
thus more data had the chance to be written before a crash. Bcache is
safe in this mode: It is designed to survive such crashes and just
replays all missing writes to the harddisk upon system recovery. Just
don't ever detach such a dirty writeback cache: From user mode view
everything is seen through bcache and transactional guarantees are in
place, but from storage layer view, bcache is a huge reordering
write-behind cache ignoring transactions. I think LVM cache is very
similar here. I've gone with bcache because it is very much less likely
to shoot yourself in the foot when messing around with the caching
layer. And I think, by that time, bcache also had better crash
guarantees (by being designed to be dirty on both clean and unclean
shutdowns).


-- 
Regards,
Kai

Replies to list-only preferred.

