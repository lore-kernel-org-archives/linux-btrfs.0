From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v2 1/5] btrfs: add command to zero out superblock
Date: Wed, 2 May 2012 19:36:29 +0200
Message-ID: <20120502173629.GI6740@twin.jikos.cz>
References: <1335876033-12201-1-git-send-email-kario@wit.edu.pl>
 <20120502142843.GD6740@twin.jikos.cz>
 <2913005.FpWZk4H159@bursa01>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2913005.FpWZk4H159@bursa01>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 02, 2012 at 06:42:16PM +0200, Hubert Kario wrote:
> A similar function in mdadm is called zero superblock so I just re used the 
> name (according to the principle of least surprise). Users, even admins, 
> generally don't read kernel code...

I intended to point out that the functionality is there under different
name, but the 'least surprise' and tool compatibility plays for
'zero-superblock' naming.

> > I'm not sure if this is useful and sensible usecase, clearing superblock
> > is a one-time action anyway, so it's more for the sake of tool
> > flexibility.
> 
> Clearing superblock is not a light decision and should generally be performed 
> just before formatting the partition with some other fs or physical volume for 
> LVM. IMHO recoverability of "cleared" superblock is a function hardly anyone 
> would use.

googled, a few users asking about recovering from md zero-superblock, and
the solution was to recreate the array, md is said to be smart and
recognize traces of previous array and will not destroy it if the
parameters are same. Point for md, btrfs does not do this.

> > To your implementation: I think adding a function doing the superblock
> > reset would be enough here. Something like this (in pseudocode):
> > 
> > for (i = 0 ; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> > 	bytenr = btrfs_sb_offset(i);
> > 	"break if bytenr > device size"
> > 	memset(superblock buffer, CLEARPATTERN, sizeof(...))
> > }
> > write_all_supers(root);
> 
> That's exactly what btrfs_prepare_device does. And it's a function run by btfs 
> just before btrfs dev add and by mkfs. Duplicating its code would be a bad 
> idea.

Not 'exactly' IMO:

* calls TRIM/discard on the device
* zeroes first 2 megabytes
* zeroes all reachable superblocks
* zeroes last 2 megabytes

Too many undocumented and unobvious side-efects.

Code duplication can be avoided by factoring the 'zero superblock' into
a function and calling it from btrfs_prepare_device() .


david
