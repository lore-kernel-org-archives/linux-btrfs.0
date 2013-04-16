Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38219 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3DPFTU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 01:19:20 -0400
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 642553EE0AE
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:19:19 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 4CAAB45DE56
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:19:19 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 3514F45DE55
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:19:19 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 26A331DB804D
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:19:19 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id D3DBC1DB8046
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:19:18 +0900 (JST)
Received: from m1000.css.fujitsu.com (m1000 [127.0.0.1])
	by m1000.s.css.fujitsu.com (Postfix) with ESMTP id ADA5361626
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:19:18 +0900 (JST)
Received: from FM-323941448.jp.fujitsu.com (unknown [10.124.101.132])
	by m1000.s.css.fujitsu.com (Postfix) with SMTP id 82A5261623
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:19:18 +0900 (JST)
Message-Id: <201304160519.AA00027@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Tue, 16 Apr 2013 14:19:11 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] Btrfs: cleanup of function where btrfs_extend_item() is called
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Argument 'trans' became unnecessary from setup_inline_extent_backref()
that called btrfs_extend_item().

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 151b0ad..f3ff02a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1590,8 +1590,7 @@ out:
  * helper to add new inline back ref
  */
 static noinline_for_stack
-void setup_inline_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
+void setup_inline_extent_backref(struct btrfs_root *root,
 				 struct btrfs_path *path,
 				 struct btrfs_extent_inline_ref *iref,
 				 u64 parent, u64 root_objectid,
@@ -1764,7 +1763,7 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
 		update_inline_extent_backref(root, path, iref,
 					     refs_to_add, extent_op);
 	} else if (ret == -ENOENT) {
-		setup_inline_extent_backref(trans, root, path, iref, parent,
+		setup_inline_extent_backref(root, path, iref, parent,
 					    root_objectid, owner, offset,
 					    refs_to_add, extent_op);
 		ret = 0;
-- 
1.7.12.2

