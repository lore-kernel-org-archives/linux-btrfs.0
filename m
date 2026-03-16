Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF38EADC
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 13:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773666260; cv=none; b=K7ZuHdA9nLh4Bek8P3b07jr9OZb8L06ZCDJkSLw4MoqChwvo1TtZPIPI3LWOXRZ/diI9QdJSaVfTIq3/sAMirQgdNGLrHWJrYCn4X8BZaytEEjpaz7dbmrCVgA/k/nLFXDwifgDzps18WA9YIjViXVgBKpcB4AC1ZxNYAcKUNbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773666260; c=relaxed/simple;
	bh=UwqNCJ6CVGDVl1bYlVJL69WKSLW/Nr6PDYNVCfGxpBk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NSu8FNKwFTEQ9m8lsoiviZ2vv/Ct4u23HQhFFLR/qTUubZ2/+hE1JZtHVqEHNgYEf+u9DdgZ3bGQ4mZ+mlTIYUwiYaKHPELvK2hqwHVolQvRG3CRLazBJdlSQNFp1iFYI3oRVcUBJeAtsqJOJ8n9bXof3nf/PHPqXrVce/eGP/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=skJOpopS; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=skJOpopS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="skJOpopS";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="skJOpopS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DB98A4D2E6;
	Mon, 16 Mar 2026 13:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773666255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PQnIN7XkoqT47Wg1EFHBBtmBJNGHGOMglNBi0SZ67n8=;
	b=skJOpopSAfYt8377b6EWVKHWhTJKkkwQyhQS/nXRAlVx+qYMAT/nqpXxETgdZyTqRC8Vx/
	Q6ST2C2wmIdgErhYvf1Qyl6cnc1L1ASC9uNAhl4Q9MkiqGvcHuckmE7n+06Sly8TzVaV/L
	i0YM5efxZPMTLKA7VHNseMi2Izu1si8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773666255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PQnIN7XkoqT47Wg1EFHBBtmBJNGHGOMglNBi0SZ67n8=;
	b=skJOpopSAfYt8377b6EWVKHWhTJKkkwQyhQS/nXRAlVx+qYMAT/nqpXxETgdZyTqRC8Vx/
	Q6ST2C2wmIdgErhYvf1Qyl6cnc1L1ASC9uNAhl4Q9MkiqGvcHuckmE7n+06Sly8TzVaV/L
	i0YM5efxZPMTLKA7VHNseMi2Izu1si8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D46E94273B;
	Mon, 16 Mar 2026 13:04:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C/baM8//t2nlBwAAD6G6ig
	(envelope-from <dsterba@suse.com>); Mon, 16 Mar 2026 13:04:15 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.0-rc5
Date: Mon, 16 Mar 2026 14:04:13 +0100
Message-ID: <cover.1773665572.git.dsterba@suse.com>
X-Mailer: git-send-email 2.51.0
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Hi,

please pull a few more short fixes. Thanks.

- fix logging of new dentries when logging parent directory and there
  are conflicting inodes (e.g. deleted directory)

- avoid taking big device lock for zone setup, this is not necessary
  during mount

- tune message verbosity when auto-reclaiming zones when low on space

- fix slightly misleading message of root item check

----------------------------------------------------------------
The following changes since commit 0749cab6174dc035b1628fb6db03abf758cfda6f:

  btrfs: remove duplicated definition of btrfs_printk_in_rcu() (2026-03-03 17:20:51 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc4-tag

for you to fetch changes up to fc1cd1f18c34f91e78362f9629ab9fd43b9dcab9:

  btrfs: tree-checker: fix misleading root drop_level error message (2026-03-13 12:49:25 +0100)

----------------------------------------------------------------
Filipe Manana (1):
      btrfs: log new dentries when logging parent dir of a conflicting inode

Johannes Thumshirn (2):
      btrfs: pass 'verbose' parameter to btrfs_relocate_block_group
      btrfs: don't take device_list_mutex when querying zone info

ZhengYuan Huang (1):
      btrfs: tree-checker: fix misleading root drop_level error message

 fs/btrfs/tree-checker.c | 2 +-
 fs/btrfs/tree-log.c     | 6 ++++++
 fs/btrfs/volumes.c      | 2 +-
 fs/btrfs/zoned.c        | 6 ++++--
 4 files changed, 12 insertions(+), 4 deletions(-)
