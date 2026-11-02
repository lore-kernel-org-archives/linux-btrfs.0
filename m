Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793649309;
	b=R5PqsoMvs05myRQu383gw67xHBCuqoILhDJhJtLBrMJGcC/Zp8dL/IaTKW74UjdHhpBw
	 YAYGOU+ItckSrhFTPp9YJm/EdZ99Y6+1BCzJZGaQFjoFWQsZq1xC+ajFujkiX8bEv5VCM
	 I3a11KvXa46V6EOhKKRX3jx2t4mPoQnMDiyCRHCifI/L8e+zMc5Kn7hvLYL0a5u/2bvtS
	 YbMlf140WZfr+8blzFduehCWrUDWGwIVARRQSnvc/4RvjngDbwLzoV6FRUK/QI9ZBocd+
	 vCk66L1RaOla0uwtkAJt338w4I3RpH8MDmGvWoRWmB0a7mv8zcd6c98Sui/wcThnxQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793649309;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D9RKiKZIKboaVdkB4sjOX/RcCW0RWe2D+hJi9iS+b68=;
	b=Otyco4xB2PuP+HhoJldAa2AQEwqKA5DlwUA70nmbPFgx7oCSyRlLDq9fafamHGnwNQrK
	 wAlh4VjthNl2stHkiA/p6jpw2RYmZa4O6J0hlVpnx5TfH7XZbNe6lL/DJlopbYIPXfZcB
	 v0ssee4MpA5zDkxK1AHnG6qrRtP2BGMcNahW0+LURV4Kt5jwvLSLBy++TJ0060eSeG04r
	 U9qDQYj7lMRqcnBKuUoYCeFZMnedtySqmTLKKd+H+XTtfz1KBvR9H2P13C2HRXnJH0Xyr
	 OfnPnXf3SX7cMWWWPMgXPyu/0iJQn6gv8d7YoewL1z93M6zYTQP+96+ntXPbpP1z9OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DemJhX7H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A44606D81C
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 19:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DemJhX7H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1973A1F00A17
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 19:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793649308;
	bh=D9RKiKZIKboaVdkB4sjOX/RcCW0RWe2D+hJi9iS+b68=;
	h=From:To:Subject:Date;
	b=DemJhX7H5tDPgSAZqkbZSOLSg9UcMMIK3wHMu2GsvWtinuaMymcSfTIXGu+mcQyJ1
	 I6sKzXptdiNgmXk8t79Xe4Qr15sWxSQGYJ716Sw0vy5+mXLG9GiExtgRhlzVWqDdVb
	 J3SLGg+ivLrlGVeeK11lo7QlNYPeHMMf8S5nhwI1dvZqeSoLJOC5q9A5B2vwP/1Fb1
	 mIimOdZGoYl7xdpn62nb3GMR5+iTERpiijbxsCziqgwcR+LsjzrrTdcdseuKfCMo+z
	 Mmnm4zOahaHdmiEf2oVxghLf8KpHzRPuX7ktIxqEyHH3cIZfqPvzOgx3QQZcAiUfCd
	 3acqaVex6yzvQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: dont propagate nodatacow mount option on files with inherited compression
Date: Mon,  2 Nov 2026 19:55:04 +0000
Message-ID: <1c729c63075e727042efdeb07df10a70b0ba1a0d.1793647368.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we set the compression property on a directory and the filesystem was
mounted with the nodatacow option, then when creating a file under that
directory we get both the compression and nodatacow attributes set on the
file. These are incompatible attributes as compression requires COW.

This has a couple unexpected behaviours:

1) If later a user sets another attribute on the file, like immutability
   or append writing mode for example, the chattr command will fail with
   -EINVAL since we in the setattr callback (btrfs_fileattr_set()) we do
   some validation, through a call to check_fsflags(), that rejects having
   both the nodatacow and compression flags set.

   I.e, doing a simple:

     $ chattr +i file
     /usr/bin/chattr: Invalid argument while setting flags on file

2) The file ends up not being compressed, which is unexpected since the
   compression attribute set on a directory/file should have precedence
   over the global nodatacow mount option.

Example reproducer:

   $ cat test.sh
   #!/bin/bash

   DEV=/dev/sdi
   MNT=/mnt/sdi

   mkfs.btrfs -f $DEV
   mount -o nodatacow $DEV $MNT

  # Create a directory with the compression attribute, so that all files
  # created under it inherit the compression attribute.
  mkdir $MNT/dir
  chattr +c $MNT/dir

  # Now create a file with some data inside the directory.
  xfs_io -f -c "pwrite 0 128K" $MNT/dir/foo

  # Now try to make the file immutable, it should work.
  chattr +i $MNT/dir/foo

  umount $MNT

  # Check the file has a compressed extent. It should have since
  # despite the fs being mounted with nodatacow, the directory has
  # the compression flag set and so that should take priority and
  # it's what makes sense.
  btrfs inspect-internal dump-tree -t 5 $DEV | grep -A 5 'EXTENT_DATA 0'

Running it:

  $ ./test.sh
  (...)
  chattr: Invalid argument while setting flags on /mnt/sdi/dir/foo
        item 11 key (258 EXTENT_DATA 0) itemoff 15529 itemsize 53
             generation 9 type 1 (regular)
             extent data disk byte 13631488 nr 131072
             extent data offset 0 nr 131072 ram 131072
             extent compression 0 (none)
             extent encryption 0

Fix this by updating btrfs_create_new_inode() to not apply the mount
options nodatacow and nodatasum on a file that has inherited compression
from its parent directory.

A test case will follow soon for fstests.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b071ed59a583..95455821ea02 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6654,11 +6654,20 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 
 	btrfs_set_inode_mapping_order(BTRFS_I(inode));
 	if (S_ISREG(inode->i_mode)) {
-		if (btrfs_test_opt(fs_info, NODATASUM))
-			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
-		if (btrfs_test_opt(fs_info, NODATACOW))
-			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW |
-				BTRFS_INODE_NODATASUM;
+		/*
+		 * If we inherited compression from the parent directory, it
+		 * takes precedence to nodatacow/nodatasum and we don't set
+		 * compression along with nodatacow/nodatasun, otherwise if a
+		 * user attempts to change some other attribute (say chattr +i),
+		 * it will fail at -EINVAL.
+		 */
+		if (!(BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS)) {
+			if (btrfs_test_opt(fs_info, NODATASUM))
+				BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
+			if (btrfs_test_opt(fs_info, NODATACOW))
+				BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW |
+					BTRFS_INODE_NODATASUM;
+		}
 		btrfs_update_inode_mapping_flags(BTRFS_I(inode));
 	}
 
-- 
2.53.0

