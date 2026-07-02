Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE023A5E9B
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 23:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783035641; cv=none; b=QSAq4tHeoZ51zLmERfVDv8kyXFD4fhSxK/KIjiEvi6wgwanDCXczQCM0fIAryowy8tb7FZPJb1QUKEfj0oBbwuAh6iIxXGSnfiUJ1zT3VyoGUs+plTJ1mOxvIXT+3DReR/zww2V480aI7BArlDyEUAfJkv1rYJW48BWWcyAYXKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783035641; c=relaxed/simple;
	bh=MNr6tJqyAQBfumtSi8gwAb9i6HlLFMirM14FthntNAU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=TUBgJ9wkswu9ZW8rmYowaeUGuu3tTrg+Wkoo0SE0IIRrX4Aa/V2nEaKJXFnUZ4Rx79KefH/WadRZ6B1kFWmF6pGdOjCW1cJPxHb1RRMcdTdCKE71pzsLBSEt658j6SXIT8NrJD2GgULdDLjHNGrPUj8fvi/ckIsvUdxsp2fquGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NFrXLhM9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NFrXLhM9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NFrXLhM9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NFrXLhM9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0749875B15
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 23:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783035638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2buOY2RIJbUJh102zGW9pBaBoGKG+op8cPZGfSndeUc=;
	b=NFrXLhM9PPel5IgwK94udGkMulYdLbaElQPyrPhCR/WnN5umsejlGDMHN+u+usYiQOHZYU
	wIpftszDO3Ik5L4QMG3j/xQA6T2LAkjCWfXR7TRvJZN/jshj8VIbDz6WRpiTs8doFrVY3H
	FrQrv9q9dUinkRiBYY3fni565VDSsP4=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783035638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2buOY2RIJbUJh102zGW9pBaBoGKG+op8cPZGfSndeUc=;
	b=NFrXLhM9PPel5IgwK94udGkMulYdLbaElQPyrPhCR/WnN5umsejlGDMHN+u+usYiQOHZYU
	wIpftszDO3Ik5L4QMG3j/xQA6T2LAkjCWfXR7TRvJZN/jshj8VIbDz6WRpiTs8doFrVY3H
	FrQrv9q9dUinkRiBYY3fni565VDSsP4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0195A779AA
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 23:40:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XpesKPT2RmryRgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2026 23:40:36 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: small changes to "usebackuproot" mount
Date: Fri,  3 Jul 2026 09:10:12 +0930
Message-ID: <cover.1783035512.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

"rescue=usebackuproot" mount option is not requiring a read-only mount,
which is different from all the other options in the "rescue=" group.
Address that in the first patch.

Standalone "usebackuproot" mount option is already marked deprecated
since v5.9, I see no practical reason to keep supporting it in 2026.
Just remove it in the second patch.

Qu Wenruo (2):
  btrfs: add "rescue=usebackuproot" into forced read-only options
  btrfs: remove "usebackuproot" mount option

 fs/btrfs/super.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

-- 
2.54.0

