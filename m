Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47844 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3FNP1P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Jun 2013 11:27:15 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 03B309A0692
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Jun 2013 09:27:15 -0600 (MDT)
Date: Fri, 14 Jun 2013 11:27:12 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V3] Btrfs: remove btrfs_sector_sum structure
Message-ID: <20130614152712.GA28783@localhost.localdomain>
References: <51878334.4000807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51878334.4000807@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 06, 2013 at 04:17:24AM -0600, Miao Xie wrote:
> Using the structure btrfs_sector_sum to keep the checksum value is
> unnecessary, because the extents that btrfs_sector_sum points to are
> continuous, we can find out the expected checksums by btrfs_ordered_sum's
> bytenr and the offset, so we can remove btrfs_sector_sum's bytenr. After
> removing bytenr, there is only one member in the structure, so it makes
> no sense to keep the structure, just remove it, and use a u32 array to
> store the checksum value.
> 
> By this change, we don't use the while loop to get the checksums one by
> one. Now, we can get several checksum value at one time, it improved the
> performance by ~74% on my SSD (31MB/s -> 54MB/s).
> 
> test command:
>  # dd if=/dev/zero of=/mnt/btrfs/file0 bs=1M count=1024 oflag=sync
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> Changelog v2 -> v3:
> - address the problem that the csums was inserted into the wrong range, this bug
>   was reported by Josef.
> 
> Changelog v1 -> v2:
> - modify the changelog and the title which can not explain this patch clearly
> - fix the 64bit division problem on 32bit machine
> ---

Hit another bug with this patch.  Doing a relocate it was screwing up csums for
data blocks we were relocating.  I think this fixes the problem but I've only
just made sure it made my problem go away.  Please look at it and do some extra
testing with relocation and if it is good re-submit.  In the meantime I'm
dropping this patch from btrfs-next until you resubmit.  Thanks,

Josef


diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index df3c632..1209649 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4473,11 +4473,13 @@ int btrfs_reloc_clone_csums(struct inode *inode, u64 file_pos, u64 len)
 	if (ret)
 		goto out;
 
+	disk_bytenr = ordered->start;
 	while (!list_empty(&list)) {
 		sums = list_entry(list.next, struct btrfs_ordered_sum, list);
 		list_del_init(&sums->list);
 
-		sums->bytenr = ordered->start;
+		sums->bytenr = disk_bytenr;
+		disk_bytenr += sums->len;
 
 		btrfs_add_ordered_sum(inode, ordered, sums);
 	}
