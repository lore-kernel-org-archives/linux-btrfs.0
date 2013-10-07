Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab3JGVnP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 17:43:15 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r97LhFWd000515
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 17:43:15 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 01/12] btrfs-progs: check path alloc in corrupt block
Date: Mon,  7 Oct 2013 14:42:54 -0700
Message-Id: <1381182185-10896-2-git-send-email-zab@redhat.com>
In-Reply-To: <1381182185-10896-1-git-send-email-zab@redhat.com>
References: <1381182185-10896-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-corrupt-block added some untested path allocations.  These showed
up in static analysis when they pass their path to btrfs_search_slot()
which unconditionally dereferences the path.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 btrfs-corrupt-block.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 9e72ca8..018c23d 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -502,6 +502,9 @@ int corrupt_chunk_tree(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
 	key.objectid = (u64)-1;
 	key.offset = (u64)-1;
 	key.type = (u8)-1;
@@ -531,7 +534,7 @@ int corrupt_chunk_tree(struct btrfs_trans_handle *trans,
 		if (ret)
 			goto free_out;
 	}
-	btrfs_free_path(path);
+	btrfs_release_path(path);
 
 	/* Here, cow and ins_len must equals 0 for the following reasons:
 	 * 1) chunk recover is based on disk scanning, so COW should be
@@ -540,7 +543,6 @@ int corrupt_chunk_tree(struct btrfs_trans_handle *trans,
 	 * 2) if cow = 0, ins_len must also be set to 0, or BUG_ON will be
 	 *    triggered.
 	 */
-	path = btrfs_alloc_path();
 	ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
 	BUG_ON(ret == 0);
 	if (ret < 0) {
@@ -720,6 +722,10 @@ int main(int ac, char **av)
 			print_usage();
 		del = rand() % 3;
 		path = btrfs_alloc_path();
+		if (!path) {
+			fprintf(stderr, "path allocation failed\n");
+			goto out_close;
+		}
 
 		if (find_chunk_offset(root->fs_info->chunk_root, path,
 				      logical) != 0) {
-- 
1.7.11.7

