Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:59459 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab2JPH3t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Oct 2012 03:29:49 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so3027449dak.19
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 00:29:48 -0700 (PDT)
Message-ID: <507D0CCB.5070007@gmail.com>
Date: Tue, 16 Oct 2012 15:29:15 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: add -V description in print_usage
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mkfs supports the option -V/--version.
Add its description to print_usage().

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 mkfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 47f0c9c..2cc6051 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -349,6 +349,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -s --sectorsize min block allocation\n");
 	fprintf(stderr, "\t -r --rootdir the source directory\n");
 	fprintf(stderr, "\t -K --nodiscard do not perform whole device TRIM\n");
+	fprintf(stderr, "\t -V --version Print the mkfs.btrfs version and exit\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
-- 
1.7.5.4

