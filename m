Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7817 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754444AbaHGCgQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Aug 2014 22:36:16 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s772aCtj005030
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Aug 2014 10:36:12 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: check option conflict for btrfs-convert
Date: Thu, 7 Aug 2014 10:35:57 +0800
Message-ID: <1407378959-23728-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The -d, -i, -n options make no sense to rollback.
Check the improper usages such as:
	# btrfs-convert -r -d <dev>

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-convert.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 952e3e6..2ea6a09 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2699,6 +2699,7 @@ int main(int argc, char *argv[])
 	int noxattr = 0;
 	int datacsum = 1;
 	int rollback = 0;
+	int usage_error = 0;
 	char *file;
 	while(1) {
 		int c = getopt(argc, argv, "dinr");
@@ -2729,6 +2730,18 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	if (rollback) {
+		if (!datacsum || noxattr || !packing) {
+			fprintf(stderr, "Usage error: -d, -i, -n options do not apply to rollback\n");
+			usage_error++;
+		}
+	}
+
+	if (usage_error) {
+		print_usage();
+		return 1;
+	}
+
 	file = argv[optind];
 	ret = check_mounted(file);
 	if (ret < 0) {
-- 
1.8.1.4

