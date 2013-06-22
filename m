Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36214 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3FVFdG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Jun 2013 01:33:06 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: [PATCH 4/5] Btrfs-progs: cleanup btrfs-image usage
Date: Sat, 22 Jun 2013 13:32:44 +0800
Message-Id: <1371879165-4993-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1371879165-4993-1-git-send-email-bo.li.liu@oracle.com>
References: <1371879165-4993-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A '\n' is missing.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 btrfs-image.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 30c1a9a..ebd283e 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2272,7 +2272,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-c value\tcompression level (0 ~ 9)\n");
 	fprintf(stderr, "\t-t value\tnumber of threads (1 ~ 32)\n");
 	fprintf(stderr, "\t-o      \tdon't mess with the chunk tree when restoring\n");
-	fprintf(stderr, "\t-s      \tsanitize file names, use once to just use garbage, use twice if you want crc collisions");
+	fprintf(stderr, "\t-s      \tsanitize file names, use once to just use garbage, use twice if you want crc collisions\n");
 	fprintf(stderr, "\t-w      \twalk all trees instead of using extent tree, do this if your extent tree is broken\n");
 	exit(1);
 }
-- 
1.7.7

