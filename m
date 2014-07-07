Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20298 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752246AbaGGCC2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jul 2014 22:02:28 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: add mount status check for btrfs-image
Date: Mon, 7 Jul 2014 09:56:51 +0800
Message-ID: <1404698211-4236-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <20140703165818.GH1553@twin.jikos.cz>
References: <20140703165818.GH1553@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs-image run on a mounted filesystem,
the undergoing fs operations may change what you have imaged a while ago.
In this case, give a warning to remind the user that he may not
get a consistent image he wants.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
changelog:
	v1->v2: just give a warning if device mounted and let it continue
---
 btrfs-image.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 985aa26..e1d5482 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2570,10 +2570,18 @@ int main(int argc, char *argv[])
 			num_threads = 1;
 	}
 
-	if (create)
+	if (create) {
+		ret = check_mounted(source);
+		if (ret < 0) {
+			fprintf(stderr, "Could not check mount status: %s\n",
+				strerror(-ret));
+			exit(1);
+		} else if (ret)
+			fprintf(stderr, "WARNING: The device is mounted. Make sure you didn't do modifications.\n");
+
 		ret = create_metadump(source, out, num_threads,
 				      compress_level, sanitize, walk_trees);
-	else
+	} else
 		ret = restore_metadump(source, out, old_restore, 1,
 				       multi_devices);
 	if (ret) {
-- 
1.8.1.4

