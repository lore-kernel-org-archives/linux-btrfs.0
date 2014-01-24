Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46956 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbaAXUOt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 15:14:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W6n9H-0000Yg-Fx
	for linux-btrfs@vger.kernel.org; Fri, 24 Jan 2014 21:14:43 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 21:14:43 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 21:14:43 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Options for SSD - autodefrag etc?
Date: Fri, 24 Jan 2014 21:14:21 +0100
Message-ID: <t5uara-vp4.ln1@hurikhan77.spdns.de>
References: <52E19667.6090005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

KC <conrad.francois.artus@googlemail.com> schrieb:

> I was wondering about whether using options like "autodefrag" and
> "inode_cache" on SSDs.
> 
> On one hand, one always hears that defragmentation of SSD is a no-no,
> does that apply to BTRFS's autodefrag?
> Also, just recently, I heard something similar about "inode_cache".
> 
> On the other hand, Arch BTRFS wiki recommends to use both options on SSDs
>   http://wiki.archlinux.org/index.php/Btrfs#Mount_options
> 
> So to clear things up, I ask at the source where people should know best.
> 
> Does using those options on SSDs gives any benefits and causes
> non-negligible increase in SSD wear?

I'm not an expert, but I wondered myself. And while I still have not SSD yet 
I would prefer turning autodefrag on even for SSD - at least when I have no 
big write-intensive files on the device (but you should plan your FS to not 
have those on a SSD anyways) because btrfs may rewrite large files on SSD 
just for the purpose of autodefragging. I hope that will improve soon, maybe 
by only defragging parts of the file given some sane thresholds.

Why I decided I would turn it on? Well, heavily fragmented files give a 
performance overhead, and btrfs tends to fragment files fast (except for the 
nodatacow mount flag with its own downsides). An adaptive online defrag 
ensures you gain no performance loss due to very scattert extents. And: 
Fragmented files (or let's better say fragmented free space) increases 
write-amplification (at least for long-living filesystems) because when 
small amounts of free space are randomly scattered all over the device the 
filesystem has to fill these holes at some point in time. This decreases 
performance because it has to find these holes and possibly split batched 
write requests, and it potentially decreases life-time of your SSD because 
the read-modify-write-erase cycle takes action in more places than what 
would be needed if the free space hole had just been big enough. I don't 
know how big erase blocks [*] are - but think about it. You will come to the 
conclusion that it will reduce life-time.

So it is generally recommended to defragment heavily fragmented files, leave 
alone the not-so-heavily fragmented files and coalesce free space holes into 
bigger free space areas on a regular basis. I think, an effective algorithm 
could coalesce free space into bigger areas of freespace and as a side 
effect simply defragment those files whose parts had to be moved anyways to 
merge free space. During this process, a trim should be applied.

I wonder if btrfs will optimize for this use case in the future...

All in all, I'd say: Defragmenting a SSD is not that bad if done right, and 
if done right it will even improve life-time and performance. And I believe 
this is why the wiki recommends it. I'd recommend combining it with 
compress=lzo or maybe even compress-force=lzo (unless your SSD firmware does 
compression) - it should give a performance boost and reduces writes to your 
SSD. YMMV - so do your (long-term) benchmarking.

If performance and life-time is a really big concern then only partition and 
ever use 75% of your device and leave the rest of it untouched so it can be 
used as spare area for wear-levelling [**]. It will give you a good long-
term performance and should increase life-time.

[*] Erase blocks are usually much much bigger than the block size you can 
read and write data at. Flash memory cannot be overwritten, it is 
essentially write-once-read-many, so it needs to be erased. This is where 
the read-modify-write-erase cycle comes from and why wear-leveling is 
needed: Read the whole erase block, modify it with your data block, write it 
to a new location, erase and free the old block. So you see: Writing just 4k 
can result in (128k-4k) read, 128k written, 128k erased (so something like a 
write-amplification factor of 64), given an erase block size of 128k. Do 
this a lot and randomly scattered, and performance and life-time will suffer 
a lot. The SSD firmware will try to buffer as much data as possible before 
the read-modify-write-erase-cycle kicks in to decrease the bad effects of 
random writes. So a block-sorting scheduler (deadline instead of noop) and 
increasing nr_requests may be a good idea. This is also why you may want to 
look into filesystems that turn random writes into sequential writes like 
f2fs or why you may want to use bcache which also turns random writes into 
sequential writes for the cache device (your SSD).

[**] This ([*]) is why you should keep a spare area...

These are just my humble thoughts. You see: The topic may be a lot more 
complex than just saying "use noop scheduler" and "SSD needs no 
defragmentation". I think those statements are just plain wrong.

-- 
Replies to list only preferred.

