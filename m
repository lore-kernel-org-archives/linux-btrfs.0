From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/1] btrfs: add missing spin_unlock to a rare exit path
Date: Wed, 20 Apr 2011 14:34:15 +0200
Message-ID: <1303302855-23093-1-git-send-email-dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5e5d07c..25e4b8f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2825,6 +2825,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 
 	spin_lock(&delayed_refs->lock);
 	if (delayed_refs->num_entries == 0) {
+		spin_unlock(&delayed_refs->lock);
 		printk(KERN_INFO "delayed_refs has NO entry\n");
 		return ret;
 	}
-- 
1.7.4.1.176.g501cc

