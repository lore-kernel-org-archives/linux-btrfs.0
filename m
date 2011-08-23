From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 06/21] Btrfs: implement online profile changing
Date: Tue, 23 Aug 2011 23:01:47 +0300
Message-ID: <1314129722-31601-7-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Profile changing is done by initializing target field in respective
btrfs_restripe_args structs and launching a balance.  Reducing code in
this mode will pick restriper's target profile if it's available instead
of doing a blind reduce.  If target profile is not yet available go back
to plain reducing.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/extent-tree.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a04f99b..05e55d1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2968,6 +2968,34 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	u64 num_devices = root->fs_info->fs_devices->rw_devices +
 		root->fs_info->fs_devices->missing_devices;
 
+	/* pick restriper's target profile if it's available */
+	spin_lock(&root->fs_info->restripe_lock);
+	if (root->fs_info->restripe_ctl) {
+		struct restripe_control *rctl = root->fs_info->restripe_ctl;
+		u64 t = 0;
+
+		if ((flags & BTRFS_BLOCK_GROUP_DATA) &&
+		    (rctl->data.flags & BTRFS_RESTRIPE_ARGS_CONVERT) &&
+		    (flags & rctl->data.target)) {
+			t = BTRFS_BLOCK_GROUP_DATA | rctl->data.target;
+		} else if ((flags & BTRFS_BLOCK_GROUP_SYSTEM) &&
+			   (rctl->sys.flags & BTRFS_RESTRIPE_ARGS_CONVERT) &&
+			   (flags & rctl->sys.target)) {
+			t = BTRFS_BLOCK_GROUP_SYSTEM | rctl->sys.target;
+		} else if ((flags & BTRFS_BLOCK_GROUP_METADATA) &&
+			   (rctl->meta.flags & BTRFS_RESTRIPE_ARGS_CONVERT) &&
+			   (flags & rctl->meta.target)) {
+			t = BTRFS_BLOCK_GROUP_METADATA | rctl->meta.target;
+		}
+
+		if (t) {
+			spin_unlock(&root->fs_info->restripe_lock);
+			t &= ~BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+			return t;
+		}
+	}
+	spin_unlock(&root->fs_info->restripe_lock);
+
 	if (num_devices == 1)
 		flags &= ~(BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID0);
 	if (num_devices < 4)
@@ -2987,8 +3015,9 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	if ((flags & BTRFS_BLOCK_GROUP_RAID0) &&
 	    ((flags & BTRFS_BLOCK_GROUP_RAID1) |
 	     (flags & BTRFS_BLOCK_GROUP_RAID10) |
-	     (flags & BTRFS_BLOCK_GROUP_DUP)))
+	     (flags & BTRFS_BLOCK_GROUP_DUP))) {
 		flags &= ~BTRFS_BLOCK_GROUP_RAID0;
+	}
 
 	/* in-memory -> on-disk */
 	flags &= ~BTRFS_AVAIL_ALLOC_BIT_SINGLE;
@@ -6519,6 +6548,29 @@ static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 	u64 stripped = BTRFS_BLOCK_GROUP_RAID0 |
 		BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10;
 
+	if (root->fs_info->restripe_ctl) {
+		struct restripe_control *rctl = root->fs_info->restripe_ctl;
+		u64 t = 0;
+
+		/* pick restriper's target profile and return */
+		if (flags & BTRFS_BLOCK_GROUP_DATA &&
+		    rctl->data.flags & BTRFS_RESTRIPE_ARGS_CONVERT) {
+			t = BTRFS_BLOCK_GROUP_DATA | rctl->data.target;
+		} else if (flags & BTRFS_BLOCK_GROUP_SYSTEM &&
+			   rctl->sys.flags & BTRFS_RESTRIPE_ARGS_CONVERT) {
+			t = BTRFS_BLOCK_GROUP_SYSTEM | rctl->sys.target;
+		} else if (flags & BTRFS_BLOCK_GROUP_METADATA &&
+			   rctl->meta.flags & BTRFS_RESTRIPE_ARGS_CONVERT) {
+			t = BTRFS_BLOCK_GROUP_METADATA | rctl->meta.target;
+		}
+
+		if (t) {
+			/* in-memory -> on-disk */
+			t &= ~BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+			return t;
+		}
+	}
+
 	/*
 	 * we add in the count of missing devices because we want
 	 * to make sure that any RAID levels on a degraded FS
-- 
1.7.5.4

