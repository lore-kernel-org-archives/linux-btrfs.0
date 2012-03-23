From: Bob McElrath <bob@mcelrath.org>
Subject: Re: heterogeneous raid1
Date: Fri, 23 Mar 2012 17:35:39 +0000
Message-ID: <20120323173539.GC11099@mcelrath.org>
References: <20120323061159.GA11099@mcelrath.org>
 <20120323164435.4c21f92e@natsu>
 <20120323164932.GB11099@mcelrath.org>
 <20120323231307.283be0fb@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120323231307.283be0fb@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov [rm@romanrm.ru] wrote:
> On Fri, 23 Mar 2012 16:49:32 +0000
> Aye, but I consider space used for redundancy to be wasted as well, especially
> when the same (or even higher) amount of redundancy can be achieved by spending
> less storage space on it.

Point taken.  So how's the btrfs raid6 implementation coming along?  ;)

> Again no argument here, just wanted to throw the link out there as it was an
> eye opener for me, and for my primary storage I currently use a 6-member RAID6
> consisting of 5x 2TB physical disks and a 2TB RAID0 from 1.5TB+500GB (yes,
> mdadm can also do RAID0 of differently-sized drives! it'll stripe while it
> can, and after that it's just the tail of the larger drive).

I actually came up with that same algorithm, before switching to the simpler
raid1 arrangement.  The former provides more redundancy, at the expense of a
*lot* more complexity.  Having rebuilt raid arrays by hand, it's not so
difficult to make a mistake there, and nuke your array, rendering your fancy
2-disk failure protection moot.  e.g. one can also issue the wrong set of
commands to btrfs and zero the superblock by accident (or so I read)...in my
case it was a motherboard that rearranged sda/sdb/sdc on each boot, and older
mdadm which didn't handle that gracefully.  If that author had provided some
nice scripts that do what he described, I'd test it, but I didn't see any...

In my proposal I'm unhappy to have to use lvm at all, and would like to remove
that dependency, in the interest of fewer chances to fuck up during a
failure/rebuild.

I'm still dreaming of a fs/admin tool that I can throw disks at, and not have to
spend so much time with the details of partitioning/raid/lvm/fs.  Imagine a
"pool" with check-boxes for how much redundancy you want, and it tells you how
much space you'll have.

--
Cheers, Bob McElrath

"The individual has always had to struggle to keep from being overwhelmed by
the tribe.  If you try it, you will be lonely often, and sometimes frightened.
But no price is too high to pay for the privilege of owning yourself." 
    -- Friedrich Nietzsche
