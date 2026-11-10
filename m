Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794350029;
	b=27vbeP6gWb5opGWdoUfQ5NZ0qArljAzTmSGahEVPV6McPPtjtsx6uw2++77XWlxjYzwC
	 85yKjsRTy/ILzhvjlbbhtPgj/2eRxW7Mey2mPwjhe2lgcecQAxEfJpJSp36xrQgxZ5tDH
	 bYEkZ9xsmp7uZrlg/SrmhtQyI+/NA4LTfbtj91OuJ9NfR13n3XU7XjU5axbASQRgL6rpU
	 fWz/QPg8SbdrgcrgBNYW5YHUjOJSpecJwnGmdNtfYW03TnvapXg2n1zyEib8sMGyYhgn2
	 zJFT1DqwkdgqQBTHFyr95ALO6bSr59l84wi9qi8jinzHohmCocx3xm0zgk65qjAPT4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794350029;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=hSG0voxm6SxlYa8n6u+SXCsTBbZ+FvuLifXsEJouV5s=;
	b=tVY4gzz8RVzHXHZ+KTg8c481874PQwDdXHQUL3STBXEwHAs5QYAYK8htrZSGwy0r4Phb
	 SHHSKbkBf0OivDdK40EEtzUGrE1Ur2SD0R+MlHszP9YcUgFiU8VEJcDZDedbenNA69Eky
	 ArHPsv51u9t1pKs/A2FSnNCgSzSDpuM8vH7dbEII1Onm4xUrpx3Sy0VSoa1MXNCcYl1zC
	 90BkJK/LMq+vATjyxnW0zW9zErpN00KQWjAlrJtP0qCJ/UlS6WzGVh9lu7R9IHQ2uczAn
	 6p5r2S46e9petiaXVfXaQJoeCTVLDdF5iWHFuhrKFX4H0O/PFgm+yJtPLkN6lzoTJ+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pYr1xEAw;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pYr1xEAw;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303BA606A32D
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:33:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 303BA606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pYr1xEAw;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pYr1xEAw
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3C0441F8D4
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794350027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hSG0voxm6SxlYa8n6u+SXCsTBbZ+FvuLifXsEJouV5s=;
	b=pYr1xEAweT/oEkeJe/YmH4gWvqvgGIDpk24d16h13d/uzud6e+awsZeaJuP7iuB1QACafR
	tKEbnNMAyKy4wk/tzUWjFowHBJWSToMe0YleIZRgxG2OeYXhhxHiOoLcoYpPtU3mS6fI4L
	MEtwt5hhIkheUVvEy3l7INF9gc9QJcI=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=pYr1xEAw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794350027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hSG0voxm6SxlYa8n6u+SXCsTBbZ+FvuLifXsEJouV5s=;
	b=pYr1xEAweT/oEkeJe/YmH4gWvqvgGIDpk24d16h13d/uzud6e+awsZeaJuP7iuB1QACafR
	tKEbnNMAyKy4wk/tzUWjFowHBJWSToMe0YleIZRgxG2OeYXhhxHiOoLcoYpPtU3mS6fI4L
	MEtwt5hhIkheUVvEy3l7INF9gc9QJcI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C5D213693
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:33:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bA6vKceb82r5DgAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:33:45 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: mkfs: fix garbage in the QGROUP_LIMIT item
Date: Wed, 11 Nov 2026 09:03:24 +1030
Message-ID: <c844a8bbd3587a2ef63865d681087dd00fa563c1.1794349527.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794349527.git.wqu@suse.com>
References: <cover.1794349527.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3C0441F8D4
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.01

[BUG]
If using "-O quota" option of mkfs.btrfs, the resulted image will have
garbage in the QGROUP_LIMIT item:

 quota tree key (QUOTA_TREE ROOT_ITEM 0)
 leaf 30474240 items 3 free space 16088 generation 11 owner QUOTA_TREE
 leaf 30474240 flags 0x1(WRITTEN) backref revision 1
 	item 0 key (0 QGROUP_STATUS 0) itemoff 16243 itemsize 40
 		version 1 generation 11 flags ON scan 0
 	item 1 key (0 QGROUP_INFO 0/5) itemoff 16203 itemsize 40
 		generation 10
 		referenced 16384 referenced_compressed 16384
 		exclusive 16384 exclusive_compressed 16384
 	item 2 key (0 QGROUP_LIMIT 0/5) itemoff 16163 itemsize 40
 		flags 500000
 		max_referenced 8388608 max_exclusive 8954665512184738474
 		rsv_referenced 5153854573009882032 rsv_exclusive 3
                               ^^^^^^^^^^^^^^^^^^^

[CAUSE]
The QGROUP_INFO and QGROUP_LIMIT items are inserted using
btrfs_insert_empty_item(), which will not do any cleanup for the new
item, so it will reuse whatever is left in the tree block.

For QGROUP_INFO it's not a big deal as later repair_qgroups() will
update the item, but QGROUP_LIMIT garbage is left there.

[FIX]
Zero the newly inserted empty items for both QGROUP_INFO and
QGROUP_LIMIT.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index d61af04e055e..74b98fccf3f6 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -897,6 +897,9 @@ static int insert_qgroup_items(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_empty_item(trans, quota_root, &path, &key,
 				      sizeof(struct btrfs_qgroup_info_item));
+	memset_extent_buffer(path.nodes[0], 0,
+			     btrfs_item_ptr_offset(path.nodes[0], path.slots[0]),
+			     btrfs_item_size(path.nodes[0], path.slots[0]));
 	btrfs_release_path(&path);
 	if (ret < 0)
 		return ret;
@@ -906,6 +909,9 @@ static int insert_qgroup_items(struct btrfs_trans_handle *trans,
 	key.offset = qgroupid;
 	ret = btrfs_insert_empty_item(trans, quota_root, &path, &key,
 				      sizeof(struct btrfs_qgroup_limit_item));
+	memset_extent_buffer(path.nodes[0], 0,
+			     btrfs_item_ptr_offset(path.nodes[0], path.slots[0]),
+			     btrfs_item_size(path.nodes[0], path.slots[0]));
 	return ret;
 }
 
-- 
2.56.0

