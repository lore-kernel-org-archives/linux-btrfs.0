Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53414 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751581AbdGSHsC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jul 2017 03:48:02 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0ADE0ABE9
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Jul 2017 07:48:01 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Remove unused variables
Date: Wed, 19 Jul 2017 10:47:57 +0300
Message-Id: <1500450477-22017-1-git-send-email-nborisov@suse.com>
In-Reply-To: <20170718155456.GW2866@twin.jikos.cz>
References: <20170718155456.GW2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

clear_super - usage was removed in commit
cea67ab92d3d ("btrfs: clean the old superblocks before freeing the device") but
that change forgot to remove the actual variable.

max_key - commit 6174d3cb43aa ("Btrfs: remove unused max_key arg from
btrfs_search_forward") removed the max_key parameter but it forgot to remove
references from callers.

stripe_len - this one was added by e06cd3dd7cea ("Btrfs: add validadtion checks
for chunk loading") but even then it wasn't used.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Here's an updated change log with info when resp. variable became unused. 

 fs/btrfs/volumes.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6466f53b1e81..9a38cbf233a1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1873,7 +1873,6 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	struct btrfs_fs_devices *cur_devices;
 	u64 num_devices;
 	int ret = 0;
-	bool clear_super = false;
 
 	mutex_lock(&uuid_mutex);
 
@@ -1909,7 +1908,6 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		list_del_init(&device->dev_alloc_list);
 		device->fs_devices->rw_devices--;
 		mutex_unlock(&fs_info->chunk_mutex);
-		clear_super = true;
 	}
 
 	mutex_unlock(&uuid_mutex);
@@ -4128,7 +4126,6 @@ static int btrfs_uuid_scan_kthread(void *data)
 	struct btrfs_fs_info *fs_info = data;
 	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_key key;
-	struct btrfs_key max_key;
 	struct btrfs_path *path = NULL;
 	int ret = 0;
 	struct extent_buffer *eb;
@@ -4147,10 +4144,6 @@ static int btrfs_uuid_scan_kthread(void *data)
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = 0;
 
-	max_key.objectid = (u64)-1;
-	max_key.type = BTRFS_ROOT_ITEM_KEY;
-	max_key.offset = (u64)-1;
-
 	while (1) {
 		ret = btrfs_search_forward(root, &key, path, 0);
 		if (ret) {
@@ -6452,7 +6445,6 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 	struct extent_map *em;
 	u64 logical;
 	u64 length;
-	u64 stripe_len;
 	u64 devid;
 	u8 uuid[BTRFS_UUID_SIZE];
 	int num_stripes;
@@ -6461,7 +6453,6 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 
 	logical = key->offset;
 	length = btrfs_chunk_length(leaf, chunk);
-	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
 	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
 
 	ret = btrfs_check_chunk_valid(fs_info, leaf, chunk, logical);
-- 
2.7.4

