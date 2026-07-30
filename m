Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397192FD665
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 16:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785429668; cv=none; b=nzXbMqCJ2lW3de5MP2AmUK7bgh2a3db9ccFOBmNosA0Kniv2K5mauCvdRCUNLf9Qrx21EBooqkDpfwVNbHHJn/V1vYpt1sgGLYgXSP4zyZPxweXA19xv+NMNuhUnBeHAeiswnU2F2vr5m1gnm0aUm0dRze3cXuReF9gWRHFfDCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785429668; c=relaxed/simple;
	bh=MrFomt+ek9MafSDO1YjdTdqnbU0KRNtMwKsxbzP/hJA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GJJDeAsDtrEWMMdYAm1if/khM6YnvSiKncD2+Ly1th6CcW2YLD0dHx73Q5WtY3CTmgCYmiXl3amGtd6I0zhdgP82BVWAz/9WiaZB5Rwjr6g9CKlZyRNQ+SNwX3TiXE9W6czvkCmtRmm5NIWe7m6SuBGy8zELtLbUhELlyuV1008=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTw4c/x3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTw4c/x3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F841F00A3A
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 16:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785429667;
	bh=CVbDS0z6cD3upyKMSkX9occQj/nJh/cYwD6kUVV1Rds=;
	h=From:To:Subject:Date;
	b=cTw4c/x3X5rksmLQ9YTFEuJsftiyVdfSzB3pKoUl5DhdLjaz8mXkjbwnxKvvhdqyR
	 wzdNQ/yU0v0xrLfCsY8pWkgPHzwTnjYd9SchjeDOV+1zyVc5hfPfdaXPqpFkrxBneF
	 Afn5CbRzKyavzf9paEBP84GogVfGc17dce3zYLRubTUBQn4y15KOqb6ZIhnf3mNBwb
	 wSZm1TWOZ/AGQCeDKQacK2FRxDPBxMbLqXKyF8J/y1p5tdgVw8qvSMqM3Xof6jI3Rp
	 M0dz7ydMGBcFrKwOiWO5v4iYNN36WSmPooZcmSCv9RUoz+kMrt+pSDsp4hbXrJzQoV
	 9hvteQQJfpDyg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: skip hole detection during full fsync for files without holes
Date: Thu, 30 Jul 2026 17:41:02 +0100
Message-ID: <2673cd12fadb5269b39417694d82e02b90a482f7.1785429154.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we the no-holes feature is enabled (a default since btrfs-progs 5.15),
when doing a full fsync we always iterate of all leaves in the subvolume
root that contain file extent items in order to detect holes between them.

This can take a lot of time for files with a large number of extents.
But if we know there are no prealloc extents and the amount of space
(uncompressed space) matches the i_size of the inode, then we cannot
have holes and therefore avoid searching for them. So skip the search
if those conditions are met.

The following test script was used:

  $ cat test.sh
  #!/bin/bash

  MNT=/mnt/nullb0
  DEV=/dev/nullb0

  MOUNT_OPTIONS="-o ssd"
  MKFS_OPTIONS=""

  umount $MNT &> /dev/null
  mkfs.btrfs -f $MKFS_OPTIONS $DEV
  mount $MOUNT_OPTIONS $DEV $MNT

  # 256M gives 64K extents of 4K each.
  FILE_SIZE=$((256 * 1024 * 1024))
  touch $MNT/foobar

  for ((i = 0; i < $FILE_SIZE; i += 8192)); do
      xfs_io -c "pwrite -S 0xab $i 4K" $MNT/foobar > /dev/null
  done

  xfs_io -c "fsync" $MNT/foobar

  for ((i = 4096; i < $FILE_SIZE; i += 8192)); do
     xfs_io -c "pwrite -S 0xab $i 4K" $MNT/foobar > /dev/null
  done

  # unmount and mount, clear caches and ensure the next fsync is a
  # full sync.
  umount $MNT
  mount $MOUNT_OPTIONS $DEV $MNT

  # Do some change to the file in order to fsync.
  xfs_io -c "pwrite -S 0xcd 0 4K" $MNT/foobar > /dev/null

  T0=$(date +%s%N)
  xfs_io -c "fsync" $MNT/foobar
  T1=$(date +%s%N)

  echo
  echo "Took $(( (T1 - T0) / 1000 ))us"

  umount $MNT

Before this change:

  Took 28721us

After this change:

  Took 5453us

That's about 5.3x times faster.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 47046dd14997..226dd3053564 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5591,6 +5591,14 @@ static int btrfs_log_holes(struct btrfs_trans_handle *trans,
 	if (!btrfs_fs_incompat(fs_info, NO_HOLES) || i_size == 0)
 		return 0;
 
+	/*
+	 * If there are no prealloc extents (which can be located past i_size),
+	 * and disk space used matches the i_size, then there are no holes.
+	 */
+	if (!(inode->flags & BTRFS_INODE_PREALLOC) &&
+	    i_size == inode_get_bytes(&inode->vfs_inode))
+		return 0;
+
 	key.objectid = ino;
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = 0;
-- 
2.47.2

