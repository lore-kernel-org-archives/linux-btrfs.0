Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0844D282F0E
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 12:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724117; cv=none; b=pI+5jeucKjdAZ+ZZbVSUKYfsraJkNqi2/ZGdLR/d4NfNpaAkAAIAvTs6zjP1PY3jILVQyoVICV09udr0SjB0MwyKIZNHywH95NYmxVW7ga6zMN0fgOjb+XNRGBl5zmBaiUgJlv/Ce2KSSq6ZIWZdMas/wq8rOWjgHtYb18FOwG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724117; c=relaxed/simple;
	bh=74dFqjQEcEMfcFuKR4l/RKgZ49f7BIP8xujY5cV5xow=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0efqRBguHenOScxEeIC6LO2TsCgfXrBNNYkRezMGou3QU3LR3cM77A7dzpVPZflIWBKDtVfKbILiN7nHAEsyM0OPUhtLDYw8jHBvEXIc4+3o0q+FazGLB6U8Eo/IrUescWXTVdLJi/3cP/A8CqazGHPbsE0suhlCU4zjPQ2fwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DLVidI+E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DLVidI+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67A71F00A3E
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 12:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784724109;
	bh=7NapPeufXrQDb7NCN/nqsdayxHBCm4yH1X1R3dij4Pw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=DLVidI+E87hzK20+eHytMVUExYn6G0OnkczbF8Cz68kuhsJsv/RE2VFE7HKhviMN3
	 F4XaCoFnxWBzZKtjhXvMhmpWuhz3EMCRz4uDoL1NKOQuvKwMbjgawvvxH/0mn1mtPv
	 +5+D+Hi/pR6esijrQCGrX5D0w/m4L3jFIPwFswfGquZFybFKIt9DMMmAAPGx9JVxBQ
	 0DVGxESYmiBsKLeY5S0m0ujq6a2ugfS+Q+3nHcxuysGKUSsfocC4QhkRQ/LN28ZM3t
	 WpncPd2+G5mFqvz/01zJGUYpRQKvnss1lQwYxknAS6lg1KJeDHI+eFJzH76L2BlAbn
	 velFcb4BeR92w==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/7] btrfs: do an initial lockless committed log transaction check during log syncing
Date: Wed, 22 Jul 2026 13:41:39 +0100
Message-ID: <e3e5b937d269982a826ec1b8f65351883e1b5d48.1784656641.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1784656641.git.fdmanana@suse.com>
References: <cover.1784656641.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

When calling btrfs_sync_log() one of the things we do first is to check if
the log transaction the given context belongs to was already committed
and return immediately if it was committed before. However we take the
root's log_mutex before doing the check, which adds lock contention in
case the log transaction was already committed, as this is a heavily used
mutex in case we have multiple tasks doing fsyncs or renaming and adding
hard links to files that were fsynced before in the current transaction.

So add an initial lockless check in btrfs_sync_log() to reduce lock
contention.

The following fio test was used to benchmark:

  $ cat fio-buffered-fsync.sh
  DEV=/dev/sdj
  MNT=/mnt/sdj
  MOUNT_OPTIONS=""
  MKFS_OPTIONS=""

  if [ $# -ne 6 ]; then
     echo "Use $0 NUM_JOBS FILE_SIZE IO_SIZE FSYNC_FREQ BLOCK_SIZE [write|randwrite]"
     exit 1
  fi

  NUM_JOBS=$1
  FILE_SIZE=$2
  IO_SIZE=$3
  FSYNC_FREQ=$4
  BLOCK_SIZE=$5
  WRITE_MODE=$6

  if [ "$WRITE_MODE" != "write" ] && [ "$WRITE_MODE" != "randwrite" ]; then
     echo "Invalid WRITE_MODE, must be 'write' or 'randwrite'"
     exit 1
  fi

  cat <<EOF > /tmp/fio-job.ini
  [writers]
  rw=$WRITE_MODE
  fsync=$FSYNC_FREQ
  fallocate=none
  group_reporting=1
  direct=0
  bs=$BLOCK_SIZE
  ioengine=psync
  filesize=$FILE_SIZE
  io_size=$IO_SIZE
  directory=$MNT
  numjobs=$NUM_JOBS
  EOF

  echo
  echo "Using config:"
  echo
  cat /tmp/fio-job.ini
  echo

  umount $MNT &> /dev/null
  mkfs.btrfs -f $MKFS_OPTIONS $DEV
  mount $MOUNT_OPTIONS $DEV $MNT

  fio /tmp/fio-job.ini
  umount $MNT

Running the script as:  ./fio-buffered-fsync.sh 12 64M 64M 1 4K randwrite

Before patch:

  WRITE: bw=16.6MiB/s (17.4MB/s), 16.6MiB/s-16.6MiB/s (17.4MB/s-17.4MB/s), io=768MiB (805MB), run=46235-46235msec

After patch:

  WRITE: bw=18.2MiB/s (19.0MB/s), 18.2MiB/s-18.2MiB/s (19.0MB/s-19.0MB/s), io=768MiB (805MB), run=42277-42277msec

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 580f2aabc065..191308982e9c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3306,15 +3306,21 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	struct btrfs_root *log = root->log_root;
 	struct btrfs_root *log_root_tree = fs_info->log_root_tree;
 	struct btrfs_root_item new_root_item;
-	int log_transid = 0;
+	int log_transid = ctx->log_transid;
 	struct btrfs_log_ctx root_log_ctx;
 	struct blk_plug plug;
 	u64 log_root_start;
 	u64 log_root_level;
 
+	/* Avoid fist taking root->log_mutex, reduce lock contention. */
+	if (data_race(root->log_transid_committed) >= log_transid) {
+		trace_btrfs_sync_log_enter(trans, root, ctx);
+		trace_btrfs_sync_log_exit(trans, root, ctx, ctx->log_ret);
+		return ctx->log_ret;
+	}
+
 	mutex_lock(&root->log_mutex);
 	trace_btrfs_sync_log_enter(trans, root, ctx);
-	log_transid = ctx->log_transid;
 	if (root->log_transid_committed >= log_transid) {
 		trace_btrfs_sync_log_exit(trans, root, ctx, ctx->log_ret);
 		mutex_unlock(&root->log_mutex);
-- 
2.47.2

