Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37367 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab2KNHqc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 02:46:32 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so176011iea.19
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2012 23:46:32 -0800 (PST)
Message-ID: <50A34C4D.8060403@gmail.com>
Date: Wed, 14 Nov 2012 15:46:21 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: update usage description for debug-tree.c
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are more options than "-e" only.
Update the description for the usage.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 debug-tree.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/debug-tree.c b/debug-tree.c
index 94ffd8e..f6bd5d8 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -30,7 +30,15 @@

 static int print_usage(void)
 {
-	fprintf(stderr, "usage: debug-tree [ -e ] device\n");
+	fprintf(stderr, "usage: btrfs-debug-tree [ -e ] [ -d ] [ -r ] [ -R ]\n");
+	fprintf(stderr, "                        [-b block_num ] device\n");
+	fprintf(stderr, "\t-e : print detailed extents info\n");
+	fprintf(stderr, "\t-d : print info of btrfs device and root tree dirs"
+                    " only\n");
+	fprintf(stderr, "\t-r : print info of roots only\n");
+	fprintf(stderr, "\t-R : print info of roots and root backups\n");
+	fprintf(stderr, "\t-b block_num : print info of the specified block"
+                    " only\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
-- 
1.7.5.4
