Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17573 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754458AbaHGCvV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Aug 2014 22:51:21 -0400
Message-ID: <53E2E9A3.6060206@cn.fujitsu.com>
Date: Thu, 7 Aug 2014 10:51:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs: Don't continue mounting when superblock csum mismatches
 even generation is less than 10.
References: <1403599753-4072-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1403599753-4072-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It seems that the patch is rejected in patchwork,

Could any one tell me the reason?

Thanks,
Qu
-------- Original Message --------
Subject: [PATCH] btrfs: Don't continue mounting when superblock csum 
mismatches even generation is less than 10.
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Date: 2014年06月24日 16:49
> Revert kernel commit 667e7d94a1683661cff5fe9a0fa0d7f8fdd2c007.
> (Btrfs: allow superblock mismatch from older mkfs by Chris Mason)
>
> Above commit will cause disaster if someone try to mount a newly created but
> later corrupted btrfs filesystem.
>
> And before btrfs entered mainline, btrfs-progs has already superblock
> checksum. See btrfs-progs commit: 5ccd1715fa2eaad0b26037bb53706779c8c93b5f
> (superblock duplication by Yan Zheng).
> Before commit 5ccd17, mkfs.btrfs uses 16K as super offset, while current btrfs
> uses 64K super offset, anyway old btrfs without super csum will not be
> mountable due to the change of super offset.
>
> So backward compatibility is not a problem.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/disk-io.c | 6 ------
>   1 file changed, 6 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 8bb4aa1..dbfb2a3 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -400,12 +400,6 @@ static int btrfs_check_super_csum(char *raw_disk_sb)
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

