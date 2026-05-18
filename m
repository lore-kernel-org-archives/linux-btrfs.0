Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A543229B766
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779099681; cv=none; b=kn497AJN4h9dlPLoe6f6yo/WVNqeuLzdNR5/f0CDE80NMxBs+4IdbULZ/I/LuUZb/7oaL66UezO3EmlZ/z9NlGBwED+5CHY0IxAx26/0qEK+MDYnD08mKr+f6g/un+FgpqB5KfZAxOsG0HJ5gIT3Vo3LYWrAriDcdtELL/DEOMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779099681; c=relaxed/simple;
	bh=PavrTncA5t6L34Z59Qf9dssU5lctjM1JkfQx0OaLYIQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=AL+g4LOkxAnjKZDhP+okPDVBrq3HoWeLWuTE61N05L7E+S0tZE2jb6Qc5OLI74BAzbP/W0s0VA9oXYPD/Zne+8kICAphRMBhxpXZ2c/p6YsMI6vUxW4z2+kr7gnD4TsZlBAMnsOI7pJsFPzIPhosYyNsC5E9aCnf640ssJnhJdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=g6ucwKF4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=g6ucwKF4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="g6ucwKF4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="g6ucwKF4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 05A3C67056
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779099678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ZlqOnh3kGRKwC/mRaEWnqQebFYNR3Yk2UeG6Zq9MQG0=;
	b=g6ucwKF4AYTpLFInjbPvg8NRc0DO1u2Lt+8ng2wkhTS+FUC6YPU3OgCSpNcPUH3Isfa2HV
	qwTfkYAIZTv8HEJ69a6e1ceNwzdDKO4H9GcFjqYT1HaXrf81/OV0UsWSRO6G/ue3xYux4E
	LmO1v96MIXSq5lWvRLDZ4pEl+Coz3pY=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779099678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ZlqOnh3kGRKwC/mRaEWnqQebFYNR3Yk2UeG6Zq9MQG0=;
	b=g6ucwKF4AYTpLFInjbPvg8NRc0DO1u2Lt+8ng2wkhTS+FUC6YPU3OgCSpNcPUH3Isfa2HV
	qwTfkYAIZTv8HEJ69a6e1ceNwzdDKO4H9GcFjqYT1HaXrf81/OV0UsWSRO6G/ue3xYux4E
	LmO1v96MIXSq5lWvRLDZ4pEl+Coz3pY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42C77593A8
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id i/TgAR3oCmorFwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:17 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] mkfs/rootdir: refactor and enhancements, part 1
Date: Mon, 18 May 2026 19:50:56 +0930
Message-ID: <cover.1779099356.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
X-Spam-Score: -2.80

We have "--reflink" option introduced for mkfs for a while, and recently
the new get_csums ioctl is also introduced, making
add_file_item_extent() much larger and harder to maintain.

I have some concerns about the larger and larger
add_file_item_extent(), and will address some of them in the series:

- Minor mismatches on some parameter/variable names
  Use more commonly used names to replace them.

- Duplicated partial block handling
  Which not only makes add_file_item_extent() larger but also harder to
  read/maintain.

  To remove those duplicated partial block handling, the idea is to
  shrink the range to block boundary when possible.
  If we can not shrink the range anymore, disable reflink/get_csums.

  So that we do not need to handle partial blocks for reflink/get_csums.
  All the duplicated code can be removed.

- No test case for --reflink nor the latest get_csums option
  A new test case, to verify all above mentioned cases.

Qu Wenruo (3):
  btrfs-progs: rename logical bytenr parameter for
    add_file_item_extent()
  btrfs: mkfs/rootdir: refactor the last block handling
  btrfs-progs: mkfs-tests: add a new one for '--reflink' option

 kernel-shared/extent_io.c                    |  10 +-
 mkfs/rootdir.c                               | 175 ++++++++-----------
 tests/mkfs-tests/043-rootdir-reflink/test.sh |  57 ++++++
 3 files changed, 135 insertions(+), 107 deletions(-)
 create mode 100755 tests/mkfs-tests/043-rootdir-reflink/test.sh

--
2.54.0

