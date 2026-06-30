Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA32450F2
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 00:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782778170; cv=none; b=KZPuk5D9M1pTPr8XRX8Zs/i6Q4Xcq1mGxwkeVFIvbojsFTr5b9bo1IgbdNH29VWIKpnkwLZeDwPELwh+Zqsu0vDQJ66q+c4CZCOiAY0Hw13yCwr6hULHMqeMbF8Ez+ddDqrE9BZkT3xcPaya0ZOmlpsUDnhVNDIjXr8ZkuUEbmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782778170; c=relaxed/simple;
	bh=4Z8OsTTKVRZRb9bvmj0iUoiBuPYZq7ttv5r+JqwywYI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bLkF7TnlFrmvYTJ3QIiQvgib7L473U7AA1OYv6vBV2FBWGyO74ItMkJDI7DZWD6yItpiqjncyq8Fgr7MOSUF9lVKL/gK1+eGTZR/fzgd4pGlMRwClmXF/Q6H5wbrUs/9jlPkthOJxdWQLU8HTto3xDhcJB/Mk+pnCUKeASM6k2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qLaI+tjy; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qLaI+tjy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qLaI+tjy";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qLaI+tjy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 86A3075A16;
	Tue, 30 Jun 2026 00:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782778167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XHenOIQPmFdn6WhJtzRlo26RaTtAcx+PmAgPdKoBb0U=;
	b=qLaI+tjyuDkDkWAV6ilQZ/YvMce52wIh4dU1JGWXCI7ih7vCwsmuTE+s8YrHO/1/4BAnGh
	OXbmCcZGoMoeeX30+9MMqYpvmHUtqo5LAi4qa8ZjBw+tkyjEvxy7MIt5/fNAiukvgmOA4A
	5C2PYuWAh2GEx/AgJHOCygsPcIfUfes=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=qLaI+tjy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782778167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XHenOIQPmFdn6WhJtzRlo26RaTtAcx+PmAgPdKoBb0U=;
	b=qLaI+tjyuDkDkWAV6ilQZ/YvMce52wIh4dU1JGWXCI7ih7vCwsmuTE+s8YrHO/1/4BAnGh
	OXbmCcZGoMoeeX30+9MMqYpvmHUtqo5LAi4qa8ZjBw+tkyjEvxy7MIt5/fNAiukvgmOA4A
	5C2PYuWAh2GEx/AgJHOCygsPcIfUfes=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C50D779A8;
	Tue, 30 Jun 2026 00:09:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uzPlHTcJQ2oSOQAAD6G6ig
	(envelope-from <dsterba@suse.com>); Tue, 30 Jun 2026 00:09:27 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: sink idmap parameter to __btrfs_ioctl_snap_create()
Date: Tue, 30 Jun 2026 02:09:17 +0200
Message-ID: <20260630000917.2521623-1-dsterba@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 86A3075A16
X-Spam-Score: -3.01

The 'idmap' parameter is derived from 'file' that we also pass to
__btrfs_ioctl_snap_create(), assign it inside the function.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1ed16ff4007b..8aa6538f005c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1143,13 +1143,13 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 }
 
 static noinline int __btrfs_ioctl_snap_create(struct file *file,
-				struct mnt_idmap *idmap,
 				const char *name, unsigned long fd, bool subvol,
 				bool readonly,
 				struct btrfs_qgroup_inherit *inherit)
 {
 	int ret;
 	struct qstr qname = QSTR(name);
+	struct mnt_idmap *idmap = file_mnt_idmap(file);
 
 	if (!S_ISDIR(file_inode(file)->i_mode))
 		return -ENOTDIR;
@@ -1227,8 +1227,7 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 	if (ret < 0)
 		return ret;
 
-	return __btrfs_ioctl_snap_create(file, file_mnt_idmap(file),
-					 vol_args->name, vol_args->fd, subvol,
+	return __btrfs_ioctl_snap_create(file, vol_args->name, vol_args->fd, subvol,
 					 false, NULL);
 }
 
@@ -1271,8 +1270,7 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 			return ret;
 	}
 
-	return __btrfs_ioctl_snap_create(file, file_mnt_idmap(file),
-					 vol_args->name, vol_args->fd, subvol,
+	return __btrfs_ioctl_snap_create(file, vol_args->name, vol_args->fd, subvol,
 					 readonly, inherit);
 }
 
-- 
2.54.0

