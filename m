Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ACF26296
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 05:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786943665; cv=none; b=mfIj6Jv6Hu+tuAiKUeMpBmNUHm5a0r4M5RsYKRZzKu2xGmEQIvXXTZjO67bwe68/e4k9pg+5W0xdFiIPLELJbbWB/8tUMBhBoraY0BP2j6sHHIzsYIAn0sipIBOtLHHuGlMSChK+zx8BhTvgf5biTCVkmv/u1cMPrhHjnXr2GCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786943665; c=relaxed/simple;
	bh=rTGtgcC9dZ42bDrCcpMc8WvW9lXbyuAbD2V89xvFBIA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=SWl9/3GjW/QrL8gRTuuzE9ZxA1iUMsk+sPETRfTO0w6++xiVq3r1gXgjiYhBdkD1K4wynRAOnGYueEH7gq0UIrs7W3e2sNkv3uPguI4dzLkr9I0U+2DwLx5P5G7bAEuwBEzq/M4wCLnwQjW200nmrpUqhl/aUsJWno0pYi9wKj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=l0WWATRy; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=u2hRX/3L; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="l0WWATRy";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="u2hRX/3L"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3145983E30
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 05:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786943658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QiiRWtFg1nc+u3Hg2mDkkOzJgbjhTIJknwmSGDzi6GY=;
	b=l0WWATRysteS+PD34kjmeYBxv+R0xpH9HtNMswOq7qK5kJkLcHeiu+yYjSBfDeZAMIiLNB
	GO5iCW/RdcNsB+tw5Rzc5C+YrvprTp1kIqklQBeuAjLIfXrN1385EmIQPNgMnq2yy7mKaf
	88A+iSp9peruJXjkqCEjcu1nwNavNIM=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="u2hRX/3L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786943654; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QiiRWtFg1nc+u3Hg2mDkkOzJgbjhTIJknwmSGDzi6GY=;
	b=u2hRX/3Lvr7dQNyliG4w1Fyt4b826fpbJQao7Xldm30RzdZvDJ6fWQ6JcZWft0rfSRrsw+
	ILUKx6SAH2nnrftiDywMmv3szD905Vzd7LQrVNymmomz2kX+z6Ypww9QYOHUKMUUlTCm9G
	a+bggJ42/QMQk/zHmB+V9/Kx/hKm6h8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 118EE792C1
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 05:14:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +0ARKqSYgmoDSgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 05:14:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: rst: minor error handling fixes
Date: Mon, 17 Aug 2026 14:43:52 +0930
Message-ID: <cover.1786943382.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 3145983E30
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

Sashiko found two pre-existing bugs in one small patch unrelated to both
bugs.

Both reports are validated by myself manually, and both should be fixed.

Qu Wenruo (2):
  btrfs: fix the possible bioc_list memory leak during error
  btrfs: return proper negative error code for update_raid_extent_item()

 fs/btrfs/inode.c            |  3 +++
 fs/btrfs/raid-stripe-tree.c | 24 ++++++++++++++++--------
 fs/btrfs/raid-stripe-tree.h |  1 +
 3 files changed, 20 insertions(+), 8 deletions(-)

-- 
2.54.0

