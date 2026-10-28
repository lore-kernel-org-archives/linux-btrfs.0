Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793169070;
	b=nsgPxy0EByXrsdQ+pp4Ykjo6PodrgyDDeWwGidhYqHZRZM0ir95GoTlSPUkPQAuTIaeC
	 dW3ZeBsopL35ABlb76yyDXtZKHZz1vAtuCw7KQE1glrocJB1RLkJVtyDBEDNfKxtpD49H
	 syHy+QqhPlfLg8rk9VINKO3W+riLshhdYM8eBJOnsZevhxQFkEJaMroEAGjutzhtRPLYn
	 Tbqt/4IbErN5gYDmLsTpwpZoPYgpCJs6sJpgr6ZvkghDNgfka2o7j13HLa3jQQ/F1650b
	 sbW4936xqe1qyoHqjcluRLaa4l641g+0VRV05Zus3rDSDQ4xeIIwskafHsXxwCxuaPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793169070;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=4a5SslmTgOkYfFp/o9/GSeN4JubavSzkkzZhX6srjaA=;
	b=VEb8M7ccCc8DilWHLSxIO/naDMYkR1JDs0FEIhMkmqmXrFBx4MxSxOtlsYQJ+9hV6DYj
	 rFLNkj2TK9AoCZmviQCx49azCd5UaL2FLf+UyFEFEf1tJ/qI5RLeXxKwEHJjBYG+TTIlR
	 oAHWst3j7I0qeGeNwK4y9lXaDEPOepolvJ+JEM4h7mBqkrr/EZwI8rykwZIDpypN5lwCr
	 R6QRKSkVYV3KBGvX7QEL6UTWVx2PyiiRCE8NsBHCkhEVIgYibRuwGBBEopeocOSuj0YQr
	 hXBSMpPE8RZ8SQaxaI9B8CDoDoB8h4B1/HF2bQ+rOVp0lRzkYvfVlb8ZJFw4jdtyVxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=O28Ip0BI;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=O28Ip0BI;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83042606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:31:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83042606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=O28Ip0BI;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=O28Ip0BI
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4904D1FB06
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793169067; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4a5SslmTgOkYfFp/o9/GSeN4JubavSzkkzZhX6srjaA=;
	b=O28Ip0BI82H4je5ZuglE6XdYlrOYvpHymNykoNcTiVBB7tXNjFnWeC3XD3xn9j8ADzTQe1
	4pCfTNjNmTy13xEPKr/bY46u18yYcN9OUi+itzxxwfCORs5uA5Mud7bIYgaNGMkMBILhGC
	Vw2CETf9iUZAXzAwaAMEGYqniHvpkmQ=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=O28Ip0BI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793169067; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4a5SslmTgOkYfFp/o9/GSeN4JubavSzkkzZhX6srjaA=;
	b=O28Ip0BI82H4je5ZuglE6XdYlrOYvpHymNykoNcTiVBB7tXNjFnWeC3XD3xn9j8ADzTQe1
	4pCfTNjNmTy13xEPKr/bY46u18yYcN9OUi+itzxxwfCORs5uA5Mud7bIYgaNGMkMBILhGC
	Vw2CETf9iUZAXzAwaAMEGYqniHvpkmQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2457913419
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:31:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NOeGHKmW4WoiBwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:31:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: raid56: minor fixes to rmw_rbio()
Date: Wed, 28 Oct 2026 17:00:45 +1030
Message-ID: <cover.1793168898.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 4904D1FB06
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[99.99%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

I was checking the bio_list_lock usage as some call sites doesn't look
sane, e.g. spin_lock(); set_bit(); spin_unlock();.

But during the cleanup and reviewing, LLM exposed two new bugs:

- rbio_orig_end_io() can race with lock_stripe_add()
  And rbio_orig_end_io() didn't hold the bio_list_lock, under certain
  race condition, a bio can even be missing.

  Fixed by the first patch.

- Failed rbio can still be cached
  Fixed by the second patch.

Qu Wenruo (2):
  btrfs: fix racy bio_list changes for failed RMW rbio
  btrfs: don't cache rbio if an error is hit

 fs/btrfs/raid56.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

-- 
2.56.0

