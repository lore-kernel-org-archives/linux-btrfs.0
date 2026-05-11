Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA1B1624D5
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778461042; cv=none; b=sxXJK5fvGpg9hQqYD/lmn6yA6pl4Q6AWOmW6QCHanaZo6ctLcwMUom5ayplSz7xe6VNT2YxBOHw27UOawitVnvhRuy6LB5qYKZwTC+GnSDGsZLi57rgT8MIeq0XsumfbJarhcL7p8rGOxRG/C3xGGldzZE/xuPxQizOaHnqYg08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778461042; c=relaxed/simple;
	bh=clAyq1Nhsw5MTVfavB2avcyRtT44HU2+VKKpyQtwZzQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ETPX9tTN6Ml6tvUq8fGxTBg99rTD9Ppv1FFd0OcyULX6NBZ3ppiAtL5Ss5dqBbAsvv9SN9IUp9F7Dflm+6fijq7RpZPGag4hGlfaH9KfoS4I16g+GoE/hso5qtzphbpm9GXzPt7nZYz/xvZIM8niQDTsodbm4EVWuZrelSEvlDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=W8e/Zc2U; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=W8e/Zc2U; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="W8e/Zc2U";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="W8e/Zc2U"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 520DC5C505
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778461038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hRcnjpaHuqYiiMQ6oyX2g3IWs0AKL7rdd88lOIpLpZk=;
	b=W8e/Zc2UEXnKB1dNCS+REVb6ck8kbEjwmYvFgDYr+INQqQ5ph6eYgZKuxBHOEmCPE7I1YJ
	mZ4Jt5JhVtBvnYHwucfYJz6Yav1o482fFHVSPwQyoptCajYx0V7OEStS0yBwdiq7VdpN7Q
	W9hNjXGau3gX9q9Rdv/L4ARe3m3HJwc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778461038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hRcnjpaHuqYiiMQ6oyX2g3IWs0AKL7rdd88lOIpLpZk=;
	b=W8e/Zc2UEXnKB1dNCS+REVb6ck8kbEjwmYvFgDYr+INQqQ5ph6eYgZKuxBHOEmCPE7I1YJ
	mZ4Jt5JhVtBvnYHwucfYJz6Yav1o482fFHVSPwQyoptCajYx0V7OEStS0yBwdiq7VdpN7Q
	W9hNjXGau3gX9q9Rdv/L4ARe3m3HJwc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 912C8593A3
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AXAkFW0pAWp3OwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:17 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: tree-checker: enhanced fst extent/bitmap checks
Date: Mon, 11 May 2026 10:26:48 +0930
Message-ID: <cover.1778460959.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
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
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

The first patch is a small cleanup to share more code and remove
duplications.

The second one is to avoid u64 overflow for the extent/bitmap/space info,
mostly to catch obviously corruptedd size.

The last one is the main part, introducing cross-key checks.

If the previous key is FREE_SPACE_INFO, make sure the current key is
inside the bg range, and matches the type the free space info is using.

If the previous key is FREE_SPACE_EXTENT/BITMAP, make sure the current
key doesn't overlap with the previous one, and type matches the previous
one. This will allow tree-checker to catch most (but not all) bad key
type flipping.

Qu Wenruo (3):
  btrfs: tree-checker: extract the shared key check for free space
    entries
  btrfs: tree-checker: ensure free space tree entries won't overflow
  btrfs: tree-checker: add more cross checks for free space tree

 fs/btrfs/tree-checker.c | 119 +++++++++++++++++++++++++++++++---------
 1 file changed, 93 insertions(+), 26 deletions(-)

-- 
2.54.0

