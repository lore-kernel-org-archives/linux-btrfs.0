Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:10647 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754846Ab3LDJZB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Dec 2013 04:25:01 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rB49Ows6000605
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Dec 2013 17:24:58 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fix segfault when getting scrub status
Date: Wed, 4 Dec 2013 17:24:36 +0800
Message-Id: <1386149076-10253-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I sometimes get segfault in cmd_scrub_status(), this is because
free_history() forgot to check whether pointer address is valid,fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 9f614bc..69791b3 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -285,7 +285,7 @@ static void print_fs_stat(struct scrub_fs_stat *fs_stat, int raw)
 static void free_history(struct scrub_file_record **last_scrubs)
 {
 	struct scrub_file_record **l = last_scrubs;
-	if (!l)
+	if (!l || IS_ERR(l))
 		return;
 	while (*l)
 		free(*l++);
-- 
1.8.3.1

