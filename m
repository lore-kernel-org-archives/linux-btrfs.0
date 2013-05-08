Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19404 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab3EHIJ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 May 2013 04:09:58 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r4889rTD019759
	for <linux-btrfs@vger.kernel.org>; Wed, 8 May 2013 16:09:53 +0800
Message-ID: <518A0871.5090907@cn.fujitsu.com>
Date: Wed, 08 May 2013 16:10:25 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix possible memory leak in the find_parent_nodes()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the find_parent_nodes(), if read_tree_block() fails, we can
not return directly, we should free some allocated memory otherwise
memory leak happens.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
Since Chris has already setup his pull, we'd like to send
another patch.
---
 fs/btrfs/backref.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index b4fb415..290e347 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -918,7 +918,8 @@ again:
 							   ref->parent, bsz, 0);
 				if (!eb || !extent_buffer_uptodate(eb)) {
 					free_extent_buffer(eb);
-					return -EIO;
+					ret = -EIO;
+					goto out;
 				}
 				ret = find_extent_in_eb(eb, bytenr,
 							*extent_item_pos, &eie);
-- 
1.7.7.6






