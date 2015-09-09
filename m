Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:36521 "EHLO
	mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbbIIBFW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 21:05:22 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id D043BAC01E8
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2015 10:05:19 +0900 (JST)
Subject: Re: [PATCH 08/19] btrfs: qgroup: Introduce function to release/free
 reserved data range
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1441703318-25733-1-git-send-email-quwenruo@cn.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <55EF85C2.1050400@jp.fujitsu.com>
Date: Wed, 9 Sep 2015 10:05:06 +0900
MIME-Version: 1.0
In-Reply-To: <1441703318-25733-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Qu,

On 2015/09/08 18:08, Qu Wenruo wrote:
> Introduce functions btrfs_qgroup_release/free_data() to release/free
> reserved data range.
> 
> Release means, just remove the data range from data rsv map, but doesn't
> free the reserved space.
> This is for normal buffered write case, when data is written into disc
> and its metadata is added into tree, its reserved space should still be
> kept until commit_trans().
> So in that case, we only release dirty range, but keep the reserved
> space recorded some other place until commit_tran().
> 
> Free means not only remove data range, but also free reserved space.
> This is used for case for cleanup.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/qgroup.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/btrfs/qgroup.h |  2 ++
>   2 files changed, 50 insertions(+)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index e24c10d..ba7888f 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2979,6 +2979,54 @@ next:
>   	return 0;
>   }
>   
> +static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
> +				       int free_reserved)
> +{
> +	struct data_rsv_range *tmp;
> +	struct btrfs_qgroup_data_rsv_map *map;
> +	u64 reserved = 0;
> +	int ret;
> +
> +	spin_lock(&BTRFS_I(inode)->qgroup_init_lock);
> +	map = BTRFS_I(inode)->qgroup_rsv_map;
> +	spin_unlock(&BTRFS_I(inode)->qgroup_init_lock);
> +	if (!map)
> +		return 0;
> +
> +	tmp = kmalloc(sizeof(*tmp), GFP_NOFS);
> +	if (!tmp)
> +		return -ENOMEM;
> +	spin_lock(&map->lock);
> +	ret = release_data_range(map, tmp, start, len, &reserved);
> +	/* release_data_range() won't fail only check if memory is used */
> +	if (ret == 0)
> +		kfree(tmp);
> +	if (free_reserved)
> +		btrfs_qgroup_free(BTRFS_I(inode)->root, reserved);
> +	spin_unlock(&map->lock);
> +	return 0;
> +}
> +
> +/*
> + * Caller should be truncate/invalidate_page.
> + * As it will release the reserved data.
> + */
> +int btrfs_qgroup_free_data(struct inode *inode, u64 start, u64 len)
> +{
> +	return __btrfs_qgroup_release_data(inode, start, len, 1);
> +}
> +
> +/*
> + * Caller should be finish_ordered_io

> + * As qgroup accouting happens at commit time, for data written to disk

                accounting

Thanks,
Tsutomu

> + * its reserved space should not be freed until commit.
> + * Or we may beyond the limit.
> + */
> +int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len)
> +{
> +	return __btrfs_qgroup_release_data(inode, start, len, 0);
> +}
> +
>   /*
>    * Init data_rsv_map for a given inode.
>    *
> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
> index 366b853..8e69dc1 100644
> --- a/fs/btrfs/qgroup.h
> +++ b/fs/btrfs/qgroup.h
> @@ -88,4 +88,6 @@ int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
>   int btrfs_qgroup_init_data_rsv_map(struct inode *inode);
>   void btrfs_qgroup_free_data_rsv_map(struct inode *inode);
>   int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len);
> +int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len);
> +int btrfs_qgroup_free_data(struct inode *inode, u64 start, u64 len);
>   #endif /* __BTRFS_QGROUP__ */
> 


