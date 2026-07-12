Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EEEC8EB
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 03:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783827793; cv=none; b=AkyPBTkNaglfvvjWCQLU3/7rlXQOSGDgSL+9AlS9jnkQypegBpEBhZ+MpNJgfWzyzaEC9uSIp4ucPGbZfteX2kSOMdnHCRNecqWyC3kn/ppyyXbcPz/ylnZrSmmpUoOSavxddQE2kzU6adYjfmqWKjRSmuwJguMNXXBY9ZBAjTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783827793; c=relaxed/simple;
	bh=w+GTGA7YsIQTgz6RPy2DWwTgBXxXKvunYj081K8/jsA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Fy9tRFO98vBir0wrBXjmlS6phZedIb3g9sg9UF0KZ9tVvD5pEGrF26LK9hKWATsWm36j+QVAS4PqKCCY7QUDTpPaQmANylpsTR5gN9NKmMVV3ICE5BBV6rnzoAo07w+SKhUY4Evz6eGScJBqKccnjiul1RDb3e95ggB0ur/8U4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gxJJWGMZ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ajrXjU9I; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gxJJWGMZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ajrXjU9I"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DCB8E76DD7
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 03:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783827790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ErpRnTXh89vd67icLIkmb1g1AS/H6LrRk+Ee461KiSU=;
	b=gxJJWGMZ57e7H2z1td6/U03k5EkldErUNZfEVwYq+kSfs0Opd9o9sKjOVmiKkpTVzUKe22
	XndBD1RQ8aqmppVLUyLV++JSQu4SKueVTpSZx2AHx5Nt46tHDb/WH2a6KmdThvHa1Ek+PZ
	Re3lCIdBpgFkATR1L3i23zP+bJ3iET0=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ajrXjU9I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783827789; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ErpRnTXh89vd67icLIkmb1g1AS/H6LrRk+Ee461KiSU=;
	b=ajrXjU9ISFfHRmyf/tFJIBOJkEY5L5xbxrjoeTfB53bElz+33JZvzsUybl3CRlFBN59sAD
	XApOIAodECiTiPC+38GzAt0d3SgX+FMeevXMuPfwQeYiUqLwcfDQk92wphIoZeBefPQpMt
	M7hKPTYuvn4lGj9jGAVVVRqZyL0s4SA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 26590779B5
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 03:43:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0Ph6NkwNU2qAaQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 03:43:08 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: raid56: fix an incorrect csum skip during scrub
Date: Sun, 12 Jul 2026 13:12:51 +0930
Message-ID: <d687c3aa28b09bcd90bfea33afc9e907f2ee57ef.1783827722.git.wqu@suse.com>
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
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: DCB8E76DD7
X-Spam-Score: -3.01

Commit 7425a2894019 ("btrfs: introduce btrfs_bio_for_each_block_all()
helper") uses the new helper to replace the nested loop inside
verify_bio_data_sectors(), which simplifies the code.

However that also changed the behavior of "continue" when a block has no
data checksum.

Previously the "continue" will skip the old for() loop, which will also
increase @total_sector_nr.

Now the "continue" will skip the new btrfs_bio_for_each_block_all()
loop, which doesn't update @total_sector_nr.

This means if we hit a block that has no data checksum, we will skip all
the remaining blocks no matter if they have data checksum.
As @total_sector_nr will never be updated, and that test_bit() will
always return false.

Fix it by increasing @total_sector_nr before calling "continue".

Fixes: 7425a2894019 ("btrfs: introduce btrfs_bio_for_each_block_all() helper")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/raid56.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index baaa18b3c958..885602ab6448 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1679,8 +1679,10 @@ static void verify_bio_data_sectors(struct btrfs_raid_bio *rbio,
 			continue;
 
 		/* No csum for this sector, skip to the next sector. */
-		if (!test_bit(total_sector_nr, rbio->csum_bitmap))
+		if (!test_bit(total_sector_nr, rbio->csum_bitmap)) {
+			total_sector_nr++;
 			continue;
+		}
 
 		expected_csum = rbio->csum_buf + total_sector_nr * fs_info->csum_size;
 		btrfs_calculate_block_csum_pages(fs_info, paddrs, csum_buf);
-- 
2.54.0

