Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34129 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbbJHAYL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Oct 2015 20:24:11 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v3] Btrfs: send, fix file corruption due to incorrect cloning operations
Date: Thu,  8 Oct 2015 01:23:57 +0100
Message-Id: <1444263837-24717-1-git-send-email-fdmanana@kernel.org>
In-Reply-To: <1443781092-18870-1-git-send-email-fdmanana@kernel.org>
References: <1443781092-18870-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

If we have a file that shares an extent with other files, when processing
the extent item relative to a shared extent, we blindly issue a clone
operation that will target a length matching the length in the extent item
and uses as a source some other file the receiver already has and points
to the same extent. However that range in the other file might not
exclusively point only to the shared extent, and so using that length
will result in the receiver getting a file with different data from the
one in the send snapshot. This issue happened both for incremental and
full send operations.

So fix this by issuing clone operations with lengths that don't cover
regions of the source file that point to different extents (or have holes).

The following test case for fstests reproduces the problem.

  seq=`basename $0`
  seqres=$RESULT_DIR/$seq
  echo "QA output created by $seq"

  tmp=/tmp/$$
  status=1	# failure is the default!
  trap "_cleanup; exit \$status" 0 1 2 3 15

  _cleanup()
  {
      rm -fr $send_files_dir
      rm -f $tmp.*
  }

  # get standard environment, filters and checks
  . ./common/rc
  . ./common/filter

  # real QA test starts here
  _supported_fs btrfs
  _supported_os Linux
  _require_scratch
  _need_to_be_root
  _require_cp_reflink
  _require_xfs_io_command "fpunch"

  send_files_dir=$TEST_DIR/btrfs-test-$seq

  rm -f $seqres.full
  rm -fr $send_files_dir
  mkdir $send_files_dir

  _scratch_mkfs >>$seqres.full 2>&1
  _scratch_mount

  # Create our test file with a single 100K extent.
  $XFS_IO_PROG -f -c "pwrite -S 0xaa 0K 100K" \
     $SCRATCH_MNT/foo | _filter_xfs_io

  # Clone our file into a new file named bar.
  cp --reflink=always $SCRATCH_MNT/foo $SCRATCH_MNT/bar

  # Now overwrite parts of our foo file.
  $XFS_IO_PROG -c "pwrite -S 0xbb 50K 10K" \
     -c "pwrite -S 0xcc 90K 10K" \
     -c "fpunch 70K 10k" \
     $SCRATCH_MNT/foo | _filter_xfs_io

  _run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT \
     $SCRATCH_MNT/snap

  echo "File digests in the original filesystem:"
  md5sum $SCRATCH_MNT/snap/foo | _filter_scratch
  md5sum $SCRATCH_MNT/snap/bar | _filter_scratch

  _run_btrfs_util_prog send $SCRATCH_MNT/snap -f $send_files_dir/1.snap

  # Now recreate the filesystem by receiving the send stream and verify
  # we get the same file contents that the original filesystem had.
  _scratch_unmount
  _scratch_mkfs >>$seqres.full 2>&1
  _scratch_mount

  _run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap

  # We expect the destination filesystem to have exactly the same file
  # data as the original filesystem.
  # The btrfs send implementation had a bug where it sent a clone
  # operation from file foo into file bar covering the whole [0, 100K[
  # range after creating and writing the file foo. This was incorrect
  # because the file bar now included the updates done to file foo after
  # we cloned foo to bar, breaking the COW nature of reflink copies
  # (cloned extents).
  echo "File digests in the new filesystem:"
  md5sum $SCRATCH_MNT/snap/foo | _filter_scratch
  md5sum $SCRATCH_MNT/snap/bar | _filter_scratch

  status=0
  exit

Another test case that exercises a different scenario, where the source
range (the file we clone from) does not point to the beginning of the
extent we intend to clone, that is, there's an offset against the shared
extent, is the following:

  seq=`basename $0`
  seqres=$RESULT_DIR/$seq
  echo "QA output created by $seq"

  tmp=/tmp/$$
  status=1	# failure is the default!
  trap "_cleanup; exit \$status" 0 1 2 3 15

  _cleanup()
  {
      rm -fr $send_files_dir
      rm -f $tmp.*
  }

  # get standard environment, filters and checks
  . ./common/rc
  . ./common/filter

  # real QA test starts here
  _supported_fs btrfs
  _supported_os Linux
  _require_scratch
  _need_to_be_root
  _require_cloner

  send_files_dir=$TEST_DIR/btrfs-test-$seq

  rm -f $seqres.full
  rm -fr $send_files_dir
  mkdir $send_files_dir

  _scratch_mkfs >>$seqres.full 2>&1
  _scratch_mount "-o compress"

  # Create file foo first, so that it has a lower inode number than file
  # bar. Btrfs send processes inodes in ascending order.
  touch $SCRATCH_MNT/foo

  $XFS_IO_PROG -f -c "pwrite -S 0xaa 630K 20K" $SCRATCH_MNT/bar \
     | _filter_xfs_io

  # Clone the whole extent into file foo.
  $CLONER_PROG -s $((540 * 1024)) -d $((200 * 1024)) -l 0 \
      $SCRATCH_MNT/bar $SCRATCH_MNT/foo

  # After this write our file foo will reference the extent with a file
  # extent item that starts at offset 300K, has a length of 8K and a data
  # offset of 12K. So after this write file foo no longer refers to the
  # first 12K of the extent we cloned before from file bar.
  $XFS_IO_PROG -c "pwrite -S 0xcc 200K 100K" $SCRATCH_MNT/foo \
      | _filter_xfs_io

  # Append some data to file foo. This is just to verify later that the
  # send stream does not include clone operations for any of these data
  # for file bar.
  $XFS_IO_PROG -c "pwrite -S 0xbb 400K 100K" $SCRATCH_MNT/foo \
      | _filter_xfs_io

  # Append some data to file bar. This is to verify later that the send
  # stream included these data for file bar.
  $XFS_IO_PROG -c "pwrite -S 0xdd 650K 100K" $SCRATCH_MNT/bar \
      | _filter_xfs_io

  _run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT \
      $SCRATCH_MNT/snap

  echo "File digests in the original filesystem:"
  md5sum $SCRATCH_MNT/snap/foo | _filter_scratch
  md5sum $SCRATCH_MNT/snap/bar | _filter_scratch

  _run_btrfs_util_prog send $SCRATCH_MNT/snap -f $send_files_dir/1.snap

  # Now recreate the filesystem by receiving the send stream and verify
  # we get the same file contents that the original filesystem had.
  # Btrfs send had a bug where it sent a clone operation from file foo
  # to bar that covered the range from file foo [300K, 308K[ into file
  # bar's range [630K, 638K[ with the intention of cloning the whole
  # extent that was cloned before. That was incorrect because file foo
  # no longer pointed to the first 12K of the 20K extent that was
  # originally cloned from file bar.
  _scratch_unmount
  _scratch_mkfs >>$seqres.full 2>&1
  _scratch_mount "-o compress"

  _run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap

  echo "File digests in the new filesystem:"
  # Must match the digests we got in the original filesystem.
  md5sum $SCRATCH_MNT/snap/foo | _filter_scratch
  md5sum $SCRATCH_MNT/snap/bar | _filter_scratch

  status=0
  exit

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Fixed implicit hole detection, use 'clone_root->offset' instead of
    'offset' to track the next expected key offset.

V3: Deal with the case where the source file range we're cloning from
    points to the shared extent but with a positive offset and we're
    interested in cloning the data up to that offset. We need to check
    not only the disk bytenr in extent items from the source file's range
    but also their data offsets. Include a new test case to exercise
    this corner case.

 fs/btrfs/send.c | 190 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 173 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index a739b82..13c6941 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4687,6 +4687,171 @@ tlv_put_failure:
 	return ret;
 }
 
+static int send_extent_data(struct send_ctx *sctx,
+			    const u64 offset,
+			    const u64 len)
+{
+	u64 sent = 0;
+
+	if (sctx->flags & BTRFS_SEND_FLAG_NO_FILE_DATA)
+		return send_update_extent(sctx, offset, len);
+
+	while (sent < len) {
+		u64 size = len - sent;
+		int ret;
+
+		if (size > BTRFS_SEND_READ_SIZE)
+			size = BTRFS_SEND_READ_SIZE;
+		ret = send_write(sctx, offset + sent, size);
+		if (ret < 0)
+			return ret;
+		if (!ret)
+			break;
+		sent += ret;
+	}
+	return 0;
+}
+
+static int clone_range(struct send_ctx *sctx,
+		       struct clone_root *clone_root,
+		       const u64 disk_byte,
+		       u64 data_offset,
+		       u64 offset,
+		       u64 len)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret;
+
+	path = alloc_path_for_send();
+	if (!path)
+		return -ENOMEM;
+
+	/*
+	 * We can't send a clone operation for the entire range if we find
+	 * extent items in the respective range in the source file that
+	 * refer to different extents or if we find holes.
+	 * So check for that and do a mix of clone and regular write/copy
+	 * operations if needed.
+	 *
+	 * Example:
+	 *
+	 * mkfs.btrfs -f /dev/sda
+	 * mount /dev/sda /mnt
+	 * xfs_io -f -c "pwrite -S 0xaa 0K 100K" /mnt/foo
+	 * cp --reflink=always /mnt/foo /mnt/bar
+	 * xfs_io -c "pwrite -S 0xbb 50K 50K" /mnt/foo
+	 * btrfs subvolume snapshot -r /mnt /mnt/snap
+	 *
+	 * If when we send the snapshot and we are processing file bar (which
+	 * has a higher inode number than foo) we blindly send a clone operation
+	 * for the [0, 100K[ range from foo to bar, the receiver ends up getting
+	 * a file bar that matches the content of file foo - iow, doesn't match
+	 * the content from bar in the original filesystem.
+	 */
+	key.objectid = clone_root->ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = clone_root->offset;
+	ret = btrfs_search_slot(NULL, clone_root->root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	if (ret > 0 && path->slots[0] > 0) {
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0] - 1);
+		if (key.objectid == clone_root->ino &&
+		    key.type == BTRFS_EXTENT_DATA_KEY)
+			path->slots[0]--;
+	}
+
+	while (true) {
+		struct extent_buffer *leaf = path->nodes[0];
+		int slot = path->slots[0];
+		struct btrfs_file_extent_item *ei;
+		u8 type;
+		u64 ext_len;
+		u64 clone_len;
+
+		if (slot >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(clone_root->root, path);
+			if (ret < 0)
+				goto out;
+			else if (ret > 0)
+				break;
+			continue;
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+
+		/*
+		 * We might have an implicit trailing hole (NO_HOLES feature
+		 * enabled). We deal with it after leaving this loop.
+		 */
+		if (key.objectid != clone_root->ino ||
+		    key.type != BTRFS_EXTENT_DATA_KEY)
+			break;
+
+		ei = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
+		type = btrfs_file_extent_type(leaf, ei);
+		if (type == BTRFS_FILE_EXTENT_INLINE) {
+			ext_len = btrfs_file_extent_inline_len(leaf, slot, ei);
+			ext_len = PAGE_CACHE_ALIGN(ext_len);
+		} else {
+			ext_len = btrfs_file_extent_num_bytes(leaf, ei);
+		}
+
+		if (key.offset + ext_len <= clone_root->offset)
+			goto next;
+
+		if (key.offset > clone_root->offset) {
+			/* Implicit hole, NO_HOLES feature enabled. */
+			u64 hole_len = key.offset - clone_root->offset;
+
+			if (hole_len > len)
+				hole_len = len;
+			ret = send_extent_data(sctx, offset, hole_len);
+			if (ret < 0)
+				goto out;
+
+			len -= hole_len;
+			if (len == 0)
+				break;
+			offset += hole_len;
+			clone_root->offset += hole_len;
+			data_offset += hole_len;
+		}
+
+		if (key.offset >= clone_root->offset + len)
+			break;
+
+		clone_len = min_t(u64, ext_len, len);
+
+		if (btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte &&
+		    btrfs_file_extent_offset(leaf, ei) == data_offset)
+			ret = send_clone(sctx, offset, clone_len, clone_root);
+		else
+			ret = send_extent_data(sctx, offset, clone_len);
+
+		if (ret < 0)
+			goto out;
+
+		len -= clone_len;
+		if (len == 0)
+			break;
+		offset += clone_len;
+		clone_root->offset += clone_len;
+		data_offset += clone_len;
+next:
+		path->slots[0]++;
+	}
+
+	if (len > 0)
+		ret = send_extent_data(sctx, offset, len);
+	else
+		ret = 0;
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 static int send_write_or_clone(struct send_ctx *sctx,
 			       struct btrfs_path *path,
 			       struct btrfs_key *key,
@@ -4695,9 +4860,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
 	int ret = 0;
 	struct btrfs_file_extent_item *ei;
 	u64 offset = key->offset;
-	u64 pos = 0;
 	u64 len;
-	u32 l;
 	u8 type;
 	u64 bs = sctx->send_root->fs_info->sb->s_blocksize;
 
@@ -4725,22 +4888,15 @@ static int send_write_or_clone(struct send_ctx *sctx,
 	}
 
 	if (clone_root && IS_ALIGNED(offset + len, bs)) {
-		ret = send_clone(sctx, offset, len, clone_root);
-	} else if (sctx->flags & BTRFS_SEND_FLAG_NO_FILE_DATA) {
-		ret = send_update_extent(sctx, offset, len);
+		u64 disk_byte;
+		u64 data_offset;
+
+		disk_byte = btrfs_file_extent_disk_bytenr(path->nodes[0], ei);
+		data_offset = btrfs_file_extent_offset(path->nodes[0], ei);
+		ret = clone_range(sctx, clone_root, disk_byte, data_offset,
+				  offset, len);
 	} else {
-		while (pos < len) {
-			l = len - pos;
-			if (l > BTRFS_SEND_READ_SIZE)
-				l = BTRFS_SEND_READ_SIZE;
-			ret = send_write(sctx, pos + offset, l);
-			if (ret < 0)
-				goto out;
-			if (!ret)
-				break;
-			pos += ret;
-		}
-		ret = 0;
+		ret = send_extent_data(sctx, offset, len);
 	}
 out:
 	return ret;
-- 
2.1.3

