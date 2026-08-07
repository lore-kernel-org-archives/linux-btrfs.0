Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935CA394792
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2026 09:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786095529; cv=none; b=eauHZBVzHt7pa+LH64qa6ZOsPiGtiJGqKerq4TZuG3RFiBOsiFSgRhAs+eD6wVQVbqZVGSuuFzQGdbouuUR+/BtgS32Ehnm28R8BhcAxASha0Hcnuf0RIDHNHV4b08pOkjTN0US6psYz0Klg8XoSdQdspAz5IBJZeOQnAYHKxLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786095529; c=relaxed/simple;
	bh=OML0ov7Emox5Ks5AXaUUiJNNzOXoA/tBCdni167uM5g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=CcId6dmfixekl1zqbAWzD2jOrmMAn/jws2/a63s+gRBOvm40oPkDblctn5V3NmmUI+T+csiibG8jOqfzx2teDULl562niNpT7MXmf4R+81KkjKdrNG7mGuExiBBf3XkoTD7ZA0ZRNvF1QsEjzq1PS3z72zkDAIY384B/nTjo+Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=boPcx7I7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VOb0NV11; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="boPcx7I7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VOb0NV11"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6442B3E0D
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2026 09:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786095521; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=24hJ6TzBgzhDz5qxn49l4FHeDZ9FAP44bDUr3Px9CKU=;
	b=boPcx7I7JsPYV4gwcg7P94HPiq/bCvXq0Ii9R6VkNDoryj4Yk5v7sqCKNxaduSidy/oFgY
	PnrxytHfTC+sd2ko0fUccVui4wtYoI5HzFJ9ix2kuWYtAQJUylEQqRA0u0/pCmLnkw0AgC
	GoCT/4FhLkx+I/Hroz5q0uQuq5fLQKw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786095517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=24hJ6TzBgzhDz5qxn49l4FHeDZ9FAP44bDUr3Px9CKU=;
	b=VOb0NV11XTg1ojTN4UDXx5F+qh1Xgb0XWK3vzmhgHUYfEfYQwHgHhE1MFU1LkKgtOFmVoh
	acDG6Nm4Kfn+QGluasXkgcDV0fQ11FFwm9d7ffJd6AgwihFu2SW8qtKCS+S3Hmu/8vf5xh
	FL+seaxlHTFCZ47skZGklPMK88E4wcc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6AD0D779B6
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2026 09:38:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CRQVB5yndWp0EwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2026 09:38:36 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: minor cleanup for subpage helpers
Date: Fri,  7 Aug 2026 19:08:07 +0930
Message-ID: <cover.1786095309.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

The first patch removes dead "unlikely(!fs_info)" checks, as commit
b2136cc288fc ("btrfs: tests: allocate dummy fs_info and root in
test_find_delalloc()") has properly allocated a dummy fs_info for
extent-io-tests.

The second patch is inspired by Boris' new cow fixup, where we can
determine if a folio belongs to data or metadata.
As the only special case is when the folio has no mapping. Meanwhile for
data folios they are always from page cache, thus they are always
mapped.
So an unmapped folio must belongs to metadata, for dummy ebs.

This allows us to enhance btrfs_is_subpage() to cover both data and
metadata, now btrfs_meta_folio_*() helpers are just a simple wrapper for
the correponding btrfs_folio_*() helpers.

Qu Wenruo (2):
  btrfs: remove NULL fs_info checks in subpage helpers
  btrfs: unify data and metadata subpage handling

 fs/btrfs/subpage.c | 50 +++++++++-------------------------------------
 fs/btrfs/subpage.h | 45 +++++++++++++++++++++++++++++------------
 2 files changed, 41 insertions(+), 54 deletions(-)

-- 
2.54.0

