Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033566;
	b=iXLlvXe85xe1ygAiY5z+OsuyACnryc48+bTw/7FP6eQkzc5Co1U3CwpwQUDqgldM6jsX
	 J5RkycaJPctNTtdq4SMW7obhTAPThDoXy5npOGOyxtuXD6ajSxgoJ+45n8nd0VARFY9c2
	 HwIgLuiHovVxu8+wsB3SmVIJtaUk6M5M9kFWSTYXh9yOaX40Wbdy8OYtjYPbhnTIR1woH
	 CC31LvJ7KdBwL8N9fG82c0XnSkj9+RhXLjpqh/t4XcGOPgVX5lhDsxV/45X+MsMsIdTYj
	 2rMG3OlOpuuWZxNp3niL0Gf5ReQwQtBW74en6MJG6Qh0wsOkKa/n9uoYeAnC89kGDdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033566;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=a9aHOtY9r8YIi90O/ve97/2PegLaKtc6V++AttcaFxk=;
	b=FCO1IfTX61IFhc7IdL2Fe1MY/uVrnkoBKQ8exOclEEkfAfyWNOdkmOA43ENyv/pdY4YO
	 1L0nUMSLoLYM3WNMCOYaFEEPfe95g7ZVQa0IvkbkoDJXKNXb/VplLZZe4v85w9zVdJ1AS
	 o6fwCyfsMmYmj3KOdxAQ1vset6IgjGERdDJW6wYiCB0Wlc4CSyojvh06exjLcn0qn7TQg
	 snrxvF387GeFR2DZCZbiBacyHAkJywvw8UEonf/cpG+yqIb359N3TmHzC4v5qsTyQAvzl
	 XZdup1pdAZ/5ScEd/jsmBNz//6mHdT4sXFTcLyANn4Wln0GjPzRVR+I4GlrTMfzz7CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=iu55TWDL;
	arc=none smtp.remote-ip=185.70.43.171
Received: from mail-43171.protonmail.ch (mail-43171.protonmail.ch [185.70.43.171])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2C5606A31C;
	Wed, 18 Nov 2026 20:26:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F2C5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=iu55TWDL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795033562; x=1795292762;
	bh=a9aHOtY9r8YIi90O/ve97/2PegLaKtc6V++AttcaFxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=iu55TWDLoLnqLrAwEc2HfPOe/egIk/popu97XI0DCIPpMdqIniu/FcZ2u9962M9/k
	 MToYFNv253LMfXya1TRbE++UyovmzNjlxTACFaLZ+0cNukNq6zYpzU9v7yiL5Eg91D
	 +OhNEb08HBbh2xulPL/TKg9HVVPKKvOHLR/TvelkjEcH20NPBY2ydt0vttF2jMdaEp
	 Eqd8E9Tz2oqdgymKVspkPwgwxlHnMY+DvdGofx1O91Kg5ifYOFfJmOTdSoRZNZT93e
	 4ocf4zN0DORqoZUFMXoJUZfxu1P9YxNOpFHy6Okf/W433twxPvGqwprQawlPIM+iRT
	 Kh+v9v5u1FA9A==
X-Pm-Submission-Id: 4jVCm835mMz1DDLY
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] btrfs: wait for block group relocation on remount read-only
Date: Wed, 18 Nov 2026 20:25:48 +0000
Message-ID: <20261118202548.82001-1-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118125816.6878-1-mc@raidlab.org>
References: <20261118125816.6878-1-mc@raidlab.org>
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
always for a forced remount, the remount goes through:

 reclaim work                       remount read-only
 btrfs_reclaim_block_groups()
 |-btrfs_relocate_chunk()           btrfs_remount_ro()
 | Still relocating                 |-btrfs_set_sb_rdonly()
 |                                  \-btrfs_commit_super()
 |                                    Returns, read-only
 \-Keeps writing, leaves its last
   transaction open
                                    unmount
                                    close_ctree()
                                      No commit on a read-only fs

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
is done, before that commit. Cancel the space reclaim works last, right
before that commit, as what the remount waits for may queue them again,
and run the delayed iputs before, as a work may wait for them.

Balance, resize and device remove hold off a regular remount read-only
with mnt_want_write_file(), a resumed balance is paused by
btrfs_pause_balance(), and none of them is changed here.

Fixes: 18bb8bbf13c1 ("btrfs: zoned: automatically reclaim zones")
Fixes: f7ef5287a63d ("btrfs: zoned: relocate block group to repair IO failure in zoned filesystems")
CC: stable@vger.kernel.org # 6.8+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
v2:
- Cancel the space reclaim works right before the last commit instead of
  at the start of btrfs_remount_ro(), after running the delayed iputs,
  as in close_ctree(): what the remount waits for may queue them again
  (Sashiko).
- Add a chart of the race.

Found by an LLM while testing "btrfs: zoned: wait for the relocating
repair kthread during unmount", which noted that remount read-only had
the same problem for the repair. It turned out to be about any
relocation, so this is separate and applies with or without that patch.
The fix and the commit message were prepared with the help of an LLM,
which also ran the tests below. I reviewed everything.

Tested on btrfs for-next in QEMU with KASAN, remount read-only retried
while the reclaim work or a zoned repair relocates, then an unmount:
without the patch 6 of 6 reclaim and 3 of 4 repair runs crash as
above, with it 9 of 9 runs are clean.

The cancel_work_sync() under s_umount is the same as in close_ctree(),
and a remount can't run during a freeze.

A remount or unmount during a relocation at the dirty limit still hangs
without "btrfs: start writeback of relocated data before dirty
throttling".

When the repair is skipped because of the remount, the block group
keeps its repair flag, as with the other early exits of the kthread.
Kernels before 6.8 will need a different backport.

 fs/btrfs/block-group.c |  9 +++++----
 fs/btrfs/super.c       | 36 +++++++++++++++++++++++++++++-------
 fs/btrfs/volumes.c     |  4 ++++
 3 files changed, 38 insertions(+), 11 deletions(-)

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
index b424cc836bd4..e80df13d36e4 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1328,13 +1328,6 @@ static int btrfs_remount_rw(struct btrfs_fs_info *fs_info)
 
 static int btrfs_remount_ro(struct btrfs_fs_info *fs_info)
 {
-	/*
-	 * This also happens on 'umount -rf' or on shutdown, when the
-	 * filesystem is busy.
-	 */
-	cancel_work_sync(&fs_info->async_reclaim_work);
-	cancel_work_sync(&fs_info->async_data_reclaim_work);
-
 	btrfs_discard_cleanup(fs_info);
 
 	/* Wait for the uuid_scan task to finish */
@@ -1342,7 +1335,19 @@ static int btrfs_remount_ro(struct btrfs_fs_info *fs_info)
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
@@ -1364,6 +1369,14 @@ static int btrfs_remount_ro(struct btrfs_fs_info *fs_info)
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
@@ -1385,6 +1398,15 @@ static int btrfs_remount_ro(struct btrfs_fs_info *fs_info)
 	 */
 	btrfs_qgroup_wait_for_completion(fs_info, false);
 
+	/*
+	 * Stop the space reclaim works last, as what we waited for above may
+	 * have queued them again. Run the delayed iputs before, as a work may
+	 * wait for them and the cleaner no longer runs them.
+	 */
+	btrfs_run_delayed_iputs(fs_info);
+	cancel_work_sync(&fs_info->async_reclaim_work);
+	cancel_work_sync(&fs_info->async_data_reclaim_work);
+
 	return btrfs_commit_super(fs_info);
 }
 
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

