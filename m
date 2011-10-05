From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: rotate mirror selection
Date: Wed,  5 Oct 2011 12:17:59 +0200
Message-ID: <1317809879-24877-1-git-send-email-dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Single process will always select the same mirror (raid1 and raid10),
selection si based on PID. Use a simple incremental counter on every
attempt. This is just a heuristic, we do not know which mirror device is
least loaded, but there is a good chance the distribution over mirrors
will improve.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/volumes.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e138af7..3f0cc12 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2893,6 +2893,7 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 	int num_stripes;
 	int max_errors = 0;
 	struct btrfs_multi_bio *multi = NULL;
+	static unsigned int mirror_rotor = 0;
 
 	if (multi_ret && !(rw & (REQ_WRITE | REQ_DISCARD)))
 		stripes_allocated = 1;
@@ -3000,7 +3001,7 @@ again:
 		else {
 			stripe_index = find_live_mirror(map, 0,
 					    map->num_stripes,
-					    current->pid % map->num_stripes);
+					    mirror_rotor++ % map->num_stripes);
 		}
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
@@ -3026,7 +3027,7 @@ again:
 		else {
 			stripe_index = find_live_mirror(map, stripe_index,
 					      map->sub_stripes, stripe_index +
-					      current->pid % map->sub_stripes);
+					      mirror_rotor++ % map->sub_stripes);
 		}
 	} else {
 		/*
-- 
1.7.6

