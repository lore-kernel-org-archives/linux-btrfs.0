Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52245 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750907AbeC0HTr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:19:47 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C100EAFE8
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 07:19:45 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 10/10] btrfs-progs: Make __btrfs_fs_incompat return bool
Date: Tue, 27 Mar 2018 10:19:32 +0300
Message-Id: <1522135172-8276-11-git-send-email-nborisov@suse.com>
In-Reply-To: <1522135172-8276-1-git-send-email-nborisov@suse.com>
References: <1522135172-8276-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First this function does the '!!' trick to turn its value into a bool,
yet the return type is int. Second, the kernel counterpart also returns
bool.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index fa861ba0b4c3..1fafe7f90837 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2460,7 +2460,7 @@ static inline u32 btrfs_file_extent_inline_len(struct extent_buffer *eb,
 #define btrfs_fs_incompat(fs_info, opt) \
 	__btrfs_fs_incompat((fs_info), BTRFS_FEATURE_INCOMPAT_##opt)
 
-static inline int __btrfs_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag)
+static inline bool __btrfs_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag)
 {
 	struct btrfs_super_block *disk_super;
 	disk_super = fs_info->super_copy;
-- 
2.7.4

