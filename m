Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794461222;
	b=yIexdD9FaxDZelFYqQDx9AigaKWENHMy0ussSB7j28Cr0vZRBFowFUAV3hpj+BhwgYAc
	 QVxz71OzJKfOYuMZy2LoRs/OjXezl+Qz7B6UlWmbotb3HJxq29boaSUPwtDJqQ64Mvu81
	 P3tlhxlBe5TmfGlkJSCXFIf3RID+BrJ9ibcj9S+RucP36oHjz6Lb17+nkSzIO/wmGuntw
	 7ko18mBVQRZr3JgxU2cI4kZzaXvk2LneEm6hL+RItYXt600c7kQ+RW5xwI5QReTvCt8+v
	 6FAMpO/bCW3mq3Df7N3iZFwO42zakvAJFRNEvDa+esaaTe18G6kF0l35LKq5JOVOXQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794461222;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=oz/ADgQ4qo1qowW/i6m9uS3Mp6zsqorDc+OW/J1G0cU=;
	b=KMeUQx8UnVjXbv/7/GnVnZb8n7N85LNeZwCANLCF76F3GXRTs+ZZL9zJTKL3qamKMjvB
	 bf1nn2+QPJIx8L5e9IxBX/lww1fxoHa5ihW9aGptNzeQrLerBU2E1KNxTUelDltOV5ka5
	 3PzydZHhKGFpzI5HITUVD8K9fcZHmJXlhEv71A+60Jh/ZpYAoSR+08kRqDP2BUlwOM371
	 XZPRQjVZXP/eDqJDl/I3wTjUJbrKMgmd4CbvV1Zzh/j2uJD2QhTiANyKVTMWU1TLiGcza
	 hJVJRIqlOKladu0eLIY9j2uMIzfyx8x+pQkUry+Wvvk+0tdvn1WT1nq7O+knXlxJ/IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=F8u5oojB;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=F8u5oojB;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54265606A89B
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 05:27:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54265606A89B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=F8u5oojB;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=F8u5oojB
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C58B21E9F
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 05:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794461219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oz/ADgQ4qo1qowW/i6m9uS3Mp6zsqorDc+OW/J1G0cU=;
	b=F8u5oojBxLyTvGARYRMHV8X4GTdpxlGeEi9dez4fpWwD/oS9aH2ur+t+NvIdzTmpIt3L7v
	FpkedB0GauYa2kcxDG5f5Xm8cxkt/IZT+imz0YwDr+33oT5wRcflpj6l30FLYYwi+4Srai
	wIqthoHFEDeNsaOqkEW51bDonSo1BIY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794461219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oz/ADgQ4qo1qowW/i6m9uS3Mp6zsqorDc+OW/J1G0cU=;
	b=F8u5oojBxLyTvGARYRMHV8X4GTdpxlGeEi9dez4fpWwD/oS9aH2ur+t+NvIdzTmpIt3L7v
	FpkedB0GauYa2kcxDG5f5Xm8cxkt/IZT+imz0YwDr+33oT5wRcflpj6l30FLYYwi+4Srai
	wIqthoHFEDeNsaOqkEW51bDonSo1BIY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E22C134A0
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 05:26:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id buNLCCBO9WrVDwAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 05:26:58 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix anon_dev leak when snapshot creation races with a root read
Date: Thu, 12 Nov 2026 15:56:33 +1030
Message-ID: <399fda6a2e930a40447c7562fa97f97c194b83f1.1794461116.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794461116.git.wqu@suse.com>
References: <cover.1794461116.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

[BUG]
When create_snapshot() fails after the new snapshot root is already
cached (e.g. by a backref lookup), an anonymous block device ID can be
leaked.

[CAUSE]
The leak call chain looks like the following:

 create_snapshot()
 |- btrfs_commit_transaction()
 |  \- create_pending_snapshot()
 |     \- pending->snap = btrfs_get_new_fs_root()
 |        \- btrfs_get_root_ref()
 |           |- free_anon_bdev(*anon_dev);
 |           |- *anon_dev = 0;
 |           |  ^^^ found the cached root, freeing the preallocated
 |           |      anon_dev and retry
 |           |
 |           |- root = btrfs_lookup_fs_root()
 |           \- return root;
 |              ^^^ now pending->snap is the cache root.
 |
 |- btrfs_orphan_cleanup() fails
 \- fail:
    \- pending_snapshot->snap->anon_dev = 0
       ^^^ clears the cached root's ID which is not the preallocated ID.
           Futhermore, the old ID is not released, causing a leak.

[FIX]
Make the ownership of the preallocated ID explicit: btrfs_get_root_ref()
now sets *anon_dev to 0 whenever it consumes the ID.

This makes pending_snapshot->anon_dev non-zero only if it has not been
consumed, so the "prevent double freeing" hack in create_snapshot() is no
longer needed.

Remove it, along with the now redundant anon_dev resets in
create_snapshot() and create_subvol().

Thankfully this is really hard to hit, the window is pretty small, so
it's just to make the ID ownership more explicit and consistent.

Fixes: 2dfb1e43f57d ("btrfs: preallocate anon block device at first phase of snapshot creation")
Assisted-by: LLM (planning and coding)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 7 +++++++
 fs/btrfs/ioctl.c   | 8 +-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 78865704b45d..50888d1e3e1e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1297,6 +1297,8 @@ void btrfs_free_fs_info(struct btrfs_fs_info *fs_info)
  * @objectid:	root id
  * @anon_dev:	preallocated anonymous block device number for new roots,
  *		pass NULL for a new allocation.
+ *		If the ID is consumed, *@anon_dev is set to 0.
+ *		Otherwise the caller needs to release the ID.
  * @check_ref:	whether to check root item references, If true, return -ENOENT
  *		for orphan roots
  */
@@ -1390,6 +1392,9 @@ static struct btrfs_root *btrfs_get_root_ref(struct btrfs_fs_info *fs_info,
 		}
 		goto fail;
 	}
+	/* The new root owns the preallocated anon_dev now. */
+	if (anon_dev)
+		*anon_dev = 0;
 	return root;
 fail:
 	/*
@@ -1424,6 +1429,8 @@ struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
  * @objectid:	tree objectid
  * @anon_dev:	if NULL, allocate a new anonymous block device or use the
  *		parameter value if not NULL
+ *		Check the comment of btrfs_get_root_ref() on the lifespan
+ *		of @anon_dev if not NULL.
  */
 struct btrfs_root *btrfs_get_new_fs_root(struct btrfs_fs_info *fs_info,
 					 u64 objectid, dev_t *anon_dev)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 651a780dd7b1..6cd12f586423 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -712,10 +712,8 @@ static noinline int create_subvol(const struct mnt_idmap *idmap,
 		btrfs_abort_transaction(trans, ret);
 		goto out;
 	}
-	/* anon_dev is owned by new_root now. */
-	anon_dev = 0;
 	BTRFS_I(new_inode_args.inode)->root = new_root;
-	/* ... and new_root is owned by new_inode_args.inode now. */
+	/* new_root is owned by new_inode_args.inode now. */
 
 	ret = btrfs_record_root_in_trans(trans, new_root);
 	if (unlikely(ret)) {
@@ -868,11 +866,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 
 	d_instantiate(dentry, inode);
 	ret = 0;
-	pending_snapshot->anon_dev = 0;
 fail:
-	/* Prevent double freeing of anon_dev */
-	if (ret && pending_snapshot->snap)
-		pending_snapshot->snap->anon_dev = 0;
 	btrfs_put_root(pending_snapshot->snap);
 	btrfs_block_rsv_release(fs_info, block_rsv, (u64)-1, NULL);
 	if (qgroup_reserved)
-- 
2.56.0

