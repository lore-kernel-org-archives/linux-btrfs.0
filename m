Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7096 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752123AbaJFBQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Oct 2014 21:16:01 -0400
Message-ID: <5431ED70.2040708@cn.fujitsu.com>
Date: Mon, 6 Oct 2014 09:16:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/4] Btrfs-progs: fsck: disallow partial opening if critical
 roots corrupted
References: <1401276041-18349-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1401276041-18349-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1401276041-18349-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH 2/4] Btrfs-progs: fsck: disallow partial opening if 
critical roots corrupted
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Date: 2014年05月28日 19:20
> If btrfs tree root is corrupted, fsck will hit the following segmentation.
>
> enabling repair mode
> Check tree block failed, want=29376512, have=0
> Check tree block failed, want=29376512, have=0
> Check tree block failed, want=29376512, have=0
> Check tree block failed, want=29376512, have=0
> Check tree block failed, want=29376512, have=0
> read block failed check_tree_block
> Couldn't read tree root
> Checking filesystem on /dev/sda9
> UUID: 0e1a754d-04a5-4256-ae79-0f769751803e
> Critical roots corrupted, unable to fsck the FS
> Segmentation fault (core dumped)
>
> In btrfs_setup_all_roots(), we could tolerate some trees(extent tree, csum tree)
> corrupted, and we have did careful check inside that function, it will
> return NULL if critial roots corrupt(for example tree root).
>
> The problem is that we check @OPEN_CTREE_PARTIAL flag again after
> calling btrfs_setup_all_roots() which will successfully return
> @fs_info though critial roots corrupted.
>
> Fix this problem by removing @OPEN_CTREE_PARTIAL flag check outsize
> btrfs_setup_all_roots().
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>   disk-io.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/disk-io.c b/disk-io.c
> index 58f3f07..63e153d 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1134,13 +1134,10 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>   
>   	ret = btrfs_setup_all_roots(fs_info, root_tree_bytenr, flags);
>   	if (ret)
> -		goto out_failed;
> +		goto out_chunk;
>   
>   	return fs_info;
>   
> -out_failed:
> -	if (flags & OPEN_CTREE_PARTIAL)
> -		return fs_info;
>   out_chunk:
>   	btrfs_release_all_roots(fs_info);
>   	btrfs_cleanup_all_caches(fs_info);
Tested-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

This patch fixed a lot of segfault when checking fsfuzzed btrfs image.

Thanks,
Qu
