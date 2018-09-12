Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41151 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeILQZX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 12:25:23 -0400
Received: by mail-pg1-f196.google.com with SMTP id s15-v6so898011pgv.8
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 04:21:18 -0700 (PDT)
From: damenly.su@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: suy.fnst@cn.fujitsu.com
Subject: [PATCH 3/6] btrfs-progs: lowmem check: find dir_item by di_key in check_dir_item()
Date: Wed, 12 Sep 2018 19:20:40 +0000
Message-Id: <20180912192046.5861-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180912192046.5861-1-suy.fnst@cn.fujitsu.com>
References: <20180912192046.5861-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

In check_dir_item, we are going to search corresponding
dir_item/index.

Commit 564901eac7a4 ("btrfs-progs: check: introduce
print_dir_item_err()") Changed argument name from key to di_key but
forgot to change the key name for dir_item search.
So @key shouldn't be used here. It should be @di_key.

Fixes: 564901eac7a4 ("btrfs-progs: check: introduce print_dir_item_err()")
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 1bce44f5658a..89a304bbdd69 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1658,7 +1658,7 @@ begin:
 
 		/* check relative INDEX/ITEM */
 		key.objectid = di_key->objectid;
-		if (key.type == BTRFS_DIR_ITEM_KEY) {
+		if (di_key->type == BTRFS_DIR_ITEM_KEY) {
 			key.type = BTRFS_DIR_INDEX_KEY;
 			key.offset = index;
 		} else {
-- 
2.18.0
