Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48115 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752082AbaJFBQ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Oct 2014 21:16:57 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s961GuGk015440
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Oct 2014 09:16:56 +0800
Message-ID: <5431EDAD.4050001@cn.fujitsu.com>
Date: Mon, 6 Oct 2014 09:17:33 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Don't return any fs_info that contain NULL
 tree_root or fs_root.
References: <1412044762-2480-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1412044762-2480-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please ignore this patch since Wang's patch has already fixed them.

https://patchwork.kernel.org/patch/4254631/

Thanks,
Qu
-------- Original Message --------
Subject: [PATCH] btrfs-progs: Don't return any fs_info that contain NULL 
tree_root or fs_root.
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年09月30日 10:39
> [BUG]
> btrfsck will segfault if it fails to open the fs tree or tree root.
>
> [REPRODUCER]
> Execute btrfsck on a highly damaged btrfs image.
> fsfuzz can be used to make a junk btrfs image.
>
> [REASON]
> Current open_ctree() in btrfs-progs support OPEN_CTREE_PARTIAL flag to
> allow return fs_info even some of the trees is missing.
>
> However it is too loose and even allows fs_info containing no tree to be
> returned.
>
> And when it happens, fs_info->fs_root is NULL,
> close_ctree(fs_info->fs_root) will cause the access to NULL pointer and
> segfault.
>
> [FIX]
> This patch will add checks for fs_info->tree_root and fs_info->fs_root
> before return fs_info.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   disk-io.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/disk-io.c b/disk-io.c
> index 26a532e..21a3083 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1134,7 +1134,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>   	return fs_info;
>   
>   out_failed:
> -	if (flags & OPEN_CTREE_PARTIAL)
> +	if (flags & OPEN_CTREE_PARTIAL &&
> +	    fs_info->tree_root && fs_info->fs_root)
>   		return fs_info;
>   out_chunk:
>   	btrfs_release_all_roots(fs_info);

