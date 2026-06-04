Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF36211A09
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jun 2026 00:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780533019; cv=none; b=LSPeZtd+NqceQNIcjCiCqr45bmM97P67LYfYrcFyPRoQw4nkrPLYcBEEv/2jEHPLbi8B6y3denAKfejmdXrF+qbPY+xLnEWBMgUMsaOiNAsiRtQDy8lvZ8g0eGozwel+p7R6ipwv1o8ieiwabdmAa0q0wrpZtBtFyTHIQMY/F6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780533019; c=relaxed/simple;
	bh=UWQWILIdcM1CLrB1HK3AKN90Usah8nVqdAJjhNC8cqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acHB1h6CtyfpAb+KYasUi1OWYlXYI0P91aHtyKtc7z7R1nQwSv+JrEnf3GTuscYW/WWQgReGbZAZx8p6zoY1INfWrrTRJOqHy0d+ybWgO+sw8FnuddVzKV7WeIec7XcajwCpUt5Z7lZrvHJGI7XLUgArYqHHsn3aoOU+aJ4eU8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=peC1SErS; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=K5rCRa+R; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="peC1SErS";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="K5rCRa+R"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D99716AAA4;
	Thu,  4 Jun 2026 00:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780533011; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u3ftRblBzNibBc26cg++/79dE9KT6v9fZ9MsyUXgqVM=;
	b=peC1SErSahuwEx8faDPKN9r54HzbL/w0AzDtdkk1ztbUWYNYZ+gFFmPBAIH2q/CxK3LTTz
	BB9KFxVH4iHzHIuD9R2+bsEaf+JkEpF/rR/p4i1vsgPnLOBhWG7Qtgfw4Rn/bnlu3Jz9W8
	LuJCs3G5/ku33knDWP2OkAciF/TEqLM=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780533010; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u3ftRblBzNibBc26cg++/79dE9KT6v9fZ9MsyUXgqVM=;
	b=K5rCRa+RxcKrPOEvEZJMaUDg8e0TnMCCDlYdR0Nie0eWMyJyD9hlE5tQEFKs9p6kxakXm2
	3f0YZZSSWiU1RmWxL99+bKJ6BFAQIuGDjU9NxW/xwXdzaCz6LNDuwRWw3+Qk7Sk1v4F6Pv
	Xpo/sr2X4qYLsNbjTkShUljHeRhdkKQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 372F0779A9;
	Thu,  4 Jun 2026 00:30:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EJBmNRDHIGqsVgAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 04 Jun 2026 00:30:08 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org,
	Boris Burkov <boris@bur.io>
Subject: [PATCH v3 1/3] btrfs: fix false IO failure after falling back to buffered write
Date: Thu,  4 Jun 2026 09:59:46 +0930
Message-ID: <0ad7488de0b2c737e3ff1ff522358bc218471b66.1780528155.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780528155.git.wqu@suse.com>
References: <cover.1780528155.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

[BUG]
The test case generic/362 will fail with "nodatasum" mount option (*):

 MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch

 generic/362  0s ... - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
    --- tests/generic/362.out	2024-08-24 15:31:37.200000000 +0930
    +++ /home/adam/xfstests/results//generic/362.out.bad	2026-05-27 10:21:17.574771567 +0930
    @@ -1,2 +1,3 @@
     QA output created by 362
    +First write failed: Input/output error
     Silence is golden
    ...

*: If the test case has been executed before with default data checksum,
the failure will not reproduce. Need the following fix to make it
reliably reproducible:
https://lore.kernel.org/linux-btrfs/20260528111659.87113-1-wqu@suse.com/

[CAUSE]
Inside __iomap_dio_rw(), the -EFAULT/-ENOTBLK error is not directly returned.
Thus we never got an error pointer from __iomap_dio_rw().

The call chain looks like this:

 btrfs_direct_write()
 |- btrfs_dio_write()
 |-  __iomap_dio_rw()
 |  |- iomap_iter()
 |  |  |- btrfs_dio_iomap_begin()
 |  |     Now an ordered extent is allocated for the 4K write.
 |  |
 |  |- iomi.status = iomap_dio_iter()
 |  |  Where iomap_dio_iter() returned -EFAULT.
 |  |
 |  |- ret = iomap_iter()
 |  |  |- btrfs_dio_iomap_end()
 |  |  |  |- btrfs_finish_ordered_extent(uptodate = false)
 |  |  |  |  |- can_finish_ordered_extent()
 |  |  |  |     |- btrfs_mark_ordered_extent_error()
 |  |  |  |        |- mapping_set_error()
 |  |  |  |           Now the address space is marked error.
 |  |  |  | return -ENOTBLK
 |  |  |- return -ENOTBLK
 |  |- if (ret == -ENOTBLK) { ret = 0; }
 |     Now the return value is reset to 0.
 |     Thus no error pointer will be returned.
 |
 |- ret = iomap_dio_complete()
 |  Since no byte is submitted, @ret is 0.
 |
 |- Fallback to buffered IO
 |  And the buffered write finished without error
 |
 |- filemap_fdatawait_range()
    |- filemap_check_errors()
       The previous error is recorded, thus an error is returned

However the buffered write is properly submitted and finished, the error
is from the btrfs_finish_ordered_extent() call with @uptodate = false.

[FIX]
When a short dio write happened, any range that is submitted will have
btrfs_extract_ordered_extent() to be called, thus the submitted range
will always have an OE just covering the submitted range.

The remaining OE range is never submitted, thus they should be treated
as truncated, not an error. So that we can properly reclaim and not
insert an unnecessary file extent item, without marking the mapping as
error.

Extract a helper, btrfs_mark_ordered_extent_truncated(), and utilize
that helper to mark the direct IO ordered extent as truncated, so it
won't cause failure for the later buffered fallback.

[REASON FOR NO FIXES TAG]
The bug itself is pretty old, at commit f85781fb505e ("btrfs: switch to
iomap for direct IO") we're already passing @uptodate=false finishing
the OE.
But at that time OE with IOERR won't call mapping_set_error(), so it's
not exposed.
Later commit d61bec08b904 ("btrfs: mark ordered extent and inode with
error if we fail to finish") finally exposed the bug, but that commit
is doing a correct job, not the root cause.

Anyway the bug is very old, dating back to 5.1x days, thus only CC to
stable.

Cc: stable@vger.kernel.org # 5.15+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/direct-io.c    | 17 ++++++++++++++---
 fs/btrfs/inode.c        |  6 +-----
 fs/btrfs/ordered-data.c | 12 ++++++++++++
 fs/btrfs/ordered-data.h |  2 ++
 4 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 57167d56dc72..88cb2e82a507 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -624,12 +624,23 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	if (submitted < length) {
 		pos += submitted;
 		length -= submitted;
-		if (write)
+		if (write) {
+			/*
+			 * We have a short write, if there is any range
+			 * that is submitted properly, that part will have
+			 * its own OE split from the original one.
+			 *
+			 * So for the OE at dio_data->ordered, it's the part
+			 * that is not submitted, and should be marked
+			 * as fully truncated.
+			 */
+			btrfs_mark_ordered_extent_truncated(dio_data->ordered, 0);
 			btrfs_finish_ordered_extent(dio_data->ordered,
-						    pos, length, false);
-		else
+						    pos, length, true);
+		} else {
 			btrfs_unlock_dio_extent(&BTRFS_I(inode)->io_tree, pos,
 						pos + length - 1, NULL);
+		}
 		ret = -ENOTBLK;
 	}
 	if (write) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 973a89301baa..2c0131452754 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7590,11 +7590,7 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
 					       EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
 					       EXTENT_DEFRAG, &cached_state);
 
-		spin_lock(&inode->ordered_tree_lock);
-		set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
-		ordered->truncated_len = min(ordered->truncated_len,
-					     cur - ordered->file_offset);
-		spin_unlock(&inode->ordered_tree_lock);
+		btrfs_mark_ordered_extent_truncated(ordered, cur - ordered->file_offset);
 
 		/*
 		 * If the ordered extent has finished, we're safe to delete all
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index f5f77c33cf59..b32d4eabe0ab 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -358,6 +358,18 @@ void btrfs_mark_ordered_extent_error(struct btrfs_ordered_extent *ordered)
 		mapping_set_error(ordered->inode->vfs_inode.i_mapping, -EIO);
 }
 
+void btrfs_mark_ordered_extent_truncated(struct btrfs_ordered_extent *ordered,
+					 u64 truncate_len)
+{
+	struct btrfs_inode *inode = ordered->inode;
+
+	ASSERT(truncate_len <= ordered->num_bytes);
+	spin_lock(&inode->ordered_tree_lock);
+	set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
+	ordered->truncated_len = min(ordered->truncated_len, truncate_len);
+	spin_unlock(&inode->ordered_tree_lock);
+}
+
 static void finish_ordered_fn(struct btrfs_work *work)
 {
 	struct btrfs_ordered_extent *ordered_extent;
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 03e12380a2fd..8d5d5ba1e02f 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -226,6 +226,8 @@ bool btrfs_try_lock_ordered_range(struct btrfs_inode *inode, u64 start, u64 end,
 struct btrfs_ordered_extent *btrfs_split_ordered_extent(
 			struct btrfs_ordered_extent *ordered, u64 len);
 void btrfs_mark_ordered_extent_error(struct btrfs_ordered_extent *ordered);
+void btrfs_mark_ordered_extent_truncated(struct btrfs_ordered_extent *ordered,
+					 u64 truncate_len);
 int __init ordered_data_init(void);
 void __cold ordered_data_exit(void);
 
-- 
2.54.0

