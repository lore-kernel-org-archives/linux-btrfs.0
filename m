Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13785 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754741AbbAIIM4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jan 2015 03:12:56 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t098CL52030005
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Jan 2015 16:12:22 +0800
From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs:btrfstune:fix multiple options error
Date: Fri, 9 Jan 2015 16:11:42 +0800
Message-ID: <1420791102-9948-2-git-send-email-fancn.fnst@cn.fujitsu.com>
In-Reply-To: <1420791102-9948-1-git-send-email-fancn.fnst@cn.fujitsu.com>
References: <1420791102-9948-1-git-send-email-fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when we use multiple options, error return status will be override by the
last option status.
example: btrfstune -S 1 -r /dev/loop0
when -S option fails and -r option succeeds, return value is 0, rather than
1, where 1 is the right return status.

Reported-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
---
 btrfstune.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/btrfstune.c b/btrfstune.c
index 9a9e855..499a71d 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -117,6 +117,7 @@ int main(int argc, char *argv[])
 {
 	struct btrfs_root *root;
 	int success = 0;
+	int total = 0;
 	int extrefs_flag = 0;
 	int seeding_flag = 0;
 	u64 seeding_value = 0;
@@ -199,19 +200,22 @@ int main(int argc, char *argv[])
 			ignore_enabled_seeding);
 		if (!ret)
 			success++;
+		total++;
 	}
 
 	if (extrefs_flag) {
 		enable_extrefs_flag(root);
 		success++;
+		total++;
 	}
 
 	if (skinny_flag) {
 		enable_skinny_metadata(root);
 		success++;
+		total++;
 	}
 
-	if (success > 0) {
+	if (success == total) {
 		ret = 0;
 	} else {
 		root->fs_info->readonly = 1;
-- 
1.9.1

