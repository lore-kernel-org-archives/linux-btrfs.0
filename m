From: David Sterba <dsterba@suse.cz>
Subject: [PATCH -rc6] btrfs: xattr: fix attribute removal
Date: Tue,  6 Sep 2011 15:33:45 +0200
Message-ID: <1315316025-11138-1-git-send-email-dsterba@suse.cz>
Cc: chris.mason@oracle.com, David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

An attribute is not removed by 'setfattr -x attr file' and remains
visible in attr list. This makes xfstests/062 pass again.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/xattr.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index d733b9c..69565e5 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -116,6 +116,12 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 		if (ret)
 			goto out;
 		btrfs_release_path(path);
+
+		/*
+		 * remove the attribute
+		 */
+		if (!value)
+			goto out;
 	}
 
 again:
@@ -158,6 +164,9 @@ out:
 	return ret;
 }
 
+/*
+ * @value: "" makes the attribute to empty, NULL removes it
+ */
 int __btrfs_setxattr(struct btrfs_trans_handle *trans,
 		     struct inode *inode, const char *name,
 		     const void *value, size_t size, int flags)
-- 
1.7.6

