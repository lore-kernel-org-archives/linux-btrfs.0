Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.107
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795006716;
	b=ndYbvwFvkh1++mM94G7HowZd89ALq0beNgp0eGbpH+ikJ6FLQgNfAmG9/9gb+g+fMjI6
	 gfTIlVeZHDK5y1bg99CfQ6O05HUnF2y1mDnqBrgi0O21V0Img1G6lOFzAGiL5sBUbxITv
	 ga5IZFQvkoc8RvXYkzRkQrOD5J8m39Iyorj0/3BYtMHv+tscNdsvcKSCB1ijvHjwBYlfm
	 ACBUIWKhknN7p7ptojfzIGNeuyhykj7YuXzzvML8WAy5CMawcIsZUGzVN18fDuOqafA0r
	 yvhGCUvuOYdsamn34Hyp52m8zjoQLXC519zgNyn7q9C3O28rJoGoLeO3F3rr+jecDkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795006716;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ARcPM0deu4retNstP8skY7BonNxYAsp2bEBu1Or+Aco=;
	b=bGjfc3FxMWErFsBje0TS5mU0A8hCATwREN4Gzz33o9WTlqkBsQ1LmFoTAh2Zl4kQLNiJ
	 L+5+oRl/W30yEX4aaCF6wPesyULXdohlWPlcQiVQDgEWc04YdYwQZPFckzk5fsE7XiCv9
	 9C7Y158hKLcB6/FtnCyd1W3W9l4C96hYnQ9KOYSYQaI4aITyrOeP1oru7KSWQI6QTEyxU
	 /kR3bUgIh1u80QDA4RQV2jmNPyHUuhBLNM68Bj4uCB7Jk/d1Dj2hZRsAekvuNEzri4jBc
	 kvZfL7zLjXKeZCvTKs3IYDXOF6TNkE7+bCaLLd6Fm0ApxYLGIO/S8cEPsA3olBymPqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=BFWb3dBR;
	arc=none smtp.remote-ip=109.224.244.107
Received: from mail-244107.protonmail.ch (mail-244107.protonmail.ch [109.224.244.107])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55036606A325
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 12:58:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55036606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=BFWb3dBR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795006713; x=1795265913;
	bh=ARcPM0deu4retNstP8skY7BonNxYAsp2bEBu1Or+Aco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=BFWb3dBRBfRP5hEaece3q4nIaN+w4hyQp5M7A3KBe0qnli+qcGAGBSlicdBB27JtH
	 hqY3Ua5RUgbB+HTF8++QpnAQaXgSMXedXIK/QzMIYdGuRibo8PIoZL8mkUBbWH8P3t
	 llXo6bGqYqwaM3ozD7MgvNgbxB0njlrWw/srRtZDfyu2v0aUItuuwZRHHVbg3FUVvA
	 wdQ3UZhneQjhKrRzAQKyXYV/DvM4BvebdWEUDZDYMjrjtMhwtDqGSWLUoizcZaYFQI
	 dvhE2bx6jMGwL7fqwzYTnWmDNPaEMZeAshdgrDOcZVFdjhy8GYe9WXmix5UG3vPHCD
	 3FR3bYkMJV5Zg==
X-Pm-Submission-Id: 4jV1qq4ZjLz2ScWs
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: wait for block group relocation on remount read-only
Date: Wed, 18 Nov 2026 12:58:16 +0000
Message-ID: <20261118125816.6878-1-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118004808.201460-1-mc@raidlab.org>
References: <20261118004808.201460-1-mc@raidlab.org>
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

Nothing holds off a remount read-only while the reclaim work or a zoned
repair relocates a block group. Both take the super write lock, and the
reclaim work counts on it ("As we did take the super write lock, "mount
-o remount,ro" won't happen"), but sb_prepare_remount_readonly() doesn't
look at it. Without the remap tree, the remount is refused with -EBUSY
while the relocation's orphan inode exists, as it counts in
s_remove_count. Before the inode is created and after it is dropped, and
always for a forced remount, the remount goes through. The relocation
then keeps writing to the read-only filesystem, and its last transaction
is still open at unmount, as close_ctree() doesn't commit a read-only
filesystem:

  BTRFS warning (device nb2 state I): transaction 65 (with 98304 dirty metadata bytes) is not committed
  assertion failed: !found, in fs/btrfs/disk-io.c:4378
  kernel BUG at fs/btrfs/disk-io.c:4378!

Every relocation runs under reclaim_bgs_lock, btrfs_relocate_chunk()
asserts it. Take it in btrfs_remount_ro() around setting the filesystem
read-only, so the remount waits for the block group being relocated.
The reclaim work checks for read-only under the lock before each block
group and skips the remaining ones, add the same check to the zoned
repair kthread. Take the lock before setting the filesystem read-only,
as a relocation may wait for unfinished snapshot drops, which the
cleaner stops working on once the filesystem is read-only.

While it skips them, the reclaim work still calls
btrfs_delete_unused_bgs() between the block groups, which starts
transactions, also after btrfs_commit_super() has committed the last
one, and the cleaner may have queued it again. Stop it once the cleaner
is done, before that commit.

Balance, resize and device remove hold off a regular remount read-only
with mnt_want_write_file(), a resumed balance is paused by
btrfs_pause_balance(), and none of them is changed here.

Fixes: 18bb8bbf13c1 ("btrfs: zoned: automatically reclaim zones")
Fixes: f7ef5287a63d ("btrfs: zoned: relocate block group to repair IO failure in zoned filesystems")
CC: stable@vger.kernel.org
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
Found by an LLM while testing "btrfs: zoned: wait for the relocating
repair kthread during unmount", which noted that remount read-only had
the same problem for the repair. It turned out to be about any
relocation, so this is separate and applies with or without that patch.
The fix and the commit message were prepared with the help of an LLM,
which also ran the tests below. I reviewed everything.

Tested on btrfs for-next (6f4bbde7e036) in QEMU with KASAN:
- reclaim: one zoned null_blk device, 75% of several block groups
  freed, bg_reclaim_threshold lowered, and remount read-only retried in
  a loop while the reclaim work relocates. Without the patch the
  relocation goes on after the remount (1560 to 5536 sectors written to
  the device afterwards, 4 of 4 runs) and an unmount right after the
  remount crashes as above (6 of 6). With it nothing is written after
  the remount (7 of 7) and the unmount is clean (7 of 7).
- zoned repair: RAID1 on two zoned null_blk devices with read errors on
  one, remount read-only in a loop while the repair relocates, then
  unmount. Without the patch 3 of 4 crash as above, with it 7 of 7 are
  clean.
- unused block groups: as in the reclaim test, with the remaining files
  deleted while the reclaim work relocates, and with delays added for
  the test only (after setting read-only, before the reclaim work
  deletes unused block groups, and per deleted block group). Without
  the cancel_work_sync() the reclaim work deleted block groups in a
  transaction after the remount's last commit in 6 of 8 runs, and 2 of
  8 unmounts crashed as above. With it, 0 of 8.

With vm.dirty_bytes at 2 MiB, a remount read-only or an unmount during
the reclaim hangs, with and without this patch: the relocation waits
in balance_dirty_pages() for the flusher, which skips the filesystem
while the remount or unmount holds s_umount. "btrfs: start writeback
of relocated data before dirty throttling" fixes that separately.

When the repair is skipped because of the remount, the block group
keeps its repair flag, as with the other early exits of the kthread.
Kernels before 6.8 will need a different backport.

 fs/btrfs/block-group.c |  9 +++++----
 fs/btrfs/super.c       | 20 ++++++++++++++++++++
 fs/btrfs/volumes.c     |  4 ++++
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a40eedc65dd2..9d78ea7d5370 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2021,10 +2021,11 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 	/*
 	 * Get out fast, in case we're read-only or unmounting the
 	 * filesystem. It is OK to drop block groups from the list even
-	 * for the read-only case. As we did take the super write lock,
-	 * "mount -o remount,ro" won't happen and read-only filesystem
-	 * means it is forced read-only due to a fatal error. So, it
-	 * never gets back to read-write to let us reclaim again.
+	 * for the read-only case, after a remount read-write they come
+	 * back when they are marked for reclaim again. The super write
+	 * lock doesn't hold off "mount -o remount,ro", but
+	 * btrfs_remount_ro() sets read-only under reclaim_bgs_lock, which
+	 * we hold, so a remount waits for the block group we relocate.
 	 */
 	if (btrfs_need_cleaner_sleep(fs_info)) {
 		up_write(&space_info->groups_sem);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b424cc836bd4..e696d1133055 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1342,7 +1342,19 @@ static int btrfs_remount_ro(struct btrfs_fs_info *fs_info)
 	/* Avoid complains from lockdep et al. */
 	up(&fs_info->uuid_tree_rescan_sem);
 
+	/*
+	 * Nothing holds off a remount read-only while the reclaim work or a
+	 * zoned repair relocates a block group, not even the super write lock
+	 * they take. Every relocation runs under reclaim_bgs_lock, so wait for
+	 * the one in progress and set read-only under the lock. The reclaim
+	 * work and the zoned repair check for read-only under it before they
+	 * relocate. Do this before setting read-only, as a relocation may wait
+	 * for unfinished snapshot drops, which the cleaner stops working on
+	 * once the filesystem is read-only.
+	 */
+	mutex_lock(&fs_info->reclaim_bgs_lock);
 	btrfs_set_sb_rdonly(fs_info->sb);
+	mutex_unlock(&fs_info->reclaim_bgs_lock);
 
 	/*
 	 * Setting SB_RDONLY will put the cleaner thread to sleep at the next
@@ -1364,6 +1376,14 @@ static int btrfs_remount_ro(struct btrfs_fs_info *fs_info)
 	 */
 	wait_on_bit(&fs_info->flags, BTRFS_FS_CLEANER_RUNNING, TASK_UNINTERRUPTIBLE);
 
+	/*
+	 * The reclaim work doesn't relocate on a read-only filesystem, but
+	 * it still deletes unused block groups between the ones it skips, and
+	 * the cleaner may have queued it again before going to sleep. Stop
+	 * it, so it can't start a transaction after btrfs_commit_super().
+	 */
+	cancel_work_sync(&fs_info->reclaim_bgs_work);
+
 	/*
 	 * We've set the superblock to RO mode, so we might have made the
 	 * cleaner task sleep without running all pending delayed iputs. Go
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4630053d5cea..49988f4f8018 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -9078,6 +9078,10 @@ static int relocate_repair_block_group(struct btrfs_block_group *cache)
 	if (!cache)
 		goto out;
 
+	/* Don't relocate after a remount read-only, see btrfs_remount_ro(). */
+	if (btrfs_need_cleaner_sleep(fs_info))
+		goto out;
+
 	if (!test_bit(BLOCK_GROUP_FLAG_RELOCATING_REPAIR, &cache->runtime_flags))
 		goto out;
 
-- 
2.53.0

