Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47922 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934722AbeGDMmd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 08:42:33 -0400
Subject: Re: [PATCH v3] btrfs: Add chunk type check in read a chunk
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: quwenruo.btrfs@gmx.com
References: <1530699399-23573-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <838084df-8c4b-db45-62bf-501da15e15d0@suse.com>
Date: Wed, 4 Jul 2018 15:42:30 +0300
MIME-Version: 1.0
In-Reply-To: <1530699399-23573-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  4.07.2018 13:16, Gu Jinxiang wrote:
> Reported in https://bugzilla.kernel.org/show_bug.cgi?id=199839,
> which has a invalid chunk, not return error opportunlly.
> 
> Add chunk type check in btrfs_check_chunk_valid,
> to make error be returned in advance.
> 
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> ---
> changelog:
> v3:
> deal with comment by Nikolay Borisov, change the error message
> more appropriate.
> 
> v2:
> deal with comment by Qu, add precise check for chunk type.
> 
>  fs/btrfs/volumes.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index b33bf29130b6..deea169cc276 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6401,6 +6401,8 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
>  	u16 num_stripes;
>  	u16 sub_stripes;
>  	u64 type;
> +	u64 features;
> +	int mixed = 0;
>  
>  	length = btrfs_chunk_length(leaf, chunk);
>  	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
> @@ -6439,6 +6441,33 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
>  			  btrfs_chunk_type(leaf, chunk));
>  		return -EIO;
>  	}
> +
> +	if (!(type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
> +		btrfs_err(fs_info, "missing chunk type flag: %llu", type);
> +		return -EIO;
> +	}
> +
> +	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
> +	(type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
> +		btrfs_err(fs_info,
> +"system chunk type, meanwhile with metadata or data chunk type flag: %llu",
> +				type);

That's rather cumbersomely worded, why not simply "Invalid chunk type
detected"

> +		return -EIO;
> +	}
> +
> +	features = btrfs_super_incompat_flags(fs_info->super_copy);
> +	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
> +		mixed = 1;
> +
> +	if (!mixed) {
> +		if (type &
> +		(BTRFS_BLOCK_GROUP_METADATA & BTRFS_BLOCK_GROUP_DATA)) {
> +			btrfs_err(fs_info,
> +			"mixed chunk type flag in non-mixed mode: %llu", type);
> +			return -EIO;
> +		}
> +	}
> +
>  	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
>  	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
>  	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
> 
