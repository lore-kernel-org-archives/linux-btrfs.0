Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:47829 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaEYCu2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 May 2014 22:50:28 -0400
Received: by mail-we0-f177.google.com with SMTP id x48so6289418wes.8
        for <linux-btrfs@vger.kernel.org>; Sat, 24 May 2014 19:50:26 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: send, don't error in the presence of subvols/snapshots
Date: Sun, 25 May 2014 04:49:24 +0100
Message-Id: <1400989764-2478-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1400985786-16240-1-git-send-email-fdmanana@gmail.com>
References: <1400985786-16240-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we are doing an incremental send and the base snapshot has a
directory with name X that doesn't exist anymore in the second
snapshot and a new subvolume/snapshot exists in the second snapshot
that has the same name as the directory (name X), the incremental
send would fail with -ENOENT error. This is because it attempts
to lookup for an inode with a number matching the objectid of a
root, which doesn't exist.

Steps to reproduce:

    mkfs.btrfs -f /dev/sdd
    mount /dev/sdd /mnt

    mkdir /mnt/testdir
    btrfs subvolume snapshot -r /mnt /mnt/mysnap1

    rmdir /mnt/testdir
    btrfs subvolume create /mnt/testdir
    btrfs subvolume snapshot -r /mnt /mnt/mysnap2

    btrfs send -p /mnt/mysnap1 /mnt/mysnap2 -f /tmp/send.data

A test case for xfstests follows.

Reported-by: Robert White <rwhite@pobox.com>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Simpler version.

 fs/btrfs/send.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 1a65a40..2722b26 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1664,6 +1664,10 @@ static int lookup_dir_item_inode(struct btrfs_root *root,
 		goto out;
 	}
 	btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
+	if (key.type == BTRFS_ROOT_ITEM_KEY) {
+		ret = -ENOENT;
+		goto out;
+	}
 	*found_inode = key.objectid;
 	*found_type = btrfs_dir_type(path->nodes[0], di);
 
-- 
1.9.1

