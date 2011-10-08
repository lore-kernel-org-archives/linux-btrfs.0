From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs-progs: make btrfs df report profiles for mixed block groups
Date: Sun,  9 Oct 2011 00:09:19 +0300
Message-ID: <1318108159-26273-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.cz>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Profiles other than SINGLE for mixed chunks might sound a bit strange,
but there is nothing in the filesystem that prevents a crazy user from
doing it.  So make "btrfs fi df" report them properly.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 btrfs_cmds.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 32f6b25..0d7d4da 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -967,9 +967,9 @@ int do_df_filesystem(int nargs, char **argv)
 
 		if (flags & BTRFS_BLOCK_GROUP_DATA) {
 			if (flags & BTRFS_BLOCK_GROUP_METADATA) {
-				snprintf(description, 15, "%s",
+				snprintf(description, 14, "%s",
 					 "Data+Metadata");
-				written += 14;
+				written += 13;
 			} else {
 				snprintf(description, 5, "%s", "Data");
 				written += 4;
-- 
1.7.5.4

