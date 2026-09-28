Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6452C3911B2
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 06:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576776; cv=none; b=aPEyOW324ILAS3MHJuc6X0eCYDg20KNHjAGzTH2Oh0yHirz1Jub9fR7HDu0YZMQCtvQw/AAvzyveTk6Euofo7DvhoaoKCiAVq/5TB/I3qgqgFvzwpvHp9Leb0Kt89fn8XBo462x4SvrWzAagl3JCau/GeI0WMArOnq4ExZoVI+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576776; c=relaxed/simple;
	bh=Zszn6IqWH2/d5HG0SGzmfwZ/6QpYddmyavX1BThqNLw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=mwHxAki3bC6kUy88tbr0lRlaJzt3wHmWKPZibz/ffH6b5+NBkFASNZ5/mFYKA96utSoCVRWHnDmAjOOdPDCyPj9a3aloARFaaPLunyvfpxQhp/loctrkChVATTja4Kfhb2BMHjTi5oMwwwmfmLAXr38B/LvaudmiNN4IV2/HWgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=bofWDfAZ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Yt5oNGtN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bofWDfAZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Yt5oNGtN"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ECFD721D0E
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 06:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790576768; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=JY/IetVnXG3JnLbpWsEqTkbuK4H3y5bmWh4T/6VWdEU=;
	b=bofWDfAZVOg68fVcw058cwEVe5AxmwGX6duKZQAISHU9UKKp08suWqF1AqC23pcYjPE7v3
	ULb0MMcZ4URJNrtrMSWtaHdi9yja3+r1GCHz8NAB1ReoiRoR/JNZxP7QfgKPKGvOF09K+7
	t7rkhKyazLbXe0GZ5GZpJLm2qLV9OIg=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790576763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=JY/IetVnXG3JnLbpWsEqTkbuK4H3y5bmWh4T/6VWdEU=;
	b=Yt5oNGtNsyUIytnE3SEbV5U7JHq8A63VjjG1JXPef2SJO9LxHZcMjtExh3nxs0azizFgdN
	HOrELgPJD8pzto24TFclza+uI79agvrbM9WRl21fETHkPOGwr/lT39R/Qqj3udYT3V2rFf
	eXUeesCtGgf0r4SBS9nWKEc4snlbq2g=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9FF3B133F3
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 06:26:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jiQQNHkIumqheQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 06:26:02 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: go extent-by-extent for buffered reads and writes
Date: Mon, 28 Sep 2026 15:55:41 +0930
Message-ID: <cover.1790576583.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

[CHANGELOG]
v2:
- Fix the length of advancement when no OE is found
  We should still retry the next block, as there may be only a block of
  gap.

  Exposed by Sashiko on the 2nd patch.

  Although it also exposed a false alert on the
  truncate_ordered_extents_beyond_eof().
  Where all the blocks in the range should have an OE, or we're having
  a bigger problem.

Although we have large data folio support for a while, the bufferedL
reads and writes are still iterating a large folio block-by-block.

For a large block sized buffered IO, the large folio has a very high
chance to contain only one single extent.

In that case, although doing block-by-block checks is good for
readability, it's not really performant.

The series changes the behavior to do extent-by-extent iteration
instead, this can bring a very slight performance improve.

For best case scenario, the runtime to submit a folio read can be
reduced from 32us to 2.5us, and a much better distribution.

For writes it's not that obvious for the average runtime, but an obvious
improvment to the distribution.

My current guess for the lack of write performance improment is more
bio_add_folio() failure thus more bio allocations.


Qu Wenruo (2):
  btrfs: read a folio extent-by-extent instead of block-by-block
  btrfs: write back a folio extent-by-extent instead of block-by-block

 fs/btrfs/extent_io.c | 313 +++++++++++++++++++++++++------------------
 fs/btrfs/subpage.c   |  49 +++++++
 fs/btrfs/subpage.h   |   4 +
 3 files changed, 237 insertions(+), 129 deletions(-)

-- 
2.55.0

