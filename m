From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH -v2] btrfs: Use correct values when updating inode
 i_size on fallocate
Date: Mon, 1 Feb 2010 09:31:09 -0500
Message-ID: <20100201143109.GC4668@think>
References: <1264138365-13989-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <87d40st3cr.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87d40st3cr.fsf@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 30, 2010 at 01:46:04PM +0530, Aneesh Kumar K. V wrote:
> 
> Hi Chris,
> 
> I see that you merged an older version of this patch. But i guess it
> still have some issues.

Thanks, I missed v2 in the patchwork list.  I'll fix it up.

-chris

> 
> -anesh
> On Fri, 22 Jan 2010 11:02:45 +0530, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > Even though we allocate more, we should be updating inode i_size
> > as per the arguments passed
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> > Changes from V1:
> >  We should update i_size only if actual_len and cur_offset are both
> >  larger than i_size. Otherwise if actual_len is < i_size and cur_offset > i_size
> >  we may end up setting wrong i_size value
> > 
> >  fs/btrfs/inode.c |   17 ++++++++++++-----
> >  1 files changed, 12 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 5440bab..ac4cb6b 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -5789,7 +5789,7 @@ out_fail:
> >  }
> > 
> >  static int prealloc_file_range(struct inode *inode, u64 start, u64 end,
> > -			       u64 alloc_hint, int mode)
> > +			u64 alloc_hint, int mode, loff_t actual_len)
> >  {
> >  	struct btrfs_trans_handle *trans;
> >  	struct btrfs_root *root = BTRFS_I(inode)->root;
> > @@ -5798,6 +5798,7 @@ static int prealloc_file_range(struct inode *inode, u64 start, u64 end,
> >  	u64 cur_offset = start;
> >  	u64 num_bytes = end - start;
> >  	int ret = 0;
> > +	u64 i_size;
> > 
> >  	while (num_bytes > 0) {
> >  		alloc_size = min(num_bytes, root->fs_info->max_extent);
> > @@ -5835,9 +5836,15 @@ static int prealloc_file_range(struct inode *inode, u64 start, u64 end,
> >  		inode->i_ctime = CURRENT_TIME;
> >  		BTRFS_I(inode)->flags |= BTRFS_INODE_PREALLOC;
> >  		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> > -		    cur_offset > inode->i_size) {
> > -			i_size_write(inode, cur_offset);
> > -			btrfs_ordered_update_i_size(inode, cur_offset, NULL);
> > +			(actual_len > inode->i_size) &&
> > +			(cur_offset > inode->i_size)) {
> > +
> > +			if (cur_offset > actual_len)
> > +				i_size  = actual_len;
> > +			else
> > +				i_size = cur_offset;
> > +			i_size_write(inode, i_size);
> > +			btrfs_ordered_update_i_size(inode, i_size, NULL);
> >  		}
> > 
> >  		ret = btrfs_update_inode(trans, root, inode);
> > @@ -5930,7 +5937,7 @@ static long btrfs_fallocate(struct inode *inode, int mode,
> >  		     !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
> >  			ret = prealloc_file_range(inode,
> >  						  cur_offset, last_byte,
> > -						  alloc_hint, mode);
> > +						alloc_hint, mode, offset+len);
> >  			if (ret < 0) {
> >  				free_extent_map(em);
> >  				break;
> > -- 
> > 1.6.6.1.383.g5a9f
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
