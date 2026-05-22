Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357813C4167
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 09:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779441867; cv=none; b=lTf4aI8p45bLWSKD4P1jd/1ohXUvKPes9H8a9YOEjpVj8jOgbiqwr45u1VUxPsHeLKYR+vDbsQ9flE5OV9MZh1u0LYngUOE9IPbKZ2lsrJ1rqsw456sjtphVE8tmbeR2MNcd9M+NogVGJ9mt0m2Hn+xl3xYaeWINtJsqUZ3X16k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779441867; c=relaxed/simple;
	bh=uRrKQ7Ria7NmQ0AHhwOPJeVuZVLAp9dw8WuQ/I6KYq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9YAFAZ6i933uGsSi75RbXxXvg84TEy0/ydLZ0TGKlNThw5HzFqtIp1E4ShYOAkxLG58UcPZtNFyWNaWEGD44V5+XJhMi3mPKa9S9scpTT3bIVN6Jg4LLlBIm2IJqSeU4aSF+d+c3onjbmuJgRnVgnI+AePLbBEu0UCuCPkCUv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oSCr+hm4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oSCr+hm4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oSCr+hm4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oSCr+hm4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CC9FA67919;
	Fri, 22 May 2026 09:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779441855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vgWWOi1vUcD9OaabMwejeQHJSZlaYLEMWe0tyFCegrE=;
	b=oSCr+hm4fW7ooDl2ssD1XiNxJKaJlk//AT7sbFI5fTQCfkN4a8+Qisrap4zwK3jXOI/syS
	s8Eq2atnKy66xgnI0PrH+hc+MstaCyVmDmqNacF3EauAlEd4l6QfngTDc1SI5vM8fx/Oiy
	SCk/wV8IgxOHIEmSX2uONJSfMrxUYnI=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779441855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vgWWOi1vUcD9OaabMwejeQHJSZlaYLEMWe0tyFCegrE=;
	b=oSCr+hm4fW7ooDl2ssD1XiNxJKaJlk//AT7sbFI5fTQCfkN4a8+Qisrap4zwK3jXOI/syS
	s8Eq2atnKy66xgnI0PrH+hc+MstaCyVmDmqNacF3EauAlEd4l6QfngTDc1SI5vM8fx/Oiy
	SCk/wV8IgxOHIEmSX2uONJSfMrxUYnI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8C351593A8;
	Fri, 22 May 2026 09:24:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MNDhE74gEGoXQgAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 22 May 2026 09:24:14 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: hch@lst.de,
	linux-raid@vger.kernel.org
Subject: [PATCH 2/3] btrfs: remove duplicated block group type assignment
Date: Fri, 22 May 2026 18:53:52 +0930
Message-ID: <6bced02cf7b5bb9b844600b775ca52a434947dd7.1779412152.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779412152.git.wqu@suse.com>
References: <cover.1779412152.git.wqu@suse.com>
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
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_NONE(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid]
X-Spam-Flag: NO

In the function fill_dummy_bgs(), bg->flags is assigned twice.

Just remove the second assignment.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/block-group.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a0cb0db68c9a..41f65a3165f8 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2627,7 +2627,6 @@ static int fill_dummy_bgs(struct btrfs_fs_info *fs_info)
 		bg->flags = map->type;
 		bg->cached = BTRFS_CACHE_FINISHED;
 		bg->used = map->chunk_len;
-		bg->flags = map->type;
 		bg->space_info = btrfs_find_space_info(fs_info, bg->flags);
 		ret = btrfs_add_block_group_cache(bg);
 		/*
-- 
2.54.0

