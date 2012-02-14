From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: fix memory leak in load_free_space_cache()
Date: Tue, 14 Feb 2012 17:12:23 +0900
Message-ID: <201202140812.AA00042@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

load_free_space_cache() has forgotten to free path.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 5802b147..b30242f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -777,6 +777,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	spin_lock(&block_group->lock);
 	if (block_group->disk_cache_state != BTRFS_DC_WRITTEN) {
 		spin_unlock(&block_group->lock);
+		btrfs_free_path(path);
 		goto out;
 	}
 	spin_unlock(&block_group->lock);

