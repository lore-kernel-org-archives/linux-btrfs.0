Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:50081 "EHLO
	mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbbIIBfe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 21:35:34 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 26689AC0088
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2015 10:35:32 +0900 (JST)
Subject: Re: [PATCH 13/19] btrfs: extent-tree: Add new verions of
 btrfs_check_data_free_space
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1441704164-353-2-git-send-email-quwenruo@cn.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <55EF8CD9.2090408@jp.fujitsu.com>
Date: Wed, 9 Sep 2015 10:35:21 +0900
MIME-Version: 1.0
In-Reply-To: <1441704164-353-2-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Qu,

On 2015/09/08 18:22, Qu Wenruo wrote:
> Add new function __btrfs_check_data_free_space() to do precious space
> reservation.
> 
> The new function will replace old btrfs_check_data_free_space(), but
> until all the change is done, let's just use the new name.
> 
> Also, export internal use function btrfs_alloc_data_chunk_ondemand(), as
> now qgroup reserve requires precious bytes, which can only be got in
> later loop(like fallocate).
> But data space info check and data chunk allocate doesn't need to be
> that accurate, and can be called at the beginning.
> 
> So export it for later operations.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/ctree.h       |  2 ++
>   fs/btrfs/extent-tree.c | 50 +++++++++++++++++++++++++++++++++++++++++---------
>   2 files changed, 43 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index ae86025..c1a0aaf 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3453,6 +3453,8 @@ enum btrfs_reserve_flush_enum {
>   };
>   
>   int btrfs_check_data_free_space(struct inode *inode, u64 bytes, u64 write_bytes);
> +int __btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len);
> +int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes);
>   void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes);
>   void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
>   				struct btrfs_root *root);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 402415c..61366ca 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3907,11 +3907,7 @@ u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
>   	return ret;
>   }
>   
> -/*
> - * This will check the space that the inode allocates from to make sure we have
> - * enough space for bytes.
> - */
> -int btrfs_check_data_free_space(struct inode *inode, u64 bytes, u64 write_bytes)
> +int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes)
>   {
>   	struct btrfs_space_info *data_sinfo;
>   	struct btrfs_root *root = BTRFS_I(inode)->root;
> @@ -4032,19 +4028,55 @@ commit_trans:
>   					      data_sinfo->flags, bytes, 1);
>   		return -ENOSPC;
>   	}
> -	ret = btrfs_qgroup_reserve(root, write_bytes);
> -	if (ret)
> -		goto out;
>   	data_sinfo->bytes_may_use += bytes;
>   	trace_btrfs_space_reservation(root->fs_info, "space_info",
>   				      data_sinfo->flags, bytes, 1);
> -out:
>   	spin_unlock(&data_sinfo->lock);
>   
>   	return ret;
>   }
>   
>   /*
> + * This will check the space that the inode allocates from to make sure we have
> + * enough space for bytes.
> + */
> +int btrfs_check_data_free_space(struct inode *inode, u64 bytes, u64 write_bytes)
> +{
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	int ret;
> +
> +	ret = btrfs_alloc_data_chunk_ondemand(inode, bytes);
> +	if (ret < 0)
> +		return ret;
> +	ret = btrfs_qgroup_reserve(root, write_bytes);
> +	return ret;
> +}
> +
> +/*

> + * New check_data_free_space() with ability for precious data reserveation

                                                                 reservation

Thanks,
Tsutomu

> + * Will replace old btrfs_check_data_free_space(), but for patch split,
> + * add a new function first and then replace it.
> + */
> +int __btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
> +{
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	int ret;
> +
> +	/* align the range */
> +	len = round_up(start + len, root->sectorsize) -
> +	      round_down(start, root->sectorsize);
> +	start = round_down(start, root->sectorsize);
> +
> +	ret = btrfs_alloc_data_chunk_ondemand(inode, len);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Use new btrfs_qgroup_reserve_data to reserve precious data space */
> +	ret = btrfs_qgroup_reserve_data(inode, start, len);
> +	return ret;
> +}
> +
> +/*
>    * Called if we need to clear a data reservation for this inode.
>    */
>   void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
> 


