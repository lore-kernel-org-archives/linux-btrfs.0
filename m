Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554011;
	b=iigbd5KgnpYojr/qHPBOWNijbgvVcgfx2rmNZdQvCByUCZJcFAQLxq/kJiG41a4EWxrS
	 7ayW/d9wsEaZUy15bpKsHRw6GmEX3raYEKejlFMaCQwmaJFtUXDH3o58n5II8W2rJPT3a
	 HrXU+yaFEpVYx/VqiWIystTgztQ7ZoieqsPsfq1RkT3tJeIeqHVr9BRwy2UzYUuANW5Im
	 9ppBxKVru/UHMLoCshmH6jhZWBk8B2AM35aYKYihcKKYeVdvqzbwAa+FKTgTC2ho7088H
	 chmIlXGsyDk6DIC/tzsxURX49vGlW77hqAxh9yB6hiO1Rm5ftqiFH9Db/HfKgEIBkJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554011;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=5nqZVzVWUNT18ZKTm+YAaZWMNeUiJ1Q7asXA4YkVSNU=;
	b=tyqFYZ+WMwXP0bA98SF1pWrD365do8f62grJeQKiRc6sIDd7Q5U49BkIcP1JXnd8+TqL
	 9ERFQBeWuvizqgi4fVBA9gU297kzrccSKhpBZlILF7IUoTwVrTEkhWctB0FAQ2bLPoOnl
	 n15A2ODkVkXjbFwQT5Fun5bW7qsf5uB8ayLRPYO+XoMsQSWPnVIk0XTSPf8qfgOnJ4dca
	 41aV/w6PowWv3VS0DTD7/zt7Us7jrPPX4xvvinxNEsfUa4cGGiaAStOIkjy+SsofG03bg
	 /xBXbazyI5pWAHhA1XQ4ESfVQOzqrhxIyPR+cjyKo2xvHXwFZ07IZt6U7oTh4UE+lsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ovXzsj2A;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ovXzsj2A;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2B2606A322
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD2B2606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ovXzsj2A;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ovXzsj2A
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 410701F7F1;
	Wed, 21 Oct 2026 03:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554009; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5nqZVzVWUNT18ZKTm+YAaZWMNeUiJ1Q7asXA4YkVSNU=;
	b=ovXzsj2AttmDpJStf2SX7gwXhmm6ePS0By/8kTgHUjqXjvzRk4TO/oS1mVtiAcTzo+0S2Q
	yCyIe/cQ6T3SUrBzW8keUI37idfzTYGfdlLXNC6dIx9aZmkdlzIvGqFXZnF6O6/3u3VNYL
	uBS3fC7JichK/WBbhiTRWvMXzdZ/MLQ=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554009; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5nqZVzVWUNT18ZKTm+YAaZWMNeUiJ1Q7asXA4YkVSNU=;
	b=ovXzsj2AttmDpJStf2SX7gwXhmm6ePS0By/8kTgHUjqXjvzRk4TO/oS1mVtiAcTzo+0S2Q
	yCyIe/cQ6T3SUrBzW8keUI37idfzTYGfdlLXNC6dIx9aZmkdlzIvGqFXZnF6O6/3u3VNYL
	uBS3fC7JichK/WBbhiTRWvMXzdZ/MLQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D6C67134A5;
	Wed, 21 Oct 2026 03:40:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4EIhJRU02GpeeQAAD6G6ig:T2
	(envelope-from <wqu@suse.com>); Wed, 21 Oct 2026 03:40:07 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 1/9] btrfs: reduce the width of num_stripes and sub_stripes
Date: Wed, 21 Oct 2026 14:09:35 +1030
Message-ID: <2d11e7fb359ff98e9df1e2e2287afdf0c001fbab.1792553748.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792553748.git.wqu@suse.com>
References: <cover.1792553748.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,wdc.com:email,suse.com:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,wdc.com:email,suse.com:email]
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

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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

