Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E009323EAB8
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 05:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779858433; cv=none; b=DGyLlM4vDjShX0q4hhQPEHb/xTl5B8MPuMW8DHl92WNY6FHxqhlhssmIwSRCJGbVQicTFDR9H4mtYS+wDj4SH1cOpuT3LD/L1V0hEYezdp4cnxgzKKu0dJx2SUf2O10AuyBHLLq45jb7tqJkmip1d+09khNMV/vxvk7+A1S+IEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779858433; c=relaxed/simple;
	bh=Xe4vbAnF3TQ2SQqYaQOBnrNU9xy9WAIiCYzOa1CtLd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdHfPBUsHwx9c4QLwxrpcrQ1UcpPD/ZjySJp8dT3VlDVFUL/a9RWfrltQSpO4seP3dQ+3Ag5JNnoNDNB1Sc1QbLK4W4JtlUpXnSez1QruuQo5y7iVpSqEOvxUeMPNId2uWuL77VcVf9n2hCtC1u2+n94A+V7am1e2zZL7o0T4IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kFigW/Xe; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qvGW6gqs; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kFigW/Xe";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qvGW6gqs"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E8C0766D0E;
	Wed, 27 May 2026 05:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779858430; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+QpChJEjGUqI6fGAyhi/SABoy0dYNdvVY7zDkFrfHW0=;
	b=kFigW/Xen0DTcuzmMqnJLT6eQsqUuZ/bxzmb7zrD+1YLoQ3LtAYiiPK8EHEeYwcnw+VHUu
	T86Q6qbis8qwVunhWC8qht6q+sB3IsUmwSEurj9Ux3qgAfIr44RBP/SRkBMhvrrHL5rKog
	S/LxkbrnJuSVa4G3qF7lj5DufnfLPQw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=qvGW6gqs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779858429; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+QpChJEjGUqI6fGAyhi/SABoy0dYNdvVY7zDkFrfHW0=;
	b=qvGW6gqsMuX+YrRPO1sb/r23r8V3fm6gEhqTVa6Cm63jL4Ieub6kbylJP0ayzBos6P+eJb
	Lc8F3Kr2PfSkCGykEBIYvq54t0F6UTXzT4ICFKN6YG47VdcSXuwSa4vpeGmO9FPYiIGYyj
	qZIv8lRcfq1yP+9hCMRiK+YkS9Eu9bs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB6AF5A653;
	Wed, 27 May 2026 05:07:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eAkIK/x7Fmo4AQAAD6G6ig
	(envelope-from <wqu@suse.com>); Wed, 27 May 2026 05:07:08 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix false IO failure after falling back to buffered IO
Date: Wed, 27 May 2026 14:36:44 +0930
Message-ID: <b3393b113c45ac7bd7b2649576b5667395c22a1b.1779846117.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779846117.git.wqu@suse.com>
References: <cover.1779846117.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E8C0766D0E
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCPT_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.com:+]

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
https://lore.kernel.org/linux-btrfs/20260526070055.60193-1-wqu@suse.com/

[CAUSE]
Btrfs direct write disable page fault of the input buffer, this is to
avoid a deadlock specific to btrfs.

So for the test case generic/362, it uses an anonymous page as input
buffer. And since the page is not yet faulted in, the direct IO will
fail with -EFAULT, causing us to go through the following call chain:

 btrfs_direct_write()
 |- btrfs_dio_write()
 |  |- btrfs_dio_iomap_end()
 |     |- btrfs_finish_ordered_extent(uptodate = false);
 |        |- can_finish_ordered_extent()
 |           |- btrfs_mark_ordered_extent_error()
 |              |- mapping_set_error()
 |                 Now the address space is marked error.
 |
 |- iomap_dio_complete()
 |  The dio bio is empty, nothing submitted.
 |
 |- Fallback to buffered
 |  And the buffered write finished without error
 |
 |- filemap_fdatawait_range()
    |- filemap_check_errors()
       The previous error is recorded, thus an error is returned

However the buffered write is properly submitted and finished, the error
is from the previous short dio write.

[FIX]
When a short dio write happened, we shouldn't mark it as an error, but
treat it like a truncated write.

Extract a helper, btrfs_mark_ordered_extent_truncated(), and utilize
that helper to mark the direct IO ordered extent as truncated, so it
won't cause failure for the later buffered fallback.

Cc: stable@vger.kernel.org # 6.1+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/direct-io.c    | 18 +++++++++++++-----
 fs/btrfs/inode.c        |  6 +-----
 fs/btrfs/ordered-data.c | 12 ++++++++++++
 fs/btrfs/ordered-data.h |  2 ++
 4 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 57167d56dc72..598480b77002 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -610,6 +610,7 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 {
 	struct iomap_iter *iter = container_of(iomap, struct iomap_iter, iomap);
 	struct btrfs_dio_data *dio_data = iter->private;
+	struct btrfs_ordered_extent *ordered = dio_data->ordered;
 	size_t submitted = dio_data->submitted;
 	const bool write = !!(flags & IOMAP_WRITE);
 	int ret = 0;
@@ -624,16 +625,23 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	if (submitted < length) {
 		pos += submitted;
 		length -= submitted;
-		if (write)
-			btrfs_finish_ordered_extent(dio_data->ordered,
-						    pos, length, false);
-		else
+		if (write) {
+			/*
+			 * We got a short write, will fallback to buffered IO
+			 * for the whole range.
+			 * Set the truncate length to 0, so that no real file
+			 * extent item will be created.
+			 */
+			btrfs_mark_ordered_extent_truncated(ordered, 0);
+			btrfs_finish_ordered_extent(ordered, pos, length, true);
+		} else {
 			btrfs_unlock_dio_extent(&BTRFS_I(inode)->io_tree, pos,
 						pos + length - 1, NULL);
+		}
 		ret = -ENOTBLK;
 	}
 	if (write) {
-		btrfs_put_ordered_extent(dio_data->ordered);
+		btrfs_put_ordered_extent(ordered);
 		dio_data->ordered = NULL;
 	}
 
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

