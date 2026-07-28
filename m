Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341913AA182
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 06:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785220779; cv=none; b=ODbfJRx+vhSCzQY/1E+nQ39DdqyYYiKZJvGUZv/cB4AD7z4V5k0iR9sA9R1LtaFOqP4aNR+gZPN5d/W2ZUZ6/rLRdynClDJRL0A7SI3cK7A+NZlgE0DvPMfqZ60CLdeEtod6ZOHRFf1PjH9UbfuUizW/4yRYmg3nU3ODcN09S3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785220779; c=relaxed/simple;
	bh=Ir2Hub7zvisuhIFqbYdNozP6IQGp57wxSOiKGS3u5Q0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VEnjGpvhRVZY8/CDDs4vObLUQFByhDh+H3KGYH3nL/qFfH5YQ4O2bxdKJRV8TmJJZo4U7Ok0YqSJSIKI80+2ifQivHLt8eW0gh9/fSQtO/z/sKgLxoIme002WzqUBJ1cuFZ6L3SkmFmeiWuy5vd5nH/5lQ+CfGhV6w+OKvIjpxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=r/MAEHYn; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LCKMlSi8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="r/MAEHYn";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LCKMlSi8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B58923E18
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 06:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785220771; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MfoI5Y020SrWeR8nWHf8Gd/az0dYrspeEqcJB6bhBKI=;
	b=r/MAEHYnPJ3oOffOMf7KHIXt0lnO0eFgzpjTiU+oYScsY5X5W4RNJpOG+o8xg35qfT/ymy
	VR4wVori082xzTa2G/XaGkkJz008/t3KEBhHCdkAxpZeEncWAI3tmRozur0eYg6efQ1mcY
	xaG+MHO00GgschwlfbbAchbQYzpfG4g=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785220767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MfoI5Y020SrWeR8nWHf8Gd/az0dYrspeEqcJB6bhBKI=;
	b=LCKMlSi8f1p5BNPDSnsLyNmcmqW4PnxWurq6s7qnMBQ121a6sRnKnmAJJAabMZNQb/BR9L
	LF4m+vNnJJvSqouTzj7SIu/VcPx7Aunk5+jAV1DjEfc1jRnEJvoGMeH6ZoDsue8TCqOAzY
	ECCqPzTvtgaYs9ERFOVDfMH4ba0rtno=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC881779B1
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 06:39:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id A1PKFp5OaGrkSAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 06:39:26 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: add basic alignment checks for extent_state
Date: Tue, 28 Jul 2026 16:09:02 +0930
Message-ID: <cover.1785220613.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.992];
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

Commit 3f255ece2f1e ("btrfs: introduce extra sanity checks for extent
maps") introduced sanity checks for extent maps, but for extent state we
do not have any extra sanity checks.

This series will introduce the check in the 2nd patch, meanwhile the
first one is to fix an exposed unaligned access in extent_fiemap().

Qu Wenruo (2):
  btrfs: use proper inclusive end in extent_fiemap()
  btrfs: add validation for extent states

 fs/btrfs/extent-io-tree.c | 21 +++++++++++++++++++++
 fs/btrfs/fiemap.c         |  8 ++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

-- 
2.54.0

