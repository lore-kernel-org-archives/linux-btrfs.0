From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: Fix possible overflow of total bytes calculation
	for data enospc
Date: Tue, 22 Sep 2009 15:26:00 -0400
Message-ID: <20090922192559.GA18159@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Because of a bug where we sometimes don't know if a page has been dirtied
until its too late, there is a possibility that we could end up accounting
for more space than what we have.  This will of course cause an ENOSPC bug,
but it will also cause us to drive farther off into the weeds, since we
take total_bytes - (all of our counters), so any checks will always pass
just fine since the number will wrap.  Fix it so we add up all of the used
counters and then compare that way, so we don't dig ourselves a hole thats
much deeper than it already is.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/extent-tree.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7919050..a165260 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3006,6 +3006,7 @@ int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
 				u64 bytes)
 {
 	struct btrfs_space_info *data_sinfo;
+	u64 used;
 	int ret = 0, committed = 0;
 
 	/* make sure bytes are sectorsize aligned */
@@ -3015,10 +3016,12 @@ int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
 again:
 	/* make sure we have enough space to handle the data first */
 	spin_lock(&data_sinfo->lock);
-	if (data_sinfo->total_bytes - data_sinfo->bytes_used -
-	    data_sinfo->bytes_delalloc - data_sinfo->bytes_reserved -
-	    data_sinfo->bytes_pinned - data_sinfo->bytes_readonly -
-	    data_sinfo->bytes_may_use - data_sinfo->bytes_super < bytes) {
+
+	used = data_sinfo->bytes_used + data_sinfo->bytes_delalloc +
+		data_sinfo->bytes_reserved + data_sinfo->bytes_pinned +
+		data_sinfo->bytes_readonly + data_sinfo->bytes_may_use +
+		data_sinfo->bytes_super;
+	if (used + bytes > data_sinfo->total_bytes) {
 		struct btrfs_trans_handle *trans;
 
 		/*
-- 
1.5.4.3

