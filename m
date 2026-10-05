Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B821327E1DC
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 01:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791163022; cv=none; b=B8yRATBOCENK27cADgS+j+sCb8iAds6FgtmKGbukntIIjHiIpdnv2yZHmn8IB5zQH3K1rqUS+XyLSsrbPxstO9YEzXpUunTrzVjaFqO/lNGFx3ZnGvU9kvxRAGgFAa9ABUk1yh5m/Sg3umb05CuNU38K8re/Tp9WINcuxmD99Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791163022; c=relaxed/simple;
	bh=wwwvThDf/zEKHHxjNeHGtwRKO5qifMRWaYQ9JN7sDEA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qvBe5e7tjUmfJAFu3Be9PETFcESLaGWq2IoflVICHbZCOFs7D4pte3f4IEwLntgPP2aC5Sx7wrSnXvXxiE9P2QXqxp5n115m1qNtqISgRLOn41ooTofo51xdEON68ApSO9Iz2k7we7eSpX2pog7AAprScHFnBAFCSThyquI5OjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=N4qElXOf; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=N4qElXOf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="N4qElXOf";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="N4qElXOf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8500321EB7
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 01:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791163018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IhwwVU0e6GPZsGKVdZWbvLNVZVlVOSVjrMl8NqR2q7I=;
	b=N4qElXOffGQKrzTYsqw1RoOh7kIRNxq2N6WFUJucXLYu9splt0TceR755GWXIXEobPTXuY
	tUHc+1UK8UHrjNwTIGMuMCVnaxOlxzhUXBvYaNtrHxeyEqVZXB90FUXepCVUCkPFyP4T2a
	R4NNsP4c9aWi/fql1mZJLxsgqI9u6Dc=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791163018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IhwwVU0e6GPZsGKVdZWbvLNVZVlVOSVjrMl8NqR2q7I=;
	b=N4qElXOffGQKrzTYsqw1RoOh7kIRNxq2N6WFUJucXLYu9splt0TceR755GWXIXEobPTXuY
	tUHc+1UK8UHrjNwTIGMuMCVnaxOlxzhUXBvYaNtrHxeyEqVZXB90FUXepCVUCkPFyP4T2a
	R4NNsP4c9aWi/fql1mZJLxsgqI9u6Dc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C6DB132D3
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 01:16:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8Xf4H4j6wmpxagAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2026 01:16:56 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/2] btrfs: go extent-by-extent submission for buffered reads and writes
Date: Mon,  5 Oct 2026 11:46:36 +1030
Message-ID: <cover.1791162950.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

[CHANGELOG]
v4:
- Make the writeback_bio_size limit check more robust
  Only clamp @cur_len and do round_up() when the writeback_bio_size is
  larger than the current bio size.

  This will handle unaligned writeback_bio_size more robustly.

v3:
- Enhance the writeback_bio_size limit check
  Now we limit the writeback size early.

  This will follow the writeback_bio_size better.

- Do a better microbenchmark for the writeback patch
  It turns out that writeback throttle is making submit_bio() sleep,
  masking the improvement in extent_writepage_io().

  With wbt_late_nsec set to 0, now the improvement is way more obvious.
  Now it's over 90% reduce in average runtime, other than no improvement
  in the average runtime.

v2:
- Fix the length of advancement when no OE is found
  We should still retry the next block, as there may be only a block of
  gap.

  Exposed by Sashiko on the 2nd patch.

  Although it also exposed a false alert on the
  truncate_ordered_extents_beyond_eof().
  Where all the blocks in the range should have an OE, or we're having
  a bigger problem.

Although we have large data folio support for a while, the buffered
reads and writes are still iterating a large folio block-by-block.

For a large buffered IO, the large folio has a very high chance to
contain only one single extent.

In that case, although doing block-by-block checks is good for
readability, it's not really performant.

The series changes the behavior to do extent-by-extent iteration
instead, this can bring a very slight performance improve.

For best case scenario, the runtime to submit a folio read can be
reduced from 32us to 2.5us, and a much better distribution.
The runtime to submit a folio write can be reduced from 177us to 9us.

Qu Wenruo (2):
  btrfs: read a folio extent-by-extent instead of block-by-block
  btrfs: write back a folio extent-by-extent instead of block-by-block

 fs/btrfs/extent_io.c | 323 ++++++++++++++++++++++++++-----------------
 fs/btrfs/subpage.c   |  49 +++++++
 fs/btrfs/subpage.h   |   4 +
 3 files changed, 247 insertions(+), 129 deletions(-)

-- 
2.55.0

