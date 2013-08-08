Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42174 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab3HHCdY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Aug 2013 22:33:24 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] Btrfs-progs: add manpage of btrfs-image -m option
Date: Thu,  8 Aug 2013 10:33:09 +0800
Message-Id: <1375929189-1920-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a lack of manpage of btrfs-image '-m' option.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 btrfs-image.c        |    1 +
 man/btrfs-image.8.in |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 82aa4f3..862f081 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2422,6 +2422,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-o      \tdon't mess with the chunk tree when restoring\n");
 	fprintf(stderr, "\t-s      \tsanitize file names, use once to just use garbage, use twice if you want crc collisions\n");
 	fprintf(stderr, "\t-w      \twalk all trees instead of using extent tree, do this if your extent tree is broken\n");
+	fprintf(stderr, "\t-m      \trestore metadump image onto multiple disks\n");
 	exit(1);
 }
 
diff --git a/man/btrfs-image.8.in b/man/btrfs-image.8.in
index d5ba594..d0fdfc7 100644
--- a/man/btrfs-image.8.in
+++ b/man/btrfs-image.8.in
@@ -42,6 +42,10 @@ problems with your file system tree and need to have it mostly working.
 Walk all the trees manually and copy any blocks that are referenced. Use this
 option if your extent tree is corrupted to make sure that all of the metadata is
 captured.
+.TP
+\fB\-m\fP
+restore metadump image onto multiple disks. Use this option if your metadump
+image is created on a multiple disk made btrfs filesystem.
 .SH AVAILABILITY
 .B btrfs-image
 is part of btrfs-progs. Btrfs is currently under heavy development,
-- 
1.7.7

