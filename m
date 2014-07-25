Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36762 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752186AbaGYB7F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 21:59:05 -0400
Message-ID: <53D1B8A7.6070302@cn.fujitsu.com>
Date: Fri, 25 Jul 2014 09:53:43 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix compressed write corruption on enospc
References: <1406213285-19607-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1406213285-19607-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/24/2014 10:48 PM, Liu Bo wrote:
> When failing to allocate space for the whole compressed extent, we'll
> fallback to uncompressed IO, but we've forgotten to redirty the pages
> which belong to this compressed extent, and these 'clean' pages will
> simply skip 'submit' part and go to endio directly, at last we got data
> corruption as we write nothing.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>   fs/btrfs/inode.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3668048..8ea7610 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -709,6 +709,18 @@ retry:
>   				unlock_extent(io_tree, async_extent->start,
>   					      async_extent->start +
>   					      async_extent->ram_size - 1);
> +
> +				/*
> +				 * we need to redirty the pages if we decide to
> +				 * fallback to uncompressed IO, otherwise we
> +				 * will not submit these pages down to lower
> +				 * layers.
> +				 */
> +				extent_range_redirty_for_io(inode,
> +						async_extent->start,
> +						async_extent->start +
> +						async_extent->ram_size - 1);
> +
>   				goto retry;
BTW, if such ENOSPC happens, it means we could not reserve compressed space.
So we retry with nocompression codes, it will try to reserve more space. 
Any reason
we do such things?

Thanks,
Wang
>   			}
>   			goto out_free;

