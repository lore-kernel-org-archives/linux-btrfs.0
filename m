From: Alex Elsayed <eternaleye@gmail.com>
Subject: [PATCH] [Doc] Fix incorrect case of btrfsctl argument to create a subvol
Date: Tue, 6 Oct 2009 00:59:58 +0000 (UTC)
Message-ID: <loom.20091006T025923-596@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

---
 Documentation/filesystems/btrfs.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt
b/Documentation/filesystems/btrfs.txt
index 64087c3..29ee7dd 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -73,7 +73,7 @@ mkfs.btrfs: create a filesystem
 btrfsctl: control program to create snapshots and subvolumes:
 
 	mount /dev/sda2 /mnt
-	btrfsctl -s new_subvol_name /mnt
+	btrfsctl -S new_subvol_name /mnt
 	btrfsctl -s snapshot_of_default /mnt/default
 	btrfsctl -s snapshot_of_new_subvol /mnt/new_subvol_name
 	btrfsctl -s snapshot_of_a_snapshot /mnt/snapshot_of_new_subvol
-- 
1.6.0.4


