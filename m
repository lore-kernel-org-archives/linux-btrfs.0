Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42715 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbcCXU6e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 16:58:34 -0400
Date: Thu, 24 Mar 2016 16:58:07 -0400
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>, Liu Bo <bo.li.liu@oracle.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v8 10/27] btrfs: dedupe: Add basic tree structure for
 on-disk dedupe method
Message-ID: <20160324205807.ctxig7c2r4rfoowp@floor.thefacebook.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1458610552-9845-11-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1458610552-9845-11-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 22, 2016 at 09:35:35AM +0800, Qu Wenruo wrote:
> Introduce a new tree, dedupe tree to record on-disk dedupe hash.
> As a persist hash storage instead of in-memeory only implement.
> 
> Unlike Liu Bo's implement, in this version we won't do hack for
> bytenr -> hash search, but add a new type, DEDUP_BYTENR_ITEM for such
> search case, just like in-memory backend.

Thanks for refreshing this again, I'm starting to go through the disk
format in more detail.

> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/ctree.h             | 63 +++++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/dedupe.h            |  5 ++++
>  fs/btrfs/disk-io.c           |  1 +
>  include/trace/events/btrfs.h |  3 ++-
>  4 files changed, 70 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 022ab61..bed9273 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -100,6 +100,9 @@ struct btrfs_ordered_sum;
>  /* tracks free space in block groups. */
>  #define BTRFS_FREE_SPACE_TREE_OBJECTID 10ULL
>  
> +/* on-disk dedupe tree (EXPERIMENTAL) */
> +#define BTRFS_DEDUPE_TREE_OBJECTID 11ULL
> +
>  /* device stats in the device tree */
>  #define BTRFS_DEV_STATS_OBJECTID 0ULL
>  
> @@ -508,6 +511,7 @@ struct btrfs_super_block {
>   * ones specified below then we will fail to mount
>   */
>  #define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE	(1ULL << 0)
> +#define BTRFS_FEATURE_COMPAT_RO_DEDUPE		(1ULL << 1)
>  
>  #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
>  #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
> @@ -537,7 +541,8 @@ struct btrfs_super_block {
>  #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR		0ULL
>  
>  #define BTRFS_FEATURE_COMPAT_RO_SUPP			\
> -	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE)
> +	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
> +	 BTRFS_FEATURE_COMPAT_RO_DEDUPE)
>  
>  #define BTRFS_FEATURE_COMPAT_RO_SAFE_SET	0ULL
>  #define BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR	0ULL
> @@ -959,6 +964,42 @@ struct btrfs_csum_item {
>  	u8 csum;
>  } __attribute__ ((__packed__));
>  
> +/*
> + * Objectid: 0
> + * Type: BTRFS_DEDUPE_STATUS_ITEM_KEY
> + * Offset: 0
> + */
> +struct btrfs_dedupe_status_item {
> +	__le64 blocksize;
> +	__le64 limit_nr;
> +	__le16 hash_type;
> +	__le16 backend;
> +} __attribute__ ((__packed__));
> +
> +/*
> + * Objectid: Last 64 bit of the hash
> + * Type: BTRFS_DEDUPE_HASH_ITEM_KEY
> + * Offset: Bytenr of the hash
> + *
> + * Used for hash <-> bytenr search
> + */
> +struct btrfs_dedupe_hash_item {
> +	/* length of dedupe range */
> +	__le32 len;
> +
> +	/* Hash follows */
> +} __attribute__ ((__packed__));

Are you storing the entire hash, or just the parts not represented in
the key?  I'd like to keep the on-disk part as compact as possible for
this part.

> +
> +/*
> + * Objectid: bytenr
> + * Type: BTRFS_DEDUPE_BYTENR_ITEM_KEY
> + * offset: Last 64 bit of the hash
> + *
> + * Used for bytenr <-> hash search (for free_extent)
> + * all its content is hash.
> + * So no special item struct is needed.
> + */
> +

Can we do this instead with a backref from the extent?  It'll save us a
huge amount of IO as we delete things.

-chris
