Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50231 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab3BYOCn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 09:02:43 -0500
Received: by mail-pa0-f42.google.com with SMTP id kq12so1766078pab.29
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 06:02:42 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com
Subject: [PATCH 1/4] Btrfs-progs: add check for level and id in case overflow happens
Date: Mon, 25 Feb 2013 22:02:37 +0800
Message-Id: <1361800957-1947-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

qgroupid(u64) is splitted into two parts:

	1) the lower 48 bit are used to represent id
	2) the higher 16 bit are used to represent level
So the check for id and level are necessary.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 qgroup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index dafde12..fbb50ab 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -34,11 +34,11 @@ u64 parse_qgroupid(char *p)
 		return id;
 	}
 	level = strtoull(p, &ptr_parse_end, 10);
-	if (ptr_parse_end != s)
+	if (ptr_parse_end != s || level >= (1ll << 16))
 		goto err;
 
 	id = strtoull(s+1, &ptr_parse_end, 10);
-	if (ptr_parse_end != ptr_src_end)
+	if (ptr_parse_end != ptr_src_end || id >= (1ll << 48))
 		goto  err;
 
 	return (level << 48) | id;
-- 
1.7.7.6

