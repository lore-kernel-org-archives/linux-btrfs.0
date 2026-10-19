Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EB43FCB3D
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392036; cv=none; b=qWoFYKpG0p0NHcb5iEIIJF9girrUJVWQLLD91UwRLehn9p0Y285nmS3jH9Li73ZOgr97datgYruzQpOZ8BLicpBur4JF8aQ+rsaltIzv6zNG1H8ZwrL8+QdhiP2UpHRb+Ls9pa2VCGZumwXLsKIPTXNnV0PwSft4fU15f6oKpS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392036; c=relaxed/simple;
	bh=N4Wi4z30c/RUo0XPSzl3fnQUa4E7z3sdHbiRji7wEA8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uj7V+eENVdT/EiVQgnVIPcvtRlZOwFDv2YfCP9oisIdXGV6IdW+J2toXXe2UV0vgL4jgvMDG35OgJtqOJK3KL6ymVOL35/Y6IiYJZJAy9CW0RYowOYZ/mbu4y8Btd95Ijm3FBbASJUGASkA0dfUB5WfVvXufED4BRPK631AgPcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WBjkZQ5t; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=e81N/lis; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WBjkZQ5t";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="e81N/lis"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D04702200E
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2tTJhEs0h4uKcwmIAq1LYjnuJ38Q80QkIJmsxZWhExU=;
	b=WBjkZQ5tHQFB0gPLKrXceheLDtSCS7zk1ukIwI5SYbYtOBXYeWtAyyReGkUNn9916zYh5c
	zDn+YSLrF2/iBDmoCX7zwWXC2tgE4Uze2ApnP2qZrMOFDH2QG/zTR2csH9x+9ZCdlcszoU
	igBuQnZ9HxrlZ7ygjv8faDG2IPE9PRc=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2tTJhEs0h4uKcwmIAq1LYjnuJ38Q80QkIJmsxZWhExU=;
	b=e81N/lisC2TgzbEuuhyuqQvU//avFz6baYt7MM2ABqGCw5ghaUuMR3Myb+gPhC3b2wB6w7
	rV1IFHnwK66zbmc7pFL1Gxx7zZNdOiXFx+hgGG5hYQ+fdCjk5J3Dlr0b8ZlIBsaIR/mcVx
	xqyF8mjVxTsZ1Pt3DKrPhsV8i/fkHbg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A5D41375D
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 09jKA1i71WpsbgAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:26 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/9] btrfs: reduce the width of num_stripes and sub_stripes
Date: Mon, 19 Oct 2026 17:09:57 +1030
Message-ID: <a5234783282dd9dab22442ee9bfb3a4b2424b931.1792391732.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792391732.git.wqu@suse.com>
References: <cover.1792391732.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

The on-disk btrfs_chunk structure uses u16 for both num_stripes and
sub_stripes, so there is no need to use "int" to represent them in
btrfs_chunk_map.

Follow the on-disk format to use u16 for those members, including
verified_stripes too.

And since verified_stripes is u16, it no longer completely fill the
hole between @refs and @start.
Instead use @num_stripes and @sub_stripes to fill the hole, and leave a 6
bytes hole between @verified_stripes and @stripes.

This doesn't save any space for btrfs_chunk_map, but leaves enough space
for future expansion.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 67464025e449..d97ca875c596 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -623,9 +623,9 @@ extern const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES];
 
 struct btrfs_chunk_map {
 	struct rb_node rb_node;
-	/* For mount time dev extent verification. */
-	int verified_stripes;
 	refcount_t refs;
+	u16 num_stripes;
+	u16 sub_stripes;
 	u64 start;
 	u64 chunk_len;
 	u64 dev_extent_size;
@@ -638,8 +638,8 @@ struct btrfs_chunk_map {
 	 */
 	u64 type;
 	u64 on_disk_type;
-	int num_stripes;
-	int sub_stripes;
+	/* For mount time dev extent verification. */
+	u16 verified_stripes;
 	struct btrfs_io_stripe stripes[];
 };
 
-- 
2.56.0

