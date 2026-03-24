Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD21238C42A
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 23:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774396429; cv=none; b=lT12CYL0KDeY3suHW4VdDmgmGkPxWRZ4A6RKO/qLJ+oEwLsofu+qwaB8PdPyQWT3pGrex5N7lbgIRqNl4q+a8ElMY7qX7vU+4+s10nnwjyiEZ0vFbqfgZtJFA3IK3WMhDtC9YDwefb6b1zgcz09yC2r6sXetSS34t9waPVYaQZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774396429; c=relaxed/simple;
	bh=Vc1EvWBzBjxjlmJdjYYdleA5UCQJij33XWKrPkkn7kA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=d3W8I8ACSgxpmjT1lcD2JBCFzVQTneysvyEMPD86FNXINAS1zUQyB3NPbX13yfJgGyLuCRmPdEVO4YLYf4tT4A99AeE0v0Kv3Ou2eCe52Q/oB3cyzvoPnPz+kz5AwuqVuw5VQhay4VwHXhf2mGbDBYVXKO2CA2uRpthzyXAYs94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kU7/5+oq; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kU7/5+oq; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kU7/5+oq";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kU7/5+oq"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C63E55BCF7
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 23:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774396091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mN3fS7A0aK3pgWXfd77UPbmUJSfMLjBPSxAYyWf+BYA=;
	b=kU7/5+oq2nOZOAuu/xOupCXSs4lB/FIMrKcTB1kjn/QFlzrvQ8VMfneMvE75tLzxZurbeG
	pr/u4qXoBijQ8Fwee6TPZEri59L9L/lab1ByPOouguTH4D7SPRtU/2qjmxRD3XC/G6rNvI
	JxU2euQVIiOx/QQscrm5duDvSS3pfW0=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="kU7/5+oq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774396091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mN3fS7A0aK3pgWXfd77UPbmUJSfMLjBPSxAYyWf+BYA=;
	b=kU7/5+oq2nOZOAuu/xOupCXSs4lB/FIMrKcTB1kjn/QFlzrvQ8VMfneMvE75tLzxZurbeG
	pr/u4qXoBijQ8Fwee6TPZEri59L9L/lab1ByPOouguTH4D7SPRtU/2qjmxRD3XC/G6rNvI
	JxU2euQVIiOx/QQscrm5duDvSS3pfW0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 03DEA440D9
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 23:48:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /YQDLroiw2nlIgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 23:48:10 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: check/lowmem: fix false alerts about verity items
Date: Wed, 25 Mar 2026 10:17:51 +1030
Message-ID: <cover.1774395991.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: C63E55BCF7
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

Leo reported and fixed a bug in original mode where false alerts were
triggered about verity items.

Unfortunately we have a similar problem in lowmem mode too.

Fix the lowmem mode false alert and add a test case to prevent similar
problems in the future.

Qu Wenruo (2):
  btrfs-progs: check/lowmem: recognize verity item keys
  btrfs-progs: fsck-tests: add a test case for verity items

 check/mode-lowmem.c                              |   3 +++
 .../fsck-tests/072-verity-items/fsverity.img.xz  | Bin 0 -> 2364 bytes
 tests/fsck-tests/072-verity-items/test.sh        |  15 +++++++++++++++
 3 files changed, 18 insertions(+)
 create mode 100644 tests/fsck-tests/072-verity-items/fsverity.img.xz
 create mode 100755 tests/fsck-tests/072-verity-items/test.sh

--
2.53.0

