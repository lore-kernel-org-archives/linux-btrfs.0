Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49945 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751112AbeDLL4g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Apr 2018 07:56:36 -0400
Subject: Re: [PATCH 2/2] btrfs: Do first key check under proper lock context
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180412100003.31907-1-wqu@suse.com>
 <20180412100003.31907-2-wqu@suse.com>
 <d87827bd-5e04-5d40-a2e9-d7745691efff@suse.com>
 <d06cfef4-a16f-3335-2500-4d932604147c@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <72b7a84e-7793-4182-d2f3-19092f79a60b@suse.com>
Date: Thu, 12 Apr 2018 14:56:33 +0300
MIME-Version: 1.0
In-Reply-To: <d06cfef4-a16f-3335-2500-4d932604147c@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12.04.2018 14:48, Qu Wenruo wrote:
> 
> 
> On 2018年04月12日 18:59, Nikolay Borisov wrote:
>>
>>
>> On 12.04.2018 13:00, Qu Wenruo wrote:
>>> The original first key check is handled in
>>> btree_read_extent_buffer_pages(), which is good enough for level check,
>>> but to verify first key, we need at least read lock on the extent
>>> buffer, or we can hit some race and cause false alert.
>>>
>>> Fix it by adding new verifcation function: btrfs_verify_first_key(),
>>> which will first check lock context of both parent and child extent
>>> buffer, and only when we have proper lock hold (write or read lock if
>> So if the extent buffer is not in commit root, i.e it's active buffer in
>> current transaction (am I right?)
> 
> That's right.
> 
>> then we need write lock? It's not entirely clearly from that sentence.
> 
> Not really write lock. Either read or write (both spinning and blocking)
> is OK here.
> 
>>
>>> extent buffer is not in commit root) we will verify the first key.
>>>
>>> Most of the verification happens in ctree.c after function call like
>>> read_tree_block(), read_node_slot() and read_block_for_search(), and
>>> only call btrfs_verify_first_key() after we acquire read/write lock.
>>>
>>> Also, since first_key check is not as good as level and could easily
>>> trigger false alerts due to lock context, put it under
>>> CONFIG_BTRFS_FS_CHECK_INTEGRITY to avoid damage to end user.
>>
>> Why is first_key check not as good as level
> 
> Several reasons.
> 
> 1) Level tree check can prevent loop/nodes underflow caused by level
>    mismatch, but first_key can't
>    One problem we're trying to solve is, when level 1 node points to
>    another level 1 tree, we can still try to read next level tree block.
>    Which could underflow level.
>    first_key check can't really handle it.
> 
> 2) first_key needs extra lock to read out needed info, while level
>    check doesn't (hence easier and harder to cause false alert)
>    For a given tree block, its level won't change either for active eb
>    (modified in current trans) or committed eb.
>    But for first_key, we need proper lock to avoid race.
> 
> For short, first key check needs a lot of carefully reviewed check
> timing and error handlers, while most problem could be exposed by level
> check far before it hits first_key check.
> 
>> and why could it trigger
>> false alert, given this patch allegedly implements it under proper lock
>> context, thus eliminating false positives.
> 
> I mean the old and merged first_key check patch.

Right, I'd suggest you change the wording so it makes it clear that the
old patch was broken and not the concept of first_key in general
(because that's the impression I was left with).

> 
> Thanks,
> Qu
> 
>>
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>  fs/btrfs/ctree.c       | 69 ++++++++++++++++++++++++++++++++++++++++++
>>>  fs/btrfs/ctree.h       | 58 +++++++++++++++++++++++++++++++++++
>>>  fs/btrfs/extent-tree.c |  6 ++++
>>>  fs/btrfs/qgroup.c      |  5 +++
>>>  fs/btrfs/ref-verify.c  |  6 ++++
>>>  fs/btrfs/relocation.c  | 13 ++++++++
>>>  6 files changed, 157 insertions(+)
>>>
>>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>>> index e044b51a2789..57721aead371 100644
>>> --- a/fs/btrfs/ctree.c
>>> +++ b/fs/btrfs/ctree.c
>>> @@ -1649,6 +1649,11 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
>>>  
>>>  		btrfs_tree_lock(cur);
>>>  		btrfs_set_lock_blocking(cur);
>>> +		if (btrfs_verify_first_key(cur, parent, i)) {
>>> +			err = -EUCLEAN;
>>> +			btrfs_tree_unlock(cur);
>>> +			free_extent_buffer(cur);
>>> +		}
>>>  		err = __btrfs_cow_block(trans, root, cur, parent, i,
>>>  					&cur, search_start,
>>>  					min(16 * blocksize,
>>> @@ -1863,6 +1868,12 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>>>  
>>>  		btrfs_tree_lock(child);
>>>  		btrfs_set_lock_blocking(child);
>>> +		if (btrfs_verify_first_key(child, mid, 0)) {
>>> +			ret = -EUCLEAN;
>>> +			btrfs_tree_unlock(child);
>>> +			free_extent_buffer(child);
>>> +			goto enospc;
>>> +		}
>>>  		ret = btrfs_cow_block(trans, root, child, mid, 0, &child);
>>>  		if (ret) {
>>>  			btrfs_tree_unlock(child);
>>> @@ -1901,6 +1912,10 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>>>  	if (left) {
>>>  		btrfs_tree_lock(left);
>>>  		btrfs_set_lock_blocking(left);
>>> +		if (btrfs_verify_first_key(left, parent, pslot - 1)) {
>>> +			ret = -EUCLEAN;
>>> +			goto enospc;
>>> +		}
>>>  		wret = btrfs_cow_block(trans, root, left,
>>>  				       parent, pslot - 1, &left);
>>>  		if (wret) {
>>> @@ -1916,6 +1931,10 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>>>  	if (right) {
>>>  		btrfs_tree_lock(right);
>>>  		btrfs_set_lock_blocking(right);
>>> +		if (btrfs_verify_first_key(right, parent, pslot + 1)) {
>>> +			ret = -EUCLEAN;
>>> +			goto enospc;
>>> +		}
>>>  		wret = btrfs_cow_block(trans, root, right,
>>>  				       parent, pslot + 1, &right);
>>>  		if (wret) {
>>> @@ -2079,6 +2098,8 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
>>>  
>>>  		btrfs_tree_lock(left);
>>>  		btrfs_set_lock_blocking(left);
>>> +		if (btrfs_verify_first_key(left, parent, pslot - 1))
>>> +			goto left_out;
>>>  
>>>  		left_nr = btrfs_header_nritems(left);
>>>  		if (left_nr >= BTRFS_NODEPTRS_PER_BLOCK(fs_info) - 1) {
>>> @@ -2119,6 +2140,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
>>>  			}
>>>  			return 0;
>>>  		}
>>> +left_out:
>>>  		btrfs_tree_unlock(left);
>>>  		free_extent_buffer(left);
>>>  	}
>>> @@ -2134,6 +2156,8 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
>>>  
>>>  		btrfs_tree_lock(right);
>>>  		btrfs_set_lock_blocking(right);
>>> +		if (btrfs_verify_first_key(right, parent, pslot + 1))
>>> +			goto right_out;
>>>  
>>>  		right_nr = btrfs_header_nritems(right);
>>>  		if (right_nr >= BTRFS_NODEPTRS_PER_BLOCK(fs_info) - 1) {
>>> @@ -2174,6 +2198,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
>>>  			}
>>>  			return 0;
>>>  		}
>>> +right_out:
>>>  		btrfs_tree_unlock(right);
>>>  		free_extent_buffer(right);
>>>  	}
>>> @@ -2868,6 +2893,11 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>>>  					p->locks[level] = BTRFS_READ_LOCK;
>>>  				}
>>>  				p->nodes[level] = b;
>>> +				if (btrfs_verify_first_key(b, p->nodes[level + 1],
>>> +							   slot)) {
>>> +					ret = -EUCLEAN;
>>> +					goto done;
>>> +				}
>>>  			}
>>>  		} else {
>>>  			p->slots[level] = slot;
>>> @@ -2981,6 +3011,12 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
>>>  				goto done;
>>>  			}
>>>  
>>> +			/*
>>> +			 * NOTE: both parent and child go through
>>> +			 * tree_mod_log_rewind(), first key check is no
>>> +			 * longer consistent. So no btrfs_verify_first_key()
>>> +			 * for this read_block_for_search().
>>> +			 */
>>>  			err = read_block_for_search(root, p, &b, level,
>>>  						    slot, key);
>>>  			if (err == -EAGAIN)
>>> @@ -3753,6 +3789,8 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
>>>  
>>>  	btrfs_tree_lock(right);
>>>  	btrfs_set_lock_blocking(right);
>>> +	if (btrfs_verify_first_key(right, upper, slot + 1))
>>> +		goto out_unlock;
>>>  
>>>  	free_space = btrfs_leaf_free_space(fs_info, right);
>>>  	if (free_space < data_size)
>>> @@ -3987,6 +4025,10 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
>>>  
>>>  	btrfs_tree_lock(left);
>>>  	btrfs_set_lock_blocking(left);
>>> +	if (btrfs_verify_first_key(left, path->nodes[1], slot - 1)) {
>>> +		ret = 1;
>>> +		goto out;
>>> +	}
>>>  
>>>  	free_space = btrfs_leaf_free_space(fs_info, left);
>>>  	if (free_space < data_size) {
>>> @@ -5205,6 +5247,12 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
>>>  		}
>>>  
>>>  		btrfs_tree_read_lock(cur);
>>> +		if (btrfs_verify_first_key(cur, path->nodes[level], slot)) {
>>> +			btrfs_tree_read_unlock(cur);
>>> +			free_extent_buffer(cur);
>>> +			ret = -EUCLEAN;
>>> +			goto out;
>>> +		}
>>>  
>>>  		path->locks[level - 1] = BTRFS_READ_LOCK;
>>>  		path->nodes[level - 1] = cur;
>>> @@ -5232,6 +5280,11 @@ static int tree_move_down(struct btrfs_fs_info *fs_info,
>>>  	if (IS_ERR(eb))
>>>  		return PTR_ERR(eb);
>>>  
>>> +	if (btrfs_verify_first_key(eb, path->nodes[*level],
>>> +				   path->slots[*level])) {
>>> +		free_extent_buffer(eb);
>>> +		return -EUCLEAN;
>>> +	}
>>>  	path->nodes[*level - 1] = eb;
>>>  	path->slots[*level - 1] = 0;
>>>  	(*level)--;
>>> @@ -5786,6 +5839,14 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
>>>  							  BTRFS_READ_LOCK);
>>>  			}
>>>  			next_rw_lock = BTRFS_READ_LOCK;
>>> +			if (btrfs_verify_first_key(next, path->nodes[level],
>>> +						   slot)) {
>>> +				ret = -EUCLEAN;
>>> +				btrfs_tree_read_unlock(next);
>>> +				free_extent_buffer(next);
>>> +				btrfs_release_path(path);
>>> +				goto done;
>>> +			}
>>>  		}
>>>  		break;
>>>  	}
>>> @@ -5823,6 +5884,14 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
>>>  							  BTRFS_READ_LOCK);
>>>  			}
>>>  			next_rw_lock = BTRFS_READ_LOCK;
>>> +			if (btrfs_verify_first_key(next, path->nodes[level],
>>> +						   0)) {
>>> +				ret = -EUCLEAN;
>>> +				btrfs_tree_read_unlock(next);
>>> +				free_extent_buffer(next);
>>> +				btrfs_release_path(path);
>>> +				goto done;
>>> +			}
>>>  		}
>>>  	}
>>>  	ret = 0;
>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>> index 0eb55825862a..033d8ae027c3 100644
>>> --- a/fs/btrfs/ctree.h
>>> +++ b/fs/btrfs/ctree.h
>>> @@ -44,6 +44,7 @@
>>>  #include "extent_io.h"
>>>  #include "extent_map.h"
>>>  #include "async-thread.h"
>>> +#include "print-tree.h"
>>>  
>>>  struct btrfs_trans_handle;
>>>  struct btrfs_transaction;
>>> @@ -3752,4 +3753,61 @@ static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
>>>  #endif
>>>  	return 0;
>>>  }
>>> +
>>> +/*
>>> + * Verify the first key of an extent buffer matches with its parent pointer.
>>> + *
>>> + * For tree blocks in current transaction, caller should hold at least read lock
>>> + * for both @eb and @parent to avoid race.
>>> + * While for tree blocks in commit root, no such requirement.
>>> + */
>>> +static inline int btrfs_verify_first_key(struct extent_buffer *eb,
>>> +					 struct extent_buffer *parent, int slot)
>>> +{
>>> +#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
>>> +	struct btrfs_key parent_key;
>>> +	struct btrfs_key found_key;
>>> +	struct btrfs_fs_info *fs_info;
>>> +	u64 transid = 0;
>>> +	int ret;
>>> +
>>> +	if (!parent || !eb)
>>> +		return 0;
>>> +	fs_info = parent->fs_info;
>>> +	transid = fs_info->last_trans_committed;
>>> +	/*
>>> +	 * For first_key check, we need to ensure we have proper lock hold,
>>> +	 * or the content may change and cause false alert.
>>> +	 */
>>> +	if (btrfs_header_generation(eb) > transid &&
>>> +	    !atomic_read(&eb->read_locks) && !atomic_read(&eb->write_locks)) {
>>> +		WARN_ON(1);
>>> +		return 0;
>>> +	}
>>> +	if (btrfs_header_generation(parent) > transid &&
>>> +	    !atomic_read(&parent->read_locks) &&
>>> +	    !atomic_read(&parent->write_locks)) {
>>> +		WARN_ON(1);
>>> +		return 0;
>>> +	}
>>> +	btrfs_node_key_to_cpu(parent, &parent_key, slot);
>>> +	if (btrfs_header_level(eb))
>>> +		btrfs_node_key_to_cpu(eb, &found_key, 0);
>>> +	else
>>> +		btrfs_item_key_to_cpu(eb, &found_key, 0);
>>> +	ret =  btrfs_comp_cpu_keys(&found_key, &parent_key);
>>> +	if (ret) {
>>> +		WARN_ON(ret);
>>> +		btrfs_err(fs_info,
>>> +"tree first key mismatch detected, bytenr=%llu key expected=(%llu, %u, %llu) has=(%llu, %u, %llu)",
>>> +			  eb->start, parent_key.objectid, parent_key.type,
>>> +			  parent_key.offset, found_key.objectid,
>>> +			  found_key.type, found_key.offset);
>>> +	}
>>> +	return ret;
>>> +#else
>>> +	return 0;
>>> +#endif /* CONFIG_BTRFS_FS_CHECK_INTEGRITY */
>>> +}
>>> +
>>>  #endif
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index f080834e4dd0..17bd22a54281 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -8807,6 +8807,12 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>>>  		}
>>>  		btrfs_tree_lock(next);
>>>  		btrfs_set_lock_blocking(next);
>>> +		if (btrfs_verify_first_key(next, path->nodes[level],
>>> +					   path->slots[level])) {
>>> +			btrfs_tree_unlock(next);
>>> +			free_extent_buffer(next);
>>> +			goto out_unlock;
>>> +		}
>>>  	}
>>>  
>>>  	level--;
>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>> index c7f129356966..4c53954297d8 100644
>>> --- a/fs/btrfs/qgroup.c
>>> +++ b/fs/btrfs/qgroup.c
>>> @@ -1744,6 +1744,11 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
>>>  
>>>  			btrfs_tree_read_lock(eb);
>>>  			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
>>> +			if (btrfs_verify_first_key(eb, path->nodes[level + 1],
>>> +						   parent_slot)) {
>>> +				ret = -EUCLEAN;
>>> +				goto out;
>>> +			}
>>>  			path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
>>>  
>>>  			ret = btrfs_qgroup_trace_extent(trans, fs_info,
>>> diff --git a/fs/btrfs/ref-verify.c b/fs/btrfs/ref-verify.c
>>> index 6d856eabf34a..b996ca1fd9dc 100644
>>> --- a/fs/btrfs/ref-verify.c
>>> +++ b/fs/btrfs/ref-verify.c
>>> @@ -593,6 +593,12 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
>>>  			}
>>>  			btrfs_tree_read_lock(eb);
>>>  			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
>>> +			if (btrfs_verify_first_key(eb, path->nodes[level],
>>> +			    path->slots[level])) {
>>> +				btrfs_tree_read_unlock_blocking(eb);
>>> +				free_extent_buffer(eb);
>>> +				return -EUCLEAN;
>>> +			}
>>>  			path->nodes[level-1] = eb;
>>>  			path->slots[level-1] = 0;
>>>  			path->locks[level-1] = BTRFS_READ_LOCK_BLOCKING;
>>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>>> index 74db4694d776..74a088fbdac4 100644
>>> --- a/fs/btrfs/relocation.c
>>> +++ b/fs/btrfs/relocation.c
>>> @@ -1888,6 +1888,13 @@ int replace_path(struct btrfs_trans_handle *trans,
>>>  				break;
>>>  			}
>>>  			btrfs_tree_lock(eb);
>>> +			if (btrfs_verify_first_key(eb, parent, slot)) {
>>> +				btrfs_tree_unlock(eb);
>>> +				free_extent_buffer(eb);
>>> +				ret = -EUCLEAN;
>>> +				break;
>>> +			}
>>> +
>>>  			if (cow) {
>>>  				ret = btrfs_cow_block(trans, dest, eb, parent,
>>>  						      slot, &eb);
>>> @@ -2793,6 +2800,12 @@ static int do_relocation(struct btrfs_trans_handle *trans,
>>>  		}
>>>  		btrfs_tree_lock(eb);
>>>  		btrfs_set_lock_blocking(eb);
>>> +		if (btrfs_verify_first_key(eb, upper->eb, slot)) {
>>> +			btrfs_tree_unlock(eb);
>>> +			free_extent_buffer(eb);
>>> +			err = -EUCLEAN;
>>> +			goto next;
>>> +		}
>>>  
>>>  		if (!node->eb) {
>>>  			ret = btrfs_cow_block(trans, root, eb, upper->eb,
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
