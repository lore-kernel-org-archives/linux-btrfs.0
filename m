Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795466276;
	b=UuLlaqNPqG2wEzk34NyCuWAP68pWoLbU8PArxhv1q1EYnz3y0viNxNH6wxVhAcXLw6L/
	 IgwR83fu4LlYr6UDsGsoJntigJPE7rzhs5Jj4iK2NdrJaZ9uCTeQISm9w4wvjm993D5cB
	 tGBARAWwcRqyWoBjfgFZ3ZczqPhFvhQPz0A5H1W3St6lyucMhAJcIMaDq8l3+blQhK4Gy
	 Mwnk8QKR143xGpfAu1lkaG1/aqoL5h73hGxbuCHfs8/wVV6f6mxDuhCumyG8+b9+vnXWG
	 mN5kmA5sxO8SSLZLZiRQeWj8Npi7aV1yBBZJ+p7+t8AP4jFhnUeax7D7b2nlNa7zaCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795466276;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=VtobZ+SW1Ds0uxvopwWhXMBNb0lFM8WhmT2o5KWRM9c=;
	b=N3pX6JpUCobubARLCtQTSCQ1NOifNb+LxXUjAwxAwQsklCSC1mjlhI94fgL6ctuuBHjU
	 uMb2MYJ5WLTQ6RxlVK+nmxOQtwOYBmWZXcrue+VVpZnze2hDOIkXde5Qmb8GjHNIHRpZV
	 OqvN0qPZqBzueU6EN/fG6YYquSwJSQQqzfT4qfb55/mxCJvBoePyAKE+8BzOKdWBkjs9c
	 MWbkKEQjw+Zjo+FcWY3Ed7D553C1AIpYs2xl8ijsEc6Gkwv/a5vbFj1oV6+FGFRnFPc3C
	 OFXtLK2ni6/1VMNcYWRs62a67efi5mirLcjJBOPpTvTN1o4GY+GVV6myLXFaQL3jz+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=RHF3+Yuh;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=RHF3+Yuh;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31592606A336
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 20:37:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31592606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=RHF3+Yuh;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=RHF3+Yuh
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 63C901FB5A
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 20:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795466274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VtobZ+SW1Ds0uxvopwWhXMBNb0lFM8WhmT2o5KWRM9c=;
	b=RHF3+YuhLsNKybbOTISh2o1LgV+YUUX++Rsg3qTznKnys1K9566yURaCC6pUNv1/oxZZsw
	pEypkg4fC9Xs3My1dBE3iHqVoPmE13dbxRA0B0/s0r9Ywj7QJeBDF813LF1S0f9m3kfulb
	VkYAbRq6FQWq/tVTX4wVDQMYL1aJ/ik=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795466274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VtobZ+SW1Ds0uxvopwWhXMBNb0lFM8WhmT2o5KWRM9c=;
	b=RHF3+YuhLsNKybbOTISh2o1LgV+YUUX++Rsg3qTznKnys1K9566yURaCC6pUNv1/oxZZsw
	pEypkg4fC9Xs3My1dBE3iHqVoPmE13dbxRA0B0/s0r9Ywj7QJeBDF813LF1S0f9m3kfulb
	VkYAbRq6FQWq/tVTX4wVDQMYL1aJ/ik=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D9AD13505
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 20:37:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3J8WMh6kBGuQTwAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 20:37:52 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: reject too high tree level during backref walk
Date: Tue, 24 Nov 2026 07:07:31 +1030
Message-ID: <220d8ed1b3a8d502c4260d01e4ac4ece942873f4.1795466145.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

In handle_indirect_tree_backref(), if we got @cur->level set to 7
(the max level valid), @level will be 8, then later path->slots[level]
and path->nodes[level] will all go beyond the array boundary.

Fix it by rejecting such high level before calling btrfs_search_slot().

Link: https://sashiko.dev/#/bug/linux-8a4f92b4-daf7-4f57-8369-8e6ef323652f
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/backref.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index a0fb90b7a9ed..e9434e033372 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -3316,6 +3316,11 @@ static int handle_indirect_tree_backref(struct btrfs_trans_handle *trans,
 	}
 
 	level = cur->level + 1;
+	if (unlikely(level >= BTRFS_MAX_LEVEL)) {
+		btrfs_put_root(root);
+		btrfs_err(fs_info, "invalid searcch level %d", level);
+		return -EUCLEAN;
+	}
 
 	/* Search the tree to find parent blocks referring to the block */
 	path->search_commit_root = true;
-- 
2.56.1

