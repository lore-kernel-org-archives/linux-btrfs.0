From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: cache no acl on new inodes
Date: Mon, 23 Apr 2012 13:53:47 -0400
Message-ID: <1335203627-7741-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When running compilebench I noticed we were spending some time looking up
acls on new inodes, which shouldn't be happening since there were no acls.
This is because when we init acls on the inode after creating them we don't
cache the fact there are no acls if there aren't any.  Doing this adds a
little bit of a bump to my compilebench runs.  Thanks,
Btrfs: cache no acl on new inodes

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/acl.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 89b156d..761e2cd 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -227,7 +227,11 @@ int btrfs_init_acl(struct btrfs_trans_handle *trans,
 		if (ret > 0) {
 			/* we need an acl */
 			ret = btrfs_set_acl(trans, inode, acl, ACL_TYPE_ACCESS);
+		} else {
+			cache_no_acl(inode);
 		}
+	} else {
+		cache_no_acl(inode);
 	}
 failed:
 	posix_acl_release(acl);
-- 
1.7.7.6

