Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795576538;
	b=jwqPepXtrjAWRkH83YZw4RzEPXRUhmRZkIJ87lJvQ+/el1AQa8jtk4bw1uxlxAzd02bi
	 jycMVPAt76kVo0eNpvwhwDSPXhNM0pTSR3/qOuQaU4vmLGip7n+j5whS3dysuBQTndN8m
	 fsONnB55veGpS2C/gesBexxqvlqYyKKiczX5w4sT1/o24g1OOymoy+4tPlPCCTQdudygS
	 ISODSHyRH8U8y5+Sy9xzA3tVL8PbkEC0pGIcnOcP+sMjU5dt0iVL7kjutFsiv+odwzwF+
	 onn6S0BSBcCGVq0SxCrTN/A1eo6NL3GEcAZd2ArRKim90Q/pOYsHKfhFr/pQn3LQFKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795576538;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=fDtqdSV+V0Cz45SHA3t7E+5erBYHWMOWU0xWtsZG5MM=;
	b=HpcFIsIrkZiBKPs7hRvQ8PBT6pK5P82tIK7Dk7CvFh9Bg46mUHvJ4u1PKYBmp5F4cEFO
	 1odxXphkkBBifyoPWfk4gUDA3H5yvIZOpqF2ihsvZOLTUGeeHbdZEPeP6FPzvZfqrOdXr
	 Wt+lFfGYOPJ1XislZ5r3/q4i4/5NWFkelpIQ6FlhlFkmgWmSLkii22KOKQWLfP1gbCbF3
	 BjYpyExvGMS0DvrF3e8cbWk7SvHBcMmMubAKeC6oEd6q+YJl/NGrdvVe0mCyOEOTdZdpC
	 Vz6z4MwKown/UYN1+S855ztHhQfDNC4yRqGC4Mp7Ijp+74dOg6ygfUFQiNhdSPMG5GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=tQkcgzUJ;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ige+8exp;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F11606A329
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 03:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3F11606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=tQkcgzUJ;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ige+8exp
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DCDDA1FBB6
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 03:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795576536; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fDtqdSV+V0Cz45SHA3t7E+5erBYHWMOWU0xWtsZG5MM=;
	b=tQkcgzUJnJS3qRMRcQi8Sz+lMPtgZWx4FsIcBXVRp2UF3fHESOgAmw3fMr8n3f8xM/3AtI
	XbdTDaQC4E1A8w6yViLxTvMW4sxxpujuBI4zhPN5Q9iki3npUYq3PMmrli//E11HownX3k
	VGL3WMt5h6YeHKI2S+W8rBw3q33Pesc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795576535; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fDtqdSV+V0Cz45SHA3t7E+5erBYHWMOWU0xWtsZG5MM=;
	b=ige+8expTwDgDqQCoSgaeHimfMKQTGLzh+GV7+hS1JrHFG4zJpyhuGvvcIqjn9253/E9jm
	aONsO6OuM6X8f7eh2l7AyCDuvqumP0OleCVuO7i/4N2FDEe1sx9NJChtB8PB4DUG+2KpiF
	+IccYHHhuDRZnJ2Cb+qJ1QqO+8kTiac=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C43B41339F
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 03:15:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id b3N0L9JSBmvBMgAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 03:15:34 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: backref: reject direct parent if the current level is maxed out
Date: Wed, 25 Nov 2026 13:45:12 +1030
Message-ID: <6e3b33445364d7d0f4b95323e51ee2cbbee28aa0.1795576387.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <cover.1795576387.git.wqu@suse.com>
References: <cover.1795576387.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,sashiko.dev:url];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

Similar to the check in handle_indirect_tree_backref(), in
handle_direct_tree_backref() we have a similar problem that if a tree
block at level 7, searching for level 8 parent can lead to
out-of-boundary access for btrfs_path structure during tree search.

Fix it by rejecting such backref walk if it's not self-parenting (e.g.
reloc root).

Link: https://sashiko.dev/#/bug/linux-e90153be-7335-4621-9d72-6316f96cea82
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/backref.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index a0fb90b7a9ed..e8c299e1c010 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -3221,6 +3221,17 @@ static int handle_direct_tree_backref(struct btrfs_backref_cache *cache,
 		return 0;
 	}
 
+	/*
+	 * Self-parent already checked, and if we're at MAX_LEVEL -1,
+	 * there can not be any higher level parent.
+	 */
+	if (cur->level >= BTRFS_MAX_LEVEL - 1) {
+		btrfs_err(cache->fs_info,
+			  "tree block at %llu level %u can not have any parent",
+			  cur->bytenr, cur->level);
+		return -EUCLEAN;
+	}
+
 	edge = btrfs_backref_alloc_edge(cache);
 	if (!edge)
 		return -ENOMEM;
-- 
2.56.1

