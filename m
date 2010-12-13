From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/3] Btrfs: Clean up tree search ioctl code
Date: Mon, 13 Dec 2010 17:50:38 +0800
Message-ID: <4D05EC6E.2090408@cn.fujitsu.com>
References: <4D05EBC9.6020908@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Ian! D. Allen" <idallen@idallen.ca>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D05EBC9.6020908@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

- Check if the key is within specified range before checking the
  item length.
- Advance to the next key a bit more efficiently.
- Remove redundant code.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 08174e2..477affb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1059,28 +1059,24 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 	slot = path->slots[0];
 	nritems = btrfs_header_nritems(leaf);
 
-	if (btrfs_header_generation(leaf) > sk->max_transid) {
-		i = nritems;
+	if (btrfs_header_generation(leaf) > sk->max_transid)
 		goto advance_key;
-	}
 	found_transid = btrfs_header_generation(leaf);
 
 	for (i = slot; i < nritems; i++) {
 		item_off = btrfs_item_ptr_offset(leaf, i);
 		item_len = btrfs_item_size_nr(leaf, i);
 
+		btrfs_item_key_to_cpu(leaf, key, i);
+		if (!key_in_sk(key, sk))
+			continue;
+
 		if (item_len > BTRFS_SEARCH_ARGS_BUFSIZE)
 			item_len = 0;
 
 		if (sizeof(sh) + item_len + *sk_offset >
-		    BTRFS_SEARCH_ARGS_BUFSIZE) {
-			ret = 1;
-			goto overflow;
-		}
-
-		btrfs_item_key_to_cpu(leaf, key, i);
-		if (!key_in_sk(key, sk))
-			continue;
+		    BTRFS_SEARCH_ARGS_BUFSIZE)
+			return 1;
 
 		sh.objectid = key->objectid;
 		sh.offset = key->offset;
@@ -1102,22 +1098,21 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 
 		(*num_found)++;
 		if (*num_found >= sk->nr_items)
-			break;
+			return 1;
 	}
 advance_key:
 	ret = 0;
 	if (key->offset < (u64)-1 && key->offset < sk->max_offset)
 		key->offset++;
 	else if (key->type < (u8)-1 && key->type < sk->max_type) {
-		key->offset = 0;
+		key->offset = sk->min_offset;
 		key->type++;
 	} else if (key->objectid < (u64)-1 && key->objectid < sk->max_objectid) {
-		key->offset = 0;
-		key->type = 0;
+		key->offset = sk->min_offset;
+		key->type = sk->min_type;
 		key->objectid++;
 	} else
 		ret = 1;
-overflow:
 	return ret;
 }
 
@@ -1178,9 +1173,8 @@ static noinline int search_ioctl(struct inode *inode,
 		ret = copy_to_sk(root, path, &key, sk, args->buf,
 				 &sk_offset, &num_found);
 		btrfs_release_path(root, path);
-		if (ret || num_found >= sk->nr_items)
+		if (ret)
 			break;
-
 	}
 	ret = 0;
 err:
-- 
1.6.3

