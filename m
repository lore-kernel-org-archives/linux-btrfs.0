Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6515C4A3D41;
	Wed,  2 Sep 2026 16:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367925; cv=none; b=LO29aR0CypNOgFD920cbyvaPqK5sHBQ8ZgVw+aZalwSj5hTrFUZy+O5+KEJZYetx4nD2STfCf9NFiJc/La0qVFhQyasEkhhk5dzDyZYHpY3FvCDRWrrLDVJnDHFYD7/kbOhBbr74VMPjwjnBsh4rW/1fIqSbGb3MntgLvAXAdDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367925; c=relaxed/simple;
	bh=3XWl1pK9IGhZL47QYdYxJa2zsJ7Ugv152mtnC+wzRGc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tl2RD3zApckR5F11CrfwV3StNueTUXVe9KPiMFUGgViIO4GvPH5nz1F6ZvbKm7/pGNWe22uq2bCQhNeylXd5OGA9GV1+62k4bGs/9WFCZ+rXGDlQtrbJq6tYKVSAXof/g7WnpCYhaD7uTZy0OKX6wZznExpjK5YCbElDu9iAlHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Hs+7NCq7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qotgvntt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Hs+7NCq7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qotgvntt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2898821C92;
	Wed,  2 Sep 2026 16:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788367917; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=nX+GzhKOkDWkqnFSp/XrtoiqeEkYVG8qVIJOUPA2cQ0=;
	b=Hs+7NCq78aYdvtU4qwlrgiPFO1bmAQhI1MsFTnVZNQohQdnMk4ZnuGEvkKAcCUYXAymhD9
	e+iTjeOSekGEJhZtg0z8caACQTkMdQr9AxHVOVoV0P95gFzWlqEdE7QHsjI9Gcfxb3FI5r
	yaFLMSxp7XMQs3HAHfCBKWQiHroq8S8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788367913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=nX+GzhKOkDWkqnFSp/XrtoiqeEkYVG8qVIJOUPA2cQ0=;
	b=qotgvnttgZ9CB5FJRMxzhGk5UEzyTqRiURn+zMfD/3zGFiSx8gScyDlKBLVeREmxK2SXFF
	wCetLdFhLugt9ijdi7nEhIgqIBdnoNqGajmJrRoGNBVIIjPvk9+D96qA8tIVPf4+o67mcy
	xHCvSnjNIQ1XiuL3Zqrw9iyjB8kuG0o=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E4D1C136E6;
	Wed,  2 Sep 2026 16:51:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q0fgNihUmGqNKAAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 02 Sep 2026 16:51:52 +0000
From: Daniel Vacek <neelx@suse.com>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>
Cc: Daniel Vacek <neelx@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>
Subject: [PATCH 0/2] btrfs: async checksumming cleanups
Date: Wed,  2 Sep 2026 18:51:34 +0200
Message-ID: <20260902165137.3781696-1-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

While trying to deal with encryption bounce bios checksumming, a solution
came up which covers all writes (also the regular !encrypted ones). As a
result the code cleans up quite nicely. That's the second patch in this
series. The first one is just a nit. Details in the patches themselves.

Daniel Vacek (2):
  btrfs: consume the given iter directly instead of copying in
    csum_one_bio()
  btrfs: use bio::remaining for async checksumming synchronization

 fs/btrfs/bio.c       |  4 ----
 fs/btrfs/bio.h       |  4 ----
 fs/btrfs/file-item.c | 20 +++++++++-----------
 3 files changed, 9 insertions(+), 19 deletions(-)

-- 
2.53.0

