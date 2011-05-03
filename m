From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH 2/2] [RFC] Btrfs: Increase limit of relocated extent size
Date: Tue,  3 May 2011 14:28:15 -0500
Message-ID: <1304450895-15586-3-git-send-email-mitch.harder@sabayonlinux.org>
References: <1304450895-15586-1-git-send-email-mitch.harder@sabayonlinux.org>
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304450895-15586-1-git-send-email-mitch.harder@sabayonlinux.org>
List-ID: <linux-btrfs.vger.kernel.org>

The size of relocated compressed extents was limited to 128K.
This limit is put in place to ease the RAM required when spreading
compression across several CPUs, and to make sure the amount
of IO required to do a random read is reasonably small.

Increase this limit to 512K.
---
 fs/btrfs/relocation.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 58250e0..dd17a35 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -143,7 +143,7 @@ struct tree_block {
 	unsigned int key_ready:1;
 };
 
-#define MAX_EXTENTS 128
+#define MAX_EXTENTS 512
 
 struct file_extent_cluster {
 	u64 start;
-- 
1.7.3.4

