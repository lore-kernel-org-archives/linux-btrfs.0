Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4782F1CFBA
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 15:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776180649; cv=none; b=n4Sio7CYD0apA/+NzbSLWVNoY5Y4gbMQlZN32oD9Rykt/s/0St2S2zKbNEQVJrXbwyyuYLjKhGcTEZhQauPaFD4SOc3eolp2q4utdjEaPqd+YGyqa75vZAxLhN1gusRIc5mXg3qCqTo2f7T7Kia0F0iC2gFdX7rc4tSTlUIyg/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776180649; c=relaxed/simple;
	bh=kuBRJ3PnYH/nfWK5dex3Eb2Fcpb44vs9TSg0FPFlKfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AC5zTRYaODOPe3XeXiH7wANxf4GW34imjovPQp9lqL6Nl647dqZ6zLhhIaJb6K2sVGIv1CqlB+h6cClbgJqn67hxu1zeAZt+27qSAPAfTb0TNW7Np+S/kiyNBGyLgoba/rfTB2hKBdHpeIShTZbMQQy6DPpeI9z1AyzCBb4ZYAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VhqOzQAz; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VhqOzQAz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VhqOzQAz";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VhqOzQAz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A36405BD20;
	Tue, 14 Apr 2026 15:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776180646; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OyLpj++vQDiZWMGvGeRvJ3XN6jgcqLgfmQzNkqJsGiA=;
	b=VhqOzQAzgWB76+18BqyX+Oy51tpBIXuL6c2AmEgmnol5h2udMOl79LXTXLu6mNHcJTQ8MR
	b+SIc0GCy59yTM+bhGGFByieH8a0KBgx3BJ3KThSfuWCesiw4q9EXrxXjjgygls/mtQuEC
	Vc4HY9pQTAYV6ZgcnI7T2nI559pU5HE=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776180646; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OyLpj++vQDiZWMGvGeRvJ3XN6jgcqLgfmQzNkqJsGiA=;
	b=VhqOzQAzgWB76+18BqyX+Oy51tpBIXuL6c2AmEgmnol5h2udMOl79LXTXLu6mNHcJTQ8MR
	b+SIc0GCy59yTM+bhGGFByieH8a0KBgx3BJ3KThSfuWCesiw4q9EXrxXjjgygls/mtQuEC
	Vc4HY9pQTAYV6ZgcnI7T2nI559pU5HE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B6154B4F9;
	Tue, 14 Apr 2026 15:30:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jxPSJaZd3mkMPAAAD6G6ig
	(envelope-from <dsterba@suse.com>); Tue, 14 Apr 2026 15:30:46 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/6] btrfs: move condition to WARN_ON in btrfs_set_delalloc_extent()
Date: Tue, 14 Apr 2026 17:30:29 +0200
Message-ID: <7356ac53abc4d0f69827f1f579c62c71df1a1f33.1776180388.git.dsterba@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776180388.git.dsterba@suse.com>
References: <cover.1776180388.git.dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

For a simple if + WARN_ON we should use the condition directly in the
macro.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1e8e9a3d2d3090..247299d0860139 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2656,8 +2656,7 @@ void btrfs_set_delalloc_extent(struct btrfs_inode *inode, struct extent_state *s
 
 	lockdep_assert_held(&inode->io_tree.lock);
 
-	if ((bits & EXTENT_DEFRAG) && !(bits & EXTENT_DELALLOC))
-		WARN_ON(1);
+	WARN_ON((bits & EXTENT_DEFRAG) && !(bits & EXTENT_DELALLOC));
 	/*
 	 * set_bit and clear bit hooks normally require _irqsave/restore
 	 * but in this case, we are only testing for the DELALLOC
-- 
2.53.0

