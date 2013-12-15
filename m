Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:47015 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3LODjt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 22:39:49 -0500
Received: by mail-pb0-f47.google.com with SMTP id um1so4114385pbc.20
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Dec 2013 19:39:49 -0800 (PST)
Received: from linux-b0ol.localdomain ([223.65.141.59])
        by mx.google.com with ESMTPSA id e6sm15973162pbg.4.2013.12.14.19.39.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Dec 2013 19:39:48 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove dead comments for read_csums()
Date: Sun, 15 Dec 2013 11:39:42 +0800
Message-Id: <1387078782-14979-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Chris introduced hleper function  read_csums() and this function
has been removed, but we forgot to remove its corresponding comments.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e889779..888b35e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2543,12 +2543,6 @@ out_kfree:
 	return NULL;
 }
 
-/*
- * helper function for btrfs_finish_ordered_io, this
- * just reads in some of the csum leaves to prime them into ram
- * before we start the transaction.  It limits the amount of btree
- * reads required while inside the transaction.
- */
 /* as ordered data IO finishes, this gets called so we can finish
  * an ordered extent if the range of bytes in the file it covers are
  * fully written.
-- 
1.8.4

