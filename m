From: Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH] fs/btrfs/locking.c: Removed some unneeded return statements
Date: Wed, 16 Nov 2011 23:31:54 -0200
Message-ID: <1321493514-2562-1-git-send-email-marcos.mage@gmail.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Marcos Paulo de Souza <marcos.mage@gmail.com>
To: chris.mason@oracle.com
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 fs/btrfs/locking.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index d77b67c..8abb870 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -48,7 +48,6 @@ void btrfs_set_lock_blocking_rw(struct extent_buffer *eb, int rw)
 		atomic_dec(&eb->spinning_readers);
 		read_unlock(&eb->lock);
 	}
-	return;
 }
 
 /*
@@ -71,7 +70,6 @@ void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
 		if (atomic_dec_and_test(&eb->blocking_readers))
 			wake_up(&eb->read_lock_wq);
 	}
-	return;
 }
 
 /*
-- 
1.7.4.4
