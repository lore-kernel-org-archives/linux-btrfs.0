Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41825 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752382AbdBMJfB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:35:01 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DD01BAD22
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:54 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 21/29] btrfs: remove unused parameter from create_snapshot
Date: Mon, 13 Feb 2017 10:34:26 +0100
Message-Id: <f4031b3ded1796ebf212a2b2c94e17344f625540.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The name parameters have never been used, as the name is passed via the
dentry.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e8c7c313c113..91188a2ac5a1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -656,7 +656,7 @@ static void btrfs_wait_for_no_snapshoting_writes(struct btrfs_root *root)
 }
 
 static int create_snapshot(struct btrfs_root *root, struct inode *dir,
-			   struct dentry *dentry, char *name, int namelen,
+			   struct dentry *dentry,
 			   u64 *async_transid, bool readonly,
 			   struct btrfs_qgroup_inherit *inherit)
 {
@@ -871,7 +871,7 @@ static noinline int btrfs_mksubvol(const struct path *parent,
 		goto out_up_read;
 
 	if (snap_src) {
-		error = create_snapshot(snap_src, dir, dentry, name, namelen,
+		error = create_snapshot(snap_src, dir, dentry,
 					async_transid, readonly, inherit);
 	} else {
 		error = create_subvol(dir, dentry, name, namelen,
-- 
2.10.1

