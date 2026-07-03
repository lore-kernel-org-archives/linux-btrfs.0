Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493CF370D5C
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 08:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783068108; cv=none; b=pSM4RRb1w2/Nckx7AUuJxcCk6S8oAwGt3q/YmQiXRdG9mfCnUIxNd3HjhFqVCjb1nptfgXkdSeRZhOy91yGrhM6yupCxSztHL4WNrHA35g2NFMKONpGrATgZ8QaHvtg9I56XFOPsu72yaHM4jJwqWvDEIq9D2P1BJsgRZSleegw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783068108; c=relaxed/simple;
	bh=LLvaEnmcxeVxOgF9Y5xn9mDWzyaDttfIjZZwSuoXwcY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=b8hOAinRAmrseS647WtwlBKUfSUhAR2AnF9k1CUtRaVjHcCfWt0cky8/OJmtz1lQ7Rqe25xSmISiKlP+NI6xVMDRlJNdcYlQWdVeQncRqsHMh7kPBEyHJmxEhFZnppc40YBbnrXXo/WzPp34qdkhrCISzTn4wnQwGvWnTWtB/V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gRCqJdUm; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gRCqJdUm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gRCqJdUm";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gRCqJdUm"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5CBFC72A7E
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 08:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783068104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Zvr9qB8F/5ZEaFpPgQ06DSRk8vlrKuHIJqquXL8SahQ=;
	b=gRCqJdUmc6l99gPR2HTUleAsDOZS7GebiwjyWMWIh2So1vYbG+9YYy7iJ0fw/PfJfKFh4Q
	tcbE68Y/sd3JqycX7hLUzGgqYQzrFFBbxJAXlBtVGfu2fwhkMzcP/i2T1Vmyz2gDjBi8+j
	vE0eS42vyMggp0gHTxnCkKfk85o2jQg=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783068104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Zvr9qB8F/5ZEaFpPgQ06DSRk8vlrKuHIJqquXL8SahQ=;
	b=gRCqJdUmc6l99gPR2HTUleAsDOZS7GebiwjyWMWIh2So1vYbG+9YYy7iJ0fw/PfJfKFh4Q
	tcbE68Y/sd3JqycX7hLUzGgqYQzrFFBbxJAXlBtVGfu2fwhkMzcP/i2T1Vmyz2gDjBi8+j
	vE0eS42vyMggp0gHTxnCkKfk85o2jQg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5AAAA779AA
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 08:41:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sZgIA8d1R2p6RAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2026 08:41:43 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: small changes to "usebackuproot" mount
Date: Fri,  3 Jul 2026 18:11:13 +0930
Message-ID: <cover.1783068013.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

[CHANGELOG]
v2:
- Also include "rescue=usebackroot" into "rescue=all" shortcut

"rescue=usebackuproot" mount option is not requiring a read-only mount,
which is different from all the other options in the "rescue=" group.
Address that in the first patch.

Standalone "usebackuproot" mount option is already marked deprecated
since v5.9, I see no practical reason to keep supporting it in 2026.
Just remove it in the second patch.


Qu Wenruo (3):
  btrfs: add "rescue=usebackuproot" into forced read-only options
  btrfs: add "rescue=usebackuproot" into "rescue=all" shortcut
  btrfs: remove "usebackuproot" mount option

 fs/btrfs/super.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

-- 
2.54.0

