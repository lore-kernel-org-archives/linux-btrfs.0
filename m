Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19793 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751850AbdJaV5A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 17:57:00 -0400
Date: Tue, 31 Oct 2017 14:51:36 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: bail out gracefully rather than BUG_ON
Message-ID: <20171031215136.GA17979@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20171030171440.27044-1-bo.li.liu@oracle.com>
 <d2dc51f8-2cbb-c425-a712-93ee41de4b1a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d2dc51f8-2cbb-c425-a712-93ee41de4b1a@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 at 10:23:30PM +0200, Nikolay Borisov wrote:
> 
> 
> On 30.10.2017 19:14, Liu Bo wrote:
> > If a file's DIR_ITEM key is invalid (due to memory errors) and gets
> > written to disk, a future lookup_path can end up with kernel panic due
> > to BUG_ON().
> > 
> > This gets rid of the BUG_ON(), meanwhile output the corrupted key and
> > return ENOENT if it's invalid.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > The diff doesn't show the logic well, 'goto out_err' will return with
> > assigning 0 to location->objectid, and the caller already has a check
> > for (location->objectid == 0) to return -ENOENT.
> > 
> >  fs/btrfs/inode.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index d94e3f6..916cdc9 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -5500,6 +5500,14 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
> >  		goto out_err;
> >  
> >  	btrfs_dir_item_key_to_cpu(path->nodes[0], di, location);
> > +	if (location->type != BTRFS_INODE_ITEM_KEY &&
> > +	    location->type != BTRFS_ROOT_ITEM_KEY) {
> > +		btrfs_warn(root->fs_info,
> > +	  "%s gets something invalid in DIR_ITEM (name %s, directory ino %llu, location(%llu %u %llu))",
> > +			   __func__, name, btrfs_ino(BTRFS_I(dir)),
> > +			   location->objectid, location->type, location->offset);
> > +		goto out_err;
> 
> If this situation happens it's possible that ret is still 0 so the error
> handling in btrfs_lookup_dentry might not trigger. How about just
> setting -EUCLEAN if we execute the if branch?
>

Thanks for the comment.  So it's not going to trigger the (ret < 0)
check, instead it tries to trigger the one following (ret < 0):

        if (location.objectid == 0)
                return ERR_PTR(-ENOENT);

which is consistent to the case when we didn't find the btrfs_dir_item
(di is NULL, returned by btrfs_lookup_dir_item()).

thanks,
-liubo


> > +	}
> >  out:
> >  	btrfs_free_path(path);
> >  	return ret;
> > @@ -5816,8 +5824,6 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
> >  		return inode;
> >  	}
> >  
> > -	BUG_ON(location.type != BTRFS_ROOT_ITEM_KEY);
> > -
> >  	index = srcu_read_lock(&fs_info->subvol_srcu);
> >  	ret = fixup_tree_root_location(fs_info, dir, dentry,
> >  				       &location, &sub_root);
> > 
