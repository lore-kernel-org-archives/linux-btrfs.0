Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaHQUJZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Aug 2014 16:09:25 -0400
Message-ID: <53F10BF1.6070602@redhat.com>
Date: Sun, 17 Aug 2014 15:09:21 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH] btrfs: fix leak in qgroup_subtree_accounting() error path
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Coverity pointed this out; in the newly added
qgroup_subtree_accounting(), if btrfs_find_all_roots()
returns an error, we leak at least the parents pointer,
and possibly the roots pointer, depending on what failure
occurs.

If btrfs_find_all_roots() returns an error, we need to
free up all allocations before we return.  "roots" is
initialized to NULL, so it should be safe to free
it unconditionally (ulist_free() handles that case).

Cc: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b497498..8abe455 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1973,7 +1973,7 @@ static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
 				   elem.seq, &roots);
 	btrfs_put_tree_mod_seq(fs_info, &elem);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	if (roots->nnodes != 1)
 		goto out;

