Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30113 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbbKBIec (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Nov 2015 03:34:32 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tA28XiQ7011896
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Nov 2015 16:33:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: show-super: Add option to print superblock at given bytenr
Date: Mon,  2 Nov 2015 16:34:19 +0800
Message-Id: <1446453259-31917-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add '-s <sb_bytenr>' option to show superblock at given bytenr.

This is very useful to debug non-standard btrfs, like debuging the
1st stage btrfs of btrfs-convert.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-show-super.asciidoc | 5 +++++
 btrfs-show-super.c                      | 7 ++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-show-super.asciidoc b/Documentation/btrfs-show-super.asciidoc
index 1646be3..3480a3d 100644
--- a/Documentation/btrfs-show-super.asciidoc
+++ b/Documentation/btrfs-show-super.asciidoc
@@ -40,6 +40,11 @@ If several '-i <super_mirror>' are given, only the last one is valid.
 Attempt to print the superblock even if no superblock magic is found.  May end
 badly.
 
+-s <super_bytenr>::
+Specifiy the superblock bytenr.
++
+Used for debug purpose. Disable '-f' option.
+
 EXIT STATUS
 -----------
 *btrfs-show-super* will return 0 if no error happened.
diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index 27414c8..7b499e4 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -48,6 +48,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-a : print information of all superblocks\n");
 	fprintf(stderr, "\t-i <super_mirror> : specify which mirror to print out\n");
 	fprintf(stderr, "\t-F : attempt to dump superblocks with bad magic\n");
+	fprintf(stderr, "\t-s <bytenr> : specify the superblock bytenr\n");
 	fprintf(stderr, "%s\n", PACKAGE_STRING);
 }
 
@@ -63,7 +64,7 @@ int main(int argc, char **argv)
 	u64 arg;
 	u64 sb_bytenr = btrfs_sb_offset(0);
 
-	while ((opt = getopt(argc, argv, "fFai:")) != -1) {
+	while ((opt = getopt(argc, argv, "fFai:s:")) != -1) {
 		switch (opt) {
 		case 'i':
 			arg = arg_strtou64(optarg);
@@ -86,6 +87,10 @@ int main(int argc, char **argv)
 		case 'F':
 			force = 1;
 			break;
+		case 's':
+			sb_bytenr = arg_strtou64(optarg);
+			all = 0;
+			break;
 		default:
 			print_usage();
 			exit(1);
-- 
2.6.2

