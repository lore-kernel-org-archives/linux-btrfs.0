Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A857719067C;
	Wed, 30 Sep 2026 01:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790730708; cv=none; b=HGMUC3zvFTVCPwNiw8SPcxb1/AC6nZ/HJzLa3u5iW4u+Q2XLY+s0U0497wspFaVxS7t97HstXSwORSW3hg/ZEnGnnh8Ni3MFfsLWF4LYimp731qGRBsRsdjzrAG9cG7FjKNCS85qjoQdLjMqyXQchPJZiyF/a+5aPd2o7U7Ra+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790730708; c=relaxed/simple;
	bh=lnFlkAgbqG3i9PTWmV5t+5Vf2eSuw7VGoezcD0oekBg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nsAykRpRysJXEmdjnbgbIK/H+gmKI8/geHClg/bQb6vfosIEad7h6nW0NY7Wrh1SPUeTw5CEho6q1jvPhcX5IERkdiWTfEsS0X3RYNPggXngVyB4RYL72+mG2eCM8mKqPr8jWCbMiBpJsJAZhjzp7+TFMnlZEYaSvILNt1iAMVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=c5o2Setz; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=N5qLDJ1k; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="c5o2Setz";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="N5qLDJ1k"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 19B6021DC2;
	Wed, 30 Sep 2026 01:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790730700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Aol+61QQXd1wmBRGoBNUTd1HUGPp6EPG8b3ctCKkIpo=;
	b=c5o2SetzB9ZchfjxLGux+/Aos8iZA3UCaBVrfIfHiRnhfMzy22f3XMUpW8+bmsbkfVexKa
	wnVgYdcPrrp5E9OTOg7BRNSEYPNwSDZCYtRDdBg0+ZQEadisqVs08zJsPpIahml9C0Ouip
	u6IvIHA/7JOAlBP3vMcS1H/mI4TG0sU=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=N5qLDJ1k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790730696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Aol+61QQXd1wmBRGoBNUTd1HUGPp6EPG8b3ctCKkIpo=;
	b=N5qLDJ1kwzcqn4EztiaPLtaZXzbPjstnTfUvxRCx6k5plcLNFUkDvh4gxs42UX0+KzLxaz
	xSkLlf9FNo7nUxVwPp8B2FO7M0IRAZE+4K5GN8L/MTFoJ97EJABYrGDsa2pnVSLUV0ybY0
	EQSG7aFoqD0zBLOSR9kUoqAO7IIjfOI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3BA14136AE;
	Wed, 30 Sep 2026 01:11:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id glKXIcVhvGrOBAAAD6G6ig
	(envelope-from <wqu@suse.com>); Wed, 30 Sep 2026 01:11:33 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Bartosz Fenski <bartosz@fenski.pl>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: raid56: do not verify the content if there is no data checksum
Date: Wed, 30 Sep 2026 10:41:15 +0930
Message-ID: <2989cda015c8673ccd463a5225cb985dc9e36825.1790730674.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 19B6021DC2
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

[BUG]
There is a bug report that fio can fail to sync the data on a degraded
RAID56 mount:

 # mkfs.btrfs -m raid1 -d raid5 -f $dev1 $dev2 $dev3
 # mount $dev1 $mnt
 # btrfs balance start -d $mnt
 # umount $mnt
 # btrfs dev scan -u $dev2
 # wipefs -fa $dev2
 # mount -o degraded $dev1 $mnt
 # fio --name=degraded-write --directory=$mnt --rw=randwrite --fdatasync=4 \
		--bs=4k --size=512M --randrepeat=1

The run will fail at fsync:

 fio: io_u error on file /mnt/btrfs/degraded-write.0.0: Input/output error: datasync offset=142254080, buflen=0
 fio: pid=2064, err=5/file:io_u.c:2008, func=io_u error, error=Input/output error

[CAUSE]
With extra debug output, it shows the problem pretty well:

 rbio=2876243968 faila=0 sectornr=0
 rbio=2876243968 error=0-15 csum=2 bio=15

The first line shows the rbio's full stripe logical, and stripe/sector
number when verify_one_sector() failed.

The second line shows more detail about the rbio, the sector range [0, 16)
is corrupted, which indicates the first data stripe is corrupted, matching
the missing device.

The important part is that the csum bitmap shows the data csum is only
for sector number 2, meanwhile the failed verification is at sector
number 0.

This means we did the checksum verification even if no corresponding
checksum is populated.

[FIX]
There is already a similar check at verify_bio_data_sectors(), but
unfortunately there is no such check at verify_one_sector().

Add the missing check to skip the csum verification if there is no
corresponding data checksum.

Reported-by: Bartosz Fenski <bartosz@fenski.pl>
Link: https://lore.kernel.org/linux-btrfs/a72409af-45ef-45df-9970-2e38bcb22ea6@fenski.pl/
Fixes: 7a3150723061 ("btrfs: raid56: do data csum verification during RMW cycle")
Cc: stable@vger.kernel.org
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/raid56.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 8ec24dbb180f..38b48e53e11d 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1889,6 +1889,8 @@ static int verify_one_sector(struct btrfs_raid_bio *rbio,
 {
 	struct btrfs_fs_info *fs_info = rbio->bioc->fs_info;
 	phys_addr_t *paddrs;
+	const unsigned int total_sector_nr =
+		stripe_nr + rbio->stripe_nsectors + sector_nr;
 	u8 csum_buf[BTRFS_CSUM_SIZE];
 	u8 *csum_expected;
 
@@ -1898,6 +1900,11 @@ static int verify_one_sector(struct btrfs_raid_bio *rbio,
 	/* No way to verify P/Q as they are not covered by data csum. */
 	if (stripe_nr >= rbio->nr_data)
 		return 0;
+
+	/* No data checksum for this sector. */
+	if (!test_bit(total_sector_nr, rbio->csum_bitmap))
+		return 0;
+
 	/*
 	 * If we're rebuilding a read, we have to use pages from the
 	 * bio list if possible.
@@ -1908,9 +1915,7 @@ static int verify_one_sector(struct btrfs_raid_bio *rbio,
 		paddrs = rbio_stripe_paddrs(rbio, stripe_nr, sector_nr);
 	}
 
-	csum_expected = rbio->csum_buf +
-			(stripe_nr * rbio->stripe_nsectors + sector_nr) *
-			fs_info->csum_size;
+	csum_expected = rbio->csum_buf + total_sector_nr * fs_info->csum_size;
 	calculate_block_csum_paddrs(fs_info, paddrs, csum_buf);
 	if (unlikely(memcmp(csum_buf, csum_expected, fs_info->csum_size) != 0))
 		return -EIO;
-- 
2.55.0

