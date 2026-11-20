Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795167721;
	b=wB8o06nP+iO1IGXPjVvoYh69rnIcyi0sM1KXk/7eVyeoeGbWQ7f863rQj4p+wDiDr9Ec
	 f9Z/kLFSIoDqxF8Cv8/iuVSN4Qdtipx2ORGBCvIb9c55RcA+j/5aPyWwFRh7A27vdtwNs
	 RW4ftgrH9XPfYDz4wUfgHwYyNjiH7CtQ0fAZGmaLWSnRJlC35Ufn/Wec5srn+0AqE+ARn
	 ufybpMnqoryCB4n2xYDgYsHPbeA6ex3ieM5X3wFaGN/YpxgrD9QlGgE5TvZEJBRtO9Al/
	 1UgBag4sY8q6NXxbZUeYm/pR8wMBzLcqBA4Z154DbCB7ehnD4sx3Qh79VK7Mf+1VJJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795167721;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=ZZ7+XTz7lh1uK0u+jzggrqj2wLx3RyEVuUvjCWPd5Rg=;
	b=p4S8uDeNsGunjcR1hW5WgdUTozZbvPgUN5tFsXGHGJoCTq32dX0VnMbyqDexAF5qJCGj
	 zygxIfCFBnSDRE1Im0I5AAPSSQp5hosRBjM0lIS+L0qXOtWOxeLDlBhkzqVVz2TeuKysG
	 vIupnqy27fOBWvDVZ8eosDJe0aYlEmKu6V83wLPtxe5q/2IqcbJOcmJTG0XCsK3VHme3V
	 RBlp5ipbVWdzWN/jbAGjKxr9JLtuQRQJZfMvjmFCPkdpx72sJ1zdg9b+JaD9vD/hYDVFc
	 jcKS0yp5nLCQ3KP6mE7Dz19jljEPVL4xmr0YXkPsRKvk7l9CjQl4daBgeRc0U6RxUAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="cI2U2A/r";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=AxcxXX13;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE33606A334
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:42:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BE33606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=cI2U2A/r;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=AxcxXX13
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E885522609
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795167719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZ7+XTz7lh1uK0u+jzggrqj2wLx3RyEVuUvjCWPd5Rg=;
	b=cI2U2A/roTf5rWBKFRqL9NRC1u/UalgQOVCjLuHhxOO1Z1M33wamnHCQM+zRtNCUiUqOHw
	s5Jvmj8c9353rNZnGeziY4WtBUFeJDHqjfqHrWggUgg+dF9pcc4USVCwXDS0ss4UtTmry5
	8plr0wmvMoZQxL1zLoD5T4S8ofmdw4I=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=AxcxXX13
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795167718; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZ7+XTz7lh1uK0u+jzggrqj2wLx3RyEVuUvjCWPd5Rg=;
	b=AxcxXX13psqflN0AhJVhKr4D4RiAjfINTJHIwos5viAvmSkB3u0/I6z4/EQ4DsH8o9RWLw
	4nfDLlTbT5nNWCHrE6MLindnzxYoAmOld/RDtLn7KJGN89ungY6V2bl9kk115b5g915OE7
	KlZA0W1c+iuz4ij7z0w7IrG7/LzIV8o=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CDE8E134F6
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:41:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id maa+MOEVAGsBBgAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:41:57 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: qgroup: ensure the qgroup rescan messages are always shown
Date: Fri, 20 Nov 2026 20:11:34 +1030
Message-ID: <0de834dc726392804b83031be495d34db0cb1c8b.1795167390.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795167390.git.wqu@suse.com>
References: <cover.1795167390.git.wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: E885522609

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

