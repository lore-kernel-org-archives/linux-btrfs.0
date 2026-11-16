Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864579;
	b=CVcXCkMrr8hmO0QaqVdBjhfl+i9Q+RwxxT3IevFKSs/rI9F9isjPibmltYEpX5/d8sgA
	 +UID3ccOFz68UU9NvNLmx9Eh1erXzOdD46QLqayn+O1r04I5EeO/1a1nopZGUKDzu+CdX
	 wNqpY8oKMPWnMt39vzmRFv/q3KRHIe13O4GTuy/6MxKfedIizfBh4E1aqBBQ7tDO/ByDv
	 lC5/KiALkFXCmYSaP2CYaRQtSqwN1QVu6e4RLoy6BuBIwAh3ZdOt9FslPcjHHs4IaKXKg
	 ot5Lf3DyEqfKimaRGYbHJL3WGkc4ASByJqZDrpMo3daBJwNbtKAadpM8XEM3bqKq6MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864579;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=bHR6zAxlLD7B4rX7lpJmYRoshazUGftcyBv/Ltvyzms=;
	b=1m96afBFOvp2UGy9QaKYKm9kVpZISPD818W0EP0s27UlQ9oE/f4ye9LKYMeNMqEHUNGc
	 MZbqFJ2ke73JUEDfdr+AD1VHMGaVKqqKfiCk7Quo5LpRyIMX7dsxpcval7gZXwsgWImnv
	 Sqg3BR9FjwBnE2AeIueWum/+9sHRlzlewJUZXfblXzNK8eYfoCe+ZZ/7jnAH+HcdwYnh0
	 XnxGoXwJF6DrZ5NOnIDW3FYMuUAX07f/zQ/ekVQ4xKQRTlh0q0gzwEHMbe25lpezQK+6s
	 0q8EJelcS/dNR+rKSrs55giRY5cHYAe9DKg961AoenupZ4msLGgIvgCYBqJSQicZJ/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=mmsfrjt+;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=mmsfrjt+;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FDA606A322
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 21:29:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8FDA606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=mmsfrjt+;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=mmsfrjt+
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 14B3A1F461
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 21:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794864576; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bHR6zAxlLD7B4rX7lpJmYRoshazUGftcyBv/Ltvyzms=;
	b=mmsfrjt+pdTx/sqd6tnU2DXXo/sIW1AquSX0io0iyQSK+WV+oTyPEghtwwQM3zy9ty9SpW
	lOzIhjX+73OebYjQwcgl99wwJx5mnQBLcKHYcdUsPwpHr2FFfsUNq6pB2H4id6iflrEIOA
	xkrQvD0moYpUZbRSdSh1kJ8mMFYzkXc=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=mmsfrjt+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794864576; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bHR6zAxlLD7B4rX7lpJmYRoshazUGftcyBv/Ltvyzms=;
	b=mmsfrjt+pdTx/sqd6tnU2DXXo/sIW1AquSX0io0iyQSK+WV+oTyPEghtwwQM3zy9ty9SpW
	lOzIhjX+73OebYjQwcgl99wwJx5mnQBLcKHYcdUsPwpHr2FFfsUNq6pB2H4id6iflrEIOA
	xkrQvD0moYpUZbRSdSh1kJ8mMFYzkXc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F0D7513408
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 21:29:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ugL8Jbp1+2oUJgAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 21:29:34 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: defrag: fix missed extent when the lookup lands on the next inode
Date: Tue, 17 Nov 2026 07:59:04 +1030
Message-ID: <099289b46c357f0b67d86ff222d828acab46c92e.1794864101.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794864101.git.wqu@suse.com>
References: <cover.1794864101.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim];
	RCPT_COUNT_ONE(0.00)[1];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 14B3A1F461

In defrag_get_extent(), if @start is inside the last extent of an inode
and the next inode's items are in the same leaf, btrfs_search_slot()
points to the next inode's item.

The code then checks the item at the current slot to decide whether to
go one slot back, which is never an EXTENT_DATA of our inode in this
case. So the extent covering @start is skipped and we return NULL.

Fix it by checking the previous item instead, which is the one that can
cover @start.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/defrag.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index c3a9f1aff922..c6482aefa2a5 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -657,9 +657,15 @@ static struct extent_map *defrag_get_extent(struct btrfs_inode *inode,
 	    key.offset == start)
 		goto iterate;
 
-	/* We didn't find a perfect match, needs to go one slot back */
+	/*
+	 * We didn't find a perfect match, go one slot back if the previous item
+	 * is an EXTENT_DATA of our inode, as it may cover @start.
+	 *
+	 * Note the item at the current slot can belong to the next inode, in
+	 * which case we still need to check the previous one.
+	 */
 	if (path.slots[0] > 0) {
-		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0] - 1);
 		if (key.objectid == ino && key.type == BTRFS_EXTENT_DATA_KEY)
 			path.slots[0]--;
 	}
-- 
2.56.0

