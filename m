Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8993237FF41
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 05:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788757720; cv=none; b=ZUPYakeBWAYOE/vAI164Z5ppYUOPqUmQxayj2esFzCpgi9uXst5Hkr6Qgdui99lWad8iAXdv3vBjeSoTsWwoPg3BMNQNVYN+TcaMzwgLIhYQBUCho9x/KX6iO61CXMKMGSb7moqTH24sMpN5Hj7lwGORh94ck3iTU6O+SkK3C8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788757720; c=relaxed/simple;
	bh=kP4Y9yLxpOsd1WRoWXussSVTTqU1emO6kogszfilvJc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiXAGWg/nMgyScaYDkgTWySfeUweWofVuiiAnzsbK6Cf2ZjB+AsAAErxcC8d03gsZvC249HIOZpsuo7EnORAfmYzYhQMVnAEFH14oa4xTYUwJJJvtdIE8Cv+ibnyTw+KmoWb++FVP0aMjweY6arw1zl8df/NbxBlgYxkDZHTlDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FOypphQN; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Uyr4ELCr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FOypphQN";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Uyr4ELCr"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5AC5C21AEC
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 05:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788757707; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Uz45jW/ChPLykRczO8j8kllBh2dP79ef2ECO/CxHR4=;
	b=FOypphQNFq6QTDBMJodYUCIKKzd354OXd/vWS0Xt3/sdmE3/tB+tAocYuQBgiC9nd9AGLE
	VxI/w0xB73eIFF/KgPADFNQvxI2SlNQPpOHd8KG5MR7v2prgAkjELDCpnIoVUXmvDb7352
	NCCoWz4lGFWGtJIjHHwhvg/i6Txoups=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788757703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Uz45jW/ChPLykRczO8j8kllBh2dP79ef2ECO/CxHR4=;
	b=Uyr4ELCrb6CZRtaH8TAP1BhLLPx2wssCZNRSgDvoscFgCjW2ydeK2ySkyXF6EJD3Z2JtIK
	f92mCvqupTXEcSwmQjrb/3DlvBpjxAa2NoxtkRmJIAyL6klJAs7mq1G1AHpAgH7A4J5+NF
	W9lpZpHzsAl/B+v8TfVw31hWYL0Kwec=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 20F1A13793
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 05:08:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oCxnMMVGnmoDBAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 05:08:21 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs-progs: unexport btrfs_setup_chunk_tree_and_device_map()
Date: Mon,  7 Sep 2026 14:37:53 +0930
Message-ID: <8f81fd77146eb7c6ce5e76cdd8b3a9e156e5cc72.1788743334.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788743334.git.wqu@suse.com>
References: <cover.1788743334.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

That function is only utilized during __open_ctree_fd(), no need to
export it.

Unexport it and remove the "btrfs_" prefix.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/disk-io.c | 6 +++---
 kernel-shared/disk-io.h | 3 ---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel-shared/disk-io.c b/kernel-shared/disk-io.c
index 385b74bbac3c..2b1f6c7f6cad 100644
--- a/kernel-shared/disk-io.c
+++ b/kernel-shared/disk-io.c
@@ -1477,8 +1477,8 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 	return 0;
 }
 
-int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
-					  u64 chunk_root_bytenr)
+static int setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
+					   u64 chunk_root_bytenr)
 {
 	struct btrfs_super_block *sb = fs_info->super_copy;
 	u64 generation;
@@ -1666,7 +1666,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, struct open_ctree_args *oca
 	if (fcntl(fp, F_GETFL) & O_DIRECT)
 		fs_info->zoned = 1;
 
-	ret = btrfs_setup_chunk_tree_and_device_map(fs_info, oca->chunk_tree_bytenr);
+	ret = setup_chunk_tree_and_device_map(fs_info, oca->chunk_tree_bytenr);
 	if (ret)
 		goto out_chunk;
 
diff --git a/kernel-shared/disk-io.h b/kernel-shared/disk-io.h
index 839f6e41a709..b3e85c89eab7 100644
--- a/kernel-shared/disk-io.h
+++ b/kernel-shared/disk-io.h
@@ -176,9 +176,6 @@ void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info);
 int btrfs_scan_fs_devices(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices, u64 sb_bytenr,
 			  unsigned sbflags, int skip_devices);
-int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
-			  u64 chunk_root_bytenr);
-
 struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
 			      unsigned flags);
 struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
-- 
2.55.0

