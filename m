Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2523 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S965488AbeCACya (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 21:54:30 -0500
Subject: Re: [PATCH 2/4] btrfs-progs: check/original mode: Check inline extent
 size
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <peteryuchuang@gmail.com>
References: <20180301024747.26192-1-wqu@suse.com>
 <20180301024747.26192-3-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <190d2b73-a262-cc9b-6536-ce3bcc5cbf19@cn.fujitsu.com>
Date: Thu, 1 Mar 2018 10:59:30 +0800
MIME-Version: 1.0
In-Reply-To: <20180301024747.26192-3-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/01/2018 10:47 AM, Qu Wenruo wrote:
> Kernel doesn't allow inline extent equal or larger than 4K.
> And for inline extent larger than 4K, __btrfs_drop_extents() can return
> -EOPNOTSUPP and cause unexpected error.
> 
> Check it in original mode.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Looks good to me.

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
>   check/main.c          | 4 ++++
>   check/mode-original.h | 1 +
>   2 files changed, 5 insertions(+)
> 
> diff --git a/check/main.c b/check/main.c
> index 97baae583f04..ce41550ab16a 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -560,6 +560,8 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
>   		fprintf(stderr, ", bad file extent");
>   	if (errors & I_ERR_FILE_EXTENT_OVERLAP)
>   		fprintf(stderr, ", file extent overlap");
> +	if (errors & I_ERR_FILE_EXTENT_TOO_LARGE)
> +		fprintf(stderr, ", inline file extent too large");
>   	if (errors & I_ERR_FILE_EXTENT_DISCOUNT)
>   		fprintf(stderr, ", file extent discount");
>   	if (errors & I_ERR_DIR_ISIZE_WRONG)
> @@ -1461,6 +1463,8 @@ static int process_file_extent(struct btrfs_root *root,
>   		num_bytes = btrfs_file_extent_inline_len(eb, slot, fi);
>   		if (num_bytes == 0)
>   			rec->errors |= I_ERR_BAD_FILE_EXTENT;
> +		if (num_bytes > BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info))
> +			rec->errors |= I_ERR_FILE_EXTENT_TOO_LARGE;
>   		rec->found_size += num_bytes;
>   		num_bytes = (num_bytes + mask) & ~mask;
>   	} else if (extent_type == BTRFS_FILE_EXTENT_REG ||
> diff --git a/check/mode-original.h b/check/mode-original.h
> index f859af478f0f..368de692fdd1 100644
> --- a/check/mode-original.h
> +++ b/check/mode-original.h
> @@ -185,6 +185,7 @@ struct file_extent_hole {
>   #define I_ERR_SOME_CSUM_MISSING		(1 << 12)
>   #define I_ERR_LINK_COUNT_WRONG		(1 << 13)
>   #define I_ERR_FILE_EXTENT_ORPHAN	(1 << 14)
> +#define I_ERR_FILE_EXTENT_TOO_LARGE	(1 << 15)
>   
>   struct inode_record {
>   	struct list_head backrefs;
> 


