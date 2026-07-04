Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DDF31F993
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Jul 2026 08:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783153762; cv=none; b=j8gCBG+DoeCTXyb4eC/Cex07UfWEtAC1F2mP1i+AUluXiiterBnZ0n8Vuj8h28ke6ToAeCX5/rs07o5Q0UWxRjKRHTRmfsG1vC6to6rDjSsj0y4yuQbio1I2Jesnf6B1kK1TRjm6FBwBAt+WT3LmRCoj0hKtFLbfr1GExyGSVjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783153762; c=relaxed/simple;
	bh=u0xDcbuu8V0UfTbSBOxk2zdk0w6WU4QFi+zSNs3Uqb8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pMjHI3eYSY46wcJ9b/X4ax+5QgZMee6Hhm2kvQ2OBovzhr3jNej6DY6rqRQa6Zy8D96LD00IeicYr5dg6sAQouLgX+9XQG7kyoPwGLAFwE2dmMc7Lrpxfncc52rw/niWxs4V/9MpwkOey/YVdkRN77u+Y0KzalfdkK7buBSkkZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VGBdQpd2; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VGBdQpd2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VGBdQpd2";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VGBdQpd2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8C00875C75
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Jul 2026 08:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783153759; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tgYvfd16AqRICDD42kJzz+OYR68O9SSGegMYhdwbzuU=;
	b=VGBdQpd2E/GHkupGYFMO9ztaZFczw2hrTo48sJXeV9JFtiry+JfpUNto02PjDib4F/o36N
	ACsTrjkTMTDmPGhrP+Qfn0KPYkCPmCAw0i+C2oHS4BeGz5+eu5K+bOVuSHgQhoW4Wgd0nl
	Ntlpo/Xi9OSf62X+1m+fr1aT/qCDcsE=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=VGBdQpd2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783153759; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tgYvfd16AqRICDD42kJzz+OYR68O9SSGegMYhdwbzuU=;
	b=VGBdQpd2E/GHkupGYFMO9ztaZFczw2hrTo48sJXeV9JFtiry+JfpUNto02PjDib4F/o36N
	ACsTrjkTMTDmPGhrP+Qfn0KPYkCPmCAw0i+C2oHS4BeGz5+eu5K+bOVuSHgQhoW4Wgd0nl
	Ntlpo/Xi9OSf62X+1m+fr1aT/qCDcsE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 92345779AA
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Jul 2026 08:29:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g46+EF7ESGpRfgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 04 Jul 2026 08:29:18 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix leaking BTRFS_FS_STATE_REMOUNTING flag
Date: Sat,  4 Jul 2026 17:58:56 +0930
Message-ID: <60a629f78bbd03c07e8907101a23368722c47662.1783153727.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 8C00875C75
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

[BUG]
The following script can lead to unexpected qgroup rescan failure:

 # mkfs.btrfs -f -O quota $dev
 # mount $dev $mnt
 # mount -o remount,rescue=ibadroots $mnt
   ^^^^^ This above command is expected to fail

 # btrfs quota rescan -w $mnt
   ^^^^^ The above qgroup rescan is not expected to fail

 # btrfs qgroup show $mnt
 WARNING: qgroup data inconsistent, rescan recommended
 Qgroupid    Referenced    Exclusive   Path
 --------    ----------    ---------   ----
 0/5           16.00KiB     16.00KiB   <toplevel>

The above short script will be converted to a proper fstests case.

[CAUSE]
Inside btrfs_reconfigure(), if either btrfs_check_options() or
btrfs_check_features() failed, we will always have
BTRFS_FS_STATE_REMOUNTING set for the fs until the next successful
remount.

That BTRFS_FS_STATE_REMOUNTING flag will interrupt several operations,
including:

- Qgroup rescan
- Auto defrag
- Space reclaim

[FIX]
Change the error handling of btrfs_check_options() and
btrfs_check_features() to goto restore label.

Fixes: eddb1a433f26 ("btrfs: add reconfigure callback for fs_context")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/super.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a8c55f7571d0..5843254e3aaf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1510,12 +1510,14 @@ static int btrfs_reconfigure(struct fs_context *fc)
 	sync_filesystem(sb);
 	set_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state);
 
-	if (!btrfs_check_options(fs_info, &ctx->mount_opt, fc->sb_flags))
-		return -EINVAL;
+	if (!btrfs_check_options(fs_info, &ctx->mount_opt, fc->sb_flags)) {
+		ret = -EINVAL;
+		goto restore;
+	}
 
 	ret = btrfs_check_features(fs_info, !(fc->sb_flags & SB_RDONLY));
 	if (ret < 0)
-		return ret;
+		goto restore;
 
 	btrfs_ctx_to_info(fs_info, ctx);
 	btrfs_remount_begin(fs_info, old_ctx.mount_opt, fc->sb_flags);
-- 
2.54.0

