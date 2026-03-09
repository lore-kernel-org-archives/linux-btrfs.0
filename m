Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2331344056
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Mar 2026 22:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773094802; cv=none; b=IgooAUGbLW8d5ZDJnf3x11q+0fTOXCkPLBkPi3EIqmxF4i+z38O1oTIYRkiCZZneuk7In8AQHcg0TMlG5saT/F7K9tX8CiMGmn+tGOD0Xm8fb5Wi1gL5sMHyHa+tohKjZhJ1iixS0ECjtoUkiZLcRQEP2dgFFZFylFpUB5+PomA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773094802; c=relaxed/simple;
	bh=Ly6aeMeG2MUppcymcswOVpWyOj7ohxflB0FEawShR3w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R/hNJXmoHAydzjJ1HS450w3iQtkLUsv2wxoYBbhOiGadRtCzTgug+RrjAcNmTHX09F3O5s3AIzFCPeHYJAuOjjjPqMFOR5l6Jjm0l94Hwq4HX/kfpZoQvEuJdHnsYGNm8R5SN9GpUxP0gp8iSTpZvWpP4O8yHc3K+CzxynO19Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aZnXNflb; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aZnXNflb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aZnXNflb";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aZnXNflb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B2AF34D297;
	Mon,  9 Mar 2026 22:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773094793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=FRt1FE83GH9J6qisj7el9uIO7sY99qqDKKycUeegcE0=;
	b=aZnXNflbex3l9qPcrjPEZVSmB53/14CPYucFJjTRL0d/yOgXsDphx6v+Z3Z1NoCdaWMSIC
	g/O3TApBleP56j54dsFdB5OfQSQ6ThMCxdGRoqpgwmAKxBVOkYiwJvBHzVAMhL0Ps4CuEc
	Hhbi25D5E//xRZq18yB+pFauXOjt0UY=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=aZnXNflb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773094793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=FRt1FE83GH9J6qisj7el9uIO7sY99qqDKKycUeegcE0=;
	b=aZnXNflbex3l9qPcrjPEZVSmB53/14CPYucFJjTRL0d/yOgXsDphx6v+Z3Z1NoCdaWMSIC
	g/O3TApBleP56j54dsFdB5OfQSQ6ThMCxdGRoqpgwmAKxBVOkYiwJvBHzVAMhL0Ps4CuEc
	Hhbi25D5E//xRZq18yB+pFauXOjt0UY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C2813F11A;
	Mon,  9 Mar 2026 22:19:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1c3UFohHr2n6LQAAD6G6ig
	(envelope-from <wqu@suse.com>); Mon, 09 Mar 2026 22:19:52 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: gality369@gmail.com
Subject: [PATCH 0/2] btrfs: add free space tree checks except for FREE_SPACE_BITMAP
Date: Tue, 10 Mar 2026 08:49:24 +1030
Message-ID: <cover.1773094579.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_CC(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B2AF34D297

There is a fuzzed image report (*) that a bad item size for
FREE_SPACE_BITMAP item can lead to various problems.

And I'm surprised that we do not have any checks for such critical tree,
so let's add the proper checks for FREE_SPACE_INFO and
FREE_SPACE_EXTENT items

The check for FREE_SPACE_BITMAP item is reserved for the reporter, whose
initial fix is not properly put into tree-checker, and also as an
example for the reporter to follow.

Qu Wenruo (2):
  btrfs: tree-checker: introduce checks for FREE_SPACE_INFO
  btrfs: tree-checker: introduce checks for FREE_SPACE_EXTENT

 fs/btrfs/tree-checker.c         | 70 +++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs_tree.h |  3 +-
 2 files changed, 72 insertions(+), 1 deletion(-)

-- 
2.53.0

