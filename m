Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:36943 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107AbcBWEyl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 23:54:41 -0500
Received: from freie.home (home.lxoliva.fsfla.org [172.31.160.22])
	by linux-libre.fsfla.org (8.14.4/8.14.4/Debian-4.1ubuntu1) with ESMTP id u1N4gfbk002751
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 04:42:42 GMT
From: Alexandre Oliva <oliva@gnu.org>
To: linux-btrfs@vger.kernel.org
Subject: after crash, btrfs attempts to clean up extent it has already cleaned up 
Date: Tue, 23 Feb 2016 01:42:25 -0300
Message-ID: <orsi0kt4um.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Are there others getting errors like $SUBJECT, described in more detail
at https://bugzilla.kernel.org/show_bug.cgi?id=112561

If my theory is correct, workloads involving lots of snapshots, such as
Ceph OSDs, might run into it quite often.

Although I could recover from a few such metadata corruptions by hand,
when btrfs check --repair couldn't fix it, it's quite cumbersome.  I
wonder if a change like this, made conditional on a mount option, would
be considered appropriate.  I considered making it conditional on -o
recovery, but ended up just making it unconditional for my own temporary
use.


As for fixing metadata corruption by hand, I've been thinking it might
be useful to have some tool to help navigate and change metadata,
extract files and whatnot, much like debugfs for ext* filesystems.
Would others find it useful?  Is anyone else already working on such a
thing?


diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index cadacf6..849765a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6356,7 +6356,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			"unable to find ref byte nr %llu parent %llu root %llu  owner %llu offset %llu",
 			bytenr, parent, root_objectid, owner_objectid,
 			owner_offset);
-		btrfs_abort_transaction(trans, extent_root, ret);
+		ret = 0; /*btrfs_abort_transaction(trans, extent_root, ret);*/
 		goto out;
 	} else {
 		btrfs_abort_transaction(trans, extent_root, ret);


-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist|Red Hat Brasil GNU Toolchain Engineer
