Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44501 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752626AbeFHB13 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 21:27:29 -0400
Subject: Re: [PATCH v3 (Only) 2/3] btrfs-progs: map-logical: Use
 btrfs_next_extent_item()
To: james harvey <jamespharvey20@gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <6c838a08-3d84-8cc7-b20e-aea7dca3793c@cn.fujitsu.com>
Date: Fri, 8 Jun 2018 09:33:35 +0800
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn6EP4nxGA7hE4HCUa9jWpk3XVVPdR0zb1v9Yd-y9kH5Ew@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <CA+X5Wn6EP4nxGA7hE4HCUa9jWpk3XVVPdR0zb1v9Yd-y9kH5Ew@mail.gmail.com>



On 06/08/2018 02:41 AM, james harvey wrote:
> On Thu, Jun 7, 2018 at 4:50 AM, Su Yue <suy.fnst@cn.fujitsu.com> wrote:
>> On 06/07/2018 03:20 PM, james harvey wrote:
>>>
>>> btrfs_next_extent_item() looks for BTRFS_EXTENT_ITEM_KEY and
>>> BTRFS_METADATA_KEY,
>>> which are the types we're looking for.
>>>
>>> Signed-off-by: James Harvey <jamespharvey20@gmail.com>
>>
>> Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> 
> btrfs_next_extent_item() looks for BTRFS_EXTENT_ITEM_KEY and BTRFS_METADATA_KEY,
> which are the types we're looking for.
> 
> (Previous versions missed last 0 argument to btrfs_next_extent_item().  Sorry, I
> realize I need to take more time before sending, being more careful on
> everything.)
> 

So do I.

If you want to write something which is unreleated to
changes in a patch. Just put them and changelog belows "---" under
SOB line.
It would be easier for maintainers to apply patches.

And, I noticed patches sent by you are separated in ML. It's OK.
Puting series into one thread is better for review. You can
use tools like 'git-send-email' to send patches.
The last nag: a coverletter is nice with patches.
Link of conversation:
https://www.spinics.net/lists/linux-btrfs/msg77791.html

> Signed-off-by: James Harvey <jamespharvey20@gmail.com>
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
> +                                                    path, 0);
After a careful look, if btrfs_next/previous_extent_item is used here.
It's no need to check
====
  if ((search_foward && key.objectid < logical) || 

             (!search_foward && key.objectid > logical) || 

             (key.type != BTRFS_EXTENT_ITEM_KEY && 

              key.type != BTRFS_METADATA_ITEM_KEY)) {
===
Pass @logical as the last parameters of
btrfs_next/previous_extent_item() is simple enough.

Thanks,
Su

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


