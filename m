Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861F02DBF40
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Feb 2026 03:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771558918; cv=none; b=ciCzTT0Mo+FLQHZW1ghuFbSJ704KEhF30jepfx+2Dnor+uoO2OEdVMiwIg0y7HKH1bbimdFDdktRUCwYLarOahICdLDg8iYo4irM1Dc48cLpOCRW8pT/JPROsMTt4WVtRPnA4J59EQTAgQhwU11eQWD/tLeXdQXttcAgCvCfJjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771558918; c=relaxed/simple;
	bh=2eLfhcCpNR/KKfJ4eVibuncp1nZpHEXQu0xLzNkPo3U=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=uIxhHli5l3ypPQq/unVByCuHw0W+pEd9VK/uZSdJvgSdxDI1ZoL3nz0KPeZamOmRGgYKver+6Nu1Kp1CffGdh/GKa1FujdEuDx2Djj59s5bu97nACUNnZhkz9lU4ojFHTyRFQhOnDs1hWQMIqWSXn2fCuBc7nfYjOhKoIkRsHgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QO6dMj9N; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QO6dMj9N; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QO6dMj9N";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QO6dMj9N"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A92465BCC1
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Feb 2026 03:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771558915; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NxGy+bzTWgc3sYMtmNMTcAolhJRireHbrk3GzJr1Xj0=;
	b=QO6dMj9NEd8PSU4oJa7MNXTSBV/88URrADGF9EFqDJoFu3bY9MGyEAHY+qsJ9RTQy/EhfF
	Izt4a6NATBuMQSP8h8snfNVT6ZemP77I3+XrJzBMHpCPH4NPH7ueatOXtEHZfVPy9ngCPo
	5wAQ/1wFTCXwYx9b4LOZBmuOKopqYYg=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771558915; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NxGy+bzTWgc3sYMtmNMTcAolhJRireHbrk3GzJr1Xj0=;
	b=QO6dMj9NEd8PSU4oJa7MNXTSBV/88URrADGF9EFqDJoFu3bY9MGyEAHY+qsJ9RTQy/EhfF
	Izt4a6NATBuMQSP8h8snfNVT6ZemP77I3+XrJzBMHpCPH4NPH7ueatOXtEHZfVPy9ngCPo
	5wAQ/1wFTCXwYx9b4LOZBmuOKopqYYg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC3063EA65
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Feb 2026 03:41:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gfHbIgLYl2nODgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Feb 2026 03:41:54 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: remove compressed_bio::compressed_len
Date: Fri, 20 Feb 2026 14:11:49 +1030
Message-ID: <cover.1771558832.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
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
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

That member is removed in the 2nd patch, the 1st patch is a minor
cleanup to provide a common helper to calculate the bio size.

Please check the commit message of each patch for details.

Qu Wenruo (2):
  btrfs: introduce a common helper to calculate the size of a bio
  btrfs: reduce the size of compressed_bio

 fs/btrfs/compression.c |  2 --
 fs/btrfs/compression.h |  3 ---
 fs/btrfs/lzo.c         |  7 ++++---
 fs/btrfs/misc.h        | 15 +++++++++++----
 fs/btrfs/raid56.c      |  9 ++-------
 fs/btrfs/scrub.c       | 22 ++++------------------
 fs/btrfs/zlib.c        |  2 +-
 fs/btrfs/zstd.c        |  2 +-
 8 files changed, 23 insertions(+), 39 deletions(-)

-- 
2.52.0

