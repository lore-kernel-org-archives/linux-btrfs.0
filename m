Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18355 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbaAHPKJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 10:10:09 -0500
Message-ID: <52CD6A46.2030802@fb.com>
Date: Wed, 8 Jan 2014 10:09:58 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
CC: <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] Btrfs: fix the race between write back and nocow
 buffered write
References: <1388149910-31499-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1388149910-31499-1-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/27/2013 08:11 AM, Miao Xie wrote:
> When we ran the 274th case of xfstests with nodatacow mount option,
> We met the following warning message:
> WARNING: CPU: 1 PID: 14185 at fs/btrfs/extent-tree.c:3734 btrfs_free_reserved_data_space+0xa6/0xd0
>
> It is caused by the race between the write back and nocow buffered
> write:
>    Task1				Task2
>    __btrfs_buffered_write()
>      skip data reservation
>      reserve the metadata space
>      copy the data
>      dirty the pages
>      unlock the pages
> 				write back the pages
> 				release the data space
>     				  becasue there is no
> 				  noreserve flag
>     set the noreserve flag
>
> This patch fixes this problem by unlocking the pages after
> the noreserve flag is set.
>
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>   fs/btrfs/file.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 82d0342..f6960c2 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1523,7 +1523,6 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>   		}
>   
>   		release_bytes = 0;
> -		btrfs_drop_pages(pages, num_pages);
>   

This isn't based on your other patch

     Btrfs: fix the reserved space leak caused by the race between 
nonlock dio and buffered io

You need to redo this one ontop of that patch, I'll take 2/2 tho. Thanks,

Josef
