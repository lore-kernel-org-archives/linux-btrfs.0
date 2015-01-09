Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34686 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbbAISkf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 13:40:35 -0500
Date: Fri, 9 Jan 2015 10:40:15 -0800
From: Shaohua Li <shli@fb.com>
To: Miao Xie <miaoxie@huawei.com>
CC: <linux-btrfs@vger.kernel.org>, <Kernel-team@fb.com>
Subject: Re: [PATCH] btrfs: delete chunk allocation attemp when setting block
 group ro
Message-ID: <20150109184015.GA1363690@devbig257.prn2.facebook.com>
References: <ad987515563f59adfc028f23693d4a151a333846.1420752193.git.shli@fb.com>
 <54AF2885.40708@huawei.com>
 <20150109020650.GA3565386@devbig257.prn2.facebook.com>
 <54AF41E9.2000609@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <54AF41E9.2000609@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 09, 2015 at 10:50:17AM +0800, Miao Xie wrote:
> On Thu, 08 Jan 2015 18:06:50 -0800, Shaohua Li wrote:
> > On Fri, Jan 09, 2015 at 09:01:57AM +0800, Miao Xie wrote:
> >> On Thu, 08 Jan 2015 13:23:13 -0800, Shaohua Li wrote:
> >>> Below test will fail currently:
> >>>   mkfs.ext4 -F /dev/sda
> >>>   btrfs-convert /dev/sda
> >>>   mount /dev/sda /mnt
> >>>   btrfs device add -f /dev/sdb /mnt
> >>>   btrfs balance start -v -dconvert=raid1 -mconvert=raid1 /mnt
> >>>
> >>> The reason is there are some block groups with usage 0, but the whole
> >>> disk hasn't free space to allocate new chunk, so we even can't set such
> >>> block group readonly. This patch deletes the chunk allocation when
> >>> setting block group ro. For META, we already have reserve. But for
> >>> SYSTEM, we don't have, so the check_system_chunk is still required.
> >>>
> >>> Signed-off-by: Shaohua Li <shli@fb.com>
> >>> ---
> >>>  fs/btrfs/extent-tree.c | 31 +++++++------------------------
> >>>  1 file changed, 7 insertions(+), 24 deletions(-)
> >>>
> >>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> >>> index a80b971..430101b6 100644
> >>> --- a/fs/btrfs/extent-tree.c
> >>> +++ b/fs/btrfs/extent-tree.c
> >>> @@ -8493,22 +8493,8 @@ static int set_block_group_ro(struct btrfs_block_group_cache *cache, int force)
> >>>  {
> >>>  	struct btrfs_space_info *sinfo = cache->space_info;
> >>>  	u64 num_bytes;
> >>> -	u64 min_allocable_bytes;
> >>>  	int ret = -ENOSPC;
> >>>  
> >>> -
> >>> -	/*
> >>> -	 * We need some metadata space and system metadata space for
> >>> -	 * allocating chunks in some corner cases until we force to set
> >>> -	 * it to be readonly.
> >>> -	 */
> >>> -	if ((sinfo->flags &
> >>> -	     (BTRFS_BLOCK_GROUP_SYSTEM | BTRFS_BLOCK_GROUP_METADATA)) &&
> >>> -	    !force)
> >>> -		min_allocable_bytes = 1 * 1024 * 1024;
> >>> -	else
> >>> -		min_allocable_bytes = 0;
> >>> -
> >>>  	spin_lock(&sinfo->lock);
> >>>  	spin_lock(&cache->lock);
> >>>  
> [SNIP]
> >>>  	ret = set_block_group_ro(cache, 0);
> >>>  	if (!ret)
> >>>  		goto out;
> >>> @@ -8566,6 +8544,11 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
> >>>  		goto out;
> >>>  	ret = set_block_group_ro(cache, 0);
> >>>  out:
> >>> +	if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
> >>> +		alloc_flags = update_block_group_flags(root, cache->flags);
> >>> +		check_system_chunk(trans, root, alloc_flags);
> >>
> >> Please consider the case that the following patch fixed
> >>   199c36eaa95077a47ae1bc55532fc0fbeb80cc95
> >>
> >> If there is no free device space, check_system_chunk can not allocate
> >> new system metadata chunk, so when we run final step of the chunk
> >> allocation to update the device item and insert the new chunk item, we
> >> would fail.
> > 
> > So the relocation will always fail in this case. The check just makes
> > the failure earlier, right? We don't have the BUG_ON in
> > do_chunk_alloc() currently.
> 
> The final step of the chunk allocation is a delayed operation, we must make sure
> it can be done successfully, or we would abort the transaction, make the
> filesystem readonly and lose the data that is written into the filesystem before
> we do balance, it would make the users unconfortable.
> 
> With this patch, we will set the block group successfully at the first time we
> invoke set_block_group_ro(). But if the block group that will be set to RO is
> the only system metadata block group in the filesystem, and there is no device
> space to allocate a new one, that is we have no space to deal with the pending
> final step of chunk allocation, so the problem I said above will happen.

Ok, makes sense. Updated patch:


commit d8c84ce6d40b471f5d0fb3d4e8b76d5ba424dca4
Author: Shaohua Li <shli@fb.com>
Date:   Wed Jan 7 14:29:49 2015 -0800

    btrfs: delete chunk allocation attemp when setting block group ro
    
    Below test will fail currently:
      mkfs.ext4 -F /dev/sda
      btrfs-convert /dev/sda
      mount /dev/sda /mnt
      btrfs device add -f /dev/sdb /mnt
      btrfs balance start -v -dconvert=raid1 -mconvert=raid1 /mnt
    
    The reason is there are some block groups with usage 0, but the whole
    disk hasn't free space to allocate new chunk, so we even can't set such
    block group readonly. This patch deletes the chunk allocation when
    setting block group ro. For META, we already have reserve. But for
    SYSTEM, we don't have, so the check_system_chunk is still required.
    
    Signed-off-by: Shaohua Li <shli@fb.com>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a80b971..be1aac6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8548,14 +8548,6 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	alloc_flags = update_block_group_flags(root, cache->flags);
-	if (alloc_flags != cache->flags) {
-		ret = do_chunk_alloc(trans, root, alloc_flags,
-				     CHUNK_ALLOC_FORCE);
-		if (ret < 0)
-			goto out;
-	}
-
 	ret = set_block_group_ro(cache, 0);
 	if (!ret)
 		goto out;
@@ -8566,6 +8558,11 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 		goto out;
 	ret = set_block_group_ro(cache, 0);
 out:
+	if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
+		alloc_flags = update_block_group_flags(root, cache->flags);
+		check_system_chunk(trans, root, alloc_flags);
+	}
+
 	btrfs_end_transaction(trans, root);
 	return ret;
 }
