Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB082AE78
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 07:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777189891; cv=none; b=uiYRwnGSDv/RR3/aZ37dmgfzLVjrl6kmxepfWDctszUGk+cRPAeN5rWGks042DxGw+2FXbxr24LwWfshYEPREalJ5f20RZmMx+iIkOrwjPGfW9UzdEskw/JRAdLzfkZy62GIuperu8MbwOuO2uukbZy0zG9+n1gjbknEE1GpPyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777189891; c=relaxed/simple;
	bh=RqTrGEOIvbsN7QEMrNmkRRmKcoATYtvE4u16/7iQVn8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GXo7AilfCMIVos+mWgoLfcut+Msdv4zwWUXheZt3oGYCz9wkoyXrRg020FiZU3ymK15e6TFqMaeP41u65XoinEe2NJm2H9eUQCQU/V6xSFkPsjaEfygMt3eDSfoB3G8tYp6n2KGmVaySP67aHMWwOmHCOZ7KxuGpaQTrrooKHbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hf46ZEua; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hf46ZEua; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hf46ZEua";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hf46ZEua"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 48C6D5BCD4
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 07:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777189888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GF4MDpsyqH43y8lx4Ic0uv63FZ3sl7WtTQa1cYUCaCQ=;
	b=hf46ZEuag7psJnqmG0mP7j41HqAc6OWnmLolAHm13eQFNlMvJaU8toa5hpcOhm/j7ngbrS
	cOCW7cH8ZoukXZrjvQHr8ihSyPimwQdbD0ysTrC981uG7lv8E/IeHYlO4n8PQXENIDsYZK
	W7OyPD96u40YzYxvqmGkQHZUgiX9a1w=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777189888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GF4MDpsyqH43y8lx4Ic0uv63FZ3sl7WtTQa1cYUCaCQ=;
	b=hf46ZEuag7psJnqmG0mP7j41HqAc6OWnmLolAHm13eQFNlMvJaU8toa5hpcOhm/j7ngbrS
	cOCW7cH8ZoukXZrjvQHr8ihSyPimwQdbD0ysTrC981uG7lv8E/IeHYlO4n8PQXENIDsYZK
	W7OyPD96u40YzYxvqmGkQHZUgiX9a1w=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 49E4C593B0
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 07:51:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mL02Ov7D7Wm3IwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 07:51:26 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: properly enable compressed readahead for bs < ps and large folio cases
Date: Sun, 26 Apr 2026 17:21:02 +0930
Message-ID: <cover.1777189624.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Compressed data readahead is disabled for bs < ps cases, but it has
never taken large folios into the consideration.

And that unexpectedly enables compressed data readahead for large
folios, which should go through the same subpage routine.

This means for real bs < ps cases compressed data read is disabled, but
still enabled for bs == ps with large folios.

This small series will properly enable the compressed readahead for both
bs < ps and large folios cases, mostly by simply remove the unnecessary
checks.

Then since we're here, also update the function name and comments to
reflect that we're already using folio interface, not the old page
interface.

Qu Wenruo (2):
  btrfs: enable cross-folio readahead for bs < ps and large folio cases
  btrfs: refresh add_ra_bio_pages() to indicate it's using folios

 fs/btrfs/compression.c | 67 +++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 43 deletions(-)

-- 
2.53.0

