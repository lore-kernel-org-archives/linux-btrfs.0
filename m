From: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Subject: Re: [PATCH] Btrfs: fix tree corruption after multi-thread snapshots
 and inode cache flush
Date: Thu, 29 Sep 2011 16:36:26 +0800
Message-ID: <4E842E0A.60808@linux.intel.com>
References: <1317261627-17265-1-git-send-email-liubo2009@cn.fujitsu.com> <4E83F354.3030102@linux.intel.com> <4E8429DE.1030501@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, josef@redhat.com,
	chris.mason@oracle.com, lizf@cn.fujitsu.com, miaox@cn.fujitsu.com,
	dave@jikos.cz
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E8429DE.1030501@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/29/2011 04:18 PM, Liu Bo wrote:
> On 09/29/2011 12:25 PM, Yan, Zheng wrote:
>> On 09/29/2011 10:00 AM, Liu Bo wrote:
>>> The btrfs snapshotting code requires that once a root has been
>>> snapshotted, we don't change it during a commit.
>>>
>>> But there are two cases to lead to tree corruptions:
>>>
>>> 1) multi-thread snapshots can commit serveral snapshots in a transaction,
>>>    and this may change the src root when processing the following pending
>>>    snapshots, which lead to the former snapshots corruptions;
>>>
>>> 2) the free inode cache was changing the roots when it root the cache,
>>>    which lead to corruptions.
>>>
>> For the case 2, the free inode cache of newly created snapshot is invalid.
>> So it's better to avoid modifying snapshotted trees.
>>
> 
> For case 2, with flushing dirty inode cache during create_pending_snapshot,
> we can avoid modifying snapshotted trees as your advice.
> 
> But for case 1, I have no idea how to do the same thing, since we are not
> allowed to commit per snapshot, which will make the performance terrible.
> 
I think commit per snapshot is acceptable. If you want better solution, build
a dependency graph. http://en.wikipedia.org/wiki/Dependency_graph

> thanks,
> liubo
> 
> 
>>> This fixes things by making sure we force COW the block after we create a
>>> snapshot during commiting a transaction, then any changes to the roots
>>> will result in COW, and we get all the fs roots and snapshot roots to be
>>> consistent.
>>>
>>> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
>>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>>> ---
>>>  fs/btrfs/ctree.c       |   17 ++++++++++++++++-
>>>  fs/btrfs/ctree.h       |    2 ++
>>>  fs/btrfs/transaction.c |    8 ++++++++
>>>  3 files changed, 26 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>>> index 011cab3..49dad7d 100644
>>> --- a/fs/btrfs/ctree.c
>>> +++ b/fs/btrfs/ctree.c
>>> @@ -514,10 +514,25 @@ static inline int should_cow_block(struct btrfs_trans_handle *trans,
>>>  				   struct btrfs_root *root,
>>>  				   struct extent_buffer *buf)
>>>  {
>>> +	/* ensure we can see the force_cow */
>>> +	smp_rmb();
>>> +
>>> +	/*
>>> +	 * We do not need to cow a block if
>>> +	 * 1) this block is not created or changed in this transaction;
>>> +	 * 2) this block does not belong to TREE_RELOC tree;
>>> +	 * 3) the root is not forced COW.
>>> +	 *
>>> +	 * What is forced COW:
>>> +	 *    when we create snapshot during commiting the transaction,
>>> +	 *    after we've finished coping src root, we must COW the shared
>>> +	 *    block to ensure the metadata consistency.
>>> +	 */
>>>  	if (btrfs_header_generation(buf) == trans->transid &&
>>>  	    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN) &&
>>>  	    !(root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID &&
>>> -	      btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC)))
>>> +	      btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC)) &&
>>> +	    !root->force_cow)
>>>  		return 0;
>>>  	return 1;
>>>  }
>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>> index 03912c5..bece0df 100644
>>> --- a/fs/btrfs/ctree.h
>>> +++ b/fs/btrfs/ctree.h
>>> @@ -1225,6 +1225,8 @@ struct btrfs_root {
>>>  	 * for stat.  It may be used for more later
>>>  	 */
>>>  	dev_t anon_dev;
>>> +
>>> +	int force_cow;
>>>  };
>>>  
>>>  struct btrfs_ioctl_defrag_range_args {
>>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>>> index 7dc36fa..bf6e2b3 100644
>>> --- a/fs/btrfs/transaction.c
>>> +++ b/fs/btrfs/transaction.c
>>> @@ -816,6 +816,10 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
>>>  
>>>  			btrfs_save_ino_cache(root, trans);
>>>  
>>> +			/* see comments in should_cow_block() */
>>> +			root->force_cow = 0;
>>> +			smp_wmb();
>>> +
>>>  			if (root->commit_root != root->node) {
>>>  				mutex_lock(&root->fs_commit_mutex);
>>>  				switch_commit_root(root);
>>> @@ -976,6 +980,10 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>>>  	btrfs_tree_unlock(old);
>>>  	free_extent_buffer(old);
>>>  
>>> +	/* see comments in should_cow_block() */
>>> +	root->force_cow = 1;
>>> +	smp_wmb();
>>> +
>>>  	btrfs_set_root_node(new_root_item, tmp);
>>>  	/* record when the snapshot was created in key.offset */
>>>  	key.offset = trans->transid;
>>
>>
> 

