From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: strange btrfs sub list output
Date: Fri, 27 May 2011 09:47:33 +0100
Message-ID: <chaz20110527084733.GC27537@seebyte.com>
References: <20110526212203.GA4611@yahoo.fr> <chaz20110527080157.GA27537@seebyte.com> <4DDF5EEF.6060706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDF5EEF.6060706@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-05-27 10:21:03 +0200, Andreas Philipp:
[...]
> > What do those top-level IDs mean by the way?
> The top-level ID associated with a subvolume is NOT the ID of this
> particular subvolume but of the subvolume containing it. Since the
> "root/initial" (sub-)volume has always ID 0, the subvolumes of "depth"
> 1 will all have top-level ID set to 0. You need those top-level IDs to
> correctly mount a specific subvolume by name.
> 
> # mount /dev/dummy -o subvol=<subvolume>,subvolrootid=<top-level ID>
> /mountpoint
> 
> Of course, you do need them, if you specify the subvolume to mount by
> its ID.
[...]

Thanks Andreas for pointing that subvolrootid (might be worth
adding it to
https://btrfs.wiki.kernel.org/index.php/Getting_started#Mount_Options
BTW).

In my case, on a freshly made btrfs file system, subvolumes have
top-level 5. (and neither volume with id 0 or 5 appear in the
btrfs sub list).

All the top-levels are 5, and I don't even know how to create a
subvolume with a different top-level there, so I wonder how that
subvol that I had created with

btrfs sub snap data snapshots/2011-03-30

ending up being a subvolume with ID 285 that doesn't appear in
the "btrfs sub list" and contains a subvolume of "path" "data"
in there (with its top-level being 285). All the other
subvolumes and snapshots I've created in the exact same way are
created with a top-level 5 and have an entry in "btrfs sub list"
and don't have subvolumes of their own.

-- 
Stephane
