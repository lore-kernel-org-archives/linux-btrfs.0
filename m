Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BC43AE196
	for <linux-btrfs@vger.kernel.org>; Sun,  3 May 2026 09:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777801702; cv=none; b=VvsiJITULP+wEO5HnZW5Y+fQAkkB/2HW8RdC1AgO1L7KehNF7l68AciNHuJubiajPH7l0rj9/1ay/Sr+laCPjbmgHtqYrfz3LcdpKLppxKlLsxyZD21M1Iiz2X19e+V5emJ7GcLciF9t/qjKFeL8SLFChhkieXIhu9suFOv62BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777801702; c=relaxed/simple;
	bh=L2DAkIkIX/1waNhX1JeO0X5SlaXVkA1SYo3E9Ti3wTE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=e+rBrf2vOCnWKkpk4uXcDHxFWZ1Avt7dOf8TRzHuKc7A91bnxaX8tE+uPc5XcjS+dKwn7hzB6AC0dQswXj++/WjNAP8K/qjS6qKXHcbkrhoWzHbk+I6uz4K5xsdQfcjtLDr8s6SXakHonJUWlKi/YzhyfABI5f9OxrfUrEdrcRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aWm04yLM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aWm04yLM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aWm04yLM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aWm04yLM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C97896AA41
	for <linux-btrfs@vger.kernel.org>; Sun,  3 May 2026 09:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777801693; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=naxaZIDN8v0U3X92Mpm7fC1bD5Ed3XRT0jxvrkCx+hg=;
	b=aWm04yLMv1bzLJMvmm6x0OJrpNX+iGRpMQF9mh9WLn59BFNlfqSWjeijdUAHTCvK1fJBcf
	PQXtnOPxeP4Ey/2SlqCroLvwbPoPpq5+bgrUVYcNghvNQ6tQ+TlcQ0GlAuLNcWYrGeVC3u
	NemVJFw91vbykzgFS5/qlDACT4gWzgY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777801693; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=naxaZIDN8v0U3X92Mpm7fC1bD5Ed3XRT0jxvrkCx+hg=;
	b=aWm04yLMv1bzLJMvmm6x0OJrpNX+iGRpMQF9mh9WLn59BFNlfqSWjeijdUAHTCvK1fJBcf
	PQXtnOPxeP4Ey/2SlqCroLvwbPoPpq5+bgrUVYcNghvNQ6tQ+TlcQ0GlAuLNcWYrGeVC3u
	NemVJFw91vbykzgFS5/qlDACT4gWzgY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 057ED593A3
	for <linux-btrfs@vger.kernel.org>; Sun,  3 May 2026 09:48:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CN0NLtwZ92mUPAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 03 May 2026 09:48:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: simple cleanup around
Date: Sun,  3 May 2026 19:17:49 +0930
Message-ID: <cover.1777801546.git.wqu@suse.com>
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid];
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

The first patch moves and unexport the function.

The second one open-codes the function into the only caller, and
replaces remove the need for @offset/@length usage.

Qu Wenruo (2):
  btrfs: unexport and move extent_invalidate_folio()
  btrfs: simplify the btree folio wait during invalidation

 fs/btrfs/disk-io.c   | 30 +++++++++++++++++++++++++++---
 fs/btrfs/extent_io.c | 32 --------------------------------
 fs/btrfs/extent_io.h |  2 --
 3 files changed, 27 insertions(+), 37 deletions(-)

-- 
2.54.0

