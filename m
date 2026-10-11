Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20E81F09AD
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 08:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791706951; cv=none; b=UEbKyaEKboW4sss6EyRzpMsB9yq5P2eKFpUCn14tGets7FZC/ZiVFK7JDIAzHX7wYquqJR9BGbfUkE6b12HOatWEuU+EjYG6BHfIypD18UFwKi/Aums82UmDehVhTOxC1qsB8wUR+JHia4Ih0yDe1YxxeI9lcRVdSEoKs/GBt3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791706951; c=relaxed/simple;
	bh=TnxkzVdE1pUTPPSxzoq2RwC//Cns+YpK4r7L+IveyS0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VBi6kfBZmUEOUGOlPAGHRQMUTtAXtTkDXzNSuPHRmFC5ClErlh9owKrF2hsLwfyhgkCm+3bDXR2WpNLZjYgcdUUWQDJqDOAmZU6S8QlixDX36IChApo3UCUT9Cqogayl26bGOlkUe19OQwpD0ot14rA0yLEyFN2hyxoBrBMz1Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dtcIjrAE; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dtcIjrAE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dtcIjrAE";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dtcIjrAE"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6FB0221E3D
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 08:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791706939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=JZUWoLMqMVGt3NKgMLb4Xz67nfm5ymRjH6F12/ML8l8=;
	b=dtcIjrAE9CkHL3RGEGfvGHsvWMU+8X3yG00lE4R4VriC7z6NWI1XVBlDgnLp9jtMp7ejmU
	wpjwUzuW0uEAzXWWBBbUkb4ndd6gHZz24DzAkCPEJuBu9eHn7nnn3CndPaoUPge07wZd4x
	B8jjUWgiDXf+TQHm/g2/aQ3WnRCmxpQ=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791706939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=JZUWoLMqMVGt3NKgMLb4Xz67nfm5ymRjH6F12/ML8l8=;
	b=dtcIjrAE9CkHL3RGEGfvGHsvWMU+8X3yG00lE4R4VriC7z6NWI1XVBlDgnLp9jtMp7ejmU
	wpjwUzuW0uEAzXWWBBbUkb4ndd6gHZz24DzAkCPEJuBu9eHn7nnn3CndPaoUPge07wZd4x
	B8jjUWgiDXf+TQHm/g2/aQ3WnRCmxpQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2153F13408
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 08:22:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JViNFDlHy2oHdgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 08:22:17 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 0/2] btrfs: fix a UAF where btrfs_root::dirty_list is freed but still referred
Date: Sun, 11 Oct 2026 18:51:56 +1030
Message-ID: <cover.1791706855.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

[CHANGELOG]
v5:
- Drop the first patch
  As we no longer put the list_del_init() call inside
  btrfs_put_root(), the existing code is already safe without the need
  for extra spinlock, as the existing callers are already holding a
  trans handle, thus won't race with transaction cleanup/committing.

- Also drop the spinlock from the 2nd patch
  As we are already safe without that lock.

- Update the commit message of the last commit
  As we no long hold trans_lock for every btrfs_root::dirty_list caller.

v4:
- Also cleanup qgroup swapped blocks and dirty_log_pages
  Which are only released during switch_commit_roots().

v3:
- Use Yalagada's v2 fix as the final UAF fix
  The delayed list_del_init() call inside btrfs_put_root() is not
  safe as another racing ioctl can grab the quota root, extending
  its lifespan.

v2:
- Add extra patches to address Sashiko's comment
  * Make all root->dirty_list users to hold trans_lock
  * Release root->dirty_list from cur_trans->switch_commits during
    transaction cleanup

The first patch is an existing bug exposed by Sashiko, which also
affects the last UAF fix.

The last one is the final UAF fix for the bug reported by syzbot.


Qu Wenruo (1):
  btrfs: prevent use-after-free in btrfs_transaction::switch_commits

Yalagada Pavan Kumar (1):
  btrfs: fix use-after-free on quota enable allocation failure

 fs/btrfs/disk-io.c | 10 ++++++++++
 fs/btrfs/qgroup.c  |  7 +++++++
 2 files changed, 17 insertions(+)

-- 
2.56.0

