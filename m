Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37807 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751164AbbASH3B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 02:29:01 -0500
From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Subject: [PATCH v2 2/2] btrfs-progs:btrfstune:fix multiple options error
Date: Mon, 19 Jan 2015 15:27:31 +0800
Message-ID: <1421652451-994-2-git-send-email-fancn.fnst@cn.fujitsu.com>
In-Reply-To: <1421652451-994-1-git-send-email-fancn.fnst@cn.fujitsu.com>
References: <1421652451-994-1-git-send-email-fancn.fnst@cn.fujitsu.com>
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
index 15f68c8..075fbc6 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -114,6 +114,7 @@ int main(int argc, char *argv[])
 {
 	struct btrfs_root *root;
 	int success = 0;
+	int total = 0;
 	int extrefs_flag = 0;
 	int seeding_flag = 0;
 	u64 seeding_value = 0;
@@ -190,19 +191,22 @@ int main(int argc, char *argv[])
 		ret = update_seeding_flag(root, seeding_value);
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

