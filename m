From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Tuning of btrfs for throughput?
Date: Tue, 31 Jan 2012 08:59:35 +0000 (UTC)
Message-ID: <pan.2012.01.31.08.59.35@cox.net>
References: <CACyXjPxb3Ped7yvv5je_g76T+uDKKYkhC7t7MY_-GQK3WuTQ-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Richard Sharpe posted on Mon, 30 Jan 2012 11:35:31 -0800 as excerpted:

> I am interested in any feedback on tuning btrfs for throughput?
> 
> I am running on 3.2.1 and have set up btrfs across 11 7200RPM 1TB 3.5"
> drives. I told btrfs to mirror metadata and stripe data.
> 
> For my current simple throughput tests I am running dd with 256kiB
> blocks and 1M blocks (memory is 64Gib).
> 
> All tests are done with conv=fdatasync and then with and without
> oflags=direct.
> 
> I get around 800MB/s in the non DIRECTIO case, and around 430MB/s in the
> DIRECTIO case (which is pretty impressive it seems to me).
> 
> However, what I would like to know is are there any tuning parameters I
> can tweak to push the numbers up a bit?

AFAIK (just researching btrfs at this point, I'm not a dev and am not run 
it yet), the code is still in high enough flux that trying to fine tune 
for current performance isn't a particularly good idea as what's best now 
might not be best in a couple kernel cycles.

A rather big exception to that could be specific sizes.  Btrfs likes 
powers of two, and 1 TB (base-10) disks are obviously not 1 TiB, more 
like 930(-ish) GiB.  It may be that 896 GiB (512+256+128) sizing will 
give you slightly better performance than using the full 930-ish GiB 
drives.

You could also try playing around with the various mkfs.btrfs size 
parameters, --alloc-start, --leafsize, --nodesize, and --sectorsize.

More stable than fine-tuning btrfs tweaks at this point would probably be 
partition alignment on the physical disk, and general kernel vfs 
parameters.

Many modern disks use 4 KiB physical sectors while still using 512-byte 
logical sectors for compatibility.  Getting the alignment exactly right 
with them can make a *BIG* difference in performance.  Using a good 
partitioner (such as gptfdisk, aka gdisk, for gpt-based partitioning, as 
opposed to the old mbr-base partitioning), you should be able to select 
alignment.  Alternatively, you can use the mkfs.btrfs --alloc-start 
parameter mentioned above to realign btrfs data structures within a 
larger partition or the unpartitioned full disk.  It's worth noting that 
due to MS compatibility efforts, sometimes 4 KiB physical sector disks 
are themselves offset, so you can't simply align to 4 KiB and call it 
good, for best performance you'd need to test 4 KiB blocks at each of the 
512-byte logical sector boundaries.  If you have such disks, one of those 
alignments should be measurably better than all the others, perhaps by 
several times!

Kernel vfs parameters... that's a discussion for elsewhere.

> I see lots of idle time (80+%) on my 16 cores (probably two by four by
> two).

If you're willing to trade CPU cycles for I/O bandwidth, definitely 
investigate btrfs' mount-time compression options!  zlib-based 
compression is the older and more stable one, lzo compression is newer 
and faster, but not as good a compression ratio.  It's the default when 
compression is enabled in newer kernels.  Google's snappy compression is 
the newest option, generally as fast as lzo with the compression of zlib, 
but I'm not sure whether it's available in kernel 3.2 yet.  There has 
been recent discussion on-list of a fourth option, IDR the name, but it's 
supposedly faster than snappy at about the same compression ratio.

But zlib should give you the better compression currently and is more 
mature, so I'd recommend it as long as I/O is the bottleneck, not CPU.

There's a number of other performance-tuning mount options with various 
tradeoffs.  Since you're striping data, performance apparently overrides 
data integrity for you, so nodatasum may be of interest.  nobarrier is 
another "unsafe but boosts performance" option.  One more in this 
category, notreelog.  Consider nodatacow as well, altho if you're doing a 
lot of copying, copy-on-write may in fact be higher performing due to not 
needing to actually write so much.

A small/zero number for max_inline=<number> could increase performance, 
at the expense of space, just how much space will depend on mkfs-time 
parameters.  space_cache and inode_cache should increase performance, 
altho it's worth noting that inode_cache will probably slow it down on 
the first run after enabling, where it wasn't enabled before.  noacl may 
be appropriate as well, if you don't need ACLs for security reasons.  
thread_pool=<number> may be useful as well with 16-way SMP, but I don't 
know the default so couldn't say for sure.

The above mount-options list is from the wiki's getting started page.  
The mount options section is at the bottom, below all the distro-specific 
stuff.

https://btrfs.wiki.kernel.org/articles/g/e/t/Getting_started.html

Of course, the not-btrfs-specific noatime,nodiratime mount options apply 
too, but you probably already knew or at least figured that.

> Would I be better of with 10 drives rather than 11, or 12 rather than
> 11?

I'm not sure on this, but it's possible that an even number of drives may 
work slightly better given the metadata mirroring.

Other than that, basic RAID bus logic applies; the optimum number of 
drives depend on your data bus topology.  If your data buses are 
saturated, adding more drives won't help, but a bus can typically handle 
several spinning media drives before saturation.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

