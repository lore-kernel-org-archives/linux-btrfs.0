From: Jan Engelhardt <jengelh@medozas.de>
Subject: btrfs: fix missing last-entry in readdir(3)
Date: Wed, 9 Dec 2009 23:00:38 +0100 (CET)
Message-ID: <alpine.LSU.2.01.0912092259200.11799@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: cmason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

parent 49313cdac7b34c9f7ecbb1780cfc648b1c082cd7 (v2.6.32-1-g49313cd)
commit ff48c08e1c05c67e8348ab6f8a24de8034e0e34d
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Dec 9 22:57:36 2009 +0100

btrfs: fix missing last-entry in readdir(3)

When one does a 32-bit readdir(3), the last entry of a directory is
missing. This is however not due to passing a large value to filldir,
but it seems to have to do with glibc doing telldir or something
quirky. In any case, this patch fixes it in practice.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 fs/btrfs/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b3ad168..7bf9811 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3869,7 +3869,11 @@ skip:
 
 	/* Reached end of directory/root. Bump pos past the last item. */
 	if (key_type == BTRFS_DIR_INDEX_KEY)
-		filp->f_pos = INT_LIMIT(off_t);
+		/*
+		 * 32-bit glibc will use getdents64, but then strtol -
+		 * so the last number we can serve is this.
+		 */
+		filp->f_pos = 0x7fffffff;
 	else
 		filp->f_pos++;
 nopos:
-- 
# Created with git-export-patch

