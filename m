Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96BE331A77
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 09:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775554488; cv=none; b=JMmsQpZf4/LLg+drtjMwyPEi0pIPls2AER7tfAarzoNiw+t43tEWqqzhtM6EbFWcfbPAlFIhg/sXmQrCYrNY4QCQlrSL4SbmV2v+aN6+9yp4eLAnplEbL11ubsrAob2Dm+gAnF/NuK6pvBd4hNFttg9ZB+lZDb65BsUpfunnByE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775554488; c=relaxed/simple;
	bh=PzEn/iIx8hxRWbg80QYVzK1z2YooxR3bIFO38LW4dbA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2srh3vfoSvcwvtU0elTFpw7Jp1V9LVFFB6Qjz6va7FLFdI9bNwOOsrb58pL30Kmm7LB2cR2W2sXqAFgvTYtfv/Z+KY8otoyYBRjpbCpdH+tpnkNsZNK//6HjSG0Z+iFdQUSWwCK6wLtkj7DqOB7Ipm3AiF9TEzhFAv3tX4EgT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=U1yggnw/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=U1yggnw/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="U1yggnw/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="U1yggnw/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 18BB64E3B1
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 09:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775554468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uyBtMywTzWVtk5Y3eBDPQRwHPjgDD01WSQK9zo6DSAM=;
	b=U1yggnw/0Xxdp3PTZcOU/Cn33EQ2Ffitxu/VJc2Nf9Q4q3dHWk7fm3ruMv9w7a5UA7MAoW
	2n6mKMm2kVOBjVK1nwS1UgUgmEs9zY0OdArI1I/BCNmo1yrykfPv2goDAz92IJzcO7i7bo
	vN0hi/LUqUquRxDKwxpXuv/zvHdazXc=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775554468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uyBtMywTzWVtk5Y3eBDPQRwHPjgDD01WSQK9zo6DSAM=;
	b=U1yggnw/0Xxdp3PTZcOU/Cn33EQ2Ffitxu/VJc2Nf9Q4q3dHWk7fm3ruMv9w7a5UA7MAoW
	2n6mKMm2kVOBjVK1nwS1UgUgmEs9zY0OdArI1I/BCNmo1yrykfPv2goDAz92IJzcO7i7bo
	vN0hi/LUqUquRxDKwxpXuv/zvHdazXc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 188644A0B0
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 09:34:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AHz7LaLP1GkOYAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2026 09:34:26 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs: avoid unnecessary dev stats updates
Date: Tue,  7 Apr 2026 19:04:01 +0930
Message-ID: <cfcf51637e298790485caa28b4961590dec3e651.1775553952.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775553952.git.wqu@suse.com>
References: <cover.1775553952.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

[MINOR PROBLEM]
When mounting a btrfs with a valid DEV_STATS item, btrfs will always
update the DEV_STATS again in the next transaction commit, even if there
is no change the values.

[CAUSE]
During the mount, btrfs_device_init_dev_stats() will read out the
on-disk DEV_STATS item for each device.
Then it calls btrfs_dev_stat_set() to update the in-memory structure.

However btrfs_dev_stat_set() does not only set the dev stats value, but
also increase device->dev_stats_ccnt.

That member determines if we should update the device item at the next
transaction commit. Since we have called btrfs_dev_stat_set() for each
dev status member, dev_stats_ccnt will be non-zero and we will update
the dev stats item even it doesn't change at all.

[FIX]
Instead of using btrfs_dev_stat_set() for valid on-disk DEV_STATUS
values, directly call atomic_set() to set the in-memory values.

For other call sites, we still want to use btrfs_dev_stat_set() so that
we will force updating/creating the dev stats item.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 09d6382beda5..0acd17c57698 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8181,8 +8181,8 @@ static int btrfs_device_init_dev_stats(struct btrfs_device *device,
 
 	for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++) {
 		if (item_size >= (1 + i) * sizeof(__le64))
-			btrfs_dev_stat_set(device, i,
-					   btrfs_dev_stats_value(eb, ptr, i));
+			atomic_set(device->dev_stat_values + i,
+				   btrfs_dev_stats_value(eb, ptr, i));
 		else
 			btrfs_dev_stat_set(device, i, 0);
 	}
-- 
2.53.0

