Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539213;
	b=ff2PBsS704Y/86jRE3pfNwNeqqtl8zfo8z/KcVJFfeaT8LVisjn8ICvn4H4hqiYNV109
	 DV/80TSsKQVqF9tLmLFgIWN73JPd6/QP/W8xiaDDpVRk4gmaEIrhYklFJk/UL5SC0stzP
	 ORKCFTPIGoO821w1kkt6tM6zqo3i57DMedmoddEHVKlI5YsSeRovpIFKfoao/ns25FCY0
	 q7aW5ZZpNDY5oiOlE1TBzLAlq/DFJjOSQbFJiz7kHt10Kvs6DrkN1oOgw+RxB1XclB4QY
	 itI0wmcLX5XFWpO+tDGT2UOD0zQE38KfBI32FK49FP32eeij4SVBa8XPxf+xbRFamlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539213;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=uN4zAWHVVIoJ48n2dVmR0u+93AUQopc/jl95ldQ5HGQ=;
	b=GKNQxKKwITKIUhOY/tHCep7zRxhQQlQXOCtTsamNHeI0RVsFl/Nr0p91MUaKhHNNeG03
	 Tpl18NucSKo5sIwwZ1+MlvagJToj8ufXob9ddnbtE//7RJ4dGOiaoetZLp0MfUviHgP8r
	 NKW/icjS9p8Wvfmcp+CY0wDZBEDuUbY4qFDOOVoMkvj5FsTK1HYbWQSFZ43BTc7pgKFyV
	 rjB009nSBee75QIb0sRoB0lTTD7jdlxB2l8s+qbgrtTV56KnyWMNiXK+iu7ZdR8quHlIF
	 yNkz/828BgzuzuirIpQV59jSB8WzwN0Ig5lRUMIm9tPu9DvblcFC2rTQBCFkqp8QGIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=E0HaIkHQ;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=E0HaIkHQ;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E80B606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 03:06:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E80B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=E0HaIkHQ;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=E0HaIkHQ
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C32EB1F394;
	Fri, 13 Nov 2026 03:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794539210; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uN4zAWHVVIoJ48n2dVmR0u+93AUQopc/jl95ldQ5HGQ=;
	b=E0HaIkHQzz+5XTwK3RvNHKAaRD0oZeUwcyKFAi32hSRSOWJEQz6keStAe3V1Pq8o76Xkit
	XC4JRH2xugfQlJtUclZwKpFr6e3p349wUxzOtA2gAQmjeBfkRZ4vV+VggiGqkYiyHy469b
	1ocSE0kHMUdd9m0O4KiQIsEEwDSMsaI=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794539210; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uN4zAWHVVIoJ48n2dVmR0u+93AUQopc/jl95ldQ5HGQ=;
	b=E0HaIkHQzz+5XTwK3RvNHKAaRD0oZeUwcyKFAi32hSRSOWJEQz6keStAe3V1Pq8o76Xkit
	XC4JRH2xugfQlJtUclZwKpFr6e3p349wUxzOtA2gAQmjeBfkRZ4vV+VggiGqkYiyHy469b
	1ocSE0kHMUdd9m0O4KiQIsEEwDSMsaI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 571A2134C3;
	Fri, 13 Nov 2026 03:06:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id urUjKch+9mq4QQAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 13 Nov 2026 03:06:49 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] btrfs: fix an off-by-one bug when reading backup supers
Date: Fri, 13 Nov 2026 13:36:30 +1030
Message-ID: <27888031e07cccb13dcf61462472b132df7df99b.1794539183.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,suse.com:email];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

The check inside btrfs_read_disk_super() has an off-by-one bug:

	if (bytenr + BTRFS_SUPER_INFO_SIZE >= bdev_nr_bytes(bdev))
		return ERR_PTR(-EINVAL);

This means if a backup super is exactly at the end of the device,
btrfs_read_disk_super() will reject it.

This is not going to cause any problem, as btrfs kernel module never
utilizes any backup super blocks.
This also means Sashiko is overstating the severity of the bug.

Only btrfs_scratch_superblock() is affected, which will skip the
scratching the backup super.
But even with that backup super block left, it won't cause anything
wrong, since device scan/mount will never touch those backups.

So just change this to follow write_dev_supers() to allow reading the
backup superblock at the end of the device.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/bug/linux-2d915102-fe48-454c-ba6c-941e86a9ac43
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8b94c509b85d..5ec2f286abcd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1378,7 +1378,7 @@ struct btrfs_super_block *btrfs_read_disk_super(struct block_device *bdev,
 		return ERR_PTR(ret);
 	}
 
-	if (bytenr + BTRFS_SUPER_INFO_SIZE >= bdev_nr_bytes(bdev))
+	if (bytenr + BTRFS_SUPER_INFO_SIZE > bdev_nr_bytes(bdev))
 		return ERR_PTR(-EINVAL);
 
 	if (drop_cache) {
-- 
2.56.0

