Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917731;
	b=JFN/D9jFWuQlhOiB1Rvh1Qo3VuUrJxH53tOFSNqM9aozMtfevmiyJHOQOGElbAEp1HWt
	 AScaA6WHSrat5p47HasixiXbaVK2xYRjAG0sDLNUJyu6UvESAU+qoI13j8Kb0AMXvG++k
	 nqqvBaTKsTXZANsh7rdXjlSYGOOxZldMzGmHh+PtLk2g70B+Px1Ymz8U0L+T0Fx/WNgPM
	 1DtFOT/b0/ucXUapMed3qKCmR5ETui4YXjWz2RMTTgF66ljdZJsylpE6yTt2GojPu3Wdf
	 8y5vphyjMqKhXUZ7RFzySDStdK6hhfbL2RJ7st901J03mUhuBbTSojPNrOkfG74G4KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917731;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=O/tW7w8dnVX5rVk0qHJc45R5Y1XqzMM8Jj8LCsfuhpY=;
	b=rN8ArQHihzx2QUZiogj8oM41m+U47gPO1GLyhEicWJOp61PuAz5hdmxjyEhxlOrNUZUO
	 pMETAIPosEmaDna1v0tCrJRxUmqgQdmGjoHhbBE+muc9gfJezAlJqxzQNBSmeNf9V86Zm
	 tOA2cgrVjtZ4Vwcy2lqapWV71W8uaUwoJ3PIUfBNBzOMDeeO41sfeBMZ78yDONJx1iyCy
	 4DN37A/7FSXadhremekfJs6igQ4T7rt45WW+li7/kEamTpnzA/zEpkaovHES5DeWNi7wN
	 NB/mibl5Tkfrdxh2ZEg+xLJvvIvJv7e9SmRSG4HhUAJlx0yIxRt0ptPqo29mIuUSdOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kA+8g44R;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kA+8g44R;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DCB606A325
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14DCB606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kA+8g44R;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kA+8g44R
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8B8941F395
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917729; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O/tW7w8dnVX5rVk0qHJc45R5Y1XqzMM8Jj8LCsfuhpY=;
	b=kA+8g44R6A/8QNE7rAY37jUwnnD2PubE8mcJPYgzIZPxrXWBdhlR/0BYL+b0Dr0Gq+McvE
	C00UhM6vPBCQ5t5dD8vrD378yOV0J+N/u+vUZI9inCSuhVtqU0FVgkalh/yNdZv9lV07ji
	Ax/cyIaugjhX1A1uc5WlSmgSxx+fFUk=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917729; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O/tW7w8dnVX5rVk0qHJc45R5Y1XqzMM8Jj8LCsfuhpY=;
	b=kA+8g44R6A/8QNE7rAY37jUwnnD2PubE8mcJPYgzIZPxrXWBdhlR/0BYL+b0Dr0Gq+McvE
	C00UhM6vPBCQ5t5dD8vrD378yOV0J+N/u+vUZI9inCSuhVtqU0FVgkalh/yNdZv9lV07ji
	Ax/cyIaugjhX1A1uc5WlSmgSxx+fFUk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7314B13314
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mglvH9zA3Wq5HgAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:08 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 02/12] btrfs-progs: image: only remove a chunk map from physical tree if non-empty
Date: Sun, 25 Oct 2026 19:11:36 +1030
Message-ID: <5e4b6392c7d1bc135e9f3ad61e2239c17abf5c27.1792914402.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792914402.git.wqu@suse.com>
References: <cover.1792914402.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

During read_chunk_tree_block(), if a chunk is already in the physical
tree, then the fs_chunk is only added to overlapping_chunks list, but
not yet inserted into the physical_tree, since inserting it would
conflict with the existing chunk

Then remap_overlapping_chunks() remap the chunk into a new location, and
re-insert the updated fs_chunk into physical tree.

However if some error happened before remap_overlapping_chunks() is
called, one fs_chunk can be linked to overlapping_chunks list, but its
rbtree entry is not properly initialized (all zero), then
mdrestore_destroy() still calls rb_erase() on the uninitialized entry.

Fix the problem by always clearing the allocated fs_chunk->p.
Then at mdrestore_destroy() only call rb_erase() if the rb tree pointer
is not empty.

Assisted-by: LLM (exposing the bug)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/image-restore.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/image/image-restore.c b/image/image-restore.c
index 9bc11ea5e7d9..b1de96c51efa 100644
--- a/image/image-restore.c
+++ b/image/image-restore.c
@@ -66,7 +66,8 @@ static void mdrestore_destroy(struct mdrestore_struct *mdres, int num_threads)
 
 		entry = rb_entry(n, struct fs_chunk, l);
 		rb_erase(n, &mdres->chunk_tree);
-		rb_erase(&entry->p, &mdres->physical_tree);
+		if (!RB_EMPTY_NODE(&entry->p))
+			rb_erase(&entry->p, &mdres->physical_tree);
 		free(entry);
 	}
 	free_extent_cache_tree(&mdres->sys_chunks);
@@ -806,6 +807,7 @@ static int read_chunk_tree_block(struct mdrestore_struct *mdres,
 		fs_chunk->physical = btrfs_stripe_offset_nr(eb, chunk, 0);
 		fs_chunk->bytes = btrfs_chunk_length(eb, chunk);
 		INIT_LIST_HEAD(&fs_chunk->list);
+		RB_CLEAR_NODE(&fs_chunk->p);
 
 		if (tree_search(&mdres->physical_tree, &fs_chunk->p,
 				physical_cmp, 1) != NULL)
-- 
2.56.0

