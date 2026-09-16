Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13A83E9F8E
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789541565; cv=none; b=uohxXUBRfcJsZyAntDS6sy3K5xuavF4QF4lfnOiBp157rOABg8UBF31yph7PBogd4txx/2+NCi01PbT67p3uwYvXyqwKHQKHtcu1ZdHZPSwvUrku68vG5Xyo0IM2vLpdirFA9bZeQP7TYMg7bCck0w7Lmafh0BNgZNJR0H78Z1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789541565; c=relaxed/simple;
	bh=q01t0/BG/b71qvm4sta9prJHIhgJG9A++HbocbAmZSg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=NPVV/2Qc/ZhguszolaOH/R37oNQYvwTEka6lbvtSa1PfIy2bhTnkVEsbLqe9dSJvZ6qPQDEy96C9FMSHZfCPCzxvP7OlYObMmx2oFJhLOguHF3+XYcowDxiiDytNHYBh1LgcQ/KrwoXAvuUD7DpYcRKNgoNh3jM3Ip1kJePDuXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HtUv7eI+; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YEb3EMFW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HtUv7eI+";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YEb3EMFW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 71C1E21C09
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789541557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LAvpkwRUrqXlljZt16gEVFGOgSkO5KXVCNSUm4WLFpk=;
	b=HtUv7eI+EJWUmVbq9A9VyL+ndd5JR92nXV9u+B7bHuUgM7VPj/uGH6Xbg8tTp9q+rMyzlo
	E4kBa9oUyjlfVTldr42qFk+PIm4j8wiYKUNpgNkzORsxgiB42Bm4h2VXsea9LSH036nJxy
	2ia//136YEoypK0lQy67HP9uFBTUvk0=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=YEb3EMFW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789541553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LAvpkwRUrqXlljZt16gEVFGOgSkO5KXVCNSUm4WLFpk=;
	b=YEb3EMFWC8T4QmhVwfzFkEgYRV72HR3ys6p68zt8UAAg6W/vGmxi4VjuumtvCTIKAT/Yq+
	WWmukSsQGPCXgOKyE/Q/+jDrf3UYc1ct3zuw7kH/9rkpUrrCyJSmy9znCfEbvzgxRq2ACc
	A4ARW/99WU03ZJtXExKDJyCsNeFPCsA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 448631348F
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ts9hJK88qmr0ZAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:31 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: restore: handler newer inlined
Date: Wed, 16 Sep 2026 16:22:02 +0930
Message-ID: <cover.1789541428.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 71C1E21C09
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid]
X-Spam-Flag: NO
X-Spam-Score: -3.01

The detailed commit message is in the first patch.

And also fix a minor problem related to very rare inlined extent that is
larger than 4K (possible only with page sizes larger than 4K).

Finally a test case for the initial problem.

Qu Wenruo (3):
  btrfs-progs: restore: handle full block compressed inline extent
  btrfs-progs: restore: handle inlined extent larger than 4K
  btrfs-progs: misc-tests: add a test case for btrfs-restore

 cmds/restore.c                                | 23 +++++++++++----
 .../073-restore-inline-compressed/test.sh     | 28 +++++++++++++++++++
 2 files changed, 46 insertions(+), 5 deletions(-)
 create mode 100755 tests/misc-tests/073-restore-inline-compressed/test.sh

--
2.55.0

