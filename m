Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56384 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753214AbdGCJDZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jul 2017 05:03:25 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v2] btrfs: fix validation of XATTR_ITEM dir items
To: David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <fdmanana@gmail.com>, <nborisov@suse.com>
References: <20170629182015.3000-1-dsterba@suse.com>
Message-ID: <34edb95c-0b5f-d8c8-fe45-a051fae56312@cn.fujitsu.com>
Date: Mon, 3 Jul 2017 17:05:36 +0800
MIME-Version: 1.0
In-Reply-To: <20170629182015.3000-1-dsterba@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks a lot.
I'm sorry for that I hadn't noticed those emails during the vacation.

On 06/30/2017 02:20 AM, David Sterba wrote:
> The XATTR_ITEM is a type of a directory item so we use the common
> validator helper. Unlike other dir items, it can have data. The way the
> name len validation is currently implemented does not reflect that. We'd
> have to adjust by the data_len when comparing the read and item limits.
> 
> However, this will not work for multi-item xattr dir items.
> 
> Example from tree dump of generic/337:
> 
>          item 7 key (257 XATTR_ITEM 751495445) itemoff 15667 itemsize 147
>                  location key (0 UNKNOWN.0 0) type XATTR
>                  transid 8 data_len 3 name_len 11
>                  name: user.foobar
>                  data 123
>                  location key (0 UNKNOWN.0 0) type XATTR
>                  transid 8 data_len 6 name_len 13
>                  name: user.WvG1c1Td
>                  data qwerty
>                  location key (0 UNKNOWN.0 0) type XATTR
>                  transid 8 data_len 5 name_len 19
>                  name: user.J3__T_Km3dVsW_
>                  data hello
> 
> At the point of btrfs_is_name_len_valid call we don't have access to the
> data_len value of the 2nd and 3rd sub-item. So simple btrfs_dir_data_len(leaf,
> di) would always return 3, although we'd need to get 6 and 5 respectively to
> get the claculations right. (read_end + name_len + data_len vs item_end)
> 
> We'd have to also pass data_len externally, which is not point of the
> name validation. The last check is supposed to test if there's at least
> one dir item space after the one we're processing. I don't think this is
> particularly useful, validation of the next item would catch that too.
> So the check is removed and we don't weaken the validation. Now tests
> btrfs/048, btrfs/053, generic/273 and generic/337 pass. >
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> 
>   fs/btrfs/dir-item.c | 8 --------
>   1 file changed, 8 deletions(-)
> 
> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index 2b00dd746118..41cb9196eaa8 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -550,14 +550,6 @@ bool btrfs_is_name_len_valid(struct extent_buffer *leaf, int slot,
>   		goto out;
>   	}
>   
> -	/*
> -	 * This may be the last item in the slot
> -	 * Or same type item(s) is left between read_end and item_end
> -	 */
> -	if (item_end != read_end && item_end - read_end < size) {
> -		ret = false;
> -		goto out;
> -	}
>   out:
>   	if (!ret)
>   		btrfs_crit(fs_info, "invalid dir item name len: %u",
> 


