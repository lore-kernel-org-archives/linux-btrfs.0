Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.106
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795458245;
	b=J/a2kZumv562Oc8JUWvVMi5Kmvit5h3+949J8xBfkJhRR8TvW6BAZlkifjU2eBIeNvcx
	 OmQ60Un+vTxKdaInVGr2qTduBWX1R1j6v0J2aeMX8i9jPdH9qtEdnw/Tyuw007Whcn5eD
	 PLvEA6nY9rlGQhmIpcCyZD4BENuk/JlXZg6V+mmUgGvFmVDGRlDFH4c3drCG46RSDYh6i
	 ZZpOj7b1W1p7B5wvRXK6z/DKFyKS98VVjfWilvNXLJ+mvqA55+UOm780FpNF6O/tF/pFF
	 cLCiGeZhUQdBqqmvYL+J7kGQ40MpdxfsAZUhjYOuBdWF9mC16kVBOzDvdY6piVQdwQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795458245;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=TWSKbUsSrTjzNCSYsG1xahamTRTheITCywBSxo844mA=;
	b=TLJ5ZKPGmtK53uOtZI+mD19NgBN4iD5lnZNU/5egOfGn8j2gU9aSkOhIgMzExr8woVbj
	 XQgyx+hZg/M+zu4Xws8cbjnGL6MSoqttL5m3mokw8iR4Qqt7A4HEXjNFpAPSD/THiwRay
	 xRBiHsIn7KKHGa6i95VlXwphP6RF8s8PDt4ZZimj1uOwd3QBQETwxlt/x9su9H6KKq7Jt
	 qSaOXzs1d4PBmhbryY0Gnh0JThoo1jebgDBnD4eYkBLn60ME4zfpqesWIe/DvRV5pL3ea
	 4Fqb5HBX5+ntVi2ecU8/Ejq53OKxBUCac3mk4cpWy7pVKkDqFqFSFLayRmdcxXsSZGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=VRIlWwkE;
	arc=none smtp.remote-ip=109.224.244.106
Received: from mail-244106.protonmail.ch (mail-244106.protonmail.ch [109.224.244.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CA1606A31A;
	Mon, 23 Nov 2026 18:24:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34CA1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=VRIlWwkE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795458241; x=1795717441;
	bh=TWSKbUsSrTjzNCSYsG1xahamTRTheITCywBSxo844mA=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=VRIlWwkEGzBn5SdB16bdlj9+BlhfozocUWqqOES15bjCWpixQWWFH4E0mOjbTjILE
	 xCbm5rKiI3iXPWUoumcXV32mlN1Xfn++HVyG+O23eNzCxkVrrpB+thkK+fMIUaUU/4
	 O3ZQ3GyZXXOJLsCbOLlu7KoCMEf7A4m1/3LoNeM4a5xc1CEg006gUq9ABLzOkRoNQ7
	 7qLX+oEFQfbpVRv991FYfauZDcJOkP4Y8L8of5bW0PJxxV1neWlijV/cSbSL2iQiy0
	 uynuE3zFdbiK35V7cW0tm+irKvG6Wb2i2h5sZ/fOwKoowp9vsZHw5XGR6NpX7WdRrh
	 NoxZpc6Q65YPA==
X-Pm-Submission-Id: 4jYDq34c1tz1DDKY
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: fix use-after-free in the raid stripe tree commit root search
Date: Mon, 23 Nov 2026 18:23:54 +0000
Message-ID: <20261123182354.2091665-1-mc@raidlab.org>
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

Since commit f4d39cf1cebf ("btrfs: set search_commit_root on stripe io
in case of relocation"), reads of the data relocation inode look up the
raid stripe tree in its commit root. A read repair of such a read does
the same. btrfs_get_raid_extent_offset() then searches with
search_commit_root and skip_locking, but nothing holds commit_root_sem.

switch_commit_roots() can then drop the old commit root while
btrfs_search_slot() takes a reference to it:

  relocation read or its repair     transaction commit
  -----------------------------     ------------------
  btrfs_map_block()
    btrfs_get_raid_extent_offset()
      btrfs_search_slot()
        b = root->commit_root
                                    switch_commit_roots()
                                      drops the last reference to b
        refcount_inc(&b->refs)
                                    b is freed after an RCU grace period
        reads b

  refcount_t: addition on 0; use-after-free.
  ...
  BUG: KASAN: slab-use-after-free in btrfs_search_slot+0x2e5f/0x2fc0
   btrfs_get_raid_extent_offset+0x1cb/0x700
   btrfs_map_block+0x5f8/0x27a0
   btrfs_submit_bbio+0x54d/0x2350
   btrfs_check_read_bio+0x758/0x12e0

Scrub sets the same flag. A commit pauses scrub first, but the repair
reads of stripes that are still in flight run from
scrub_stripe_read_repair_worker() and are not covered by the pause.

Take commit_root_sem for read in btrfs_map_block() for these lookups,
and hold it until the mapping is done. Only reads that set
rst_search_commit_root take it. Take it before dev_replace->rwsem. A
read that looks up checksums in the commit root already takes the two
locks in this order. btrfs_lookup_bio_sums() holds commit_root_sem while
it reads csum tree blocks. Each of these reads goes through
btrfs_map_block(). need_commit_sem in the search would take
commit_root_sem inside dev_replace->rwsem instead. During a device
replace, lockdep reports that order as a circular dependency.

Fixes: 9acaa64187f9 ("btrfs: scrub: implement raid stripe tree support")
Fixes: f4d39cf1cebf ("btrfs: set search_commit_root on stripe io in case of relocation")
CC: stable@vger.kernel.org # 6.12+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
Found with FuzzyRAID, a fault-injection tester for RAID that is not
public at the moment: zoned RAID1 with the raid stripe tree, a failing
device, read repair during relocation.

It does not need a failing device. The tests add a test-only delay
before the refcount_inc() in btrfs_search_slot_get_root(). With it, a
data balance on the raid stripe tree with a writer and concurrent
commits hit the use-after-free in 3 of 3 runs without this patch and in
none of 4 with it. A read-only scrub with a bad mirror hit it in
scrub_stripe_read_repair_worker() in 3 of 3 runs without this patch and
in none of 4 with it. Without the delay, both tests pass with and
without the patch (relocation 2 and 1 runs, scrub 4 and 4 runs). The
tests throttle the writer and the sync loop. With the delay, the commits
are slow, and null_blk keeps every written zone in RAM. Unthrottled runs
ran out of memory.

A first version set need_commit_sem in btrfs_get_raid_extent_offset().
Both versions ran with lockdep, in a device replace with a bad source
mirror and concurrent reads. Lockdep stops at its first report. Without
this patch, the first report in this test is a recursive read of
dev_replace->rwsem in btrfs_map_block(). The test kernels annotate that
read to get further. With the first version, lockdep then reported a
circular dependency between commit_root_sem and dev_replace->rwsem less
than a second into the replace, in 2 of 2 runs. With this version, it
reported none in 2 of 2 runs. Its only report came after the replace had
finished: an inversion between dev_replace->rwsem and the raid stripe
tree lock. That one shows up without this patch too, in 1 of 2 runs. The
recursive read and the inversion are separate bugs, not addressed here.
Both come from the raid stripe tree lookup that btrfs_map_block() does
while it holds dev_replace->rwsem.

This applies to 6.19 and newer. 6.18 needs a context change
(skip_locking = 1). 6.12 needs a backport: it has no io_geom.use_rst,
takes dev_replace->rwsem unconditionally and has no csum lookup in the
commit root. Backports for 6.18 and 6.12 can follow if needed.

The analysis, the fix and the tests were done with the help of an LLM. I
reviewed everything.

 fs/btrfs/raid-stripe-tree.c |  2 ++
 fs/btrfs/volumes.c          | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 1d3d1fa40b20..0d640678ef2b 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -436,6 +436,8 @@ int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
 		return -ENOMEM;
 
 	if (stripe->rst_search_commit_root) {
+		/* btrfs_map_block() holds commit_root_sem for this search. */
+		lockdep_assert_held_read(&fs_info->commit_root_sem);
 		path->skip_locking = true;
 		path->search_commit_root = true;
 	}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bfc1b85f4b03..e52bd9f57ee5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7321,6 +7321,7 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 	struct btrfs_io_context *bioc = NULL;
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 	bool dev_replace_is_ongoing = false;
+	bool commit_root_locked = false;
 	u16 num_alloc_stripes;
 	u64 max_len;
 
@@ -7365,6 +7366,18 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 	*length = min_t(u64, map->chunk_len - map_offset, max_len);
 	io_geom.use_rst = btrfs_need_stripe_tree_update(fs_info, map->type);
 
+	/*
+	 * Relocation and scrub look up the raid stripe tree in its commit root.
+	 * Hold off a transaction commit, which switches and frees that root,
+	 * until the mapping is done. Take the lock before dev_replace->rwsem,
+	 * as the csum lookup of a read does.
+	 */
+	if (io_geom.use_rst && op == BTRFS_MAP_READ && smap &&
+	    smap->rst_search_commit_root) {
+		down_read(&fs_info->commit_root_sem);
+		commit_root_locked = true;
+	}
+
 	if (dev_replace->replace_task != current)
 		down_read(&dev_replace->rwsem);
 
@@ -7521,6 +7534,8 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		/* Unlock and let waiting writers proceed */
 		up_read(&dev_replace->rwsem);
 	}
+	if (commit_root_locked)
+		up_read(&fs_info->commit_root_sem);
 	btrfs_free_chunk_map(map);
 	return ret;
 }

base-commit: 65101fe10b3008186b813b628ee3a611b0e70ce6
-- 
2.53.0

