From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: strange btrfs sub list output
Date: Fri, 27 May 2011 12:30:10 +0100
Message-ID: <chaz20110527113010.GA12775@seebyte.com>
References: <20110526212203.GA4611@yahoo.fr> <chaz20110527080157.GA27537@seebyte.com> <4DDF5EEF.6060706@gmail.com> <chaz20110527084733.GC27537@seebyte.com> <20110527091224.GA15627@carfax.org.uk> <chaz20110527093029.GA30613@seebyte.com> <20110527094523.GA12089@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo@carfax.org.uk>,
	Andreas Philipp <philipp.andreas@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110527094523.GA12089@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

2011-05-27 10:45:23 +0100, Hugo Mills:
[...]
> > How could a "subvolume 285" become a "top level"?
> 
> > How does one get a subvolume with a top-level other than "5"?
> 
>    This just means that subvolume 287 was created (somewhere) inside
> subvolume 285.
> 
>    Due to the way that the FS trees and subvolumes work, there's no
> global namespace structure in btrfs; that is, there's no single data
> structure that represents the entirety of the file/directory hierarchy
> in the filesystem. Instead, it's broken up into these sub-namespaces
> called subvolumes, and we only record parent/child relationships for
> each subvolume separately. The "full path" you get from "btrfs subv
> list" is reconstructed from that information in userspace(*).
[...]

Thanks, I can understand that. What I don't get is how one
creates a subvol with a top-level other than 5. I might be
missing the obvious, though.

If I do:

btrfs sub create A
btrfs sub create A/B
btrfs sub snap A A/B/C

A, A/B, A/B/C have their top-level being 5. How would I get a
new snapshot to be a child of A/B for instance?

In my case, 285, was not appearing in the btrfs sub list output,
287 was a child of 285 with path "data" while all I did was
create a snapshot of 284 (path
u6:10022/vm+xfs@u8/xvda1/g8/v3/data in vol 5) in
u6:10022/vm+xfs@u8/xvda1/g8/v3/snapshots/2011-03-30

So I did manage to get a volume with a parent other than 5, but
I did not ask for it.

-- 
Stephane
