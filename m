Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F2A2FFF81
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 09:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783846824; cv=none; b=BUvrA8RT6ZS7+LYs2jfZtVfslw07gNVKpOj+JwCCemC91coN0jNxZq/GSJoRrw6AcRatP/JJAEQstmzwYEVmgIASMzX6C+bvzCOYyRuoZzKvm9P8lXEQ78x0sV553qJW56SjM3Hu0PMqDJgjPOuR6ieXmXLGwUbe1qg5PntXNLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783846824; c=relaxed/simple;
	bh=9dgolWs8lgRCXAuWoE7ul8jyERYUKbLUhG6RZyVRkzw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=G90Y/AUA4qjSmBuqHhxUg4+Kh/9anaCtkFM5JHXCNe0+wtThk5/Vw//Nif7NFB8g6KDZPs/YKjOiCdaNldqMmkfEDZ++/t+bWEgmADdTtT4FRfswX4PcjMxaZnMRgwNm/gOIx5izEoc/E4soOj93PPeNkphKOtVDtoewF8ApJXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RcbrpfE4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RcbrpfE4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RcbrpfE4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RcbrpfE4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 443D07720B
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 09:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783846821; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=e4Mfe/Jdeb6LQSCZjYTUKXEa1x3uhU16Ycc2ncuBJ5Y=;
	b=RcbrpfE4xupmAJSUlL6Ony8KotWglcu+HXE3n4KMhTe2VmwnWwPIumMiJiO1blb4Kuuk6V
	p5I7hqgUx6ozd7R5MJaPeUseUBmrVxvtf2oPF6T4J8yboqdCvmz98+aMF5dDJSN3ABt8EI
	569xK3foy4PjKBG3vIblipvjHNj8Q9w=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783846821; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=e4Mfe/Jdeb6LQSCZjYTUKXEa1x3uhU16Ycc2ncuBJ5Y=;
	b=RcbrpfE4xupmAJSUlL6Ony8KotWglcu+HXE3n4KMhTe2VmwnWwPIumMiJiO1blb4Kuuk6V
	p5I7hqgUx6ozd7R5MJaPeUseUBmrVxvtf2oPF6T4J8yboqdCvmz98+aMF5dDJSN3ABt8EI
	569xK3foy4PjKBG3vIblipvjHNj8Q9w=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 82787779B5
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 09:00:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6HVTEaRXU2reCQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 09:00:20 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: raid56: fix an incorrect csum skip during rmw
Date: Sun, 12 Jul 2026 18:30:02 +0930
Message-ID: <757cd3e5422b7a880fc853a32037a031e189149c.1783846776.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

Commit 7425a2894019 ("btrfs: introduce btrfs_bio_for_each_block_all()
helper") uses the new helper to replace the nested loop inside
verify_bio_data_sectors(), which simplifies the code.

However that also changed the behavior of "continue" when a block has no
data checksum.

Previously the "continue" will skip the old for() loop, which will also
increase @total_sector_nr.

Now the "continue" will skip the new btrfs_bio_for_each_block_all()
loop, which doesn't update @total_sector_nr.

This will affect RMW workflow, as RMW will load the data checksum, and
rely on that to recover any corruption before generating P/Q stripes.
Now if we hit a single block without checksum, we will skip verifying
the remaining data, and will use corrupted data to generate P/Q, killing
the old chance of recovery.

Thankfully this doesn't affect recover nor scrub.
For recover we never populate the data checksum and rely on the caller
to do the verification.
For scrub it's pretty much the same, the data stripe verification is
done by scrub before updating P/Q stripes.

Fix it by increasing @total_sector_nr before calling "continue".

Fixes: 7425a2894019 ("btrfs: introduce btrfs_bio_for_each_block_all() helper")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Update the subject and commit message
  This doesn't affect scrub nor rebuild, but RMW.
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

