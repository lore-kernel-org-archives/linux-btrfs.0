Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D68536494C
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775970554; cv=none; b=Ily+b/QXxhXhpPdcwd2rsnX0XvPQiQC9HKklwTeP9/prmVBPMXf0KXWpc5VWw2InJBUZb1n1u0UlaNgLgV2i51qLEqaVdBun0YnghHtzS7DJXtuz1/TTaPZAK2BuP91VgmUujTjbg769Y6sqaZZRX9SZQSiayoZhkMjzCo3JBGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775970554; c=relaxed/simple;
	bh=cdlNdxPU9a19eNhwKexgioqQJyy4ySWhKmhYay+U7ag=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJemToeUPceS/svyn6d/Lg/qax8m069FflTAipLA2x1RN6y+rYqzzvu8aYVA0KJHV6pcIYQaY9BYtUJR4Jvs6/zQYLEd8+FYJ5TOOlRnzb84GDOYc+KOL5YmNuONMXUsid7cve3DcmiwkRcuMKoRH8a9hM5LHFODWLPeRMp3miM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BBdWT6rD; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BBdWT6rD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BBdWT6rD";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BBdWT6rD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ACE4F5BCE5
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775970548; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=waJ8JbzcLi6JaEWykD3d30fGtZ8mYrZHk9U6AOQZvyo=;
	b=BBdWT6rDEZWVHzS62O7ufG40mSWqwz52A4bDWP67HnilE/gnpT2wSzsL10ckYNcp33D0o9
	Evt8lZBEuPKcAirAsT8jHu4zlbb9FUbMUy2r3PfNcYKiVRZIwLpO6UsVXBN59sREKnENBY
	jn3YuLsGYdzI4w2cWabUx8l61SOxsZQ=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=BBdWT6rD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775970548; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=waJ8JbzcLi6JaEWykD3d30fGtZ8mYrZHk9U6AOQZvyo=;
	b=BBdWT6rDEZWVHzS62O7ufG40mSWqwz52A4bDWP67HnilE/gnpT2wSzsL10ckYNcp33D0o9
	Evt8lZBEuPKcAirAsT8jHu4zlbb9FUbMUy2r3PfNcYKiVRZIwLpO6UsVXBN59sREKnENBY
	jn3YuLsGYdzI4w2cWabUx8l61SOxsZQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A456F4A756
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oGgLFPMo22k7AwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:07 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: check/lowmem: fix false alerts about EXTENT_OWNER
Date: Sun, 12 Apr 2026 14:38:44 +0930
Message-ID: <eb292f78aff9a587ea35534aebddb551beee2be4.1775970499.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775970499.git.wqu@suse.com>
References: <cover.1775970499.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: ACE4F5BCE5
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

[BUG]
When simple quota is enabled, lowmem will give false alerts:

 [3/8] checking extents
 ERROR: extent[13631488 168 1048576] has unknown ref type: 172
 ERROR: extent[63963136 168 131072] has unknown ref type: 172
 ERROR: extent[63963136 168 131072] has unknown ref type: 172
 ERROR: file extent[257 0] root 256 owner 256 backref lost
 ERROR: extent[13631488 168 1048576] has unknown ref type: 172
 ERROR: file extent[258 0] root 256 owner 256 backref lost
 ERROR: errors found in extent allocation tree or chunk allocation

[CAUSE]
Lowmem mode has strict checks on the inlined backref type, and
unfortunately EXTENT_OWNER_REF is not inside the support 4 backre types,
thus it's treated as an unknown type, and caused the false alerts.

[FIX]
Add the EXTENT_OWNER_REF type into the supported types.

For lowmem check itself, those key types are just skipped as it's only
to indicate the owner of a data extent, which will be verified by qgroup
part.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 9db58f6c1702..a7465268ad89 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -3053,6 +3053,7 @@ static int check_extent_inline_ref(struct extent_buffer *eb,
 	case BTRFS_EXTENT_DATA_REF_KEY:
 	case BTRFS_SHARED_BLOCK_REF_KEY:
 	case BTRFS_SHARED_DATA_REF_KEY:
+	case BTRFS_EXTENT_OWNER_REF_KEY:
 		ret = 0;
 		break;
 	default:
@@ -4645,6 +4646,12 @@ next:
 		parent = offset;
 		tmp_err |= check_shared_data_backref(offset, key.objectid);
 		break;
+	case BTRFS_EXTENT_OWNER_REF_KEY:
+		/*
+		 * This is showing the initial owner for SIMPLE QUOTA.
+		 * It will be hanled by qgroup check, skip it here.
+		 */
+		break;
 	default:
 		error("extent[%llu %d %llu] has unknown ref type: %d",
 			key.objectid, key.type, key.offset, type);
-- 
2.53.0

