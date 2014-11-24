Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62316 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752212AbaKXH3t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 02:29:49 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAO7TSI1005907
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 15:29:29 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Doc: Add explain on 'source' and 'target' for btrfs-image.
Date: Mon, 24 Nov 2014 15:27:44 +0800
Message-ID: <1416814064-29543-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add explain on 'source' and 'target', which is somewhat confusing for
users who want to restore dumped image.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-image.txt | 5 +++++
 btrfs-image.c                 | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/btrfs-image.txt b/Documentation/btrfs-image.txt
index b7751f9..43c2e06 100644
--- a/Documentation/btrfs-image.txt
+++ b/Documentation/btrfs-image.txt
@@ -14,6 +14,11 @@ DESCRIPTION
 *btrfs-image* is used to create an image of a btrfs filesystem.
 All data will be zeroed, but metadata and the like is preserved.
 
+Without '-r' option, <source> is the device/normal file containing the btrfs,
+and <target> is the output image file, or standard output if <target> is '-'.
+With '-r' option, <source> is the dump image file and <target> is the
+device/normal file where the restored fs lies.
+
 Mainly used for debug purpose.
 
 OPTIONS
diff --git a/btrfs-image.c b/btrfs-image.c
index cb17f16..12f04b7 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2459,6 +2459,8 @@ out:
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfs-image [options] source target\n");
+	fprintf(stderr, "Without '-r' source is the btrfs fs and target is output image('-' for stdout)\n");
+	fprintf(stderr, "With '-r' source is the dumped image and target is the btrfs fs\n");
 	fprintf(stderr, "\t-r      \trestore metadump image\n");
 	fprintf(stderr, "\t-c value\tcompression level (0 ~ 9)\n");
 	fprintf(stderr, "\t-t value\tnumber of threads (1 ~ 32)\n");
-- 
2.1.3

