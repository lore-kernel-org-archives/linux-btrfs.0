Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333761;
	b=Y5mVN7INSRI+Hfh/0jONLVI7SXiA7BnH1c1PgOLKof+qlNBXQ9rgEBaT7zrGyDF1EJiy
	 EhJH/UyyeAaihADMv1RsT/HSOLOxG0L6+Ua+QdKdCuA3ce8Ymv9TpO7pX6ky4t7jZ9FBz
	 FUuDmjXXiwMEj09cULPZF4CXfbKv+1jU579mW8GmZGSDXxw/SIS0LVNLHKRtBXp+5Mu/A
	 sgKP2nDgSjjuN/hVldHeaAF2Da0EzfXQyaYV4ULfrEPRGBEjL2ht4i45BiY8uswfeXPU9
	 W9o4yBUmmmN3HS5cYyDJInrWLQdOTyq7keQM+EUjn1vq9dabG/s64pg/fmytIKfyU8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333761;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=We8OKRdfXzD9Ch0dKQ+lJh+yqI7m5dtbXEnxvH19IC0=;
	b=4MXksv2R/EnPnTtoHgGxPHeKmwnnL2weiKYVZJxRmfSCPgNpsigxEgnIo9QK/eREMAhv
	 iX5IBFoYRrh24iFWi9DYQCWYq81Slf4Ks8nOLGQqEkdQvBfpSddtTCGotDO6XMgDz1J4P
	 BYyOFwVjkhbYVRluK1niGM3lYc9vwM1E4kVrV+XWJkaPaLrs1/cVBtR5zVu5Oq7fUgP9N
	 WCga4FqQQH1MSOJSD/jwvMVmzTW8Zqr9FGrAB2n1sGFb4gzsaNSYawQgt0T4j7xrQYbTP
	 Hu1KeVT5o6/5gJDmS26oBXhV83IauTbibiFMUX3s1cqGRgOmmm5o6qpx121xeDsqtAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Le4p7jRM;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="GK/qojVz";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA85606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:16:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BA85606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Le4p7jRM;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GK/qojVz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 99CCF1FCFB
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333759; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=We8OKRdfXzD9Ch0dKQ+lJh+yqI7m5dtbXEnxvH19IC0=;
	b=Le4p7jRMqQpyvXnTj+6aHZ3IYxABr/+l3o0d/mmEktGVSXHWFIjyIkbidfSiKJMxazojil
	6pxbQ0+h6UuIZjuVCkMKxRJPkc6hA2O7dKc+oTsGYEQckgcZAc7OxuBXgibMrKCX5f1Ydh
	BZ07WJZjIeIPHszV79xVh1NnX3NHQmA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333758; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=We8OKRdfXzD9Ch0dKQ+lJh+yqI7m5dtbXEnxvH19IC0=;
	b=GK/qojVzPbh4gg97i/PEp9p75GCmlGr1VN9Mjlbd/dK/aM9Y/+mktuQXZ3aTS6pgQjsI5B
	vY6e0E16f2ty+FKgCjvxxFIqdtvVAxoltcPA1+37jpL0yPdxTeUHgtfaiIHVuDI5aeCzJQ
	6aoC3DIlGIfflA6ZhVNv784zHiTm1eo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81E1413432
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0uAiEekZ5GrDGwAAD6G6ig:T13
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:57 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/12] btrfs-progs: check: return error if fill_csum_tree_from_fs() fails to read a root
Date: Fri, 30 Oct 2026 14:45:19 +1030
Message-ID: <18a6c0ecc34bb581e8f5d9143b754742196a279f.1793333606.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793333606.git.wqu@suse.com>
References: <cover.1793333606.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
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

If fill_csum_tree_from_fs() can not read a fs/subvolume tree, it prints an
error message but returns @ret, which is 0 at that point.

Thus the caller will consider the csum tree rebuild as successful, even if
the csum items of that subvolume are not generated.

Return the proper error instead.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/check/mode-common.c b/check/mode-common.c
index 7d829661eb3d..cda682313f49 100644
--- a/check/mode-common.c
+++ b/check/mode-common.c
@@ -1348,8 +1348,10 @@ static int fill_csum_tree_from_fs(struct btrfs_trans_handle *trans)
 		key.offset = (u64)-1;
 
 		cur_root = btrfs_read_fs_root(gfs_info, &key);
-		if (IS_ERR(cur_root) || !cur_root) {
-			fprintf(stderr, "Fail to read fs/subvol tree: %lld\n",
+		if (IS_ERR(cur_root)) {
+			ret = PTR_ERR(cur_root);
+			errno = -ret;
+			fprintf(stderr, "Fail to read fs/subvol tree %lld: %m\n",
 				key.objectid);
 			return ret;
 		}
-- 
2.56.0

