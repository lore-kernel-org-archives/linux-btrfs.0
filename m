Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50981 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750826AbbAOBrI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 20:47:08 -0500
Message-ID: <1421286288.3249.4.camel@localhost.localdomain>
Subject: Re: [PATCH] btrfs: cleanup a straight free-after-malloc branch for
 free-space-cache
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Date: Thu, 15 Jan 2015 09:44:48 +0800
In-Reply-To: <20150114152202.GT3685@twin.jikos.cz>
References: <1421223534-11799-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20150114152202.GT3685@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2015-01-14 at 16:22 +0100, David Sterba wrote:
> On Wed, Jan 14, 2015 at 04:18:54PM +0800, Gui Hecheng wrote:
> > Move the branch that is unrelated to the result of io_ctl_init() before
> > the function call, so we can save a kmalloc() & kfree() pair in that
> > branch.
> > 
> > Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> > ---
> >  fs/btrfs/free-space-cache.c | 17 +++++++++--------
> >  1 file changed, 9 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> > index d6c03f7..88f6122 100644
> > --- a/fs/btrfs/free-space-cache.c
> > +++ b/fs/btrfs/free-space-cache.c
> > @@ -1132,10 +1132,6 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
> >  	if (!i_size_read(inode))
> >  		return -1;
> >  
> > -	ret = io_ctl_init(&io_ctl, inode, root, 1);
> > -	if (ret)
> > -		return -1;
> 
> I'm not sure this preserves the original semantics. This can fail if
> there's no memory, fine, but also ENOSPC if the "crcs do not fit into
> the first page" as the comment in io_ctl_init() says. There's an
> additional condition that the inode is not FREE_INO, ie. it is the
> FREE_SPACE inode.
> 
> So in some cases io_ctl_init may fail but would not after your patch.
> 
> > -
> >  	if (block_group && (block_group->flags & BTRFS_BLOCK_GROUP_DATA)) {
> >  		down_write(&block_group->data_rwsem);
> >  		spin_lock(&block_group->lock);
> > @@ -1145,11 +1141,15 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
> >  			up_write(&block_group->data_rwsem);
> >  			BTRFS_I(inode)->generation = 0;
> >  			ret = 0;
> > -			goto out;
> > +			goto out_skip;
> >  		}
> >  		spin_unlock(&block_group->lock);
> >  	}
> >  
> > +	ret = io_ctl_init(&io_ctl, inode, root, 1);
> > +	if (ret)
> > +		return -1;
> 
> This would leave block_group->data_rwsem locked, ie. another exit path
> would have to be added that would reflect the current state (no io_ctl
> initialized and the extent range not locked). We cannot use out_enospc
> here.

Yes, you're right, the ->data_rwsem shall not be left locked.

> I'm not sure if the kmalloc/kfree savings are significant here.

I'm not sure whether it brings much, please *ignore* this patch and I
will do more checks.

Thanks,
Gui 

> > +
> >  	/* Lock all pages first so we can lock the extent safely. */
> >  	io_ctl_prepare_pages(&io_ctl, inode, 0);
> >  
> > @@ -1212,13 +1212,14 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
> >  	/* Flush the dirty pages in the cache file. */
> >  	ret = flush_dirty_cache(inode);
> >  	if (ret)
> > -		goto out;
> > +		goto out_free;
> >  
> >  	/* Update the cache item to tell everyone this cache file is valid. */
> >  	ret = update_cache_item(trans, root, inode, path, offset,
> >  				entries, bitmaps);
> > -out:
> > +out_free:
> >  	io_ctl_free(&io_ctl);
> > +out_skip:
> >  	if (ret) {
> >  		invalidate_inode_pages2(inode->i_mapping);
> >  		BTRFS_I(inode)->generation = 0;
> > @@ -1232,7 +1233,7 @@ out_nospc:
> >  	if (block_group && (block_group->flags & BTRFS_BLOCK_GROUP_DATA))
> >  		up_write(&block_group->data_rwsem);
> >  
> > -	goto out;
> > +	goto out_free;
> >  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


