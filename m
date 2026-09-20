Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF0A479864
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Sep 2026 22:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789944681; cv=none; b=qPb0E1Ngba5oScTrCmk2lnWT8uvY7FWNcgTfGjbInOcOu4v5qnc1H+Urg9QtXdj+nmHpKOeJrN+ywulDykwwL0zkCPxZxlL/2c29B+jrhgpqF6p8I1zbGhXSYYzt3cSJVKCcVpr5ORTcxmZUC3WCSxCz6zHNhJki0/H1feK8EF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789944681; c=relaxed/simple;
	bh=z2r1kpn2KePKskx0zuRDS/W7aQPZdHpgLklku2Kv8mg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=m74W1kNlbCUYBtjlcQrXx9Mc3BaeDYHKlprqnDezLui1fs8YPG/jesuNEYk6OOVeCTVA1WGPoKFx2cwAO57ZZovm5185PP6bN7s88DNGiSsVUuCDBYQTNOZWo4zQuDcnD/JMsmZubWiqh/YKtC70qS0UOG73BplGbP+2C1wi8eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=blsko8Ul; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tnJrKuF2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="blsko8Ul";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tnJrKuF2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F2C8521A70
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Sep 2026 22:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789944668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Opqkx4xUl2dtOq3pUTM1sjIb8FbG6KjfNt5HViHTMns=;
	b=blsko8UlxJkIRKn0m249l/EeglCK83FErU1/y18h6sm3u7YoNTC0vtFpVQOv17GB5K5sOq
	LTpO+8D0Vh2g3ysQmSDJIax5ybVdNpKGHNJKGnJ3IpIU9dxOjhGnhur8nubcBR9/3+aKYp
	7bA9aWmd2/UE1jbsu5N2M/c2zM2lCt4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=tnJrKuF2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789944664; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Opqkx4xUl2dtOq3pUTM1sjIb8FbG6KjfNt5HViHTMns=;
	b=tnJrKuF2+nC848q+ztcd0cs15Ki3mrycPjnJVmdFRZW/6+sQSH/4hFrAuCW3lq8sVVMjeX
	MB9l3+FQTye9mJkwsQ2qb2/iCUdIvCQgRLfpET3k/IZSzC1Qa+GI3yVNnYqkMmm9hDljEc
	p8OS5rtswcgnbKTr7QKQEZRfuHYuvWs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B465713793
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Sep 2026 22:51:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id imMtBFZjsGphXAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Sep 2026 22:51:02 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: remove the tailing zeros from compressed inline extents
Date: Mon, 21 Sep 2026 08:20:42 +0930
Message-ID: <cover.1789944508.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: F2C8521A70
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

[CHANGELOG]
v2:
- Remove the block based space saving checks completely from lzo
  Zlib and ZSTD do not have block based space saving in the first place.
  It's the caller's responsibility to check, and inlined and regular
  extents have different requirements.

  This simplify the first patch a lot.

- Update the cover letter
  Filipe's v3 fix is already merged, so we can not force push a fix but
  to co-operate the v3 fix.

Commit 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated
delalloc helper") changed the compression input from [0, i_size) to [0,
blocksize), which caused two problems:

- Other tools unable to decompress the inlined extent
  U-boot and btrfs-restore are affected, as they only allocated a buffer
  which is @ram_bytes sized.
  That buffer is too small to contain the decompressed data, which is
  @sectorsize.

  Those projects are fixed to have a more robust decompression routine
  which can handle both cases now.

- Worse ratio for those compressed inline extent.

  For the same 3K 0xcd filled range, the results are small but
  observable, 48 vs 61 bytes.

Filipe's v1 fix is very close to a proper fix, but btrfs will unable to
create inlined extents for lzo.
It turns out to be another bug in the copy_compressed_data_to_bio()
function.

Which is doing a premature block size based space saving checks,
meanwhile all other algorithms do not have block sized based checks, but
only a simple "@compressed >= @input" check.
Zlib and Zstd all rely on the caller to do proper space saving checks,
as regular and inlined extents have different requirements.

So this series is to properly fix the bug, firstly fix the lzo
regression which prevents inlined extent creation, then restore the old
i_size based inline extent creation.

Qu Wenruo (2):
  btrfs: lzo: fix space saving checks
  btrfs: remove the trailing zeros from compressed inline extent

 fs/btrfs/inode.c | 7 +------
 fs/btrfs/lzo.c   | 5 +++--
 2 files changed, 4 insertions(+), 8 deletions(-)

-- 
2.55.0

