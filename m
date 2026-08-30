Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9502AD2C;
	Sun, 30 Aug 2026 10:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788086591; cv=none; b=eN1nADYvSA1Okd2RZDWNL3Vy98hVk/UfLX7Raa01HPUiBjpIALaMMSXApGg25bp/e5mCdNLBsi3SoQf2AOFl0LjBVKNPRTT7h16RLoFRm3SdY3ugutEkohRzuPuRpkN9OxrzlEHl33YCyJZqZzmF8/MA28fkBIgylPFFma4R7KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788086591; c=relaxed/simple;
	bh=YrrNFApOiygNE3IydW119p93T8B+olUT0TF5hfmX6Gg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oMPvMSf1dQ88TMnp0LTXAM5PY4RI490H3CpowQAK9WeyqhQYuPbZnkWk1UTauyHKjH0M9YV9tgDqTPQNEXW2pV7eikZaMZHSZFl2cGe48o6o1IFQ7hNzAshk/LrUf3lhmK5mIiy9dJnnULOkjNJmULUA3M1rFGcBuqWLHNUDiZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=lueX7JCi; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lueX7JCi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Message-ID:MIME-Version:
	Content-Type; bh=b2J2i9sD6asTLcdA0gSUTN3NiymMW+XcJNgX31MUJTE=;
	b=lueX7JCi1jeLyz2B3tlYZgyYEHuZJWCJBZMha34GIwGm5g2c07KWcfrMOJmI6Z
	M/3FZXoeLaSKlu5t6GMNtJMPuu+DjdeQn3fwaFfWJWu/xivfkRzreJlfil/g9jaU
	Gh8n6PHKhrcm+Sa6fpZtu1T1YhYo2GPcqrY+ptZzH3XYM=
Received: from localhost (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgCXPysjCZRqtYsHPA--.60919S2;
	Sun, 30 Aug 2026 18:42:44 +0800 (CST)
Date: Sun, 30 Aug 2026 18:42:43 +0800
From: Melon Liu <melon1335@163.com>
To: Qu Wenruo <wqu@suse.com>
Cc: clm@fb.com, dsterba@suse.com, fdmanana@suse.com, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix deadlocks with transaction commit when
 cloning inline extents
Message-ID: <byfdpkxktwidszfv3yss7nxajjioxq7nhcmnxrzrwkvvzqaejh@ovl6qwbe6du6>
References: <a74ov5nvs5u4nkqhrs5lp2jaj664wewkqqsjxzhuemzazzmzvx@eeof6sjb3xdc>
 <bbcc2791-442f-4bf5-aabf-40eb2edc0165@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bbcc2791-442f-4bf5-aabf-40eb2edc0165@suse.com>
X-CM-TRANSID:PygvCgCXPysjCZRqtYsHPA--.60919S2
X-Coremail-Antispam: 1Uf129KBjvAXoW3ZF45GryUur1UWrykuw4kZwb_yoW8AFWUXo
	WrZFs2qr1rGr13trW7Kw4kG3yUu39Fkw4kJr4Yq34S9wn7tF1jgw47Ka1DWa40y3WfKFn5
	Ga4xX3Z8trWvy3Wfn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUe6wuUUUUU
X-CM-SenderInfo: ppho00irttkqqrwthudrp/xtbDAAQLLGqUCSS7iAAA3D

On Sat, Aug 29, 2026 at 06:25:11PM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/8/29 17:09, Melon Liu 写道:
> > Commits b48c980b6a7e ("btrfs: fix deadlock between reflink and transaction
> > commit when using flushoncommit") and 532085d00eb5 ("btrfs: fix deadlock
> > cloning inline extent when using flushoncommit") moved the destination
> > i_size update before btrfs_start_transaction() to prevent
> > extent_writepage() from invalidating a folio beyond EOF.  However, two
> > deadlock windows remain.
> > 
> > First, after the folio is dirtied but before i_size is updated,
> > extent_writepage() can still see the folio beyond EOF.  It calls
> > folio_invalidate(), and btrfs_invalidate_folio() waits for the destination
> > extent range lock held by the clone task.
> > 
> > Second, if extent_writepage() sees the folio within EOF, it proceeds to
> > writepage_delalloc(), which also waits for the destination extent range
> > lock.
> 
> What about letting the agent to create a reproducer, trigger it and paste
> the lockdep/hang calltrace?
> 
> Also an ASCII chart showing the window between involved threads?
> 
> > 
> > In both cases the transaction commit waits for writeback to complete,
> > while the clone task waits in btrfs_start_transaction() for the
> > committing transaction to become unblocked.
> > 
> > To close both windows, first call btrfs_start_transaction() after reserving
> > delalloc space and before creating and dirtying the folio.
> > However, a commit may still start writeback before all extwriters have left
> > the transaction.  Therefore, when the copied range extends beyond EOF,
> > update i_size while the folio is still locked and before marking it dirty,
> > so that extent_writepage() cannot treat it as being beyond EOF.  The
> > resulting ordering also makes BTRFS_INODE_NO_DELALLOC_FLUSH unnecessary, so
> > remove the flag and its associated logic.
> > 
> > Fixes: 05a5a7621ce6 ("Btrfs: implement full reflink support for inline extents")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Melon Liu <melon1335@163.com>
> 
> And AI disclosure.
> 
> > ---
> >   fs/btrfs/btrfs_inode.h |  14 +----
> >   fs/btrfs/dev-replace.c |   2 +-
> >   fs/btrfs/disk-io.c     |   2 +-
> >   fs/btrfs/inode.c       |  16 ++----
> >   fs/btrfs/ioctl.c       |   4 +-
> >   fs/btrfs/qgroup.c      |   4 +-
> >   fs/btrfs/reflink.c     | 117 ++++++++++-------------------------------
> >   fs/btrfs/send.c        |   4 +-
> >   fs/btrfs/space-info.c  |   2 +-
> >   9 files changed, 45 insertions(+), 120 deletions(-)
> > 
> > diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> > index 1082fa92c..aafe47b23 100644
> > --- a/fs/btrfs/btrfs_inode.h
> > +++ b/fs/btrfs/btrfs_inode.h
> > @@ -68,15 +68,6 @@ enum {
> >   	 * to an inode.
> >   	 */
> >   	BTRFS_INODE_NO_XATTRS,
> > -	/*
> > -	 * Set when we are in a context where we need to start a transaction and
> > -	 * have dirty pages with the respective file range locked. This is to
> > -	 * ensure that when reserving space for the transaction, if we are low
> > -	 * on available space and need to flush delalloc, we will not flush
> > -	 * delalloc for this inode, because that could result in a deadlock (on
> > -	 * the file range, inode's io_tree).
> > -	 */
> > -	BTRFS_INODE_NO_DELALLOC_FLUSH,
> >   	/*
> >   	 * Set when we are working on enabling verity for a file. Computing and
> >   	 * writing the whole Merkle tree can take a while so we want to prevent
> > @@ -531,9 +522,8 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
> >   int btrfs_delete_subvolume(struct btrfs_inode *dir, struct dentry *dentry);
> >   int btrfs_truncate_block(struct btrfs_inode *inode, u64 offset, u64 start, u64 end);
> > -int btrfs_start_delalloc_snapshot(struct btrfs_root *root, bool in_reclaim_context);
> > -int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
> > -			       bool in_reclaim_context);
> > +int btrfs_start_delalloc_snapshot(struct btrfs_root *root);
> > +int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr);
> >   int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
> >   			      unsigned int extra_bits,
> >   			      struct extent_state **cached_state);
> > diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> > index dc0834f92..ea1e43b9a 100644
> > --- a/fs/btrfs/dev-replace.c
> > +++ b/fs/btrfs/dev-replace.c
> > @@ -899,7 +899,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
> >   	 * flush all outstanding I/O and inode extent mappings before the
> >   	 * copy operation is declared as being finished
> >   	 */
> > -	ret = btrfs_start_delalloc_roots(fs_info, LONG_MAX, false);
> > +	ret = btrfs_start_delalloc_roots(fs_info, LONG_MAX);
> >   	if (ret) {
> >   		/* Stays started/resumable; keep both denied. */
> >   		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 819727460..fcd627251 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -4403,7 +4403,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
> >   	 * getting delayed iputs than are never run. So flush delalloc and wait
> >   	 * for ordered extents.
> >   	 */
> > -	btrfs_start_delalloc_roots(fs_info, LONG_MAX, false);
> > +	btrfs_start_delalloc_roots(fs_info, LONG_MAX);
> >   	btrfs_wait_ordered_roots(fs_info, U64_MAX, NULL);
> >   	/*
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 3c10a0ef0..00795c3de 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -8901,7 +8901,7 @@ static struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode
> >    * of all the inodes with pending delalloc and forces them to disk.
> >    */
> >   static int start_delalloc_inodes(struct btrfs_root *root, long *nr_to_write,
> > -				 bool snapshot, bool in_reclaim_context)
> > +				 bool snapshot)
> >   {
> >   	struct btrfs_delalloc_work *work, *next;
> >   	LIST_HEAD(works);
> > @@ -8919,10 +8919,6 @@ static int start_delalloc_inodes(struct btrfs_root *root, long *nr_to_write,
> >   		list_move_tail(&inode->delalloc_inodes, &root->delalloc_inodes);
> > -		if (in_reclaim_context &&
> > -		    test_bit(BTRFS_INODE_NO_DELALLOC_FLUSH, &inode->runtime_flags))
> > -			continue;
> > -
> >   		tmp_inode = igrab(&inode->vfs_inode);
> >   		if (!tmp_inode) {
> >   			cond_resched_lock(&root->delalloc_lock);
> > @@ -8971,17 +8967,16 @@ static int start_delalloc_inodes(struct btrfs_root *root, long *nr_to_write,
> >   	return ret;
> >   }
> > -int btrfs_start_delalloc_snapshot(struct btrfs_root *root, bool in_reclaim_context)
> > +int btrfs_start_delalloc_snapshot(struct btrfs_root *root)
> >   {
> >   	struct btrfs_fs_info *fs_info = root->fs_info;
> >   	if (unlikely(BTRFS_FS_ERROR(fs_info)))
> >   		return -EROFS;
> > -	return start_delalloc_inodes(root, NULL, true, in_reclaim_context);
> > +	return start_delalloc_inodes(root, NULL, true);
> >   }
> > -int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
> > -			       bool in_reclaim_context)
> > +int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr)
> >   {
> >   	long *nr_to_write = nr == LONG_MAX ? NULL : &nr;
> >   	struct btrfs_root *root;
> > @@ -9003,8 +8998,7 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
> >   			       &fs_info->delalloc_roots);
> >   		spin_unlock(&fs_info->delalloc_root_lock);
> > -		ret = start_delalloc_inodes(root, nr_to_write, false,
> > -				in_reclaim_context);
> > +		ret = start_delalloc_inodes(root, nr_to_write, false);
> >   		btrfs_put_root(root);
> >   		if (ret < 0 || nr <= 0)
> >   			goto out;
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 72bc9d4f7..43a956a00 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -926,7 +926,7 @@ static noinline int btrfs_mksnapshot(struct dentry *parent,
> >   	 */
> >   	btrfs_drew_read_lock(&root->snapshot_lock);
> > -	ret = btrfs_start_delalloc_snapshot(root, false);
> > +	ret = btrfs_start_delalloc_snapshot(root);
> >   	if (ret)
> >   		goto out;
> > @@ -5586,7 +5586,7 @@ long btrfs_ioctl(struct file *file, unsigned int
> >   	case BTRFS_IOC_SYNC: {
> >   		int ret;
> > -		ret = btrfs_start_delalloc_roots(fs_info, LONG_MAX, false);
> > +		ret = btrfs_start_delalloc_roots(fs_info, LONG_MAX);
> >   		if (ret)
> >   			return ret;
> >   		ret = btrfs_sync_fs(inode->i_sb, 1);
> > diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> > index f68b696b4..a4e01403c 100644
> > --- a/fs/btrfs/qgroup.c
> > +++ b/fs/btrfs/qgroup.c
> > @@ -1321,7 +1321,7 @@ static int flush_reservations(struct btrfs_fs_info *fs_info)
> >   {
> >   	int ret;
> > -	ret = btrfs_start_delalloc_roots(fs_info, LONG_MAX, false);
> > +	ret = btrfs_start_delalloc_roots(fs_info, LONG_MAX);
> >   	if (ret)
> >   		return ret;
> >   	btrfs_wait_ordered_roots(fs_info, U64_MAX, NULL);
> > @@ -4228,7 +4228,7 @@ static int try_flush_qgroup(struct btrfs_root *root)
> >   		return 0;
> >   	}
> > -	ret = btrfs_start_delalloc_snapshot(root, true);
> > +	ret = btrfs_start_delalloc_snapshot(root);
> >   	if (ret < 0)
> >   		goto out;
> >   	btrfs_wait_ordered_extents(root, U64_MAX, NULL);
> > diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> > index d2a410191..11950a2cd 100644
> > --- a/fs/btrfs/reflink.c
> > +++ b/fs/btrfs/reflink.c
> > @@ -58,7 +58,8 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
> >   			       char *inline_data,
> >   			       const u64 size,
> >   			       const u64 datal,
> > -			       const u8 comp_type)
> > +			       const u8 comp_type,
> > +			       struct btrfs_trans_handle **trans_out)
> >   {
> >   	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> >   	const u32 block_size = fs_info->sectorsize;
> > @@ -84,6 +85,18 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
> >   	if (ret)
> >   		goto out;
> > +	/*
> > +	 * Start the transaction before creating and dirtying the folio, otherwise
> > +	 * commit writeback can deadlock on the destination range locked by the
> > +	 * caller.
> > +	 */
> > +	*trans_out = btrfs_start_transaction(inode->root, 1);
> > +	if (IS_ERR(*trans_out)) {
> > +		ret = PTR_ERR(*trans_out);
> > +		*trans_out = NULL;
> > +		goto out_unlock;
> > +	}
> > +
> >   	folio = __filemap_get_folio(mapping, file_offset >> PAGE_SHIFT,
> >   					FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
> >   					btrfs_alloc_write_mask(mapping));
> > @@ -100,19 +113,6 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
> >   	if (ret)
> >   		goto out_unlock;
> > -	/*
> > -	 * After dirtying the page our caller will need to start a transaction,
> > -	 * and if we are low on metadata free space, that can cause flushing of
> > -	 * delalloc for all inodes in order to get metadata space released.
> > -	 * However we are holding the range locked for the whole duration of
> > -	 * the clone/dedupe operation, so we may deadlock if that happens and no
> > -	 * other task releases enough space. So mark this inode as not being
> > -	 * possible to flush to avoid such deadlock. We will clear that flag
> > -	 * when we finish cloning all extents, since a transaction is started
> > -	 * after finding each extent to clone.
> > -	 */
> > -	set_bit(BTRFS_INODE_NO_DELALLOC_FLUSH, &inode->runtime_flags);
> > -
> >   	if (comp_type == BTRFS_COMPRESS_NONE) {
> >   		memcpy_to_folio(folio, offset_in_folio(folio, file_offset), data_start,
> >   					datal);
> > @@ -140,6 +140,14 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
> >   	if (datal < block_size)
> >   		folio_zero_range(folio, datal, block_size - datal);
> > +	/*
> > +	 * A commit may start writeback before all extwriters have left the
> > +	 * transaction.  Update i_size while the folio is still locked and before
> > +	 * marking it dirty, so that writeback cannot treat it as being beyond EOF.
> > +	 */
> > +	if (file_offset + datal > i_size_read(&inode->vfs_inode))
> > +		i_size_write(&inode->vfs_inode, file_offset + datal);
> > +
> >   	btrfs_folio_set_uptodate(fs_info, folio, file_offset, block_size);
> >   	btrfs_folio_set_dirty(fs_info, folio, file_offset, block_size);
> >   out_unlock:
> > @@ -150,6 +158,10 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
> >   	if (ret)
> >   		btrfs_delalloc_release_space(inode, data_reserved, file_offset,
> >   					     block_size, true);
> > +	if (ret && *trans_out) {
> > +		btrfs_end_transaction(*trans_out);
> > +		*trans_out = NULL;
> > +	}
> >   	btrfs_delalloc_release_extents(inode, block_size);
> >   out:
> >   	extent_changeset_free(data_reserved);
> > @@ -180,12 +192,11 @@ static int clone_copy_inline_extent(struct btrfs_inode *inode,
> >   	struct btrfs_drop_extents_args drop_args = { 0 };
> >   	int ret;
> >   	struct btrfs_key key;
> > -	bool copied_inline_to_page = false;
> >   	if (new_key->offset > 0) {
> >   		ret = copy_inline_to_page(inode, new_key->offset,
> > -					  inline_data, size, datal, comp_type);
> > -		copied_inline_to_page = (ret == 0);
> > +					  inline_data, size, datal, comp_type,
> > +					  &trans);
> >   		goto out;
> >   	}
> > @@ -290,73 +301,6 @@ static int clone_copy_inline_extent(struct btrfs_inode *inode,
> >   	if (unlikely(ret))
> >   		btrfs_abort_transaction(trans, ret);
> >   out:
> > -	if (!ret && !trans) {
> > -		if (copied_inline_to_page &&
> > -		    new_key->offset + datal > i_size_read(&inode->vfs_inode)) {
> > -			/*
> > -			 * If we copied the inline extent data to a page/folio
> > -			 * beyond the i_size of the destination inode, then we
> > -			 * need to increase the i_size before we start a
> > -			 * transaction to update the inode item. This is to
> > -			 * prevent a deadlock when the flushoncommit mount
> > -			 * option is used, which happens like this:
> > -			 *
> > -			 * 1) Task A clones an inline extent from inode X to an
> > -			 *    offset of inode Y that is beyond Y's current
> > -			 *    i_size. This means we copied the inline extent's
> > -			 *    data to a folio of inode Y that is beyond its EOF,
> > -			 *    using the call above to copy_inline_to_page();
> > -			 *
> > -			 * 2) Task B starts a transaction commit and calls
> > -			 *    btrfs_start_delalloc_flush() to flush delalloc;
> > -			 *
> > -			 * 3) The delalloc flushing sees the new dirty folio of
> > -			 *    inode Y and when it attempts to flush it, it ends
> > -			 *    up at extent_writepage() and sees that the offset
> > -			 *    of the folio is beyond the i_size of inode Y, so
> > -			 *    it attempts to invalidate the folio by calling
> > -			 *    folio_invalidate(), which ends up at btrfs' folio
> > -			 *    invalidate callback - btrfs_invalidate_folio().
> > -			 *    There it tries to lock the folio's range in inode
> > -			 *    Y's extent io tree, but it blocks since it's
> > -			 *    currently locked by task A - during reflink we
> > -			 *    lock the inodes and the source and destination
> > -			 *    ranges after flushing all delalloc and waiting for
> > -			 *    ordered extent completion - after that we don't
> > -			 *    expect to have dirty folios in the ranges, the
> > -			 *    exception is if we have to copy an inline extent's
> > -			 *    data (because the destination offset is not zero);
> > -			 *
> > -			 * 4) Task A then does the 'goto out' below and attempts
> > -			 *    to start a transaction to update the inode item,
> > -			 *    and then it's blocked since the current
> > -			 *    transaction is in the TRANS_STATE_COMMIT_START
> > -			 *    state. Therefore task A has to wait for the
> > -			 *    current transaction to become unblocked (its
> > -			 *    state >= TRANS_STATE_UNBLOCKED).
> > -			 *
> > -			 * This leads to a deadlock - the task committing the
> > -			 * transaction waiting for the delalloc flushing which
> > -			 * is blocked during folio invalidation on the inode's
> > -			 * extent lock and the reflink task waiting for the
> > -			 * current transaction to be unblocked so that it can
> > -			 * start a new one to update the inode item (while
> > -			 * holding the extent lock).
> > -			 */
> > -			i_size_write(&inode->vfs_inode, new_key->offset + datal);
> > -		}
> > -		/*
> > -		 * No transaction here means we copied the inline extent into a
> > -		 * page of the destination inode.
> > -		 *
> > -		 * 1 unit to update inode item
> > -		 */
> > -		trans = btrfs_start_transaction(root, 1);
> > -		if (IS_ERR(trans)) {
> > -			ret = PTR_ERR(trans);
> > -			trans = NULL;
> > -		}
> > -	}
> >   	if (ret && trans)
> >   		btrfs_end_transaction(trans);
> >   	if (!ret)
> > @@ -376,8 +320,7 @@ static int clone_copy_inline_extent(struct btrfs_inode *inode,
> >   	btrfs_release_path(path);
> >   	ret = copy_inline_to_page(inode, new_key->offset,
> > -				  inline_data, size, datal, comp_type);
> > -	copied_inline_to_page = (ret == 0);
> > +				  inline_data, size, datal, comp_type, &trans);
> >   	goto out;
> >   }
> > @@ -665,8 +608,6 @@ static int btrfs_clone(struct btrfs_inode *src, struct btrfs_inode *inode,
> >   	}
> >   out:
> > -	clear_bit(BTRFS_INODE_NO_DELALLOC_FLUSH, &inode->runtime_flags);
> > -
> >   	return ret;
> >   }
> > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > index dca357016..e0febffaf 100644
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -7908,7 +7908,7 @@ static int flush_delalloc_roots(struct send_ctx *sctx)
> >   	int i;
> >   	if (root) {
> > -		ret = btrfs_start_delalloc_snapshot(root, false);
> > +		ret = btrfs_start_delalloc_snapshot(root);
> >   		if (ret)
> >   			return ret;
> >   		btrfs_wait_ordered_extents(root, U64_MAX, NULL);
> > @@ -7916,7 +7916,7 @@ static int flush_delalloc_roots(struct send_ctx *sctx)
> >   	for (i = 0; i < sctx->clone_roots_cnt; i++) {
> >   		root = sctx->clone_roots[i].root;
> > -		ret = btrfs_start_delalloc_snapshot(root, false);
> > +		ret = btrfs_start_delalloc_snapshot(root);
> >   		if (ret)
> >   			return ret;
> >   		btrfs_wait_ordered_extents(root, U64_MAX, NULL);
> > diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> > index 39a28e1be..7915819d7 100644
> > --- a/fs/btrfs/space-info.c
> > +++ b/fs/btrfs/space-info.c
> > @@ -770,7 +770,7 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
> >   		long nr_pages = min_t(u64, temp, LONG_MAX);
> >   		int async_pages;
> > -		btrfs_start_delalloc_roots(fs_info, nr_pages, true);
> > +		btrfs_start_delalloc_roots(fs_info, nr_pages);
> >   		/*
> >   		 * We need to make sure any outstanding async pages are now

Thanks for the review. I'll address your comments and send a v2.

