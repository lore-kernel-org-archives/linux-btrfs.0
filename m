Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:42063 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbeHTQrm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 12:47:42 -0400
Subject: Re: [PATCH 1/2] btrfstune: Remove fs_info arg from change_device_uuid
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1534771685-4924-1-git-send-email-nborisov@suse.com>
 <1534771685-4924-2-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <99fbdb40-56aa-169f-6d36-3d1908d0ba0f@gmx.com>
Date: Mon, 20 Aug 2018 21:31:48 +0800
MIME-Version: 1.0
In-Reply-To: <1534771685-4924-2-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/8/20 下午9:28, Nikolay Borisov wrote:
> This function already takes an extent buffer that contains a reference
> to the fs_info. Use that and reduce argument count. No functional
> changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  btrfstune.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/btrfstune.c b/btrfstune.c
> index 889b931c55d8..723317a00f3a 100644
> --- a/btrfstune.c
> +++ b/btrfstune.c
> @@ -179,10 +179,10 @@ static int change_extents_uuid(struct btrfs_fs_info *fs_info)
>  	return ret;
>  }
>  
> -static int change_device_uuid(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
> -			      int slot)
> +static int change_device_uuid(struct extent_buffer *eb, int slot)
>  {
>  	struct btrfs_dev_item *di;
> +	struct btrfs_fs_info *fs_info = eb->fs_info;
>  	int ret = 0;
>  
>  	di = btrfs_item_ptr(eb, slot, struct btrfs_dev_item);
> @@ -217,7 +217,7 @@ static int change_devices_uuid(struct btrfs_fs_info *fs_info)
>  		if (key.type != BTRFS_DEV_ITEM_KEY ||
>  		    key.objectid != BTRFS_DEV_ITEMS_OBJECTID)
>  			goto next;
> -		ret = change_device_uuid(fs_info, path.nodes[0], path.slots[0]);
> +		ret = change_device_uuid(path.nodes[0], path.slots[0]);
>  		if (ret < 0)
>  			goto out;
>  next:
> 
