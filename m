Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168686;
	b=elefjhw6AShffIixCfdljcV5mPdnEiUJ0oHVdv6d9fuId0Yx+oLDqt/0MVjDKtlTqUW9
	 97HjJoWoTVVkC4y0COVnjlhiODoAivqPsDJRdHUEwYERJjGBjJUoM58wnZ470roBkIDKT
	 kMeNs65x/lzkac6qP2sI7SvMQ35Mg6lZthMZckglw9fHbOdKxFaGtOqK5xtYlSyHkmkz1
	 +A3RhJHlboIPCkEvku2UebhFTTE5fIqPEjhSMJJoc5YnRmJfK3qOA9TVjSQ/tQxEyzLZK
	 b6ooSxICefBNoIsK4RtvRBsqtE/gWtLtaWCsLg4kZnV9UfBTx64FQWgVZ04RRVufrNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168686;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=1t+v0cqJ+twCSoibY9pXBIIHaDLJ3WGybMJPb7RUdzM=;
	b=wArXF3WuUbiKGixEp4zleaEYMZRadOZqB+cAu3dIdV71NqjHi+a462hvgf2JSEGWUkqj
	 l99D2IXVxfzDqwUwKyTJcMq5tmb6ICNO58UGKi0iiTI/zG86ZlKXq/D2GhVUR5Mh1TMEC
	 pLw2AicCzSkM6aCSSDbViGtFjDO9XN3T1VxJSJaaG1/eqBilLlIAWXvWXNETehwpAyfwo
	 RNXEZkYjno6GE4P7Vjr7vPgHp8cp/wGiwPsxIhHJlJYgkBgM6DyR9lGjQhvLL2vT1xXxY
	 l3NKVvR/7uQbna0JCTBEN8pfER5gIKfSG+qCQoeoO+x+TzNR0CfJXF1x3MjwFCkL5bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=R0eoTxDz;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=R0eoTxDz;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E1F606A32C
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:58:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50E1F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=R0eoTxDz;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=R0eoTxDz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3B52022516
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795168683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1t+v0cqJ+twCSoibY9pXBIIHaDLJ3WGybMJPb7RUdzM=;
	b=R0eoTxDz7YSydJYrI4VenibCNseswKFm0jeQrtVh7ptcN/YuOMslKbjg/YRbLatOvBE4BW
	lxWWzeG71jrxGRRuxQFWcDA2/W1mJavZtlWQ4D9CcbDkxiBeVKKTWhXe0X5+f9SgOq5Kxb
	UeiSKf9ROIGAkSaimlIE1CCUvtd0sUA=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=R0eoTxDz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795168683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1t+v0cqJ+twCSoibY9pXBIIHaDLJ3WGybMJPb7RUdzM=;
	b=R0eoTxDz7YSydJYrI4VenibCNseswKFm0jeQrtVh7ptcN/YuOMslKbjg/YRbLatOvBE4BW
	lxWWzeG71jrxGRRuxQFWcDA2/W1mJavZtlWQ4D9CcbDkxiBeVKKTWhXe0X5+f9SgOq5Kxb
	UeiSKf9ROIGAkSaimlIE1CCUvtd0sUA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 181FB1348F
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:58:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UUtJGakZAGvSFgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:58:01 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/3] btrfs: qgroup: rescan related message minor fixes
Date: Fri, 20 Nov 2026 20:27:32 +1030
Message-ID: <cover.1795168584.git.wqu@suse.com>
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
	RCPT_COUNT_ONE(0.00)[1];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 3B52022516

[CHANGELOG]
v3:
- Fix the @cancelled update
  To handle the @stopped == false case better.

v2:
- Handle cancelled-after-finished case better
  So cancelled is only update when the rescan is stopped. This means
  if the rescan is finished properly then cancelled before we commit
  everything, at least we still treat the rescan as finished.

  This is pointed by sashiko, but I won't handle it any further, as it's
  a long existing cancel-rescan race. I don't think it's that important
  either.

- Reorder the error messages priority
  Now the failure has the highest priority.

The first one is from Sashiko.

The second one is to make sure we output the rescan related message even
if we failed to start a transaction (e.g. transaction aborted).

The final one is to fix a bug that rescan cancelled message is never
shown.

But the final one is also prone to race between scan and cancel. I don't
think there is any good way to really fix that yet nor is really caused by
this patch.

So I'll mostly ignore future scan-cancel race related review from sashiko
on the last patch.


Qu Wenruo (3):
  btrfs: qgroup: handle the transaction commit error during rescan
  btrfs: qgroup: ensure the qgroup rescan messages are always shown
  btrfs: qgroup: show the "qgroup scan cancelled" message correctly

 fs/btrfs/qgroup.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

-- 
2.56.0

