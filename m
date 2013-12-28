Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:58765 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab3L1Lwq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Dec 2013 06:52:46 -0500
Received: by mail-pb0-f52.google.com with SMTP id uo5so10108973pbc.11
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Dec 2013 03:52:45 -0800 (PST)
Received: from linux-b0ol.localdomain ([223.65.188.73])
        by mx.google.com with ESMTPSA id dq3sm68495815pbc.35.2013.12.28.03.52.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Dec 2013 03:52:44 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix an oops when we fail to relocate tree blocks
Date: Sat, 28 Dec 2013 19:52:39 +0800
Message-Id: <1388231559-2463-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

During balance test, we hit an oops:
[ 2013.841551] kernel BUG at fs/btrfs/relocation.c:1174!

The problem is that if we fail to relocate tree blocks, we should
update backref cache, otherwise, some pending nodes are not updated
while snapshot check @cache->last_trans is within one transaction
and won't update it and then oops happen.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b530ed9..4a3f0d9 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4075,6 +4075,12 @@ restart:
 		if (!RB_EMPTY_ROOT(&blocks)) {
 			ret = relocate_tree_blocks(trans, rc, &blocks);
 			if (ret < 0) {
+				/*
+				 * if we fail to relocate tree blocks, force to update
+				 * backref cache when committing transaction.
+				 */
+				rc->backref_cache.last_trans = trans->transid - 1;
+
 				if (ret != -EAGAIN) {
 					err = ret;
 					break;
-- 
1.8.4

