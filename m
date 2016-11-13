Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:34625 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934841AbcKMTmT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Nov 2016 14:42:19 -0500
Received: by mail-pg0-f46.google.com with SMTP id x23so41510539pgx.1
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Nov 2016 11:42:19 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 1/6] btrfs-progs: add the FREE_SPACE_TREE_VALID compat_ro bit definition
Date: Sun, 13 Nov 2016 11:35:19 -0800
Message-Id: <74f83b8e9fbe48feff8fc0339bd7327f89f5cb6b.1479064970.git.osandov@fb.com>
In-Reply-To: <cover.1479064970.git.osandov@fb.com>
References: <cover.1479064970.git.osandov@fb.com>
In-Reply-To: <cover.1479064970.git.osandov@fb.com>
References: <cover.1479064970.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

This is just the definition; we don't support it yet.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 ctree.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/ctree.h b/ctree.h
index d47f0ae..d67b852 100644
--- a/ctree.h
+++ b/ctree.h
@@ -467,6 +467,14 @@ struct btrfs_super_block {
  * ones specified below then we will fail to mount
  */
 #define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE	(1ULL << 0)
+/*
+ * Older kernels on big-endian systems produced broken free space tree bitmaps,
+ * and btrfs-progs also used to corrupt the free space tree. If this bit is
+ * clear, then the free space tree cannot be trusted. btrfs-progs can also
+ * intentionally clear this bit to ask the kernel to rebuild the free space
+ * tree.
+ */
+#define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID	(1ULL << 1)
 
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
@@ -493,6 +501,11 @@ struct btrfs_super_block {
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 
+/*
+ * The FREE_SPACE_TREE and FREE_SPACE_TREE_VALID compat_ro bits must not be
+ * added here until read-write support for the free space tree is implemented in
+ * btrfs-progs.
+ */
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
 
 #define BTRFS_FEATURE_INCOMPAT_SUPP			\
-- 
2.10.2

