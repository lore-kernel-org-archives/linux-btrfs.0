Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53116 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbcHLENM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Aug 2016 00:13:12 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bY3qH-00046R-8G
	for linux-btrfs@vger.kernel.org; Fri, 12 Aug 2016 06:13:09 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: checksum error in metadata node - best way to move root fs to
 new drive?
Date: Fri, 12 Aug 2016 04:13:02 +0000 (UTC)
Message-ID: <pan$d5a3c$1341dd34$181da281$7419cf7d@cox.net>
References: <CAGdWbB5LX5KprZYQeUiyedoaN=ggPKesw9iXqFBWTuRKFn9cZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave T posted on Thu, 11 Aug 2016 16:23:45 -0400 as excerpted:

> I also have a few general questions:
> 
> 1. Can one discontinue using the compress mount option if it has been
> used previously? What happens to existing data if the compress mount
> option is 1) added when it wasn't used before, or 2) dropped when it had
> been used.

The compress mount option only affects newly written data.  Data that was 
previously written is automatically decompressed into memory on read, 
regardless of whether the compress option is still being used or not.

So you can freely switch between using the option and not, and it'll only 
affect newly written files.  Existing files stay written the way they 
are, unless you do something (like run a recursive defrag with the 
compress option) to rewrite them.

> 2. I understand that the compress option generally improves btrfs
> performance (via Phoronix article I read in the past; I don't find the
> link). Since encryption has some characteristics in common with
> compression, would one expect any decrease in performance from dropping
> compression when using btrfs on dm-crypt? (For more context,
> with an i7 6700K which has aes-ni, CPU performance should not be a
> bottleneck on my computer.)

Compression performance works like this (this is a general rule, not 
btrfs specific):  Compression uses more CPU cycles but results in less 
data to actually transfer to and from storage.  If your disks are slow 
and your CPU is fast (or if the CPU can use hardware accelerated 
compression functions), performance will tend to favor compression, 
because the bottleneck will be the actual data transfer to and from 
storage and the extra overhead of the CPU cycles won't normally matter 
while the effect of less data to actually transfer, due to the 
compression, will.

But the slower the CPU (and lack of hardware accelerated compression 
functions) is and the faster storage IO is, the less of a bottleneck the 
actual data transfer will be, and thus the more likely it will be that 
the CPU will become the bottleneck, particularly as the compression gets 
more efficient size-wise, which generally translates to requiring more 
CPU cycles and/or memory to handle it.

Since your storage is PCIE-3.0 @ > 1 GiB/sec, extremely fast, even tho LZO 
compression is considered fast (as opposed to size-efficient) as well, 
you may actually see /better/ performance without compression, especially 
when running CPU-heavy workloads where the extra CPU cycles of 
compression will matter as the CPU is already the bottleneck.

Since you're doing encryption also, and that too tends to be CPU 
intensive (even if it's hardware accelerated for you), I'd actually be a 
bit surprised if you didn't see an increase of performance without 
compression, because your storage /is/ so incredibly fast compared to 
conventional storage.

But of course if it's really a concern, there's nothing like actually 
benchmarking it yourself to see. =:^)  But I'd be very surprised if you 
actually notice a slowdown, turning compression off.  You might not 
notice a performance boost either, but I'd be surprised if you notice a 
slowdown, tho some artificial benchmarks might show one if they aren't 
balancing CPU and IO in something like real-world.

> 3. How do I find out if it is appropriate to use dup metadata on a
> Samsung 950 Pro NVMe drive? I don't see deduplication mentioned in the
> drive's datasheet:
> http://www.samsung.com/semiconductor/minisite/ssd/downloads/document/
Samsung_SSD_950_PRO_Data_Sheet_Rev_1_2.pdf

I'd google the controller.  A lot of them will list either compression 
and dedup as features as they enhance performance in some cases, or the 
stability of constant performance as a feature, as mine, targeted at the 
server market, did.  If the emphasis is on constant performance and what-
you-see-is-what-you-get storage capacity, then they're not doing 
compression and dedup, as that can increase performance and storage 
capacity under certain conditions, but it's very unpredictable as it 
depends on how much duplication the data has and how compressible it is.

Sandforce controllers, in particular, are known to emphasize compression 
and dedup.  OTOH, controllers targeted at enterprise or servers are 
likely to emphasize stability and predictability and thus not do 
transparent compression or dedup.

> 4. Given that my drive is not reporting problems, does it seem
> reasonable to re-use this drive after the errors I reported? If so,
> how should I do that? Can I simply make a new btrfs filesystem and copy
> my data back? Should I start at a lower level and re-do the dm-crypt
> layer?

I'd reuse it here.  For hardware that supports/needs trim I'd start at 
the bottom layer and work up, but IIRC you said yours doesn't need it, 
and by the time you get to the btrfs layer on top of the crypt layer, the 
hardware layer should be scrambled zeros and ones in any case, so if it's 
true your hardware doesn't need it, I'd guess you should be fine just 
doing the mkfs on top of the existing dmcrypted layer.

But I don't use a crypted layer here, so better to rely on others with 
experience with it, if you have their answers to rely on.

> 5. Would most of you guys use btrfs + dm-crypt on a production file
> server (with spinning disks in JBOD configuration -- i.e., no RAID).
> In this situation, the data is very important, of course. My past
> experience indicated that RAID only improves uptime, which is not so
> critical in our environment. Our main criteria is that we should never
> ever have data loss. As far as I understand it, we do have to use
> encryption.

I'd suggest, if the data is that important, do btrfs raid1.  Because 
unlike most raid, btrfs raid takes advantage of btrfs checksumming, and 
actually gives you a second copy to fall back on as well as to repair a 
bad copy, if the first copy tried fails the checksum test.  That level of 
run-time-verified data integrity and repair is something most raid 
systems don't have -- they'll only use the parity or redundancy to verify 
integrity if a device fails or if a scrub is done (and even with a scrub, 
in most cases at least for redundant-raid they simply blindly copy the 
one device to the others, no real integrity checking at all).  But 
because btrfs raid1 actually does that real-time integrity checking and 
repair, it's a lot stronger in use-cases where data integrity is 
paramount.

Tho do note that btrfs raid1 is ONLY two-copy, additional devices 
increase capacity, not redundancy.  So I'd create two crypted devices of 
roughly the same size out of your JBOD, and expose them to btrfs to use 
as a raid1.

Or if you want a cold-spare, create three crypted devices of about the 
same size, create a btrfs raid1 out of two of them, and keep the third in 
reserve to btrfs replace, if needed.

Tho as i said earlier, I don't personally trust btrfs on the crypted 
layer yet, so for me, I'd either use something other than btrfs, or use 
btrfs but really emphasize the backups, including testing them of course, 
because I /don't/ really trust btrfs on crypted just yet.  But based on 
earlier posts in this thread, I admit it's very possible that all the 
reported cases that are the basis for my not trusting btrfs on dmcrypt 
yet, were using btrfs compression, and it's possible /that/ was the real 
problem, and without it, things will be fine.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

