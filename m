Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE821F130B
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 09:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780047392; cv=none; b=NGKhYAEqRoqDJEXozZOTgRZQqc73WhuEgrC5745uoQcUtz0WmT2WqGZVgN+moKO1UZPFPAHFBQsrROtN8udrnDYPftYwntfIU8wZ3ibcQoTJZpJwE/x2VrsLKPQwiOZDpzAlJttbDa+A0oEMHKIBRcRTB9QaFi9JUHT3r740ieM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780047392; c=relaxed/simple;
	bh=OxjAxYRD5Yum8E752nfdrUE9wRyDCBc2y9AekhNtVdA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bi708kgFF5R66j5qGUYq9amJIUT6G0Z97p7O0dctGRYOfPhzQloJECsTCXxhowvS4dxnHCna5G6EyejwyXIJ4vav7CNCDNAFBfJXXtkjum77Yhx1tSq/l6TZalzSqWxKEfZjINnHxMemCsozJw9mBGqyx5Jiz4RBu7/OPMqUaic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=k4O6coWb; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Y4LzwE3R; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="k4O6coWb";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Y4LzwE3R"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 55FB8672B9
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 09:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780047384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MRZw+WbW7gn588xejBbNg5NKGXo24KY8Qc+h+L7Xg7g=;
	b=k4O6coWbOEMVrl8+lkS3AYDo4G9MFlBrmh1luZmWsb7/eNYFz6mLHrokCxoAeoaj4pvIs/
	EL+vENNRdNIHutzJgSQBTVIgdrhNm7ZRVklO34G40TdhJWJu4vlXQIYWJpgmAwtQnKRayC
	8wPuuGelnLKqdCiGbOI9DvxnJ/6htBQ=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Y4LzwE3R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780047383; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MRZw+WbW7gn588xejBbNg5NKGXo24KY8Qc+h+L7Xg7g=;
	b=Y4LzwE3RdNfBh7R1GGlQAadvakIw3VBZnIPUnwLd6/sUqHNOGsLpyJjPJe4YtHaB0Ucy9E
	xCKiPaB2+3snAkaNfGNu1Yl/7KpmirY84+XSBUIWZqORnts++/Deej2kyGMyDzVKkNk7eZ
	ee5beiM4wwzWekCtnevdzj7TblXfHpQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96284779A7
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 09:36:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qD5nFhZeGWqfWgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 09:36:22 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: dump-tree: fix the chunk type check for system chunks
Date: Fri, 29 May 2026 19:06:17 +0930
Message-ID: <47d51544e0e919a9b43d01508b92fb23ead8c759.1780047275.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780047275.git.wqu@suse.com>
References: <cover.1780047275.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 55FB8672B9
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

[BUG]
Commit 408e45feb325 ("btrfs-progs: dump-tree: add extra chunk type
checks") introduced one extra check on when using "btrfs ins dump-tree
-b <bytenr>" option, to prevent end users from passing logical address
belonging to data chunks.

However that check forget that we also have metadata in system chunks,
thus will cause the following false alerts:

 # mkfs.btrfs -f $dev
 # btrfs ins dump-tree -t chunk $dev | grep "owner CHUNK_TREE"
 leaf 22036480 items 4 free space 15781 generation 8 owner CHUNK_TREE
 ^^^ This means we can still print the chunk tree

 # btrfs ins dump-tree -b 22036480 $dev
 btrfs-progs v6.19.1
 ERROR: logical 22036480 is not in a metadata chunk, found chunk 22020096 len 8388608 flags 0x22

[CAUSE]
I'm an idiot and forgot to check system chunks.

[FIX]
Add system chunk type into the check.

Fixes: 408e45feb325 ("btrfs-progs: dump-tree: add extra chunk type checks")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds/inspect-dump-tree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds/inspect-dump-tree.c b/cmds/inspect-dump-tree.c
index 8f384d3561c9..0d58e398f636 100644
--- a/cmds/inspect-dump-tree.c
+++ b/cmds/inspect-dump-tree.c
@@ -206,8 +206,9 @@ static int check_metadata_logical(struct btrfs_fs_info *fs_info, u64 logical)
 		return -ENOENT;
 	}
 	map = container_of(ce, struct map_lookup, ce);
-	if (!(map->type & BTRFS_BLOCK_GROUP_METADATA)) {
-		error("logical %llu is not in a metadata chunk, found chunk %llu len %llu flags 0x%llx",
+	if (!(map->type & (BTRFS_BLOCK_GROUP_METADATA |
+			   BTRFS_BLOCK_GROUP_SYSTEM))) {
+		error("logical %llu is not in a metadata/system chunk, found chunk %llu len %llu flags 0x%llx",
 		      logical, ce->start, ce->size, map->type);
 		return -EINVAL;
 	}
-- 
2.54.0

