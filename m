Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D7B3C4167
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 10:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779444441; cv=none; b=VfgfW2o0dWbas7C1s0GN9ePJe3lZLr0dpaYnF3tOw0+n8Qr9mZnlBy/Y7trSSe8WvopkT43DS0ulKQo9SaxRjf/jmPUbOHRdbCADnm2gXj61z4M9uDgPbEdy6p5JW0IRP0Xe+pXdXcvU4Gp7lpalKirLwz1Gh6/b8KzXf9wRwDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779444441; c=relaxed/simple;
	bh=JcS/WMHwcljiQhWOrNFtKvF1Nb7fYux3gUQDorwW0Fw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/bEF2IoCExuQ/g0ZxPUpGVpTfd8NbVV7jTMVImPubGDxXnIYJnqC5ZFr0oLy0GLtnzS0zCANLHwI75fKpKYF77ff9+zmS/r+i7wcM1kfsMrKenGhMY4Ji143bnRplikVzIh2mAbw9iRZKbhiklK7Bt3eBWqepjDXVw3Cj+jqJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OHkNzOoc; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OHkNzOoc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OHkNzOoc";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OHkNzOoc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0481967AE8
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 10:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779444433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GatmWSXJGwJb2kwd4lWvrydurYYZNcjO0sN5K3ZqS0E=;
	b=OHkNzOoc9NVAFmlSoN/NEkUigazOnL45QlTUgX8zIuj2aJLwaPCFPeElIdK1Z+fF40Uw7E
	0BRFJkfSeIjWu1oD46CVgypA/GeN875u5w/DvfGL9+Ltk+2ZxQyf9pTeOgSikWzqpDNSHm
	WuZwMSryJMeUXP7Mf+fxA/L1MOmZTbQ=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=OHkNzOoc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779444433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GatmWSXJGwJb2kwd4lWvrydurYYZNcjO0sN5K3ZqS0E=;
	b=OHkNzOoc9NVAFmlSoN/NEkUigazOnL45QlTUgX8zIuj2aJLwaPCFPeElIdK1Z+fF40Uw7E
	0BRFJkfSeIjWu1oD46CVgypA/GeN875u5w/DvfGL9+Ltk+2ZxQyf9pTeOgSikWzqpDNSHm
	WuZwMSryJMeUXP7Mf+fxA/L1MOmZTbQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C2B6593A8
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 10:07:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WNZeO88qEGpnbAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 10:07:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: fix raid56 reconstruction read
Date: Fri, 22 May 2026 19:36:52 +0930
Message-ID: <02faea573cf7a487ffa94100bbded46864efa1e4.1779442619.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779442619.git.wqu@suse.com>
References: <cover.1779442619.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 0481967AE8
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO

[BUG]
The following script can easily lead to false alerts from
"btrfs check --check-data-csum":

	mkfs.btrfs -f -d raid5 $dev1 $dev2 > /dev/null
	mount $dev1 $mnt
	$fsstress -w -n 64 -d $mnt
	umount $mnt
	btrfs check --check-data-csum $dev1

Which will normally report a lot of csum mismatch on mirror 2:

 Opening filesystem to check...
 Checking filesystem on /dev/test/scratch1
 UUID: e742b7b6-2562-48e5-b411-d50975633045
 [1/8] checking log skipped (none written)
 [2/8] checking root items
 [3/8] checking extents
 [4/8] checking free space tree
 [5/8] checking fs roots
 [6/8] checking csums against data
 mirror 2 bytenr 298909696 csum 0xd800f135 expected csum 0x7f6b1842
 mirror 2 bytenr 298913792 csum 0x1f49b645 expected csum 0x7f6b1842
 ...
 mirror 2 bytenr 1372917760 csum 0x16f78e6b expected csum 0x9462d728
 mirror 2 bytenr 1372921856 csum 0xa972667e expected csum 0x3bea937f
 ERROR: errors found in csum tree
 [7/8] checking root refs
 [8/8] checking quota groups skipped (not enabled on this FS)
 found 2736128 bytes used, error(s) found

And if asan is enabled, it will detect a heap-over-flow:

[6/8] checking csums against data
=================================================================
==6512==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x7e982fa2c800 at pc 0x7f883111e4da bp 0x7ffc69e8c9a0 sp 0x7ffc69e8c148
READ of size 65536 at 0x7e982fa2c800 thread T0
    #0 0x7f883111e4d9 in memcpy /usr/src/debug/gcc/gcc/libsanitizer/sanitizer_common/sanitizer_common_interceptors_memintrinsics.inc:115
    #1 0x560b9f250c4a in read_raid56 kernel-shared/extent_io.c:413
    #2 0x560b9f25100a in read_data_from_disk kernel-shared/extent_io.c:443
    #3 0x560b9f3faa12 in check_extent_csums check/main.c:5964
    #4 0x560b9f3fcaee in check_csum_root check/main.c:6235
    #5 0x560b9f3fcef6 in check_csums check/main.c:6276
    #6 0x560b9f41d168 in cmd_check check/main.c:11082
    #7 0x560b9f1f04fb in cmd_execute cmds/commands.h:126
    #8 0x560b9f1f1cc8 in main /home/adam/btrfs-progs/btrfs.c:474
    #9 0x7f8830c27634  (/usr/lib/libc.so.6+0x27634) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #10 0x7f8830c276e8 in __libc_start_main (/usr/lib/libc.so.6+0x276e8) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #11 0x560b9f1f03d4 in _start (/home/adam/btrfs-progs/btrfs+0x883d4) (BuildId: 2fde8cac91b9fec1b45e1b5145ee594466b76396)

0x7e982fa2c800 is located 0 bytes after 65536-byte region [0x7e982fa1c800,0x7e982fa2c800)
allocated by thread T0 here:
    #0 0x7f8831120cb5 in malloc /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_malloc_linux.cpp:67
    #1 0x560b9f250874 in read_raid56 kernel-shared/extent_io.c:348
    #2 0x560b9f25100a in read_data_from_disk kernel-shared/extent_io.c:443
    #3 0x560b9f3faa12 in check_extent_csums check/main.c:5964
    #4 0x560b9f3fcaee in check_csum_root check/main.c:6235
    #5 0x560b9f3fcef6 in check_csums check/main.c:6276
    #6 0x560b9f41d168 in cmd_check check/main.c:11082
    #7 0x560b9f1f04fb in cmd_execute cmds/commands.h:126
    #8 0x560b9f1f1cc8 in main /home/adam/btrfs-progs/btrfs.c:474
    #9 0x7f8830c27634  (/usr/lib/libc.so.6+0x27634) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #10 0x7f8830c276e8 in __libc_start_main (/usr/lib/libc.so.6+0x276e8) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #11 0x560b9f1f03d4 in _start (/home/adam/btrfs-progs/btrfs+0x883d4) (BuildId: 2fde8cac91b9fec1b45e1b5145ee594466b76396)

SUMMARY: AddressSanitizer: heap-buffer-overflow kernel-shared/extent_io.c:413 in read_raid56
Shadow bytes around the buggy address:
  0x7e982fa2c580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x7e982fa2c600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x7e982fa2c680: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x7e982fa2c700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x7e982fa2c780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>0x7e982fa2c800:[fa]fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x7e982fa2c880: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x7e982fa2c900: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x7e982fa2c980: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x7e982fa2ca00: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x7e982fa2ca80: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
Shadow byte legend (one shadow byte represents 8 application bytes):

[CAUSE]
During read of mirrors other than mirror 0/1 from RAID56 profiles,
btrfs-progs go through the following call chain:

 read_data_from_disk()
 |- btrfs_map_block()
 |  Note that @read_len returned by btrfs_map_block() is always
 |  BTRFS_STRIPE_LEN.
 |
 \- read_raid56()
    | Which does read out all stripes, but there is no extra checks
    | against if the logical range crosses stripe boundaries.
    |
    |- raid56_recov()
    |  Which rebuilds the target stripe.
    |
    |- memcpy(buf, pointers[failed_a] + (logical - full_stripe_start) %
              BTRFS_STRIPE_LEN, len);

If @logical is not at the begining of a stripe, then @logical + @len
will go beyond the stripe buffer size, causing gargage into the target
buffer.

[FIX]
Calculate the correct read length inside the data stripe for RAID56
inside read_data_from_disk().

And add extra ASSERT()s inside read_raid56().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/extent_io.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel-shared/extent_io.c b/kernel-shared/extent_io.c
index cb48699c2e46..ea26d9e6c94b 100644
--- a/kernel-shared/extent_io.c
+++ b/kernel-shared/extent_io.c
@@ -324,6 +324,8 @@ static int read_raid56(struct btrfs_fs_info *fs_info, void *buf, u64 logical,
 	const int tolerance = (multi->type & BTRFS_RAID_RAID6 ? 2 : 1);
 	const int num_stripes = multi->num_stripes;
 	const u64 full_stripe_start = raid_map[0];
+	const u64 stripe_start = full_stripe_start +
+				 round_down(logical - full_stripe_start, BTRFS_STRIPE_LEN);
 	void **pointers = NULL;
 	unsigned long *failed_stripe_bitmap = NULL;
 	int failed_a = -1;
@@ -336,7 +338,8 @@ static int read_raid56(struct btrfs_fs_info *fs_info, void *buf, u64 logical,
 	ASSERT(raid_map);
 
 	/* The read length should be inside one stripe */
-	ASSERT(len <= BTRFS_STRIPE_LEN);
+	ASSERT(logical >= stripe_start &&
+	       logical + len <= stripe_start + BTRFS_STRIPE_LEN);
 
 	pointers = calloc(num_stripes, sizeof(void *));
 	if (!pointers)
@@ -439,6 +442,15 @@ int read_data_from_disk(struct btrfs_fs_info *info, void *buf, u64 logical,
 
 	/* We need to rebuild from P/Q */
 	if (mirror > 1 && multi->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
+		u64 stripe_start;
+
+		/*
+		 * The returned @read_len is always BTRFS_STRIPE_LEN. We have to calcualte
+		 * the proper length to the stripe boundary.
+		 */
+		stripe_start = raid_map[0] + round_down(logical - raid_map[0], BTRFS_STRIPE_LEN);
+		read_len = min((stripe_start + BTRFS_STRIPE_LEN) - logical, read_len);
+
 		ret = read_raid56(info, buf, logical, read_len, mirror, multi,
 				  raid_map);
 		kfree(multi);
-- 
2.54.0

