Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23516 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762065AbdACXhD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jan 2017 18:37:03 -0500
Date: Tue, 3 Jan 2017 15:36:29 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, holger@applied-asynchrony.com,
        s.priebe@profihost.ag, quwenruo@cn.fujitsu.com
Subject: Re: [PATCH 1/3] btrfs: improve inode's outstanding_extents
 computation
Message-ID: <20170103233629.GD4651@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1478853587-28717-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1478853587-28717-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <20170103210045.GA4651@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170103210045.GA4651@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Resend this reply due to a message that there is an invalid email address.)

On Tue, Jan 03, 2017 at 01:00:45PM -0800, Liu Bo wrote:
> On Fri, Nov 11, 2016 at 04:39:45PM +0800, Wang Xiaoguang wrote:
> > This issue was revealed by modifying BTRFS_MAX_EXTENT_SIZE(128MB) to 64KB,
> > When modifying BTRFS_MAX_EXTENT_SIZE(128MB) to 64KB, fsstress test often
> > gets these warnings from btrfs_destroy_inode():
> > 	WARN_ON(BTRFS_I(inode)->outstanding_extents);
> > 	WARN_ON(BTRFS_I(inode)->reserved_extents);
> > 
> > Simple test program below can reproduce this issue steadily.
> > Note: you need to modify BTRFS_MAX_EXTENT_SIZE to 64KB to have test,
> > otherwise there won't be such WARNING.
> > 	#include <string.h>
> > 	#include <unistd.h>
> > 	#include <sys/types.h>
> > 	#include <sys/stat.h>
> > 	#include <fcntl.h>
> > 
> > 	int main(void)
> > 	{
> > 		int fd;
> > 		char buf[68 *1024];
> > 
> > 		memset(buf, 0, 68 * 1024);
> > 		fd = open("testfile", O_CREAT | O_EXCL | O_RDWR);
 
	        pwrite(fd, buf, 64 * 1024, 64 * 1024);

(During my test, I had to add the above in order to reproduce the
warning, another alternative way is to use truncate and pread.)
 
> > 		pwrite(fd, buf, 68 * 1024, 64 * 1024);
> > 		return;
> > 	}
> > 
> > When BTRFS_MAX_EXTENT_SIZE is 64KB, and buffered data range is:
> > 64KB						128K		132KB
> > |-----------------------------------------------|---------------|
> >                          64 + 4KB
> > 
> > 1) for above data range, btrfs_delalloc_reserve_metadata() will reserve
> > metadata and set BTRFS_I(inode)->outstanding_extents to 2.
> > (68KB + 64KB - 1) / 64KB == 2
> > 
> > Outstanding_extents: 2
> > 
> > 2) then btrfs_dirty_page() will be called to dirty pages and set
> > EXTENT_DELALLOC flag. In this case, btrfs_set_bit_hook() will be called
> > twice.
> > The 1st set_bit_hook() call will set DEALLOC flag for the first 64K.
> > 64KB						128KB
> > |-----------------------------------------------|
> > 	64KB DELALLOC
> > Outstanding_extents: 2
> 
I think that here the 1st extent [64k, 128k] is only set with
EXTENT_UPTODATE since other bits like DELALLOC has been cleared by
lock_and_cleanup_extent_if_need.

It would work if we check EXTENT_UPTODATE on deciding whether to clear
EXTENT_FIRST_DELALLOC, i.e.

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4175987..4eace1a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1752,7 +1752,12 @@ static void btrfs_set_bit_hook(struct inode *inode,
	bool do_list = !btrfs_is_free_space_inode(inode);

	if (*bits & EXTENT_FIRST_DELALLOC) {
-			*bits &= ~EXTENT_FIRST_DELALLOC;
+			/*
+			 * With EXTENT_UPTODATE, the state gets rewritten
+			 * before writing it back, or gets read from disk.
+			 */
+			if (!(state->state & EXTENT_UPTODATE))
+				*bits &= ~EXTENT_FIRST_DELALLOC;
	} else {
		spin_lock(&BTRFS_I(inode)->lock);
		BTRFS_I(inode)->outstanding_extents++;

Thanks,

-liubo
> 
> > 
> > Set_bit_hooks() uses FIRST_DELALLOC flag to avoid re-increase
> > outstanding_extents counter.
> > So for 1st set_bit_hooks() call, it won't modify outstanding_extents,
> > it's still 2.
> > 
> > Then FIRST_DELALLOC flag is *CLEARED*.
> > 
> > 3) 2nd btrfs_set_bit_hook() call.
> > Because FIRST_DELALLOC have been cleared by previous set_bit_hook(),
> > btrfs_set_bit_hook() will increase BTRFS_I(inode)->outstanding_extents by
> > one, so now BTRFS_I(inode)->outstanding_extents is 3.
> > 64KB                                            128KB            132KB
> > |-----------------------------------------------|----------------|
> > 	64K DELALLOC				   4K DELALLOC
> > Outstanding_extents: 3
> > 
> > But the correct outstanding_extents number should be 2, not 3.
> > The 2nd btrfs_set_bit_hook() call just screwed up this, and leads to the
> > WARN_ON().
> > 
> > Normally, we can solve it by only increasing outstanding_extents in
> > set_bit_hook().
> > But the problem is for delalloc_reserve/release_metadata(), we only have
> > a 'length' parameter, and calculate in-accurate outstanding_extents.
> > If we only rely on set_bit_hook() release_metadata() will crew things up
> > as it will decrease inaccurate number.
> > 
> > So the fix we use is:
> > 1) Increase *INACCURATE* outstanding_extents at delalloc_reserve_meta
> >    Just as a place holder.
> > 2) Increase *accurate* outstanding_extents at set_bit_hooks()
> >    This is the real increaser.
> > 3) Decrease *INACCURATE* outstanding_extents before returning
> >    This makes outstanding_extents to correct value.
> > 
> > For 128M BTRFS_MAX_EXTENT_SIZE, due to limitation of
> > __btrfs_buffered_write(), each iteration will only handle about 2MB
> > data.
> > So btrfs_dirty_pages() won't need to handle cases cross 2 extents.
> > 
> > Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> > ---
> >  fs/btrfs/ctree.h |  2 ++
> >  fs/btrfs/inode.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++------
> >  fs/btrfs/ioctl.c |  6 ++----
> >  3 files changed, 62 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 9d8edcb..766d152 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -3139,6 +3139,8 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
> >  			       int nr);
> >  int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
> >  			      struct extent_state **cached_state, int dedupe);
> > +int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
> > +			    struct extent_state **cached_state);
> >  int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
> >  			     struct btrfs_root *new_root,
> >  			     struct btrfs_root *parent_root,
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 1f980ef..25e0083 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -1601,6 +1601,9 @@ static void btrfs_split_extent_hook(struct inode *inode,
> >  	if (!(orig->state & EXTENT_DELALLOC))
> >  		return;
> >  
> > +	if (btrfs_is_free_space_inode(inode))
> > +		return;
> > +
> >  	size = orig->end - orig->start + 1;
> >  	if (size > BTRFS_MAX_EXTENT_SIZE) {
> >  		u64 num_extents;
> > @@ -1643,6 +1646,9 @@ static void btrfs_merge_extent_hook(struct inode *inode,
> >  	if (!(other->state & EXTENT_DELALLOC))
> >  		return;
> >  
> > +	if (btrfs_is_free_space_inode(inode))
> > +		return;
> > +
> >  	if (new->start > other->start)
> >  		new_size = new->end - other->start + 1;
> >  	else
> > @@ -1738,7 +1744,6 @@ static void btrfs_del_delalloc_inode(struct btrfs_root *root,
> >  static void btrfs_set_bit_hook(struct inode *inode,
> >  			       struct extent_state *state, unsigned *bits)
> >  {
> > -
> >  	if ((*bits & EXTENT_DEFRAG) && !(*bits & EXTENT_DELALLOC))
> >  		WARN_ON(1);
> >  	/*
> > @@ -1749,13 +1754,16 @@ static void btrfs_set_bit_hook(struct inode *inode,
> >  	if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
> >  		struct btrfs_root *root = BTRFS_I(inode)->root;
> >  		u64 len = state->end + 1 - state->start;
> > +		u64 num_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE - 1,
> > +					    BTRFS_MAX_EXTENT_SIZE);
> >  		bool do_list = !btrfs_is_free_space_inode(inode);
> >  
> > -		if (*bits & EXTENT_FIRST_DELALLOC) {
> > +		if (*bits & EXTENT_FIRST_DELALLOC)
> >  			*bits &= ~EXTENT_FIRST_DELALLOC;
> > -		} else {
> > +
> > +		if (do_list) {
> >  			spin_lock(&BTRFS_I(inode)->lock);
> > -			BTRFS_I(inode)->outstanding_extents++;
> > +			BTRFS_I(inode)->outstanding_extents += num_extents;
> >  			spin_unlock(&BTRFS_I(inode)->lock);
> >  		}
> >  
> > @@ -1803,7 +1811,7 @@ static void btrfs_clear_bit_hook(struct inode *inode,
> >  
> >  		if (*bits & EXTENT_FIRST_DELALLOC) {
> >  			*bits &= ~EXTENT_FIRST_DELALLOC;
> > -		} else if (!(*bits & EXTENT_DO_ACCOUNTING)) {
> > +		} else if (!(*bits & EXTENT_DO_ACCOUNTING) && do_list) {
> >  			spin_lock(&BTRFS_I(inode)->lock);
> >  			BTRFS_I(inode)->outstanding_extents -= num_extents;
> >  			spin_unlock(&BTRFS_I(inode)->lock);
> > @@ -2001,9 +2009,52 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
> >  int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
> >  			      struct extent_state **cached_state, int dedupe)
> >  {
> > +	int ret;
> > +	u64 num_extents = div64_u64(end - start + BTRFS_MAX_EXTENT_SIZE,
> > +				    BTRFS_MAX_EXTENT_SIZE);
> > +
> > +	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
> > +	ret = set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
> > +				  cached_state);
> > +
> > +	/*
> > +	 * btrfs_delalloc_reserve_metadata() will first add number of
> > +	 * outstanding extents according to data length, which is inaccurate
> > +	 * for case like dirtying already dirty pages.
> > +	 * so here we will decrease such inaccurate numbers, to make
> > +	 * outstanding_extents only rely on the correct values added by
> > +	 * set_bit_hook()
> > +	 *
> > +	 * Also, we skipped the metadata space reserve for space cache inodes,
> > +	 * so don't modify the outstanding_extents value.
> > +	 */
> > +	if (ret == 0 && !btrfs_is_free_space_inode(inode)) {
> > +		spin_lock(&BTRFS_I(inode)->lock);
> > +		BTRFS_I(inode)->outstanding_extents -= num_extents;
> > +		spin_unlock(&BTRFS_I(inode)->lock);
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
> > +			    struct extent_state **cached_state)
> > +{
> > +	int ret;
> > +	u64 num_extents = div64_u64(end - start + BTRFS_MAX_EXTENT_SIZE,
> > +				    BTRFS_MAX_EXTENT_SIZE);
> > +
> >  	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
> > -	return set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
> > -				   cached_state);
> > +	ret = set_extent_defrag(&BTRFS_I(inode)->io_tree, start, end,
> > +				cached_state);
> > +
> > +	if (ret == 0 && !btrfs_is_free_space_inode(inode)) {
> > +		spin_lock(&BTRFS_I(inode)->lock);
> > +		BTRFS_I(inode)->outstanding_extents -= num_extents;
> > +		spin_unlock(&BTRFS_I(inode)->lock);
> > +	}
> > +
> > +	return ret;
> >  }
> >  
> >  /* see btrfs_writepage_start_hook for details on why this is required */
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 7163457..eff5eae 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -1235,10 +1235,8 @@ again:
> >  				(page_cnt - i_done) << PAGE_SHIFT);
> >  	}
> >  
> > -
> > -	set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start, page_end - 1,
> > -			  &cached_state);
> > -
> > +	btrfs_set_extent_defrag(inode, page_start,
> > +				page_end - 1, &cached_state);
> >  	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
> >  			     page_start, page_end - 1, &cached_state,
> >  			     GFP_NOFS);
> > -- 
> > 2.7.4
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
