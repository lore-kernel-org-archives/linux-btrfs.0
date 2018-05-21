Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:41982 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751021AbeEUOpw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 10:45:52 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Mon, 21 May 2018 16:45:14 +0200
Message-Id: <20180521144515.16501-1-kilobyte@angband.pl>
In-Reply-To: <20180521144254.4zdxt6jtxoeca26o@angband.pl>
References: <20180521144254.4zdxt6jtxoeca26o@angband.pl>
Subject: [PATCH 1/2] btrfs: allow defrag on a file opened ro that has rw permissions
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Requiring a rw descriptor conflicts both ways with exec, returning ETXTBSY
whenever you try to defrag a program that's currently being run, or
causing intermittent exec failures on a live system being defragged.

As defrag doesn't change the file's contents in any way, there's no reason
to consider it a rw operation.  Thus, let's check only whether the file
could have been opened rw.  Such access control is still needed as
currently defrag can use extra disk space, and might trigger bugs.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 fs/btrfs/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 632e26d6f7ce..b75db9d72106 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2561,7 +2561,8 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 		ret = btrfs_defrag_root(root);
 		break;
 	case S_IFREG:
-		if (!(file->f_mode & FMODE_WRITE)) {
+		if (!capable(CAP_SYS_ADMIN) &&
+		    inode_permission(inode, MAY_WRITE)) {
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.17.0

