Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4C823A566
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 02:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773367601; cv=none; b=lSh8w1JwanrelWMiOQK64SVu6iQHA0yEObuWTDEjLL756Q6XclZ9wFppRz05KB4a8y6nIfy7lE29DuJDZkit7x9L9a8lhT/ZkSI36HOduZOfpUby3oaivyYenAnsy28JmH7Mdyp9SFnxMW/UvAg6H9oSkRXGcw4twSeO61s+B8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773367601; c=relaxed/simple;
	bh=vh/P8kbp1hWf10ZVMwrraSQAU4dPg5iPOhKjlEjT3to=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ud7XQ81doTOH25loeWr5uNTNHKRw4sOo0Z4xWX3zqAgEm+Oc0dNL733YtpfglsFFIr0wSgO4BQT3aprePpSNB6YOsDmfH5UH/o0iuhx4vz3TYlSlpmT2WdhvzWckbMJqKSVxEDDHyNRqCVYj5BwpCFzBKcDAmzrB5a6V8sAEspE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AdBuCQX3; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oLOchP9m; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AdBuCQX3";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oLOchP9m"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EDB065CB7A;
	Fri, 13 Mar 2026 02:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773367598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ZUCfbMNY8lnlMMklEtXNnM/VK2+0Q4m/fHVOJoiHfqk=;
	b=AdBuCQX30SuFJSF/lIC+VU5vQRhBg9sMzwCDJdwmzC4d6a+XVd2HnVNUmMeD2FBfbQtp2v
	VNJEcPRz1uy4MxyUH6whTbXM9nznA95b/AhV/MXpFZ3ojSGdugRGYHT+ZzZW23eokK5Onu
	rK8Q0IJaXIZ/GOgZpg6g6HYPswC3TM0=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=oLOchP9m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773367597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ZUCfbMNY8lnlMMklEtXNnM/VK2+0Q4m/fHVOJoiHfqk=;
	b=oLOchP9mXT3c6bjLpqtPOhTAPXfCy8mdvvTWYpiKtruWxG39263KrG2zHM6Pf2DbDlqLeR
	FIY1pXh7JWxa0C+mSS7nhuBuDxHiX3QendUre4GN1ONBv8qOCf+hJgooqIHzMacTzWWOqX
	Koa0o8T/oNj0Q825rnSvPDIwUcyFmTA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ECD59402A0;
	Fri, 13 Mar 2026 02:06:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iZoyKyxxs2n2QQAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 13 Mar 2026 02:06:36 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] btrfs: zlib: handle page aligned compressed size correctly
Date: Fri, 13 Mar 2026 12:36:19 +1030
Message-ID: <e4b8b53446f543b8e0ee08ab78537e76174995a3.1773367428.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
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
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: EDB065CB7A

[BUG]
Since commit 3d74a7556fba ("btrfs: zlib: introduce zlib_compress_bio()
helper"), there are some reports about different crashes in zlib
compression path. One of the symptoms is list corruption like the
following:

  list_del corruption. next->prev should be fffffbb340204a08, but was ffff8d6517cb7de0. (next=fffffbb3402d62c8)
  ------------[ cut here ]------------
  kernel BUG at lib/list_debug.c:65!
  Oops: invalid opcode: 0000 [#1] SMP NOPTI
  CPU: 1 UID: 0 PID: 21436 Comm: kworker/u16:7 Not tainted 7.0.0-rc2-jcg+ #1 PREEMPT
  Hardware name: LENOVO 10VGS02P00/3130, BIOS M1XKT57A 02/10/2022
  Workqueue: btrfs-delalloc btrfs_work_helper [btrfs]
  RIP: 0010:__list_del_entry_valid_or_report+0xec/0xf0
  Call Trace:
   <TASK>
   btrfs_alloc_compr_folio+0xae/0xc0 [btrfs]
   zlib_compress_bio+0x39d/0x6a0 [btrfs]
   btrfs_compress_bio+0x2e3/0x3d0 [btrfs]
   compress_file_range+0x2b0/0x660 [btrfs]
   btrfs_work_helper+0xdb/0x3e0 [btrfs]
   process_one_work+0x192/0x3d0
   worker_thread+0x19a/0x310
   kthread+0xdf/0x120
   ret_from_fork+0x22e/0x310
   ret_from_fork_asm+0x1a/0x30
   </TASK>
  ---[ end trace 0000000000000000 ]---

Other symptoms include VM_BUG_ON() during folio_put().

Meanwhile zstd/lzo doesn't seem to have the same problem.

[CAUSE]
During zlib_compress_bio() every time the output buffer is full, we
queue the full folio into the compressed bio, and allocate a new folio
as the output folio.

After the input has finished, we loop through zlib_deflate() with
Z_FINISH to flush all output.

And when that is done, we still need to check if the last folio has any
content, and if so we still need to queue that part into the compressed
bio.

The problem is in the final folio handling, if the final folio is full
(for x86_64 the folio size is 4K), the length to queue is calculated by

  u32 cur_len = offset_in_folio(out_folio, workspace->strm.total_out);

But since total_out is 4K aligned, the resulted @cur_len will be 0, then
we hit the bio_add_folio(), which has a quirk that if bio_add_folio()
got an length 0, it will still queue the folio into the bio, but return
false.

In that case we go to out: tag, which calls btrfs_free_compr_folio() to
release @out_folio, which may put the out folio into the btrfs global
pool list.

On the other hand, that @out_folio is already added to the
compressed bio, and will later be released again by
cleanup_compressed_bio(), which results double release.

And if this time we still need to put the folio into the btrfs global
pool list, it will result a list corruption because it's already in the
list.

[FIX]
Instead of offset_inside_folio(), directly use the difference between
strm.total_out and bi_size.
So that if the last folio is completely full, we can still properly
queue the full folio other than queueing zero byte.

Fixes: 3d74a7556fba ("btrfs: zlib: introduce zlib_compress_bio() helper")
Cc: stable@vger.kernel.org # 7.0+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/zlib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 1a5093525e32..147c92a4dd04 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -308,7 +308,9 @@ int zlib_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 	}
 	/* Queue the remaining part of the folio. */
 	if (workspace->strm.total_out > bio->bi_iter.bi_size) {
-		u32 cur_len = offset_in_folio(out_folio, workspace->strm.total_out);
+		const u32 cur_len = workspace->strm.total_out - bio->bi_iter.bi_size;
+
+		ASSERT(cur_len <= folio_size(out_folio));
 
 		if (!bio_add_folio(bio, out_folio, cur_len, 0)) {
 			ret = -E2BIG;
-- 
2.53.0

