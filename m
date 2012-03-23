From: Bob McElrath <bob@mcelrath.org>
Subject: Re: heterogeneous raid1
Date: Fri, 23 Mar 2012 16:49:32 +0000
Message-ID: <20120323164932.GB11099@mcelrath.org>
References: <20120323061159.GA11099@mcelrath.org>
 <20120323164435.4c21f92e@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120323164435.4c21f92e@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov [rm@romanrm.ru] wrote:
> On Fri, 23 Mar 2012 06:11:59 +0000
> Bob McElrath <bob@mcelrath.org> wrote:
> 
> > http://superuser.com/questions/387851/a-zfs-or-lvm-or-md-redundant-heterogeneous-storage-proposal/388536
> > 
> > In a nutshell: organize your heterogenous disks into two "halves", the sum of
> > which are of roughly equal size, and create a raid1 array across those two
> > halves.
> 
> This seems to be an extremely simplistic concept and also a very inefficient
> use of storage space, while not even providing enough redundancy (can't
> reliably tolerate an any-two-disks failure even).
>
> I suggest that you go with http://linuxconfig.org/prouhd-raid-for-the-end-user
> instead. Depending on how many drives you have, the widest portion can be raid
> 6, then decreasing to RAID5 for the second stage, then finally to RAID1 for
> the tail.

The algorithm I proposed wastes a lot less space.  The above article wastes 2Tb
in his first example, while mine would waste 0 in a raid1.  (2Tb+1Tb+1Tb) and
4Tb in raid1.

And I've chosen not to worry about 2-disk failures.

> Also remember that with MD you can also create arrays from arrays. So e.g. a
> RAID0 of two 500GB members can join a RAID6 of 1TB members. More on this idea:
> http://louwrentius.com/blog/2008/08/building-a-raid-6-array-of-mixed-drives/

I'm aware of that, and decided against it.  The way btrfs does things is the way
of the future.  Using multiple raids there are so many layers (md+md+lvm+btrfs)
that it becomes an administration nightmare, and I've had enough of rebuilding
raid arrays by hand for one lifetime.

--
Cheers, Bob McElrath

"The individual has always had to struggle to keep from being overwhelmed by
the tribe.  If you try it, you will be lonely often, and sometimes frightened.
But no price is too high to pay for the privilege of owning yourself." 
    -- Friedrich Nietzsche
