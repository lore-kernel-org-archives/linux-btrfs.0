Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67583175A6D
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 06:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787813761; cv=none; b=ui0C1GgP1NatRXBiyizyBAQS3jOwUrkjva357R0q/apfHFBE61IDWhz8q8pNjLKftOJd3YbArhLyN7PNw8n8ZYTHtKZBRHNtnyBHJtWCSYDGqS9eDfJxTF47mjclLgFRHGvwtMQGVdUoChgfVgpW4nmd1dhztAM6+WCmouUEwds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787813761; c=relaxed/simple;
	bh=eLWYcrH8h9a+an1KvimoGhX6nQOHZIc5EVJ/sSlRAHk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=F84U5k6TvpXnlfGR2xTrLYtm4GY4xqJ12djD8KAIH7iNWXcBLGbPrITDt/VTYHuKFd3vGDMy/ue72W/awzYGTD1kDJBjWD1dhbUZdYF7waABaJtnLzUoMAHl997rqERpUjl5dwtLs1rRSnI5wHb7hEcCo5aupLRwVQj6kYZD5Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=b35I264U; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aetZwxn5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="b35I264U";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aetZwxn5"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3535E21223
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 06:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787813754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=VSny1jfJb5FEDR6RnXOAFBbm2E4OjJtv7qSA0FDisBQ=;
	b=b35I264Uvxh+L1rQvxd3fPuW/SdE9x8Qb8NLuge6S9qL5JNqtgugVWwbNi6FU/wwccOj0C
	MnNbOZzjRl+U2Xxt1qc3D6nH7c4XAETR8kMBIggSWzaDxyb7QsoCt87W/qEmrKHcr7Yn5V
	FI59n7OqgAIiyxMaJjpL4x93gFTQbfY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787813750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=VSny1jfJb5FEDR6RnXOAFBbm2E4OjJtv7qSA0FDisBQ=;
	b=aetZwxn584rQi7iCWq6r9IduUzoH5/+mJ9kJJc86MZ0XCgG9wBqmMtE/jKFfWSLlUExgV2
	UUZO3ootpiiNOJEAN7/6kCSGTc7Nt/sfvR5+LLNmm0bm7s0P/jVQzdIO0bA7AdWZL/fGYX
	aZI4TWL0LnhUib4z3LA4bz1Ij4W94hI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32E1113354
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 06:55:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GWxDNHTfj2oiXgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 06:55:48 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: qgroup: mark qgroup inconsistent for more
Date: Thu, 27 Aug 2026 16:25:28 +0930
Message-ID: <cover.1787812966.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Commit 011b46c30476 ("btrfs: skip subtree scan if it's too high to avoid
low stall in btrfs_commit_transaction()") covers the most common case
that can cause a long qgroup stall, where a large subtree is rescanned
when dropping a snapshot.

But there are more corner cases for the same long qgroup stall:

- A qgroup rescan is queued immediately after marking inconsistent
  The new rescan will immediately revert the NO_ACCOUNTING flag, thus
  still results long qgroup stalls.

- A subvolume with no shared subtree
  This can still queue a lot of workload into the current transaction.

This series covers both less-common cases.

Qu Wenruo (2):
  btrfs: reject new qgroup rescan during subvolume dropping
  btrfs: avoid long stall when dropping a non-shared large subvolume

 fs/btrfs/disk-io.c     |  4 ++++
 fs/btrfs/extent-tree.c | 11 +++++++++++
 fs/btrfs/qgroup.c      | 29 ++++++++++++++++++++++++++++-
 fs/btrfs/qgroup.h      | 15 +++++++++++++++
 4 files changed, 58 insertions(+), 1 deletion(-)

-- 
2.55.0

