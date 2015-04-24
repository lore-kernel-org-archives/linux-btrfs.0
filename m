Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031470AbbDXRLz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 13:11:55 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id AF629ADAC
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 17:11:54 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/3] btrfs: report exact callsite where transaction abort occurs
Date: Fri, 24 Apr 2015 19:11:54 +0200
Message-Id: <37c1087edc978ccec5411761ae4bb200e38b07c1.1429894863.git.dsterba@suse.cz>
In-Reply-To: <cover.1429894863.git.dsterba@suse.cz>
References: <cover.1429894863.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

WARN is called from a single location and all bugreports say that's in
super.c __btrfs_abort_transaction. This is slightly confusing as we'd
rather want to know the exact callsite. Whereas this information is
printed in the syslog below the stacktrace, this requires further look
and we usually see only the headline from WARNING.

Moving the WARN into the macro has to inline some code and increases
code by a few kilobytes:

  text    data     bss     dec     hex filename
835481   20305   14120  869906   d4612 btrfs.ko.before
842883   20305   14120  877308   d62fc btrfs.ko.after

The delta is +7k (130+ calls), measured on 3.19 x86_64, distro config.
The increase is not small and could lead to worse icache use. The code
is on error/exit paths that can be recognized by compiler as cold and
moved out of the way so the impact is speculated to be low, if
measurable at all.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h | 12 +++++++++---
 fs/btrfs/super.c |  8 --------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f9c89cae39ee..b0f9ba4b47c8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4072,11 +4072,17 @@ static inline int __btrfs_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag)
  * Call btrfs_abort_transaction as early as possible when an error condition is
  * detected, that way the exact line number is reported.
  */
-
 #define btrfs_abort_transaction(trans, root, errno)		\
 do {								\
-	__btrfs_abort_transaction(trans, root, __func__,	\
-				  __LINE__, errno);		\
+	/* Report first abort since mount */			\
+	if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,	\
+			&((root)->fs_info->fs_state))) {	\
+		WARN(1, KERN_DEBUG				\
+		"BTRFS: Transaction aborted (error %d)\n",	\
+		(errno));					\
+	}							\
+	__btrfs_abort_transaction((trans), (root), __func__,	\
+				  __LINE__, (errno));		\
 } while (0)
 
 #define btrfs_std_error(fs_info, errno)				\
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 05fef198ff94..3c6033768ad3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -251,14 +251,6 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, const char *function,
 			       unsigned int line, int errno)
 {
-	/*
-	 * Report first abort since mount
-	 */
-	if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,
-				&root->fs_info->fs_state)) {
-		WARN(1, KERN_DEBUG "BTRFS: Transaction aborted (error %d)\n",
-				errno);
-	}
 	trans->aborted = errno;
 	/* Nothing used. The other threads that have joined this
 	 * transaction may be able to continue. */
-- 
2.1.3

