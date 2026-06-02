Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC11223D7DF
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 05:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780378031; cv=none; b=HytJ1AYs000P2pGahJWeJTuIenTq8CeuSg4qpas3X7oRC8IaB/X4Y44lE+ROWVfetSi/89ZSF0os0J95HIcoHhxpm1geDA63TnxhcQMsMNzo4Q0qWIE9+DEFhEWGmDS0gLWSSw47v2WPR9EyGsYt53parZ++Z0XuKpgQS51jHzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780378031; c=relaxed/simple;
	bh=plAmqUFm/MUOo/SrJdtUUpKcZMDEIz5cpTv/69xSZYM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=SMElaLv1hX9DMG3BWfXbrOJq50Ez9cjFBoFovDPEd+Ksn9FRUO45bAMFXL5qkQMhG+eGC3uPidp9ZFkITG8l2KuMkf5+HPBErOHb3EHiTcCpBmANSz9WmjMIBUu3OMNHkD3ngoQUs9M3UEbNomoF+tyeDQpWP6ucS7CTHrP9kfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sJi1fNV/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sJi1fNV/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sJi1fNV/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sJi1fNV/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C6C4A6A945
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 05:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780378027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vbIaf7cNGr3jJg2u4EFaZsbnkWMKhaUX3eITsuVIrdM=;
	b=sJi1fNV/u7iwbtPYdS/Z3B2CgVxXd6LtdX7TC+x0wYdFEC2Kz1qkHbgpB56Rv9hIpn8K1m
	8SyfU0YoQ0CL017M1pkgHoFo24mHq9HHmgEb6C/huxqOJbjUHWXfmaiI98WnuQfDTpKA1A
	5j4cf5xcBhpJ2LIkF27ihMOiQ9msnZg=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780378027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vbIaf7cNGr3jJg2u4EFaZsbnkWMKhaUX3eITsuVIrdM=;
	b=sJi1fNV/u7iwbtPYdS/Z3B2CgVxXd6LtdX7TC+x0wYdFEC2Kz1qkHbgpB56Rv9hIpn8K1m
	8SyfU0YoQ0CL017M1pkgHoFo24mHq9HHmgEb6C/huxqOJbjUHWXfmaiI98WnuQfDTpKA1A
	5j4cf5xcBhpJ2LIkF27ihMOiQ9msnZg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C38C779A7
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 05:27:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3WiML6ppHmpbXwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2026 05:27:06 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: output a message when a missing device re-appear
Date: Tue,  2 Jun 2026 14:56:49 +0930
Message-ID: <c7860a5196a885c39e01676c4a1b3a4323f56590.1780377988.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.80

There is a bug report that fstrim crashed, and that crash is eventually
pinned down to a missing device which re-appeared and screwed up callers
that only checks BTRFS_DEV_STATE_MISSING, but not
BTRFS_DEV_STATE_WRITEABLE nor device->bdev.

A missing device re-appearing can be very tricky, as for now it will
result a device without WRITEABLE nor MISSING flag, and still no bdev
pointer.

As the first step to enhance handling of such re-appearing missing
devices, add an dmesg output when a missing device re-appeared.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 93a923e4ecaf..716dcefb0fd8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -963,6 +963,11 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 					  devid, btrfs_dev_name(device),
 					  path, current->comm,
 					  task_pid_nr(current));
+		} else {
+			btrfs_info(NULL,
+	"missing devid %llu re-appeared at %s scanned by %s (%d)",
+				   devid, path, current->comm,
+				   task_pid_nr(current));
 		}
 
 		name = kstrdup(path, GFP_NOFS);
-- 
2.54.0

