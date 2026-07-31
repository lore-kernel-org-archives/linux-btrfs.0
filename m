Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A62A3A9870
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 09:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785489600; cv=none; b=ovcy1DMeKVKCR1yy582pjcD5uX06xyCO4Q8DV69u9dz7zE5/f4VFMWWevpPKRVsfkILHzuEnlzecq7vq7rinevSGGetky7xfb4LSuM6CKZEdHxzbNkEqhYCIGDkAB1He73cGk1k4x8K8wzKoMaR1/9Ub/JfIb1NZ6ODNsWic1vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785489600; c=relaxed/simple;
	bh=YNlt1mant49hcw/DpUlghlzZnB/GzPG/1xFOWwA4vKY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlyZiq/+VMKR9y5Yzrkx+6JOi7m8NCbmI+GSi9h6N3zS17GocFYAbG0/oQIz2BKeX30xoWeH5xfHyeqGbee9PQDbkeEph2x9lSYpqGi2+GuGmVdGxrkokxygv8P31MOE9dRoiW6bA8wbEL/0WdbYOno2RPpSx/OVpygLkHfD804=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Allw4iAp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Allw4iAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C27D1F00A3A
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 09:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785489594;
	bh=8XhEg2wk3DWsXsag9hzIKK2+iRsQ6t1q94oXXCa2DE4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Allw4iApedLPJ+aiAlfE7TFZXr7QoVPepCmEPAW7FfGHCdMerS8OZ2EGMqdtWrqgx
	 fERmLp9OGDzm45UYEuQ/Wwx4qtKCQ71fKHqROrIVKO6VuirdPmAVBI7sMLyLcyyUP1
	 7N8QFOvyxVaKG3BHrBD9KSS3Q7/vrW8j+TNrBJXke+R64lbOb+YOc/bzzN9E4Ry5vB
	 7Sf/pIweWY1y2eU+jB6yYAHVl+UI/XoRvS60tYAbJDYZaTcH0GKl+iHtT7xhZvIeih
	 VkGTauCmEQXe5xh2eDffSW5VSbTXBuqMao6JwzSvO4OJ8xbbG/+ny9++cEtVjv5xbl
	 0emK2Neh56laA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: skip hole detection during full fsync for files without holes
Date: Fri, 31 Jul 2026 10:19:42 +0100
Message-ID: <8a62eeb9c24994929aa697d2125a197e82bb7c02.1785488972.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <2673cd12fadb5269b39417694d82e02b90a482f7.1785429154.git.fdmanana@suse.com>
References: <2673cd12fadb5269b39417694d82e02b90a482f7.1785429154.git.fdmanana@suse.com>
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
(uncompressed space) is greater than or equals to the i_size of the
inode, then we cannot have holes and therefore avoid searching for
them. So skip the search if those conditions are met.

The following test script was used:

  $ cat test.sh
  #!/bin/bash

  MNT=/mnt/nullb0
  DEV=/dev/nullb0

  umount $MNT &> /dev/null
  mkfs.btrfs -f $DEV
  mount $DEV $MNT

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
  mount $DEV $MNT

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

V2: Support the case where i_size is not sector size aligned and so
    i_size <= nbytes.

 fs/btrfs/tree-log.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 47046dd14997..88b6258f2e3f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5591,6 +5591,15 @@ static int btrfs_log_holes(struct btrfs_trans_handle *trans,
 	if (!btrfs_fs_incompat(fs_info, NO_HOLES) || i_size == 0)
 		return 0;
 
+	/*
+	 * If there are no prealloc extents (which can be located past i_size),
+	 * and disk space used is greater than or equals to i_size, then there
+	 * are no holes.
+	 */
+	if (!(inode->flags & BTRFS_INODE_PREALLOC) &&
+	    i_size <= inode_get_bytes(&inode->vfs_inode))
+		return 0;
+
 	key.objectid = ino;
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = 0;
-- 
2.47.2

