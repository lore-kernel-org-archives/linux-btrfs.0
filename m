Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093AbbIWR3I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 13:29:08 -0400
Date: Wed, 23 Sep 2015 19:28:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, dsterba@suse.cz,
        Hugo Mills <hugo@carfax.org.uk>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
Message-ID: <20150923172810.GD12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com>
 <5601596B.1020607@googlemail.com>
 <20150922134131.GH5918@carfax.org.uk>
 <20150922142333.GH12815@twin.jikos.cz>
 <20150922143602.GI5918@carfax.org.uk>
 <20150923131226.GA12815@twin.jikos.cz>
 <5602A6EA.8050107@gmx.com>
 <5602A9F8.80802@gmail.com>
 <5602B06C.8020600@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5602B06C.8020600@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 23, 2015 at 10:00:12PM +0800, Qu Wenruo wrote:
> As it's already planned, and I think it will need new incompact flag 
> anyway, or old kernel can easily remove/convert desired profile.

The usecase with the old kernel is colser to the rescue scenario than
regular use. We do have support for read-only compatibility (grep for
COMPAT_RO), so all of this might be covered by such an incompat flag.

> So what about adding new ROOT_ITEM members to record data/meta profile?

The profile is not the only property we'd like to add. It is be possible
to add it to btrfs_root_item in a safe way, like the new send related
items.

> I'm not a big fan to use xattr and it's quite easy to modify from user 
> space, and not completely confident with the possible concurrency about 
> xattr modification with chunk allocation.

The point is to be able to modify it from the userspace, but it's done
in a safe way. The xattrs are in their own namespace and have handlers
taht propagate the changes anywhere it's needed. The idea is to cache
the values along the in-memory structures and only update them via the
handlers.

> And from the logical level, xattr is at the same level as inode, but 
> subvolume is definitely at a higher level, even it's normally treated as 
> directory.
> So for me, I'd like to record it into root_item, not as sub xattr, even 
> it may need an extra ioctl to handle it.

The xattrs give us extensibility that does not require changes in the
size of root_item structure. Basically, the unknown and unsupported
xattrs (properties) are invisible in the b-tree.

> Anyway, I'm just a new comer for this feature, it's completely OK to 
> ignore my stupid ideas.

No worries. We had similar discussions in the past, I proposed special
ioctls first but then the xattrs were found more suitable. So we're
letting you know the status but there's still some chance that we missed
something and you can point it out.
