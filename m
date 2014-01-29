Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53213 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaA2Pxm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 10:53:42 -0500
Received: by mail-pd0-f169.google.com with SMTP id v10so1860555pde.0
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 07:53:41 -0800 (PST)
Received: from linux-b0ol.localdomain ([36.58.227.58])
        by mx.google.com with ESMTPSA id pe3sm8367192pbc.23.2014.01.29.07.53.00
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jan 2014 07:53:40 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove unused argument from read_block_for_search()
Date: Wed, 29 Jan 2014 23:52:05 +0800
Message-Id: <1391010725-4604-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

@time_seq is no longer used in read_block_for_search(), remove it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 30f5b11..b484cd5 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2478,7 +2478,7 @@ static int
 read_block_for_search(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct btrfs_path *p,
 		       struct extent_buffer **eb_ret, int level, int slot,
-		       struct btrfs_key *key, u64 time_seq)
+		       struct btrfs_key *key)
 {
 	u64 blocknr;
 	u64 gen;
@@ -2906,7 +2906,7 @@ cow_done:
 			}
 
 			err = read_block_for_search(trans, root, p,
-						    &b, level, slot, key, 0);
+						    &b, level, slot, key);
 			if (err == -EAGAIN)
 				goto again;
 			if (err) {
@@ -3049,7 +3049,7 @@ again:
 			}
 
 			err = read_block_for_search(NULL, root, p, &b, level,
-						    slot, key, time_seq);
+						    slot, key);
 			if (err == -EAGAIN)
 				goto again;
 			if (err) {
@@ -5833,7 +5833,7 @@ again:
 		next = c;
 		next_rw_lock = path->locks[level];
 		ret = read_block_for_search(NULL, root, path, &next, level,
-					    slot, &key, 0);
+					    slot, &key);
 		if (ret == -EAGAIN)
 			goto again;
 
@@ -5883,7 +5883,7 @@ again:
 			break;
 
 		ret = read_block_for_search(NULL, root, path, &next, level,
-					    0, &key, 0);
+					    0, &key);
 		if (ret == -EAGAIN)
 			goto again;
 
-- 
1.8.4

