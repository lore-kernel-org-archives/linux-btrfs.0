Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC77823A566
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 01:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777511274; cv=none; b=ZMze/qqfbN5Hu9PJ1n7XLRlKLiXBQJAppR04bqjlIapdFpY4HicnZ+OY6V6c9yz/8Av58uZIHLmqX94txjK2xSjfiXYiSBs1jrnreLaYKsrKkPjFRKYACyiNxZX2Puc1apxbXV+zBYN0qWogkDz2LVTBLvOFA+svnsB1Axw7dls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777511274; c=relaxed/simple;
	bh=phYS5BGiu552kew9MVMGYc8SKpzy3z0je7TNYrG9DzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqWAQyMBQDkEpaFVFCt2H7lhgMcnrzyx8TUOdCX5XAMHS5yGbd44B9sKPcx5f/su1+IJ8B/x7Q6RFpKHtGO2ifmjvok5k1+/wCM6X9i6KLAaGSBOQjJgXrQ+VgmEFHeKUDUUtOPtU9jP3efGZwPfd0iZzCWkr44ZhiNXfepWxow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=U7TBFJj+; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=U7TBFJj+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="U7TBFJj+";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="U7TBFJj+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 193B56A7C2;
	Thu, 30 Apr 2026 01:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777511271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3LSuVdunNBqxPG46c9EbrP4WTo2JEjwwHmAFlxHofTc=;
	b=U7TBFJj+Ok3ZIo4gahHTkrBDIivFfJSjZHmXM5vstMhSTwY9x+UEQnisDZ7M7LyJd+sHq+
	cNTpMdDcVOX1vOG493Ah+y+ipoIa1BRY8k0EFXziemlSKVdvkxMG6RcwtBu8WYdlqodrsV
	34bpQV+eRTLgzr8JMS6DfIGTZ2ZQYW0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777511271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3LSuVdunNBqxPG46c9EbrP4WTo2JEjwwHmAFlxHofTc=;
	b=U7TBFJj+Ok3ZIo4gahHTkrBDIivFfJSjZHmXM5vstMhSTwY9x+UEQnisDZ7M7LyJd+sHq+
	cNTpMdDcVOX1vOG493Ah+y+ipoIa1BRY8k0EFXziemlSKVdvkxMG6RcwtBu8WYdlqodrsV
	34bpQV+eRTLgzr8JMS6DfIGTZ2ZQYW0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1E36D593B0;
	Thu, 30 Apr 2026 01:07:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oAqoNGWr8mlyWgAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 30 Apr 2026 01:07:49 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v4 1/2] btrfs: only release the dirty pages io tree after successful writes
Date: Thu, 30 Apr 2026 10:37:22 +0930
Message-ID: <d02693a5159193f02dda9c7b500e00e7ed41a171.1777510825.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777510825.git.wqu@suse.com>
References: <cover.1777510825.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

[BUG]
With the recent commit "btrfs: warn about extent buffer that can not be
released", we can trigger the following warning running test cases like
generic/388 at unmount:

 BTRFS critical (device dm-2 state E): emergency shutdown
 BTRFS error (device dm-2 state E): cow_file_range failed, root=5 inode=265 start=135168 len=118784 cur_offset=135168 cur_alloc_size=0: -5
 BTRFS error (device dm-2 state E): error while writing out transaction: -30
 BTRFS warning (device dm-2 state E): Skipping commit of aborted transaction.
 BTRFS error (device dm-2 state EA): Transaction 9 aborted (error -30)
 BTRFS: error (device dm-2 state EA) in cleanup_transaction:2068: errno=-30 Readonly filesystem
 BTRFS info (device dm-2 state EA): forced readonly
 BTRFS error (device dm-2 state EA): failed to run delalloc range, root=5 ino=265 folio=135168 submit_bitmap=0 start=135168 len=118784: -5
 BTRFS info (device dm-2 state EA): last unmount of filesystem 8b3d8748-4710-4b5a-84d9-b072cb03be2d
 ------------[ cut here ]------------
 WARNING: disk-io.c:3306 at invalidate_btree_folios+0xfd/0x1ca [btrfs], CPU#4: umount/60183
 CPU: 4 UID: 0 PID: 60183 Comm: umount Tainted: G        W  OE       7.0.0-rc6-custom+ #365 PREEMPT(full)  5804053f02137e627472d94b5128cc9fcb110e88
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
 RIP: 0010:invalidate_btree_folios+0xfd/0x1ca [btrfs]
 Call Trace:
  <TASK>
  close_ctree+0x534/0x57a [btrfs eeeee2af86b856a32e0b81b75d427a17a62ffe29]
  generic_shutdown_super+0x89/0x1a0
  kill_anon_super+0x16/0x40
  btrfs_kill_super+0x16/0x20 [btrfs eeeee2af86b856a32e0b81b75d427a17a62ffe29]
  deactivate_locked_super+0x2d/0xb0
  cleanup_mnt+0xdc/0x140
  task_work_run+0x5a/0xa0
  exit_to_user_mode_loop+0x123/0x4b0
  do_syscall_64+0x288/0x7d0
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
  </TASK>
 ---[ end trace 0000000000000000 ]---
 BTRFS warning (device dm-2 state EA): unable to release extent buffer 30507008 owner 1 gen 9 refs 2 flags 0x7
 BTRFS warning (device dm-2 state EA): unable to release extent buffer 30588928 owner 9 gen 9 refs 2 flags 0x7
 BTRFS warning (device dm-2 state EA): unable to release extent buffer 30605312 owner 257 gen 9 refs 2 flags 0x7
 BTRFS warning (device dm-2 state EA): unable to release extent buffer 30621696 owner 7 gen 9 refs 2 flags 0x7
 BTRFS warning (device dm-2 state EA): unable to release extent buffer 30638080 owner 258 gen 9 refs 2 flags 0x7
 BTRFS warning (device dm-2 state EA): unable to release extent buffer 30654464 owner 2 gen 9 refs 2 flags 0x7
 BTRFS warning (device dm-2 state EA): unable to release extent buffer 30670848 owner 10 gen 9 refs 2 flags 0x7

I'm using a stripped down version, which seems to trigger the warning
more reliably:

  _fsstress_pid=""
  workload()
  {
  	dmesg -C
  	mkfs.btrfs -f -K $dev > /dev/null
  	echo 1 > /sys/kernel/debug/clear_warn_once
  	mount $dev $mnt
  	$fsstress -w -n 1024 -p 4 -d $mnt &
  	_fsstress_pid=$!
  	sleep 0
  	$godown $mnt
  	pkill --echo -PIPE fsstress > /dev/null
  	wait $_fsstress_pid
  	unset _fsstress_pid
  	umount $mnt

  	if dmesg | grep -q "WARNING"; then
  		fail
  	fi
  }

  for (( i = 0; i < $runtime; i++ )); do
  	echo "=== $i/$runtime ==="
  	workload
  done

[CAUSE]
Inside btrfs_write_and_wait_transaction(), we first try to write all
dirty ebs, then wait for them to finish.

After that we call btrfs_extent_io_tree_release() to free all
extent states from dirty_pages io tree.

However if we hit an error from btrfs_write_marked_extent(), then we
still call btrfs_extent_io_tree_release() to clear that dirty_pages io
tree, which may contain dirty records that we haven't yet submitted.

Furthermore, the later transaction cleanup path will utilize that
dirty_pages io tree to properly cleanup those dirty ebs, but since it's
already empty, no dirty ebs are properly cleaned up, thus will later
trigger the warnings inside invalidate_btree_folios().

[FIX]
Normally such dirty ebs won't cause problems, as when the iput() is
called on the btree inode, the dirty ebs will be forcibly written back,
and since the fs is already in an error status, such writeback will not
reach disk and finish immediately.

But it's still better to get rid of such dirty ebs, if we ended up with
dirty ebs but the fs is not in an error status, then such writeback at
iput() time will be too late, as all workers are already stopped but
writeback will utilize workers, which will lead to NULL pointer
dereferences.

Instead of unconditionally calling btrfs_extent_io_tree_release(), only
call it if btrfs_write_and_wait_transaction() finished successfully, so
that @dirty_pages extent io tree is kept untouched for transaction
cleanup.

CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c     | 1 +
 fs/btrfs/transaction.c | 9 ++++-----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 308955f0592a..f28cef8217de 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4679,6 +4679,7 @@ static void btrfs_destroy_marked_extents(struct btrfs_fs_info *fs_info,
 			free_extent_buffer_stale(eb);
 		}
 	}
+	btrfs_extent_io_tree_release(dirty_pages);
 }
 
 static void btrfs_destroy_pinned_extent(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 248adb785051..194f581b36f3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1293,14 +1293,13 @@ static int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans)
 	blk_finish_plug(&plug);
 	ret2 = btrfs_wait_extents(fs_info, dirty_pages);
 
-	btrfs_extent_io_tree_release(&trans->transaction->dirty_pages);
-
 	if (ret)
 		return ret;
-	else if (ret2)
+	if (ret2)
 		return ret2;
-	else
-		return 0;
+
+	btrfs_extent_io_tree_release(&trans->transaction->dirty_pages);
+	return 0;
 }
 
 /*
-- 
2.54.0

