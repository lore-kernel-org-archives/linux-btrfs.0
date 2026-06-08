Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BAA192D97
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 03:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780887770; cv=none; b=WjkUs6G3ybpc7WGFlUS9MFZ9Ar4qY4lzhAlRqUjUhC0ToYlZY0K2RLAn5am53ZE6uFh+7EoyopFk+VGJRz01VWHTxD8I1e78DBW5+hES0O0mHMk8cDk8eMCXDKlX/+WkKIS6ykG4+oyNQxRsnpk7O52YpJNwlYpzXAPdfXy7lIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780887770; c=relaxed/simple;
	bh=ASmEpEteE7rElTQYQnod3RC/TvfJhbj2egvBHHcG6Jw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=FhRAqX9t00gCVmEFfZs6NnCxpJW3DcpBzxSzukkQKN810jIjNSwaQ6HVL+2KBsnGOJw+SIZtE/WI6GCXoeIeGSz8SIT3JJzyTYYvYtGf7xlFSWA5PGIlSoSvVV8MRxYAIeJM4uGsa9yRCG5NilZxXibsnGAA1EBcVpPzmLmg1wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=O07W0CS7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=O07W0CS7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="O07W0CS7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="O07W0CS7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9FAB375C85
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 03:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780887760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7ad7DeyGZpVwF/oHhkmuxTD3g+1yDjxUuQze5YtLpbc=;
	b=O07W0CS7PdRnCM9zZ9/F671ezHvpLze5S5MmmS6xhNY/7WMdrQGqsyCQUvB0IZ70wHIVxh
	67AIUWJ+HinwymA6lTCl2stRtfKoAU8iVPOZIpUwQOIRwZ7nGub5AqS1Ge4NXwtUuEXEDd
	gXxChTEvakYkRy3leuquoL4aJKqkMNk=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780887760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7ad7DeyGZpVwF/oHhkmuxTD3g+1yDjxUuQze5YtLpbc=;
	b=O07W0CS7PdRnCM9zZ9/F671ezHvpLze5S5MmmS6xhNY/7WMdrQGqsyCQUvB0IZ70wHIVxh
	67AIUWJ+HinwymA6lTCl2stRtfKoAU8iVPOZIpUwQOIRwZ7nGub5AqS1Ge4NXwtUuEXEDd
	gXxChTEvakYkRy3leuquoL4aJKqkMNk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A1850779A7
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 03:02:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id x/j6E88wJmpaeAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 08 Jun 2026 03:02:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: minor fixes and cleanups on direct IO path
Date: Mon,  8 Jun 2026 12:32:14 +0930
Message-ID: <cover.1780873489.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
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
X-Spam-Level: 
X-Spam-Score: -2.80

[CHANGELOG]
v2:
- Drop the first 2 patches
  The problem with APPEND NOWAIT direct writes needs more consideration.
  If short writes happened for APPEND NOWAIT write, there are more
  factors to consider.

  Firstly we should return -EGAIN so that the caller can retry in a
  blocking way.

  Secondly we should fully revert what has been written so that isize is
  not increased.


  For the OE conflicts I have not yet hit with upstream, so it should be
  something wrong in my previous direct locking changes.

There are several small problems inside the direct IO code:

- Duplicated btrfs_dio_data::submitted
  The iomap_end() callback has @written parameter which provides the
  same value.

  Fixed in the third patch.

- Badly structured btrfs_dio_iomap_end()
  Refactored in the last patch.

Qu Wenruo (2):
  btrfs: remove btrfs_dio_data::submitted
  btrfs: refactor btrfs_dio_iomap_end()

 fs/btrfs/direct-io.c | 131 ++++++++++++++++++++++---------------------
 1 file changed, 66 insertions(+), 65 deletions(-)

-- 
2.54.0

