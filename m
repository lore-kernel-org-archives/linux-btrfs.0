Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795466278;
	b=PEO0ywz6BWqq9dPA1x3hZsnBpbjdzU+chCHSxzTg57mPvgooI89VhvtpxNBOal4lKGPp
	 9DVNBDGGpXRQJt0zYUeX9NphUzXgYkDL8w5/vBHEaB60YXIvjeSiQzYcrEuq0VUwLxHa2
	 hSIB6Lns7G4uUBlQnjYiCfCbaFHlIz3Ybt8epLl3ePI7GmSf5KGSVL3EFd1XpZds36ieg
	 pup43W75ZO2d3N5/r3Ig5hVk5Y9K9Q2lzTvqI8OIdvdlWJxL30yM7IubwUmK8yR7XUI2R
	 oJd5oi509jyyAy5THCOtCyHW+9bVmG0TQnCLGyLdwWVdJnbrN/IpVJJAnvjtHHdnq+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795466278;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=LAq2+JjSB8Ig982TyOyPBaVnejz8YS95b2C4cfuvJ34=;
	b=zV7Ux86BzqtOchCAWCX9HHfa/WK/yxE13qCz8h+MsL8heFAwhTvzaIlWx1PBhQjIhnjk
	 KSGQ7p6WcRyapTjtdrawyBY2Dp54rtLTB56iLg+fUKQC3E6We8y1XjvHAZBNhO3UfB08X
	 v2y7/73se+bgUSpiBxNo0w+zngxfNjGfbdMbSVHUO36mTo6x1IeSLIfWMvPYJs0eGeT8t
	 vx6+3xL1e6uQkG0mZQmeYW+xu6ZdzYjGV3FatFtLvX9ogrDkzcSP/poB9I0zKboaoSjiI
	 eBiM/xGo2pD3MAVmp63DkU3K2OBGclzK1TIbiID+GZFiXy2TEkBd/HMnMeCPLjETxsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HEGwHNHl;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HEGwHNHl;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1A9606A326
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 20:37:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC1A9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HEGwHNHl;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HEGwHNHl
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 18A2D22076
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 20:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795466276; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LAq2+JjSB8Ig982TyOyPBaVnejz8YS95b2C4cfuvJ34=;
	b=HEGwHNHlJf6cfnI4eYvDjhJnhrc6JB2iDescqXRXW1Ccuf/2DeflXVBCCPbMXZEip8UOnY
	iRVp5fkL7TABKKUzrASTVgevzaab047D1DuwctofuE7gJxBu5OV3c39SMgL/pZO34HovTI
	PtkZ/bBdvfU8z3MXvLWWEEPzrlrfh1Y=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795466276; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LAq2+JjSB8Ig982TyOyPBaVnejz8YS95b2C4cfuvJ34=;
	b=HEGwHNHlJf6cfnI4eYvDjhJnhrc6JB2iDescqXRXW1Ccuf/2DeflXVBCCPbMXZEip8UOnY
	iRVp5fkL7TABKKUzrASTVgevzaab047D1DuwctofuE7gJxBu5OV3c39SMgL/pZO34HovTI
	PtkZ/bBdvfU8z3MXvLWWEEPzrlrfh1Y=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E605813505
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 20:37:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3J8WMh6kBGuQTwAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 20:37:54 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: avoid NULL-ptr-dreference after a lowest_level search
Date: Tue, 24 Nov 2026 07:07:32 +1030
Message-ID: <2a0a92aa027b67006da45ba8abb8177b333e31da.1795466145.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <cover.1795466145.git.wqu@suse.com>
References: <cover.1795466145.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
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

In handle_indirect_tree_backref(), if we got a corrupted backref item
that has a valid level (e.g. 2), but higher than the subvolume root level
(e.g. 0), btrfs_search_slot() will return 0 or 1 depending on if the key
can be found in the leaf.

But the returned path->nodes[] will be all be NULL.

Later we call btrfs_node_blockptr(path->nodes[level]) will trigger a
NULL pointer dereference.

Fix it by checking if we got a valid eb pointer before calling
btrfs_node_blockptr(), and reject it as we can not find the parent tree
block.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/backref.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index e9434e033372..29737246d481 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -3336,7 +3336,8 @@ static int handle_indirect_tree_backref(struct btrfs_trans_handle *trans,
 		path->slots[level]--;
 
 	eb = path->nodes[level];
-	if (btrfs_node_blockptr(eb, path->slots[level]) != cur->bytenr) {
+	if (unlikely(!eb || btrfs_node_blockptr(eb, path->slots[level]) !=
+		     cur->bytenr)) {
 		btrfs_err(fs_info,
 "couldn't find block (%llu) (level %d) in tree (%llu) with key " BTRFS_KEY_FMT,
 			  cur->bytenr, level - 1, btrfs_root_id(root),
-- 
2.56.1

