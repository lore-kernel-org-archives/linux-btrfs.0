Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18273 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbbJGJYk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Oct 2015 05:24:40 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH V2] Btrfs: add missing brelse when superblock checksum fails
Date: Wed,  7 Oct 2015 17:23:23 +0800
Message-Id: <1444209803-16101-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1444035320-9400-1-git-send-email-anand.jain@oracle.com>
References: <1444035320-9400-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like oversight, call brelse() when checksum fails. Further down the
code, in the non error path, we do call brelse() and so we don't see
brelse() in the goto error paths.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
V2: Updated changelog

 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c7c739f..1b72cb5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2665,6 +2665,7 @@ int open_ctree(struct super_block *sb,
 	if (btrfs_check_super_csum(bh->b_data)) {
 		printk(KERN_ERR "BTRFS: superblock checksum mismatch\n");
 		err = -EINVAL;
+		brelse(bh);
 		goto fail_alloc;
 	}
 
-- 
2.4.1

