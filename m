Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54150 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752558AbeDSHqo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 03:46:44 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B2299AE21
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 07:46:42 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/6] btrfs: Use list_empty instead of list_empty_careful
Date: Thu, 19 Apr 2018 10:46:37 +0300
Message-Id: <1524123999-4220-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1524123999-4220-1-git-send-email-nborisov@suse.com>
References: <1524123999-4220-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

list_empty_careful usually is a signal of something tricky going on. Its
usage in btrfs is actually not needed since both lists it's used on are
local to a function and cannot be modified concurrently. So switch to
plain list_empty. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7b1026a7ffab..423a6eb3165c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10086,7 +10086,7 @@ static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput,
 		btrfs_wait_and_free_delalloc_work(work);
 	}
 
-	if (!list_empty_careful(&splice)) {
+	if (!list_empty(&splice)) {
 		spin_lock(&root->delalloc_lock);
 		list_splice_tail(&splice, &root->delalloc_inodes);
 		spin_unlock(&root->delalloc_lock);
@@ -10148,7 +10148,7 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
 
 	ret = 0;
 out:
-	if (!list_empty_careful(&splice)) {
+	if (!list_empty(&splice)) {
 		spin_lock(&fs_info->delalloc_root_lock);
 		list_splice_tail(&splice, &fs_info->delalloc_roots);
 		spin_unlock(&fs_info->delalloc_root_lock);
-- 
2.7.4

