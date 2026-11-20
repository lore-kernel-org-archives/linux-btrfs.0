Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168688;
	b=QCJAX5Ic7tJzZyHXWkPW2UGa1p1luURnTJwW7ZfD5ciT6S0qDEt90I7/3rol0yV2pCSL
	 vsTfLpgcAhzpQGP8sOtSrYLxdQLpe4RjGQI6TL16VtkLYORKTWSP7Xj/dwQ81Ys2m/34H
	 giwDbPwPVXGoooIhetT6tyZM6lphzA3CRbHWdN+Jj83tMlRQhVKGquDTooHDbJMY+Iqs/
	 Ea8a3jG/DJhFTdtH4Vp/Pw+PeBtfE3eEH8nLLXx/vcH+XxFEDopOv+RnA4VbGgQbq5Kea
	 PSlzlBHwPPqb6UImBixbjqerDJPAYeSD1C5Rd+CTuqGzy9mrVr42JnSoQR5lC/vG6SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168688;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=ZZ7+XTz7lh1uK0u+jzggrqj2wLx3RyEVuUvjCWPd5Rg=;
	b=JBpE8vin7K/dZZ3QpRDSs3Kolw6oCgRQ+pFXpQ45aXIP8qta0cno/NUdQByBOdIHeLeL
	 5kFAqGPy0X5Bf1SXf3k4QkCCgklZ5LS0hXwL5iTIxRcCWCnfbX+iuWTB2Au9BrXgo9IvF
	 dC6tnxFu5rm774U8SPYWMt9y/gfTeA0LZfPr+OmgZGUanqUqWdBFM/81BiiuLYran340r
	 3BiNuoJphXZ99vNNTYTYpjR0UILkf9hduhERgkNipHeyF7y3bUXMWTsf0LqHArWOzR43i
	 HtW77risEEvW60r53o4TNQm1D1Ev836GLID0JOKWycJq562gkMZ0w9TkkcxJST8wazg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=foImXtYj;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=foImXtYj;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557AF606A33E
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:58:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 557AF606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=foImXtYj;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=foImXtYj
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8BA4122594
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795168686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZ7+XTz7lh1uK0u+jzggrqj2wLx3RyEVuUvjCWPd5Rg=;
	b=foImXtYj9zMoeNXZP2hTB40iMiCgVXpVOF4PKYiXhKm3EUtBFhQIpqpDYIbRKlGwspdru8
	lLQL9hq+pvkPY63Hi0rGkFCh1pZDmkk6HhAPbJcd2wA7Kf3h06qFmzyH5BKcEK1r0MVBnI
	bnYr9pscOsXiZ2JANwekkOP18rlgkQs=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=foImXtYj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795168686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZ7+XTz7lh1uK0u+jzggrqj2wLx3RyEVuUvjCWPd5Rg=;
	b=foImXtYj9zMoeNXZP2hTB40iMiCgVXpVOF4PKYiXhKm3EUtBFhQIpqpDYIbRKlGwspdru8
	lLQL9hq+pvkPY63Hi0rGkFCh1pZDmkk6HhAPbJcd2wA7Kf3h06qFmzyH5BKcEK1r0MVBnI
	bnYr9pscOsXiZ2JANwekkOP18rlgkQs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6CCE51348F
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:58:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UUtJGakZAGvSFgAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:58:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/3] btrfs: qgroup: ensure the qgroup rescan messages are always shown
Date: Fri, 20 Nov 2026 20:27:34 +1030
Message-ID: <0de834dc726392804b83031be495d34db0cb1c8b.1795168584.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795168584.git.wqu@suse.com>
References: <cover.1795168584.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 8BA4122594
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

In btrfs_qgroup_rescan_worker(), if by somehow the transaction is
aborted halfway, later we can not start a new transaction.

This marks @trans variable always to be NULL, which later skips the
qgroup scan related messages, this can be a little confusing for end
users.

Fix it by only end the transaction if we have a valid trans handle,
other than returning from btrfs_qgroup_rescan_worker().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9f3886d128d3..afac7402af36 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3986,10 +3986,8 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	complete_all(&fs_info->qgroup_rescan_completion);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
-	if (!trans)
-		return;
-
-	btrfs_end_transaction(trans);
+	if (trans)
+		btrfs_end_transaction(trans);
 
 	if (stopped) {
 		btrfs_info(fs_info, "qgroup scan paused");
-- 
2.56.0

