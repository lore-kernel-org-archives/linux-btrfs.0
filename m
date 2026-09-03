Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408523E0C59;
	Thu,  3 Sep 2026 06:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788416614; cv=none; b=qLrI6GoA4Qo/MFzBrm5nW1McvKqUkNetcsBS2C6jrKUwNiDXGs97TTo/JKIyQ05x8u+yCA5COm0QPHdKcyN/WYyUdAkjg2m9KMu2qCJjC4lQmnqjdjLUMfD+nYItapilgA8mEHFk8NMh2vSVIG52oudUz2Py2AEL4wqbODzlSiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788416614; c=relaxed/simple;
	bh=N40fSXOXjiaKXmK5b2QB9kTR1GISfoi7xdZIopqKD1g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CJnSTlkeBq5TzRZ2uDeU2w3MO5syzpAy4YOxdMGSFaoN/G+S8gZDBXboBpQ1nTE8VVnLxRvtFrLVng7wbFJMq+0BVl0+H+eHH4mmGWsv0zZEq8+sFvkrsPs8PG3CLCv4A5+t9GT77Gm4Ji+KQ81vVAPMV9K4I1FtpXqbcMl29Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UMgavWDp; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rT9LwESf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UMgavWDp";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rT9LwESf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E28D621E5D;
	Thu,  3 Sep 2026 06:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788416607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pq4gpwxUXtqTAQGq9VjBSYfuPHHX7FM2WjTcOfScm1U=;
	b=UMgavWDp8kzDfRsl0RPOCHldkHsRevetcJvkmDlnUgcOid/NprKPQcsmH61sti2Sacynfc
	FfnOHbAmFb6tCKVeewKahA+q6yEDqFpQK3MArC4vmrMSjt2VP8YUB2W23KW9IILYssNoyk
	qxi4naX1QtwRy53UF2gwet7cFzPCU9U=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788416602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pq4gpwxUXtqTAQGq9VjBSYfuPHHX7FM2WjTcOfScm1U=;
	b=rT9LwESfcBrEgXAeApoymDtyNU7p/6PyiMdN7nS1eMdOEx53G+IkhXfshupvxs8hSFxnDv
	FJI0VCY/wSSfIduYSHqPnzZ31VfbR89S0YwvR5LuGz8S9DR3hSKn0omrYQdeXZVkZXvjQH
	XjwfVhB1HmQnKi7E8b9/vL7iMsDbfUQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B482C136D9;
	Thu,  3 Sep 2026 06:23:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YQ94K1oSmWoVKwAAD6G6ig
	(envelope-from <neelx@suse.com>); Thu, 03 Sep 2026 06:23:22 +0000
From: Daniel Vacek <neelx@suse.com>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>
Cc: Daniel Vacek <neelx@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>
Subject: [PATCH v2 0/3] btrfs: async checksumming cleanups
Date: Thu,  3 Sep 2026 08:23:13 +0200
Message-ID: <20260903062317.3928665-1-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	RCVD_TLS_ALL(0.00)[]

While trying to deal with encryption bounce bios async checksumming,
a solution came up which covers all writes (also the regular !encrypted
ones). As a result the code cleans up quite nicely.

In v2 the first patch was further polished and the new last patch promotes
async checksumming out of EXPERIMENTAL. Qu confirmed it was never meant to
stay there for long.

Details in the patches themselves.

v1: https://lore.kernel.org/linux-btrfs/20260902165137.3781696-1-neelx@suse.com/

Daniel Vacek (3):
  btrfs: consume the given iter directly instead of copying in
    csum_one_bio()
  btrfs: use bio::remaining for async checksumming synchronization
  btrfs: promote async checksumming out of EXPERIMENTAL

 fs/btrfs/bio.c       |  8 --------
 fs/btrfs/bio.h       |  4 ----
 fs/btrfs/file-item.c | 21 +++++++++------------
 3 files changed, 9 insertions(+), 24 deletions(-)

-- 
2.53.0

