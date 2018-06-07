Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:8526 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753190AbeFGIpb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 04:45:31 -0400
Subject: Re: [PATCH v2 3/3] Fix misspelling of forward
To: james harvey <jamespharvey20@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CA+X5Wn5J-gF9VTYCvT=J7SQA3n3DP0PTExf7Zf8AcLzkkpG6OQ@mail.gmail.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <711bd032-8ee0-4451-9402-f8fbee329360@cn.fujitsu.com>
Date: Thu, 7 Jun 2018 16:51:29 +0800
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn5J-gF9VTYCvT=J7SQA3n3DP0PTExf7Zf8AcLzkkpG6OQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/07/2018 03:20 PM, james harvey wrote:
> Signed-off-by: James Harvey <jamespharvey20@gmail.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
>   btrfs-map-logical.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
> index 8a41b037..59ba731b 100644
> --- a/btrfs-map-logical.c
> +++ b/btrfs-map-logical.c
> @@ -39,7 +39,7 @@
>   static FILE *info_file;
> 
>   static int map_one_extent(struct btrfs_fs_info *fs_info,
> -                         u64 *logical_ret, u64 *len_ret, int search_foward)
> +                         u64 *logical_ret, u64 *len_ret, int search_forward)
>   {
>          struct btrfs_path *path;
>          struct btrfs_key key;
> @@ -75,11 +75,11 @@ static int map_one_extent(struct btrfs_fs_info *fs_info,
> 
>   again:
>          btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
> -       if ((search_foward && key.objectid < logical) ||
> -           (!search_foward && key.objectid > logical) ||
> +       if ((search_forward && key.objectid < logical) ||
> +           (!search_forward && key.objectid > logical) ||
>              (key.type != BTRFS_EXTENT_ITEM_KEY &&
>               key.type != BTRFS_METADATA_ITEM_KEY)) {
> -               if (!search_foward)
> +               if (!search_forward)
>                          ret = btrfs_previous_extent_item(fs_info->extent_root,
>                                                           path, 0);
>                  else
> --
> 2.17.0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


