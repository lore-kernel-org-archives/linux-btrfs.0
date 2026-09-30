Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DACE472F86;
	Wed, 30 Sep 2026 09:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758840; cv=none; b=kqjXvKvnJSkMzPCXQgFILTU6aV50oT1lkfLq1LSdsX7kMKoWhqqgvEU95XowMZMbonBzzi5RyNUgzF2yXFoJoYbo8Oz0woA5o9UoABq8P08VIcbw/Jx3A/GNNboTockR0395Pmia7+0dieFrFtRAFH1Lc2R5FQjrDb3Nc8woS9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758840; c=relaxed/simple;
	bh=fEjGsQimbdESRBDFcPr0XIfPdbwfARu5eK8xFiRRHAM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CNfQO8OpjthSrINo2qLM7ZGtL7bgFc0iK4rhmAAkvYN/IloLqTT6PXWO9oOUrln+Gnph9X71xYRdF10znrPE25FcL+G1PrHG9dMYJfOvWQYM8f0yHxPvE5MdCrJ/e02F6GkEKp+o5/5OO7WPmGAh/mCZJuwECZclES6CjWYMmBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=u0/6P6rM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gzRxEM1r; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="u0/6P6rM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gzRxEM1r"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1F6CC21A85;
	Wed, 30 Sep 2026 09:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790758827; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1C8no6pilB4V85Md09gq48eBgFXJsan1yb9Pg180/xU=;
	b=u0/6P6rMJIBZLnF3cNu2GrqGz7vQIJ+Ay4UlL+qYQgEtgGEJas5E4R6KhGsnlwalM1sUwL
	382ZdZsj68eTDL/Vh4z/rhfKCS4G4JTMFe7kJG93AzsGcXdNS+gd93Xj33Tv+pWpZi+BPE
	4tYIqh5I8ShxDwvPdxt3mGO85sjblLg=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=gzRxEM1r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790758823; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1C8no6pilB4V85Md09gq48eBgFXJsan1yb9Pg180/xU=;
	b=gzRxEM1rHnVuX4RlfMCqNJ6FJpk+U7q9ghsdo1yy4DL7fla6Sv77WlwufE6y7yJuy/Gcl8
	uAy5p7pHFS4VkGhpZIIOYpTgfxM66RFbQtTP8xGCtHQnj61bgW3YJCY1FUPcbGRgo0YcWv
	e54fu3wksvuyaQ9PwCu8iS+ezAc1YPk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4CC5A13A90;
	Wed, 30 Sep 2026 09:00:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zAdiJqTPvGouGwAAD6G6ig
	(envelope-from <wqu@suse.com>); Wed, 30 Sep 2026 09:00:20 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Bartosz Fenski <bartosz@fenski.pl>,
	stable@vger.kernel.org
Subject: [PATCH v2] btrfs: raid56: do not verify the content if there is no data checksum
Date: Wed, 30 Sep 2026 18:29:58 +0930
Message-ID: <4ee4d3cf8971d35eb863407808c896d6120bcc59.1790758765.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1F6CC21A85
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,fenski.pl:email,suse.com:mid,suse.com:email,suse.com:dkim];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[3];
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
Changelog:
v2:
- Fix the calculation in the total_sector_nr
  Which used "+" instead of "*" for the stripe_nr part.
---
 fs/btrfs/raid56.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 8ec24dbb180f..5ec31299f1c3 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1889,6 +1889,8 @@ static int verify_one_sector(struct btrfs_raid_bio *rbio,
 {
 	struct btrfs_fs_info *fs_info = rbio->bioc->fs_info;
 	phys_addr_t *paddrs;
+	const unsigned int total_sector_nr =
+		stripe_nr * rbio->stripe_nsectors + sector_nr;
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

