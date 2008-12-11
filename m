From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs and hotplug, auto-assembly, auto-setup, ...
Date: Thu, 11 Dec 2008 08:14:51 -0500
Message-ID: <1229001291.22236.23.camel@think.oraclecorp.com>
References: <ac3eb2510812091002g7d7c163am55f44b188dea0ef6@mail.gmail.com>
	 <1228959014.21376.6.camel@think.oraclecorp.com>
	 <ac3eb2510812101808p4a2d3c12n70eddee64dc87106@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, Greg <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510812101808p4a2d3c12n70eddee64dc87106@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-12-11 at 03:08 +0100, Kay Sievers wrote:
[ ... ]

> I have the btrfs detection code in udev since while, to be able to
> test it, and I'm tracking the changes.
> 
> After the metadata is finalized, I will come up with a few working
> examples how we could make this information easily available, and
> possible integrate it into the tools, and we can decide what we think
> is the best.
> 
> One thing I like to check now, if I got it correctly - the volume that
> gets mounted has:
>   btrfs_super_block.fsid (the volume, may be used for mount-by-label)
>   btrfs_super_block.label (the volume, may be used for mount-by-label)

Yes

> 
> The devices the volume is assembled from, which can be several, have:
>   btrfs_super_block.dev_item.uuid (the device uuid, not used in userspace)
>   btrfs_super_block.dev_item.fsid (the volume uuid, matches
> btrfs_super_block.fsid)

Yes, that's right.  Just to confuse things a little more there's some
called a seed filesystem, so FS B can point to FS A and include all of
its devices.

But, this pointing happens inside the FS device tree and not at the
super block level.  It just points to the fs uuid, so I think your
existing setup will be sufficient.

-chris


