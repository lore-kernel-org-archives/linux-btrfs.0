Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1606836494B
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775970548; cv=none; b=M6RKcNue5gCA2b18xA4m3l7TjXj8iI93avyaP5qey1YVCJkLVbsdQgxPaqLhe0pEhiEAwqTVn0s3/eFVUMIb3Y8+61Wp3NCRGhoumlZum7ToMHLrEP317gQ5NmkoaoRJl85EmyQqZRvnZmr5YzCbIQpP7z6QdSbCLfqkzH0/Vzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775970548; c=relaxed/simple;
	bh=8ViUCce+o3QOQNbghnn2BuWh01kd4L8Dezk4sZFCh2o=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=d55nBynRZetL4fNR+DeP/T8B3TiW1w9ilY48DR/bPQNUpqu2PSzlJhlIbHSbNByQV88bZ0y4Wu7JkvM34J6paHFRw5EnNKv7pykRfRZ4aZ/k3+iNxSGORDr5Bbo5Y5bJRg9SP57YkH53JhM0vrZikX5/VN0mVVviY4Ex18fl4qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=V8OQnKBn; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=V8OQnKBn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="V8OQnKBn";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="V8OQnKBn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 571395BCCE
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775970545; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=A+lKJqazM8LW8l5eDAV7P3Okj11yXCHcbfJhYHmZx20=;
	b=V8OQnKBnoKZ9yFB0xYvOhcgI9Igfry+UKFYoD37FCc1N9h3ZKumhWUAdy25e/c4TuEJ1AE
	5CVSlCU+FJ2CvHuSh3FA2sZVM7RQUQQDc1I5RNfEvVKZj0XfJVdDDIJkjET0BC8JFlzt1M
	Nsrr7uNxkGWDsep4xXKUmv11cq4tOdI=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775970545; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=A+lKJqazM8LW8l5eDAV7P3Okj11yXCHcbfJhYHmZx20=;
	b=V8OQnKBnoKZ9yFB0xYvOhcgI9Igfry+UKFYoD37FCc1N9h3ZKumhWUAdy25e/c4TuEJ1AE
	5CVSlCU+FJ2CvHuSh3FA2sZVM7RQUQQDc1I5RNfEvVKZj0XfJVdDDIJkjET0BC8JFlzt1M
	Nsrr7uNxkGWDsep4xXKUmv11cq4tOdI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4961E4A756
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DDQBOe8o22k7AwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:03 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: check/lowmem: fix false alerts on
Date: Sun, 12 Apr 2026 14:38:42 +0930
Message-ID: <cover.1775970499.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
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
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

The lowmem mode check doesn't recognize the new EXTENT_OWNER_REF key
type, thus it will always treat it as an unknown inline type and cause
false alerts.

Fix it by adding such types to lowmem check.

The first patch is to fix a format string error during the add of inline
backref sequence output, which breaks the indent.

The second patch is the real fix for lowmem btrfs check on squota
feature.

The last one is a new test case for fsck on squota.

Qu Wenruo (3):
  btrfs-progs: print-tree: fix the format string for
    EXTENT_OWNER_REF_KEY
  btrfs-progs: check/lowmem: fix false alerts about EXTENT_OWNER
  btrfs-progs: fsck-tests: add a new test case for squota lowmem false
    alerts

 check/mode-lowmem.c                 |  7 +++++++
 kernel-shared/print-tree.c          |  2 +-
 tests/fsck-tests/073-squota/test.sh | 31 +++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 1 deletion(-)
 create mode 100755 tests/fsck-tests/073-squota/test.sh

--
2.53.0

