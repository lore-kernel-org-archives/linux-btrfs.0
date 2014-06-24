Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5166 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750827AbaFXCly (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 22:41:54 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2 2/4] btrfs-progs: deal with invalid option combinations for btrfs-image
Date: Tue, 24 Jun 2014 10:36:33 +0800
Message-ID: <1403577393-6096-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <20140623141214.GF1553@twin.jikos.cz>
References: <20140623141214.GF1553@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs-image,
	dump 	may not come with option '-o'
	-r	may not come with option '-c', '-s', '-w', dev_cnt != 1
	-m	may not come with dev_cnt < 2
All of the above should be regarded as invalid combinations,
and the usage will show up.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
changelog
	v1->v2: add error messages for each case
---
 btrfs-image.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index db5d193..c18dff1 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2462,6 +2462,7 @@ int main(int argc, char *argv[])
 	int ret;
 	int sanitize = 0;
 	int dev_cnt = 0;
+	int usage_error = 0;
 	FILE *out;
 
 	while (1) {
@@ -2500,15 +2501,26 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if ((old_restore) && create)
-		print_usage();
-
 	argc = argc - optind;
 	dev_cnt = argc - 1;
 
-	if (multi_devices && dev_cnt < 2)
-		print_usage();
-	if (!multi_devices && dev_cnt != 1)
+	if (create) {
+		usage_error = old_restore;
+		fprintf(stderr, "Usage error: create and restore cannot be used at the same time\n");
+	} else {
+		usage_error = walk_trees || sanitize || compress_level;
+		fprintf(stderr, "Usage error: use -w, -s, -c options for restore makes no sense\n");
+
+		if (multi_devices) {
+			usage_error = usage_error || (dev_cnt < 2);
+			fprintf(stderr, "Usage error: not enough devices specified for -m option\n");
+		} else {
+			usage_error = usage_error || (dev_cnt != 1);
+			fprintf(stderr, "Usage error: accepts only 1 device without -m option\n");
+		}
+	}
+
+	if (usage_error)
 		print_usage();
 
 	source = argv[optind];
-- 
1.8.1.4

