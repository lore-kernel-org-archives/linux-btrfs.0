Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F919387378
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 15:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784733895; cv=none; b=nNntrirzIpVJQzbIRwUUx7vZp2qHy5r9SX9hnGG1hErVTgbUgFLaNDDNNvOUfpuE0tNAsi52G9l/eRxIh2do3p2Zt2McI8qwteDGFhcykZgSDjAIA1whQlWPP4tD4CpvHqv2j0tjlCb13eyeff1wTrq/qL3+KD+Tcc5amEgm8vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784733895; c=relaxed/simple;
	bh=bY++5UZjUjIijY2DmkqIy/eGJls2u0cViyNIn7QclQk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6QoBP3CZIrUrTWQ70sJexFi0XqbBdxOcvKUJnGaAXuokqr3uxEzGMoARHwXYXmVwWA53wnYrNgVLPJh45dedWxAsEImA/nPTIjUeQPr37JTbOOkou6u5yysRXPsUscnfLk8j7F78nvDu5gA+ILITmXNjJSGm8QCczBGqKObfek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iNW84w7u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iNW84w7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829DF1F00A3A
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784733887;
	bh=84gD9EtlNbYISkXGtokYVsHeoPRH6kDcdvRwZwhEw7s=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=iNW84w7uFeZQbb+kILxocSduM7JO9tJ/xUvYiFWT5YmE0YZQisjWM4DafWf5tQBzJ
	 dDoQQdOLMoUzcx6Vxvan6V9TWHapzYItBuKCAbXX8da4cjgTY1sdvb5xmgK4qKI5Oc
	 U3LPsXpKe1Hc4OnGKZUu7TCvpa6bWUMalmP7fe/X6PP003tan4cBAzk1wTpEl0ayZr
	 nnlQPmDbrSsFZnoyCJo2hUZoDNR+mc3YVyJS3cGywNXb8Ormn6WFSfvObhGFuIj7Cr
	 ZtIwEgZsLkH2yl0JzaaFQjMBK7tIUy1r3pxbOwYYw26FOXT8ln3QrFU+nCIzea1LfR
	 MJuRyyvYC1Trw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/5] btrfs: stop sleeping for one jiffy in non-ssd mounts during log commit
Date: Wed, 22 Jul 2026 16:24:38 +0100
Message-ID: <13fd7ba0d00232d4126531173e9f43e079449775.1784733395.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1784733395.git.fdmanana@suse.com>
References: <cover.1784733395.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Joining/starting a log transaction tracks if we ever had more than one task
concurrently logging by setting the flag BTRFS_ROOT_MULTI_LOG_TASKS in the
respective root. Once set, this flag remains for the rest of the lifetime
of the transaction, only cleared when we don't have a log root and need to
create a new one (transaction commits drop log roots).

During log commit, if we are not on a ssd mount (or use the -o nossd mount
option) and the BTRFS_ROOT_MULTI_LOG_TASKS flag is set, we sleep for one
jiffy with the excuse to allow future log writers to join and log inodes
and then commit a larger log transaction to reduce overall IO. However
this is extremely inefficient because:

1) If at some point we had multiple tasks logging concurrently but now
   we have only one task at a time, we force it to wait for 1 jiffy;

2) One jiffy can vary between 1ms to 10ms, depending on the kernel
   config option CONFIG_HZ, which by default has a value of 250HZ and
   that corresponds to 4ms - that is a lot.

This massively reduces the latency of fsyncs for non-ssd mounts, even
on consumer grade spinning disks.

Remove this mechanism to track if we have (or ever had) multiple tasks
logging and wait for 1 jiffy.

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

Running the script as:  ./fio-buffered-fsync.sh 8 64M 64M 1 4K randwrite

Before patch:

  WRITE: bw=2647KiB/s (2711kB/s), 2647KiB/s-2647KiB/s (2711kB/s-2711kB/s), io=512MiB (537MB), run=198055-198055msec

After patch:

  WRITE: bw=14.9MiB/s (15.6MB/s), 14.9MiB/s-14.9MiB/s (15.6MB/s-15.6MB/s), io=512MiB (537MB), run=34471-34471msec

That's about 5.7 times faster.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.h    |  2 --
 fs/btrfs/tree-log.c | 18 +-----------------
 2 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6de7ad191e04..0f2653182405 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -131,7 +131,6 @@ enum {
 	BTRFS_ROOT_ORPHAN_ITEM_INSERTED,
 	BTRFS_ROOT_DEFRAG_RUNNING,
 	BTRFS_ROOT_FORCE_COW,
-	BTRFS_ROOT_MULTI_LOG_TASKS,
 	BTRFS_ROOT_DIRTY,
 	BTRFS_ROOT_DELETING,
 
@@ -216,7 +215,6 @@ struct btrfs_root {
 	 * to access this field.
 	 */
 	int last_log_commit;
-	pid_t log_start_pid;
 
 	u64 last_trans;
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 875e4ddc68ea..ccc262833a7c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -316,13 +316,6 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 			wait_log_commit(root, root->log_transid - 1);
 			goto again;
 		}
-
-		if (!root->log_start_pid) {
-			clear_bit(BTRFS_ROOT_MULTI_LOG_TASKS, &root->state);
-			root->log_start_pid = current->pid;
-		} else if (root->log_start_pid != current->pid) {
-			set_bit(BTRFS_ROOT_MULTI_LOG_TASKS, &root->state);
-		}
 	} else {
 		/*
 		 * This means fs_info->log_root_tree was already created
@@ -340,8 +333,6 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 			goto out;
 
 		set_bit(BTRFS_ROOT_HAS_LOG_TREE, &root->state);
-		clear_bit(BTRFS_ROOT_MULTI_LOG_TASKS, &root->state);
-		root->log_start_pid = current->pid;
 	}
 
 	atomic_inc(&root->log_writers);
@@ -3347,13 +3338,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
 	while (1) {
 		int batch = atomic_read(&root->log_batch);
-		/* when we're on an ssd, just kick the log commit out */
-		if (!btrfs_test_opt(fs_info, SSD) &&
-		    test_bit(BTRFS_ROOT_MULTI_LOG_TASKS, &root->state)) {
-			mutex_unlock(&root->log_mutex);
-			schedule_timeout_uninterruptible(1);
-			mutex_lock(&root->log_mutex);
-		}
+
 		wait_for_writer(root);
 		if (batch == atomic_read(&root->log_batch))
 			break;
@@ -3414,7 +3399,6 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
 	btrfs_set_root_log_transid(root, root->log_transid + 1);
 	log->log_transid = root->log_transid;
-	root->log_start_pid = 0;
 	/*
 	 * IO has been started, blocks of the log tree have WRITTEN flag set
 	 * in their headers. new modifications of the log will be written to
-- 
2.47.2

