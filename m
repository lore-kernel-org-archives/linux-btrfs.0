Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB242AD35
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787546081; cv=none; b=kDorqGmck+BrwHfmfwbBltj2XChyqJfv0J8AzbdcVlYsSnK5cQw36Xkr8CMw2jw+ySemKxCG4LMYu7wL3SVZuzEx2Gd+8tluvrMc54pPAu5IKwoRJdlpt+PyfH4hdzbQDwG+qQJWmvB5jD0DeP6/sreq+0EgHHhJDwceq64itlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787546081; c=relaxed/simple;
	bh=kDA8PNLg1i7fKsR+y9xYrt+/bN28hPvpGpOg43WgHN0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1KgiMyWOMBT2uc72nY2XaLq/W5+1/zSbjI7I919CmBmgvFac+SYDYBOxcQs1NsOc+75SEi5PEiOs3omXjVU8TIIEYbFqYUHkF6nlYeOgaySSf7DdRPZu6CcWNv0ECYIjJvGJ7UCu4olLK98wSGM2dr8uCqxrtyjakbqgYWsVyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GUVFPxR4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=S3UCR74L; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GUVFPxR4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="S3UCR74L"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F1E4F866F2
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787546074; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kAcqSY94R1kCsa+58nHoGqTPSrHDNayB8fckloED5g8=;
	b=GUVFPxR4EBb7ZB5QH8XdZd7OfLKCINM1KHZb1+3ZtzTCG3gtYtlBW5ujJcyzOcvzvR7oWL
	kgcw64pi3k7X6SNVjsIWo7kQOEaLGwH4ryNmpHyn1XX3wkX7HznWshdfRyl/F+WtE3ujfp
	8PU3dH9aSBoB0T/SygFwtPR9QNqUoQw=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787546069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kAcqSY94R1kCsa+58nHoGqTPSrHDNayB8fckloED5g8=;
	b=S3UCR74LKgd08yUimh/o6It7XVJUU8myeD5UcBZ3JLA9RmsUtUvs3gpGnzXZFmHWVPh94b
	cNRkjWVIVH2ExiAQXqGESm4FeOV0jhJu1sdNf4ywTxQL+XrXw2Dx+L+7pcXebDOThH9IGQ
	dxw0roFYU+0R/x9WAy3JNmIl9cnCkTI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E431413335
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oFKFI9TJi2p1SAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:28 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/4] btrfs: dev-replace: fix the incorrect error message
Date: Mon, 24 Aug 2026 14:04:05 +0930
Message-ID: <35da84f6e8866b95ac64f6d514894255b4e5d29d.1787545216.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787545216.git.wqu@suse.com>
References: <cover.1787545216.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

The error message for a failed dev-replace is:

 "btrfs_scrub_dev(%s, %llu, %s) failed %d"

Which is not showing if this is dev-replace or a regular scrub, and not
consistent with the finished or canceled dev-replace messages:

 "dev_replace from %s (devid %llu) to %s finished"
 "dev_replace from %s (devid %llu) to %s canceled"

To reduce confusion, change the error message to be more consistent with
the remaining two.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/dev-replace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 72cba7fed942..a0bfc4e597a2 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -948,7 +948,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	} else {
 		if (scrub_ret != -ECANCELED)
 			btrfs_err(fs_info,
-				 "btrfs_scrub_dev(%s, %llu, %s) failed %d",
+				 "dev_replace from %s (devid %llu) to %s failed %d",
 				 btrfs_dev_name(src_device),
 				 src_device->devid,
 				 btrfs_dev_name(tgt_device), scrub_ret);
-- 
2.55.0

