Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031478AbbDXRL7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 13:11:59 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 43F66ADAC
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 17:11:58 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/3] btrfs: add 'cold' compiler annotations to all error handling functions
Date: Fri, 24 Apr 2015 19:11:57 +0200
Message-Id: <45f5186a247fa68551ae25b18fdf49fdee0c3576.1429894863.git.dsterba@suse.cz>
In-Reply-To: <cover.1429894863.git.dsterba@suse.cz>
References: <cover.1429894863.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The annotated functios will be placed into .text.unlikely section. The
annotation also hints compiler to move the code out of the hot paths,
and may implicitly mark if-statement leading to that block as unlikely.

This is a heuristic, the impact on the generated code is not
significant.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h | 4 ++++
 fs/btrfs/super.c | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b0f9ba4b47c8..3a303451f010 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4011,6 +4011,7 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 
 #ifdef CONFIG_BTRFS_ASSERT
 
+__cold
 static inline void assfail(char *expr, char *file, int line)
 {
 	pr_err("BTRFS: assertion failed: %s, file: %s, line: %d",
@@ -4026,10 +4027,12 @@ static inline void assfail(char *expr, char *file, int line)
 
 #define btrfs_assert()
 __printf(5, 6)
+__cold
 void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		     unsigned int line, int errno, const char *fmt, ...);
 
 
+__cold
 void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, const char *function,
 			       unsigned int line, int errno);
@@ -4099,6 +4102,7 @@ do {								\
 } while (0)
 
 __printf(5, 6)
+__cold
 void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 		   unsigned int line, int errno, const char *fmt, ...);
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3c6033768ad3..51a36bf80b2e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -135,6 +135,7 @@ static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
  * __btrfs_std_error decodes expected errors from the caller and
  * invokes the approciate error response.
  */
+__cold
 void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		       unsigned int line, int errno, const char *fmt, ...)
 {
@@ -247,6 +248,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
  * We'll complete the cleanup in btrfs_end_transaction and
  * btrfs_commit_transaction.
  */
+__cold
 void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, const char *function,
 			       unsigned int line, int errno)
@@ -273,6 +275,7 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
  * __btrfs_panic decodes unexpected, fatal errors from the caller,
  * issues an alert, and either panics or BUGs, depending on mount options.
  */
+__cold
 void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 		   unsigned int line, int errno, const char *fmt, ...)
 {
-- 
2.1.3

