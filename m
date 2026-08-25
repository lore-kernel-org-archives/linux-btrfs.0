Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22451990A7
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 04:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787631183; cv=none; b=WJrpRtE98fK5o2x8FvWppV6aohpJOLZM1Lw3C6Z16U5hna/7qhZFuvo4YM1Uk/sDDmHsxTysAQOsnCbgNuRpAVqOgo0/HR7kHpt7zBPcPvk2hzGssYkOWXz54itU4u6Xl5ufE6SmAmOhHiGp7vJvgBN3hByM5JBMN2orYOnCXqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787631183; c=relaxed/simple;
	bh=E/lMCCUGdVwHwsiBE6tVsXA+vZfeISj3O1DCE9l70bQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Ghd+LcORbMdx9mwTm5kneY8f4ekMAzpk2yJpfiKqdj5DX6IJrinMXXJ08R86NFQXnupbzWGPwv2iOZaFAlq5Dz5s/X/3LpGRJqkVzsnNcXDVHj32UaoTy3nHGOzWMqKaJkSyYV1aEIFXWOPvRUasTI8CGFAMdY5LRVZ6EPd0kr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Qx1nSukX; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m3N91/Ai; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Qx1nSukX";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m3N91/Ai"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7FE0A1F79E
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 04:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787631175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4sW+wrxZcJGqDHcTnmyEMBmlJ3vBvEUr3B6wkEz7x8M=;
	b=Qx1nSukXBehFoeus7z9ATls2s/I55/DA4PnevCGoO3f/dETLUw3Ajxn9lVr8H9PCqEXwfY
	wEF3v+mC08Uu2sbeUdzBbyG85kaXHRXmJk2Bq0ZPPIvyVEe0GwAD9Nxo5eCr/DzPebf4be
	67dWmCjgFaq+4+UvnPfogGlo5nrmHFM=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="m3N91/Ai"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787631171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4sW+wrxZcJGqDHcTnmyEMBmlJ3vBvEUr3B6wkEz7x8M=;
	b=m3N91/Ai+hVZuAOBMhwjypNyENabKdlYL7IvMrDKV+zwL/Ff/wnpMTPPfBdNQCvcyllRWE
	p3kWGADmNMR7lFn5pOJrqNY2Gkp2oId3WybLAxJSmYsazYWuyiJyNk9ddKO65Pp3WE7f74
	UwpXh8N5/vEbUOhmT52e/at5xJlSC2A=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6C74D13331
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 04:12:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9APkBUIWjWodGQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 04:12:50 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: qgroup: minor cleanups
Date: Tue, 25 Aug 2026 13:42:29 +0930
Message-ID: <cover.1787631065.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
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
X-Spam-Level: 
X-Rspamd-Queue-Id: 7FE0A1F79E
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Remove one unused variable from btrfs_read_qgroup_config(), then use
atomic operations for qgroup_flags.

Check the changelog for each patch for details.

Qu Wenruo (2):
  btrfs: remove the unused variable @flags from
    btrfs_read_qgroup_config()
  btrfs: qgroup: use atomic operations for btrfs_fs_info::qgroup_flags

 fs/btrfs/fs.h                   |   2 +-
 fs/btrfs/ioctl.c                |   2 +-
 fs/btrfs/qgroup.c               | 110 +++++++++++++++++---------------
 fs/btrfs/qgroup.h               |   4 +-
 fs/btrfs/sysfs.c                |   9 +--
 include/uapi/linux/btrfs_tree.h |  26 +++++---
 6 files changed, 84 insertions(+), 69 deletions(-)

-- 
2.55.0

