Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0DB4B8DE5
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650095; cv=none; b=uvmKyXVw9DSrWVUVYQIiLYe2doXBoKEYLU32FRdmHBr9EHekUcaYvX5q64USBdBb8KyaMiu+JqTzOye6HAqSjgkk0Xkz4bcBgoWKPJbTm5jLEKw/pqfaBpjZVg6tR1ER2KyttAyEmx9mXy6HjBzEoCuzdFaWFTajHzrNjwS3Ay4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650095; c=relaxed/simple;
	bh=drv4Hljsb+osm8jxJLclAsPy7tDvPX/PHGnYdK4Ly6Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAzei+E4CGxu46qISmKpvE9feoH0VgTTD2b3lQEo6CejRoqz9Lvs/JG2GMDXsZgtMjzK3QVPpF3xZ9Hf//EEE3gaz1QsbVoWoDRA+fZ5g0uQ6LvGnTBicU86a8jjkMyLuAxAMofgrmrsy369usrm9BmK12D3Rrn5waWO4SAXuY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Y38Ms956; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Y38Ms956; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Y38Ms956";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Y38Ms956"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6CFD47591A
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780650089; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pGR51XOpMhW/88yxhocum6dz5JI3JEBDoLS6Te685tQ=;
	b=Y38Ms956HxaTjLOHE3CaB4ofE+tNdXFQa45z7l3lHV8UwpCpSGbz+oEQF7GkKhlMKFOTbx
	lli3IZparncnWBKWUMBTyqFftb9QzJHMi/p4Bo0FWlDo9EHkAVhs3PC+GBPYrrdxbOeAIp
	yb5quMvV85WURWvYNFYj74Gd/MbfJWw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Y38Ms956
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780650089; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pGR51XOpMhW/88yxhocum6dz5JI3JEBDoLS6Te685tQ=;
	b=Y38Ms956HxaTjLOHE3CaB4ofE+tNdXFQa45z7l3lHV8UwpCpSGbz+oEQF7GkKhlMKFOTbx
	lli3IZparncnWBKWUMBTyqFftb9QzJHMi/p4Bo0FWlDo9EHkAVhs3PC+GBPYrrdxbOeAIp
	yb5quMvV85WURWvYNFYj74Gd/MbfJWw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6EFF9779A8
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:01:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oObBB2iQImrFDAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2026 09:01:28 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs: wait for OE to be fully removed before falling back to buffered
Date: Fri,  5 Jun 2026 18:31:04 +0930
Message-ID: <30dc9cbbaef57713552d7d00f1137c7c2b5be53e.1780645090.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 6CFD47591A
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Currently if a direct write failed for whatever reasons, e.g. page fault
failure or IO error, then we fallback to buffered IO.

But it's possible that the direct write attempt has created some ordered
extent, and they may not be fully removed from the inode io tree yet:

 btrfs_direct_write:
 |- __iomap_dio_rw()
 |  |- btrfs_dio_iomap_begin()
 |  |  |- btrfs_get_blocks_direct_write()
 |  |     |- btrfs_create_dio_extent()
 |  |        Now an OE is created for the whole range
 |  |
 |  |- iomap_dio_iter()
 |  |  Failed with -EFAULT, which is pretty common inside
 |  |  btrfs as we have set iov_iter->nofault flag.
 |  |
 |  |- btrfs_dio_iomap_end()
 |     |- btrfs_finish_ordered_extent()
 |        |- btrfs_queue_ordered_fn()
 |           The real removal of the OE is queued into a workqueue.
 |
 |- btrfs_buffered_write()
 |- btrfs_fdatawrite_range()
    |- cow_file_range()
       |- btrfs_alloc_ordered_extent()
          If the previous OE is not yet removed, a conflicting OE
	  will be inserted and trigger a panic.

Fix it by calling btrfs_wait_ordered_range() before buffered writes.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/direct-io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index c97396ca476d..8efe3a722206 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -1025,6 +1025,16 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	pos = iocb->ki_pos;
+	/*
+	 * Direct writes may have created an OE, then submitted nothing.
+	 * Although iomap_end() should have marked the OE as finished, it's
+	 * not yet removed from io-tree.
+	 * Thus we have to wait for them to be removed.
+	 */
+	ret = btrfs_wait_ordered_range(BTRFS_I(inode), pos, iov_iter_count(from));
+	if (ret < 0)
+		goto out;
+
 	written_buffered = btrfs_buffered_write(iocb, from);
 	if (written_buffered < 0) {
 		ret = written_buffered;
-- 
2.54.0

