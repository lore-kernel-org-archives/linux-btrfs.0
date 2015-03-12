Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49076 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751014AbbCLFpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Mar 2015 01:45:09 -0400
Message-ID: <550127E1.4050606@cn.fujitsu.com>
Date: Thu, 12 Mar 2015 13:45:05 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] Revert "Btrfs: allow superblock mismatch from older mkfs"
References: <1426138847-10851-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1426138847-10851-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I sent such patch some time ago but was rejected by Chris,
hopes this time it can be accepted.

This one can make btrfs much more robust.

Thanks,
Qu
-------- Original Message  --------
Subject: [PATCH] Revert "Btrfs: allow superblock mismatch from older mkfs"
From: Liu Bo <bo.li.liu@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年03月12日 13:40

> This reverts commit 667e7d94a1683661cff5fe9a0fa0d7f8fdd2c007.
>
> This was used to make sure that a fresh btrfs from an older mkfs.btrfs,
> and it also allows us to mount a buggy btrfs if this btrfs has the right
> superblock head part but has something wrong with chunk tree part[1], and
> after that we can hit BUG_ON()s set in the code to prevent something
> impossible.
>
> Since David has gave us "Btrfs progs v3.19-rc2", just remove the check,
> if anyone who wants to make a fresh btrfs, please use the latest one.
>
> [1]: http://www.spinics.net/lists/linux-btrfs/msg42358.html
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>
> Conflicts:
> 	fs/btrfs/disk-io.c
> ---
>   fs/btrfs/disk-io.c | 6 ------
>   1 file changed, 6 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 41b320e..f63aacf 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -418,12 +418,6 @@ static int btrfs_check_super_csum(char *raw_disk_sb)
>
>   		if (memcmp(raw_disk_sb, result, csum_size))
>   			ret = 1;
> -
> -		if (ret && btrfs_super_generation(disk_sb) < 10) {
> -			printk(KERN_WARNING
> -				"BTRFS: super block crcs don't match, older mkfs detected\n");
> -			ret = 0;
> -		}
>   	}
>
>   	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
>
