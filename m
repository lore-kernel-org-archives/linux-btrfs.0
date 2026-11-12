Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521943;
	b=rDFCiA+R2Txlowd4gc7QSZEJCM5wdMxtB+GneVQKcGn80HawlgpYJwH1QisOFX7X23nP
	 QSpygVJJphH+hYBInNlfq9UwEJ/yBMYVOewTKzTSKWs5U5rrt0N1mcoX6WtiJQ+JhbyL2
	 iFq6Jil6ULF0zp4TW+OdF+2SKSX/KF1lqKEKvuFccIInEp3A7ZebHNqLqF2P5P25NBzBy
	 XYZE9ZBpGd3BfOOi3yaUfDgCcDKgQFMGHE+Ewy4ckdqtVw+HtQOPRFVIdX6xqnmaWn0Nn
	 CFvA5l163ew3AyAy66/gYQLOq3YipevfN3CU/1z+SD+AnLdck+Jx/pj7v2o2pCEiYtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521943;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=7chnHymaATS1BON7QNdug9NRjaDkP08grcc46ELUykk=;
	b=47yQwvkcj5sY+1UpqVhDaJHG9WLfpAjOZzEq/84rRc/FE0BCkebblp96Y3eqv32EtSvi
	 dW51QpkFdyD7N7tphwzsRx11YW+dvERpLA3Qt0UUEzodLJHYFws+iZvsl5bmWoG38W3Vg
	 EZN/tXnG0Z3z210X9pJH6XDKIcKAeOn09yPcFhuc8DrQHQ0xle79ZmvCzIJsahpd54DU0
	 HdzpBkgUMGegwMQsw4YbNQuxYsAy4xY96YPeCR7Gi6f/lG8nehbMNfl+b8b/w1+WKY3ad
	 emkJn/NbxNiLOrz4ybWAnJZw+RCWH39rv8CWa88rNdk8rKmnZXYVf7bvPqi6W5wk23w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=tRSQf+ts;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=tRSQf+ts;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427E5606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 22:19:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 427E5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=tRSQf+ts;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=tRSQf+ts
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 51C8A221FE
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 22:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794521941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7chnHymaATS1BON7QNdug9NRjaDkP08grcc46ELUykk=;
	b=tRSQf+ts0xB0Mh5c7m0DwhjGF1TQ0QDmautlC6JxnMncERbXr2Xp6qypCktX5ibtpCyVwR
	dgmXup2eaqt3gEtoIE6r3lgdgYEiTXIUpDpPlKj/xGTXL1QTGybCA7AsAoegrE+8fwWLmc
	oLEV/0Qj51LAHxkHlOhdDEkFGuWcdU0=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=tRSQf+ts
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794521941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7chnHymaATS1BON7QNdug9NRjaDkP08grcc46ELUykk=;
	b=tRSQf+ts0xB0Mh5c7m0DwhjGF1TQ0QDmautlC6JxnMncERbXr2Xp6qypCktX5ibtpCyVwR
	dgmXup2eaqt3gEtoIE6r3lgdgYEiTXIUpDpPlKj/xGTXL1QTGybCA7AsAoegrE+8fwWLmc
	oLEV/0Qj51LAHxkHlOhdDEkFGuWcdU0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 306ED13432
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 22:18:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XAn0H1M79mr7IQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 22:18:59 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: abort transaction if btrfs_commit_transaction() failed
Date: Fri, 13 Nov 2026 08:48:37 +1030
Message-ID: <521fda24cf9375242f53a4842475957d8231214b.1794521916.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
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
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 51C8A221FE

All other error paths of btrfs_start_dirty_block_groups() abort the
transaction, but the btrfs_alloc_path() failure doesn't.

This exposed a very tiny opening that btrfs_commit_transaction() can
return an error without aborting transaction, and none of the callers
expects to handle such situation.

Fix the only exception in btrfs_start_dirty_block_groups() path
allocation failure, so that btrfs_commit_transaction() always abort the
transaction on error.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/block-group.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 027830a53f7d..e4859f7e0323 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3397,6 +3397,7 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 		path = btrfs_alloc_path();
 		if (!path) {
 			ret = -ENOMEM;
+			btrfs_abort_transaction(trans, ret);
 			goto out;
 		}
 	}
-- 
2.56.0

