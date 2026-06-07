Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEE626AE5
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Jun 2026 22:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780872857; cv=none; b=dmmrgnOUD62LhbIxSnEfF0udat5Piwl1FKFvzJfblWjN7iZr5/NhsTXRKvfg6PqTrNVlzgqyVqhGZw+nP4c3Ff64Jg0Dz2UALi8OZoT6QoVH5loDEvLOz/HKdagiHO+1JXa69TyrgWMS2YtLpM5WhtN6cKCVJk4xyczG4x/PytQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780872857; c=relaxed/simple;
	bh=eCguf+kKYL+2X1HBrL1l565MfCX/vdzaMgfDxFw76ds=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=jnpg0lpKda+//lSdE30DCROYjtWhVwn3ui7WeIhDp6lYQ0Vjuey+WVSlQojel59dlupS6eHc6fFZc/dmGpI/kJsFDtFN8cJCs5mGImxRkyyfiH9D9ehiVtsqBXK4FwWq8zi+ghsCtERr2qLeGtny3KGtbDt/bhJs/ECjsx6Nkl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=R4AKEubh; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hOGokgwI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="R4AKEubh";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hOGokgwI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 29C436AA54
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Jun 2026 22:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780872854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=33baiZCAPxPROPJPOZJTIICQd4mCukF3sPAJNqSE7wc=;
	b=R4AKEubhafkzAeebaciSD11wqAhyvPmmLoQchLQAlvqvgRrxuB2gn8LIokZSehNptV1Oe0
	xkYY3wmFwuE2nXLYVN7Xud9eXRIV8w3f2eIZ4yE5I+KQlVIUpP+m638xCdUUfm2Xm24Hjf
	LEG9nthSRDWxRRV/6A6kawvj57Td15A=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780872853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=33baiZCAPxPROPJPOZJTIICQd4mCukF3sPAJNqSE7wc=;
	b=hOGokgwIibjnre3rUjpn/mxYdMgeiLap19aw8WxKa5SisnQ3ic0G2z5CYsL7cqygFJwDa3
	pCpAYJ57cKk9Pkvkf3jNPZDaxSOAPWt3WZSqSwmunvOoktSOkoNE0Cr+oPPfwMKQWxwFga
	us43dSwpK7xKVg8jbU2uEeMhxT/j8n0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2AA3A779A7
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Jun 2026 22:54:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CUyWMpP2JWr+FAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 07 Jun 2026 22:54:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: lzo: add error message for invalid headers
Date: Mon,  8 Jun 2026 08:23:49 +0930
Message-ID: <205f9c2da68cc36dbaa604b6bdd462ff871b2b83.1780872810.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.78
X-Spamd-Result: default: False [-2.78 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.18)[-0.919];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

Inside btrfs we always pair -EUCLEAN error with an error message to
indicate which data is corrupted.

However there are 3 cases inside lzo decompression where there is no
error message for corrupted headers.

Add those missing error messages to show exactly where the corruption
is.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/lzo.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 6e4aa22853ab..488167b32a48 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -552,17 +552,26 @@ int lzo_decompress(struct list_head *ws, const u8 *data_in,
 	size_t max_segment_len = workspace_buf_length(fs_info);
 	int ret;
 
-	if (unlikely(srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * 2))
+	if (unlikely(srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * 2)) {
+		btrfs_err(fs_info, "invalid header length, has %zu expect (%u, %zu)",
+			  srclen, LZO_LEN, max_segment_len + LZO_LEN * 2);
 		return -EUCLEAN;
+	}
 
 	in_len = get_unaligned_le32(data_in);
-	if (unlikely(in_len != srclen))
+	if (unlikely(in_len != srclen)) {
+		btrfs_err(fs_info, "invalid header length, has %zu expect %zu",
+			  in_len, srclen);
 		return -EUCLEAN;
+	}
 	data_in += LZO_LEN;
 
 	in_len = get_unaligned_le32(data_in);
-	if (unlikely(in_len != srclen - LZO_LEN * 2))
+	if (unlikely(in_len != srclen - LZO_LEN * 2)) {
+		btrfs_err(fs_info, "invalid segment length, has %zu expect %zu",
+			  in_len, srclen - LZO_LEN * 2);
 		return -EUCLEAN;
+	}
 	data_in += LZO_LEN;
 
 	out_len = sectorsize;
-- 
2.54.0

