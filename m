Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50487 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752497AbdDKDZK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 23:25:10 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 764CB47CE231
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Apr 2017 11:25:05 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] btrfs-progs: check: enable lowmem repair
Date: Tue, 11 Apr 2017 11:26:29 +0800
Message-ID: <20170411032631.24932-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170411032631.24932-1-suy.fnst@cn.fujitsu.com>
References: <20170411032631.24932-1-suy.fnst@cn.fujitsu.com>
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
index 6ab18b26..da5fe75f 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12925,11 +12925,10 @@ int cmd_check(int argc, char **argv)
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
2.12.0



