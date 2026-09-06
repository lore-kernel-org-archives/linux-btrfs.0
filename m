Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C325335E926
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 05:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788672403; cv=none; b=WEYMhnlfYSbLs4df/ZloBSeZHSIsb4Ao8UK9Rq5717wH3jMK07JqdNGF/6E6+9BetkU4Th35/2nSemNRzAJHu1iONe5gNTZABUSWgETl3G1eJRki1FWw2kEuYT0SmWSReZBjnb90YSumjoXWrJThFzcmTAi0SBVhRa28cPkVQvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788672403; c=relaxed/simple;
	bh=XKnYFQiG7KZSFvkRyp+nnAbv+MygKX4m2C38VVipkC4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ZV5Rn7OynKOf9F87IBPfLy6HT7zZO1pkYWgTuE4/zDJcjHY8288x4WRI5Mbf3fVKsT0KbHMZvHAyPOcpNXOAs9MKrW+OBsuqo+ix66vmVFYxpnVjiOYR55K2w8rx2Q1k64Kzx6A1Qr3uyOTV8rkWh9q4Y8YIa6pRx0Koh57ee6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fFGaWvmx; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q5BGduze; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fFGaWvmx";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q5BGduze"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 779F933A03
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 05:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788672395; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SIe/UKcalgl22FaBOMgpSegftOk17Oc6kamlQAGOPAo=;
	b=fFGaWvmxi1ZDIW6Tlm84mLGm8JSpVvFsVM354dDLlbZ3gmJw8IrCtMZ47LBqGm75M8S1qb
	GhtpmC0fY1sWdGKn1K6u5+pW1CJ9fipKQIYUmn4HpE8XFmALu+xZEmlLEGRAb/yfib0GAv
	Gvn7nxjPrdXAplgivMXRhFgnIDSJbA0=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Q5BGduze
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788672391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SIe/UKcalgl22FaBOMgpSegftOk17Oc6kamlQAGOPAo=;
	b=Q5BGduze4hzCQlJDILnDsHmTUbTUV66kO0BESyCwp3lF3PjkW7hzJQQ5GcU6WZbAVoUYQr
	r4sMD2XPb8ur353gPkDSoHYQcLesf36F2P7WZMmq23fcKyhPPXPxVLU915sev5n0Rf9wHd
	MToBn+xVndsYSIYBiT42gYL+Eewcqiw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 41BBB13432
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 05:26:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DPHvN4X5nGqVUAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 05:26:29 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: allow more fine control to rescue=usebackuproot
Date: Sun,  6 Sep 2026 14:56:05 +0930
Message-ID: <cover.1788671975.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 779F933A03
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

There is a bug report that for a specific corrupted btrfs, the
"rescue=usebackuproot" still chose the newest slot (aka, the same tree
root as the one in the super block) to mount the fs, and resulted
transid mismatch.

Meanwhile the reporter used btrfs-mod-sb to modify the fs to use a
specific backup slot, then the fs can pass btrfs-check.

This shows the limit of the current automatic backup root detection,
that as long as all tree root nodes can be loaded, btrfs will consider
it as a valid backup slot, without trying any other slot.

And end user has no way to tell btrfs to use a specific slot.

This patchest address the problem by:

- Make "rescue=usebackuproot" to always use the second newest slot
  Which has the highest chance to still get every tree block right
  without transid error.

- Introduce new "rescue=usebackuproot_*" mount option
  Where "*" can be 0/1/2/3.
  0 means the newest slot (aka, the one matching the super block
  generation), 1/2/3 means the second/third/fourth(oldest) newest slot.

  Now "rescue=usebackuproot" is just the same as
  "rescue=usebackuproot_1".

Although those "rescue=usebackuproot*" mount options still requires full
RO.
For proper recovery, we still need to use "btrfs check", and a new
option for btrfs-check will be introduced soon to make the backuproot
usage simpler for progs.

Qu Wenruo (2):
  btrfs: always use the second newest slot for rescue=usebackuproot
  btrfs: introduce more accurate usebackuproot options

 fs/btrfs/disk-io.c | 106 ++++++++++++++++++++-------------------------
 fs/btrfs/fs.h      |   1 +
 fs/btrfs/super.c   |  20 +++++++++
 3 files changed, 68 insertions(+), 59 deletions(-)

-- 
2.55.0

