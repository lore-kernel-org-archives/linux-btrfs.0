Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54470 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751060AbeEVKvh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 06:51:37 -0400
Subject: Re: [PATCH 2/2] btrfs: propagate failures of __exclude_logged_extent
 to upper caller
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1526982411-9243-1-git-send-email-gujx@cn.fujitsu.com>
 <1526982411-9243-2-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <624e084a-acfa-d49e-917c-87283b4ae5e5@suse.com>
Date: Tue, 22 May 2018 13:51:35 +0300
MIME-Version: 1.0
In-Reply-To: <1526982411-9243-2-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.05.2018 12:46, Gu Jinxiang wrote:
> Function btrfs_exclude_logged_extents may call __exclude_logged_extent
> which may fail.
> Propagate the failures of __exclude_logged_extent to upper caller.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/extent-tree.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 2e85e99b5e6f..28fd71579141 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6468,6 +6468,7 @@ int btrfs_exclude_logged_extents(struct btrfs_fs_info *fs_info,
>  	struct btrfs_key key;
>  	int found_type;
>  	int i;
> +	int ret = 0;
>  
>  	if (!btrfs_fs_incompat(fs_info, MIXED_GROUPS))
>  		return 0;
> @@ -6484,10 +6485,14 @@ int btrfs_exclude_logged_extents(struct btrfs_fs_info *fs_info,
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
>  
>  static void
> 
