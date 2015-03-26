Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbbCZDYU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 23:24:20 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 19DE82BCD7C
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Mar 2015 03:24:20 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t2Q3OI6O002494
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2015 23:24:19 -0400
Message-ID: <55137BE2.80603@redhat.com>
Date: Wed, 25 Mar 2015 22:24:18 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: I think "btrfs: fix leak of path in btrfs_find_item" broke stable
 trees ...
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like "btrfs: fix leak of path in btrfs_find_item" got sent
to stable trees, but in my testing, it causes deadlocks on mount:

[23379.359246] mount           D 0000000000000000     0 22541  22274 0x00000080
[23379.366326]  ffff8803ebadf6c8 0000000000000086 ffff88027ff10230 0000000000013680
[23379.373770]  0000000000013680 ffff8803ebadffd8 ffff8803ebadc010 0000000000013680
[23379.381208]  ffff8803ebadffd8 0000000000013680 ffff880261c78b60 ffff8802140a0b60
[23379.388648] Call Trace:
[23379.391106]  [<ffffffff816182b9>] schedule+0x29/0x70
[23379.396091]  [<ffffffffa06b82f5>] btrfs_tree_lock+0xb5/0x290 [btrfs]
[23379.402444]  [<ffffffff8109b470>] ? wake_up_bit+0x40/0x40
[23379.407855]  [<ffffffffa064f7a5>] ? generic_bin_search+0xf5/0x180 [btrfs]
[23379.414643]  [<ffffffffa065041b>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
[23379.421345]  [<ffffffffa065936b>] btrfs_search_slot+0x63b/0x800 [btrfs]
[23379.427956]  [<ffffffffa064fa49>] ? btrfs_set_path_blocking+0x39/0x80 [btrfs]
[23379.435088]  [<ffffffffa0659ede>] btrfs_insert_empty_items+0x7e/0xe0 [btrfs]
[23379.442125]  [<ffffffffa065051a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[23379.448655]  [<ffffffffa06b8989>] btrfs_insert_orphan_item+0x69/0x90 [btrfs]
[23379.455696]  [<ffffffffa06ba938>] insert_orphan_item+0x68/0x90 [btrfs]
[23379.462251]  [<ffffffffa06bf772>] replay_one_buffer+0x372/0x380 [btrfs]
[23379.468878]  [<ffffffffa069a4c1>] ? mark_extent_buffer_accessed+0x51/0x70 [btrfs]
[23379.476372]  [<ffffffffa06ba54b>] walk_up_log_tree+0x1cb/0x250 [btrfs]
[23379.482910]  [<ffffffffa06ba68f>] walk_log_tree+0xbf/0x1b0 [btrfs]
[23379.489098]  [<ffffffffa06bd51c>] btrfs_recover_log_trees+0x1ec/0x4c0 [btrfs]
...

I could hit this by running ./check generic/015  generic/039 in fstests,
with a SCRATCH_DEV_POOL defined (not sure it matters, it's just what I
have...)

This fixes it, though I'm not totally sure why.  Refcounts?

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 906934e..d37e6d1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1265,11 +1265,11 @@ static int insert_orphan_item(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_find_item(root, path, BTRFS_ORPHAN_OBJECTID,
 			offset, BTRFS_ORPHAN_ITEM_KEY, NULL);
+	btrfs_free_path(path);
+
 	if (ret > 0)
 		ret = btrfs_insert_orphan_item(trans, root, offset);
 
-	btrfs_free_path(path);
-
 	return ret;
 }
 

but it never likely showed up upstream, because 

9c4f61f btrfs: simplify insert_orphan_item

made the whole path alloc/free go away.

-Eric
