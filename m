Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49864 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbcENKbe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 May 2016 06:31:34 -0400
Subject: Re: [PATCH 3/7] Btrfs: check if extent buffer is aligned to
 sectorsize
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
 <1463184422-13584-3-git-send-email-bo.li.liu@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <02aae5ea-bd0e-689d-85d2-327d7b177aad@gmx.com>
Date: Sat, 14 May 2016 18:30:52 +0800
MIME-Version: 1.0
In-Reply-To: <1463184422-13584-3-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

Thanks for your patch first.

On 05/14/2016 08:06 AM, Liu Bo wrote:
> Thanks to fuzz testing, we can pass an invalid bytenr to extent buffer
> via alloc_extent_buffer().  An unaligned eb can have more pages than it
> should have, which ends up extent buffer's leak or some corrupted content
> in extent buffer.
>
> This adds a warning to let us quickly know what was happening.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/extent_io.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d247fc0..e601e0f 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4868,6 +4868,10 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>  	int uptodate = 1;
>  	int ret;
>
> +	WARN_ONCE(!IS_ALIGNED(start, fs_info->tree_root->sectorsize),
> +		  KERN_WARNING "eb->start(%llu) is not aligned to root->sectorsize(%u)\n",
> +		  start, fs_info->tree_root->sectorsize);
> +

IMHO this is a quite big problem. As almost all other things rely on the 
assumption that extent buffer are at least sectorsize aligned.

What about warning and returning NULL? WARN_ONCE() only won't info user 
quick enough.

BTW, after a quick glance into __alloc_extent_buffer(), it seems that we 
didn't check the return pointer of kmem_cache_zalloc(), since you're 
fixing things around that code, would you mind to fix it too?

Thanks,
Qu

>  	eb = find_extent_buffer(fs_info, start);
>  	if (eb)
>  		return eb;
>
