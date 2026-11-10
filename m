Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794291175;
	b=LSTkXTTKMemaii8WeykVzMUTZYwXfVAvwKyhZgOCTVaPX/SOccP23Sm0nPd21u9bhIvu
	 XTPY9/Cq6QQVlQffyy8NRVGxBizIbiXLN8yIslQSds9UlPyeAWyWfHccBNHdvo91UHaJs
	 eYW8DEc9CwaMtkMiA+haTAQdSMIqW+3q2T5z4+S7F2bgrL5bbiJsETE+z6RN/xmOALHi2
	 93d+raVxCXSde0WlJP3Y3v2F4eXJiNrf1MiiGezMhm/Xpq/NeRDZ/AnYSzZmPodaV62tQ
	 yEPcAHLr/R2pjiBADamyXs06gLltERAkPKTAdqIqmb+sY1lSPUXub21KnRKPGxwAc4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794291175;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=DBVw5uWNnIITNByR1Rh4p9z0pfjz69d93T7jHJD0f08=;
	b=zhnEw0rlvRzKbHH8NclvhESPPMcDPQSi5vEjIYbtDsLHT1RZojBbW26cf8OF6uiq5fOd
	 WWzgqjDzm5Oi7uGNDhcO7bCa09+1JDxMuqtPYLHny31Tg54r/x8GhYlN16dQ9QxdHP5xj
	 wOEJ0jM5dkNni7jjH00g8SklO8pIyYpdN0PG1KiIVMOrhIoZbEeAaC01W+Xgv90f+g8EC
	 yASHhqT9S1qiRmjkov6uI9mlcXEmea6pVxNQ4ydHSK82kA4LHbGyFMdr9NOxaZI6DS6CT
	 ThbFu+keNAMJWx7eGj5ZF1M6F5WWWCbEmVkucjXVRB3mtzVoLKy6OkVXRi1kzUcpvsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="Mb/H1+UA";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="Mb/H1+UA";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C847606A333
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 06:12:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C847606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Mb/H1+UA;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Mb/H1+UA
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A33301F45B
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 06:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794291172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DBVw5uWNnIITNByR1Rh4p9z0pfjz69d93T7jHJD0f08=;
	b=Mb/H1+UABJi2gp8tYh8J/wMLyccQBuokuQPpE1ZX/IWh6ARrOdsshuHPEFPxaEgaKEJLX3
	05hFLR7DfMnH05xukVV/Hqp2ODKVxGXGw3TCZS2OE7w+V+zjrmNdM2VCwy5nb+uTHElhWZ
	a/z1qb9Y/9PNpJLZDm9tl2JYZ7jcP80=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="Mb/H1+UA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794291172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DBVw5uWNnIITNByR1Rh4p9z0pfjz69d93T7jHJD0f08=;
	b=Mb/H1+UABJi2gp8tYh8J/wMLyccQBuokuQPpE1ZX/IWh6ARrOdsshuHPEFPxaEgaKEJLX3
	05hFLR7DfMnH05xukVV/Hqp2ODKVxGXGw3TCZS2OE7w+V+zjrmNdM2VCwy5nb+uTHElhWZ
	a/z1qb9Y/9PNpJLZDm9tl2JYZ7jcP80=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 82C5F13479
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 06:12:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id no3bCeG18mreJQAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 06:12:51 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/4] btrfs: do not allow fast fsync if there is any async dio write
Date: Tue, 10 Nov 2026 16:42:24 +1030
Message-ID: <aa2343bbda662ef5f425c0dfbb5c84cc67940fcd.1794290876.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794290876.git.wqu@suse.com>
References: <cover.1794290876.git.wqu@suse.com>
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,sashiko.dev:url];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: A33301F45B

Sashiko reported a possible race where an async direct write happened, a
fast fsync() can return before the write reaches the storage:

  CPU0 (io_uring/AIO direct write)| CPU1
  --------------------------------+-----------------------------------
  btrfs_direct_write()
  |-btrfs_dio_write()
  | \-__iomap_dio_rw()
  |   |-btrfs_dio_iomap_begin()
  |   | |-btrfs_new_extent_direct()
  |   |   ^^^ new extent + ordered extent, data not written yet
  |   |
  |   |-btrfs_dio_submit_io()
  |   | |-btrfs_submit_bbio()
  |   |   ^^^ bio in flight, not finished
  |   |
  |   \- return -EIOCBQUEUED
  \-btrfs_inode_unlock()
                                    btrfs_sync_file()
                                    |-btrfs_get_ordered_extents_for_logging()
                                    | ^^^grabs the incomplete OE
                                    |
                                    |-filemap_fdatawait_range()
                                    | ^^^no folio under writeback, returns
                                    |    immediately
                                    |
                                    |-btrfs_log_dentry_safe()
                                    | | ...
                                    | \-btrfs_log_changed_extents()
                                    |   ^^^ logs file extent item for the new extent
                                    |       OE only marked PENDING, nobody waits for its IO
                                    |
                                    \-btrfs_sync_log()
                                      ^^^ log tree is on disk, data bio still in flight
                                          fsync() returns

  power loss, the data bio never reached disk

  mount
  |-btrfs_recover_log_trees()
    ^^^ replays the extent item, file now points to unwritten blocks

To prevent such problem, disable fast fsync for async direct writes.

Fixes: 487781796d30 ("btrfs: make fast fsyncs wait only for writeback")
Link: https://sashiko.dev/#/bug/linux-ee047626-2fa7-46d5-b543-861136993fc7
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/direct-io.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index ed3914257d39..6e796163015e 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -974,6 +974,17 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 
 	if (IS_ERR_OR_NULL(dio)) {
 		ret = PTR_ERR_OR_ZERO(dio);
+		/*
+		 * The async direct write is not waiting for its IO to finish.
+		 *
+		 * If fsync() went through the fast path, the direct write OE
+		 * will be logged, but the data may not yet reach disks.
+		 * And fsync() returned without waiting for the data.
+		 *
+		 * So for async direct writes, we can not go to fast sync path.
+		 */
+		if (ret == -EIOCBQUEUED)
+			btrfs_set_inode_full_sync(BTRFS_I(inode));
 	} else {
 		/*
 		 * If we have a synchronous write, we must make sure the fsync
-- 
2.56.0

