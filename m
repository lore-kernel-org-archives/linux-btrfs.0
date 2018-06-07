Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:60139 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753387AbeFGIom (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 04:44:42 -0400
Subject: Re: [PATCH v2 2/3] btrfs-progs: map-logical: Use
 btrfs_next_extent_item()
To: james harvey <jamespharvey20@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CA+X5Wn4GAp9cLqCKUiu4H6PSAvi9e0quDsQOjarZbS5EDWmspA@mail.gmail.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <9d281216-5184-96cc-6b87-923b7b674bb1@cn.fujitsu.com>
Date: Thu, 7 Jun 2018 16:50:47 +0800
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn4GAp9cLqCKUiu4H6PSAvi9e0quDsQOjarZbS5EDWmspA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/07/2018 03:20 PM, james harvey wrote:
> btrfs_next_extent_item() looks for BTRFS_EXTENT_ITEM_KEY and BTRFS_METADATA_KEY,
> which are the types we're looking for.
> 
> Signed-off-by: James Harvey <jamespharvey20@gmail.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
>   btrfs-map-logical.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
> index 2451012b..8a41b037 100644
> --- a/btrfs-map-logical.c
> +++ b/btrfs-map-logical.c
> @@ -83,7 +83,8 @@ again:
>                          ret = btrfs_previous_extent_item(fs_info->extent_root,
>                                                           path, 0);
>                  else
> -                       ret = btrfs_next_item(fs_info->extent_root, path);
> +                       ret = btrfs_next_extent_item(fs_info->extent_root,
> +                                                    path);
>                  if (ret)
>                          goto out;
>                  goto again;
> --
> 2.17.0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


