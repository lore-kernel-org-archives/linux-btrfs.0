Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17775 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757710AbcAKCWO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jan 2016 21:22:14 -0500
Subject: Re: [PATCH] btrfs-progs: chunk-recovery: Fix a float point error
To: <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>
References: <1447915359-29707-1-git-send-email-quwenruo@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5693102C.609@cn.fujitsu.com>
Date: Mon, 11 Jan 2016 10:15:08 +0800
MIME-Version: 1.0
In-Reply-To: <1447915359-29707-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

Would you please consider merging this patch for v4.2 btrfs-progs?

Thanks,
Qu

Qu Wenruo wrote on 2015/11/19 14:42 +0800:
> Fix a zero division causing chunk-recovery fail.
>
> Also fix a typo "strpie_length" -> "stripe_length".
>
> Reported-by: Scotty Edmonds <scotty@scottyedmonds.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   btrfsck.h       | 17 +++++++++++++++++
>   chunk-recover.c |  9 ++++++---
>   2 files changed, 23 insertions(+), 3 deletions(-)
>
> diff --git a/btrfsck.h b/btrfsck.h
> index 0882a38..e16f52f 100644
> --- a/btrfsck.h
> +++ b/btrfsck.h
> @@ -142,6 +142,23 @@ static inline unsigned long btrfs_chunk_record_size(int num_stripes)
>   }
>   void free_chunk_cache_tree(struct cache_tree *chunk_cache);
>
> +/*
> + * Function to check validation for num_stripes, or it can call
> + * float point error for 0 division
> + * return < 0 for invalid combination
> + * return 0 for valid combination
> + */
> +static inline int check_num_stripes(u64 type, int num_stripes)
> +{
> +	if (num_stripes == 0)
> +		return -1;
> +	if (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes <= 1)
> +		return -1;
> +	if (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes <= 2)
> +		return -1;
> +	return 0;
> +}
> +
>   u64 calc_stripe_length(u64 type, u64 length, int num_stripes);
>   /* For block group tree */
>   static inline void block_group_tree_init(struct block_group_tree *tree)
> diff --git a/chunk-recover.c b/chunk-recover.c
> index 0d4c8ff..85dc1bc 100644
> --- a/chunk-recover.c
> +++ b/chunk-recover.c
> @@ -1607,16 +1607,19 @@ static int btrfs_verify_device_extents(struct block_group_record *bg,
>   				       struct list_head *devexts, int ndevexts)
>   {
>   	struct device_extent_record *devext;
> -	u64 strpie_length;
> +	u64 stripe_length;
>   	int expected_num_stripes;
>
>   	expected_num_stripes = calc_num_stripes(bg->flags);
>   	if (expected_num_stripes && expected_num_stripes != ndevexts)
>   		return 1;
>
> -	strpie_length = calc_stripe_length(bg->flags, bg->offset, ndevexts);
> +	if (check_num_stripes(bg->flags, ndevexts) < 0)
> +		return 1;
> +
> +	stripe_length = calc_stripe_length(bg->flags, bg->offset, ndevexts);
>   	list_for_each_entry(devext, devexts, chunk_list) {
> -		if (devext->length != strpie_length)
> +		if (devext->length != stripe_length)
>   			return 1;
>   	}
>   	return 0;
>


