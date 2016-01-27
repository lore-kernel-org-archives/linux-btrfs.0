Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:33894 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbcA0KMB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 05:12:01 -0500
Received: by mail-pf0-f169.google.com with SMTP id q63so2592049pfb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 02:12:00 -0800 (PST)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs: remove redundant error check
Date: Wed, 27 Jan 2016 19:11:53 +0900
Message-Id: <1453889513-9696-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While running btrfs_mksubvol(), d_really_is_positive() is called twice.
First in btrfs_mksubvol() and second inside btrfs_may_create().  So I
remove the first one.

Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 fs/btrfs/ioctl.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1568f57a3376..d2f29c70d865 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -844,10 +844,6 @@ static noinline int btrfs_mksubvol(struct path *parent,
 	if (IS_ERR(dentry))
 		goto out_unlock;
 
-	error = -EEXIST;
-	if (d_really_is_positive(dentry))
-		goto out_dput;
-
 	error = btrfs_may_create(dir, dentry);
 	if (error)
 		goto out_dput;
-- 
2.7.0

