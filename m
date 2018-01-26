Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59414 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752402AbeAZIaw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 03:30:52 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id AF1DD49F19BD
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 16:30:48 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 07/15] btrfs-progs: lowmem check: find_dir_item by di_key in check_dir_item()
Date: Fri, 26 Jan 2018 16:35:11 +0800
Message-ID: <20180126083519.28373-8-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In check_dir_item, we are going to search corresponding
dir_item/index.
@key shouldn't be used here. It should be @di_key.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 4ce6139b3ab1..caac71a67472 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6001,7 +6001,7 @@ begin:
 
 		/* check relative INDEX/ITEM */
 		key.objectid = di_key->objectid;
-		if (key.type == BTRFS_DIR_ITEM_KEY) {
+		if (di_key->type == BTRFS_DIR_ITEM_KEY) {
 			key.type = BTRFS_DIR_INDEX_KEY;
 			key.offset = index;
 		} else {
-- 
2.16.1



