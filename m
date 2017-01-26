Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:33370 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752380AbdAZBHd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 20:07:33 -0500
Received: by mail-pf0-f170.google.com with SMTP id y143so61956211pfb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 17:07:33 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Murphy <lists@colorremedies.com>,
        Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 3/3] Btrfs: remove ->{get,set}_acl() from btrfs_dir_ro_inode_operations
Date: Wed, 25 Jan 2017 17:06:40 -0800
Message-Id: <14d5cbf62169b1ac773028fa3ce0da246b968134.1485392101.git.osandov@fb.com>
In-Reply-To: <c96f9f4d14c7a40913a39856ca8f065d37113372.1485311744.git.osandov@fb.com>
References: <c96f9f4d14c7a40913a39856ca8f065d37113372.1485311744.git.osandov@fb.com>
In-Reply-To: <cover.1485392101.git.osandov@fb.com>
References: <cover.1485392101.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Subvolume directory inodes can't have ACLs.

Cc: <stable@vger.kernel.org> # 4.9.x
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 924f3583a04d..1b21a63ed328 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10577,8 +10577,6 @@ static const struct inode_operations btrfs_dir_inode_operations = {
 static const struct inode_operations btrfs_dir_ro_inode_operations = {
 	.lookup		= btrfs_lookup,
 	.permission	= btrfs_permission,
-	.get_acl	= btrfs_get_acl,
-	.set_acl	= btrfs_set_acl,
 	.update_time	= btrfs_update_time,
 };
 
-- 
2.11.0

