Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:52267 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932920AbdJ3W3Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 18:29:25 -0400
Received: by mail-pg0-f46.google.com with SMTP id a192so12877621pge.9
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 15:29:25 -0700 (PDT)
From: Justin Maggard <jmaggard10@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard@netgear.com>
Subject: [PATCH] btrfs: Fix quota reservation leak on preallocated files
Date: Mon, 30 Oct 2017 15:29:10 -0700
Message-Id: <20171030222910.21722-1-jmaggard@netgear.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit c6887cd11149 (Btrfs: don't do nocow check unless we have to)
changed the behavior of __btrfs_buffered_write() so that it first tries
to get a data space reservation, and then skips the relatively expensive
nocow check if the reservation succeeded.

If we have quotas enabled, the data space reservation also includes a
quota reservation.  But in the rewrite case, the space has already been
accounted for in qgroups.  So btrfs_check_data_free_space() increases the
quota reservation, but it never gets decreased when the data actually
gets written and overwrites the pre-existing data.  So we're left with
both the qgroup and qgroup reservation accounting for the same space.

This commit adds the missing btrfs_qgroup_free_data() call in the case of
BTRFS_ORDERED_PREALLOC extents.

Signed-off-by: Justin Maggard <jmaggard@netgear.com>
---
 fs/btrfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d94e3f68b9b1..d7881ccf5310 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3006,6 +3006,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		compress_type = ordered_extent->compress_type;
 	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
 		BUG_ON(compress_type);
+		btrfs_qgroup_free_data(inode, NULL, ordered_extent->file_offset,
+				       ordered_extent->len);
 		ret = btrfs_mark_extent_written(trans, BTRFS_I(inode),
 						ordered_extent->file_offset,
 						ordered_extent->file_offset +
-- 
2.14.2

