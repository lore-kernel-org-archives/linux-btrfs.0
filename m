Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493E1381EAF
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 05:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790831821; cv=none; b=ifHUzcuW+xNdUgS5UtM8djz2r0Ltjc7jNAWTSFQzkDMnn91Ex5Ze+LqQb2gs+/3AuX8tAbvfaDIhYd9DxDLKkljmaZkTAHMEVWid21PF3wZywOHSoKZl30otQJBkzcTy/M6tzlH2v9INQwWaDH94Lu7ylSE9tondisCO7Qj08Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790831821; c=relaxed/simple;
	bh=N61lY7ldL9UH/YdtV0ew50M3uYb5B8H43FzaSmvI/cA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VStOWBKlIPAai8vz7ZUTsMfOUy3nwZhdv36Mit+nWU8MTXdO/+dwVlsEZAq8iBUVF7krSZeZK3zU9Epa/vZuNpryW1+QBSRrR8Knwn5QrymvqVQf5I5KntpuGPoIfh7FdJbG60arRY+wYbyI6dqsG8McBacEZeuFKFd0V0Uzhl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sgSPrmvB; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QUzOFFCM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sgSPrmvB";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QUzOFFCM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D80E91FCCD
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 05:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790831813; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXYKgjynE3v7paa/qitz2XFMtkiXFtANIuM25SsFEi4=;
	b=sgSPrmvBpeM0a9lXxLZsgfyCtyZIP52Y8OStkVzvhxxBV5LomPPuisAWCFuFqNyRkAYqBI
	YWEPhMLVj73/5Jol2SL+jvbPs1ovZbD5B2Zg/GFTyZA+7AmSCax/NHJ5WLEfvgRyThHHcc
	crDeawckd0tXL5GQzIvUYObhbquhFXc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790831808; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXYKgjynE3v7paa/qitz2XFMtkiXFtANIuM25SsFEi4=;
	b=QUzOFFCM1OEuSwBJV8Ey72Uha44hqSTdrhGL/oevyQ8c0To6RLRRgzwcsvj84rei1tHKzQ
	H1ENhxnFzdMm7BFywpCxdwdtlSvO50rmC6CFTBIy2caDln57z/uk/jweR+t6JWdlbRG/uL
	xwwqUggzXpBXMzl0Xyfu3grRfpuAyW8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 94C23134B3
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 05:16:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aRXOE7vsvWrVGwAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 01 Oct 2026 05:16:47 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: qgroup: use qgroup_mark_inconsistent() in quick_update_accounting()
Date: Thu,  1 Oct 2026 14:46:16 +0930
Message-ID: <d50d910c5b342d7cb3f60ddca35ac8f518bfab7f.1790831600.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790831600.git.wqu@suse.com>
References: <cover.1790831600.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.19)[-0.974];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.79
X-Spam-Level: 

When quick_update_accounting() fails to handle a qgroup which is not
fully exclusive (its exclusive number doesn't match the reference one),
we have to mark the qgroup inconsistent.

Unlike other locations we didn't use qgroup_mark_inconsistent(), thus
when such problem happens no extra error message is shown.

Use the helper in quick_update_accounting(), which does not only show
the reason of marking qgroup inconsistent, but also cancels any running
rescan and skips dirty accounting, avoiding wasting CPU time on already
inconsistent qgroup numbers.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index dfe3827ec369..d3401a6df530 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1562,7 +1562,10 @@ static int quick_update_accounting(struct btrfs_fs_info *fs_info,
 	}
 out:
 	if (ret)
-		set_bit(BTRFS_QGROUP_STATUS_BIT_INCONSISTENT, &fs_info->qgroup_flags);
+		qgroup_mark_inconsistent(fs_info,
+	"unable to do quick excl updating for qgroup %hu/%llu, ret=%d",
+					 btrfs_qgroup_level(src),
+					 btrfs_qgroup_subvolid(src), ret);
 	return ret;
 }
 
-- 
2.55.0

