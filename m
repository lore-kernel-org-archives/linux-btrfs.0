Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62064 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872Ab3LMPVa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 10:21:30 -0500
Message-ID: <52AB257B.5070700@fb.com>
Date: Fri, 13 Dec 2013 10:19:23 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 6/6] Btrfs: introduce the delayed inode ref deletion for
 the single link inode
References: <1386929381-3483-1-git-send-email-miaox@cn.fujitsu.com> <1386929381-3483-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1386929381-3483-6-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/13/2013 05:09 AM, Miao Xie wrote:
> The inode reference item is close to inode item, so we insert it simultaneously
> with the inode item insertion when we create a file/directory.. In fact, we also
> can handle the inode reference deletion by the same way. So we made this patch to
> introduce the delayed inode reference deletion for the single link inode(At most
> case, the file doesn't has hard link, so we don't take the hard link into account).
>
> This function is based on the delayed inode mechanism. After applying this patch,
> we can reduce the time of the file/directory deletion by ~10%.
>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>   fs/btrfs/btrfs_inode.h   |   3 ++
>   fs/btrfs/delayed-inode.c | 103 +++++++++++++++++++++++++++++++++++++++++++++--
>   fs/btrfs/delayed-inode.h |   2 +
>   fs/btrfs/inode.c         |  55 ++++++++++++++++++++++++-
>   4 files changed, 157 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index ac0b39d..661b0ac 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -135,6 +135,9 @@ struct btrfs_inode {
>   	 */
>   	u64 index_cnt;
>   
> +	/* Cache the directory index number to speed the dir/file remove */
> +	u64 dir_index;
> +
>   	/* the fsync log has some corner cases that mean we have to check
>   	 * directories to see if any unlinks have been done before
>   	 * the directory was logged.  See tree-log.c for all the
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 979db56..8671d980 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1015,6 +1015,18 @@ static void btrfs_release_delayed_inode(struct btrfs_delayed_node *delayed_node)
>   	}
>   }
>   
> +static void btrfs_release_delayed_iref(struct btrfs_delayed_node *delayed_node)
> +{
> +	struct btrfs_delayed_root *delayed_root;
> +
> +	BUG_ON(!delayed_node->root);

Use assert(), not BUG_ON().

> +	clear_bit(BTRFS_DELAYED_NODE_DEL_IREF, &delayed_node->flags);
> +	delayed_node->count--;
> +
> +	delayed_root = delayed_node->root->fs_info->delayed_root;
> +	finish_one_item(delayed_root);
> +}
> +
>   static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
>   					struct btrfs_root *root,
>   					struct btrfs_path *path,
> @@ -1023,13 +1035,19 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
>   	struct btrfs_key key;
>   	struct btrfs_inode_item *inode_item;
>   	struct extent_buffer *leaf;
> +	int mod;
>   	int ret;
>   
>   	key.objectid = node->inode_id;
>   	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
>   	key.offset = 0;
>   
> -	ret = btrfs_lookup_inode(trans, root, path, &key, 1);
> +	if (test_bit(BTRFS_DELAYED_NODE_DEL_IREF, &node->flags))
> +		mod = -1;
> +	else
> +		mod = 1;
> +
> +	ret = btrfs_lookup_inode(trans, root, path, &key, mod);
>   	if (ret > 0) {
>   		btrfs_release_path(path);
>   		return -ENOENT;
> @@ -1037,19 +1055,58 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
>   		return ret;
>   	}
>   
> -	btrfs_unlock_up_safe(path, 1);
>   	leaf = path->nodes[0];
>   	inode_item = btrfs_item_ptr(leaf, path->slots[0],
>   				    struct btrfs_inode_item);
>   	write_extent_buffer(leaf, &node->inode_item, (unsigned long)inode_item,
>   			    sizeof(struct btrfs_inode_item));
>   	btrfs_mark_buffer_dirty(leaf);
> -	btrfs_release_path(path);
>   
> +	if (!test_bit(BTRFS_DELAYED_NODE_DEL_IREF, &node->flags))
> +		goto no_iref;
> +
> +	path->slots[0]++;
> +	if (path->slots[0] >= btrfs_header_nritems(leaf))
> +		goto search;
> +again:
> +	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
> +	if (key.objectid != node->inode_id)
> +		goto out;
> +
> +	if (key.type != BTRFS_INODE_REF_KEY &&
> +	    key.type != BTRFS_INODE_EXTREF_KEY)
> +		goto out;
> +
> +	/*
> +	 * Delayed iref deletion is for the inode who has only one link,
> +	 * so there is only one iref. The case that several irefs are
> +	 * in the same item doesn't exist.
> +	 */
> +	btrfs_del_item(trans, root, path);
> +out:
> +	btrfs_release_delayed_iref(node);
> +no_iref:
> +	btrfs_release_path(path);
> +err_out:
>   	btrfs_delayed_inode_release_metadata(root, node);
>   	btrfs_release_delayed_inode(node);
>   
> -	return 0;
> +	return ret;
> +
> +search:
> +	btrfs_release_path(path);
> +
> +	btrfs_set_key_type(&key, BTRFS_INODE_EXTREF_KEY);
> +	key.offset = -1;
> +	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
> +	if (ret < 0)
> +		goto err_out;
> +	BUG_ON(!ret);

Same here.  Thanks,

Josef
