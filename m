Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64B232F774
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 03:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772163260; cv=none; b=GOoY96uq1FiQK4U2xJdvoAInSDwkVuUj8xCotmr7EIYH1t7NNSUz2gzZKM632YT60u2gpVPI84lavMCCvM5/tidFFt8j71cRCGxkh9oFO+Mxe1AtVwbvf2W8GnzcMUEJiFGIqzQMFb7J7Ivzu1VYdNw+Yw/Rpn7vK8TFoW7GwFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772163260; c=relaxed/simple;
	bh=BbAiRHikspyezYA5Lwt3Pffx5Uyt5GXkdSYJoWV+7fk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWFhR4H4i2MNicYGytPwQMnX+pPRS0Wvgh8w636cy6xOqXoLKtlWJg8owHrkpZU48rNTn8kj16kMsVaQ/TAZ0djczraFp1uJkbVmrQZhVmuKhJzT/ecc7jPTf1glhwVAHfiffFnoQ5pvycDL+LsZDmK+9rL2ccQwopKBB8ogrj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nIJjxKi3; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nIJjxKi3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nIJjxKi3";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nIJjxKi3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 299295CEAA
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 03:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772163257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ICaBzNi0eKi00rCEOHMdiXLHUHR9VwsrwNblifrr84=;
	b=nIJjxKi3sPX3EiqAmHzlPfaacbhoNCcWWBtt4TzgiUHXSuk7RMU0BppiNzt2RqjsEGXyMV
	MKo2+3FojCYD2xyDwB6CBeOwzBBoXkRW8ZbAap57Q/TfaVu39un9I9MOm/Ha9sadXojTzR
	8nAAQ6ORcVqnhkSfapgi36wAqCQwYZk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=nIJjxKi3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772163257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ICaBzNi0eKi00rCEOHMdiXLHUHR9VwsrwNblifrr84=;
	b=nIJjxKi3sPX3EiqAmHzlPfaacbhoNCcWWBtt4TzgiUHXSuk7RMU0BppiNzt2RqjsEGXyMV
	MKo2+3FojCYD2xyDwB6CBeOwzBBoXkRW8ZbAap57Q/TfaVu39un9I9MOm/Ha9sadXojTzR
	8nAAQ6ORcVqnhkSfapgi36wAqCQwYZk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5E0AE3EA69
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 03:34:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mGjyB7gQoWmcNAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 03:34:16 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/4] btrfs: move larger data folios out of experimental features
Date: Fri, 27 Feb 2026 14:03:45 +1030
Message-ID: <0d8fe02f58ccbc0c53714ea45b0a4303f2ee8206.1772162871.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772162871.git.wqu@suse.com>
References: <cover.1772162871.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 299295CEAA

This feature is introduced in v6.17 under experimental, and we had
several small bugs related or exposed by that feature:

 e9e3b22ddfa7 ("btrfs: fix beyond-EOF write handling")
 18de34daa7c6 ("btrfs: truncate ordered extent when skipping writeback past i_size")

Otherwise the feature is being frequently tested by btrfs developers.

The latest fix only arrived in v6.19, after two releases I think it's time
to move this feature out of experimental.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/Kconfig       | 2 +-
 fs/btrfs/btrfs_inode.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 5e75438e0b73..d0451cf93849 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -110,7 +110,7 @@ config BTRFS_EXPERIMENTAL
 
 	  - extent tree v2 - complex rework of extent tracking
 
-	  - large folio and block size (> page size) support
+	  - large block size (> page size) support
 
 	  - asynchronous checksum generation for data writes
 
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 55c272fe5d92..01b147fa9801 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -532,11 +532,9 @@ static inline void btrfs_set_inode_mapping_order(struct btrfs_inode *inode)
 	ASSERT(is_data_inode(inode));
 
 	/* We only allow BITS_PER_LONGS blocks for each bitmap. */
-#ifdef CONFIG_BTRFS_EXPERIMENTAL
 	mapping_set_folio_order_range(inode->vfs_inode.i_mapping,
 				      inode->root->fs_info->block_min_order,
 				      inode->root->fs_info->block_max_order);
-#endif
 }
 
 void btrfs_calculate_block_csum_folio(struct btrfs_fs_info *fs_info,
-- 
2.53.0

