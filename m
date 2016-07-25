Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39958 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbcGYNdH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jul 2016 09:33:07 -0400
Subject: Re: [PATCH v2 4/4] btrfs: should block unused block groups deletion
 work when allocating data space
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <20160725075141.5712-1-wangxg.fnst@cn.fujitsu.com>
 <20160725075141.5712-5-wangxg.fnst@cn.fujitsu.com>
CC: <dsterba@suse.cz>, <holger@applied-asynchrony.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <df0eb696-efea-0902-8e18-131a0898857c@fb.com>
Date: Mon, 25 Jul 2016 09:32:43 -0400
MIME-Version: 1.0
In-Reply-To: <20160725075141.5712-5-wangxg.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/25/2016 03:51 AM, Wang Xiaoguang wrote:
> cleaner_kthread() may run at any time, in which it'll call btrfs_delete_unused_bgs()
> to delete unused block groups. Because this work is asynchronous, it may also result
> in false ENOSPC error. Please see below race window:
>
>                CPU1                           |             CPU2
>                                               |
> |-> btrfs_alloc_data_chunk_ondemand()         |-> cleaner_kthread()
>     |-> do_chunk_alloc()                      |   |
>     |   assume it returns ENOSPC, which means |   |
>     |   btrfs_space_info is full and have free|   |
>     |   space to satisfy data request.        |   |
>     |                                         |   |- > btrfs_delete_unused_bgs()
>     |                                         |   |    it will decrease btrfs_space_info
>     |                                         |   |    total_bytes and make
>     |                                         |   |    btrfs_space_info is not full.
>     |                                         |   |
> In this case, we may get ENOSPC error, but btrfs_space_info is not full.
>
> To fix this issue, in btrfs_alloc_data_chunk_ondemand(), if we need to call
> do_chunk_alloc() to allocating new chunk, we should block btrfs_delete_unused_bgs().
> So here we introduce a new struct rw_semaphore bg_delete_sem to do this job.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/ctree.h       |  1 +
>  fs/btrfs/disk-io.c     |  1 +
>  fs/btrfs/extent-tree.c | 40 ++++++++++++++++++++++++++++++++++------
>  3 files changed, 36 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 7eb2913..bf0751d 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -800,6 +800,7 @@ struct btrfs_fs_info {
>  	struct mutex cleaner_mutex;
>  	struct mutex chunk_mutex;
>  	struct mutex volume_mutex;
> +	struct rw_semaphore bg_delete_sem;
>
>  	/*
>  	 * this is taken to make sure we don't set block groups ro after
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 60ce119..65a1465 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2676,6 +2676,7 @@ int open_ctree(struct super_block *sb,
>  	mutex_init(&fs_info->ordered_operations_mutex);
>  	mutex_init(&fs_info->tree_log_mutex);
>  	mutex_init(&fs_info->chunk_mutex);
> +	init_rwsem(&fs_info->bg_delete_sem);
>  	mutex_init(&fs_info->transaction_kthread_mutex);
>  	mutex_init(&fs_info->cleaner_mutex);
>  	mutex_init(&fs_info->volume_mutex);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index df8d756..d1f8638 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4111,6 +4111,7 @@ int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes)
>  	int ret = 0;
>  	int need_commit = 2;
>  	int have_pinned_space;
> +	int have_bg_delete_sem = 0;
>
>  	/* make sure bytes are sectorsize aligned */
>  	bytes = ALIGN(bytes, root->sectorsize);
> @@ -4121,8 +4122,11 @@ int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes)
>  	}
>
>  	data_sinfo = fs_info->data_sinfo;
> -	if (!data_sinfo)
> +	if (!data_sinfo) {
> +		down_read(&root->fs_info->bg_delete_sem);
> +		have_bg_delete_sem = 1;
>  		goto alloc;
> +	}
>
>  again:
>  	/* make sure we have enough space to handle the data first */
> @@ -4134,10 +4138,21 @@ again:
>  	if (used + bytes > data_sinfo->total_bytes) {
>  		struct btrfs_trans_handle *trans;
>
> +		spin_unlock(&data_sinfo->lock);
> +		/*
> +		 * We may need to allocate new chunk, so we should block
> +		 * btrfs_delete_unused_bgs()
> +		 */
> +		if (have_bg_delete_sem == 0) {
> +			down_read(&root->fs_info->bg_delete_sem);
> +			have_bg_delete_sem = 1;
> +		}
> +

We could race with somebody else doing an allocation here, so instead do 
something like

if (!have_bg_delete_sem) {
	spin_unlock(&data_sinfo->lock);
	down_read(&root->fs_info->bg_delete_sem);
	have_bg_delete_sem = 1;
	spin_lock((&data_sinfo->lock);
	if (used + bytes <= data_sinfo->total_bytes)
		goto done; // add a done label at bytes_may_use += bytes
}

Thanks,

Josef
