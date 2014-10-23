Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38015 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753121AbaJWHbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 03:31:17 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s9N7VAPh013091
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 15:31:10 +0800
Message-ID: <5448AEC3.2080308@cn.fujitsu.com>
Date: Thu, 23 Oct 2014 15:31:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs: Add more check before read_extent_buffer()
 to avoid read overflow.
References: <1411012892-17481-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1411012892-17481-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm sorry that this patch is not needed since inline extent will not go 
into this routine,
so no overflow.

Please ignore the patch,
Thanks,
Qu
-------- Original Message --------
Subject: [PATCH 1/2] btrfs: Add more check before read_extent_buffer() 
to avoid read overflow.
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年09月18日 12:01
> Before this patch, when replay_one_extent() find an existing file
> extent item, btrfs will call read_extent_buffer() to read out the file
> extent.
> However it lacks enough check, and may read out the inline file extent
> using the wrong size(currently it always uses
> sizeof(btrfs_file_extent_item))
>
> If a inline file extent's size is smaller than normal file extent
> size(53 bytes) and unfortunately the inline file extent lies at the end
> of a full leaf, WARN_ON in read_extent_buffer() will be triggered.
>
> This patch will check the file extent type before calling
> read_extent_buffer(), since the if the logged one and the existing one
> are all preallocated/regular file extent item, their size must be
> sizeof(struct btrfs_file_extent_item) and will avoid the read overflow.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/tree-log.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 7e0e6e3..1ea2b10 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -620,6 +620,8 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
>   		existing = btrfs_item_ptr(leaf, path->slots[0],
>   					  struct btrfs_file_extent_item);
>   
> +		if (btrfs_file_extent_type(leaf, existing) != found_type)
> +			goto no_compare;
>   		read_extent_buffer(eb, &cmp1, (unsigned long)item,
>   				   sizeof(cmp1));
>   		read_extent_buffer(leaf, &cmp2, (unsigned long)existing,
> @@ -634,6 +636,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
>   			goto out;
>   		}
>   	}
> +no_compare:
>   	btrfs_release_path(path);
>   
>   	/* drop any overlapping extents */

