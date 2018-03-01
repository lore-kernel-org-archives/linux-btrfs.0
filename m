Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:8878 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S965488AbeCACzA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 21:55:00 -0500
Subject: Re: [PATCH 3/4] btrfs-progs: check/lowmem mode: Check inline extent
 size
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <peteryuchuang@gmail.com>
References: <20180301024747.26192-1-wqu@suse.com>
 <20180301024747.26192-4-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <62feedeb-de8e-2dcb-aaaf-2e6106bd4a98@cn.fujitsu.com>
Date: Thu, 1 Mar 2018 10:59:57 +0800
MIME-Version: 1.0
In-Reply-To: <20180301024747.26192-4-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/01/2018 10:47 AM, Qu Wenruo wrote:
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Looks good to me.

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>   check/mode-lowmem.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 62bcf3d2e126..44c58163f8f7 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -1417,6 +1417,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
>   	u64 csum_found;		/* In byte size, sectorsize aligned */
>   	u64 search_start;	/* Logical range start we search for csum */
>   	u64 search_len;		/* Logical range len we search for csum */
> +	u32 max_inline_extent_size = BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info);
>   	unsigned int extent_type;
>   	unsigned int is_hole;
>   	int compressed = 0;
> @@ -1440,6 +1441,13 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
>   				root->objectid, fkey->objectid, fkey->offset);
>   			err |= FILE_EXTENT_ERROR;
>   		}
> +		if (extent_num_bytes > max_inline_extent_size) {
> +			error(
> +		"root %llu EXTENT_DATA[%llu %llu] too large inline extent size, have %llu, max: %u",
> +				root->objectid, fkey->objectid, fkey->offset,
> +				extent_num_bytes, max_inline_extent_size);
> +			err |= FILE_EXTENT_ERROR;
> +		}
>   		if (!compressed && extent_num_bytes != item_inline_len) {
>   			error(
>   		"root %llu EXTENT_DATA[%llu %llu] wrong inline size, have: %llu, expected: %u",
> 


