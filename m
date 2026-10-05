Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6374E42640A
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 09:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791190909; cv=none; b=IrMqCkX4PiMc+jTylQiaTiPEFvgaoWdgCQ87l57Un51ypUwiUS3KYOy5Imd9CN+uWKLXn8RVVS26UleEeSBp4+AVzw75wFjIGrgAkWCUrAWJeUWTidVCpBcdwpLBCpQgR9qtGenDOljdbfNTepXbKa6aLfSOXkY84o+Z/VpIXCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791190909; c=relaxed/simple;
	bh=KFTfNWpC66peCznuS8finMnT9kjXvOTvusmv2sjgc9k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7xxXZYfWyvi0G0beLSLAa+xVpQOV9adJqAOE4PZXwgQgB0DWS60ptBjbjt0dC7O7Gq5NocIDQvw1Kc99Bpjgh+XOSO3t40U+WpCNrsTTdvY70IBqWJFgn5ptKtPOltPhSLaDxhdVMPKmpD8L3Yf/JarpG2ZlhXOrcx9xTm4cnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IM7QUB18; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iVx5kRJo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IM7QUB18";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iVx5kRJo"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F3C8D1F7BA
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 09:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791190901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Vn4wkTklfDY2Nv3Sc0Sb5B3OH70gqUIciCry2GwbEQ=;
	b=IM7QUB18pbT6f0Ffwo9hJeu012IrRnE1vJR36iji5DDTAXtTr3NSpSr5XqjCNp/a80ziGR
	n1LN5ALEYeIXOrkOCXki1/0MgEx+tWqloGA5glECXL3KAFOXLV/xaFBfulHEiHFoDIqG+2
	dC+166HcXj4WLAsMBuCp1ViUHb6ZPk8=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=iVx5kRJo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791190897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Vn4wkTklfDY2Nv3Sc0Sb5B3OH70gqUIciCry2GwbEQ=;
	b=iVx5kRJojxZ3eFpvjcJ4VF5rBGtacK6rep1wo/qQG2QcnnivWV63wrjAAGQtacGWSz9xnJ
	2zSnmEQKyRN96M2ptmcKU0+TVAXhkaR2lze92zvjF4p0qh6VirD204daCy9tRgrxwfymL0
	dR/QpUjOxuXgBo94gTZGWOE0PDfkAlU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AEF4A13A1D
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 09:01:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ngyMK2tnw2qpRwAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2026 09:01:35 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs-progs: check: remove unused qgroup_count::key
Date: Mon,  5 Oct 2026 19:31:11 +1030
Message-ID: <53bfbf1a1219a1f33d9e329410d4ae10a45751e5.1791190852.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791190852.git.wqu@suse.com>
References: <cover.1791190852.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: F3C8D1F7BA
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.86 / 50.00];
	BAYES_HAM(-2.85)[99.37%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:email,suse.com:dkim]
X-Spam-Flag: NO
X-Spam-Score: -2.86
X-Spam-Level: 

That member is only set during insert, but never read again.
And it's against the common practice to use btrfs_key structure for
in-memory structures.

Just remove the member to save some space for qgroup_count::key.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/qgroup-verify.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/check/qgroup-verify.c b/check/qgroup-verify.c
index 7993cd22a213..433d89b47d3a 100644
--- a/check/qgroup-verify.c
+++ b/check/qgroup-verify.c
@@ -60,7 +60,6 @@ struct qgroup_count {
 	u64 qgroupid;
 	int subvol_exists;
 
-	struct btrfs_disk_key key;
 	struct qgroup_info diskinfo;
 
 	struct qgroup_info info;
@@ -863,7 +862,6 @@ static struct qgroup_count *alloc_count(struct btrfs_disk_key *key,
 
 	if (c) {
 		c->qgroupid = btrfs_disk_key_offset(key);
-		c->key = *key;
 
 		item = &c->diskinfo;
 		item->referenced = btrfs_qgroup_info_rfer(leaf, disk);
-- 
2.55.0

