Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35670 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaAXBIy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 20:08:54 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0O18qbF004522
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 09:08:52 +0800
Message-ID: <52E1BCDB.9060004@cn.fujitsu.com>
Date: Fri, 24 Jan 2014 09:07:39 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix extent_from_logical to deal with skinny metadata
References: <1390511177-3395-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1390511177-3395-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

I have sent a patch before to address this issue:
       https://patchwork.kernel.org/patch/3472211/

I introduced another function btrfs_previous_extent_item() to
search previous extent item, I think you must miss my path before
giving this patch ^_^.

Thanks,
Wang

On 01/24/2014 05:06 AM, Josef Bacik wrote:
> I don't think this is an issue and I've not seen it in practice but
> extent_from_logical will fail to find a skinny extent because it uses
> btrfs_previous_item and gives it the normal extent item type.  This is just not
> a place to use btrfs_previous_item since we care about either normal extents or
> skinny extents, so open code btrfs_previous_item to properly check.  This would
> only affect metadata and the only place this is used for metadata is scrub and
> I'm pretty sure it's just for printing stuff out, not actually doing any work so
> hopefully it was never a problem other than a cosmetic one.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>   fs/btrfs/backref.c | 41 +++++++++++++++++++++++++++++++++--------
>   1 file changed, 33 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 34a8952..dcf2448 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1302,20 +1302,45 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
>   	ret = btrfs_search_slot(NULL, fs_info->extent_root, &key, path, 0, 0);
>   	if (ret < 0)
>   		return ret;
> -	ret = btrfs_previous_item(fs_info->extent_root, path,
> -					0, BTRFS_EXTENT_ITEM_KEY);
> -	if (ret < 0)
> -		return ret;
>   
> -	btrfs_item_key_to_cpu(path->nodes[0], found_key, path->slots[0]);
> +	while (1) {
> +		u32 nritems;
> +		if (path->slots[0] == 0) {
> +			btrfs_set_path_blocking(path);
> +			ret = btrfs_prev_leaf(fs_info->extent_root, path);
> +			if (ret != 0) {
> +				if (ret > 0) {
> +					pr_debug("logical %llu is not within "
> +						 "any extent\n", logical);
> +					ret = -ENOENT;
> +				}
> +				return ret;
> +			}
> +		} else {
> +			path->slots[0]--;
> +		}
> +		nritems = btrfs_header_nritems(path->nodes[0]);
> +		if (nritems == 0) {
> +			pr_debug("logical %llu is not within any extent\n",
> +				 logical);
> +			return -ENOENT;
> +		}
> +		if (path->slots[0] == nritems)
> +			path->slots[0]--;
> +
> +		btrfs_item_key_to_cpu(path->nodes[0], found_key,
> +				      path->slots[0]);
> +		if (found_key->type == BTRFS_EXTENT_ITEM_KEY ||
> +		    found_key->type == BTRFS_METADATA_ITEM_KEY)
> +			break;
> +	}
> +
>   	if (found_key->type == BTRFS_METADATA_ITEM_KEY)
>   		size = fs_info->extent_root->leafsize;
>   	else if (found_key->type == BTRFS_EXTENT_ITEM_KEY)
>   		size = found_key->offset;
>   
> -	if ((found_key->type != BTRFS_EXTENT_ITEM_KEY &&
> -	     found_key->type != BTRFS_METADATA_ITEM_KEY) ||
> -	    found_key->objectid > logical ||
> +	if (found_key->objectid > logical ||
>   	    found_key->objectid + size <= logical) {
>   		pr_debug("logical %llu is not within any extent\n", logical);
>   		return -ENOENT;

