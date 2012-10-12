Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56496 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757629Ab2JLDZ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 23:25:29 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id C492F3EE0BC
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:25:24 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id AD8B445DEB6
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:25:24 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 93FE445DEB2
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:25:24 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 859621DB8040
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:25:24 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 34A2C1DB803C
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:25:24 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 110F89F7986
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:25:24 +0900 (JST)
Received: from [127.0.0.1] (unknown [10.124.101.110])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id B76A59F6C65
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:25:23 +0900 (JST)
Message-ID: <50778D98.50804@jp.fujitsu.com>
Date: Fri, 12 Oct 2012 12:25:12 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/4] btrfs: support default mount options
References: <50778C1D.4060807@jp.fujitsu.com>
In-Reply-To: <50778C1D.4060807@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make space to save default mount options in super block.
Parse saved default mount options first and then parse mount options given
when the file system is mounted.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 fs/btrfs/ctree.h |    7 ++++++-
 fs/btrfs/super.c |   16 ++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0d195b5..eea6bd0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -461,8 +461,11 @@ struct btrfs_super_block {
 
 	__le64 cache_generation;
 
+	/* default mount options */
+	__le64 default_mount_opt;
+
 	/* future expansion */
-	__le64 reserved[31];
+	__le64 reserved[30];
 	u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
 	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];
 } __attribute__ ((__packed__));
@@ -2581,6 +2584,8 @@ BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
 			 csum_type, 16);
 BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct btrfs_super_block,
 			 cache_generation, 64);
+BTRFS_SETGET_STACK_FUNCS(super_default_mount_opt, struct btrfs_super_block,
+			 default_mount_opt, 64);
 
 static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
 {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d51aaee..1cadf0e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -567,13 +567,25 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	struct btrfs_fs_info *info = root->fs_info;
 	substring_t args[MAX_OPT_ARGS];
 	char *p, *orig = NULL;
-	u64 cache_gen;
+	u64 cache_gen, default_opt;
 	int ret = 0;
 
-	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
+	cache_gen = btrfs_super_cache_generation(info->super_copy);
 	if (cache_gen)
 		btrfs_set_opt(info->mount_opt, SPACE_CACHE);
 
+	default_opt = btrfs_super_default_mount_opt(info->super_copy);
+	if (default_opt) {
+		int token;
+		for (token = 0; token < Opt_err; token++) {
+			if (default_opt & (1ul << token)) {
+				ret = __btrfs_parse_options(info, token, args);
+				if (ret)
+					return ret;
+			}
+		}
+	}
+
 	if (!options)
 		goto out;
 
-- 
1.7.7.6


