From: Jan Kara <jack@suse.cz>
Subject: [PATCH] btrfs: Do not return more items that user asked from from search ioctl
Date: Fri, 20 Aug 2010 23:40:32 +0200
Message-ID: <1282340432-15564-1-git-send-email-jack@suse.cz>
Cc: linux-btrfs@vger.kernel.org, Jan Kara <jack@suse.cz>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While searching a tree we didn't properly check number of items we really
stored in user's buffer thus possibly exceeding number of items requested
by user. This was mostly harmless since actual buffer overflow is checked
correctly in a different place. Anyway, let's fix the check.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/btrfs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9254b3d..94e7ab5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -977,7 +977,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		}
 		found++;
 
-		if (*num_found >= sk->nr_items)
+		if (*num_found + found >= sk->nr_items)
 			break;
 	}
 advance_key:
-- 
1.6.4.2

