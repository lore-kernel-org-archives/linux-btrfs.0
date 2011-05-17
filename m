From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: fix crash when no drive supports DISCARD
Date: Tue, 17 May 2011 18:00:31 +0200
Message-ID: <1305648031-26379-1-git-send-email-dsterba@suse.cz>
References: <20110517152743.GU12709@twin.jikos.cz>
Cc: linux-btrfs@vger.kernel.org, lidongyang@novell.com,
	David Sterba <dsterba@suse.cz>, stable@kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110517152743.GU12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

xfstests/013 crashes when the test partition is mounted with -o discard:

walk_up_log_tree
  btrfs_free_reserved_extent
    btrfs_discard_extent
      return -EOPNOTSUPP
    BUG_ON ret

btrfs_discard_extent() should be fine when drive does not support the
DISCARD operation and filter the EOPNOTSUPP retcode, but currently it
does this only when some bytes were succesfully discarded.

Signed-off-by: David Sterba <dsterba@suse.cz>
CC: stable@kernel.org
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9ee6bd5..feab2ab 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1790,7 +1790,7 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 		}
 		kfree(multi);
 	}
-	if (discarded_bytes && ret == -EOPNOTSUPP)
+	if (ret == -EOPNOTSUPP)
 		ret = 0;
 
 	if (actual_bytes)
-- 
1.7.3.4

