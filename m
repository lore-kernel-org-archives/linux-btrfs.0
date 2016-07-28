Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44034 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1163416AbcG1HJE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 03:09:04 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id 109A042BA388
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 15:08:53 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH 13/13] btrfs-progs: check: fix false warning for check_extent_item()
Date: Thu, 28 Jul 2016 15:08:25 +0800
Message-ID: <1469689705-26836-14-git-send-email-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
References: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the case that a extent doesn't have inline ref, this function
shouldn't report ITEM_SIZE_MISMATCH.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index c52eebc..9fe3643 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10373,7 +10373,11 @@ static int check_extent_item(struct btrfs_fs_info *fs_info,
 	}
 	end = (unsigned long)ei + item_size;
 
-	if (ptr >= end) {
+	if (ptr == end) {
+		goto out;
+	} else if (ptr > end) {
+		error("bad extent item [%llu %u %llu] size wrong",
+		      key.objectid, key.type, key.offset);
 		err |= ITEM_SIZE_MISMATCH;
 		goto out;
 	}
-- 
2.7.4



