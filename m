Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793860664;
	b=0CPRAA5qZPY17N6kybxwmqjU2JDHE/B+93o701EQ5WFmpm6UiavVyU45fhcz9OW6dxJj
	 Jh2yeDNz27Dzv4xt3hpGPLKBsgQOOy5Ch/lKN8t6W7XVQ1+5FqjWBIosl/xSXDImiQMIG
	 XRtRlRkr8Qunf3hgwaIlCoLRD2HkFQ9VgQ++veBxPcJLPgwaKHo7NRyMrJ7jP7yCFF9NS
	 oGLYeE4cmJF3KhTJRkv52VmY4WsnUgcHzpMvkKGY8ybTgQ5oh+yiNb/KNHF4IeKs5DYhK
	 6hsl6oYvp1x1yFyP3JzXDUH6UyKKw8jgLwRbFSYL64Ekx7pNl8pOvOKxKzhQK8t0/1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860664;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=leUnIdQhBiGQYGv68XizKY6btC5lCb8k4V0Hi/tfF/I=;
	b=ueAl/nC6aT0VVZbd2pt7du5rlQ/Kg4SSi1TDgBqqrH8l54d0yZ1xRLFf6/NJwN3vJ7KZ
	 7vMISXwwNwqvjtnvjv+ckGC3A/uUdb0nbyQgjyjr+HC+sVnp2glhb31DJu/KayVPwkF+M
	 qMVkqIHCsgSCv+v6K6QKtMT2jv2DasAYjtAoAcH2YpLe09siamgLaTjiTnP+QKx3CK8KG
	 xjGXvQl5XWhDamLzncySjP9B7ZwNehw4xhy+/UOxMN1cdsErNaYFhL/WNvib6ajOpkKjb
	 0NDZcOkezEnWWTwYy1xhdNKFU0s3ZEWzK3pj1V2sHE5Oz1sznbWzivfOnsgqsNtALew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kYE5LVQ9;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=AQKaYIZ5;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54E6606A31B
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 06:37:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A54E6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kYE5LVQ9;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=AQKaYIZ5
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9FD0121EDD;
	Thu,  5 Nov 2026 06:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793860662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=leUnIdQhBiGQYGv68XizKY6btC5lCb8k4V0Hi/tfF/I=;
	b=kYE5LVQ9MjdPefQAUpXPgLn7LwiWbZce9V6t+5YsmyLJw/1u7t7fp8UiHOa8yXqBfTbcyV
	hXAIPq3/P0o1+v4JFWj+JJtlcb3jsrq6xEnC/Dg2J/Xd1BOki4edcTUu1ud7LotxsJ1JEo
	aPo08SgxXRoH2jSmBFifZFG1qRSkFCQ=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=AQKaYIZ5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793860660; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=leUnIdQhBiGQYGv68XizKY6btC5lCb8k4V0Hi/tfF/I=;
	b=AQKaYIZ5VGZKwZdhRiHUb77YkqZpOr73CLLmexOvX6syxVLFUTT29ztLdRmdq8mJsKYPJe
	4oTD1RCA6WRvKlqv9L0j7eke4RD89ALIl7Bxy07ZVKQawaMQHOFt3qIuC+BpMW6igB9EBV
	LAx/553haMxyj3zVu5RaWnVKD8CYWp0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 02D3E133F6;
	Thu,  5 Nov 2026 06:37:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OmvCEjIk7GpePwAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 05 Nov 2026 06:37:38 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?=E9=93=AE?= <fengaojigui88@gmail.com>
Subject: [PATCH] btrfs: make sure the eb debug info is before the WARN_ON_ONCE()
Date: Thu,  5 Nov 2026 17:07:16 +1030
Message-ID: <080655ad6734a27e70f3699abe97ae46d63f690c.1793860606.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-12.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 9FD0121EDD

Inside invalidate_and_check_btree_folios() if we found some unrelated
extent buffers, we trigger WARN_ON_ONCE() first, then output the extent
buffer info.

However for a lot of fuzzing setups, kernel.panic_on_warn is set, so
that WARN_ON_ONCE() will immediately cause a panic, skipping the important
eb debug info.

Change the order so that WARN_ON_ONCE() is only triggered after all eb
debug info is outputted.

Reported-by: 铮 <fengaojigui88@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAO-4RZ0mqFEU8z44B+biaMw5Ee4ogCjs80Uws9YY8LMV7J685w@mail.gmail.com/
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 35a43e7cb937..78865704b45d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3353,6 +3353,7 @@ static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
 {
 	unsigned long index = 0;
 	struct extent_buffer *eb;
+	bool found_err = false;
 	int ret;
 
 	ret = invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
@@ -3391,17 +3392,18 @@ static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
 		 * of the loop, one for the ownership in the buffer tree.
 		 */
 		if (unlikely(refs > 2 || extent_buffer_under_io(eb))) {
-			WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG));
 			btrfs_warn(fs_info,
 			"unable to release extent buffer %llu owner %llu gen %llu refs %u flags 0x%lx",
 				   eb->start, btrfs_header_owner(eb),
 				   btrfs_header_generation(eb),
 				   refs, eb->bflags);
+			found_err = true;
 		}
 		free_extent_buffer(eb);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
+	WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG) && found_err);
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 }
 
-- 
2.56.0

