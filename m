Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52312 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab3HAFhG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 01:37:06 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r715avKW009257
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Aug 2013 13:37:00 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/10] btrfs-progs: Fix the return value of btrfs-map-logical
Date: Thu, 1 Aug 2013 13:35:33 +0800
Message-Id: <1375335334-32540-9-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

The ret variant in the main function is not changed so even problems
happen, return value is still 0.
The patch fixs the minor bug and return 1 if any problems happen.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-map-logical.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index e46d812..7dc71d3 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -119,7 +119,6 @@ int main(int ac, char **av)
 	int copy = 0;
 	u64 bytes = 0;
 	int out_fd = 0;
-	int err;
 
 	while(1) {
 		int c;
@@ -187,8 +186,9 @@ int main(int ac, char **av)
 			out_fd = open(output_file, O_RDWR | O_CREAT, 0600);
 			if (out_fd < 0)
 				goto close;
-			err = ftruncate(out_fd, 0);
-			if (err) {
+			ret = ftruncate(out_fd, 0);
+			if (ret) {
+				ret = 1;
 				close(out_fd);
 				goto close;
 			}
@@ -205,8 +205,9 @@ int main(int ac, char **av)
 	while (bytes > 0) {
 		eb = debug_read_block(root, logical, root->sectorsize, copy);
 		if (eb && output_file) {
-			err = write(out_fd, eb->data, eb->len);
-			if (err < 0 || err != eb->len) {
+			ret = write(out_fd, eb->data, eb->len);
+			if (ret < 0 || ret != eb->len) {
+				ret = 1;
 				fprintf(stderr, "output file write failed\n");
 				goto out_close_fd;
 			}
-- 
1.8.0.1

