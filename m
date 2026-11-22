Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795388424;
	b=VY2CDn5C4mI1hpd7yjxVds2RGZxuCuJDih9/cE9CTlhZY8uR1NtQ+jsbbnrubqAX35AR
	 ujhqDN6mn8NFqbyzGm3bijA7Hnxyp728a3XN0DpdYGHPSthNghNHGDxuHhxsECVi2X1x/
	 03mpBjHIgITgIw3IpJS80MMfH51jvLkakwEeLMgx3n6Kf5Kl+J5cuO3x4owakJ60TOwP7
	 VitFTRl3OXsAKRfTCtJf3gzJHb4tZzp2KUgepXYds76Ny3sp/QvGEiLldHXR0pYM7avZf
	 BKYQy/yDmfchRKN5TVWuFNigXwOGKOt340JK5DQcAKbDtB1LG+dW8CVVvpJ7K7eBZ4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795388424;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=MTYj7kLfKAvGzw4WbLZ0pB2ECJuW+lquVIQjiDXqmAA=;
	b=jvFt3DRAvNQy0Mi9XFUgn12R7ymLkBEH3pVDwRUDcUFYllOxYTD0f+CaFkwwPXCmKNEJ
	 xR24JUUkVfUkiXBI4x2R67ThPX7dWr0D3QHk/4XOYErX4XL4aKK6/z8cIVXhubGCwiGY6
	 y6+b7nKkzhEQwRAmo0gfAHDI6GI3vS7q0XiD4cLVYmLIB+WH1LNDbcwkNGppYpEBb9hJA
	 o2qp/8fZ4GX/0FyV1azTY+U2ERskMkZbl8xpo87EITK8jc/oAQc36qi3+7Spr6n4ctz2B
	 M4ud95rpNR6JC7NvqYBrMfx++5RM2qeWi3uq0huENf3xMM2AncMzpHYNIRplqCYLsqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=lM3bSSkU;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=lM3bSSkU;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7719E606A32E
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 23:00:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7719E606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=lM3bSSkU;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=lM3bSSkU
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B1DED1F44E
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 23:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795388421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MTYj7kLfKAvGzw4WbLZ0pB2ECJuW+lquVIQjiDXqmAA=;
	b=lM3bSSkUmfLhLEn8mRab6MxpO/XU6gzCxdCXgNh7atsrEk4p9StpyYp0QjlQxsj3T3dUiQ
	x/xCq5W+kVstBVOP3y8eWwOm7nKPuSulh7yz/xdE+Pq+PO1voQZn9v8/cHKM3zUPHpb7Wr
	59VTBzy27aP44p8lgIpchR9wXlfpl5g=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795388421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MTYj7kLfKAvGzw4WbLZ0pB2ECJuW+lquVIQjiDXqmAA=;
	b=lM3bSSkUmfLhLEn8mRab6MxpO/XU6gzCxdCXgNh7atsrEk4p9StpyYp0QjlQxsj3T3dUiQ
	x/xCq5W+kVstBVOP3y8eWwOm7nKPuSulh7yz/xdE+Pq+PO1voQZn9v8/cHKM3zUPHpb7Wr
	59VTBzy27aP44p8lgIpchR9wXlfpl5g=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 98F3413510
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 23:00:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PE5SCgJ0A2v8PQAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 23:00:20 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: reject too high tree level during backref walk
Date: Mon, 23 Nov 2026 09:29:58 +1030
Message-ID: <95c15a8e7aaff788ba9582186c2345db7cd52dfe.1795388358.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <cover.1795388358.git.wqu@suse.com>
References: <cover.1795388358.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
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
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

In handle_indirect_tree_backref(), if we got @cur->level set to 7
(the max level valid), @level will be 8, then later path->slots[level]
and path->nodes[level] will all go beyond the array boundary.

Fix it by rejecting such high level before calling btrfs_search_slot().

Link: https://sashiko.dev/#/bug/linux-8a4f92b4-daf7-4f57-8369-8e6ef323652f
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/backref.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index a0fb90b7a9ed..d56476b21fe8 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -3316,6 +3316,11 @@ static int handle_indirect_tree_backref(struct btrfs_trans_handle *trans,
 	}
 
 	level = cur->level + 1;
+	if (level >= BTRFS_MAX_LEVEL) {
+		btrfs_put_root(root);
+		btrfs_err(fs_info, "invalid searcch level %d", level);
+		return -EUCLEAN;
+	}
 
 	/* Search the tree to find parent blocks referring to the block */
 	path->search_commit_root = true;
-- 
2.56.1

