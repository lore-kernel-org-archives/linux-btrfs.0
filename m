From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] implement memory reclaim for leaf reference cache
Date: Wed, 30 Jul 2008 16:48:12 -0400
Message-ID: <1217450892.20239.34.camel@think.oraclecorp.com>
References: <3d0408630807300852q28b12252g3230cc136c075ce3@mail.gmail.com>
	 <1217441674.20239.16.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1217441674.20239.16.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-07-30 at 14:14 -0400, Chris Mason wrote:
> On Wed, 2008-07-30 at 23:52 +0800, Yan Zheng wrote:
> > Hello,
> > 
> > The memory reclaiming issue happens when snapshot exists. In that
> > case, some cache entries may not be used during old snapshot dropping,
> > so they will remain in the cache until umount. The patch adds a field
> > to struct btrfs_leaf_ref to record create time. Besides, the patch
> > makes all dead roots of a given snapshot linked together in order of
> > create time. After a old snapshot was completely dropped, we check the
> > dead root list and remove all cache entries created before the oldest
> > dead root in the list.
> > 
> 
> Hi Yan,
> 
> I think this is missing some hunks, it isn't compiling quite right:
> 

Well, outside of these errors the code looks right.  I'll push it out,
just send along an incremental if it is needed.

-chris


