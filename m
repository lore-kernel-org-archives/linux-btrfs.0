Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:48763 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751388AbdKUKLs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 05:11:48 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id A49FC487F16A
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2017 18:11:46 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] btrfs-progs: check: report more specific info about invalid location
Date: Tue, 21 Nov 2017 18:15:22 +0800
Message-ID: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previously, it was so useless to print message like
"invalid location %d".

Let it print objectid and offset of dir_item.
Debug is easier now.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index a93ac2c88a38..5c15dfb60b9a 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1635,8 +1635,8 @@ static int process_dir_item(struct extent_buffer *eb,
 					  namebuf, len, filetype,
 					  key->type, error);
 		} else {
-			fprintf(stderr, "invalid location in dir item %u\n",
-				location.type);
+			fprintf(stderr, "invalid location in dir item[%llu %llu]\n",
+				key->objectid, key->offset);
 			add_inode_backref(inode_cache, BTRFS_MULTIPLE_OBJECTIDS,
 					  key->objectid, key->offset, namebuf,
 					  len, filetype, key->type, error);
-- 
2.15.0



