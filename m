Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10CF3CB8FF
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 22:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791497642; cv=none; b=GvcL78Iz8XgGUfZg1/CMscpvFyML+1CoS7v4cgTsjnFDAALMUzzMObE/LWSyBskeHla+DR5yMQ7b4fmToSNKcOrx79J8rIJKcygQFwnoSIhaShGg97VnYohEuYkeu4/VUFMR/cPDGpKIUtEVkQDvgV2GwPJy2YPZnEyofNdRKWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791497642; c=relaxed/simple;
	bh=sr5ZThTGkbPUcZNbJ93m+vhuAlfcvAoaUqQIHYiIKAo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PRe6YB7XvkrfJny1FLPVNlVhQN5FjZ/Cq33bvFuChDiwocV3AA+A/BUSuQJdZ59tAGnJvUHobVps8QWp0TAtANQW46qQ0xb+KJMhtUs4FbkcWCjJsGFG7t8tXs07IjJJb8PAEecnPt91WZ5OmrWyKcr+YClrG9QdlKHcF0WJBoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D55671F7CE
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 22:13:59 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA45213354
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 22:13:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oyywBqYVyGrLMQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 08 Oct 2026 22:13:58 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/3] btrfs: fix a UAF where btrfs_root::dirty_list is freed but still referred
Date: Fri,  9 Oct 2026 08:43:37 +1030
Message-ID: <cover.1791497576.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spamd-Result: default: False [0.00 / 50.00]
X-Spam-Score: 0.00

[CHANGELOG]
v4:
- Also cleanup qgroup swapped blocks and dirty_log_pages
  Which are only released during switch_commit_roots().

v3:
- Use Yalagada's v2 fix as the final UAF fix
  The delayed list_del_init() call inside btrfs_put_root() is not
  safe as another racing ioctl can grab the quota root, extending
  its lifespan.

v2:
- Add extra patches to address Sashiko's comment
  * Make all root->dirty_list users to hold trans_lock
  * Release root->dirty_list from cur_trans->switch_commits during
    transaction cleanup

The first patch is to make lock consistent when accessing
btrfs_root::dirty_list, btrfs_fs_info::dirty_cowonly_roots and
btrfs_transaction::switch_commits.

Normally it's not a big deal as the existing lock-holding callers are
also holding a trans handle, thus they can not race with transaction
committing.
But the last commit will change the cleanup timing, and Sashiko is not
happy with that, so make it more consistent and shut Sashiko up.

The second patch is an existing bug exposed by Sashiko, which also
affects the last UAF fix.

The last one is the final UAF fix for the bug reported by syzbot.

Qu Wenruo (2):
  btrfs: protect dirty_cowonly_roots, switch_commits and
    root->dirty_list
  btrfs: prevent use-after-free in btrfs_transaction::switch_commits

Yalagada Pavan Kumar (1):
  btrfs: fix use-after-free on quota enable allocation failure

 fs/btrfs/disk-io.c     | 14 ++++++++++++++
 fs/btrfs/qgroup.c      |  7 +++++++
 fs/btrfs/transaction.c | 30 ++++++++++++++++++++++++++----
 3 files changed, 47 insertions(+), 4 deletions(-)

-- 
2.55.0

