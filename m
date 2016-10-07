Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20471 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754749AbcJGGdx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Oct 2016 02:33:53 -0400
Subject: Re: [RFC 3/3] btrfs: make shrink_delalloc() try harder to reclaim
 metadata space
To: <linux-btrfs@vger.kernel.org>
References: <1474441173-31049-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1474536319-22659-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
CC: <jbacik@fb.com>, <dsterba@suse.cz>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57F7406D.6080805@cn.fujitsu.com>
Date: Fri, 7 Oct 2016 14:27:57 +0800
MIME-Version: 1.0
In-Reply-To: <1474536319-22659-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Any comments about these 3 patches, thanks.

Regards,
Xiaoguang Wang

On 09/22/2016 05:25 PM, Wang Xiaoguang wrote:
> Since commit b02441999efcc6152b87cd58e7970bb7843f76cf, we don't wait all
> ordered extents, but I run into some enospc errors when doing large file
> create and delete test, it's because shrink_delalloc() does not write
> enough delalloc bytes and wait them finished:
>      From: Miao Xie <miaox@cn.fujitsu.com>
>      Date: Mon, 4 Nov 2013 23:13:25 +0800
>      Subject: [PATCH] Btrfs: don't wait for the completion of all the ordered extents
>
>      It is very likely that there are lots of ordered extents in the filesytem,
>      if we wait for the completion of all of them when we want to reclaim some
>      space for the metadata space reservation, we would be blocked for a long
>      time. The performance would drop down suddenly for a long time.
>
> But since Josef introduced "Btrfs: introduce ticketed enospc infrastructure",
> shrink_delalloc() starts to be run asynchronously, then If we want to reclaim
> metadata space, we can try harder, after all, false enospc error is not
> acceptable.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>   fs/btrfs/extent-tree.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 46c2a37..f7c420b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4721,7 +4721,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
>   		if (trans)
>   			return;
>   		if (wait_ordered)
> -			btrfs_wait_ordered_roots(root->fs_info, items,
> +			btrfs_wait_ordered_roots(root->fs_info, -1,
>   						 0, (u64)-1);
>   		return;
>   	}
> @@ -4775,6 +4775,14 @@ skip_async:
>   		}
>   		delalloc_bytes = percpu_counter_sum_positive(
>   						&root->fs_info->delalloc_bytes);
> +		if (loops == 2) {
> +			/*
> +			 * Try to write all current delalloc bytes and wait all
> +			 * ordered extents to have a last try.
> +			 */
> +			to_reclaim = delalloc_bytes;
> +			items = -1;
> +		}
>   	}
>   }
>   



