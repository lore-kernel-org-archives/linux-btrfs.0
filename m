Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058439;
	b=N2L61EC7iS97ssLW91lMakhMMo0NNDjOa/r0vC17rIeaLsVRFnUt5hyAYNMIrwIAWMZ5
	 4DWVFJjO+E8AcvB4tGUOFqt0BzN5Gl7GXJyHS75H+ZgiXNAXBQTNgA0MReyPJ3PwqCxfs
	 zTaRBunL26VpIFurVL/vuCmZpN5L+RtXx/oB+g2S/rIF6OWbFpjns1mRi10dj/0AzOub9
	 PWhx9dIrcPIMQaDjusjTLDNbSBWJjNZ/rH/j1WQITaz2kTv4bi/yuT1aQL7U+mu7neenC
	 JgZr1ticz28ch9F4tg3IAPpw61ME++oXYodzb3uyPeFHHzkdYgGRIdnWyKJMfUDWKsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058439;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=tXPbplkcekPnmN6xmcw6HFlrSXC90INz+S7Soo6we7o=;
	b=s+zApO+hwjgWn8kMFHl6E+bsU/tIA4DZ7IRXwnfhE7WFNmeV3K6VZrjpJxN6f068NrTZ
	 ZDdTeAuvZ2Fj5FXsbGBxycc2FmjTwWWn34bx13cQ5KaahbyQXPZ56rGgVFXjgVSJEKhwC
	 kT8zgN3iAs2VOYdg550P9LoKwTCi87mLN0Ip7LuO1FiHJqsKECfJRoix3ltiH9BfvSG+o
	 XDZaw0jzkczYACvfsAF1IRrpfLrjPw63A2TstBQWJ+hEwiiPgr6WeBMD2SCpCWk0r4qsG
	 2vfXV+cn7V7tuYirIGpPvT7HndCxfb8Jj8bzK+74NwOcwcVF9pxeCo2OSiwV6x4fWyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=LwB9ZEJQ;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ALvyYE3t;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90993606A326
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 03:20:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90993606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=LwB9ZEJQ;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ALvyYE3t
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7435722107
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 03:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795058435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tXPbplkcekPnmN6xmcw6HFlrSXC90INz+S7Soo6we7o=;
	b=LwB9ZEJQ+VW+w3XOAKmH/wovQjmC/ivkRGrtwzBALpXWlfh5nxp/2MdOt79Wjm5see0aZN
	n1VTdYxbtbsjUzx6McpCGuaKSw0604CToek0cENTkZnvdZO+7K7zsDrVSh8RsT0tdKPy4c
	JoMOMGWEU0/X+4Mo+0m5KPVI2gcPmHI=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795058434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tXPbplkcekPnmN6xmcw6HFlrSXC90INz+S7Soo6we7o=;
	b=ALvyYE3tJ7K71XIfO2N1uxyngEK0tkoOHFoDcIR3/wV0hhVTkc8jmV+9i2WxYqIO04wIXY
	FgQdWLLT3k+s053Q5xGfEkk2kGqs1ewxrPoLireYhR8O6Eh/Fc5gdHcacgHqWjLAZPFXI5
	96qXFxFk4/QAxHNCDhSlxVJWxZ6/9fw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1ACA21334C
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 03:20:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sSvrFwBr/mq7WQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 03:20:32 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: add extra points to warn about extra chunk profiles
Date: Thu, 19 Nov 2026 13:50:12 +1030
Message-ID: <cover.1795057869.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

This is inspired by a private user report, that after replacing a
missing device from a degraded RAID1 fs, the fs can no longer tolerate
missing the old good device.

It turns out that during dev-replace, a new system chunk is created, and
since dev-replace destination can not be utilized for chunk allocation,
the new system chunk is SINGLE, thus can no longer tolerate missing that
device.

We need a better solution to this long existing SINGLE-chunk problem,
but for now at least warn the user about this for both balance (success
path) and dev-replace.

Qu Wenruo (2):
  btrfs-progs: always check if the fs has multiple profiles after
    balance
  btrfs-progs: warn about multiple profiles after dev-replace

 cmds/balance.c | 1 +
 cmds/replace.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--
2.56.0

