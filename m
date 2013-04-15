Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f65.google.com ([209.85.212.65]:34191 "EHLO
	mail-vb0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab3DOBwP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Apr 2013 21:52:15 -0400
MIME-Version: 1.0
Date: Sun, 14 Apr 2013 17:44:02 -0700
Message-ID: <CAJ3m7BpZkbGS6+Qhn_KMN1z0bA+8Czf3D6cbC1B8_0fdFjcPvA@mail.gmail.com>
Subject: [PATCH mainline] btrfs: fix minor typo in comment
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the comment describing the sync_writers field of the btrfs_inode
struct, "fsyncing" was misspelled "fsycing."

Signed-off-by: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
---
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index d9b97d4..08b286b 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -93,7 +93,7 @@ struct btrfs_inode {

  unsigned long runtime_flags;

- /* Keep track of who's O_SYNC/fsycing currently */
+ /* Keep track of who's O_SYNC/fsyncing currently */
  atomic_t sync_writers;

  /* full 64 bit generation number, struct vfs_inode doesn't have a big
