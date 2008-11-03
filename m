From: "yanhai zhu" <zhu.yanhai@gmail.com>
Subject: [PATCH]several insignificant cleanups
Date: Mon, 3 Nov 2008 22:20:01 +0800
Message-ID: <977a2be20811030620j51485a6fi502551c55d31abfc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
   below is some nontrivial cleanups.

Thanks,
Zhu Yanhai
--
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cbb9bb3..0974637 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -834,7 +834,7 @@ static int btrfs_rm_dev_item(struct btrfs_root *root,
 	struct block_device *bdev = device->bdev;
 	struct btrfs_device *next_dev;
 	struct btrfs_key key;
-	u64 total_bytes;
+	u64 num_devices;
 	struct btrfs_fs_devices *fs_devices;
 	struct btrfs_trans_handle *trans;

@@ -878,9 +878,9 @@ static int btrfs_rm_dev_item(struct btrfs_root *root,
 	if (bdev == fs_devices->latest_bdev)
 		fs_devices->latest_bdev = next_dev->bdev;

-	total_bytes = btrfs_super_num_devices(&root->fs_info->super_copy);
+	num_devices = btrfs_super_num_devices(&root->fs_info->super_copy);
 	btrfs_set_super_num_devices(&root->fs_info->super_copy,
-				    total_bytes - 1);
+				    num_devices - 1);
 out:
 	btrfs_free_path(path);
 	unlock_chunks(root);
@@ -1579,7 +1579,6 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	struct map_lookup *map;
 	struct extent_map *em;
 	int min_stripe_size = 1 * 1024 * 1024;
-	u64 physical;
 	u64 calc_size = 1024 * 1024 * 1024;
 	u64 max_chunk_size = calc_size;
 	u64 min_free;
@@ -1779,7 +1778,6 @@ again:
 		btrfs_set_stack_stripe_devid(stripe, device->devid);
 		btrfs_set_stack_stripe_offset(stripe, dev_offset);
 		memcpy(stripe->dev_uuid, device->uuid, BTRFS_UUID_SIZE);
-		physical = dev_offset;
 		index++;
 	}
 	BUG_ON(!list_empty(&private_devs));
