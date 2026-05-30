Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC4E30E85C
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 03:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780112084; cv=none; b=Wb5Sl+l4Pjmv/EZpKwQ5sOQgCZo8vNnzn0omfnY1zaJcaItHhyfkGRbDOmx4/VwS5WkAfGcNAh7QvUC8kJAJlr0cdozmST6vqHvpa3xNvmmi2l6WJOQmjGL0ddBtBl+XbFXjeCs9KYTZKdTxaE5tkDde8B6oZ8yGmihEO+p+oyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780112084; c=relaxed/simple;
	bh=2n/SMWhMaC/6412FY7ktbFBtCbjeiMrsj3zy0Q/CC8g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=BuaHzo107LBzp4ACLwmR7kfRdDf8jkhVZeqSth0+ZmhBRXKfVPG8HjHXk55laoR32TVrTgQMeiQchs1SYV+s1RZ+cxciK4cis5RAlEqGLVMvEo5AgStV8EIx6xbCQWkWfCJtFnyI4QApOitwJLUus/+RhCIQVVgS7TrxdpJq/3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DSTjrg9c; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DSTjrg9c; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DSTjrg9c";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DSTjrg9c"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A95CA6745A
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 03:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780112081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=bLwKk8xqwJxpeUH4ZWfCVy2mqM9z/qQewiFGEUDMC0w=;
	b=DSTjrg9cq8VoXnyYsoMDv4IMReM3fr6OmiYl1pK4jMWXunxcQmsLxQVAdH/DGp0cN5rUja
	D35Xpl9EnHKGBO9KkzB6krKm4O/uLjH+7FBW6saf87OhyjA2QjQ7uiJ1Of7dlvGtXEijd2
	WGzbxIVZiaYrJtBr91fGSs3ZdbkmeFk=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780112081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=bLwKk8xqwJxpeUH4ZWfCVy2mqM9z/qQewiFGEUDMC0w=;
	b=DSTjrg9cq8VoXnyYsoMDv4IMReM3fr6OmiYl1pK4jMWXunxcQmsLxQVAdH/DGp0cN5rUja
	D35Xpl9EnHKGBO9KkzB6krKm4O/uLjH+7FBW6saf87OhyjA2QjQ7uiJ1Of7dlvGtXEijd2
	WGzbxIVZiaYrJtBr91fGSs3ZdbkmeFk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E5D2D779A7
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 03:34:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w+2UKdBaGmorcgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 03:34:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: fix generic/362 failures with nodatasum
Date: Sat, 30 May 2026 13:04:16 +0930
Message-ID: <cover.1780112003.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_NONE(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]

Changelog
v2:
- Add a new patch to allow retry after no byte is submitted for direct
  write

- Add a more clean callchain to explain why __iomap_dio_rw() doesn't
  return -EFAULT/-ENOTBLK directly.

- Add a code comment explaining the OE split sitation and why we can
  truncate all the remaining OE after a short write

- Fix the isize revert when part of the direct write succeeded

- Dig deeper into the original cause
  Which is very old, dates back to v5.15 LTS at least, and add a reason
  why no specific fixes tag is provided.

The test case generic/362 is pretty well hidden by several factors:

- "nodatasum" will not take effect due to the bad design of the test
  case
  If the target file already exists, the test case will reuse it,
  meanwhile "nodatasum" mount option only affects new files, meaning
  if the test case is executed before with data checksum, it will never
  go through the nodatasum path.

  There is already an update on the test case to make the failure
  reliably reproducible:
  https://lore.kernel.org/linux-btrfs/20260528111659.87113-1-wqu@suse.com/

- Btrfs always falls back to buffered IO if the inode has csum
  Thus we do not exercise the zero-copy path, hide the failure for the
  default mount option.

With that said, the test case failure needs to be fixed, and there are
several bugs in the direct write path:

- Treat any short write as an error
  This is especially common as we have disabled page faulting for
  reading from the @from iov_iter.

  This is fixed by the first patch.

- No isize rollback after a short write
  The isize is increased at btrfs_get_blocks_direct_write() but when a
  short write happened, the isize is not propoerly rolledback, causing
  later buffered fallback to write at the new isize.

  This is fixed by the second patch.

- No page fault-in retry after a zero-submitted short write
  Unlike the previous two, this is only a minor problem which reduces
  the chance to do zero-copy direct IO.

  This is fixed by the third patch.

Qu Wenruo (3):
  btrfs: fix false IO failure after falling back to buffered write
  btrfs: fix incorrect buffered IO fallback for append direct writes
  btrfs: retry faulting in the pages after a zero sized short direct
    write

 fs/btrfs/direct-io.c    | 44 ++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/inode.c        |  6 +-----
 fs/btrfs/ordered-data.c | 12 +++++++++++
 fs/btrfs/ordered-data.h |  2 ++
 4 files changed, 54 insertions(+), 10 deletions(-)

-- 
2.54.0

