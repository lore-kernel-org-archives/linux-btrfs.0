Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:65285 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932713AbeFGIlq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 04:41:46 -0400
Subject: Re: [PATCH v2 1/3] btrfs-progs: map-logical: look at next leaf if
 slot > items
To: james harvey <jamespharvey20@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CA+X5Wn4Ygijhnc2m4zHeH+wOTvFNOGepk5g08_D4a0dQWWMfpQ@mail.gmail.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <4f96864c-4a34-f109-c7df-a75c1e0e2764@cn.fujitsu.com>
Date: Thu, 7 Jun 2018 16:47:54 +0800
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn4Ygijhnc2m4zHeH+wOTvFNOGepk5g08_D4a0dQWWMfpQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/07/2018 03:19 PM, james harvey wrote:
> btrfs-map-logical -l 10955980800 -b 4096 <path>
> No extent found at range [10955980800,10955984896)
> 
> But, this extent exists.  btrfs-debug-tree shows:
> 
>     item 202 key (10955976704 EXTENT_ITEM 4096) itemoff 8772 itemsize 37
>             refs 1 gen 62656 flags DATA
>             shared data backref parent 142655488 count 1
> ...
>     item 0 key (10955980800 EXTENT_ITEM 4096) itemoff 16246 itemsize 37
>             refs 1 gen 62656 flags DATA
>             shared data backref parent 128958464 count 1
> 
> The code searches for (<logical>, 0, 0), and looks forward then backward.  It
> needs to go to the next leaf when slot > number of items on this leaf.
> 
> Signed-off-by: James Harvey <jamespharvey20@gmail.com>
> ---
>   btrfs-map-logical.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
> index 7a8bcff9..2451012b 100644
> --- a/btrfs-map-logical.c
> +++ b/btrfs-map-logical.c
> @@ -65,6 +65,14 @@ static int map_one_extent(struct btrfs_fs_info *fs_info,
>          BUG_ON(ret == 0);
>          ret = 0;
> 
> +       if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
> +               ret = btrfs_next_leaf(fs_info->extent_root, path);

It seems that you forgot to handle the case ret < 0.

Thanks,
Su

> +               if (ret > 0) {
> +                       ret = -ENOENT;
> +                       goto out;
> +               }
> +       }
> +
>   again:
>          btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>          if ((search_foward && key.objectid < logical) ||
> --
> 2.17.0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


