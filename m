Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781421A6811
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781140460; cv=none; b=FLWOni0bzuLUgaT2uzBjSS/phgvzAuF+fdYPGHLKNAAGzKC5gyopQaflIZbOWYOy4DLmLdO+nGBEQ8i8rX3wQ+qaHn9BnYd8Harx4ToPfNn0hjA5VtDcswYweicdN+XiHirFxRKynu6M1gCOIMaecpNt0f5cKLQL4zgxdpDCPj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781140460; c=relaxed/simple;
	bh=siuPaZV7bgxXIXpFAsodesWCgkPJ5kIQGeeuPwAGE2w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lK44EbosfyK1JKNrgjbyT7H1rknt2Kf/sUCg3lPpNMybn7gEknlVK4wVc4YnMC7FgDj/RpMme+fO6pbJ59ur0plbdZBMVdQS1SbH/OKovhFKKChaPHaogzl3h26UQH4WIhB1Qafeq+Bff+WKliZ28eUuORhbEmJOnYFZWrYYrYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BS1+I/j6; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BS1+I/j6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BS1+I/j6";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BS1+I/j6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CDF4075B9E
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781140451; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C7i35+sULHjtNuKw9+4Rr5k5BT7IC6O9W8tDFDTWpi8=;
	b=BS1+I/j6yL8lJLtpeNsFFDBGwobJ6JT4x5+Yx83Q+ZYd/tB4VBx22xHFe82DWTQBrRnV+H
	6nL4Fx/Q8brAWqcjidO3XacvXovuSd5onBfp+gj92HNGPL3nylIwAxUTaUUWnvq9bHV9Hd
	5hGA46XRSfQLvVCHxlfjyNpFnV4jHMY=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="BS1+I/j6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781140451; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C7i35+sULHjtNuKw9+4Rr5k5BT7IC6O9W8tDFDTWpi8=;
	b=BS1+I/j6yL8lJLtpeNsFFDBGwobJ6JT4x5+Yx83Q+ZYd/tB4VBx22xHFe82DWTQBrRnV+H
	6nL4Fx/Q8brAWqcjidO3XacvXovuSd5onBfp+gj92HNGPL3nylIwAxUTaUUWnvq9bHV9Hd
	5hGA46XRSfQLvVCHxlfjyNpFnV4jHMY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CD30E779A7
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SHSEHuILKmqFWwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:10 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: fix a memory leak in __btrfs_map_block() after RST lookup failure
Date: Thu, 11 Jun 2026 10:43:43 +0930
Message-ID: <a8174e901f7239e52fd573a2505f1041d72e62e3.1781140396.git.wqu@suse.com>
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
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: CDF4075B9E
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

[BUG]
With all previous memory leaks fixed, now mkfs/030 fails with the
following memory leak:

====== RUN CHECK /home/adam/btrfs-progs/mkfs.btrfs -f -O zoned -d dup -m single /dev/nullb0 /dev/nullb1 /dev/nullb2 /dev/nullb3
WARNING: DUP is not recommended on filesystem with multiple devices
WARNING: DUP may not actually lead to 2 copies on the device, see manual page

=================================================================
==48914==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 144 byte(s) in 1 object(s) allocated from:
    #0 0x7fe9247205dd in calloc /usr/src/debug/gcc/gcc/libsanitizer/asan/asan_malloc_linux.cpp:74
    #1 0x5587da350c9a in __btrfs_map_block kernel-shared/volumes.c:2236
    #2 0x5587da34f4b9 in btrfs_map_block kernel-shared/volumes.c:2002
    #3 0x5587da279470 in queue_discard_logical mkfs/main.c:1355
    #4 0x5587da27a01b in discard_free_space mkfs/main.c:1453
    #5 0x5587da2825a8 in main mkfs/main.c:2587
    #6 0x7fe924227634  (/usr/lib/libc.so.6+0x27634) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #7 0x7fe9242276e8 in __libc_start_main (/usr/lib/libc.so.6+0x276e8) (BuildId: 2f722da304c0a508c891285e6840199c35019c8d)
    #8 0x5587da26ffa4 in _start (/home/adam/btrfs-progs/mkfs.btrfs+0x3cfa4) (BuildId: 67b730427c6a4739addff9bd31ecd89b1b5ae11a)

[CAUSE]
In __btrfs_map_block() if the fs has raid-stripe-tree enabled, we need
to do one extra mapping to get the physical address.

However btrfs_stripe_tree_logical_to_physical() can fail, and if that
function failed, we error out without freeing @multi we have allocated,
resulting the above memory leak.

[FIX]
Do the proper error handling before erroring out after
btrfs_stripe_tree_logical_to_physical() failure.

Fixes: a9fd50f85fdd ("btrfs-progs: read stripe tree when mapping blocks")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/volumes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel-shared/volumes.c b/kernel-shared/volumes.c
index c3d113b6e3b1..f35b59bcc20e 100644
--- a/kernel-shared/volumes.c
+++ b/kernel-shared/volumes.c
@@ -2396,8 +2396,10 @@ again:
 
 			ret = btrfs_stripe_tree_logical_to_physical(fs_info, logical,
 								    &multi->stripes[i]);
-			if (ret)
+			if (ret) {
+				kfree(multi);
 				return ret;
+			}
 		} else {
 			multi->stripes[i].physical =
 				map->stripes[stripe_index].physical +
-- 
2.54.0

