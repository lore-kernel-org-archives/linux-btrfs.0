Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B5728851F
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 07:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788678258; cv=none; b=dj3NjNmmromp85RD1hLLY6SeTJnZ6xBz7Xvy2a9374Xhe+iz78abHmsU7jZaJjK6ldv/i+zH37CXk3VeLUPgvBIEqUeLBcPp+EeUaA9ksCepP+/BYa0Jp8xxezOTUujwkYNqWCtGpQ1Z7xy1OeGJ2LFrf88u2t+iQ8mQxj3gI0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788678258; c=relaxed/simple;
	bh=L/jlZvYZZn+TCj7aEq8NJbDJZ2OoVw20mF/BSaUYwi0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=j1ufld2ttYYRfB6ApifXM4yFNfgikhUEyLZxAsMlphp3t9EjclU0Z5LTvxQgz0qHbs34BexuJUxRn5052KPfEHK6vvZSlsKlB+lSJOltiV5vNn/fm2pYz8OZ0tPN+XnU1eV5HaaFZDK9HWFDgAacnqDhGDsqnLY42ozXIrwXxuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YCzeMSTu; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Z+Dmj9YL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YCzeMSTu";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Z+Dmj9YL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC45422747
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 07:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788678250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2VOTkGj1KCOTSI4D84m1n+uvpaTUL4rlS3pb7GH+Fxk=;
	b=YCzeMSTuWSbzL9v8GEDachHytGJvWEcHrsFTW5OfybKk9X3hhjH7F6hs97/Y3tK0xWMOjt
	Ao5wW+zJ96+vP5ABKk0vC01iBeTWh8rj04TidovVufrZwnoBQWLCPnj8BRyf8iMVeJdv2k
	J5mwHLXsUkNIDeOMVx+RopNINqvwh0U=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788678246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2VOTkGj1KCOTSI4D84m1n+uvpaTUL4rlS3pb7GH+Fxk=;
	b=Z+Dmj9YLWb19iRRWjfSapK5GIutGUdP3cPNxbWA2kgGAjEDUsNu3CVPUn2vstDaK9l01HF
	UhBU7HcgIZlOAych8RlwBQ2FP3dU/tAsxCWz+mwQR/Jm8rah++yaZQGDdAwckucNfmRaze
	I1qKxtAuPwvEEx/1/2RQch0UH23kRCE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7658C133CF
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 07:04:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3irwCGUQnWpUMAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 07:04:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: allow more fine control to rescue=usebackuproot
Date: Sun,  6 Sep 2026 16:33:36 +0930
Message-ID: <cover.1788678078.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
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
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

[CHANGELOG]
v2:
- Fix a missing use_backup_slot update for rescue=all mount option
  Which can trigger the ASSERT() on use_backup_slot.

- Add proper output for btrfs_show_options()

- Slightly update the commit message of the 2nd patch
  To address a false alert from Sashiko, where it thinks it's a bug not
  to load any backup root for the newest slot.
  For the newest slot, it matches the current generation in the super
  block, thus every root should be the same as the super block, and no
  need to load the bytenr from backup.

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
 fs/btrfs/super.c   |  28 +++++++++++-
 3 files changed, 74 insertions(+), 61 deletions(-)

-- 
2.55.0

