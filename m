Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795388422;
	b=GT4iQ7rE2gzFQSoIe8Nboqa9AOLvZpzoTvlb6fdAUl/kqaqSqN2nQg141dFjjm+Ncur0
	 03eAeXaA43uEaZWMvuJO0OeEVWLCsAqZRxZLj9hyj7hon3ZA8dTFIxkFYLVcWtbhWmKYc
	 CHrQ7O8C/5jJF6xi+DRBLVPwFNgT9KAvPHIX8JDWmq/MdRy/YJOshUpWHuJDQ4ZMRRxnh
	 Pwwjf4Q0moZQDFzjEyYENZfLqcpd0RrC8pqru+8DSdMGS5cJ0Oqr9rkD3YtT5Z6C3Phdt
	 r+mrTGP3uBaNu1TXAMQvY2KvRc7rx0pLAg12rLRwfQ0tqIdFvv2W8v72/V63F0aAzEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795388422;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=pON5kYKmJ7OQSMc40cKtgg54MBPBY+FIULE/MQYtAAY=;
	b=G4teY4+R8jDvlJ4L1H73SkfXYnyICfwVUyu17dBdBkHXjJTIPy7oAOlw7S0NMOm8lR9l
	 Wf2S4lCDBPqYLSqZemnnokSB2TCgy9QchmaMu8R9X5Qjjl8E5DnkBdJuGK7W+rEXnSds5
	 EDQUGVHROVN+wL01/qUImgz2dFVwKbyzVEYFtYMB5ZbWZDIRrJRzLMCV+9Eq+UK7nYAhC
	 h1dQXw1dDny2ZkesV7LGF8CM0owEKTznM+QApuDUthHzGkrIR4bjFhn9TPLRn4kqAjavs
	 VvUPZ1hCY244wX22UFjlpUzEeyWJlz3HnxgjUF9i5JNdLm9kvXSlbtbfjNmg3xK3Q/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UXRKIgnN;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UXRKIgnN;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A72606A31A
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 23:00:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6A72606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UXRKIgnN;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UXRKIgnN
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0950F1F444
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 23:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795388420; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pON5kYKmJ7OQSMc40cKtgg54MBPBY+FIULE/MQYtAAY=;
	b=UXRKIgnNGdqVeJfPook8j+kdsKjQWuZN9fJeei2L5XIzU8iATLFN2X1OTqcJn3w/P48fIc
	zLzBVkvIS5JVlWbsCe2wLFmP1gjdH22KDlNgEw3qSYCJgddZoKpAnGE00vEuvF4vlfn0Wk
	VWD70NoE9JjZ5Jw12Z0qGn7m5ALp7No=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795388420; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pON5kYKmJ7OQSMc40cKtgg54MBPBY+FIULE/MQYtAAY=;
	b=UXRKIgnNGdqVeJfPook8j+kdsKjQWuZN9fJeei2L5XIzU8iATLFN2X1OTqcJn3w/P48fIc
	zLzBVkvIS5JVlWbsCe2wLFmP1gjdH22KDlNgEw3qSYCJgddZoKpAnGE00vEuvF4vlfn0Wk
	VWD70NoE9JjZ5Jw12Z0qGn7m5ALp7No=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D329F13510
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 23:00:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PE5SCgJ0A2v8PQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 23:00:18 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: minor fixes in
Date: Mon, 23 Nov 2026 09:29:57 +1030
Message-ID: <cover.1795388358.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
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

The first one is reported by Sashiko, the second one is another bug
exposed during fixing the first one.

Qu Wenruo (2):
  btrfs: reject too high tree level during backref walk
  btrfs: avoid NULL-ptr-dreference after a lowest_level search

 fs/btrfs/backref.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

-- 
2.56.1

