Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:62093 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab2KFQis (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:48 -0500
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp3) (RZmta 30.22 OK)
	with ESMTP id p03dd3oA6AspSW for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:45 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/26] Btrfs: avoid risk of a deadlock in btrfs_handle_error
Date: Tue,  6 Nov 2012 17:38:30 +0100
Message-Id: <e99158ed12100847bc591bffa92c8af1a01e4efb.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

Remove the attempt to cancel a running scrub or device replace
operation in btrfs_handle_error() because it adds the risk of
a deadlock. The only penalty of not canceling the operation is
that some I/O remains active until the procedure completes.
This is basically the same thing that happens to other tasks
that are running in user mode context, they are not affected
or stopped in btrfs_handle_error(), these tasks just need to
handle write errors correctly.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/super.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8b7cf54..bdf1f5e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -116,7 +116,16 @@ static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
 	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
 		sb->s_flags |= MS_RDONLY;
 		printk(KERN_INFO "btrfs is forced readonly\n");
-		btrfs_scrub_cancel(fs_info);
+		/*
+		 * Note that a running device replace operation is not
+		 * canceled here although there is no way to update
+		 * the progress. It would add the risk of a deadlock,
+		 * therefore the canceling is ommited. The only penalty
+		 * is that some I/O remains active until the procedure
+		 * completes. The next time when the filesystem is
+		 * mounted writeable again, the device replace
+		 * operation continues.
+		 */
 //		WARN_ON(1);
 	}
 }
-- 
1.8.0

