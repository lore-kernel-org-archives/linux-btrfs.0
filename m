Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C76FC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 05:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA1D620850
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 05:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfDAFz6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 01:55:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:54324 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725860AbfDAFz6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 01:55:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 907C1ACBF;
        Mon,  1 Apr 2019 05:55:57 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Thorsten Hirsch <t.hirsch@web.de>
Subject: [PATCH v2 1/7] btrfs-progs: check/lowmem: Add inode mode check
Date:   Mon,  1 Apr 2019 13:55:45 +0800
Message-Id: <20190401055551.6837-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190401055551.6837-1-wqu@suse.com>
References: <20190401055551.6837-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is one report about invalid free space cache inode mode.
Normally free space cache inode should have mode 100600 (regular file,
no uid/gid/sticky bit, rw------ bit).

But in that report, we have free space cache inode mode as 0.

So at least btrfs check should report invalid inode mode.

This patch will at least make btrfs check lowmem mode to detect this
problem.

Please note that, this check only applies to inodes in fs/subvol trees.
It doesn't apply to free space cache inodes.

Reported-by: Thorsten Hirsch <t.hirsch@web.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-common.h | 24 ++++++++++++++++++++++++
 check/mode-lowmem.c |  5 +++++
 check/mode-lowmem.h |  1 +
 3 files changed, 30 insertions(+)

diff --git a/check/mode-common.h b/check/mode-common.h
index 1fb3cda7d89d..4c88365abbcc 100644
--- a/check/mode-common.h
+++ b/check/mode-common.h
@@ -126,4 +126,28 @@ int delete_corrupted_dir_item(struct btrfs_trans_handle *trans,
 			      struct btrfs_key *di_key, char *namebuf,
 			      u32 namelen);
 
+/*
+ * Check if the inode mode @imode is valid
+ *
+ * This check focuses on S_FTMT bits and unused bits.
+ * Sticky/setuid/setgid and regular owner/group/other bits won't cause
+ * any problem.
+ */
+static inline bool is_valid_imode(u32 imode)
+{
+	if (imode & ~(S_IFMT | 07777))
+		return false;
+
+	/*
+	 * S_IFMT is not bitmap, nor pure numbering sequence. Need per valid
+	 * number check.
+	 */
+	imode &= S_IFMT;
+	if (imode != S_IFDIR && imode != S_IFCHR && imode != S_IFBLK &&
+	    imode != S_IFREG && imode != S_IFIFO && imode != S_IFLNK &&
+	    imode != S_IFSOCK)
+		return false;
+	return true;
+}
+
 #endif
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index fc6228a05a1b..1553a4a5d2c1 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2452,6 +2452,11 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path)
 	nlink = btrfs_inode_nlink(node, ii);
 	nodatasum = btrfs_inode_flags(node, ii) & BTRFS_INODE_NODATASUM;
 
+	if (!is_valid_imode(mode)) {
+		error("invalid imode mode bits: 0%o", mode);
+		err |= INODE_MODE_ERROR;
+	}
+
 	if (S_ISLNK(mode) &&
 	    flags & (BTRFS_INODE_IMMUTABLE | BTRFS_INODE_APPEND)) {
 		err |= INODE_FLAGS_ERROR;
diff --git a/check/mode-lowmem.h b/check/mode-lowmem.h
index 46b9b191ce24..e0ab30b770d5 100644
--- a/check/mode-lowmem.h
+++ b/check/mode-lowmem.h
@@ -46,6 +46,7 @@
 #define FATAL_ERROR             (1<<22) /* Fatal bit for errno */
 #define INODE_FLAGS_ERROR	(1<<23) /* Invalid inode flags */
 #define DIR_ITEM_HASH_MISMATCH	(1<<24) /* Dir item hash mismatch */
+#define INODE_MODE_ERROR	(1<<25) /* Bad inode mode */
 
 /*
  * Error bit for low memory mode check.
-- 
2.21.0

