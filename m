Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864576;
	b=s94gHO0ppE/d7AMjc+1h2EwryZm98CpWrRBDPChM/S15cADxyKDAJxkakEXdnyIuOo7r
	 Pifv+scGVqemgeMwKuV6BtWZrC9ZNHXrQ9+OmaANFTQJe475nuWWec7kHydsgxPKjOKah
	 yGjiqIQPZLslFChWtHrfAmqE1td+/5j2N8cOAYtFTZoZW2YCJFsryYqb0yf7cKMAb6nYh
	 8y3TY62GU/7/+l2rOHt8TkAmRjta7LAq6J049MZUwtjMZkNgFPPcMCoVP9s4aiH+VHyb7
	 H8rp0NqWZg2WwX/mYiAn8QFxm9YG8FG2/f1+ifFZiK1XEjW/nbnmVU04O72V1VhJ/8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864576;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=wbNr5J6z18kJjZRB2qXWm0NBbzoQ6O1kQYMiSa+1m0c=;
	b=LybXRqVIe0lw0pw3FnNPS3wrDwE6LWPBISlkNnMv/ij8ebzufMyOZWC7LRkzsa2h+z5A
	 bdP1C9YGdI87DBvWgWzrFjLrlI6IbYUYnL+lvOiX6aNBmGUDY8ERoljR5nPS4teXhVlLV
	 t0nRmz9vfjh/9b2tZyfyQv//plPNg1N8X1sKaw5MXsZfALwnChwl+J3nsBF/bFUwRVNXX
	 mTvvmnq2yTMJCKNzaPudI9Nc+AqiWceUuuQjYbx79Q7hcQ61Dp/JMwvPq5FptzP5WuzBA
	 nA2pmlmOr6BTrsYyN3SK6YQQH65bU948MKsnEAqlNuu7pHsELHdj4Py+s+B/H6rwHKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=q84q980W;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=q84q980W;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F9E606A336
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 21:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35F9E606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=q84q980W;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=q84q980W
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6AF422227B;
	Mon, 16 Nov 2026 21:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794864574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wbNr5J6z18kJjZRB2qXWm0NBbzoQ6O1kQYMiSa+1m0c=;
	b=q84q980Wom/PfMoIU9WdwBxWPDfCQuMVj+tSEkCLuK2gjVpWRL6uM/Dif5gytzGNQVCkbS
	TYQZ1FxNgOKnadYvSI/NlF/CZBsDWyLKEQE5ryLs+J5o//62e4iipQCyvHr8qDwrK0W9rC
	OE5wyffSdyC/nDK7ruuJRTGg4X2nieE=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794864574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wbNr5J6z18kJjZRB2qXWm0NBbzoQ6O1kQYMiSa+1m0c=;
	b=q84q980Wom/PfMoIU9WdwBxWPDfCQuMVj+tSEkCLuK2gjVpWRL6uM/Dif5gytzGNQVCkbS
	TYQZ1FxNgOKnadYvSI/NlF/CZBsDWyLKEQE5ryLs+J5o//62e4iipQCyvHr8qDwrK0W9rC
	OE5wyffSdyC/nDK7ruuJRTGg4X2nieE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0196C13408;
	Mon, 16 Nov 2026 21:29:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ugL8Jbp1+2oUJgAAD6G6ig:T2
	(envelope-from <wqu@suse.com>); Mon, 16 Nov 2026 21:29:32 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH 1/2] btrfs: defrag: break the loop early in defrag_get_extent()
Date: Tue, 17 Nov 2026 07:59:03 +1030
Message-ID: <064b3cd703b5e99f4b924f80afb13dbc593f3f49.1794864101.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:email,sashiko.dev:url,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

Inside defrag_get_extent() we have the following checks determining
whether we should continue searching:

		if (WARN_ON(key.objectid < ino) || key.type < BTRFS_EXTENT_DATA_KEY)
			goto next;

		/* It's beyond our target range, definitely not extent found */
		if (key.objectid > ino || key.type > BTRFS_EXTENT_DATA_KEY)
			goto not_found;

However the above order is incorrect.

If we are already at the next inode, but the current key type is still
smaller than BTRFS_EXTENT_DATA_KEY, e.g. BTRFS_INODE_ITEM_KEY and
followed by BTRFS_DIR_ITEM_KEY, then we will continue iterating, even
it's definitely not necessary.

This is only a performance related bug, and requires the next inode to
be a very large directory to really cause observable performance
degradation.

Fix it by doing the not-found check first.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/bug/linux-e166e8db-2bdf-4c02-8eb1-9701b3939ea4
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/defrag.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index cbc532b49c67..c3a9f1aff922 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -674,18 +674,21 @@ static struct extent_map *defrag_get_extent(struct btrfs_inode *inode,
 
 		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 
-		/*
-		 * We may go one slot back to INODE_REF/XATTR item, then
-		 * need to go forward until we reach an EXTENT_DATA.
-		 * But we should still has the correct ino as key.objectid.
-		 */
-		if (WARN_ON(key.objectid < ino) || key.type < BTRFS_EXTENT_DATA_KEY)
+		if (WARN_ON(key.objectid < ino))
 			goto next;
 
 		/* It's beyond our target range, definitely not extent found */
 		if (key.objectid > ino || key.type > BTRFS_EXTENT_DATA_KEY)
 			goto not_found;
 
+		/*
+		 * We may go one slot back to INODE_REF/XATTR item, then
+		 * need to go forward until we reach an EXTENT_DATA.
+		 * But we should still has the correct ino as key.objectid.
+		 */
+		if (key.type < BTRFS_EXTENT_DATA_KEY)
+			goto next;
+
 		/*
 		 *	|	|<- File extent ->|
 		 *	\- start
-- 
2.56.0

