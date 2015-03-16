Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934024AbbCPRKy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 13:10:54 -0400
From: Lokesh Mandvekar <lsm5@fedoraproject.org>
To: linux-btrfs@vger.kernel.org
Cc: Lokesh Mandvekar <lsm5@fedoraproject.org>
Subject: [PATCH] btrfs-progs: re-introduce BTRFS_BUILD_VERSION in version.h
Date: Mon, 16 Mar 2015 12:10:51 -0500
Message-Id: <1426525851-29763-1-git-send-email-lsm5@fedoraproject.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lokesh Mandvekar <lsm5@fedoraproject.org>
---
 version.h.in | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/version.h.in b/version.h.in
index 012d265..67dbbf7 100644
--- a/version.h.in
+++ b/version.h.in
@@ -8,4 +8,6 @@
 #define BTRFS_LIB_VERSION ( BTRFS_LIB_MAJOR * 10000 + \
                             BTRFS_LIB_MINOR * 100 + \
                             BTRFS_LIB_PATCHLEVEL )
+
+#define BTRFS_BUILD_VERSION "Btrfs @PACKAGE_VERSION@"
 #endif
-- 
2.3.2

