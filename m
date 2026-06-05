Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA394B8DF1
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650107; cv=none; b=DZZLBanRLZow9tdNbkxAyD/CmhCp9IkaurVE4pd/dPCkcXQvHU2jGZgvlwLazSsSIFSxQbwb5A5wb7IPQTJ95w24Wu7yYO1Yhr2kGazekat5Jvnhi1FOR5cyLpiAX+S6O8h700iL5i+u2NXe4ZPWu/8K6f2PPlqHaihaC66RJwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650107; c=relaxed/simple;
	bh=Js6q3nPDAhuUpN1bfJrxXLCIDr2/0J6ROiz0MA9OeOM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q88VhpVCRtnoDBSZrujz/zTpYS4BqSFOg7YyXPanrUIEazfEZgHuJMhl8q1Y6oGy9ErugIqEO3VFl2mXK9s/bBm5GnS85PAp5TWgKT2incjJIT8otN3bCyuyheeZwAq046pS5urOsb3WSLy+e5bXdhVjiwN+IMNrThPIcaIxFhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=g1r7KktB; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=g1r7KktB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="g1r7KktB";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="g1r7KktB"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A91EF7588C
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780650092; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=su4VSHdgQGw99Pa5DaMmRpbBUmlA8lpd5l2pePXWAw8=;
	b=g1r7KktB+HjyGSY4quaO9ouLitwof4Vmii+PoD2jySz/xMZ8CE/QH6c91uABN2kQLQG7ad
	ctk6g+hdVZW1KC29nNshu/Plf3jkHnhV9iiUNzz8Y6Hv5XcQjzogU9wwc9RUoO6dSGwBZx
	qI0QpthsGf/xoeXelvbbG1kyLVJj0r4=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=g1r7KktB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780650092; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=su4VSHdgQGw99Pa5DaMmRpbBUmlA8lpd5l2pePXWAw8=;
	b=g1r7KktB+HjyGSY4quaO9ouLitwof4Vmii+PoD2jySz/xMZ8CE/QH6c91uABN2kQLQG7ad
	ctk6g+hdVZW1KC29nNshu/Plf3jkHnhV9iiUNzz8Y6Hv5XcQjzogU9wwc9RUoO6dSGwBZx
	qI0QpthsGf/xoeXelvbbG1kyLVJj0r4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB8EF779A8
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:01:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KFiCFmuQImrFDAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2026 09:01:31 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs: refactor btrfs_dio_iomap_end()
Date: Fri,  5 Jun 2026 18:31:06 +0930
Message-ID: <2b04182f3a630e5028b9eec29a1420d7d786ee22.1780645090.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780645090.git.wqu@suse.com>
References: <cover.1780645090.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A91EF7588C
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

That function has the following problems:

- Read/write handling scattered across different locations
  E.g. At the beginning there is a dedicated hole read handling, but
  later short read handling is at an if() branch.

- Modifying of @pos and @length parameter for short read
  Although it's completely fine to modify those parameters as they are
  passed by value, but it can still be confusing to read.
  As normally we would assume @pos and @length to be the original range.

  But for short IO handling we modify @pos/@length, and completely
  ignore @written.

- Unnecessary split for ordered extent and changeset handling
  Both OE and changeset are only for writes, but they are handled in two
  different if (write) {} blocks.

Refactor the function so that:

- Handling of reads and writes are concentrated in their code block
  Now the handling of reads are in its own small if () branch.

  Leaving the more complex writes handling to take the remaining
  function, and reduce the indent level.

  This also removes all unnecessary "if (write)" checks.

- Do not modify @pos and @length
  Let short IO handling to manually calculate the remaining range.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/direct-io.c | 125 ++++++++++++++++++++++---------------------
 1 file changed, 65 insertions(+), 60 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index e25f36eddb51..f2a68c3e31e5 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -621,74 +621,79 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	const bool write = !!(flags & IOMAP_WRITE);
 	int ret = 0;
 
-	if (!write && (iomap->type == IOMAP_HOLE)) {
-		/* If reading from a hole, unlock and return */
-		btrfs_unlock_dio_extent(&BTRFS_I(inode)->io_tree, pos,
-					pos + length - 1, NULL);
+	if (!write) {
+		/*
+		 * Hole read, nothing is submitted, thus we have to unlock
+		 * the whole range.
+		 */
+		if (iomap->type == IOMAP_HOLE) {
+			btrfs_unlock_dio_extent(&BTRFS_I(inode)->io_tree, pos,
+						pos + length - 1, NULL);
+			return 0;
+		}
+		/*
+		 * Short read, needs to unlock the remaining range, and
+		 * return -ENOTBLK so we can later fault in the pages and retry.
+		 */
+		if (written < length) {
+			btrfs_unlock_dio_extent(&BTRFS_I(inode)->io_tree, pos + written,
+						pos + length - 1, NULL);
+			return -ENOTBLK;
+		}
+		/* The full range is submitted, endio will do the unlock. */
 		return 0;
 	}
 
 	if (written < length) {
-		pos += written;
-		length -= written;
-		if (write) {
-			/*
-			 * Got a short write and have updated the isize, need to
-			 * revert the isize change.
-			 *
-			 * Normally we need to update isize with extent lock hold,
-			 * but we're safe due to the following factors:
-			 *
-			 * - Only a single writer can be enlarging isize
-			 *   Enlarging isize will take the exclusive inode lock.
-			 *
-			 * - Buffered readers need to wait for the OE we're holding
-			 *   Buffered readers will lock extent and wait for OE
-			 *   of the folio range, and since page cache is invalidated
-			 *   the OE wait can not be skipped.
-			 *
-			 * So here we are safe to revert the isize before
-			 * finishing the OE, and no reader of the remaining range
-			 * can see the enlarged size.
-			 *
-			 * TODO: Extend the DIO_LOCKED lifespan for direct writes,
-			 * and only enlarge isize after a successful write.
-			 */
-			if (dio_data->updated_isize) {
-				u64 new_isize;
+		/*
+		 * Got a short write and have updated the isize, need to
+		 * revert the isize change.
+		 *
+		 * Normally we need to update isize with extent lock hold,
+		 * but we're safe due to the following factors:
+		 *
+		 * - Only a single writer can be enlarging isize
+		 *   Enlarging isize will take the exclusive inode lock.
+		 *
+		 * - Buffered readers need to wait for the OE we're holding
+		 *   Buffered readers will lock extent and wait for OE
+		 *   of the folio range, and since page cache is invalidated
+		 *   the OE wait can not be skipped.
+		 *
+		 * So here we are safe to revert the isize before
+		 * finishing the OE, and no reader of the remaining range
+		 * can see the enlarged size.
+		 *
+		 * TODO: Extend the DIO_LOCKED lifespan for direct writes,
+		 * and only enlarge isize after a successful write.
+		 */
+		if (dio_data->updated_isize) {
+			u64 new_isize;
 
-				if (written == 0)
-					new_isize = dio_data->old_isize;
-				else
-					new_isize = max(dio_data->old_isize, pos);
-				i_size_write(inode, new_isize);
-				dio_data->updated_isize = false;
-			}
-			/*
-			 * We have a short write, if there is any range
-			 * that is submitted properly, that part will have
-			 * its own OE split from the original one.
-			 *
-			 * So for the OE at dio_data->ordered, it's the part
-			 * that is not submitted, and should be marked
-			 * as fully truncated.
-			 */
-			btrfs_mark_ordered_extent_truncated(dio_data->ordered, 0);
-			btrfs_finish_ordered_extent(dio_data->ordered,
-						    pos, length, true);
-		} else {
-			btrfs_unlock_dio_extent(&BTRFS_I(inode)->io_tree, pos,
-						pos + length - 1, NULL);
+			if (written == 0)
+				new_isize = dio_data->old_isize;
+			else
+				new_isize = max(dio_data->old_isize, pos + written);
+			i_size_write(inode, new_isize);
+			dio_data->updated_isize = false;
 		}
+		/*
+		 * We have a short write, if there is any range
+		 * that is submitted properly, that part will have
+		 * its own OE split from the original one.
+		 *
+		 * So for the OE at dio_data->ordered, it's the part
+		 * that is not submitted, and should be marked
+		 * as fully truncated.
+		 */
+		btrfs_mark_ordered_extent_truncated(dio_data->ordered, 0);
+		btrfs_finish_ordered_extent(dio_data->ordered,
+					    pos + written, length - written, true);
 		ret = -ENOTBLK;
 	}
-	if (write) {
-		btrfs_put_ordered_extent(dio_data->ordered);
-		dio_data->ordered = NULL;
-	}
-
-	if (write)
-		extent_changeset_free(dio_data->data_reserved);
+	btrfs_put_ordered_extent(dio_data->ordered);
+	dio_data->ordered = NULL;
+	extent_changeset_free(dio_data->data_reserved);
 	return ret;
 }
 
-- 
2.54.0

