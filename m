Return-Path: <SRS0=W6bw=RH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53BAC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 14:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8250F20815
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 14:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551708379;
	bh=uadPNLQ4/qNP/mQrjhZoG55yGKfmVgE/I8ZSfTAxMCA=;
	h=From:To:Subject:Date:List-ID:From;
	b=w4Z/WIy4NXZSap3uNIwxq8XJ/LaaXS1x8x6z7nLpmm3ZKWhYUiXQtei0qe9CtG3Ee
	 mtXIkjsLKa5Qp3uNjq6+EJojHda68eg5pyFUZuat47BKJIv9PNTOveTgFsFN+1AAnG
	 3cd5PKafWa+qOoUGulxHHe54jcaljOxIDqX6bcQs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfCDOGS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Mar 2019 09:06:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbfCDOGR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Mar 2019 09:06:17 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 306EB20815
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Mar 2019 14:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551708376;
        bh=uadPNLQ4/qNP/mQrjhZoG55yGKfmVgE/I8ZSfTAxMCA=;
        h=From:To:Subject:Date:From;
        b=Pq7GV8L2ExVuhAUkep9XE4X6UjjH9TdzUilYSAmvKW3d9xrVoHKTRlYL/3uvLykAH
         My4q4rh3Ayg5vDag0o4PLYNGTlsQNBS4c9eRXg0eTsZE2+CMzSDYSYHQ81Cee7Swr/
         zFwz2umLFX1TTeZrAMp8hZQJLSrk3BEhTifzmJ5c=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix incorrect file size after shrinking truncate and fsync
Date:   Mon,  4 Mar 2019 14:06:12 +0000
Message-Id: <20190304140612.23950-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

If we do a shrinking truncate against an inode which is already present
in the respective log tree and then rename it, as part of logging the new
name we end up logging an inode item that reflects the old size of the
file (the one which we previously logged) and not the new smaller size.
The decision to preserve the size previously logged was added by commit
1a4bcf470c886b ("Btrfs: fix fsync data loss after adding hard link to
inode") in order to avoid data loss after replaying the log. However that
decision is only needed for the case the logged inode size is smaller then
the current size of the inode, as explained in that commit's change log.
If the current size of the inode is smaller then the previously logged
size, we know a shrinking truncate happened and therefore need to use
that smaller size.

Example to trigger the problem:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ xfs_io -f -c "pwrite -S 0xab 0 8000" /mnt/foo
  $ xfs_io -c "fsync" /mnt/foo
  $ xfs_io -c "truncate 3000" /mnt/foo

  $ mv /mnt/foo /mnt/bar
  $ xfs_io -c "fsync" /mnt/bar

  <power failure>

  $ mount /dev/sdb /mnt
  $ od -t x1 -A d /mnt/bar
  0000000 ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab
  *
  0008000

Once we rename the file, we log its name (and inode item), and because
the inode was already logged before in the current transaction, we log it
with a size of 8000 bytes because that is the size we previously logged
(with the first fsync). As part of the rename, besides logging the inode,
we do also sync the log, which is done since commit d4682ba03ef618
("Btrfs: sync log after logging new name"), so the next fsync against our
inode is effectively a no-op, since no new changes happened since the
rename operation. Even if did not sync the log during the rename
operation, the same problem (fize size of 8000 bytes instead of 3000
bytes) would be visible after replaying the log if the log ended up
getting synced to disk through some other means, such as for example by
fsyncing some other modified file. In the example above the fsync after
the rename operation is there just because not every filesystem may
guarantee logging/journalling the inode (and syncing the log/journal)
during the rename operation, for example it is needed for f2fs, but not
for ext4 and xfs.

Fix this scenario by, when logging a new name (which is triggered by
rename and link operations), using the current size of the inode instead
of the previously logged inode size.

A test case for fstests follows soon.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202695
Reported-by: Seulbae Kim <seulbae@gatech.edu>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 81a357a32837..41b66ea4060c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4549,6 +4549,19 @@ static int logged_inode_size(struct btrfs_root *log, struct btrfs_inode *inode,
 		item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				      struct btrfs_inode_item);
 		*size_ret = btrfs_inode_size(path->nodes[0], item);
+		/*
+		 * If the in-memory inode's i_size is smaller then the inode
+		 * size stored in the btree, return the inode's i_size, so
+		 * that we get a correct inode size after replaying the log
+		 * when before a power failure we had a shrinking truncate
+		 * followed by addition of a new name (rename / new hard link).
+		 * Otherwise return the inode size from the btree, to avoid
+		 * data loss when replaying a log due to previously doing a
+		 * write that expands the inode's size and logging a new name
+		 * immediately after.
+		 */
+		if (*size_ret > inode->vfs_inode.i_size)
+			*size_ret = inode->vfs_inode.i_size;
 	}
 
 	btrfs_release_path(path);
-- 
2.11.0

