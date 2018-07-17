Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:48192 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729675AbeGQWnz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 18:43:55 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: David Sterba <dsterba@suse.cz>, Mark Fasheh <mfasheh@suse.de>,
        linux-btrfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Wed, 18 Jul 2018 00:08:59 +0200
Message-Id: <20180717220900.3588-1-kilobyte@angband.pl>
In-Reply-To: <20180717220357.hn7mvajicpy7hu3l@angband.pl>
References: <20180717220357.hn7mvajicpy7hu3l@angband.pl>
Subject: [PATCH resend 1/2] btrfs: allow defrag on a file opened ro that has rw permissions
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
index 43ecbe620dea..01c150b6ab62 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2941,7 +2941,8 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
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
2.18.0

