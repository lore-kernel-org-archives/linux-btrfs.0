From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: check return value of kmalloc()
Date: Thu, 21 Apr 2011 14:18:11 +0200
Message-ID: <20110421121810.GC31675@twin.jikos.cz>
References: <201104190527.AA00014@T-ITOH1.jp.fujitsu.com>
 <20110419111240.GV31675@twin.jikos.cz>
 <4DAE2E12.7060002@jp.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Sterba <dave@jikos.cz>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DAE2E12.7060002@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 20, 2011 at 09:51:30AM +0900, Tsutomu Itoh wrote:
> > 2030        delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
> 
> I think that it doesn't fail ordinary when __GFP_NOFAIL is specified...

yes I agree with you, my oversight. However, from linux/gfp.h

 * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the
 * caller cannot handle allocation failures.  This modifier is
 * deprecated and no new users should be added.

in long-term, redoing without NOFAIL would be probably wise. Currently
the btrfs_add_delayed_iput is called at places which do not seem to
like failure, I'm not sure whether possibly blocking indefinetely is
better than occasional failure with chance to do recovery ...

> 
> > 
> > and in extent-tree.c:relocate_one_extent()
> > 
> > 7992        new_extents = kmalloc(sizeof(*new_extents),
> > 7993                                                 GFP_NOFS);
> > 
> > the value is checked later, new_extents is passed to get_new_locations
> > and there it's checked, but no other callers pass potential NULL and the
> > check fits here and can be dropped from get_new_locations;

> > there's a
> > little chance that get_new_locations will be able to succesfully
> > allocate the same data a jiffy later.
> 
> Yes, therefore I did not check 'new_extents'.

heh reading it again after myself, it sounds quite the opposite than I
wanted: I'd rather see the kmalloc checked right at the callsite, easier
to read and understand, than diving into get_new_locations and there
seeing checking extents for NULL and doing own alloc/free.


david
