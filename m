Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEF430499A
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 15:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776180648; cv=none; b=NW+mFymY4VPrLpwIJ921Nhq6V8PWEZT7Pju95hRcn87f7MMbdiDVUiO2wfYU3Xx8c9PV03+TpT2OSHHghE4LR52qOdjW8iIw+Xcbsg4rhkPXy15cnZVlW8EdbKq8jaOpQ5Wb2G524sLLlEwGSUwmAq0bZxkWkYlha79aOag4axY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776180648; c=relaxed/simple;
	bh=UXZknhsuOTzSzA45tpGr1kyoYUwYxIG/GZhRYEZ7Phg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F7RyscQ2RVnl2Sf/i2Df6PBclBkoFTlVXlUll0bQM6NjoOApsfobVflhpPfOBsI/Z1TI5ZUjt08U1x+/ZEOHVxFVWFFmyhbtgFE0twp8LoWB3kudCWrwYCyM9aWZMx4lakYncIK3/YRfT8WuPclnRry1b/gfDc//VeXFryNxhSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tWko3vnK; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tWko3vnK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tWko3vnK";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tWko3vnK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5D8146A7C2;
	Tue, 14 Apr 2026 15:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776180640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=bg9Y7FMhFwrPqdIW/zDvgRHXW6anvXIgkzHNtJfNTCE=;
	b=tWko3vnKQ4LXSTq4LTl11riL+BfVVKkCXDrNJ+cGCScMUDpgY4dhaK1CHYdaDqlxPT4CnD
	m+FySZNKgDNHt47BW6mS1FLwPt0eRdcQGAbTPJ+ZX8R0YU1dwFF5nAKACzXQtVYJDHBpMp
	ZPDwJLM5mGAoly4GFnoaO77mrQaVY4Q=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776180640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=bg9Y7FMhFwrPqdIW/zDvgRHXW6anvXIgkzHNtJfNTCE=;
	b=tWko3vnKQ4LXSTq4LTl11riL+BfVVKkCXDrNJ+cGCScMUDpgY4dhaK1CHYdaDqlxPT4CnD
	m+FySZNKgDNHt47BW6mS1FLwPt0eRdcQGAbTPJ+ZX8R0YU1dwFF5nAKACzXQtVYJDHBpMp
	ZPDwJLM5mGAoly4GFnoaO77mrQaVY4Q=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 574664B4F8;
	Tue, 14 Apr 2026 15:30:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id L3BGFaBd3ml1OwAAD6G6ig
	(envelope-from <dsterba@suse.com>); Tue, 14 Apr 2026 15:30:40 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/6] Debugging macro and kmalloc_obj* cleanups
Date: Tue, 14 Apr 2026 17:30:28 +0200
Message-ID: <cover.1776180388.git.dsterba@suse.com>
X-Mailer: git-send-email 2.53.0
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Replace some macros with existing or new API. Replacing ASSERT(0) in
free space tree updates error handling but it's for "impossible"
conditions.

David Sterba (6):
  btrfs: move condition to WARN_ON in btrfs_set_delalloc_extent()
  btrfs: replace open coded DEBUG_WARN in extent_writepage()
  btrfs: handle unexpected free-space-tree key types
  btrfs: lift assertions to beginning of insert_delayed_ref()
  btrfs: do more kmalloc_obj()/kmalloc_objs() conversions
  btrfs: convert kmalloc_array to kmalloc_objs in
    btrfs_calc_avail_data_space()

 fs/btrfs/delayed-ref.c     |  5 ++++-
 fs/btrfs/extent_io.c       |  2 +-
 fs/btrfs/free-space-tree.c | 18 +++++++++++++++---
 fs/btrfs/inode.c           |  3 +--
 fs/btrfs/relocation.c      | 10 +++++-----
 fs/btrfs/super.c           |  3 +--
 6 files changed, 27 insertions(+), 14 deletions(-)

-- 
2.53.0

