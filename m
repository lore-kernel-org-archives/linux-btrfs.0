Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6365C2F360A
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782319914; cv=none; b=ZUZOcvg5y/PIFkm6PYqO9glR657G+n2Qz3h6bzRXQuyj/KuS4WejOQgad7xkBYBrIiK0xe+hBR8KEen/D0SdBbil3UQ4ZSAvRBl6akj1ZIpGTK3gWtpjr0dRlZM9+nd3aznrtG73ygIrJP8l/X9G7Sd4bD5fkL7OTBn3/hGCUGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782319914; c=relaxed/simple;
	bh=tMo4f2YVM6f0TAFXYSv1hUzFkA0RghSBuIyHJzrUhhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHl0K+ZJuFPm56EOJ3CrdBlSB5mrStul3EzQLlxWQZheNv+N3UeY+/1PyJ2tV5Qcai6lgPUGT1aez5jy9961+bjsoL2JvzlkCnKsJ5GIZgFH9IpZdFUVXN88uxtfDsV7aYTthu5looHu99PzkKiZOL7FcB6vtJ28kwJ71eQ4n4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D41D57601B;
	Wed, 24 Jun 2026 16:51:50 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BF2F5779AB;
	Wed, 24 Jun 2026 16:51:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8AoxLiYLPGrUTgAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 24 Jun 2026 16:51:50 +0000
From: Daniel Vacek <neelx@suse.com>
To: David Sterba <dsterba@suse.com>
Cc: Daniel Vacek <neelx@suse.com>,
	linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v2 1/8] btrfs-progs: check: fix max inline extent size
Date: Wed, 24 Jun 2026 18:51:37 +0200
Message-ID: <20260624165144.556908-2-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260624165144.556908-1-neelx@suse.com>
References: <20260624165144.556908-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: D41D57601B
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

Fscrypt will use our entire inline extent range for symlinks, which
uncovered a bug in btrfs check where we set the maximum inline extent
size to

min(sectorsize - 1, BTRFS_MAX_INLINE_DATA_SIZE)

which isn't correct, we have always allowed sectorsize sized inline
extents, so fix check to use the correct maximum inline extent size.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---
 check/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index 5e29e2c5..dedb4db4 100644
--- a/check/main.c
+++ b/check/main.c
@@ -1720,7 +1720,7 @@ static int process_file_extent(struct btrfs_root *root,
 	u64 disk_bytenr = 0;
 	u64 extent_offset = 0;
 	u64 mask = gfs_info->sectorsize - 1;
-	u32 max_inline_size = min_t(u32, mask,
+	u32 max_inline_size = min_t(u32, gfs_info->sectorsize,
 				BTRFS_MAX_INLINE_DATA_SIZE(gfs_info));
 	u8 compression;
 	int extent_type;
-- 
2.53.0

