From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH] remove unused variables
Date: Wed, 29 Jun 2011 19:54:35 +0200
Message-ID: <201106291954.36065.kario@wit.edu.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

fixes compilation warnings with gcc 4.6.0 20110429

Signed-off-by: Hubert Kario <kario@wit.edu.pl>
---
 mkfs.c    |    3 ---
 volumes.c |    2 --
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 1b5ef06..d40b2e8 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1060,7 +1060,6 @@ static int make_image(char *source_dir, struct btrfs_root *root, int out_fd)
        struct btrfs_trans_handle *trans;
 
        struct stat root_st;
-       int root_len;
 
        struct directory_name_entry dir_head;
 
@@ -1070,8 +1069,6 @@ static int make_image(char *source_dir, struct btrfs_root *root, int out_fd)
                goto fail;
        }
 
-       root_len = strlen(source_dir);
-
        INIT_LIST_HEAD(&dir_head.list);
 
        trans = btrfs_start_transaction(root, 1);
diff --git a/volumes.c b/volumes.c
index 61af845..95c2e0d 100644
--- a/volumes.c
+++ b/volumes.c
@@ -868,7 +868,6 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
        struct list_head *dev_list = &extent_root->fs_info->fs_devices->devices;
        struct list_head *cur;
        struct map_lookup *map;
-       u64 physical;
        u64 calc_size = 8 * 1024 * 1024;
        int num_stripes = 1;
        int sub_stripes = 0;
@@ -920,7 +919,6 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
                btrfs_set_stack_stripe_devid(stripe, device->devid);
                btrfs_set_stack_stripe_offset(stripe, dev_offset);
                memcpy(stripe->dev_uuid, device->uuid, BTRFS_UUID_SIZE);
-               physical = dev_offset;
                index++;
        }
 
-- 
1.7.5.1
