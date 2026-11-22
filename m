Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795388426;
	b=bBTVTiDu2Bg2vpau9Fi8nZWWJ9HPhsPhXx6v0AFGCmrnLp7SyEp26HOGoiR+sK7afVsG
	 bNnK+oGUVR1NUOIqV+/865sKvaaOk54OGYEKSw0Do6tbfgkvq4wAxa5k+ft7PlqJbAClQ
	 OEVGiSKEUXjvn2ZrKLohZ9ZFBU5TRz73d3BwEaEBo8zfjcmpxp9kYbon38Y45Asy9VmbL
	 GCDp+DGn0Ff+11ctbA9qTz6gVMd3+5Lo6BO+pnLbFDs+cS9JE8jzbIll/X01725aRl4Um
	 OYGteOVWWJgbvUh1mxeEd1qOt8BJoI069eo7CGfi/q7nUVf5uFZRtAGyiIHSnsbbqtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795388426;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=2IjCDMlL17A0i7YHPrRiq2iw1qde9cjSdY/1KpFUb5I=;
	b=ZfZ/oPRN39zO6PcbajDeip8eplyHXQu3KXkwlgkkN3zbKgdIBd2PYcyAMe9IU3771m8b
	 2fWZ800PEmA1MJqan6/+EBBPYjjSIeCTQ3WN08INfLjJgiD4Y9z5boEvrcDK29bkvD6om
	 xBu8MjF79pAS7yummb7pKG8K6d5mxrsO7gwDrfoyFTbBmORZE1u3hvfGFl+Z6GPtheXTK
	 n301K9OxMtLo+QEbDVnm9CrBwUXBYXALcCD/ozHa6fqM4FxJyu1yKELysCfOC7mMB5g3C
	 X1Za7uMJZamWADyGTWir+G59AX4zPUBX+cRiYIlhHohRCMaByoE+Ohw+h1BAJQ5SgqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Ihnimxxj;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Ihnimxxj;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8C0606A327
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 23:00:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C8C0606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Ihnimxxj;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Ihnimxxj
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 70AA4220F6
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 23:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795388423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2IjCDMlL17A0i7YHPrRiq2iw1qde9cjSdY/1KpFUb5I=;
	b=IhnimxxjSnbJoozjRgndO98zH6zS5zR7TCcn3ql+pIJz9f6AeFfs5a+Msq7B3qNbE394Tk
	uEjESTP1l85TLqv0JNunRexB8/XeBHw3Z3ObCC6KriOYZRI5BDUKHbyxYe38ysSIuxs/UI
	/ZCmHrJeBl3OVyWmlmix8kxzdKhJDHo=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795388423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2IjCDMlL17A0i7YHPrRiq2iw1qde9cjSdY/1KpFUb5I=;
	b=IhnimxxjSnbJoozjRgndO98zH6zS5zR7TCcn3ql+pIJz9f6AeFfs5a+Msq7B3qNbE394Tk
	uEjESTP1l85TLqv0JNunRexB8/XeBHw3Z3ObCC6KriOYZRI5BDUKHbyxYe38ysSIuxs/UI
	/ZCmHrJeBl3OVyWmlmix8kxzdKhJDHo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5660013510
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 23:00:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PE5SCgJ0A2v8PQAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 23:00:22 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: avoid NULL-ptr-dreference after a lowest_level search
Date: Mon, 23 Nov 2026 09:29:59 +1030
Message-ID: <1ddedb512e769f6f886a74471855472f4e62e682.1795388358.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <cover.1795388358.git.wqu@suse.com>
References: <cover.1795388358.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

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
 fs/btrfs/backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index d56476b21fe8..83301ffbfa87 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -3336,7 +3336,7 @@ static int handle_indirect_tree_backref(struct btrfs_trans_handle *trans,
 		path->slots[level]--;
 
 	eb = path->nodes[level];
-	if (btrfs_node_blockptr(eb, path->slots[level]) != cur->bytenr) {
+	if (!eb || btrfs_node_blockptr(eb, path->slots[level]) != cur->bytenr) {
 		btrfs_err(fs_info,
 "couldn't find block (%llu) (level %d) in tree (%llu) with key " BTRFS_KEY_FMT,
 			  cur->bytenr, level - 1, btrfs_root_id(root),
-- 
2.56.1

