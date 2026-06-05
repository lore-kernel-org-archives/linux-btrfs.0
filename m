Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B8F3DC87B
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 10:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780655244; cv=none; b=QSzMkAUQPi87+yb26+p8rpgKA1W7D9/jSHb1lmr247Zf/qvBFFW1ujv3KQtzwOnNnXLtSay8/gxZthX0KMTPu/UrnQj++w72g+IaZf4J4gnUSYeoseuR50Cc7cu1Cz2o/X995VWji1v9liNhAJjOS+bGKHauzqJDwOQPSf9/S1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780655244; c=relaxed/simple;
	bh=hOQbZ1iL1E/TxyGv6optPjbms0IjOE25UZUwbwW+g+s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rIP49ZCbb/UtULBRTWiGwTzuJGYQvPnDYF9f3vbSTTnKv5aGGYzzD6EZViurzXxXCD6aYEhvNtOTdeNGYPZwOvvIdw1lizro3UovNfdz5+P0byab4FqGNAO1gVIKabU4HYwxapbCzUDyRZdRwAfePbKU0CvtSfxFiysahNaztUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UayHL3p0; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UayHL3p0"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2bf114b0cf9so14409005ad.2
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2026 03:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780655242; x=1781260042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ospLErSsF4BbKHv3hnSVSap1ssPjIy7ypNw60EIufuU=;
        b=UayHL3p0MCaDrx0tDXx9SjbdfdI7X9uE6k6qfs73YpaEzWYQRDvu/ZL8baDM619YkA
         mqt683YVu6HlCN66SdNH3tcv9Y6Dv0H59dhy4RFk++cwNJIWiUfdaoufaniUIQMf8V+V
         eooMlvHB5v0eYZsmi8O/RygrBhqAHq/5xowhD+YTSlTde5nSHDhty4b3796g1QrQ7vz+
         Z8fLEPzlt7+o9pi3KEVtIaljHXdMDRMleJy9040OiRTiq39SgR5yUTF4d92gqtCFl4NT
         cC8ijtDSkaA43+jJwLuip/OTJ2CUSjHqD5PvLBszDadNjsNZzyN8m/TnFFu799QYZhbr
         ssPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780655242; x=1781260042;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ospLErSsF4BbKHv3hnSVSap1ssPjIy7ypNw60EIufuU=;
        b=pDRyo4Mozo5IQDM7VIj3TPsiMYpvgPUBAywcEcorYzrfQMhjbIXKTfjpAeMcxb9cSS
         gZMYCPB+XRGkFA8z1jSPmUh+eMLg4PylM65Ups0aqJ0NaGCa2Ku1LN+4Xn42Np2biKhC
         VXreb1CRBd4riCoJbwUwqEU75t0IGt0no+BvIIJHs//NWUlpaQlPx/2ES3IR3BPKhA7d
         XLMD7xWzY5cYf2xIEBVs8HMlnRubFXjyJ7RaEhsge0tzeCEBSzVWrqHjpfXZskcb6g56
         tljErqhZztmCPA6sgizooDBS3eLcQwSvYErVdozen+cwU30MSJxJ/SywYeKAsA9uf3b1
         lDjQ==
X-Gm-Message-State: AOJu0YyOBw2KYVpjEijDTgoohvdtYZflCLcIqWsnjpTUpWacph31ZY3O
	EiKGmkU6YgKTeP8/S1bM5AZYsmcpf2GWrjnzwn4EU9oFf/JZ0HaKf68TNV1Ejg==
X-Gm-Gg: Acq92OEaf46afb4e/MifwlU6Qjix4TjLkrDgmyf3dmJMvzCFlonNG9BO+bNZhZQ6Wr3
	GI/L0w1NUb63BhVlxMZDWZ4Cci3lNZWZhn31oBvCR4jkktZNrCzXLnX7IF04IPLEBz3ZXyF6rk/
	6+G8LodcPqzK2mW775m5SCZ8gO41LKoSmWZOQVLUnUWq8C4NMa0tkd8rbAaBRHbDkMVPRowxObh
	u4kIH9a39D9esu0ItqtlKLOxF+UgPzqQpMSjFBrerRFokNfBurfTgoYx3VRagfDw3dNdojQjSY9
	afWv3m/bpKzu+hHlRd489rPSSOiZ1qDmmPCVHrk42mjwptuCE7WPGcXVQandQA4WzARx8QCHmu4
	nxD2QckmkrYIKRpMHptyGGJi46UiFbgJBvOjEFTf10DAgp2853o7TpgL/c4KP1anwFZ20OC5tST
	/005ranUNN7mNGtp8UI7ICEY032TPcTi2AcYxQQBxQnQbCCGRI81/qF0bc+BEsbVmxduS6kqPHJ
	+fkg+ShTJxwME+jTsYVMvt7Jm+YIhoZIiPdeeQ=
X-Received: by 2002:a17:902:f651:b0:2c0:c14c:bf38 with SMTP id d9443c01a7336-2c1e881ff16mr34738635ad.24.1780655242111;
        Fri, 05 Jun 2026 03:27:22 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-113-80-70.ap-northeast-1.compute.amazonaws.com. [13.113.80.70])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16609e0a2sm90503585ad.46.2026.06.05.03.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 03:27:21 -0700 (PDT)
From: Zhang Boyang <zhangboyang.id@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Zhang Boyang <zhangboyang.id@gmail.com>
Subject: [RFC PATCH] btrfs: [draft] fix raid1 fsync durability loss when one mirror temporarily offline followed by an unclean unmount
Date: Fri,  5 Jun 2026 18:26:07 +0800
Message-Id: <20260605102607.23786-1-zhangboyang.id@gmail.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello btrfs devs,

I found a bug in raid1 btrfs, which can cause fsync'ed data disappear.

Assume there are two btrfs device A (devid 1) and B (devid 2), the bug can be
triggered by following steps:

step 1: xfs_io -f -c 'pwrite -W -S 0xee 0 20' /path/to/testfile
   Prepare test file.
step 2: umount and mount.
step 3: make A offline
step 4: xfs_io -f -c 'pwrite -W -S 0x00 0 20' /path/to/testfile
   This will not result in error because B is still online.
step 5: make B offline
   Now A and B are both offline.
   There is no log tree in A, but the log tree exists in B.
step 6: unmount or reboot
step 7: make A and B online, then mount btrfs
   The generation of A and B are same, but log tree only exists in B.
   Since A has lower devid, the superblock of A is choosen.
   Thus no log tree replay, the data in testfile is still 0xee.

(Ofcourse mount with 'notreelog' option can workaround the problem)

These steps can be automated by doing following modifications to btrfs/271.

diff --git a/tests/btrfs/271 b/tests/btrfs/271
index 7d5424f8..3891657f 100755
--- a/tests/btrfs/271
+++ b/tests/btrfs/271
@@ -29,7 +29,6 @@ _allow_fail_make_request
 echo "Step 1: writing with one failing mirror:"
 _bdev_fail_make_request $SCRATCH_DEV 1
 $XFS_IO_PROG -f -c "pwrite -W -S 0xaa 0 8K" $SCRATCH_MNT/foobar | _filter_xfs_io
-_bdev_fail_make_request $SCRATCH_DEV 0

 # btrfs counts errors per IO, assuming the data is merged that'll be 1 IO, then
 # the log tree block and then the log root tree block and then the super block.
@@ -42,6 +41,12 @@ if [ $errs -lt 4 ]; then
         _fail "Errors: $errs expected: 4"
 fi

+_bdev_fail_make_request $dev2 1
+_scratch_unmount
+_bdev_fail_make_request $SCRATCH_DEV 0
+_bdev_fail_make_request $dev2 0
+_scratch_mount
+
 echo "Step 2: verify that the data reads back fine:"
 $XFS_IO_PROG -c "pread -v 0 8K" $SCRATCH_MNT/foobar | _filter_xfs_io_offset

This draft provides a half-finished fix:

1) revive btrfs_super_block::log_root_transid,
2) at mount time, choose the super with highest (generation, log_root_transid).

By the way, the log_root_transid is introduced in c3027eb5523d ("Btrfs: Add
inode sequence number for NFS and reserved space in a few structs") and seems
never used until deprecation 97f09d55f194 ("btrfs: make
btrfs_super_block::log_root_transid deprecated")

The biggest problem is current approach relys on checksum/tree-checker, you
might see following messages during recovery process:

[ 9529.157552] BTRFS info (device nbd4p1): start tree-log replay
[ 9529.157890] BTRFS error (device nbd4p1): parent transid verify failed on logical 30556160 mirror 1 wanted 10 found 8
[ 9529.158223] BTRFS error (device nbd4p1): parent transid verify failed on logical 30556160 mirror 2 wanted 10 found 8
[ 9529.158524] BTRFS error (device nbd4p1): parent transid verify failed on logical 30556160 mirror 3 wanted 10 found 8
[ 9529.159068] BTRFS info (device nbd4p1): read error corrected: ino 0 off 30556160 (dev /dev/nbd1p1 sector 59680)
[ 9529.159402] BTRFS error (device nbd4p1): parent transid verify failed on logical 30539776 mirror 1 wanted 10 found 8
[ 9529.159696] BTRFS error (device nbd4p1): parent transid verify failed on logical 30539776 mirror 2 wanted 10 found 8
[ 9529.159973] BTRFS error (device nbd4p1): parent transid verify failed on logical 30539776 mirror 3 wanted 10 found 8
[ 9529.160489] BTRFS info (device nbd4p1): read error corrected: ino 0 off 30539776 (dev /dev/nbd1p1 sector 59648)

The important thing is, there might be multiple versions (log_root_transid) of
log tree on disk, all of them have same generation, and there is no way to
distinguish between them. We are safe if sectors of log-tree is never reused in
one generation, but is this true?

The draft is half-finished because there are other places around
latest_dev->generation need to be fixed as well. If this draft is appropriate,
I can continue to work on this patch (coding style, commit message,
btrfs-progs, xfstests, etc.)

Signed-off-by: Zhang Boyang <zhangboyang.id@gmail.com>
---
 fs/btrfs/accessors.h            | 2 ++
 fs/btrfs/transaction.c          | 1 +
 fs/btrfs/tree-log.c             | 4 +++-
 fs/btrfs/volumes.c              | 6 +++++-
 fs/btrfs/volumes.h              | 1 +
 include/uapi/linux/btrfs_tree.h | 8 ++------
 6 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/accessors.h b/fs/btrfs/accessors.h
index 8938357fcb40..891b8197d946 100644
--- a/fs/btrfs/accessors.h
+++ b/fs/btrfs/accessors.h
@@ -852,6 +852,8 @@ BTRFS_SETGET_STACK_FUNCS(super_chunk_root, struct btrfs_super_block,
 BTRFS_SETGET_STACK_FUNCS(super_chunk_root_level, struct btrfs_super_block,
 			 chunk_root_level, 8);
 BTRFS_SETGET_STACK_FUNCS(super_log_root, struct btrfs_super_block, log_root, 64);
+BTRFS_SETGET_STACK_FUNCS(super_log_root_transid, struct btrfs_super_block,
+			 log_root_transid, 64);
 BTRFS_SETGET_STACK_FUNCS(super_log_root_level, struct btrfs_super_block,
 			 log_root_level, 8);
 BTRFS_SETGET_STACK_FUNCS(super_total_bytes, struct btrfs_super_block,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index ec3c15fc7ae3..9978eea9c08b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2530,6 +2530,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	update_super_roots(fs_info);
 
 	btrfs_set_super_log_root(fs_info->super_copy, 0);
+	btrfs_set_super_log_root_transid(fs_info->super_copy, 0);
 	btrfs_set_super_log_root_level(fs_info->super_copy, 0);
 	memcpy(fs_info->super_for_commit, fs_info->super_copy,
 	       sizeof(*fs_info->super_copy));
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ac871efb9763..1fa773d5edae 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3331,6 +3331,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	struct blk_plug plug;
 	u64 log_root_start;
 	u64 log_root_level;
+	u64 log_root_transid;
 
 	mutex_lock(&root->log_mutex);
 	log_transid = ctx->log_transid;
@@ -3539,7 +3540,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
 	log_root_start = log_root_tree->node->start;
 	log_root_level = btrfs_header_level(log_root_tree->node);
-	log_root_tree->log_transid++;
+	log_root_transid = ++log_root_tree->log_transid;
 	mutex_unlock(&log_root_tree->log_mutex);
 
 	/*
@@ -3575,6 +3576,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_set_super_log_root(fs_info->super_for_commit, log_root_start);
+	btrfs_set_super_log_root_transid(fs_info->super_for_commit, log_root_transid);
 	btrfs_set_super_log_root_level(fs_info->super_for_commit, log_root_level);
 	ret = write_all_supers(fs_info, 1);
 	mutex_unlock(&fs_info->tree_log_mutex);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fd400fbc654d..8744929c32ce 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -676,6 +676,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 		goto error_free_page;
 
 	device->generation = btrfs_super_generation(disk_super);
+	device->log_root_transid = btrfs_super_log_root_transid(disk_super);
 
 	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING) {
 		if (btrfs_super_incompat_flags(disk_super) &
@@ -1246,8 +1247,11 @@ static int open_fs_devices(struct btrfs_fs_devices *fs_devices,
 		int ret2;
 
 		ret2 = btrfs_open_one_device(fs_devices, device, flags, holder);
+		btrfs_info(NULL, "devid=%llu generation=%llu log_root_transid=%llu", device->devid, device->generation, device->log_root_transid);
 		if (ret2 == 0 &&
-		    (!latest_dev || device->generation > latest_dev->generation)) {
+		    (!latest_dev || device->generation > latest_dev->generation ||
+		     (device->generation == latest_dev->generation &&
+		      device->log_root_transid > latest_dev->log_root_transid))) {
 			latest_dev = device;
 		} else if (ret2 == -ENODATA) {
 			fs_devices->num_devices--;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 8288d79372a5..0334d637d2d3 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -129,6 +129,7 @@ struct btrfs_device {
 	const char __rcu *name;
 
 	u64 generation;
+	u64 log_root_transid;
 
 	struct file *bdev_file;
 	struct block_device *bdev;
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index f7843e6bb978..3cb263900bb8 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -687,12 +687,8 @@ struct btrfs_super_block {
 	__le64 chunk_root;
 	__le64 log_root;
 
-	/*
-	 * This member has never been utilized since the very beginning, thus
-	 * it's always 0 regardless of kernel version.  We always use
-	 * generation + 1 to read log tree root.  So here we mark it deprecated.
-	 */
-	__le64 __unused_log_root_transid;
+	/* this will help find the new super based on the log root */
+	__le64 log_root_transid;
 	__le64 total_bytes;
 	__le64 bytes_used;
 	__le64 root_dir_objectid;
-- 
2.30.2

