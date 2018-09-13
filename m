Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:41667 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbeINETT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 00:19:19 -0400
Subject: Re: [PATCH 2/3] btrfs-progs: check: lowmem: Refactor extent len test
 in check_file_extent_inline
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180913120507.18197-1-nborisov@suse.com>
 <20180913120507.18197-3-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c273f6d5-6692-b834-552d-ff47fab70943@gmx.com>
Date: Fri, 14 Sep 2018 07:07:35 +0800
MIME-Version: 1.0
In-Reply-To: <20180913120507.18197-3-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/13 下午8:05, Nikolay Borisov wrote:
> Instead of having another top-level if which checks for
> 'extent_num_bytes != item_inline_len' only if we are !compressed, just
> move the 'if' inside the 'else' branch of the first top-level if, since
> it has already checked for !compressed or not. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  check/mode-lowmem.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 48c1537e7440..3a6fbb33c858 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -1860,19 +1860,20 @@ static int check_file_extent_inline(struct btrfs_root *root,
>  				err |= FILE_EXTENT_ERROR;
>  		}
>  
> -	}
> -	if (!compressed && extent_num_bytes != item_inline_len) {
> -		error(
> +
> +		if (extent_num_bytes != item_inline_len) {
> +			error(
>  "root %llu EXTENT_DATA[%llu %llu] wrong inline size, have: %llu, expected: %u",
>  				root->objectid, fkey.objectid, fkey.offset,
>  				extent_num_bytes, item_inline_len);
> -		if (repair) {
> -			ret = repair_inline_ram_bytes(root, path,
> -						      &extent_num_bytes);
> -			if (ret)
> +			if (repair) {
> +				ret = repair_inline_ram_bytes(root, path,
> +							      &extent_num_bytes);
> +				if (ret)
> +					err |= FILE_EXTENT_ERROR;
> +			} else {
>  				err |= FILE_EXTENT_ERROR;
> -		} else {
> -			err |= FILE_EXTENT_ERROR;
> +			}
>  		}
>  	}
>  	*end += extent_num_bytes;
> 
