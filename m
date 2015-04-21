Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964993AbbDUVrf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 17:47:35 -0400
Date: Tue, 21 Apr 2015 14:47:33 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: [PATCH] btrfs: clear 'ret' in btrfs_check_shared() loop
Message-ID: <20150421214733.GO17170@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_check_shared() is leaking a return value of '1' from
find_parent_nodes(). As a result, callers (in this case, extent_fiemap())
are told extents are shared when they are not. This in turn broke fiemap on
btrfs for kernels v3.18 and up.

The fix is simple - we just have to clear 'ret' after we are done processing
the results of find_parent_nodes().

It wasn't clear to me at first what was happening with return values in
btrfs_check_shared() and find_parent_nodes() - thanks to Josef for the help
on irc. I added documentation to both functions to make things more clear
for the next hacker who might come across them.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/backref.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index f55721f..8d47380 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -880,6 +880,8 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
  * indirect refs to their parent bytenr.
  * When roots are found, they're added to the roots list
  *
+ * NOTE: This can return values > 0
+ *
  * FIXME some caching might speed things up
  */
 static int find_parent_nodes(struct btrfs_trans_handle *trans,
@@ -1198,6 +1200,19 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+/**
+ * btrfs_check_shared - tell us whether an extent is shared
+ *
+ * @trans: optional trans handle
+ *
+ * btrfs_check_shared uses the backref walking code but will short
+ * circuit as soon as it finds a root or inode that doesn't match the
+ * one passed in. This provides a significant performance benefit for
+ * callers (such as fiemap) which want to know whether the extent is
+ * shared but do not need a ref count.
+ *
+ * Return: 0 if extent is not shared, 1 if it is shared, < 0 on error.
+ */
 int btrfs_check_shared(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info, u64 root_objectid,
 		       u64 inum, u64 bytenr)
@@ -1226,11 +1241,13 @@ int btrfs_check_shared(struct btrfs_trans_handle *trans,
 		ret = find_parent_nodes(trans, fs_info, bytenr, elem.seq, tmp,
 					roots, NULL, root_objectid, inum);
 		if (ret == BACKREF_FOUND_SHARED) {
+			/* this is the only condition under which we return 1 */
 			ret = 1;
 			break;
 		}
 		if (ret < 0 && ret != -ENOENT)
 			break;
+		ret = 0;
 		node = ulist_next(tmp, &uiter);
 		if (!node)
 			break;
-- 
2.1.2

