Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:54787 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab2ITUdG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 16:33:06 -0400
Received: from lenny.home.zabbo.net (unknown [192.168.242.141])
	by tetsuo.zabbo.net (Postfix) with ESMTP id 84C3572001C8
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2012 13:33:04 -0700 (PDT)
From: Zach Brown <zab@zabbo.net>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix min csum item size warnings in 32bit
Date: Thu, 20 Sep 2012 13:33:00 -0700
Message-Id: <cea7c0b16915e1a4aa497d4037179ddc7fc40419.1348173180.git.zab@zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit 7ca4be45a0255ac8f08c05491c6add2dd87dd4f8 limited csum items to
PAGE_CACHE_SIZE.  It used min() with incompatible types in 32bit which
generates warnings:

fs/btrfs/file-item.c: In function ‘btrfs_csum_file_blocks’:
fs/btrfs/file-item.c:717: warning: comparison of distinct pointer types lacks a cast

This uses min_t(u32,) to fix the warnings.  u32 seemed reasonable
because btrfs_root->leafsize is u32 and PAGE_CACHE_SIZE is unsigned
long.

Signed-off-by: Zach Brown <zab@zabbo.net>
---
 fs/btrfs/file-item.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 857d93c..2477e88 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -29,7 +29,8 @@
 				   sizeof(struct btrfs_item) * 2) / \
 				  size) - 1))
 
-#define MAX_CSUM_ITEMS(r, size) (min(__MAX_CSUM_ITEMS(r, size), PAGE_CACHE_SIZE))
+#define MAX_CSUM_ITEMS(r, size) (min_t(u32, __MAX_CSUM_ITEMS(r, size), \
+				       PAGE_CACHE_SIZE))
 
 #define MAX_ORDERED_SUM_BYTES(r) ((PAGE_SIZE - \
 				   sizeof(struct btrfs_ordered_sum)) / \
-- 
1.7.6.5

