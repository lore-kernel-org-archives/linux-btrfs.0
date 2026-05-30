Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4746D346A0D
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 03:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780112087; cv=none; b=Sz5Ix21cwsjh5n6UNQbluGmGV/jbUdCq9iRYlQSaY66ZFdCCM6E8otV6T0JGUj0X+yZDxqAkuLM31RZNL9c68FFJbzoAxqv7Q7pIRadNilUNRSjYBdue/vzRA/8ZTu+yNFDoHC5NT5M7rNrpFGU2vG1mHmVUMFB72nGCRe5/J8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780112087; c=relaxed/simple;
	bh=ArIitXR7/VK315NSr/rYK/f1qb203xhujc0eSXdktTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwCWbXFfY9gT2/4vpvy8FCwfRc/BvfqvX+Aoy05cHWzcQzofdei8Sf0TY6kFEdHvHnlsUK2PWe8VAFOapcexnYF3ly1Vzv/2w2mqTnS/aW2IPU/4EdkQemdlslSe88PCmAeigndHZMfkOgAIljx6cSI/SQdmIC8IGutA6MCPZQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=vPpvT4hG; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=vPpvT4hG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="vPpvT4hG";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="vPpvT4hG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 948766AC6E;
	Sat, 30 May 2026 03:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780112084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mG+y3P3ZmXCbN2L5iELW4Nrm4sVulxrHK4grkSQ9nTM=;
	b=vPpvT4hG9YBpQNnTgx+yjI9cWmi+Et7kBQ3hs1bPfxbt1ee5BUj1ugkV9ufInxgKSh3x8e
	Ib9gDVZvy7Fcwk40cy4Gq2/oD7ajVxS+8+BnRAs4/jLl+zfC7T+Cnkzok/Rk+n7+slo3NY
	r9gTEQ0kmMbizUCS9lKQakgtlDf7Gdg=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=vPpvT4hG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780112084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mG+y3P3ZmXCbN2L5iELW4Nrm4sVulxrHK4grkSQ9nTM=;
	b=vPpvT4hG9YBpQNnTgx+yjI9cWmi+Et7kBQ3hs1bPfxbt1ee5BUj1ugkV9ufInxgKSh3x8e
	Ib9gDVZvy7Fcwk40cy4Gq2/oD7ajVxS+8+BnRAs4/jLl+zfC7T+Cnkzok/Rk+n7+slo3NY
	r9gTEQ0kmMbizUCS9lKQakgtlDf7Gdg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96DE2779A7;
	Sat, 30 May 2026 03:34:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CMRjFtNaGmorcgAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 30 May 2026 03:34:43 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: fix incorrect buffered IO fallback for append direct writes
Date: Sat, 30 May 2026 13:04:18 +0930
Message-ID: <8f3a0006edc5014c1de15b669f4d8c6d2aea3d61.1780112003.git.wqu@suse.com>
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
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 948766AC6E
X-Rspamd-Action: no action
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim,suse.com:mid];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

[BUG]
With the previous bug of short direct writes fixed, test case
generic/362 (*) still fails with the following error with nodatasum
mount option:

 generic/362  0s ... - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
 - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
    --- tests/generic/362.out	2024-08-24 15:31:37.200000000 +0930
    +++ /home/adam/xfstests/results//generic/362.out.bad	2026-05-27 10:13:09.072485767 +0930
    @@ -1,2 +1,3 @@
     QA output created by 362
    +Wrong file size after first write, got 8192 expected 4096
     Silence is golden
    ...

*: If the test case has been executed before with default data checksum,
the failure will not reproduce. Need the following fix to make it
reliably reproducible:
https://lore.kernel.org/linux-btrfs/20260528111659.87113-1-wqu@suse.com/

[CAUSE]
Inside btrfs_dio_iomap_begin() for a direct write, we increase the isize
if it's beyond the current isize.

But if the direct io finished short , we do not revert the isize to the
previous value nor to the short write end.

Then if we need to fall back to buffered writes, and the write has
IOCB_APPEND flag, then the buffered write will be positioned at the
incorrect isize.

The call chain looks like this:

 btrfs_direct_write(pos=0, length=4K)
 |- __iomap_dio_rw()
 |  |- iomap_iter()
 |  |  |- btrfs_dio_iomap_begin()
 |  |     |- btrfs_get_blocks_direct_write()
 |  |        |- i_size_write()
 |  |           Which updates the isize to the write end (4K).
 |  |
 |  |- iomap_dio_iter()
 |  |  Failed with -EFAULT on the first page.
 |  |
 |  |- iomap_iter()
 |  |  |- btrfs_dio_iomap_end()
 |  |     Detects a short write, return -ENOTBLK
 |  |- if (ret == -ENOTBLK) { ret = 0;}
 |     Which resets the return value.
 |
 |- ret = iomap_dio_complet()
 |  Which returns 0.
 |
 |- btrfs_buffered_write(iocb, from);
    |- generic_write_checks()
       |- iocb->ki_pos = i_size_read()
          Which is still the new size (4K), other than the original
	  isize 0.

[FIX]
Introduce btrfs_dio_data::updated_isize and btrfs_dio_data::old_isize,
so that if btrfs_get_blocks_direct_write() enlarged the inode size for
the first time, we still know the old isize.

Then if we got a short write, and btrfs_dio_data::updated_isize is set,
revert to the correct isize based on the old isize and the short write
end.

[REASON FOR NO FIXES TAG]
The bug is again very old, before commit f85781fb505e ("btrfs: switch to
iomap for direct IO") we are already increasing isize without a
proper rollback for short writes.

Thus only a CC to stable.

Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/direct-io.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 88cb2e82a507..fd53fac7186e 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -15,10 +15,16 @@
 
 struct btrfs_dio_data {
 	ssize_t submitted;
+	/*
+	 * If we got a short dio write and @updated_isize is set,
+	 * revert to the old isize.
+	 */
+	loff_t old_isize;
 	struct extent_changeset *data_reserved;
 	struct btrfs_ordered_extent *ordered;
 	bool data_space_reserved;
 	bool nocow_done;
+	bool updated_isize;
 };
 
 struct btrfs_dio_private {
@@ -228,6 +234,7 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 	bool space_reserved = false;
 	u64 len = *lenp;
 	u64 prev_len;
+	loff_t old_isize;
 	int ret = 0;
 
 	/*
@@ -341,8 +348,14 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 	 * Need to update the i_size under the extent lock so buffered
 	 * readers will get the updated i_size when we unlock.
 	 */
-	if (start + len > i_size_read(inode))
+	old_isize = i_size_read(inode);
+	if (start + len > old_isize) {
+		if (!dio_data->updated_isize) {
+			dio_data->old_isize = old_isize;
+			dio_data->updated_isize = true;
+		}
 		i_size_write(inode, start + len);
+	}
 out:
 	if (ret && space_reserved) {
 		btrfs_delalloc_release_extents(BTRFS_I(inode), len);
@@ -637,6 +650,16 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 			btrfs_mark_ordered_extent_truncated(dio_data->ordered, 0);
 			btrfs_finish_ordered_extent(dio_data->ordered,
 						    pos, length, true);
+			if (dio_data->updated_isize) {
+				u64 new_isize;
+
+				if (submitted == 0)
+					new_isize = dio_data->old_isize;
+				else
+					new_isize = max(pos, dio_data->old_isize);
+				i_size_write(inode, new_isize);
+				dio_data->updated_isize = false;
+			}
 		} else {
 			btrfs_unlock_dio_extent(&BTRFS_I(inode)->io_tree, pos,
 						pos + length - 1, NULL);
-- 
2.54.0

