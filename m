Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:54071 "EHLO
        homiemail-a124.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1165911AbdDXHoG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Apr 2017 03:44:06 -0400
Subject: Re: [PATCH] Tidy while loop in end_compressed_writeback
References: <1ff02889-4c01-acb6-cfc0-48433a86bdf8@asilaycomputing.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, sahil.kang@asilaycomputing.com
From: Sahil Kang <sahil.kang@asilaycomputing.com>
Message-ID: <f46f81a7-4481-dd86-453b-d41d0f3a12bd@asilaycomputing.com>
Date: Mon, 24 Apr 2017 00:44:05 -0700
MIME-Version: 1.0
In-Reply-To: <1ff02889-4c01-acb6-cfc0-48433a86bdf8@asilaycomputing.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

I think my previous email may have failed to send.
Can you merge my patch below?
It's a minor update that I think improves readability.

Thanks,
Sahil

On 04/19/2017 05:43 AM, Sahil Kang wrote:
> Hi,
>
> This is my first patch so it's a minor code change.
> I think removing the early continue from the loop makes the function a 
> little easier to follow.
> Please have a look and I'd appreciate any feedback.
>
> Thanks,
> Sahil
>
>
> From 98afe83a570180e841fefe3fd48d450accc42ea3 Mon Sep 17 00:00:00 2001
> From: Sahil Kang <sahil.kang@asilaycomputing.com>
> Date: Wed, 19 Apr 2017 04:47:00 -0700
> Subject: [PATCH] Tidy while loop in end_compressed_writeback
>
> Instead of continuing early in the loop when ret is 0,
> we can decrement/increment nr_pages/index by 1 at the ending.
> The for loop will not execute when ret is 0 anyway.
>
> Signed-off-by: Sahil Kang <sahil.kang@asilaycomputing.com>
> ---
>  fs/btrfs/compression.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index c473c42..c653297 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -238,17 +238,14 @@ static noinline void 
> end_compressed_writeback(struct inode *inode,
>          ret = find_get_pages_contig(inode->i_mapping, index,
>                       min_t(unsigned long,
>                       nr_pages, ARRAY_SIZE(pages)), pages);
> -        if (ret == 0) {
> -            nr_pages -= 1;
> -            index += 1;
> -            continue;
> -        }
>          for (i = 0; i < ret; i++) {
>              if (cb->errors)
>                  SetPageError(pages[i]);
>              end_page_writeback(pages[i]);
>              page_cache_release(pages[i]);
>          }
> +
> +        ret = ret ? ret : 1; /* set ret to 1 if it's 0 */
>          nr_pages -= ret;
>          index += ret;
>      }

