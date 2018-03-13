Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54264 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752268AbeCMIjl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 04:39:41 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E9ED1AC20
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Mar 2018 08:39:39 +0000 (UTC)
Subject: Re: [PATCH v2 5/7] btrfs-progs: check/lowmem mode: Check inline
 extent size
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180313015616.6574-1-wqu@suse.com>
 <20180313015616.6574-6-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b357d3ce-50f3-03e7-5d57-396be9c35565@suse.com>
Date: Tue, 13 Mar 2018 10:39:35 +0200
MIME-Version: 1.0
In-Reply-To: <20180313015616.6574-6-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.03.2018 03:56, Qu Wenruo wrote:
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  check/mode-lowmem.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 62bcf3d2e126..0d19b373c7af 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -1417,6 +1417,8 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
>  	u64 csum_found;		/* In byte size, sectorsize aligned */
>  	u64 search_start;	/* Logical range start we search for csum */
>  	u64 search_len;		/* Logical range len we search for csum */
> +	u32 max_inline_extent_size = min_t(u32, root->fs_info->sectorsize - 1,
> +				BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info));
>  	unsigned int extent_type;
>  	unsigned int is_hole;
>  	int compressed = 0;
> @@ -1440,6 +1442,32 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
>  				root->objectid, fkey->objectid, fkey->offset);
>  			err |= FILE_EXTENT_ERROR;
>  		}
> +		if (compressed) {
> +			if (extent_num_bytes > root->fs_info->sectorsize) {
> +				error(
> +"root %llu EXTENT_DATA[%llu %llu] too large inline extent ram size, have %llu, max: %u",
> +					root->objectid, fkey->objectid,
> +					fkey->offset, extent_num_bytes,
> +					root->fs_info->sectorsize);
nit: shouldn't this really be sectorsize - 1 ?
> +				err |= FILE_EXTENT_ERROR;
> +			}
> +			if (item_inline_len > max_inline_extent_size) {
> +				error(
> +"root %llu EXTENT_DATA[%llu %llu] too large inline extent on-disk size, have %u, max: %u",
> +					root->objectid, fkey->objectid,
> +					fkey->offset, item_inline_len,
> +					max_inline_extent_size);
> +				err |= FILE_EXTENT_ERROR;
> +			}
> +		} else {
> +			if (extent_num_bytes > max_inline_extent_size) {
> + 			error(
> + "root %llu EXTENT_DATA[%llu %llu] too large inline extent size, have %llu, max: %u",
> + 				root->objectid, fkey->objectid, fkey->offset,
> + 				extent_num_bytes, max_inline_extent_size);
> +				err |= FILE_EXTENT_ERROR;
> +			}
> +		}
>  		if (!compressed && extent_num_bytes != item_inline_len) {
>  			error(
>  		"root %llu EXTENT_DATA[%llu %llu] wrong inline size, have: %llu, expected: %u",
> 
