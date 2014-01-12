Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:57280 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaALC1s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 21:27:48 -0500
Received: by mail-we0-f169.google.com with SMTP id u57so5297497wes.14
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jan 2014 18:27:47 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: fix send to not send non-aligned clone operations
Date: Sun, 12 Jan 2014 02:26:28 +0000
Message-Id: <1389493588-2270-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1389475772-19286-1-git-send-email-fdmanana@gmail.com>
References: <1389475772-19286-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is possible for the send feature to send clone operations that
request a cloning range (offset + length) that is not aligned with
the block size. This makes the btrfs receive command send issue a
clone ioctl call that will fail, as the ioctl will return an -EINVAL
error because of the unaligned range.

Fix this by not sending clone operations for non block aligned ranges,
and instead send regular write operation for these (less common) cases.

The following xfstest reproduces this issue, which fails on the second
btrfs receive command without this change:

  seq=`basename $0`
  seqres=$RESULT_DIR/$seq
  echo "QA output created by $seq"

  tmp=`mktemp -d`

  status=1	# failure is the default!
  trap "_cleanup; exit \$status" 0 1 2 3 15

  _cleanup()
  {
      rm -fr $tmp
  }

  # get standard environment, filters and checks
  . ./common/rc
  . ./common/filter

  # real QA test starts here
  _supported_fs btrfs
  _supported_os Linux
  _require_scratch
  _need_to_be_root

  rm -f $seqres.full

  _scratch_mkfs >/dev/null 2>&1
  _scratch_mount

  $XFS_IO_PROG -f -c "truncate 819200" $SCRATCH_MNT/foo | _filter_xfs_io
  $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch

  $XFS_IO_PROG -c "falloc -k 819200 667648" $SCRATCH_MNT/foo | _filter_xfs_io
  $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch

  $XFS_IO_PROG -f -c "pwrite 1482752 2978" $SCRATCH_MNT/foo | _filter_xfs_io
  $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch

  $BTRFS_UTIL_PROG subvol snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1 | \
      _filter_scratch

  $XFS_IO_PROG -f -c "truncate 883305" $SCRATCH_MNT/foo | _filter_xfs_io
  $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch

  $BTRFS_UTIL_PROG subvol snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2 | \
      _filter_scratch

  $BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap 2>&1 | _filter_scratch
  $BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
      -f $tmp/2.snap 2>&1 | _filter_scratch

  md5sum $SCRATCH_MNT/foo | _filter_scratch
  md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
  md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch

  _scratch_unmount
  _check_btrfs_filesystem $SCRATCH_DEV
  _scratch_mkfs >/dev/null 2>&1
  _scratch_mount

  $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/1.snap
  md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch

  $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/2.snap
  md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch

  _scratch_unmount
  _check_btrfs_filesystem $SCRATCH_DEV

  status=0
  exit

The tests expected output is:

  QA output created by 025
  FSSync 'SCRATCH_MNT'
  FSSync 'SCRATCH_MNT'
  wrote 2978/2978 bytes at offset 1482752
  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
  FSSync 'SCRATCH_MNT'
  Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/mysnap1'
  FSSync 'SCRATCH_MNT'
  Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/mysnap2'
  At subvol SCRATCH_MNT/mysnap1
  At subvol SCRATCH_MNT/mysnap2
  129b8eaee8d3c2bcad49bec596591cb3  SCRATCH_MNT/foo
  42b6369eae2a8725c1aacc0440e597aa  SCRATCH_MNT/mysnap1/foo
  129b8eaee8d3c2bcad49bec596591cb3  SCRATCH_MNT/mysnap2/foo
  At subvol mysnap1
  42b6369eae2a8725c1aacc0440e597aa  SCRATCH_MNT/mysnap1/foo
  At snapshot mysnap2
  129b8eaee8d3c2bcad49bec596591cb3  SCRATCH_MNT/mysnap2/foo

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: simpler/shorter version.

 fs/btrfs/send.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 591063d..84aed2f 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3761,6 +3761,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
 	u64 len;
 	u32 l;
 	u8 type;
+	u64 bs = sctx->send_root->fs_info->sb->s_blocksize;
 
 	ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
 			struct btrfs_file_extent_item);
@@ -3784,7 +3785,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
 		goto out;
 	}
 
-	if (clone_root) {
+	if (clone_root && IS_ALIGNED(offset + len, bs)) {
 		ret = send_clone(sctx, offset, len, clone_root);
 	} else if (sctx->flags & BTRFS_SEND_FLAG_NO_FILE_DATA) {
 		ret = send_update_extent(sctx, offset, len);
-- 
1.7.9.5

