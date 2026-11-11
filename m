Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794400920;
	b=FQzfd8qoJcvr4/beVvo4WtdG9HDAI20SBqnNmFqVyA4s0TUjF83OriEB7YRQ8k+erLJn
	 uBQFKJPJYvNdpiQQetYiobLY3bc6F53Hvodzp6SOciabamS+U1a3LuJegCF4maqy8ANC0
	 1Ur6uTPFY3qu/UubzUEhMW95Dp1OHShHEnN4qRliRxJQbSs7bEjs4Tb9koVqCp01VLUQp
	 tXGA2qveXkupu03CqzzMxaRxevoYUmbCJCqlPjE1CFgiWqfYsX5Ek5c5q/QrvlHUOPRVK
	 MFLJx/m7BdFb2U2MLkZ5xdbMV4qlky+2xhw1b2Z77JKdv4zCt4ydStNnN5wEbKhz19w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794400920;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WNLIs73HAX9Ek1Kug6m2tjkKoSTQsmiO0dW+3tYRneM=;
	b=KCy4ClSg8aH1ZVn3S2dZ8YpmtKOHakMAlVKxLC1N1WHmgGNZEBT1Y4csHoT4pTDIdqc7
	 l9l5A/5EfgfvypggZX2iiqWkkshauYnZNGueCDMRqVZJGG/JNdfML9b9Zi5MJCWB5VOJa
	 Wanh26NrPGzy6it37ykRfQfzwNxvc2CzV+vu82q+YEuUAhQmi3m9q/PzNpdCXpsktf/zd
	 bukllhFx0tsXBKQiN4XcQQUwJLfQ6tTSX/ozVBn1vepv9Fd644OiEBSD5XNwlAEfgDLQX
	 462mnFMpX30V8331rwPNJ7mwnwwtYPP3K7sAQfpmnBhUdKYdusDbYJ+O9yCHdD/5vPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=rYAEKAhu;
	arc=none smtp.remote-ip=115.124.30.99
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECAD606A31C;
	Wed, 11 Nov 2026 12:41:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9ECAD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=rYAEKAhu
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794400916; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=WNLIs73HAX9Ek1Kug6m2tjkKoSTQsmiO0dW+3tYRneM=;
	b=rYAEKAhumPWDzgSszc2vrm/NXyEkpM5xkH/fCJHSG1GYJq5D5nE3TrOTCwH2rceQUtPCs/gCCxsQEqSRH0MQA9Q8DpQb4Qu2cZJ8xrJEGGCz41sJMsHunRlGtTx454lzKXWP/X4ONtle7No2eJX3tZ+p232V+3G8mnS1AVQX1tU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XEYtCBw_1794400915;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEYtCBw_1794400915 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Nov 2026 20:41:55 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: don't wait for ordered extents in nowait buffered writes
Date: Wed, 11 Nov 2026 20:41:52 +0800
Message-Id: <20261111124152.546406-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
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

lock_and_cleanup_extent() honours @nowait when taking the extent lock,
but then waits for an overlapping ordered extent regardless of it:

  btrfs_start_ordered_extent()
    wait_event(entry->wait, BTRFS_ORDERED_COMPLETE)

BTRFS_ORDERED_COMPLETE is only set by btrfs_remove_ordered_extent(),
which runs from the ordered extent completion work, so this sleeps
uninterruptibly until that work gets to run, and it starts a
transaction.  A pwritev2(RWF_NOWAIT) buffered write must not block like
that.

This used to be limited to writes starting below i_size, because the
ordered extent lookup was guarded by a start_pos < i_size test.  Commit
ec78575dde99 ("btrfs: always wait for ordered extents to avoid OE races")
dropped that guard so that appends also wait for the ordered extent left
behind by a short direct write whose i_size was reverted, which made the
wait, and the blocking with it, unconditional.

btrfs_write_check() rejects a NOWAIT write with -EAGAIN unless the inode
has BTRFS_INODE_NODATACOW or BTRFS_INODE_PREALLOC, so the inode has to
have one of those: a chattr +C file, a preallocated file, or a nodatacow
mount.  Those are the usual setups for database files and VM images,
which is also where NOWAIT writes get used.

Given such an inode, an append write does reach the wait.  With i_size S
and a direct write of L bytes of which only W get submitted:

  task A: O_DIRECT append, short write  task B: pwritev2(RWF_NOWAIT) append
  ------------------------------------  -----------------------------------
  btrfs_split_ordered_extent() gives
  the submitted part [S, S+W) its own
  OE, so dio_data->ordered is left
  covering [S+W, S+L)
  btrfs_dio_iomap_end():
    i_size_write(max(S, S+W))
      <- i_size reverted
    btrfs_mark_ordered_extent_truncated()
    btrfs_finish_ordered_extent()
      btrfs_queue_ordered_fn()
        -> endio_write_workers
      <- the OE is still in the tree
  iomap_dio_complete()
  btrfs_inode_unlock()
                                        btrfs_buffered_write() at S+W
                                          btrfs_inode_lock(BTRFS_ILOCK_TRY)
                                            <- succeeds, A dropped it
                                          btrfs_write_check()
                                            <- passes
                                          copy_one_range()
                                            lock_and_cleanup_extent()
                                              btrfs_try_lock_extent()
                                                <- succeeds
                                              btrfs_lookup_ordered_range()
                                                <- finds A's [S+W, S+L)
                                              btrfs_start_ordered_extent()
                                                wait_event()
                                                  <- blocks here
  endio_write_workers eventually runs
  finish_ordered_fn()
    btrfs_finish_ordered_io()
      btrfs_remove_ordered_extent()
        <- sets BTRFS_ORDERED_COMPLETE,
           B finally wakes up
                                        -EAGAIN propagates back through
                                        copy_one_range() to userspace

Because i_size was reverted to S+W, start_pos equals i_size, which is
exactly the case the dropped start_pos < i_size guard used to skip.

Return -EAGAIN without starting the ordered extent instead.
copy_one_range() passes that straight back and btrfs_buffered_write()
returns it to userspace when nothing was written yet, so a nowait caller
retries from a blocking context without IOCB_NOWAIT and takes the
waiting branch then.  btrfs_try_lock_ordered_range(), which
btrfs_check_nocow_lock() uses for the same purpose, already behaves this
way.

Fixes: ec78575dde99 ("btrfs: always wait for ordered extents to avoid OE races")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/btrfs/file.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f978c6524aa03..e84e9e129169e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -916,7 +916,14 @@ lock_and_cleanup_extent(struct btrfs_inode *inode, struct folio *folio,
 				    cached_state);
 		folio_unlock(folio);
 		folio_put(folio);
-		btrfs_start_ordered_extent(ordered);
+		/*
+		 * Waiting for the ordered extent blocks uninterruptibly, which
+		 * a nowait caller must not do.  Leave it alone and let the
+		 * caller retry where blocking is acceptable, like
+		 * btrfs_try_lock_ordered_range() does.
+		 */
+		if (!nowait)
+			btrfs_start_ordered_extent(ordered);
 		btrfs_put_ordered_extent(ordered);
 		return -EAGAIN;
 	}
-- 
2.39.3

