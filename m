Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44143 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753464AbcHVAFB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Aug 2016 20:05:01 -0400
Date: Sun, 21 Aug 2016 17:04:53 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: detect corruption when non-root leaf has zero item
Message-ID: <20160822000452.GA4711@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1470286628-4123-1-git-send-email-bo.li.liu@oracle.com>
 <20160816170728.GS30795@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160816170728.GS30795@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 16, 2016 at 07:07:28PM +0200, David Sterba wrote:
> On Wed, Aug 03, 2016 at 09:57:08PM -0700, Liu Bo wrote:
> > Right now we treat leaf which has zero item as a valid one
> > because we could have an empty tree, that is, a root that is
> > also a leaf without any item, however, in the same case but
> > when the leaf is not a root, we can end up with hitting the
> > BUG_ON(1) in btrfs_extend_item() called by
> > setup_inline_extent_backref().
> > 
> > This makes us check the situation as a corruption if leaf is
> > not its own root.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/disk-io.c | 22 +++++++++++++++++++++-
> >  1 file changed, 21 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index a5a22be..dfaeb96 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -559,8 +559,28 @@ static noinline int check_leaf(struct btrfs_root *root,
> >  	u32 nritems = btrfs_header_nritems(leaf);
> >  	int slot;
> >  
> > -	if (nritems == 0)
> > +	if (nritems == 0) {
> > +		struct btrfs_root *r;
> 
> Please don't use single letter variables.

OK.

> 
> > +
> > +		key.objectid = btrfs_header_owner(leaf);
> > +		key.type = BTRFS_ROOT_ITEM_KEY;
> > +		key.offset = -1ULL;
> 
> While -1ULL is fine, the common style is the (u64)-1, please use that.

OK.

> 
> > +
> > +		r = btrfs_get_fs_root(root->fs_info, &key, false);
> 
> I wonder how expensive that could be. check_leaf is called at the end of
> the read so it's just the lookup time and the time the lock is held on
> the radix tree. All in all it seems acceptable.

It should be fine, it'd read a root leaf from searching fs radix tree if it's a fs/file root while it'd get root immediately if it's not, like tree_root/extent_root/chunk_root, etc.

Thanks,

-liubo
> 
> > +		/*
> > +		 * The only reason we also check NULL here is that during
> > +		 * open_ctree() some roots has not yet been set up.
> > +		 */
> > +		if (!IS_ERR_OR_NULL(r)) {
> > +			/* if leaf is the root, then it's fine */
> > +			if (leaf->start != btrfs_root_bytenr(&r->root_item)) {
> > +				CORRUPT("non-root leaf's nritems is 0",
> > +					leaf, root, 0);
> > +				return -EIO;
> > +			}
> > +		}
> >  		return 0;
> > +	}
> >  
> >  	/* Check the 0 item */
> >  	if (btrfs_item_offset_nr(leaf, 0) + btrfs_item_size_nr(leaf, 0) !=
> > -- 
> > 2.5.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
