Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FCF4C0405
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650090; cv=none; b=dzkg/W44zDBX6z0y0jXPL9xEsTIpYbpSz7SoPRLTHLz+RuCMHFcduCLT6uWZUwFsBSCKuRDOQe9clQrBxm383npbfXlyHhoyBEK5lftGqRKBW8MBXPhQZyhg4DaQe3eF9sAWnoG9+V4UVK67vfl+zqg1n9FRvFhi03ZpcySuKlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650090; c=relaxed/simple;
	bh=GB5dHlvg8AmQNG2hzklxgUktPG6Va8KHT3dAI2iVuG0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3e/cvO6Yy+Yq3KpgKWASORiKoDRsNdmvM+LOCHnBLZRsNS7o37JpR28FWGhVSNvO4iyCUDfs0bnkA+8bmBAshlVuAZKM+T1/c6E6iO5uq7x4m8+hggR0G5yJ/kj+eaEE5MPQLKz8u5Z0h/wGm8Xnlu/6uERsHQg9ydctGr1njE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qvCOtVOt; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qvCOtVOt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qvCOtVOt";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qvCOtVOt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C98D06A879
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780650087; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t/OiTNWTYFMplIF+//xOcXKPy9o5kb1w5/c+1eetajY=;
	b=qvCOtVOtHlFSJHMETc5zOeEV2NhqRuWdSNbP6GAS70ZhxUvckjQXEvL+SXIWd3jmjAAUYf
	EA8SQfAtbWb9FfAR9XPlVLdBz3FY60VN6fCQ8Wz+30GtoFJ8tS9nGeIqnJ32Qh+vbaX/s2
	hWclbhqaPTsFj7i9ffNO24y5EuiJIh8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780650087; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t/OiTNWTYFMplIF+//xOcXKPy9o5kb1w5/c+1eetajY=;
	b=qvCOtVOtHlFSJHMETc5zOeEV2NhqRuWdSNbP6GAS70ZhxUvckjQXEvL+SXIWd3jmjAAUYf
	EA8SQfAtbWb9FfAR9XPlVLdBz3FY60VN6fCQ8Wz+30GtoFJ8tS9nGeIqnJ32Qh+vbaX/s2
	hWclbhqaPTsFj7i9ffNO24y5EuiJIh8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CA6F6779A8
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:01:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uPwJHmaQImrFDAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2026 09:01:26 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs: return the written number if there is any progress for dio
Date: Fri,  5 Jun 2026 18:31:03 +0930
Message-ID: <9e638119748a83f475861e69388b4dda9715b660.1780645090.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780645090.git.wqu@suse.com>
References: <cover.1780645090.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

Currently btrfs_direct_write() will return error even if there is some
progress made.

E.g. a NOWAIT direct write has submitted 16KiB data, but later
failed due to -EFAULT.

In that case we can not fallback to buffered IO either, as it's an
NOWAIT operation, so we set @ret to -EAGAIN.

In that case, we should not return -EAGAIN but 16K to indicate that we
have already submitted 16KiB data.

Fix it by doing a check on @written first, only if @written is 0 then
return @ret.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/direct-io.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 460326d34143..c97396ca476d 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -1046,7 +1046,14 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	invalidate_mapping_pages(file->f_mapping, pos >> PAGE_SHIFT,
 				 endbyte >> PAGE_SHIFT);
 out:
-	return ret < 0 ? ret : written;
+	/*
+	 * Always check if we have some bytes written, even if we hit
+	 * an error later we must report the correct number of written
+	 * bytes.
+	 */
+	if (written)
+		return written;
+	return ret;
 }
 
 static int check_direct_read(struct btrfs_fs_info *fs_info,
-- 
2.54.0

