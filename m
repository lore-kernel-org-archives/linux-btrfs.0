From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: [PATCH] Btrfs: pick the correct metadata allocation size on small
 devices
Date: Sun, 12 Dec 2010 23:33:08 +0900
Message-ID: <20101212233308.4b2aff4a.kitayama@cl.bb4u.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Josef's fs_mark test

fs_mark -d /mnt/btrfs-test -D 512 -t 16 -n 4096 -F -S0

on a 2GB single metadata fs leaves about 400Mb of metadata almost unused.

This patch reduces metadata chunk allocations by considering the proper
metadata chunk size of 200MB in should_alloc_chunk(), not the default 256MB 
which is set in __btrfs_alloc_chunk().

Signed-off-by: Itaru Kitayama <kitayama@cl.bb4.ne.jp>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8c26441..54ab490 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3241,6 +3241,8 @@ static int should_alloc_chunk(struct btrfs_root *root,
                              struct btrfs_space_info *sinfo, u64 alloc_bytes)
 {
        u64 num_bytes = sinfo->total_bytes - sinfo->bytes_readonly;
+       u64 total_rw_bytes = root->fs_info->fs_devices->total_rw_bytes; 
+       u64 max_chunk_size;
        u64 thresh;
 
        if (sinfo->bytes_used + sinfo->bytes_reserved +
@@ -3251,8 +3253,9 @@ static int should_alloc_chunk(struct btrfs_root *root,
            alloc_bytes < div_factor(num_bytes, 8))
                return 0;
 
+       max_chunk_size = min(256 * 1024 * 1024, div_factor(total_rw_bytes, 1));
        thresh = btrfs_super_total_bytes(&root->fs_info->super_copy);
-       thresh = max_t(u64, 256 * 1024 * 1024, div_factor_fine(thresh, 5));
+       thresh = max_t(u64, max_chunk_size, div_factor_fine(thresh, 5));
 
        if (num_bytes > thresh && sinfo->bytes_used < div_factor(num_bytes, 3))
                return 0;


-- 
Itaru Kitayama <kitayama@cl.bb4.ne.jp>
