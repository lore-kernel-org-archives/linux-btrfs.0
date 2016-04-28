Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51386 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392AbcD1Oby (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 10:31:54 -0400
Subject: Re: [PATCH RFC 04/16] btrfs-progs: fsck: Introduce function to check
 referencer of a backref
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1461642543-4621-5-git-send-email-quwenruo@cn.fujitsu.com>
CC: <dsterba@suse.cz>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <6a88b2b4-8bc4-71f5-2cd9-c5454f0ed02d@fb.com>
Date: Thu, 28 Apr 2016 10:31:38 -0400
MIME-Version: 1.0
In-Reply-To: <1461642543-4621-5-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/25/2016 11:48 PM, Qu Wenruo wrote:
> From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>
> Introduce a new function check_tree_block_backref() to check if a
> backref points to correct referencer.
>
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  cmds-check.c | 95 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 95 insertions(+)
>
> diff --git a/cmds-check.c b/cmds-check.c
> index 6633b6e..81dd4f3 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -323,6 +323,8 @@ struct root_item_info {
>  #define MISSING_BACKREF	(1 << 0) /* Completely no backref in extent tree */
>  #define BAD_BACKREF	(1 << 1) /* Backref mismatch */
>  #define UNALIGNED_BYTES	(1 << 2) /* Some bytes are not aligned */
> +#define MISSING_REFERENCER (1 << 3) /* Referencer not found */
> +#define BAD_REFERENCER	(1 << 4) /* Referencer found, but not mismatch */
>
>  static void *print_status_check(void *p)
>  {
> @@ -8736,6 +8738,99 @@ out:
>  	return ret;
>  }
>
> +/*
> + * Check if a tree block backref is valid (points to valid tree block)
> + * if level == -1, level will be resolved
> + */
> +static int check_tree_block_backref(struct btrfs_fs_info *fs_info, u64 root_id,
> +				    u64 bytenr, int level)
> +{
> +	struct btrfs_root *root;
> +	struct btrfs_key key;
> +	struct btrfs_path path;
> +	struct extent_buffer *eb;
> +	struct extent_buffer *node;
> +	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
> +	int err = 0;
> +	int ret;
> +
> +	/* Query level for level == -1 special case */
> +	if (level == -1)
> +		level = query_tree_block_level(fs_info, bytenr);
> +	if (level < 0) {
> +		err = MISSING_REFERENCER;
> +		goto out;
> +	}
> +
> +	key.objectid = root_id;
> +	key.type = BTRFS_ROOT_ITEM_KEY;
> +	key.offset = (u64)-1;
> +
> +	root = btrfs_read_fs_root(fs_info, &key);
> +	if (IS_ERR(root)) {
> +		err |= MISSING_REFERENCER;
> +		goto out;
> +	}
> +
> +	/* Read out the tree block to get item/node key */
> +	eb = read_tree_block(root, bytenr, root->nodesize, 0);
> +	/* Impossible, as tree block query has read out the tree block */
> +	if (!extent_buffer_uptodate(eb)) {
> +		err |= MISSING_REFERENCER;
> +		free_extent_buffer(eb);
> +		goto out;
> +	}
> +
> +	/* Empty tree, no need to check key */
> +	if (!btrfs_header_nritems(eb) && !level) {
> +		free_extent_buffer(eb);
> +		goto out;
> +	}
> +
> +	if (level)
> +		btrfs_node_key_to_cpu(eb, &key, 0);
> +	else
> +		btrfs_item_key_to_cpu(eb, &key, 0);
> +
> +	free_extent_buffer(eb);
> +
> +	btrfs_init_path(&path);
> +	/* Search with the first key, to ensure we can reach it */
> +	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> +	if (ret) {
> +		err |= MISSING_REFERENCER;
> +		goto release_out;
> +	}
> +
> +	node = path.nodes[level];
> +	if (btrfs_header_bytenr(node) != bytenr) {
> +		error("Extent [%llu %d] referencer bytenr mismatch, wanted: %llu, have: %llu",
> +		      bytenr, nodesize, bytenr,
> +		      btrfs_header_bytenr(node));
> +		err |= BAD_REFERENCER;
> +	}
> +	if (btrfs_header_level(node) != level) {
> +		error("Extent [%llu %d] referencer level mismatch, wanted: %d, have: %d",
> +		      bytenr, nodesize, level,
> +		      btrfs_header_level(node));
> +		err |= BAD_REFERENCER;
> +	}
> +
> +release_out:
> +	btrfs_release_path(&path);
> +out:
> +	if (err & MISSING_REFERENCER) {
> +		if (level < 0)
> +			error("Extent [%llu %d] lost referencer(owner: %llu)",
> +			       bytenr, nodesize, root_id);
> +		else
> +			error("Extent [%llu %d] lost referencer(owner: %llu, level: %u)",
> +			       bytenr, nodesize, root_id, level);
> +	}
> +
> +	return -err;

Sigh I missed this at first, if you are doing flags don't return 
negative numbers.  Fix this and then you can add my reviewed-by.  Thanks,

Josef

