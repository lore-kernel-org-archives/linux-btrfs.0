Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701229;
	b=o6soljZLMqSydlLVS+twfp0w/gDyX94vl0Mv5e8yuKcgJOQJgX9z7ztWlLaSq+nB+61A
	 nCkK7X+4NoZXu+epwo+S54qTxJpo/9jNnxoCzDxcCOLT9GB/oPOxpw5izH8wnQZwB9d2N
	 0dLJnAcdDAV790l24S8wC9fvEnZzrCT8usNcO1fYBK4SICG7VW2csCmBu8/MNOWKKUT1o
	 vMzZAp03qYuULiDIb/UJx5OoCsOxB1+LecBXyd46G/01kZeP1q3zDrCiw0bMZLNsinLNL
	 VfRJ5rQwXIr7SxN2AtV855CJLDHrkgORBPJgd9LL2ZxnOcE8Vuu6SmNgHLOtTIOamrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701229;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=ZbHZ3N6vq5oUAUSDvCpLbI+tSjNEcwMYQgvW4jMUXFs=;
	b=429Zy2r2m5rcRy0lgxPLZyjOx87v5zJeccS5p5UblEV8yc2qJ9VROmXK2pxmbuAlyT9i
	 vT456fql0tlozK/23hFoWCCp9RI3mXYIwmuBWoPUDVDQDYs7tVxfa7BjymZrd682bDUxr
	 JDC1bWfRDxd+UBw/D98ZeJy6BoYq189F9M54e2kSTKF3Vq5oLM2dQ1k6d97YW94NRUe0o
	 Lb48s3MWCYXgwgcOA1/pspc9ka2byX1Jf4dYihUHAfzTKfj1nissZaTZWdSYbv2YwwIpQ
	 axxA5VI8s8nx0ep9eY70yJfr920Olk48gFIWC/ZZqSmQpTfsS4iDhsF5DK7FXXDhiEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Fgg4Xgsq;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Fgg4Xgsq;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6430606A326
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 10:20:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6430606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Fgg4Xgsq;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Fgg4Xgsq
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0C1C21FBA8
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 10:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793701227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZbHZ3N6vq5oUAUSDvCpLbI+tSjNEcwMYQgvW4jMUXFs=;
	b=Fgg4Xgsq7n8c+R005UC21rM5A3xYibnkjOjtx4x+xwlwPkT7eA9UtT+WQmBrOOjPJOYjol
	6aE9WE4i7P0CKeaNuNP+ldcg+l66Co6vQUo8hZFGpVJI8UIewaabtTBvPp2PkkPfANbu1J
	c1mVUrpZ77SCywJwvwJOJQ8X+MFajNU=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793701227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZbHZ3N6vq5oUAUSDvCpLbI+tSjNEcwMYQgvW4jMUXFs=;
	b=Fgg4Xgsq7n8c+R005UC21rM5A3xYibnkjOjtx4x+xwlwPkT7eA9UtT+WQmBrOOjPJOYjol
	6aE9WE4i7P0CKeaNuNP+ldcg+l66Co6vQUo8hZFGpVJI8UIewaabtTBvPp2PkkPfANbu1J
	c1mVUrpZ77SCywJwvwJOJQ8X+MFajNU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E68C61350A
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 10:20:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LthdKme16WpgfAAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 10:20:25 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: return error if btrfs_next_leaf() failed in do_list_roots()
Date: Tue,  3 Nov 2026 20:50:03 +1030
Message-ID: <e94aa34d8144a66f8568104c225cdf634512348a.1793701174.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793701174.git.wqu@suse.com>
References: <cover.1793701174.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

During the while () loop, if btrfs_next_leaf() returned an error, the
loop is broken, but still return 0.

Which is not the correct return value.

Fix it by properly return the error if @ret is negative.
We need to intentionally ignore @ret > 0 case, as that just means we
have exhausted the root tree.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds/restore.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/cmds/restore.c b/cmds/restore.c
index 77de65bf1528..ac00faac1d02 100644
--- a/cmds/restore.c
+++ b/cmds/restore.c
@@ -1199,6 +1199,8 @@ static int do_list_roots(struct btrfs_root *root)
 		path.slots[0]++;
 	}
 
+	if (ret < 0)
+		return ret;
 	return 0;
 }
 
-- 
2.56.0

