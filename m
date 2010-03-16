From: Sage Weil <sage@newdream.net>
Subject: [PATCH 2/2] Btrfs: use __u64 types in ioctl.h
Date: Mon, 15 Mar 2010 17:02:26 -0700
Message-ID: <1268697746-16300-2-git-send-email-sage@newdream.net>
References: <1268697746-16300-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1268697746-16300-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 32f86e4..4f7fe37 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -129,14 +129,14 @@ struct btrfs_ioctl_defrag_range_args {
 };
 
 struct btrfs_ioctl_space_info {
-	u64 flags;
-	u64 total_bytes;
-	u64 used_bytes;
+	__u64 flags;
+	__u64 total_bytes;
+	__u64 used_bytes;
 };
 
 struct btrfs_ioctl_space_args {
-	u64 space_slots;
-	u64 total_spaces;
+	__u64 space_slots;
+	__u64 total_spaces;
 	struct btrfs_ioctl_space_info spaces[0];
 };
 
-- 
1.6.6.1

