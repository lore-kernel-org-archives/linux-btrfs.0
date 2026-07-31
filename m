Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D0023393A
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 00:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785458735; cv=none; b=qTNtKJfC0WUIhmeVcV5tlmn3ldjqrZ5N3/KeeEF3klRCVMhQF/9iSq5lsMsjKTHaYgC2JJjnM1qvQl1OXTsJS2FppUXA/TdlUnDm48T2ymTskHgjwtV3XSnA48YY+yjKRrauygs9iom/8eA6+4BnwHgD+n3HYkKAE34fbk6Qc4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785458735; c=relaxed/simple;
	bh=X3sy3qT460iKj9BOeANEaeTsgdCUZmIJ5gk6jv4+Tdk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoUnDAqlZQmxy83Wtb/pMFdsphWsoJpp3A5pQxL+q77+PiaLMnrz7bFFslXB53uHTgLGzYxXOWp5nPW8mPbIQsfdtPpBl+P4FSsp9vyjIoORCIqP+QtxHYVaqOFDBPYAts+gbsUz7/Vf/BGzmZgfTsd0h1T0op/A5QYjpjw5d2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=MGUfV7vP; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OC/pOvfD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MGUfV7vP";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OC/pOvfD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 64B077DC83
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 00:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785458723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=En3CNgSpmePXklCYCxza+rn/cMUFdRR/nVICMtzMBGk=;
	b=MGUfV7vPatwTzdp8ik/zNYI5T/ACFG3ElM9NlUCSpABr7jJ7Cw2jfoh5QdvIbzLaUcVGMi
	bEXLGqD6v7zHS4F6oAyb5PqFcsDddxNEG/X4Qrr+IjwxpL8n6kklFCBxMEQceYg6BuGH1O
	/3G8VUp8JznvKsY2YsmUr7q3IMyWgWc=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785458719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=En3CNgSpmePXklCYCxza+rn/cMUFdRR/nVICMtzMBGk=;
	b=OC/pOvfDl6vXQwMqgmwtKWxVYj867NdXzJ2KWf9mmEiX0K1AAGpTE1BkbSi0YNQdB0R2ep
	/h4y1OykwiTThNOa4EKG88izqifXgNumsRsf5nGCSH/wRieFw/rGkQFhnYDCyEqwo7nUfA
	vSY8chVTQO8yKmEOEsasfl2rp9CgxAs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 64457779C6
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 00:45:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OItpBR7wa2qCZgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 00:45:18 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: initialize inode mapping flags for cached inodes
Date: Fri, 31 Jul 2026 10:14:49 +0930
Message-ID: <8492f6ffce48e46865c9c0b014774608c74840c0.1785457950.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785457950.git.wqu@suse.com>
References: <cover.1785457950.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

[BUG]
When running generic/795 with 8K block size, 4K page size, the test
always fails, triggering some ASSERT()s related to folio size:

 795 (241074): drop_caches: 3
 assertion failed: IS_ALIGNED(start, blocksize) && IS_ALIGNED(end + 1, blocksize), in extent_io.c:1404 (blocksize=8192 root=262 ino=258 start=16826368 end=16830463 mapping min order=0)
 ------------[ cut here ]------------
 kernel BUG at extent_io.c:1404!
 Oops: invalid opcode: 0000 [#1] SMP
 CPU: 8 UID: 0 PID: 241105 Comm: fsstress Tainted: G           OE       7.2.0-rc5-custom+ #442 PREEMPT(full)  f4bfb352566f3949f29c233ce6f735050a03b245
 Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
 RIP: 0010:assert_folio_range.cold+0x3d/0x3f [btrfs]
 Call Trace:
  <TASK>
  btrfs_read_folio+0x9e/0x170 [btrfs 4cd1dd93b341b8ef766643f9512f4a86259567a3]
  prepare_one_folio.constprop.0+0x104/0x2a0 [btrfs 4cd1dd93b341b8ef766643f9512f4a86259567a3]
  btrfs_buffered_write+0x285/0xa50 [btrfs 4cd1dd93b341b8ef766643f9512f4a86259567a3]
  btrfs_do_write_iter+0x1aa/0x210 [btrfs 4cd1dd93b341b8ef766643f9512f4a86259567a3]
  iter_file_splice_write+0x31a/0x540
  direct_splice_actor+0x53/0x170
  splice_direct_to_actor+0xe9/0x240
  do_splice_direct+0x76/0xb0
  vfs_copy_file_range+0x1fd/0x630
  __x64_sys_copy_file_range+0xf9/0x220
  do_syscall_64+0xe1/0x790
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
  </TASK>
 ---[ end trace 0000000000000000 ]---

The ASSERT() itself is added by a later patch.
The crash is triggered with that new debug patch, and without this fix.

[CAUSE]
In the above case, the start 16826368 is properly 8K aligned, but the
end (16830463 + 1) is not 8K aligned.
Furthermore the mapping's minimal folio order is 0, not the expected 1
for 8K block size with 4K page size.

So this means some inodes do not have btrfs_set_inode_mapping_order()
called on it.

The missing btrfs_set_inode_mapping_order() call happens for cached
inodes, through the following events:

- btrfs_create_new_inode() called for inode X
  Which properly sets minimal folio order for the vfs inode.

- btrfs_update_inode() called for inode X
  Which calls btrfs_delayed_update_inode() to create a delayed_node
  into root->delayed_nodes xarray.

- Drop cache/memory pressure, evicting in-memory inode X
  Which evicted the inode X, but delayed_node is still in
  root->delayed_nodes for future reuse.

- btrfs_iget() for inode X called again

  btrfs_iget()
  |- btrfs_iget_locked()
  |  |- iget5_locked_rcu()
  |     Which creates a new vfs_inode for btrfs, whose mapping still
  |     has the minimal order as 0.
  |
  |- btrfs_read_locked_inode()
     |- btrfs_fill_inode()
     |  |- btrfs_get_delayed_node()
     |     Which found out the previous node, and use that delayed
     |     node to initialize the new inode.
     |
     |- filled = true;
     |- if (filled) goto cache_index;
        Which skips the btrfs_update_inode_mapping_flags() and
	btrfs_set_inode_mapping_order() calls.
	So the inode still has minimal folio order set as 0, not
	the required 1.

Thus later page cache read will get a folio whose size is smaller than
block size, as the mapping has its minimal folio order set as 0 not 1,
then trigger the ASSERT().

[FIX]
Move the btrfs_update_inode_mapping_flags() and
btrfs_set_inode_mapping_order() calls under cache_index label,
so that the mapping flags and minimal folio order is always set
no matter if we have a cached inode.

Assisted-by: LLM (analysis)
Fixes: ecde48a1a6b3 ("btrfs: expose per-inode stable writes flag")
Fixes: cc38d178ff33 ("btrfs: enable large data folio support under CONFIG_BTRFS_EXPERIMENTAL")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 78143e241ca4..fafd7a74eaa7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4107,10 +4107,11 @@ static int btrfs_read_locked_inode(struct btrfs_inode *inode, struct btrfs_path
 
 	btrfs_inode_split_flags(btrfs_inode_flags(leaf, inode_item),
 				&inode->flags, &inode->ro_flags);
+
+cache_index:
 	btrfs_update_inode_mapping_flags(inode);
 	btrfs_set_inode_mapping_order(inode);
 
-cache_index:
 	/*
 	 * If we were modified in the current generation and evicted from memory
 	 * and then re-read we need to do a full sync since we don't have any
-- 
2.54.0

