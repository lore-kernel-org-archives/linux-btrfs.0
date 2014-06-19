Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48959 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756959AbaFSBvX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 21:51:23 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J1pL6Y020945
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 09:51:21 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 4/4] btrfs-progs: update manpage for btrfs-image with -m option added
Date: Thu, 19 Jun 2014 09:46:03 +0800
Message-ID: <1403142363-29482-4-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1403142363-29482-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1403142363-29482-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs-image support multiple devices with -m specified.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-image.txt | 3 +++
 btrfs-image.c                 | 1 +
 2 files changed, 4 insertions(+)

diff --git a/Documentation/btrfs-image.txt b/Documentation/btrfs-image.txt
index 7ee820c..155194a 100644
--- a/Documentation/btrfs-image.txt
+++ b/Documentation/btrfs-image.txt
@@ -48,6 +48,9 @@ Walk all the trees manually and copy any blocks that are referenced. Use this
 option if your extent tree is corrupted to make sure that all of the metadata is
 captured.
 
+-m::
+Restore for multiple devices, more than 1 device should be provided.
+
 EXIT STATUS
 -----------
 *btrfs-image* will return 0 if no error happened.
diff --git a/btrfs-image.c b/btrfs-image.c
index b235b87..a87dcb7 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2446,6 +2446,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-o      \tdon't mess with the chunk tree when restoring\n");
 	fprintf(stderr, "\t-s      \tsanitize file names, use once to just use garbage, use twice if you want crc collisions\n");
 	fprintf(stderr, "\t-w      \twalk all trees instead of using extent tree, do this if your extent tree is broken\n");
+	fprintf(stderr, "\t-m	   \trestore for multiple devices\n");
 	exit(1);
 }
 
-- 
1.8.1.4

