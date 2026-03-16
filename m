Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ADC39C629
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677668; cv=none; b=Bhun/f746QzTyJSzup+5e6ZamrfQPOlbpbeM91myahp9NmyzV2i+9zXHemBXY0OVaEPiVQR6tixKLwXzjp4nju2vxEMyGXFDXLNtjgqYoEm9LZOeVOuX9isl7HCR8lN1b4zsGvfDj4ya60VF6dGqL1/xwBI5Vm+KY8yT6mz3F1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677668; c=relaxed/simple;
	bh=JFsb6LVB7/vuLUhojnMWAxnoKjitchHDOvmg6GLOEsQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAoyUegxZcH7JIy1k4WZvMX18fjzWq5eJmObtmZgGAS9LZ2FAOAiZPi+mMdI05LSltGEjOOxlktp2/jTsTxI+s31z7V5rGmD+gMR8gZfaQOMNm3cACFVOMm05EMQvZj6ZJCZcNMNLhhESkqyxNfqtjTf1Mu8CgAmbVpbbOhy5GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BeJIINRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BeJIINRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D1CC2BCB0
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677668;
	bh=JFsb6LVB7/vuLUhojnMWAxnoKjitchHDOvmg6GLOEsQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BeJIINRJPwY/5HhzD0XO8rjZI57OPRXxSTSYO8TZhGAj2E1/C0hElKBz3kYmQu+Du
	 zpcz3ztegpe6KDqPx6LyrR/t9phIf5dq6LBLDxBnhTJQ+3UsVGovG1An3YJFaiocAM
	 oTJOM2RY1/ta/7nc16jvXwIOB6YmbUkg+otlPwzCBiZqo421GH19idIWWwtt+cqrQ5
	 2vTREAd1gPsy1cUekEFipLwoXHFRnQhqzYlMPvZj1Bk9wIdFnNMnuQcNsDTB5npUL0
	 U4582du409hX78gcXLZYV+wdDovs/AXqnLn+ykWy4iEE1dHDTcMeOdhrBuOhO4Y75J
	 NqiKrLCSgURYg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/11] btrfs: optimize clearing all bits from first extent record in an io tree
Date: Mon, 16 Mar 2026 16:14:14 +0000
Message-ID: <0d67db136c383b20035dc926d0c0616f9d305554.1773676775.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1773676775.git.fdmanana@suse.com>
References: <cover.1773676775.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

When we are clearing all the bits from the first record that contains the
target range and that record ends at or before our target range but starts
before our target range, we are doing a lot of unnecessary work:

1) Allocating a prealloc state if we don't have one already;

2) Adjust that record's start offset to the start of our range and
   make the prealloc state have a range going from the original start
   offset of that first record to the start offset of our target range,
   and with the same bits as that first record. Then we insert the
   prealloc extent in the rbtree - this is done in split_state();

3) Remove our adjusted first state from the rbtree since all the bits
   were cleared - this is done in clear_state_bit().

This is only wasting time when we can simply trim that first record, so
that it represents the range from its start offset to the start offset of
our target range. So optimize for that case and avoid the prealloc state
allocation, insertion and deletion from the rbtree.

This patch is the last patch of a patchset comprised of the following
patches (in descending order):

  btrfs: optimize clearing all bits from first extent record in an io tree
  btrfs: panic instead of warn when splitting extent state not in the tree
  btrfs: free cached state outside critical section in wait_extent_bit()
  btrfs: avoid unnecessary wake ups on io trees when there are no waiters
  btrfs: remove wake parameter from clear_state_bit()
  btrfs: change last argument of add_extent_changeset() to boolean
  btrfs: use extent_io_tree_panic() instead of BUG_ON()
  btrfs: make add_extent_changeset() only return errors or success
  btrfs: tag as unlikely branches that call extent_io_tree_panic()
  btrfs: turn extent_io_tree_panic() into a macro for better error reporting
  btrfs: optimize clearing all bits from the last extent record in an io tree

The following fio script was used to measure performance before and after
applying all the patches:

  $ cat ./fio-io-uring-2.sh
  #!/bin/bash

  DEV=/dev/nullb0
  MNT=/mnt/nullb0
  MOUNT_OPTIONS="-o ssd"
  MKFS_OPTIONS=""

  if [ $# -ne 3 ]; then
      echo "Use $0 NUM_JOBS FILE_SIZE RUN_TIME"
      exit 1
  fi

  NUM_JOBS=$1
  FILE_SIZE=$2
  RUN_TIME=$3

  cat <<EOF > /tmp/fio-job.ini
  [io_uring_rw]
  rw=randwrite
  fsync=0
  fallocate=none
  group_reporting=1
  direct=1
  ioengine=io_uring
  fixedbufs=1
  iodepth=64
  bs=4K
  filesize=$FILE_SIZE
  runtime=$RUN_TIME
  time_based
  filename=foobar
  directory=$MNT
  numjobs=$NUM_JOBS
  thread
  EOF

  echo performance | \
      tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

  echo
  echo "Using config:"
  echo
  cat /tmp/fio-job.ini
  echo

  umount $MNT &> /dev/null
  mkfs.btrfs -f $MKFS_OPTIONS $DEV &> /dev/null
  mount $MOUNT_OPTIONS $DEV $MNT

  fio /tmp/fio-job.ini

  umount $MNT

When running this script on a 12 cores machine using a 16G null block
device the results were the following:

Before patchset:

  $ ./fio-io-uring-2.sh 12 8G 60
  (...)
  WRITE: bw=74.8MiB/s (78.5MB/s), 74.8MiB/s-74.8MiB/s (78.5MB/s-78.5MB/s), io=4504MiB (4723MB), run=60197-60197msec

After patchset:

  $ ./fio-io-uring-2.sh 12 8G 60
  (...)
  WRITE: bw=82.2MiB/s (86.2MB/s), 82.2MiB/s-82.2MiB/s (86.2MB/s-86.2MB/s), io=4937MiB (5176MB), run=60027-60027msec

Also, using bpftrace to collect the duration (in nanoseconds) of all the
btrfs_clear_extent_bit_changeset() calls done during that fio test and
then making an histogram from that data, held the following results:

Before patchset:

  Count: 6304804
  Range:  0.000 - 7587172.000; Mean: 2011.308; Median: 1219.000; Stddev: 17117.533
  Percentiles:  90th: 1888.000; 95th: 2189.000; 99th: 16104.000
        0.000 -    8.098:        7 |
        8.098 -   40.385:       20 |
       40.385 -  187.254:      146 |
      187.254 -  855.347:   742048 #######
      855.347 - 3894.426:  5462542 #####################################################
     3894.426 - 17718.848:   41489 |
    17718.848 - 80604.558:   46085 |
    80604.558 - 366664.449:  11285 |
   366664.449 - 1667918.122:   961 |
  1667918.122 - 7587172.000:   113 |

After patchset:

  Count: 6282879
  Range:  0.000 - 6029290.000; Mean: 1896.482; Median: 1126.000; Stddev: 15276.691
  Percentiles:  90th: 1741.000; 95th: 2026.000; 99th: 15713.000
        0.000 - 60.014:         12 |
       60.014 - 217.984:        63 |
      217.984 - 784.949:    517515 #####
      784.949 - 2819.823:  5632335 #####################################################
     2819.823 - 10123.127:   55716 #
    10123.127 - 36335.184:   46034 |
    36335.184 - 130412.049:  25708 |
   130412.049 - 468060.350:   4824 |
   468060.350 - 1679903.189:   549 |
  1679903.189 - 6029290.000:    84 |

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-io-tree.c | 44 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 72ddd8d2e7a3..6ae7709cba23 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -635,6 +635,7 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 	int ret = 0;
 	bool clear;
 	const bool delete = (bits & EXTENT_CLEAR_ALL_BITS);
+	const u32 bits_to_clear = (bits & ~EXTENT_CTLBITS);
 	gfp_t mask;
 
 	set_gfp_mask_from_bits(&bits, &mask);
@@ -712,6 +713,47 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 	 */
 
 	if (state->start < start) {
+		/*
+		 * If all bits are cleared, there's no point in allocating or
+		 * using the prealloc extent, split the state record, insert the
+		 * prealloc record and then remove this record. We can just
+		 * adjust this record and move on to the next without adding or
+		 * removing anything to the tree.
+		 */
+		if (state->end <= end && (state->state & ~bits_to_clear) == 0) {
+			const u64 orig_start = state->start;
+
+			if (tree->owner == IO_TREE_INODE_IO)
+				btrfs_split_delalloc_extent(tree->inode, state, start);
+
+			/*
+			 * Temporarilly ajdust this state's range to match the
+			 * range for which we are clearing bits.
+			 */
+			state->start = start;
+
+			ret = add_extent_changeset(state, bits_to_clear, changeset, false);
+			if (unlikely(ret < 0)) {
+				extent_io_tree_panic(tree, state,
+						     "add_extent_changeset", ret);
+				goto out;
+			}
+
+			if (tree->owner == IO_TREE_INODE_IO)
+				btrfs_clear_delalloc_extent(tree->inode, state, bits);
+
+			/*
+			 * Now adjust the range to the section for which no bits
+			 * are cleared.
+			 */
+			state->start = orig_start;
+			state->end = start - 1;
+
+			state_wake_up(tree, state, bits);
+			state = next_search_state(state, end);
+			goto next;
+		}
+
 		prealloc = alloc_extent_state_atomic(prealloc);
 		if (!prealloc)
 			goto search_again;
@@ -739,8 +781,6 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 	 * We need to split the extent, and clear the bit on the first half.
 	 */
 	if (state->start <= end && state->end > end) {
-		const u32 bits_to_clear = bits & ~EXTENT_CTLBITS;
-
 		/*
 		 * If all bits are cleared, there's no point in allocating or
 		 * using the prealloc extent, split the state record, insert the
-- 
2.47.2

