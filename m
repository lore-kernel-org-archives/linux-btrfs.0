Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63427 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2FVSOO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 14:14:14 -0400
Received: by weyu7 with SMTP id u7so1390120wey.19
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 11:14:13 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: do not ignore errors from btrfs_cleanup_fs_roots() when mounting
Date: Fri, 22 Jun 2012 21:14:13 +0300
Message-Id: <1340388853-20897-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There used to be a BUG_ON(ret) there before EH patch (79787eaa) went in.
Bail out with EINVAL.

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/disk-io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f06db81..77872da 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2461,8 +2461,8 @@ retry_root_backup:
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		ret = btrfs_cleanup_fs_roots(fs_info);
-		if (ret) {
-			}
+		if (ret)
+			goto fail_trans_kthread;
 
 		ret = btrfs_recover_relocation(tree_root);
 		if (ret < 0) {
-- 
1.7.9.1

