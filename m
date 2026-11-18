Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794962910;
	b=QB+fKLU90nGDsX+wExjQil49xTaGgurDdE58hpqlwO/1ypnEOzMmtfYm7k5wJl88xvaY
	 BKk1q2FIJjS48tOFJEbhCiNS4YXiKe+8r7pJwjXQZf2YgBLKtshCeB+rc0XGtzDn0XNsc
	 q2SUI1jxPhUJ0xWglXIK5mi6yh7uNuMv2niGMUU6MF/57tppU777ZMYq05edHlnYeRwQQ
	 pxne6nArYUBW2b86LyxXqqVY/7KKVvn/exKc4jaUJZSDYoXzgTVFHTs+bSUoYFGQwu38j
	 98gIhQmtOsg+t5RDMX/IzYEiJyHS7aOvoIWYr+7LCml9JxUKQdL/sQQxtBJ8BuWSOxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794962910;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=mw6A9y9mCJDaeXxPPToECiD1RC/0Eef4ZlgQ/93wlhk=;
	b=tIcon944pG7OptvhOYxbZXsL8zMyQTBxmkBIiao6Vsbbdl6aTAjCOfRJaYGlrN2lm/YY
	 WVkMS9fSaNQLsq8BB/7wzLx8xyjyjqNI1pZQunUMMDSHFd3cig95M0H2cCnwZucD2S2yn
	 lxGufsE9v/nIkxVhAZANzb636UDuRT977G7fo5pMocTcNVTQvXgcPL1sMIKMdhe6DrwSh
	 qECI/pEvQ4wINl43DDTabFS+ogeExA9cYvrk/xrkEyMesQ9lDfFx0N9UL09RVQqGpjfCG
	 f6Of+YWftJvdHVtXjGqu9/1WwbkS5XIbImwbHsiQgC+PWJ9FCbwV/zTXA7zcXxuBsfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=TIgsiGIc;
	arc=none smtp.remote-ip=185.70.43.171
Received: from mail-43171.protonmail.ch (mail-43171.protonmail.ch [185.70.43.171])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5C6606A882
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 00:48:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E5C6606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=TIgsiGIc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1794962907; x=1795222107;
	bh=mw6A9y9mCJDaeXxPPToECiD1RC/0Eef4ZlgQ/93wlhk=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=TIgsiGIcI1wOOe9PDU04o15OrojNhRCaTNcDi/Qxu/dgGneXSKO78UnB/PdUPMw7U
	 FFtec1ElspCF867Pf7j1zJfnBXSvcN1OTpWzdvkddpIqswP2hGUuj2+Z3XSu/7hJFE
	 b2QMUgxeGTlDS8N7awX134B/yl9O13s7C1imX9izMzsWJniXZF+LviHqXiTNwHva+P
	 +O9vqmodT+kKTA6c1ooFzHHaBacYYztdZOusmKqwihyN/hPwqAcRsBzW7MthGhZ03w
	 NW6uYmtP85QUTx+llXyCr5fWOYtgMoy3jMwyGOq9mfKghQRvDN7/0oH7ipPx51f2Hi
	 1yQL0BbdQhNgg==
X-Pm-Submission-Id: 4jTjdN54jcz2ScQ3
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: zoned: wait for the relocating repair kthread during unmount
Date: Wed, 18 Nov 2026 00:48:08 +0000
Message-ID: <20261118004808.201460-1-mc@raidlab.org>
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

On a zoned filesystem, a read error with another good copy makes
btrfs_repair_one_zone() start a "btrfs-relocating-repair" kthread that
relocates the whole block group, and return. Nothing tracks that
kthread. It takes sb_start_write() and the BALANCE exclusive operation,
but neither holds off an unmount: freeze protection only excludes
freezing, and close_ctree() only pauses a balance that has a
balance_ctl. If the filesystem is unmounted during the relocation,
close_ctree() tears it down under the kthread:

  assertion failed: list_empty(&fs_info->delalloc_roots), in fs/btrfs/disk-io.c:4608
  kernel BUG at fs/btrfs/disk-io.c:4608!
  RIP: 0010:close_ctree+0x67f/0x9b8
  Call Trace:
   generic_shutdown_super+0x14d/0x540
   kill_anon_super+0x35/0x90
   btrfs_kill_super+0x39/0x60
   deactivate_locked_super+0x9f/0x120
   cleanup_mnt+0x9a/0x130

Without the assertion, the relocation goes on to use the fs_info and
the roots that the unmount freed (KASAN: slab-use-after-free in
wait_subpage_spinlock(), null-ptr-deref in btrfs_root_node()).

Do as for the uuid rescan kthread: hold a semaphore from the start of a
repair until its kthread ends, and take and release it in close_ctree()
where the block group reclaim work, which does the same relocation, is
cancelled, before the cleaner is parked. btrfs_repair_one_zone() checks
BTRFS_FS_CLOSING_START after taking the semaphore, so no repair starts
once close_ctree() has waited. Unmount now waits for the relocation of
that one block group, as it already does for the reclaim work. The
kthread is split in two so that its guard(super_write) is released
before the up(), which must be its last access to fs_info.

A repair started while mounting has the same problem if the mount then
fails, as most error paths of open_ctree() (the fail_* labels) free
fs_info without calling close_ctree(). Don't start one before
BTRFS_FS_OPEN is set, as btrfs_should_reclaim() does.

Only one repair runs at a time now. Before, a second repair started
while one was running failed the exclusive operation with -EBUSY but
left BLOCK_GROUP_FLAG_RELOCATING_REPAIR set, so its block group was not
repaired again until the next mount. Now it returns before setting the
flag, and the next read error retries it.

Fixes: f7ef5287a63d ("btrfs: zoned: relocate block group to repair IO failure in zoned filesystems")
CC: stable@vger.kernel.org # 6.19+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
Found with FuzzyRAID, a fault-injection tester for RAID that is not
public at the moment. The analysis, the fix, the tests and the commit
message were prepared with the help of an LLM. I reviewed everything.

Tested on btrfs for-next (6f4bbde7e036) in QEMU with KASAN, two zoned
null_blk devices with RAID1 and the raid stripe tree, and read errors
on one of them, so that reading a file starts the repair:
- unmount while the repair relocates: without the patch 4 of 4 crash as
  above, with it 6 of 6 unmount cleanly after the relocation
- unmount after the repair has finished: works with and without the
  patch
- mount with read errors in one device's metadata: without the patch
  the repair starts during the mount, btrfs_start_pre_rw_mount() then
  fails ("failed to recover relocation: -ENOENT") and close_ctree()
  crashes on the repair's uncommitted transaction (ASSERT(!found) in
  warn_about_uncommitted_trans()). With it the mount works and a scrub
  repairs the errors.

Remount read-only has the same problem: it doesn't wait for the repair,
and outside the part of the repair where the remount is refused with
-EBUSY it succeeds with the kthread still running. The next unmount
then finds the repair's transaction not committed (ASSERT(!found) in
warn_about_uncommitted_trans(), 3 of 4 runs). I'll send a separate fix
for that.

 fs/btrfs/disk-io.c |  8 ++++++++
 fs/btrfs/fs.h      |  6 ++++++
 fs/btrfs/volumes.c | 49 +++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7775fc768f7e..6af173e65c77 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2965,6 +2965,7 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	init_rwsem(&fs_info->cleanup_work_sem);
 	init_rwsem(&fs_info->subvol_sem);
 	sema_init(&fs_info->uuid_tree_rescan_sem, 1);
+	sema_init(&fs_info->zone_repair_sem, 1);
 
 	btrfs_init_dev_replace_locks(fs_info);
 	btrfs_init_qgroup(fs_info);
@@ -4405,6 +4406,13 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	 * trying to stop the async reclaim task.
 	 */
 	cancel_work_sync(&fs_info->reclaim_bgs_work);
+	/*
+	 * Same for a zoned repair relocating a block group. Wait for it, no new
+	 * one can start after this since BTRFS_FS_CLOSING_START is set, see
+	 * btrfs_repair_one_zone().
+	 */
+	down(&fs_info->zone_repair_sem);
+	up(&fs_info->zone_repair_sem);
 	/*
 	 * We don't want the cleaner to start new transactions, add more delayed
 	 * iputs, etc. while we're closing. We can't use kthread_stop() yet
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 2dd167c32d61..3abbe4aa85e4 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -862,6 +862,12 @@ struct btrfs_fs_info {
 
 	struct semaphore uuid_tree_rescan_sem;
 
+	/*
+	 * Held while a zoned repair kthread relocates a block group, see
+	 * btrfs_repair_one_zone(). close_ctree() waits for it.
+	 */
+	struct semaphore zone_repair_sem;
+
 	/* Used to reclaim the metadata space in the background. */
 	struct work_struct async_reclaim_work;
 	struct work_struct async_data_reclaim_work;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f27c0c400a20..4630053d5cea 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -9053,9 +9053,8 @@ bool btrfs_pinned_by_swapfile(struct btrfs_fs_info *fs_info, void *ptr)
 	return node != NULL;
 }
 
-static int relocating_repair_kthread(void *data)
+static int relocate_repair_block_group(struct btrfs_block_group *cache)
 {
-	struct btrfs_block_group *cache = data;
 	struct btrfs_fs_info *fs_info = cache->fs_info;
 	u64 target;
 	int ret = 0;
@@ -9100,6 +9099,22 @@ static int relocating_repair_kthread(void *data)
 	return ret;
 }
 
+static int relocating_repair_kthread(void *data)
+{
+	struct btrfs_block_group *cache = data;
+	struct btrfs_fs_info *fs_info = cache->fs_info;
+	int ret;
+
+	ret = relocate_repair_block_group(cache);
+	/*
+	 * Pairs with close_ctree(). Must be the last access to fs_info, the
+	 * unmount may free it as soon as the semaphore is released.
+	 */
+	up(&fs_info->zone_repair_sem);
+
+	return ret;
+}
+
 bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
 {
 	struct btrfs_block_group *cache;
@@ -9112,19 +9127,43 @@ bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
 	if (btrfs_test_opt(fs_info, DEGRADED))
 		return true;
 
+	/*
+	 * Don't start one during mount either: most error paths of
+	 * open_ctree() free fs_info without waiting for the repair in
+	 * close_ctree().
+	 */
+	if (!test_bit(BTRFS_FS_OPEN, &fs_info->flags))
+		return true;
+
+	/*
+	 * One repair at a time, the kthread releases the semaphore when it
+	 * ends. close_ctree() takes it after setting BTRFS_FS_CLOSING_START,
+	 * so either it waits for the kthread or we see the flag here.
+	 */
+	if (down_trylock(&fs_info->zone_repair_sem))
+		return true;
+	if (btrfs_fs_closing(fs_info))
+		goto out_up;
+
 	cache = btrfs_lookup_block_group(fs_info, logical);
 	if (!cache)
-		return true;
+		goto out_up;
 
 	if (test_and_set_bit(BLOCK_GROUP_FLAG_RELOCATING_REPAIR, &cache->runtime_flags)) {
 		btrfs_put_block_group(cache);
-		return true;
+		goto out_up;
 	}
 
 	task = kthread_run(relocating_repair_kthread, cache, "btrfs-relocating-repair");
-	if (IS_ERR(task))
+	if (IS_ERR(task)) {
 		btrfs_put_block_group(cache);
+		goto out_up;
+	}
+
+	return true;
 
+out_up:
+	up(&fs_info->zone_repair_sem);
 	return true;
 }
 
-- 
2.53.0

