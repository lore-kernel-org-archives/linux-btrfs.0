Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:40945 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab2K3Dkc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Nov 2012 22:40:32 -0500
Received: by mail-oa0-f74.google.com with SMTP id k14so10657oag.1
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2012 19:40:32 -0800 (PST)
From: Filipe Brandenburger <filbranden@google.com>
To: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH 1/2] Btrfs: fix permissions of empty files not affected by umask
Date: Thu, 29 Nov 2012 19:40:08 -0800
Message-Id: <1354246809-32339-2-git-send-email-filbranden@google.com>
In-Reply-To: <1354246809-32339-1-git-send-email-filbranden@google.com>
References: <1354246809-32339-1-git-send-email-filbranden@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a new file is created with btrfs_create(), the inode will initially be
created with permissions 0666 and later on in btrfs_init_acl() it will be
adapted to mask out the umask bits. The problem is that this change won't make
it into the btrfs_inode unless there's another change to the inode (e.g. writing
content changing the size or touching the file changing the mtime.)

This fix adds a call to btrfs_update_inode() to btrfs_create() to make sure that
the change will not get lost if the in-memory inode is flushed before other
changes are made to the file.

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
---
 fs/btrfs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95542a1..caf9d76 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4996,6 +4996,12 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 	}
 
+	err = btrfs_update_inode(trans, root, inode);
+	if (err) {
+		drop_inode = 1;
+		goto out_unlock;
+	}
+
 	/*
 	* If the active LSM wants to access the inode during
 	* d_instantiate it needs these. Smack checks to see
-- 
1.7.11.7

