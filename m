Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792661997;
	b=D2fqBG61vrh9cqMpidBoP/NwRzNWz7xhFtIz/wUFB/FbeaAKAQO/+N7M/ojPgnHk7KOP
	 +f7AOX43UOjyXqp/tDH4PxMVqLfX5HRwtbPQbkorSNPxx46SW60XZs8NBMjrPH1HgZ1BU
	 VElPlEoP3yDhC47oDKy5s3Zzb/tJmGUxcFxXAAknWs9A2S00hOIf70QXsWWJYfLlHItJv
	 afWfEeRvoNcwSTQxjLcgCbnX6BLAgpeH9E8iKWuBnV6arXWB5gSHH2Dc19P2tVqMkzwxF
	 mkcbIiIFwwiDDD9aifGqgEZEbJ1jplFfcrd77PFX+7RrOE9eW567Wng5HeAqfSUUEVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792661997;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=egVxIKsd4NR0w/uMhcsthwwTn4lBW4FGOphgu/lmOzI=;
	b=W8yHpVuvdjF11r22Pk4kvpa0L4kxZNBe7KNdx/238LzM1jBXxRLNX2LHLSWzAuNfi250
	 ayK5gUVmarwmjexLIvA3CKTogJZkq6oDM70P72oifIxp7xSzozjNBWOUqga7tF3nwR9O0
	 CUMXMSzJuCkYeyKKCfeBF0jpQe8S2g41gQo+e4DCmUXhJDVEtREpAJ18xItoAfSN6a+s0
	 UPyGXgKQYbY18DXsuTIGVNV/AOLYm/NB3tzBQ7W1JobQ/leYM7B45+LQgq3BoLn8+5VNm
	 /SeFBuzPPdbdx42Tab5xztBbLLfUmrNLRqYLMnV9emTNq5ojvMS1M6RAyVa+Z6o0X2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=EmbrTZsq;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ORpfRzY9;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FBD606A324
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66FBD606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=EmbrTZsq;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ORpfRzY9
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7E6841FCD5
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792661994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=egVxIKsd4NR0w/uMhcsthwwTn4lBW4FGOphgu/lmOzI=;
	b=EmbrTZsqb7E1nzMCoGmK8TQF0iUekd3Kh+Uc/deUTRx16Yw+O91gx4p12713P0gOKqqtqb
	Wl7y+9Xa8SUXPKanJtJQ9Bd2EnsifN425O5Vkn5Senjx4EaCO5CR7jjgzBpWveIDWeFXHO
	g33Nv4Ek7IxaGrZiTHNOwxwehBNnHk8=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792661993; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=egVxIKsd4NR0w/uMhcsthwwTn4lBW4FGOphgu/lmOzI=;
	b=ORpfRzY9wbllP6EW3V46bJXjghAPDbqjROG7wJbaS6EMbmPaj/AqZlLPSh0tUHLD8EZ//5
	gtpyv/PTFyij5BGS4Gn3WS7QqvRXDqT7fQdYxux3cLIXUCZ19skoEWz3leNpbpsrrPVV4E
	ueNLjBu0+2O+5okFGY2WVAEwsgeWeRM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 65800133F3
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sUAVLufZ2Wp7dQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:52 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: raid56: fully support stripe_len < PAGE_SIZE
Date: Thu, 22 Oct 2026 20:09:26 +1030
Message-ID: <cover.1792661955.git.wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

Previously the variable stripe_len support for RAID56 intentionally
skips the stripe_len < PAGE_SIZE for partial rbio page allocation and
steal.

The reason is that the existing code assumes a stripe_len can never be
smaller than PAGE_SIZE, thus a page can either either data or P/Q
blocks, not both.

But it turns out that the original code is not unnecessarily complex,
especially for steal_rbio().
We can easily calculate the number of pages to steal/allocate without
any special assumption on stripe_len and PAGE_SIZE.

So add back the proper support for steal_rbio() and partial rbio page
allocation, which also slightly cleanup the steal_rbio() related to
helpers.

Qu Wenruo (3):
  btrfs: introduce rbio_nr_data_sectors() helper
  btrfs: add stripe_len < PAGE_SIZE support for steal_rbio()
  btrfs: add stripe_len < PAGE_SIZE support for alloc_rbio_*_pages()

 fs/btrfs/raid56.c | 182 +++++++++++++---------------------------------
 1 file changed, 51 insertions(+), 131 deletions(-)

-- 
2.56.0

