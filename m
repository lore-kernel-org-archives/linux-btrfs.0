Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744B02E7657
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 15:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777562717; cv=none; b=ntdMnuWxzdYM//TsNa6oWQvvxKWkWEIO/DkWdV0w4XACgwWRIQrd3XPLohREbaDvwm776LXJcT1T1a0bgsRot9VZBHwHB6xfDfypmPPgN/buwkENHsY6vBzfUn1iGNgIn5aAeTJyh8cn6g1tSt6/KkH5VTXeWwthXyp4rGdqcag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777562717; c=relaxed/simple;
	bh=IiYiJ207NZD3M4P2mrmL+RBYD4CHWGPAjw4Lb2snOYo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eCD1iybxlrKdDTc2CpCaMG75DJRHUmTj/DGuCH6TARt+NpNbdKD9pt9LnchPringAdpPpKIzJXKuiWvBoEPwQ1xhvTK3bPuk1l6EDumK1i2oKJNmG5tCYoqEGw1pD04KV6z4ogK7YisbBQywTae6RJH1bsbo02+ilJlI9Wl5g4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=M9qfRMwU; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=M9qfRMwU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="M9qfRMwU";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="M9qfRMwU"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9DD136A887;
	Thu, 30 Apr 2026 15:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777562713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=p0ZWBikyNaBa/yF7+wfORHK9m2ogCaUCIhdG7rWcGcw=;
	b=M9qfRMwUyXCqsWFG5ViEMV2cRSA8AI4hxdOwDcjkQSLS7OMlNgKnZ4tIjq54Yj9S8ptdur
	SoajtN8j8hoVtm663pDS8Pj2RrZSxE2ZqHpijK+yWNohU6MQRWHlt7gt7YCumn2aDnQCcz
	zyqoDRX/43vCqwgNTAPcayHDSwT2flI=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777562713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=p0ZWBikyNaBa/yF7+wfORHK9m2ogCaUCIhdG7rWcGcw=;
	b=M9qfRMwUyXCqsWFG5ViEMV2cRSA8AI4hxdOwDcjkQSLS7OMlNgKnZ4tIjq54Yj9S8ptdur
	SoajtN8j8hoVtm663pDS8Pj2RrZSxE2ZqHpijK+yWNohU6MQRWHlt7gt7YCumn2aDnQCcz
	zyqoDRX/43vCqwgNTAPcayHDSwT2flI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D504593B0;
	Thu, 30 Apr 2026 15:25:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8kB5Ill082kUKwAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 30 Apr 2026 15:25:13 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2] Backref iterator size reduction
Date: Thu, 30 Apr 2026 17:24:59 +0200
Message-ID: <cover.1777561536.git.dsterba@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Remove fs_info from struct btrfs_backref_iter and replace allocation by
on-stack usage.

David Sterba (2):
  btrfs: remove fs_info from struct btrfs_backref_iter
  btrfs: use on stack backref iterator in build_backref_tree()

 fs/btrfs/backref.c    | 39 ++++++++++++++-------------------------
 fs/btrfs/backref.h    |  9 ++++-----
 fs/btrfs/relocation.c | 13 ++++++-------
 3 files changed, 24 insertions(+), 37 deletions(-)

-- 
2.53.0

