From: Tero Roponen <tero.roponen@gmail.com>
Subject: [PATCH] btrfs: make a definition of a flag more consistent
Date: Tue, 2 Mar 2010 17:04:45 +0200 (EET)
Message-ID: <alpine.LFD.2.00.1003021703040.9396@terrop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: chris.mason@oracle.com, josef@redhat.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Commit 015449c282b87f6f88c4ad15a2d4255a7e12ed66 on subvol branch
("Btrfs: add ioctl and incompat flag to set the default mount subvol")
added a definition of a new flag. This patch makes it consistent with
the way other flags are defined.

Signed-off-by: Tero Roponen <tero.roponen@gmail.com>

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1166b15..083e10c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -373,7 +373,7 @@ struct btrfs_super_block {
  * ones specified below then we will fail to mount
  */
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
-#define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(2ULL << 0)
+#define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
