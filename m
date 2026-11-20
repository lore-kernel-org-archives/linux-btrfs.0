Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795167717;
	b=w78yaj7aWxEOPAXSdlBM/NB9UakwShSnJ4g1fp7ovZYtUTCBn55EFJJgUJr/EDVAzEo+
	 ItKOt5mWutF48uCCCTGhoSYaLsm6c0I7k97BD4md4tHO7pc3YwzpXDafSaionijJbXy8B
	 Ati0g5+prStnD5CopuY28zKrqNqg8NvdtthyzAk9mc3LZ+yobcjSc9pJet92gXreUiujT
	 RIOWnLD5rTUptmzThywLTEOyRULE+HNagNyoviOZsnf9kkv0zVPhrvzfYi+Y2QRYGlpOm
	 krFpeLoKEnNXgdvghTRuCKQArSA/kG3COGxVi5LxVy6vkxQz866XrRfLWXtmwOxyS4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795167717;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=2ew6n/p8uMe2sZe3STlrkaNN7R1yW27JL6SthyMb52o=;
	b=ZDjuI1fUbvW8HmrRPpVny5xFGy3R6bcDUq1F/gJCjs/J5XHBRm7mZTB0XWzYpDfsSwkp
	 VyB9MZaNaZc9l5OnLkigj9+QIyW7W67k2fE2Rs5aONcduIQvXpmlJnKoKk6O+/wE0iNGd
	 2xoIRMyjEo1gd9VYaI9JjVEBYktB0T6HI7mHZL5y19FuQzG/au/AJJEJES1jwxWq90TrN
	 6gMIl+zgF4ijZR6tqnOn9x9opwXjLaj9kHC8NdtyaA6B6HoRoMIwIz1J8tkkpOoUVhFeY
	 eoNBIzc3lST7oghmD0V8PN0nmgH53qzv3kdGtcUYLGZ7HQogAKLF2LQHTXOrxo7qSYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HiEidzy+;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HiEidzy+;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5818E606A325
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:41:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5818E606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HiEidzy+;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HiEidzy+
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9C75D1F7BE
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795167715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2ew6n/p8uMe2sZe3STlrkaNN7R1yW27JL6SthyMb52o=;
	b=HiEidzy+cts4/9EVyjQ2Lb3BgnXB4ypuccSdwnyZLK29XlztUG99vRsl3nuyJcbFu89hJF
	FJ1zfNIwewns1UabDSKfqVhrGix2KaAdiWKYKiEkMT5dO9SGXzMjpGFelZdsTE0DVkX1VJ
	frD7fncknywSj3HD+olBznzGfht/k7k=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795167715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2ew6n/p8uMe2sZe3STlrkaNN7R1yW27JL6SthyMb52o=;
	b=HiEidzy+cts4/9EVyjQ2Lb3BgnXB4ypuccSdwnyZLK29XlztUG99vRsl3nuyJcbFu89hJF
	FJ1zfNIwewns1UabDSKfqVhrGix2KaAdiWKYKiEkMT5dO9SGXzMjpGFelZdsTE0DVkX1VJ
	frD7fncknywSj3HD+olBznzGfht/k7k=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 783311348F
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:41:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id maa+MOEVAGsBBgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:41:54 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: qgroup: rescan related message minor fixes
Date: Fri, 20 Nov 2026 20:11:32 +1030
Message-ID: <cover.1795167390.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

[CHANGELOG]
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

 fs/btrfs/qgroup.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

-- 
2.56.0

