From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't allocate chunks as aggressively V2
Date: Mon, 18 Oct 2010 21:02:57 -0400
Message-ID: <1287450177-4081-1-git-send-email-josef@redhat.com>
References: <20101018211313.GA2539@localhost.localdomain>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101018211313.GA2539@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Because the ENOSPC code over reserves super aggressively we end up allocating
chunks way more often than we should.  For example with my fs_mark tests on a
2gb fs I can end up reserved 1gb just for metadata, when only 34mb of that is
being used.  So instead check to see if the amount of space actually used is
less than 30% of the total space, and if so don't allocate a chunk, but only if
we have at least 256mb of free space to make sure we don't put too much pressure
on free space.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1-V2: Cleanup should_alloc_chunk so it doesnt take fs_info, I was using it
before for something different, forgot to clean it up.  Also added 256mb free
floor at Chris's suggestion to help with the -m single case.

 fs/btrfs/extent-tree.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 14a52dd..eac11b1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3224,8 +3224,7 @@ static void force_metadata_allocation(struct btrfs_fs_info *info)
 	rcu_read_unlock();
 }
 
-static int should_alloc_chunk(struct btrfs_space_info *sinfo,
-			      u64 alloc_bytes)
+static int should_alloc_chunk(struct btrfs_space_info *sinfo, u64 alloc_bytes)
 {
 	u64 num_bytes = sinfo->total_bytes - sinfo->bytes_readonly;
 
@@ -3237,6 +3236,10 @@ static int should_alloc_chunk(struct btrfs_space_info *sinfo,
 	    alloc_bytes < div_factor(num_bytes, 8))
 		return 0;
 
+	if (num_bytes > 256 * 1024 * 1024 &&
+	    sinfo->bytes_used < div_factor(num_bytes, 3))
+		return 0;
+
 	return 1;
 }
 
-- 
1.6.6.1

