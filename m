Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3453 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1763832AbdEZCAa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 22:00:30 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 2058447C6103
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 10:00:28 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 3/5] btrfs-progs: check: enable lowmem repair
Date: Fri, 26 May 2017 10:02:16 +0800
Message-ID: <20170526020218.24502-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170526020218.24502-1-suy.fnst@cn.fujitsu.com>
References: <20170526020218.24502-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Enable btrfsck option '--repair' with option '--mode=lowmem'.
Now lowmem mode only repairs wrong nbytes, dir isize.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index cf4d8e09..58839314 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12973,11 +12973,10 @@ int cmd_check(int argc, char **argv)
 	}
 
 	/*
-	 * Not supported yet
+	 * Support partially
 	 */
 	if (repair && check_mode == CHECK_MODE_LOWMEM) {
-		error("low memory mode doesn't support repair yet");
-		exit(1);
+		warning("low memory mode support repair partially");
 	}
 
 	radix_tree_init();
-- 
2.13.0



