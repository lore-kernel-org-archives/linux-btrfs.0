Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30110 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751411AbaEUIJN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 04:09:13 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4L88iaO015272
	for <linux-btrfs@vger.kernel.org>; Wed, 21 May 2014 16:08:44 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: clarify manpage for btrfstune seeding option
Date: Wed, 21 May 2014 16:03:57 +0800
Message-ID: <1400659437-13231-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfstune -S option accepts a positive value to enable seeding,
and a zero to disable seeding, negtive is not allowed.

Add "positive, zero, negative" sentences to btrfstune manpage.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 Documentation/btrfstune.txt | 5 +++--
 btrfstune.c                 | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/btrfstune.txt b/Documentation/btrfstune.txt
index bf4bfce..89d5996 100644
--- a/Documentation/btrfstune.txt
+++ b/Documentation/btrfstune.txt
@@ -17,8 +17,9 @@ enable/disable some extended features for btrfs.
 OPTIONS
 -------
 -S <value>::
-Updates the seeding value, it forces a fs readonly so that you can use it to
-build other filesystems.
+Updates the seeding value.
+A positive value will enable seeding, zero will disable seeding, negtive is not allowed.
+Enable seeding forces a fs readonly so that you can use it to build other filesystems.
 -r::
 Enable extended inode refs.
 -x::
diff --git a/btrfstune.c b/btrfstune.c
index 2c26fe9..3f2f0cd 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -100,9 +100,9 @@ static int enable_skinny_metadata(struct btrfs_root *root)
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfstune [options] device\n");
-	fprintf(stderr, "\t-S value\tenable/disable seeding\n");
+	fprintf(stderr, "\t-S value\tpositive value will enable seeding, zero to disable, negative is not allowed\n");
 	fprintf(stderr, "\t-r \t\tenable extended inode refs\n");
-	fprintf(stderr, "\t-x enable skinny metadata extent refs\n");
+	fprintf(stderr, "\t-x \t\tenable skinny metadata extent refs\n");
 }
 
 int main(int argc, char *argv[])
-- 
1.8.1.4

