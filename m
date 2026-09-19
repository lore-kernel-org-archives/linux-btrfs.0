Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A08D35CB91
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 11:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789816766; cv=none; b=bxe7oRxudJnSFRSgRZuhPaP/Y48vQEHvVx3Qoxmu0cgquDZWJ9scRAvNP3bI+H9w6fVTiS3fsBPoeXFRTjpE1LCW5ESYgZuKgUVWrfZBmDIZ6vhVXF/4fGxFXaMBQ6NhAZRCQzMDmVC/WgLd+Zd8jruS7ZolaFqEBS/+dYbLs0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789816766; c=relaxed/simple;
	bh=e1ckod87+v5n4p3tWmAzrZNAy1iabRm851EkSC8aMGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F52PUqwB0vUFhD4VptLm6w3VvyvBU3MQhDz3h9Ik8MoM5KLQkBO/eOyz6EbJtedCMQbjyrgZhFPNaX20bO1pszCkaxhsRfCK+QApgnEf/MoEjXbFPhHU55z4vusx2CXJmWIDr4d2vi5cbXUO+7rZ0MDsj1vg6AKpcdPFwRPALVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=cKflc7Pw; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ItcPEGNG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="cKflc7Pw";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ItcPEGNG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D30BF1F794;
	Sat, 19 Sep 2026 11:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789816759; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wte6A3kEUTizpUp18qUR9IoDuUd9Roa+F+WgW95af3k=;
	b=cKflc7Pwdks+kZrK+SBv9iuV0rSWmC11YVe5DsL+7idO1L+W6HWhJ2Y07ZheC31403UkQE
	1iEIXn8/MTwRr2oidBzH2WnQ2Hlg4u5naPd21law+W5+I+AOH4GuPuk7gXkvh7xarMqsOt
	TxG8HFIvtt+sdvJVDreqZ/qjaY6Ohn4=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789816754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wte6A3kEUTizpUp18qUR9IoDuUd9Roa+F+WgW95af3k=;
	b=ItcPEGNG1rdNwq1ls7bdsZeT8pKybTdvWx13sQ+hELkdo31WrEoN4Q0NIL474GKFaKheAj
	LY1i13fP+D/EWicdLUQIqNfaJ+CJxufaHkrMGTcf5Ju/eoZVt+G1aAOgDXx0HpI/yk+pze
	ohweTMEgJKQjsAu/a+14LYaB52LI9b4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4427B139B7;
	Sat, 19 Sep 2026 11:19:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fM2AF61vrmrlBAAAD6G6ig:T3
	(envelope-from <wqu@suse.com>); Sat, 19 Sep 2026 11:19:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
Subject: [PATCH 2/2] btrfs: remove the trailing zeros from compressed inline extent
Date: Sat, 19 Sep 2026 20:48:51 +0930
Message-ID: <58287748ca64ccbc8d0de86aee3e4da59149ca1d.1789816636.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789816636.git.wqu@suse.com>
References: <cover.1789816636.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kernelorg];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

[BEHAVIOR CHANGE]
After commit 3eaf5f082c4c ("btrfs: extract inlined creation into a
dedicated delalloc helper"), btrfs changed its behavior when generating
compressed inlined extents.

Previously the compression input was the file range [0, i_size), but
after that commit the input is file range [0, sectorsize).

This means the decompression handling needs to have a buffer that is no
smaller than sectorsize, or the decompression will fail.

This has already caused problems for other projects, like u-boot and
btrfs-restore from btrfs-progs.
Although those projects are fixed with a more robust decompression path,
this kernel change also causes extra space usage for compressed inlined
extents:

 All doing a 3K writes with content filled with 0xcd

 Before:
        item 6 key (257 EXTENT_DATA 0) itemoff 15794 itemsize 69
                generation 9 type 0 (inline)
                inline extent data size 48 ram_bytes 3072 compression 2 (lzo) encryption 0

 After:
         item 6 key (257 EXTENT_DATA 0) itemoff 15781 itemsize 82
                generation 9 type 0 (inline)
                inline extent data size 61 ram_bytes 3072 compression 2 (lzo) encryption 0

This behavior change also increased the lzo compressed size from 48 bytes to 61 bytes.

[FIX]
Previous patch "btrfs: fix the incorrect lzo space saving checks"
fixed a regression in lzo_compress_bio() where it doesn't properly handle
inlined extents.

With that regression fixed, we can finally just pass range [0, i_size)
into btrfs_compress_bio(), and this gets rid of the trailing zeros,
getting back the old behavior, along with the older compression ratio.

Fixes: 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated delalloc helper")
Reported-by: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/c97652a5-ac6b-4de6-aa23-3cdebc01d00b@gmail.com/
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
This is mostly the v1 fix from Filipe, the missing part is the fix in
the lzo path, which is now a dedicated patch.

If this solution is fine, I'll use Filipe's v1 fix instead, although I'd
prefer to keep the extra compressed size check as one extra final safenet to
catch unexpected LZO payload paddings.
---
 fs/btrfs/inode.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 53f4532593b3..5e083ea5c577 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2342,12 +2342,7 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 		} else if (inode->prop_compress) {
 			compress_type = inode->prop_compress;
 		}
-		/*
-		 * We need to pass blocksize and not i_size, otherwise we can't
-		 * create compressed inline extents for data smaller than sector
-		 * size with lzo.
-		 */
-		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
+		cb = btrfs_compress_bio(inode, 0, i_size, compress_type, compress_level, 0);
 		if (IS_ERR(cb)) {
 			cb = NULL;
 			/* Just fall back to non-compressed case. */
-- 
2.55.0

