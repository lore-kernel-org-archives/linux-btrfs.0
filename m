Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40EC33262F
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 03:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780112090; cv=none; b=BHjt8J0ayhgy44KkhkUbR39AFIkO0pXkGq0OIqdDIcXibTGbeyn6ucfp+ZpEdgKcm/lOfLJLTXSSJWoYdGDACvquv0oJaoXAI5BylNM5PHSTaXstf/h6/FTbmm1BM+eH2AOfEGe0Mkqu52WXzUYpoVAJRXKVxtwIUGvoSQq5JEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780112090; c=relaxed/simple;
	bh=cts2Mc/cG+Q0K2/b4gL1BhAwkNXQcdUHxyVVyJ0rxkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWG2K6fZJETaJ3Ytu11/Vhk0pRxrtZJWgKjxVaI7MpL5hRx5OcOaycWI/0R+ddgNvRStonA6QxUn69jfM3II4dT6W9n9WEtMt1Ghg1FSoyCUCti1/PHayP9mFe1HgtNizBPpAM2q6ztuyL2c0p1npfVDu2/jb8oZd3bZAfUStS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mVFV9k26; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mVFV9k26; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mVFV9k26";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mVFV9k26"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 244086745E;
	Sat, 30 May 2026 03:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780112083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Xgv6jFW54V02j7TZVaaVUZVaeOupmwySMpnrOY82HA=;
	b=mVFV9k266IZcmvy4Stujo0WX2Ld7XO4rgSR5pb08Ckm1nBww9UDxAg9eyDf2hv0qXT4IN3
	oSHeRMmlgLWj+kKFIke103uyorVdHp93HebIuricmmGgn+jRECqNnTluWzTrKhbFo1xs8E
	9m/LE0XoSJnphHXldklvuLu57EAlYe4=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=mVFV9k26
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780112083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Xgv6jFW54V02j7TZVaaVUZVaeOupmwySMpnrOY82HA=;
	b=mVFV9k266IZcmvy4Stujo0WX2Ld7XO4rgSR5pb08Ckm1nBww9UDxAg9eyDf2hv0qXT4IN3
	oSHeRMmlgLWj+kKFIke103uyorVdHp93HebIuricmmGgn+jRECqNnTluWzTrKhbFo1xs8E
	9m/LE0XoSJnphHXldklvuLu57EAlYe4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 26F45779A7;
	Sat, 30 May 2026 03:34:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +JaeNtFaGmorcgAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 30 May 2026 03:34:41 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: fix false IO failure after falling back to buffered write
Date: Sat, 30 May 2026 13:04:17 +0930
Message-ID: <474cf1bf278e4ec1fd66b90aa6eeb5603ae08cd4.1780112003.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780112003.git.wqu@suse.com>
References: <cover.1780112003.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 244086745E
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
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

