Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E452AC04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B62032084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:28:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B62032084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbeLEM2y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:28:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:48444 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727525AbeLEM2y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 07:28:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CA666ADA9
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 12:28:52 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 01/10] btrfs: create a mount option for dax
Date:   Wed,  5 Dec 2018 06:28:26 -0600
Message-Id: <20181205122835.19290-2-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181205122835.19290-1-rgoldwyn@suse.de>
References: <20181205122835.19290-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Also, set the inode->i_flags to S_DAX

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ctree.h |  1 +
 fs/btrfs/ioctl.c |  5 ++++-
 fs/btrfs/super.c | 15 +++++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 68f322f600a0..5cc470fa6a40 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1353,6 +1353,7 @@ static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_fs_info *info)
 #define BTRFS_MOUNT_FREE_SPACE_TREE	(1 << 26)
 #define BTRFS_MOUNT_NOLOGREPLAY		(1 << 27)
 #define BTRFS_MOUNT_REF_VERIFY		(1 << 28)
+#define BTRFS_MOUNT_DAX			(1 << 29)
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
 #define BTRFS_DEFAULT_MAX_INLINE	(2048)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 802a628e9f7d..e9146c157816 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -149,8 +149,11 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
 	if (binode->flags & BTRFS_INODE_DIRSYNC)
 		new_fl |= S_DIRSYNC;
 
+	if ((btrfs_test_opt(btrfs_sb(inode->i_sb), DAX)) && S_ISREG(inode->i_mode))
+		new_fl |= S_DAX;
+
 	set_mask_bits(&inode->i_flags,
-		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC,
+		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC | S_DAX,
 		      new_fl);
 }
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 645fc81e2a94..035263b61cf5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -326,6 +326,7 @@ enum {
 	Opt_treelog, Opt_notreelog,
 	Opt_usebackuproot,
 	Opt_user_subvol_rm_allowed,
+	Opt_dax,
 
 	/* Deprecated options */
 	Opt_alloc_start,
@@ -393,6 +394,7 @@ static const match_table_t tokens = {
 	{Opt_notreelog, "notreelog"},
 	{Opt_usebackuproot, "usebackuproot"},
 	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
+	{Opt_dax, "dax"},
 
 	/* Deprecated options */
 	{Opt_alloc_start, "alloc_start=%s"},
@@ -739,6 +741,17 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		case Opt_user_subvol_rm_allowed:
 			btrfs_set_opt(info->mount_opt, USER_SUBVOL_RM_ALLOWED);
 			break;
+#ifdef CONFIG_FS_DAX
+		case Opt_dax:
+			if (btrfs_super_num_devices(info->super_copy) > 1) {
+				btrfs_info(info,
+					   "dax not supported for multi-device btrfs partition\n");
+				ret = -EOPNOTSUPP;
+				goto out;
+			}
+			btrfs_set_opt(info->mount_opt, DAX);
+			break;
+#endif
 		case Opt_enospc_debug:
 			btrfs_set_opt(info->mount_opt, ENOSPC_DEBUG);
 			break;
@@ -1329,6 +1342,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",clear_cache");
 	if (btrfs_test_opt(info, USER_SUBVOL_RM_ALLOWED))
 		seq_puts(seq, ",user_subvol_rm_allowed");
+	if (btrfs_test_opt(info, DAX))
+		seq_puts(seq, ",dax");
 	if (btrfs_test_opt(info, ENOSPC_DEBUG))
 		seq_puts(seq, ",enospc_debug");
 	if (btrfs_test_opt(info, AUTO_DEFRAG))
-- 
2.16.4

