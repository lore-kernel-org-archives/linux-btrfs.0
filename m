Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980DA1A317D
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Feb 2026 03:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771211933; cv=none; b=LTikOmGkfx97QyUIyt2cHz5ImDLOMYR7pZXzQX0c52WzU1hXnl6tRsOrP3DRJgC1yp9V8YrXFXbVw6Wjoy/RiGXYH0aeWFfYiSiac/SjGxIVCnPb5rh3Cq6i26IaZ7t0VLqr+jX68+AUFiSEpeu9z6ADA3ylcgvDNoVkIz439Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771211933; c=relaxed/simple;
	bh=CtJNjRpFQcdFn76G8PFmePltuw/VNR1/U6A/E65wQeg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rVSz8Vrkt3Tt5L1MHQhqIsuTxLw1f0G3BfbUQwrk1r0onwMFZaN8ckq0DZutvztJ9Yr5ahQF4meznGAR8skR0aeJ1FWTjJUyf/Rcjw1pAt9X/aV599ZWlKzUJev62pNL2QIJesXuNkEuJ5fsNkwg7L+lvnZJkbpUody+8jDfLKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LxguobRa; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LxguobRa; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LxguobRa";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LxguobRa"
Received: from x1pro.suse.cz (unknown [IPv6:2a07:de40:6183:1a::1022])
	by smtp-out1.suse.de (Postfix) with ESMTP id 32A553F26E;
	Mon, 16 Feb 2026 03:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771211930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OJ6ReTypNNQEoX8ylYb19hiniXUsOHHTtAetayTOIhA=;
	b=LxguobRaPC/y+6qzhBr/I0TSRv4htqUp0qEqFjnJPTTw5K1ZsiDEn0cGcnZ19l1hI+1vKW
	728o7TKB9XnKrYWlw8M6a6fjRsgjNtIh41ByXLhFn/tDD+ZO4vCzMmPY75r8VWzVzsIAzQ
	r16YbYHmxOx7LsZOwbcU3OvAY8h0pV4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=LxguobRa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771211930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OJ6ReTypNNQEoX8ylYb19hiniXUsOHHTtAetayTOIhA=;
	b=LxguobRaPC/y+6qzhBr/I0TSRv4htqUp0qEqFjnJPTTw5K1ZsiDEn0cGcnZ19l1hI+1vKW
	728o7TKB9XnKrYWlw8M6a6fjRsgjNtIh41ByXLhFn/tDD+ZO4vCzMmPY75r8VWzVzsIAzQ
	r16YbYHmxOx7LsZOwbcU3OvAY8h0pV4=
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] btrfs: do not mark inode incompressible after inline attempt failed
Date: Mon, 16 Feb 2026 13:48:47 +1030
Message-ID: <d1f0953814413fbcace1d625ce1227b9aa2d7c0a.1771211471.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [16.68 / 50.00];
	SPAM_FLAG(5.00)[];
	NEURAL_SPAM_LONG(3.50)[1.000];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_SPAM_SHORT(2.99)[0.996];
	HFILTER_HOSTNAME_UNKNOWN(2.50)[];
	RDNS_NONE(2.00)[];
	ONCE_RECEIVED(1.20)[];
	HFILTER_HELO_IP_A(1.00)[x1pro.suse.cz];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	HFILTER_HELO_NORES_A_OR_MX(0.30)[x1pro.suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	DIRECT_TO_MX(0.00)[git-send-email 2.52.0];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:6183:1a::1022:from];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_ZERO(0.00)[0];
	URIBL_BLOCKED(0.00)[x1pro.suse.cz:helo,suse.com:mid,suse.com:dkim,suse.com:email];
	TO_DN_NONE(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email]
X-Spam-Flag: YES
X-Spamd-Bar: ++++++++++++++++
X-Rspamd-Queue-Id: 32A553F26E
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: add header
X-Spam-Level: ****************
X-Spam-Score: 16.68
X-Spam: Yes

[BUG]
The following sequence will set the file with nocompress flag:

  # mkfs.btrfs -f $dev
  # mount $dev $mnt -o max_inline=4,compress
  # xfs_io -f -c "pwrite 0 2k" -c sync $mnt/foobar

The resulted inode will have NOCOMPRESS flag, even if the content itself
(all 0xcd) can still be compressed very well:

	item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
		generation 9 transid 10 size 2097152 nbytes 1052672
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 257 flags 0x8(NOCOMPRESS)

Please note that, this behavior is there even before commit 59615e2c1f63
("btrfs: reject single block sized compression early").

[CAUSE]
At compress_file_range(), after btrfs_compress_folios() call, we try
making an inlined extent by calling cow_file_range_inline().

But cow_file_range_inline() calls can_cow_file_range_inline() which has
more accurate checks on if the range can be inlined.

One of the user configurable condition is the "max_inline=" mount
option. If that value is set low (like the example, 4 bytes, which can
not store any header), or the compressed content is just slightly larger
than 2K (the default value, meaning a 50% compression ratio),
cow_file_range_inline() will return 1 immediately.

And since we're here only to try inline the compressed data, the range
is no larger than a single fs block.

Thus compression is never going to make it a win, we fallback to mark
the inode incompressible unavoidably.

[FIX]
Just add an extra check after inline attempt, so that if the inline
attempt failed, do not set the nocompress flag.

As there is no way to remove that flag, and the default 50% compression
ratio is way too strict for the whole inode.

Cc: stable@vger.kernel.org
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
This is the smallest fix for backport.

There will be a proper but much bigger fix to extract the inline attempt
into a dedicated helper inside run_delalloc_range() other than put them
deep inside cow_file_range() and compress_file_range().
---
 fs/btrfs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 19c6fbb1273c..4523b689711d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1061,6 +1061,12 @@ static void compress_file_range(struct btrfs_work *work)
 			mapping_set_error(mapping, -EIO);
 		return;
 	}
+	/*
+	 * If a single block at file offset 0 can not be inlined, fallback
+	 * to regular writes without marking the file incompressible.
+	 */
+	if (start == 0 && end <= blocksize)
+		goto cleanup_and_bail_uncompressed;
 
 	/*
 	 * We aren't doing an inline extent. Round the compressed size up to a
-- 
2.52.0

