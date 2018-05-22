Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35697 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751174AbeEVIU5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 04:20:57 -0400
Subject: Re: [PATCH] btrfs: handle failures of set_extent_bits in
 add_excluded_extent
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1526961099-5922-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <fb4ace75-c59a-332b-12d4-e4d186396776@suse.com>
Date: Tue, 22 May 2018 11:20:54 +0300
MIME-Version: 1.0
In-Reply-To: <1526961099-5922-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.05.2018 06:51, Gu Jinxiang wrote:
> set_extent_bits may return 0/-EEXIST, so return the result in
> add_excluded_extent. And handle the failures in upper callers.
> 
> Caller of add_excluded_extent and failure process currently:
> exclude_super_stripes
> 	<- btrfs_make_block_group  //handles the failure
> 	<- btrfs_read_block_groups //handles the failure

> __exclude_logged_extent
> 	<- btrfs_exclude_logged_extents
> 	<- btrfs_alloc_logged_file_extent //propagate failure to upper
> 					caller
> Add logic of propagate return value of __exclude_logged_extent to
> btrfs_exclude_logged_extents.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 75cfb80d2551..28fd71579141 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -215,11 +215,16 @@ static int add_excluded_extent(struct btrfs_fs_info *fs_info,
>  			       u64 start, u64 num_bytes)
>  {
>  	u64 end = start + num_bytes - 1;
> -	set_extent_bits(&fs_info->freed_extents[0],
> +	int ret = 0;
> +
> +	ret = set_extent_bits(&fs_info->freed_extents[0],
>  			start, end, EXTENT_UPTODATE);
> -	set_extent_bits(&fs_info->freed_extents[1],
> +	if (ret)
> +		goto out;
> +	ret = set_extent_bits(&fs_info->freed_extents[1],
>  			start, end, EXTENT_UPTODATE);
> -	return 0;
> +out:
> +	return ret;
>  }
>  
>  static void free_excluded_extents(struct btrfs_fs_info *fs_info,
> @@ -6463,6 +6468,7 @@ int btrfs_exclude_logged_extents(struct btrfs_fs_info *fs_info,
>  	struct btrfs_key key;
>  	int found_type;
>  	int i;
> +	int ret = 0;
>  
>  	if (!btrfs_fs_incompat(fs_info, MIXED_GROUPS))
>  		return 0;
> @@ -6479,10 +6485,14 @@ int btrfs_exclude_logged_extents(struct btrfs_fs_info *fs_info,
>  			continue;
>  		key.objectid = btrfs_file_extent_disk_bytenr(eb, item);
>  		key.offset = btrfs_file_extent_disk_num_bytes(eb, item);
> -		__exclude_logged_extent(fs_info, key.objectid, key.offset);
> +		ret = __exclude_logged_extent(fs_info, key.objectid,
> +				key.offset);
> +		if (ret)
> +			goto out;
>  	}
>  
> -	return 0;
> +out:
> +	return ret;
>  }

The 2nd and 3rd hunks need to go in a separate patch.
__exclude_logged_extent can return an error value for any number of
reasons (btrfs_lookup_block_group failing, btrfs_remove_free_space
failing or add_excluded_extents also failing). SO what you are actually
fixing here is __exclude_logged_extent return value not being handled in
btrfs_exclude_logged_extent which is a separate issue from
add_excluded_extent always returning 0. So put this in a separate patch.

>  
>  static void
> 
