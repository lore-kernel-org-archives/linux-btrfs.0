Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928AC48D879
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791870106; cv=none; b=bSRGlW0EFxrv1uYTP8NrZMjqPTkXDCq4newg+iVO+vpJkSgK7lLRezES9EqSwfH8qlJgAjV2yQPdY/1AV3zP/x70w1FNnqKMTDNwnBI19qFxi5GkI3Qk4QwzPzIPymXiqgn/Bajx5jKnJSualbS4vAqD/9IpjEhGdZLJ++Nw4SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791870106; c=relaxed/simple;
	bh=yyYLpKdLU59pHxTU46451KuA3jaSw2AWqaqmzMp9M3Q=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=TL4izgF/WkdX2GGVB9vEj2E2EHa26HG/2w01RbYOHUINB8lwp4q5nt0qfO7wmgRKY2O61JwuwT8LR2zbpeQXbmLcNqupCfrH0PhntqkIup9GhyOhHoi5v4uJ19r4dN/5vCkAUco6LtwPpvm70Aoon3GmLVA6/rHn7D54PsX6xmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=EQEMMrDh; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=EQEMMrDh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="EQEMMrDh";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="EQEMMrDh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 130C9223E6
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791870102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=FSjKjIDyaUCLu7hUf3tj9VS3cNh8xz/jsYUzhQmjyEs=;
	b=EQEMMrDh+TuqS6dooopz2ZQx3vXIaDPI1SPrK0UF+2ie+mJ3KbZf+CpfuUYrmR1yJOZbcF
	zX+bV1dYgsRiEcrsv6HGYVnD3U0Yq+/b9BjonIL4QGRbq22OrjMPFV+hw7w0+PctIdixxy
	+k4B0zq1Ce+guf8bfc0MlVys60Ef1cE=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791870102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=FSjKjIDyaUCLu7hUf3tj9VS3cNh8xz/jsYUzhQmjyEs=;
	b=EQEMMrDh+TuqS6dooopz2ZQx3vXIaDPI1SPrK0UF+2ie+mJ3KbZf+CpfuUYrmR1yJOZbcF
	zX+bV1dYgsRiEcrsv6HGYVnD3U0Yq+/b9BjonIL4QGRbq22OrjMPFV+hw7w0+PctIdixxy
	+k4B0zq1Ce+guf8bfc0MlVys60Ef1cE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EBF0D13460
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 78ziEpTEzWq8bgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: further cleanup on dirty_cowonly_roots and switch_commits
Date: Tue, 13 Oct 2026 16:11:16 +1030
Message-ID: <cover.1791869895.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

[CHANGELOG]
v2:
- Add a patch to release qgroup swapped blocks during btrfs_put_root()
  This is addressing a real but rare memory leak.

- Replace the btrfs_extent_io_tree_release() with an ASSERT()
  As cowonly roots should never have dirty_log_pages populated.
  That is only utilized by log trees, and log trees are already poperly
  cleaned up in btrfs_drop_all_logs()

- Remove the btrfs_qgroup_clean_swapped_blocks() call in
  btrfs_free_fs_roots()
  As we have a dedicated cleanup during btrfs_put_root(), no need to do
  it inside btrfs_free_fs_roots()

Sashiko mentioned that dirty_cowonly_roots can still be non-empty if a
transaction aborts during commit_cowonly_roots().

However it should not cause any problem, as after a transaction is
aborted, no one will ever touch dirty_cowonly_roots.
So even if it has some dangling pointers, as long as no one is reading
it, it's completely fine.

Furthermore, dirty_cowonly_roots contains roots that are not subvolume
nor log trees, thus they should not have swapped qgroup blocks nor
dirty_log_pages. This means no memory leak from those two members
either.

But we're still depending on such quirky behavior, and it's only going
to cause more false alerts from various LLMs, e.g. Sashiko is already
reporting problems on this.

This series address all those minor problems by:

- Remove quota_root from dirty_cowonly_roots during
  btrfs_quota_disable()
  This prepares for the final patch as we're adding a reader for
  dirty_cowonly_roots during unmount.

- Cleanup qgroup swapped blocks during btrfs_put_root()
  This is to address a real possible memory leak, that some dirty
  subvolumes can have qgroup swapped blocks, and that can leak memory
  if not properly handled.

- Cleanup dirty_cowonly_roots during btrfs_free_fs_roots()
  This to remove the quirky dirty_cowonly_roots handling, and relies on
  explicit removal during unmount.

  Also add a new ASSERT() to make sure that roots linked into
  dirty_cowonly_roots() has no dirty_log_pages.


*** BLURB HERE ***

Qu Wenruo (3):
  btrfs: always remove quota_root from dirty_cowonly_roots
  btrfs: cleanup qgroup swapped blocks at root release
  btrfs: cleanup dirty_cowonly_roots during btrfs_free_fs_roots()

 fs/btrfs/disk-io.c | 20 ++++++++++++++++++++
 fs/btrfs/qgroup.c  | 10 ++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

-- 
2.56.0

