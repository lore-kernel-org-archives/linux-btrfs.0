Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33090 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753198AbcHXJJB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 05:09:01 -0400
Received: by mail-it0-f68.google.com with SMTP id d65so1490455ith.0
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Aug 2016 02:08:10 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20160824041300.20072-1-quwenruo@cn.fujitsu.com>
References: <20160824041300.20072-1-quwenruo@cn.fujitsu.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 24 Aug 2016 09:54:16 +0100
Message-ID: <CAL3q7H5joucRg1V_Ddmw0CU_rPfQ0AsEYW8qw1KRxO+hnZm5cA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Fix extent map leak in find_first_block_group
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Liu Bo <bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 24, 2016 at 5:13 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> The following commit introduced the extent map leak:
> commit 6fb37b756acce6d6e045f79c3764206033f617b4
> Author: Liu Bo <bo.li.liu@oracle.com>
> Date:   Wed Jun 22 18:31:27 2016 -0700
>
>     Btrfs: check inconsistence between chunk and block group
>
> This leads to slab warning at rmmod time.
>
> Cc: Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

https://patchwork.kernel.org/patch/9288751/

> ---
>  fs/btrfs/extent-tree.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index c2b81b0..e621823 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9905,6 +9905,7 @@ static int find_first_block_group(struct btrfs_root *root,
>                                 ret = -ENOENT;
>                         } else {
>                                 ret = 0;
> +                               free_extent_map(em);
>                         }
>                         goto out;
>                 }
> --
> 2.7.4
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
