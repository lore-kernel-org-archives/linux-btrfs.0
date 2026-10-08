Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C323D4119
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 21:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791495917; cv=none; b=jDREX6vrBvg9QTDH22OwgOZsvzC1wlDHlT+hFFbj05H6ontIp8HgMADqu4idB6ofZlrv6uPx3XQJewI12TrOji5+hoTlVfIEtCHHdjyI/DTPSOJvsHaWJA64W+XB/ABipEGSuyyVr3YOYcrun/ujomgB/8tJ8/D9aNtvN/t9E5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791495917; c=relaxed/simple;
	bh=V3Pa1vWu6q3wl1gkGfF8Rs1rAvYGLcfGVfXxKkjFR8w=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=P+hCAxMXviNJeiPTFB+Uc3ogHa5ct1WuFje0BgmgFdpgKgb4atljia8XqgmJfruJAX1kDoHfEJrZys7mcArFN0WvSCCTRNVvOT/c7tf/kaZlqZBTr6uHoA2yRFfcnFE7+EpHeACFPGGMuZDbtrqguKlreobtBHr0KUjNB5Sb/hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 11D5C1F7E3
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 21:45:14 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA75E13354
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 21:45:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wNpSEegOyGpBFQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 08 Oct 2026 21:45:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/3] btrfs: fix a UAF where btrfs_root::dirty_list is freed but still referred
Date: Fri,  9 Oct 2026 08:14:47 +1030
Message-ID: <cover.1791495862.git.wqu@suse.com>
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
X-Spamd-Bar: /
X-Rspamd-Queue-Id: 11D5C1F7E3
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: 0.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [0.00 / 50.00]

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

The last one is the final UAF fix for the bug reported by syzbot, which
is from Yalagada.
The commit message is changed as it requires the previous two patches.

Qu Wenruo (2):
  btrfs: protect dirty_cowonly_roots, switch_commits and
    root->dirty_list
  btrfs: prevent use-after-free in btrfs_transaction::switch_commits

Yalagada Pavan Kumar (1):
  btrfs: fix use-after-free on quota enable allocation failure

 fs/btrfs/disk-io.c     | 10 ++++++++++
 fs/btrfs/qgroup.c      |  7 +++++++
 fs/btrfs/transaction.c | 30 ++++++++++++++++++++++++++----
 3 files changed, 43 insertions(+), 4 deletions(-)

-- 
2.55.0

