Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47372 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753109AbdHWCeA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 22:34:00 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id B869F46B5FD3
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 10:34:00 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 1/6] btrfs-progs: check: enable repair in lowmem mode
Date: Wed, 23 Aug 2017 10:33:45 +0800
Message-ID: <20170823023350.2940-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20170823023350.2940-1-lufq.fnst@cn.fujitsu.com>
References: <20170823023350.2940-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

Turn on the option --repair with --mode==lowmem in btrfsck.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index c5faa2b..829f7c5 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12844,12 +12844,10 @@ int cmd_check(int argc, char **argv)
 	}
 
 	/*
-	 * Not supported yet
+	 * experimental and dangerous
 	 */
-	if (repair && check_mode == CHECK_MODE_LOWMEM) {
-		error("low memory mode doesn't support repair yet");
-		exit(1);
-	}
+	if (repair && check_mode == CHECK_MODE_LOWMEM)
+		printf("Low memory mode supports repair partially\n");
 
 	radix_tree_init();
 	cache_tree_init(&root_cache);
-- 
2.7.4



