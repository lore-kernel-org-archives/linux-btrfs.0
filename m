Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35412 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbcESSvI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 14:51:08 -0400
Received: by mail-qk0-f170.google.com with SMTP id n62so47579758qkc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 11:51:07 -0700 (PDT)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id 22sm7237361qkg.0.2016.05.19.11.51.05
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Thu, 19 May 2016 11:51:06 -0700 (PDT)
Subject: Re: Hot data tracking / hybrid storage
To: linux-btrfs@vger.kernel.org
References: <nh9p2p$cns$1@ger.gmane.org>
 <pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
 <20160516010524.7e208f96@jupiter.sol.kaishome.de>
 <nhedk2$dpq$1@ger.gmane.org> <0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
 <20160517203335.5ff99a05@jupiter.sol.kaishome.de>
 <nhir96$8n4$1@ger.gmane.org>
 <20160519200926.0a2b5dcf@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e8ff591f-751b-ac56-45bb-98cdc7b206e7@gmail.com>
Date: Thu, 19 May 2016 14:51:01 -0400
MIME-Version: 1.0
In-Reply-To: <20160519200926.0a2b5dcf@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-19 14:09, Kai Krakow wrote:
> Am Wed, 18 May 2016 22:44:55 +0000 (UTC)
> schrieb Ferry Toth <ftoth@exalondelft.nl>:
>
>> Op Tue, 17 May 2016 20:33:35 +0200, schreef Kai Krakow:
>>
>>> Am Tue, 17 May 2016 07:32:11 -0400 schrieb "Austin S. Hemmelgarn"
>>> <ahferroin7@gmail.com>:
>>>
>>>> On 2016-05-17 02:27, Ferry Toth wrote:
>>  [...]
>>  [...]
>>>>  [...]
>>  [...]
>>  [...]
>>  [...]
>>>> On the other hand, it's actually possible to do this all online
>>>> with BTRFS because of the reshaping and device replacement tools.
>>>>
>>>> In fact, I've done even more complex reprovisioning online before
>>>> (for example, my home server system has 2 SSD's and 4 HDD's,
>>>> running BTRFS on top of LVM, I've at least twice completely
>>>> recreated the LVM layer online without any data loss and minimal
>>>> performance degradation).
>>  [...]
>>>> I have absolutely no idea how bcache handles this, but I doubt
>>>> it's any better than BTRFS.
>>>
>>> Bcache should in theory fall back to write-through as soon as an
>>> error counter exceeds a threshold. This is adjustable with sysfs
>>> io_error_halftime and io_error_limit. Tho I never tried what
>>> actually happens when either the HDD (in bcache writeback-mode) or
>>> the SSD fails. Actually, btrfs should be able to handle this (tho,
>>> according to list reports, it doesn't handle errors very well at
>>> this point).
>>>
>>> BTW: Unnecessary copying from SSD to HDD doesn't take place in
>>> bcache default mode: It only copies from HDD to SSD in writeback
>>> mode (data is written to the cache first, then persisted to HDD in
>>> the background). You can also use "write through" (data is written
>>> to SSD and persisted to HDD at the same time, reporting persistence
>>> to the application only when both copies were written) and "write
>>> around" mode (data is written to HDD only, and only reads are
>>> written to the SSD cache device).
>>>
>>> If you want bcache behave as a huge IO scheduler for writes, use
>>> writeback mode. If you have write-intensive applications, you may
>>> want to choose write-around to not wear out the SSDs early. If you
>>> want writes to be cached for later reads, you can choose
>>> write-through mode. The latter two modes will ensure written data
>>> is always persisted to HDD with the same guaranties you had without
>>> bcache. The last mode is default and should not change behavior of
>>> btrfs if the HDD fails, and if the SSD fails bcache would simply
>>> turn off and fall back to HDD.
>>
>> Hello Kai,
>>
>> Yeah, lots of modes. So that means, none works well for all cases?
>
> Just three, and they all work well. It's just a decision wearing vs.
> performance/safety. Depending on your workload you might benefit more or
> less from write-behind caching - that's when you want to turn the knob.
> Everything else works out of the box. In case of an SSD failure,
> write-back is just less safe while the other two modes should keep your
> FS intact in that case.
>
>> Our server has lots of old files, on smb (various size), imap
>> (10000's small, 1000's large), postgresql server, virtualbox images
>> (large), 50 or so snapshots and running synaptics for system upgrades
>> is painfully slow.
>
> I don't think that bcache even cares to cache imap accesses to mail
> bodies - it won't help performance. Network is usually much slower than
> SSD access. But it will cache fs meta data which will improve imap
> performance a lot.
Bcache caches anything that falls within it's heuristics as candidates 
for caching.  It pays no attention to what type of data you're 
accessing, just the access patterns.  This is also the case for 
dm-cache, and for Windows ReadyBoost (or whatever the hell they're 
calling it these days).  Unless you're shifting very big e-mails, it's 
pretty likely that ones that get accessed more than once in a short 
period of time will end up being cached.
>
>> We are expecting slowness to be caused by fsyncs which appear to be
>> much worse on a raid10 with snapshots. Presumably the whole thing
>> would be fast enough with ssd's but that would be not very cost
>> efficient.
>>
>> All the overhead of the cache layer could be avoided if btrfs would
>> just prefer to write small, hot, files to the ssd in the first place
>> and clean up while balancing. A combination of 2 ssd's and 4 hdd's
>> would be very nice (the mobo has 6 x sata, which is pretty common)
>
> Well, I don't want to advertise bcache. But there's nothing you
> couldn't do with it in your particular case:
>
> Just attach two HDDs to one SSD. Bcache doesn't use a 1:1 relation
> here, you can use 1:n where n is the backing devices. There's no need
> to clean up using balancing because bcache will track hot data by
> default. You just have to decide which balance between wearing the SSD
> vs. performance you prefer. If slow fsyncs are you primary concern, I'd
> go with write-back caching. The small file contents are propably not
> your performance problem anyways but the meta data management btrfs has
> to do in the background. Bcache will help a lot here, especially in
> write-back mode. I'd recommend against using balance too often and too
> intensive (don't use too big usage% filters), it will invalidate your
> block cache and probably also invalidate bcache if bcache is too small.
> It will hurt performance more than you gain. You may want to increase
> nr_requests in the IO scheduler for your situation.
This may not perform as well as you would think, depending on your 
configuration.  If things are in raid1 (or raid10) mode on the BTRFS 
side, then you can end up caching duplicate data (and on some workloads, 
you're almost guaranteed to cache duplicate data), which is a bigger 
issue when you're sharing a cache between devices, because it means they 
are competing for cache space.
>
>> Moreover increasing the ssd's size in the future would then be just
>> as simple as replacing a disk by a larger one.
>
> It's as simple as detaching the HDDs from the caching SSD, replace it,
> reattach it. It can be done online without reboot. SATA is usually
> hotpluggable nowadays.
>
>> I think many would sign up for such a low maintenance, efficient
>> setup that doesn't require a PhD in IT to think out and configure.
>
> Bcache is actually low maintenance, no knobs to turn. Converting to
> bcache protective superblocks is a one-time procedure which can be done
> online. The bcache devices act as normal HDD if not attached to a
> caching SSD. It's really less pain than you may think. And it's a
> solution available now. Converting back later is easy: Just detach the
> HDDs from the SSDs and use them for some other purpose if you feel so
> later. Having the bcache protective superblock still in place doesn't
> hurt then. Bcache is a no-op without caching device attached.
No, bcache is _almost_ a no-op without a caching device.  From a 
userspace perspective, it does nothing, but it is still another layer of 
indirection in the kernel, which does have a small impact on 
performance.  The same is true of using LVM with a single volume taking 
up the entire partition, it looks almost no different from just using 
the partition, but it will perform worse than using the partition 
directly.  I've actually done profiling of both to figure out base 
values for the overhead, and while bcache with no cache device is not as 
bad as the LVM example, it can still be a roughly 0.5-2% slowdown (it 
gets more noticeable the faster your backing storage is).

You also lose the ability to mount that filesystem directly on a kernel 
without bcache support (this may or may not be an issue for you).
>
>> Even at home, I would just throw in a low cost ssd next to the hdd if
>> it was as simple as device add. But I wouldn't want to store my
>> photo/video collection on just ssd, too expensive.
>
> Bcache won't store your photos if you copied them: Large copy
> operations (like backups) and sequential access is detected and bypassed
> by bcache. It won't invalidate your valuable "hot data" in the cache.
> It works really well.
>
> I'd even recommend to format filesystems with bcache protective
> superblock (aka format backing device) even if you not gonna use
> caching and not gonna insert an SSD now, just to have the option for
> the future easily and without much hassle.
>
> I don't think native hot data tracking will land in btrfs anytime soon
> (read: in the next 5 years). Bcache is a general purpose solution for
> all filesystems that works now (and properly works).
>
> You maybe want to clone your current system and try to integrate bcache
> to see the benefits. There's actually a really big impact on
> performance from my testing (home machine, 3x 1TB HDD btrfs mraid1
> draid0, 1x 500GB SSD as cache, hit rate >90%, cache utilization ~70%,
> boot time improvement ~400%, application startup times almost instant,
> workload: MariaDB development server, git usage, 3 nspawn containers,
> VirtualBox Windows 7 + XP VMs, Steam gaming, daily rsync backups, btrfs
> 60% filled).
>
> I'd recommend to not use a too small SSD because it wears out very fast
> when used as cache (I think that generally applies and is not bcache
> specific). My old 120GB SSD was specified for 85TB write performance,
> and it was worn out after 12 months of bcache usage, which included 2
> complete backup restores, multiple scrubs (which relocates and rewrites
> every data block), and weekly balances with relatime enabled. I've
> since used noatime+nossd, completely stopped using balance and never
> used scrub yet, with the result of vastly reduced write accesses to the
> caching SSD. This setup is able to write bursts of 800MB/s to the disk
> and read up to 800MB/s from disk (if btrfs can properly distribute
> reads to all disks). Bootchart shows up to 600 MB/s during cold booting
> (with warmed SSD cache). My nspawn containers boot in 1-2 seconds and
> do not add to the normal boot time at all (they are autostarted during
> boot, 1x MySQL, 1x ElasticSearch, 1x idle/spare/testing container).
> This is really impressive for a home machine, and c'mon: 3x 1TB HDD +
> 1x 500GB SSD is not that expensive nowadays. If you still prefer a
> low-end SSD I'd recommend to use write-around only from my own
> experience.
>
> The cache usage of the 120GB of 100% with 70-80% hit rate, which means
> it was constantly rewriting stuff. 500GB (which I use now) is a little
> underutilized now but almost no writes happen after warming up, so it's
> mostly a hot-data read cache (although I configured it as write-back).
> Plus, bigger SSDs are usually faster - especially for write ops.
>
> Conclusion: Btrfs + bcache make a very good pair. Btrfs is not really
> optimized for good latency and that's where bcache comes in. Operating
> noise from HDD reduces a lot as soon as bcache is warmed up.
>
> BTW: If deployed, keep an eye on your SSD wearing (using smartctl). But
> given you are using btrfs, you keep backups anyways. ;-)
Any decent SSD (read as 'any SSD of a major brand other than OCZ that 
you bought from a reputable source') will still take years to wear out 
unless you're constantly re-writing things and not using discard/trim 
support (and bcache does use discard).   Even if you're not using 
discard/trim, the typical wear-out point is well over 100x the size of 
the SSD for the good consumer devices.  For a point of reference, I've 
got a pair of 250GB Crucial MX100's (they cost less than 0.50 USD per GB 
when I got them and provide essentially the same power-loss protections 
that the high end Intel SSD's do) which have seen more than 2.5TB of 
data writes over their lifetime, combined from at least three different 
filesystem formats (BTRFS, FAT32, and ext4), swap space, and LVM 
management, and the wear-leveling indicator on each still says they have 
100% life remaining, and the similar 500GB one I just recently upgraded 
in my laptop had seen over 50TB of writes and was still saying 95% life 
remaining (and had been for months).
