Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33193 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbcFCOnW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jun 2016 10:43:22 -0400
Subject: Re: [PATCH v10 09/21] btrfs: dedupe: Inband in-memory only
 de-duplication implement
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-10-git-send-email-quwenruo@cn.fujitsu.com>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <87e0a104-1413-e397-0695-4bb5e1093a64@fb.com>
Date: Fri, 3 Jun 2016 10:43:05 -0400
MIME-Version: 1.0
In-Reply-To: <1459492512-31435-10-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/01/2016 02:35 AM, Qu Wenruo wrote:
> Core implement for inband de-duplication.
> It reuse the async_cow_start() facility to do the calculate dedupe hash.
> And use dedupe hash to do inband de-duplication at extent level.
>
> The work flow is as below:
> 1) Run delalloc range for an inode
> 2) Calculate hash for the delalloc range at the unit of dedupe_bs
> 3) For hash match(duplicated) case, just increase source extent ref
>    and insert file extent.
>    For hash mismatch case, go through the normal cow_file_range()
>    fallback, and add hash into dedupe_tree.
>    Compress for hash miss case is not supported yet.
>
> Current implement restore all dedupe hash in memory rb-tree, with LRU
> behavior to control the limit.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c |  18 ++++
>  fs/btrfs/inode.c       | 235 ++++++++++++++++++++++++++++++++++++++++++-------
>  fs/btrfs/relocation.c  |  16 ++++
>  3 files changed, 236 insertions(+), 33 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 53e1297..dabd721 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c


<snip>

> @@ -1076,6 +1135,68 @@ out_unlock:
>  	goto out;
>  }
>
> +static int hash_file_ranges(struct inode *inode, u64 start, u64 end,
> +			    struct async_cow *async_cow, int *num_added)
> +{
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_fs_info *fs_info = root->fs_info;
> +	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
> +	struct page *locked_page = async_cow->locked_page;
> +	u16 hash_algo;
> +	u64 actual_end;
> +	u64 isize = i_size_read(inode);
> +	u64 dedupe_bs;
> +	u64 cur_offset = start;
> +	int ret = 0;
> +
> +	actual_end = min_t(u64, isize, end + 1);
> +	/* If dedupe is not enabled, don't split extent into dedupe_bs */
> +	if (fs_info->dedupe_enabled && dedupe_info) {
> +		dedupe_bs = dedupe_info->blocksize;
> +		hash_algo = dedupe_info->hash_type;
> +	} else {
> +		dedupe_bs = SZ_128M;
> +		/* Just dummy, to avoid access NULL pointer */
> +		hash_algo = BTRFS_DEDUPE_HASH_SHA256;
> +	}
> +
> +	while (cur_offset < end) {
> +		struct btrfs_dedupe_hash *hash = NULL;
> +		u64 len;
> +
> +		len = min(end + 1 - cur_offset, dedupe_bs);
> +		if (len < dedupe_bs)
> +			goto next;
> +
> +		hash = btrfs_dedupe_alloc_hash(hash_algo);
> +		if (!hash) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +		ret = btrfs_dedupe_calc_hash(fs_info, inode, cur_offset, hash);
> +		if (ret < 0)
> +			goto out;
> +
> +		ret = btrfs_dedupe_search(fs_info, inode, cur_offset, hash);
> +		if (ret < 0)
> +			goto out;

You leak hash in both of these cases.  Also if btrfs_dedup_search

<snip>

> +	if (ret < 0)
> +		goto out_qgroup;
> +
> +	/*
> +	 * Hash hit won't create a new data extent, so its reserved quota
> +	 * space won't be freed by new delayed_ref_head.
> +	 * Need to free it here.
> +	 */
> +	if (btrfs_dedupe_hash_hit(hash))
> +		btrfs_qgroup_free_data(inode, file_pos, ram_bytes);
> +
> +	/* Add missed hash into dedupe tree */
> +	if (hash && hash->bytenr == 0) {
> +		hash->bytenr = ins.objectid;
> +		hash->num_bytes = ins.offset;
> +		ret = btrfs_dedupe_add(trans, root->fs_info, hash);

I don't want to flip read only if we fail this in the in-memory mode. 
Thanks,

Josef
