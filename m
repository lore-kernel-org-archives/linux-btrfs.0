Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47640 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751680AbdHAP0B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Aug 2017 11:26:01 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1F95BABDD
        for <linux-btrfs@vger.kernel.org>; Tue,  1 Aug 2017 15:26:00 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: remove broken memory barrier
Date: Tue,  1 Aug 2017 18:25:56 +0300
Message-Id: <1501601156-19585-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 38851cc19adb ("Btrfs: implement unlocked dio write") implemented
unlocked dio write, allowing multiple dio writers to write to non-overlapping,
and non-eof-extending regions. In doing so it also introduced a broken memory
barrier. It is broken due to 2 things:

1. Memory barriers _MUST_ always be paired, this is clearly not the case here

2. Checkpatch actually produces a warning if a memory barrier is introduced that
doesn't have a comment explaining how it's being paired.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95c212037095..5e48d2c10152 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8731,7 +8731,6 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		return 0;
 
 	inode_dio_begin(inode);
-	smp_mb__after_atomic();
 
 	/*
 	 * The generic stuff only does filemap_write_and_wait_range, which
-- 
2.7.4

