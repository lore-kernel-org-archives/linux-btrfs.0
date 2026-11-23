Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.107
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795397115;
	b=1K0LopWSsVwQrBLefUmZragVrCQYamPnXQDVOJcyVf6zH/+2fF78r/OoIqgO60Fnhkrx
	 Nj6DGrrQBZ1Dpd8IqBMYsJ5NjEAU0uBq8PD7VrbhgH+lnk+ONwXbWJ76QA8c+9E+vX4rw
	 WlqzHuyWiZ3YnNttE+Ag1JsIs0ne+NwZXNUG/RYlah0uPMQUnzscCoQgcxmn5Cyy3arXX
	 9fQpehbuoEWqNTgBj4y5BcNw3f1x9Dvx+ICh1/dHVf60CPcpT99wpKHAIWePnfejjraBK
	 77B1XKiXpnY3rjuINcYwPcl0hhbOzVnSvbIR/40R1XJ6jPXAxOzUQNL5mkqKFPvskpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795397115;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=ENWwzoFL9/nH/B1dYhxmQyjRTmQ8rPWnYy4IFtsJuVo=;
	b=NapZFy7giu1FzqiUDfpKJvhEUOW/D/FtY1NkvCxgCt8k8vDVHVs3rBK7N2CbdEPTM+el
	 H1Ksogqinu8LglsZqwQTGJJyPZmB28yOCIOl29Dtn7bJ10xZHmKhrsLkWzf1KlpVkMe0L
	 jpG/6j/qAYEuClls7R7BIAIWlP0eDRs/LV+MzMcscPsgg0diSmVEKuloSBNH+9SqSyMRY
	 L50nOOJDuje4h2Qb0aST8oXJtuPe5bdhs3CPIeBv6kH++O2GJ4BWc2fy2qkpZkEdSuSn5
	 Rg9RJQAkRA3ulWV0+Q56crICg0n4HH2FR1h1NA4ueZMAM8y9lTl1MiyOUOC6TAAhQjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=LSKZu5tw;
	arc=none smtp.remote-ip=109.224.244.107
Received: from mail-244107.protonmail.ch (mail-244107.protonmail.ch [109.224.244.107])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121FF606A31A;
	Mon, 23 Nov 2026 01:25:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 121FF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=LSKZu5tw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795397110; x=1795656310;
	bh=ENWwzoFL9/nH/B1dYhxmQyjRTmQ8rPWnYy4IFtsJuVo=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=LSKZu5twbNiigEquKRPH81YOY+9ZnfDifow0OWSKD3IS9ZKOgoUmTvgLLrbqy6L35
	 sWDBtWfs63cljGUH5JsOEsTI692m4pxNmZasCfWHsFZaRGHd+nvLp//dlWzAs15rr3
	 tXNICT/U3HJcURMuKCsRajjA4zwO5/QM4+BfwGWJzhAawPBbe4Q8yrvHul3cvA8apg
	 qAlyoneSTENJTr/2KcBR3aZJdQgKNiLpmZJRt5BG/Z9G3wO1JLcjOt7AbbYIKOFSbE
	 qTetX+TmBM2tA0O14V1V/GwjZfqA28iiPPhMCCLiXTWUzTS7A17aZ0CH9ocXcLFuIM
	 HF3B8Z710DBhw==
X-Pm-Submission-Id: 4jXpCQ20gHz2ScWs
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: zoned: fix deadlock between freeze and RECLAIM_ZONES
Date: Mon, 23 Nov 2026 01:24:59 +0000
Message-ID: <20261123012459.436826-1-mc@raidlab.org>
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

RECLAIM_ZONES calls btrfs_reclaim_block_groups() to serve data space
tickets. That function takes the super write lock with
sb_start_write(). A writer waiting on such a ticket holds that lock
already, so a freeze waits for the writer while the reclaim waits for
the freeze:

  writer             freeze               async data reclaim
  ------             ------               ------------------
  sb_start_write()
  wait on a data
  space ticket
                     freeze_super()
                       wait for writers
                                          flush_space(RECLAIM_ZONES)
                                            btrfs_reclaim_block_groups()
                                              sb_start_write()
                                              wait for the freeze

Nothing serves the ticket, and all three wait.

Take the lock with sb_start_write_trylock() and skip the reclaim while
the filesystem is being frozen or is frozen. The space flushing goes on
with its next states. If they free nothing, the ticket fails with
ENOSPC, the same as when the reclaim is skipped for a running balance.
The block groups stay on the reclaim list, and the cleaner queues the
reclaim work again after the thaw.

The reclaim worker, which also runs on non-zoned filesystems, skips
during a freeze as well instead of waiting for the thaw. Commit
ca5e4ea0beae ("btrfs: zoned: mark relocation as writing") added the lock
to keep relocations out of a frozen filesystem, and skipping them still
does that.

Fixes: e2a7fd22378f ("btrfs: zoned: add zone reclaim flush state for DATA space_info")
CC: stable@vger.kernel.org # 7.1+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
Sashiko pointed at this deadlock in its review of "btrfs: wait for
block group relocation on remount read-only". It was checked,
reproduced and fixed with the help of an LLM, which also prepared the
commit message. I reviewed everything. It needed a test-only delay
before RECLAIM_ZONES to reproduce: with the delay, 2 of 3 runs hung
without the patch and none of 3 with it.

This also removes the lockdep dependency Sashiko reported on v2 of that
patch, from s_umount through cancel_work_sync() of the reclaim works to
the super write lock. close_ctree() cancels both reclaim works and
btrfs_remount_ro() the async data reclaim work, with s_umount held. With
lockdep, after a reclaim, a remount and an unmount, /proc/lockdep showed
the reclaim works depending on sb_writers without this patch, and no
such dependency with it. Neither run printed a lockdep warning.

Johannes's pending "btrfs: zoned: wait for a running block group reclaim
in RECLAIM_ZONES" (v7 15/27) adds a flush_work() of the reclaim worker
to RECLAIM_ZONES. The worker calls btrfs_reclaim_block_groups() too and
blocks on the freeze the same way, so that flush_work() can hang as
well. In my test with that patch applied, the flusher got past the
flush_work() and hung in the direct call, 2 of 3 runs. With the trylock
none of 3 hung.

 fs/btrfs/block-group.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a40eedc65dd2..0736132624f8 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2098,10 +2098,16 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 	if (!btrfs_should_reclaim(fs_info))
 		return;
 
-	guard(super_write)(fs_info->sb);
+	/*
+	 * Skip the reclaim while the filesystem is frozen or being frozen.
+	 * RECLAIM_ZONES calls this for a space ticket, and a writer waiting
+	 * on the ticket holds off the freeze, which holds off sb_start_write().
+	 */
+	if (!sb_start_write_trylock(fs_info->sb))
+		return;
 
 	if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_BALANCE))
-		return;
+		goto out;
 
 	/*
 	 * Long running balances can keep us blocked here for eternity, so
@@ -2109,7 +2115,7 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 	 */
 	if (!mutex_trylock(&fs_info->reclaim_bgs_lock)) {
 		btrfs_exclop_finish(fs_info);
-		return;
+		goto out;
 	}
 
 	spin_lock(&fs_info->unused_bgs_lock);
@@ -2159,6 +2165,8 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 	list_splice_tail(&retry_list, &fs_info->reclaim_bgs);
 	spin_unlock(&fs_info->unused_bgs_lock);
 	btrfs_exclop_finish(fs_info);
+out:
+	sb_end_write(fs_info->sb);
 }
 
 void btrfs_reclaim_bgs_work(struct work_struct *work)

base-commit: 65101fe10b3008186b813b628ee3a611b0e70ce6
-- 
2.53.0

