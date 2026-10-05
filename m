Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0ECA424D6D
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 09:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791190905; cv=none; b=uebfyptpSAmHEKZiqTCHVZ0yxxv03jDxgfx1in6EPa+DBZvulfz6US18tKq2G6JokZoyytneP4J5KSaEQt9yUfvzR/peDf2bUmhjDtNgRdmW92881C3vbBcllG7OEi0mZe25UvLwG7e24MkgQzra2+YzDGFR9bMDp5U9EvkIP/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791190905; c=relaxed/simple;
	bh=13hR/Wd3r5A8Gr0ZyThfIt3ZCQwqhMsjGJoln43utVk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=MJVGojWGcq2wysrYftSYcLf9D8hgU0JMcO0uZf6ExHY4CPKA7uzzoZVqmBsR5Xp4fa8O1mdg01FU9cZKf3LbXz8eS8yIzGVtLRclCHCx4yyFp2bpMyYe4rZmMo6Pa1LZX3XCVzw2m+qqU1oYjv3AX8GUeGxCsZLk3/RKtrOuOLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UI7R6O4j; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZyyS+Tsx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UI7R6O4j";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZyyS+Tsx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 850841F797
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 09:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791190897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uBaRQGwwYh/FxbJ61/p9RG7SNZfUFSOX04x9iUaloCo=;
	b=UI7R6O4jvWXoddKOJlGLMQ46eDJQQQGbpKnoGh10Gq0mHB8EldP68Y4INXW/ZaoqYzXsEM
	AQWLlyJfY1zlp9vysJaAt76GYucClA4fVhWLsMuZ+IVsbu4dPXxPaZfUTMRWJCeuZIEFG1
	Ighp7EpogNo7yhmfjvBMIKcEDcnMU7M=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ZyyS+Tsx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791190893; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uBaRQGwwYh/FxbJ61/p9RG7SNZfUFSOX04x9iUaloCo=;
	b=ZyyS+TsxYBNRrbdQUPSvhZThOMdDb7pf4Q8wsvAF5dqpq8MDN8aQP5evmzoHvIYHPZHKEE
	XiHM/QbX2OGKiLkV2OtQ+PybFv32XPxGcTCuNFN1K1MVVLa81gQz5pJsRULhsWo9yxgwLG
	4PssjY/U0L7PYQ+rVt2PCT+ztTkNS9s=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 61356139EA
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 09:01:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ngyMK2tnw2qpRwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2026 09:01:32 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs-progs: check: fix and refactor load_quota_info()
Date: Mon,  5 Oct 2026 19:31:09 +1030
Message-ID: <cover.1791190852.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 850841F797
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

The btrfs-check code of qgroup verification is pretty old, and there is
a long existing bug from day 1 that causes incorrect initial search
condition.

The first patch is to fix that bug.

Then the second one to reduce the memory usage of qgroup_count
structure.

The third one is to refactor load_quota_info() to follow the modern
standard and practice.

Finally add a test case as a regression test.

Qu Wenruo (4):
  btrfs-progs: check: fix the inverted condition to load qgroups
  btrfs-progs: check: remove unused qgroup_count::key
  btrfs-progs: check: refactor load_quota_info()
  btrfs-progs: fsck-tests: add a new test case for qgroup tree check

 check/qgroup-verify.c                         | 155 +++++++++---------
 tests/fsck-tests/076-large-quota-tree/test.sh |  28 ++++
 2 files changed, 103 insertions(+), 80 deletions(-)
 create mode 100644 tests/fsck-tests/076-large-quota-tree/test.sh

--
2.55.0

