Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:52677 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964909Ab3HHNMT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 09:12:19 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9D5117C06A1
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Aug 2013 07:12:19 -0600 (MDT)
Date: Thu, 8 Aug 2013 09:12:17 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: stop using GFP_ATOMIC when allocating rewind ebs
Message-ID: <20130808131217.GC16712@localhost.localdomain>
References: <1375909909-25955-1-git-send-email-jbacik@fusionio.com>
 <5203475A.9070705@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5203475A.9070705@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 09:23:06AM +0200, Jan Schmidt wrote:
>  
> On Wed, August 07, 2013 at 23:11 (+0200), Josef Bacik wrote:
> > There is no reason we can't just set the path to blocking and then do normal
> > GFP_NOFS allocations for these extent buffers.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> >  fs/btrfs/ctree.c     |   16 ++++++++++------
> >  fs/btrfs/extent_io.c |    8 ++++----
> >  2 files changed, 14 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > index 1dd8a71..414a2d7 100644
> > --- a/fs/btrfs/ctree.c
> > +++ b/fs/btrfs/ctree.c
> > @@ -1191,8 +1191,8 @@ __tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
> >   * is freed (its refcount is decremented).
> >   */
> >  static struct extent_buffer *
> > -tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
> > -		    u64 time_seq)
> > +tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
> > +		    struct extent_buffer *eb, u64 time_seq)
> >  {
> >  	struct extent_buffer *eb_rewin;
> >  	struct tree_mod_elem *tm;
> > @@ -1207,12 +1207,15 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
> >  	if (!tm)
> >  		return eb;
> >  
> > +	btrfs_set_path_blocking(path);
> > +	btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
> > +
> >  	if (tm->op == MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
> >  		BUG_ON(tm->slot != 0);
> >  		eb_rewin = alloc_dummy_extent_buffer(eb->start,
> >  						fs_info->tree_root->nodesize);
> >  		if (!eb_rewin) {
> > -			btrfs_tree_read_unlock(eb);
> > +			btrfs_tree_read_unlock_blocking(eb);
> >  			free_extent_buffer(eb);
> >  			return NULL;
> >  		}
> > @@ -1224,13 +1227,14 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
> >  	} else {
> >  		eb_rewin = btrfs_clone_extent_buffer(eb);
> >  		if (!eb_rewin) {
> > -			btrfs_tree_read_unlock(eb);
> > +			btrfs_tree_read_unlock_blocking(eb);
> >  			free_extent_buffer(eb);
> >  			return NULL;
> >  		}
> >  	}
> >  
> > -	btrfs_tree_read_unlock(eb);
> > +	btrfs_clear_path_blocking(path, NULL, BTRFS_READ_LOCK);
> > +	btrfs_tree_read_unlock_blocking(eb);
> 
> unlock_blocking? Rest looks ok to me.
> 

Yeah I change the lock to blocking above, so I have to do read_unlock_blocking
here.  Thanks,

Josef
