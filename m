From: Josef Bacik <josef@redhat.com>
Subject: Re: Delayed inode operations not doing the right thing with enospc
Date: Thu, 14 Jul 2011 17:12:52 -0400
Message-ID: <4E1F5BD4.90900@redhat.com>
References: <4DE92BF2.1060905@redhat.com>	<4DED8143.3090803@cn.fujitsu.com>	<4DEE9263.1000802@redhat.com>	<CAO47_--zux0kiKsY9Edinj98ihoXP4n2ton+j5LgdpNJv9hLbQ@mail.gmail.com>	<4E1DB22F.1060405@redhat.com> <CAO47_-9qn31AfGQksLnRAreMudBcOQz0UnXxmhFC4cSQW5ZHFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: miaox@cn.fujitsu.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
	ceph-devel@vger.kernel.org
To: chb@muc.de
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAO47_-9qn31AfGQksLnRAreMudBcOQz0UnXxmhFC4cSQW5ZHFQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/14/2011 03:27 AM, Christian Brunner wrote:
> 2011/7/13 Josef Bacik <josef@redhat.com>:
>> On 07/12/2011 11:20 AM, Christian Brunner wrote:
>>> 2011/6/7 Josef Bacik <josef@redhat.com>:
>>>> On 06/06/2011 09:39 PM, Miao Xie wrote:
>>>>> On fri, 03 Jun 2011 14:46:10 -0400, Josef Bacik wrote:
>>>>>> I got a lot of these when running stress.sh on my test box
>>>>>>
>>>>>>
>>>>>>
>>>>>> This is because use_block_rsv() is having to do a
>>>>>> reserve_metadata_bytes(), which shouldn't happen as we should have
>>>>>> reserved enough space for those operations to complete.  This is
>>>>>> happening because use_block_rsv() will call get_block_rsv(), which if
>>>>>> root->ref_cows is set (which is the case on all fs roots) we will use
>>>>>> trans->block_rsv, which will only have what the current transaction
>>>>>> starter had reserved.
>>>>>>
>>>>>> What needs to be done instead is we need to have a block reserve that
>>>>>> any reservation that is done at create time for these inodes is migrated
>>>>>> to this special reserve, and then when you run the delayed inode items
>>>>>> stuff you set trans->block_rsv to the special block reserve so the
>>>>>> accounting is all done properly.
>>>>>>
>>>>>> This is just off the top of my head, there may be a better way to do it,
>>>>>> I've not actually looked that the delayed inode code at all.
>>>>>>
>>>>>> I would do this myself but I have a ever increasing list of shit to do
>>>>>> so will somebody pick this up and fix it please?  Thanks,
>>>>>
>>>>> Sorry, it's my miss.
>>>>> I forgot to set trans->block_rsv to global_block_rsv, since we have migrated
>>>>> the space from trans_block_rsv to global_block_rsv.
>>>>>
>>>>> I'll fix it soon.
>>>>>
>>>>
>>>> There is another problem, we're failing xfstest 204.  I tried making
>>>> reserve_metadata_bytes commit the transaction regardless of whether or
>>>> not there were pinned bytes but the test just hung there.  Usually it
>>>> takes 7 seconds to run and I ctrl+c'ed it after a couple of minutes.
>>>> 204 just creates a crap ton of files, which is what is killing us.
>>>> There needs to be a way to start flushing delayed inode items so we can
>>>> reclaim the space they are holding onto so we don't get enospc, and it
>>>> needs to be better than just committing the transaction because that is
>>>> dog slow.  Thanks,
>>>>
>>>> Josef
>>>
>>> Is there a solution for this?
>>>
>>> I'm running a 2.6.38.8 kernel with all the btrfs patches from 3.0rc7
>>> (except the pluging). When starting a ceph rebuild on the btrfs
>>> volumes I get a lot of warnings from block_rsv_use_bytes in
>>> use_block_rsv:
>>>
>>
>> Ok I think I've got this nailed down.  Will you run with this patch and make sure the warnings go away?  Thanks,
> 
> I'm sorry, I'm still getting a lot of warnings like the one below.
> 
> I've also noticed, that I'm not getting these messages when the
> free_space_cache is disabled.
> 

Ok ditch that previous patch and try this one, it should work.  Thanks,

Josef


diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 52d7eca..2263d29 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -112,9 +112,6 @@ struct btrfs_inode {
 	 */
 	u64 disk_i_size;

-	/* flags field from the on disk inode */
-	u32 flags;
-
 	/*
 	 * if this is a directory then index_cnt is the counter for the index
 	 * number for new files that are created
@@ -128,14 +125,8 @@ struct btrfs_inode {
 	 */
 	u64 last_unlink_trans;

-	/*
-	 * Counters to keep track of the number of extent item's we may use due
-	 * to delalloc and such.  outstanding_extents is the number of extent
-	 * items we think we'll end up using, and reserved_extents is the number
-	 * of extent items we've reserved metadata for.
-	 */
-	atomic_t outstanding_extents;
-	atomic_t reserved_extents;
+	/* flags field from the on disk inode */
+	u32 flags;

 	/*
 	 * ordered_data_close is set by truncate when a file that used
@@ -151,12 +142,21 @@ struct btrfs_inode {
 	unsigned orphan_meta_reserved:1;
 	unsigned dummy_inode:1;
 	unsigned in_defrag:1;
-
 	/*
 	 * always compress this one file
 	 */
 	unsigned force_compress:4;

+	/*
+	 * Counters to keep track of the number of extent item's we may use due
+	 * to delalloc and such.  outstanding_extents is the number of extent
+	 * items we think we'll end up using, and reserved_extents is the number
+	 * of extent items we've reserved metadata for.
+	 */
+	spinlock_t extents_count_lock;
+	unsigned outstanding_extents;
+	unsigned reserved_extents;
+
 	struct btrfs_delayed_node *delayed_node;

 	struct inode vfs_inode;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index be02cae..3ba4d5f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2133,7 +2133,7 @@ static inline bool btrfs_mixed_space_info(struct
btrfs_space_info *space_info)

 /* extent-tree.c */
 static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
-						 int num_items)
+						 unsigned num_items)
 {
 	return (root->leafsize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
 		3 * num_items;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3e52b85..65a721c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3952,13 +3952,35 @@ static u64 calc_csum_metadata_size(struct inode
*inode, u64 num_bytes)
 	return num_bytes >>= 3;
 }

+static unsigned drop_outstanding_extent(struct inode *inode)
+{
+	unsigned dropped_extents = 0;
+
+	spin_lock(&BTRFS_I(inode)->extents_count_lock);
+	BTRFS_I(inode)->outstanding_extents--;
+
+	/*
+	 * If we have more or the same amount of outsanding extents than we have
+	 * reserved then we need to leave the reserved extents count alone.
+	 */
+	if (BTRFS_I(inode)->outstanding_extents >=
+	    BTRFS_I(inode)->reserved_extents)
+		goto out;
+
+	dropped_extents = BTRFS_I(inode)->reserved_extents -
+		BTRFS_I(inode)->outstanding_extents;
+	BTRFS_I(inode)->reserved_extents -= dropped_extents;
+out:
+	spin_unlock(&BTRFS_I(inode)->extents_count_lock);
+	return dropped_extents;
+}
+
 int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *block_rsv = &root->fs_info->delalloc_block_rsv;
 	u64 to_reserve;
-	int nr_extents;
-	int reserved_extents;
+	unsigned nr_extents;
 	int ret;

 	if (btrfs_transaction_in_commit(root->fs_info))
@@ -3966,24 +3988,31 @@ int btrfs_delalloc_reserve_metadata(struct inode
*inode, u64 num_bytes)

 	num_bytes = ALIGN(num_bytes, root->sectorsize);

-	nr_extents = atomic_read(&BTRFS_I(inode)->outstanding_extents) + 1;
-	reserved_extents = atomic_read(&BTRFS_I(inode)->reserved_extents);
+	spin_lock(&BTRFS_I(inode)->extents_count_lock);
+	BTRFS_I(inode)->outstanding_extents++;

-	if (nr_extents > reserved_extents) {
-		nr_extents -= reserved_extents;
+	if (BTRFS_I(inode)->outstanding_extents >
+	    BTRFS_I(inode)->reserved_extents) {
+		nr_extents = BTRFS_I(inode)->outstanding_extents -
+			BTRFS_I(inode)->reserved_extents;
 		to_reserve = btrfs_calc_trans_metadata_size(root, nr_extents);
 	} else {
 		nr_extents = 0;
 		to_reserve = 0;
 	}
+	BTRFS_I(inode)->reserved_extents += nr_extents;
+	spin_unlock(&BTRFS_I(inode)->extents_count_lock);

 	to_reserve += calc_csum_metadata_size(inode, num_bytes);
 	ret = reserve_metadata_bytes(NULL, root, block_rsv, to_reserve, 1);
-	if (ret)
+	if (ret) {
+		/*
+		 * We don't need the return value since our reservation failed,
+		 * we just need to clean up our counter.
+		 */
+		drop_outstanding_extent(inode);
 		return ret;
-
-	atomic_add(nr_extents, &BTRFS_I(inode)->reserved_extents);
-	atomic_inc(&BTRFS_I(inode)->outstanding_extents);
+	}

 	block_rsv_add_bytes(block_rsv, to_reserve, 1);

@@ -3997,35 +4026,14 @@ void btrfs_delalloc_release_metadata(struct
inode *inode, u64 num_bytes)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 to_free;
-	int nr_extents;
-	int reserved_extents;
+	unsigned dropped;

 	num_bytes = ALIGN(num_bytes, root->sectorsize);
-	atomic_dec(&BTRFS_I(inode)->outstanding_extents);
-	WARN_ON(atomic_read(&BTRFS_I(inode)->outstanding_extents) < 0);
-
-	reserved_extents = atomic_read(&BTRFS_I(inode)->reserved_extents);
-	do {
-		int old, new;
-
-		nr_extents = atomic_read(&BTRFS_I(inode)->outstanding_extents);
-		if (nr_extents >= reserved_extents) {
-			nr_extents = 0;
-			break;
-		}
-		old = reserved_extents;
-		nr_extents = reserved_extents - nr_extents;
-		new = reserved_extents - nr_extents;
-		old = atomic_cmpxchg(&BTRFS_I(inode)->reserved_extents,
-				     reserved_extents, new);
-		if (likely(old == reserved_extents))
-			break;
-		reserved_extents = old;
-	} while (1);
+	dropped = drop_outstanding_extent(inode);

 	to_free = calc_csum_metadata_size(inode, num_bytes);
-	if (nr_extents > 0)
-		to_free += btrfs_calc_trans_metadata_size(root, nr_extents);
+	if (dropped > 0)
+		to_free += btrfs_calc_trans_metadata_size(root, dropped);

 	btrfs_block_rsv_release(root, &root->fs_info->delalloc_block_rsv,
 				to_free);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3c8c435..0997526 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1239,9 +1239,11 @@ static noinline ssize_t
__btrfs_buffered_write(struct file *file,
 		 * managed to copy.
 		 */
 		if (num_pages > dirty_pages) {
-			if (copied > 0)
-				atomic_inc(
-					&BTRFS_I(inode)->outstanding_extents);
+			if (copied > 0) {
+				spin_lock(&BTRFS_I(inode)->extents_count_lock);
+				BTRFS_I(inode)->outstanding_extents++;
+				spin_unlock(&BTRFS_I(inode)->extents_count_lock);
+			}
 			btrfs_delalloc_release_space(inode,
 					(num_pages - dirty_pages) <<
 					PAGE_CACHE_SHIFT);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index faf516e..3a2be0c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1298,7 +1298,9 @@ static int btrfs_split_extent_hook(struct inode
*inode,
 	if (!(orig->state & EXTENT_DELALLOC))
 		return 0;

-	atomic_inc(&BTRFS_I(inode)->outstanding_extents);
+	spin_lock(&BTRFS_I(inode)->extents_count_lock);
+	BTRFS_I(inode)->outstanding_extents++;
+	spin_unlock(&BTRFS_I(inode)->extents_count_lock);
 	return 0;
 }

@@ -1316,7 +1318,9 @@ static int btrfs_merge_extent_hook(struct inode
*inode,
 	if (!(other->state & EXTENT_DELALLOC))
 		return 0;

-	atomic_dec(&BTRFS_I(inode)->outstanding_extents);
+	spin_lock(&BTRFS_I(inode)->extents_count_lock);
+	BTRFS_I(inode)->outstanding_extents--;
+	spin_unlock(&BTRFS_I(inode)->extents_count_lock);
 	return 0;
 }

@@ -1339,10 +1343,13 @@ static int btrfs_set_bit_hook(struct inode *inode,
 		u64 len = state->end + 1 - state->start;
 		bool do_list = !is_free_space_inode(root, inode);

-		if (*bits & EXTENT_FIRST_DELALLOC)
+		if (*bits & EXTENT_FIRST_DELALLOC) {
 			*bits &= ~EXTENT_FIRST_DELALLOC;
-		else
-			atomic_inc(&BTRFS_I(inode)->outstanding_extents);
+		} else {
+			spin_lock(&BTRFS_I(inode)->extents_count_lock);
+			BTRFS_I(inode)->outstanding_extents++;
+			spin_unlock(&BTRFS_I(inode)->extents_count_lock);
+		}

 		spin_lock(&root->fs_info->delalloc_lock);
 		BTRFS_I(inode)->delalloc_bytes += len;
@@ -1372,10 +1379,13 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 		u64 len = state->end + 1 - state->start;
 		bool do_list = !is_free_space_inode(root, inode);

-		if (*bits & EXTENT_FIRST_DELALLOC)
+		if (*bits & EXTENT_FIRST_DELALLOC) {
 			*bits &= ~EXTENT_FIRST_DELALLOC;
-		else if (!(*bits & EXTENT_DO_ACCOUNTING))
-			atomic_dec(&BTRFS_I(inode)->outstanding_extents);
+		} else if (!(*bits & EXTENT_DO_ACCOUNTING)) {
+			spin_lock(&BTRFS_I(inode)->extents_count_lock);
+			BTRFS_I(inode)->outstanding_extents--;
+			spin_unlock(&BTRFS_I(inode)->extents_count_lock);
+		}

 		if (*bits & EXTENT_DO_ACCOUNTING)
 			btrfs_delalloc_release_metadata(inode, len);
@@ -6777,8 +6787,9 @@ struct inode *btrfs_alloc_inode(struct super_block
*sb)
 	ei->index_cnt = (u64)-1;
 	ei->last_unlink_trans = 0;

-	atomic_set(&ei->outstanding_extents, 0);
-	atomic_set(&ei->reserved_extents, 0);
+	spin_lock_init(&ei->extents_count_lock);
+	ei->outstanding_extents = 0;
+	ei->reserved_extents = 0;

 	ei->ordered_data_close = 0;
 	ei->orphan_meta_reserved = 0;
@@ -6816,8 +6827,8 @@ void btrfs_destroy_inode(struct inode *inode)

 	WARN_ON(!list_empty(&inode->i_dentry));
 	WARN_ON(inode->i_data.nrpages);
-	WARN_ON(atomic_read(&BTRFS_I(inode)->outstanding_extents));
-	WARN_ON(atomic_read(&BTRFS_I(inode)->reserved_extents));
+	WARN_ON(BTRFS_I(inode)->outstanding_extents);
+	WARN_ON(BTRFS_I(inode)->reserved_extents);

 	/*
 	 * This can happen where we create an inode, but somebody else also
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 09c9a8d..42f4487 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -938,7 +938,9 @@ again:
 			  GFP_NOFS);

 	if (i_done != num_pages) {
-		atomic_inc(&BTRFS_I(inode)->outstanding_extents);
+		spin_lock(&BTRFS_I(inode)->extents_count_lock);
+		BTRFS_I(inode)->outstanding_extents++;
+		spin_unlock(&BTRFS_I(inode)->extents_count_lock);
 		btrfs_delalloc_release_space(inode,
 				     (num_pages - i_done) << PAGE_CACHE_SHIFT);
 	}
