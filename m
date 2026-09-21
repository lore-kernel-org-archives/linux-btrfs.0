Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE60533E347
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 09:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982244; cv=none; b=FZ0+gQc87ZYFbrAps2Cy43NPOOzYT1iBiLSdCwqdm//rzMloDlXsxTSv8Cr1YWH40NoFkZC51OP4ai5S8w99vHBrvCs3scpzHokCMIr9rLT3VFalJpwlp7T693qlWYAToTs2iyApHk12hJgwfIfgOeA3piq9F9oufo7MyPj5Kv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982244; c=relaxed/simple;
	bh=+z0ijD32l1joPGYCMyEjiFYPLG9IF+TOk/5y2coFR7Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uf0s/ARghNwhwaEXd5ZHdCeVydCeLNeN9imOWPRYr3wrSa++RAk2HwMPLKD6GY3AjykoVe7BnRu026QRPBn/lnvuo15I5jURvHiXeS3LlTrotuOtWqzRLCaYGnmGJm4Jd8OCekwtruMAyy10GXjtqE4brrR59HVLfMsxoRdb4Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sCxrhdEt; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jQjkrJmF; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sCxrhdEt";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jQjkrJmF"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C460F21CA9
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 09:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789982236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hnaZe9c5aGmonay402EnHxHeTuzMMI4RixT9dYlwu7I=;
	b=sCxrhdEt+DPIrbxi1LIvJcJKGBclmBwQsIGMv+15d5725d3MyXUU6bU7Fjnt9kNlgiVqWd
	tMKaQGbRqie0DLYHiqOnTWQliNbriAzRj3zvp6KAKEfxZGJ2o/fyyQpQHmz5MXaQ/tEIga
	zM4sGkcmWVTNi2O4PTeqhu2H0v8yWuc=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=jQjkrJmF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789982232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hnaZe9c5aGmonay402EnHxHeTuzMMI4RixT9dYlwu7I=;
	b=jQjkrJmF19MjdCQgY0ZTePXDSJC0x9wzYZ1RVcywafYQ8ruYgxDPx9hmDwJRK6XCN7QdpH
	kCKZDsQbKyNVuQH4Zu62sF+6HBAn+MVDOUdV0Of4KfXZSZylxIx9tplRn4JJWzqSsWlyUw
	D1k8g2Vu18OaEaN6YyFt2axyd7FuQfI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 82517139DC
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 09:17:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8dCGIhH2sGqkbAAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 09:17:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: always show the message when qgroup rescan ended
Date: Mon, 21 Sep 2026 18:46:46 +0930
Message-ID: <04c9a02c7bcd35f318d118b7d30b5a0757d505ed.1789981860.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789981860.git.wqu@suse.com>
References: <cover.1789981860.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C460F21CA9
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

Currently if we failed to start a transaction to update the qgroup
status item, we show no message on the reason why the rescan finished.

This is not helpful to end users.

Fix it by only ending the transaction if there is one, instead of exiting.
So the message is always shown.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index eb71f5d7c1a5..4adcc6032dce 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3981,10 +3981,8 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	complete_all(&fs_info->qgroup_rescan_completion);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
-	if (!trans)
-		return;
-
-	btrfs_end_transaction(trans);
+	if (trans)
+		btrfs_end_transaction(trans);
 
 	if (stopped) {
 		if (canceled)
-- 
2.55.0

