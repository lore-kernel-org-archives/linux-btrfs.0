Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39208 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932125AbcJXCnx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Oct 2016 22:43:53 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 4/4] btrfs-progs: fsck: Fix NULL pointer dereference for possible memory allocation failure
Date: Mon, 24 Oct 2016 10:43:35 +0800
Message-Id: <20161024024335.6770-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161024024335.6770-1-quwenruo@cn.fujitsu.com>
References: <20161024024335.6770-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We didn't check 'path' allocated in check_root_ref(), which can cause
NULL pointer dereference if the memory allocation failed.

Fix it by using stack memory, since the function should return error
bitmap not minus error code, we don't want memory allocation to be an
exception.

Reported-by: David Sterba <dsterba@suse.cz>
Resolves-Coverity-CID: 1372510
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 91ed8b4..563cd55 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5067,7 +5067,7 @@ out:
 static int check_root_ref(struct btrfs_root *root, struct btrfs_key *ref_key,
 			  struct extent_buffer *node, int slot)
 {
-	struct btrfs_path *path;
+	struct btrfs_path path;
 	struct btrfs_key key;
 	struct btrfs_root_ref *ref;
 	struct btrfs_root_ref *backref;
@@ -5104,8 +5104,8 @@ static int check_root_ref(struct btrfs_root *root, struct btrfs_key *ref_key,
 	key.type = BTRFS_ROOT_BACKREF_KEY + BTRFS_ROOT_REF_KEY - ref_key->type;
 	key.offset = ref_key->objectid;
 
-	path = btrfs_alloc_path();
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 	if (ret) {
 		err |= ROOT_REF_MISSING;
 		error("%s[%llu %llu] couldn't find relative ref",
@@ -5115,11 +5115,11 @@ static int check_root_ref(struct btrfs_root *root, struct btrfs_key *ref_key,
 		goto out;
 	}
 
-	backref = btrfs_item_ptr(path->nodes[0], path->slots[0],
+	backref = btrfs_item_ptr(path.nodes[0], path.slots[0],
 				 struct btrfs_root_ref);
-	backref_dirid = btrfs_root_ref_dirid(path->nodes[0], backref);
-	backref_seq = btrfs_root_ref_sequence(path->nodes[0], backref);
-	backref_namelen = btrfs_root_ref_name_len(path->nodes[0], backref);
+	backref_dirid = btrfs_root_ref_dirid(path.nodes[0], backref);
+	backref_seq = btrfs_root_ref_sequence(path.nodes[0], backref);
+	backref_namelen = btrfs_root_ref_name_len(path.nodes[0], backref);
 
 	if (backref_namelen <= BTRFS_NAME_LEN) {
 		len = backref_namelen;
@@ -5130,7 +5130,7 @@ static int check_root_ref(struct btrfs_root *root, struct btrfs_key *ref_key,
 			"ROOT_REF" : "ROOT_BACKREF",
 			key.objectid, key.offset);
 	}
-	read_extent_buffer(path->nodes[0], backref_name,
+	read_extent_buffer(path.nodes[0], backref_name,
 			   (unsigned long)(backref + 1), len);
 
 	if (ref_dirid != backref_dirid || ref_seq != backref_seq ||
@@ -5143,7 +5143,7 @@ static int check_root_ref(struct btrfs_root *root, struct btrfs_key *ref_key,
 		      ref_key->objectid, ref_key->offset);
 	}
 out:
-	btrfs_free_path(path);
+	btrfs_release_path(&path);
 	return err;
 }
 
-- 
2.10.1



