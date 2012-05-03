From: Alexander Block <ablock84@googlemail.com>
Subject: [PATCH 1/1] btrfs: Fix mismatching struct members in ioctl.h
Date: Thu,  3 May 2012 15:49:55 +0200
Message-ID: <1336052995-22517-1-git-send-email-ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org, mail@jan-o-sch.net,
	Alexander Block <ablock84@googlemail.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix the size members of btrfs_ioctl_ino_path_args and
btrfs_ioctl_logical_ino_args. The user space btrfs-progs utilities used
__u64 and the kernel headers used __u32 before.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 fs/btrfs/ioctl.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 4f69028..086e6bd 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -252,7 +252,7 @@ struct btrfs_data_container {
 
 struct btrfs_ioctl_ino_path_args {
 	__u64				inum;		/* in */
-	__u32				size;		/* in */
+	__u64				size;		/* in */
 	__u64				reserved[4];
 	/* struct btrfs_data_container	*fspath;	   out */
 	__u64				fspath;		/* out */
@@ -260,7 +260,7 @@ struct btrfs_ioctl_ino_path_args {
 
 struct btrfs_ioctl_logical_ino_args {
 	__u64				logical;	/* in */
-	__u32				size;		/* in */
+	__u64				size;		/* in */
 	__u64				reserved[4];
 	/* struct btrfs_data_container	*inodes;	out   */
 	__u64				inodes;
-- 
1.7.3.4

