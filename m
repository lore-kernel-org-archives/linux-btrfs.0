Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C691E7C2E
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781140453; cv=none; b=pvnfeIdtWv1uK1gqvOPIEfF8bFEKdP652rnAbKal5xszkz4wGV03OBh1+KPRlyUHA+qoULUwYKxUtR0Pn/mQvNnzYt1xdy54zeITiGDFDxvxVYPE6Sy6OO1qbvxRZpQVhBXT0OohoiHQIA33UEthjpnRe/IP1RU4J/W4H9r9Lus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781140453; c=relaxed/simple;
	bh=k0YKhX9Qy/7TB/B8NTqU7WixhjSpwDRcaTFzQbn9bSQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+S0sW9l09DifVXuvJ5fpXBn5qHXAEKC2Tu269Mb/SHMBYlv8IcYc4QLZ4O7c9ktHj778+Y2BGISgkXLCI87UR5ip+ImyKOSaKteg8IdXuimX5liVOlSbPLU4kcUHnezJPeJqaPuLKQQHCBedlsAt+yp8Nu/YnXZ2emyh2pf9Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dtV+ifvW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dtV+ifvW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dtV+ifvW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dtV+ifvW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 32A8F75B93
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781140450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g1RyltFNGjr1yuprGRFnksYqRi4z4eQuW6RzIRJuL4k=;
	b=dtV+ifvWqiOI9lg1qGK4XC7B4YlAFar3iX/BX29+903qwEqQ/j5pXu4hRa55gRJotl0N0b
	IXSgUQfDKp1KTO+JWgJN3kzOs/rvBzIFcH/Ou93Kdx3GPgz6s9IeDQuMQoCaba/1wkaSFL
	/DfwpLwAutCgJXXoGXI7nlqSUHfRv3w=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=dtV+ifvW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781140450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g1RyltFNGjr1yuprGRFnksYqRi4z4eQuW6RzIRJuL4k=;
	b=dtV+ifvWqiOI9lg1qGK4XC7B4YlAFar3iX/BX29+903qwEqQ/j5pXu4hRa55gRJotl0N0b
	IXSgUQfDKp1KTO+JWgJN3kzOs/rvBzIFcH/Ou93Kdx3GPgz6s9IeDQuMQoCaba/1wkaSFL
	/DfwpLwAutCgJXXoGXI7nlqSUHfRv3w=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2FE9B779A7
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OIa4M+ALKmqFWwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:08 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: fix a memory leak in btrfs_load_block_group_zone_info()
Date: Thu, 11 Jun 2026 10:43:42 +0930
Message-ID: <74b8ace8b2f8dbfed5e903ff4f49c433d7cd5563.1781140396.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1781140396.git.wqu@suse.com>
References: <cover.1781140396.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	DWL_DNSWL_LOW(-1.00)[suse.com:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 32A8F75B93
X-Spam-Score: -4.01

[BUG]
With the previous btrfs_zoned_device_info memory leak fixed, the test
case mkfs/025 still fails with extra memory leaks:

====== RUN CHECK /home/adam/btrfs-progs/mkfs.btrfs -d single -m single /dev/nullb0 /dev/nullb1 /dev/nullb2 /dev/nullb3 /dev/nullb4 /dev/nullb5 /dev/nullb6 /dev/nullb7 /dev/nullb8 /dev/nullb9

=================================================================
==4392==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 64 byte(s) in 1 object(s) allocated from:
    #0 0x7f5561b205dd in calloc /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_malloc_linux.cpp:74
    #1 0x5568792ba42a in bitmap_zalloc kernel-lib/bitmap.h:19
    #2 0x5568792c24c0 in btrfs_load_block_group_zone_info kernel-shared/zoned.c:1227
    #3 0x556879256b02 in btrfs_add_block_group kernel-shared/extent-tree.c:3025
    #4 0x5568792572ba in btrfs_make_block_group kernel-shared/extent-tree.c:3094
    #5 0x5568791d3d7b in create_metadata_block_groups mkfs/main.c:162
    #6 0x5568791e1a52 in main mkfs/main.c:2263
    #7 0x7f5561627634  (/usr/lib/libc.so.6+0x27634) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #8 0x7f55616276e8 in __libc_start_main (/usr/lib/libc.so.6+0x276e8) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #9 0x5568791d1fa4 in _start (/home/adam/btrfs-progs/mkfs.btrfs+0x3cfa4) (BuildId: dd46ced75e977e88e3b77290546834407f113fba)

Direct leak of 64 byte(s) in 1 object(s) allocated from:
    #0 0x7f5561b205dd in calloc /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_malloc_linux.cpp:74
    #1 0x5568792ba42a in bitmap_zalloc kernel-lib/bitmap.h:19
    #2 0x5568792c24c0 in btrfs_load_block_group_zone_info kernel-shared/zoned.c:1227
    #3 0x556879256b02 in btrfs_add_block_group kernel-shared/extent-tree.c:3025
    #4 0x5568792572ba in btrfs_make_block_group kernel-shared/extent-tree.c:3094
    #5 0x5568791d446d in create_data_block_groups mkfs/main.c:222
    #6 0x5568791e1ea7 in main mkfs/main.c:2297
    #7 0x7f5561627634  (/usr/lib/libc.so.6+0x27634) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #8 0x7f55616276e8 in __libc_start_main (/usr/lib/libc.so.6+0x276e8) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #9 0x5568791d1fa4 in _start (/home/adam/btrfs-progs/mkfs.btrfs+0x3cfa4) (BuildId: dd46ced75e977e88e3b77290546834407f113fba)

Direct leak of 64 byte(s) in 1 object(s) allocated from:
    #0 0x7f5561b205dd in calloc /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_malloc_linux.cpp:74
    #1 0x5568792ba42a in bitmap_zalloc kernel-lib/bitmap.h:19
    #2 0x5568792c24c0 in btrfs_load_block_group_zone_info kernel-shared/zoned.c:1227
    #3 0x556879256b02 in btrfs_add_block_group kernel-shared/extent-tree.c:3025
    #4 0x5568792572ba in btrfs_make_block_group kernel-shared/extent-tree.c:3094
    #5 0x5568791d446d in create_data_block_groups mkfs/main.c:222
    #6 0x5568791e1ffe in main mkfs/main.c:2305
    #7 0x7f5561627634  (/usr/lib/libc.so.6+0x27634) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #8 0x7f55616276e8 in __libc_start_main (/usr/lib/libc.so.6+0x276e8) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #9 0x5568791d1fa4 in _start (/home/adam/btrfs-progs/mkfs.btrfs+0x3cfa4) (BuildId: dd46ced75e977e88e3b77290546834407f113fba)

[CAUSE]
Inside btrfs_load_block_group_zone_info() we allocated an @active bitmap
using bitmap_zalloc(), and use that bitmap for updating @zone_info.

However after everything is done we only freed @zone_info, not @active
bitmap, causing the above memory leak.

[FIX]
Free @active bitmap inside btrfs_load_block_group_zone_info().

Fixes: 6936ffa265c7 ("btrfs-progs: zoned: activate block group on loading")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/zoned.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel-shared/zoned.c b/kernel-shared/zoned.c
index 1757b195560a..8a9d1f38c37d 100644
--- a/kernel-shared/zoned.c
+++ b/kernel-shared/zoned.c
@@ -1302,6 +1302,7 @@ out:
 	if (!ret)
 		cache->write_offset = cache->alloc_offset;
 
+	kfree(active);
 	kfree(zone_info);
 	return ret;
 }
-- 
2.54.0

