Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917746;
	b=Ygff+IGvxJKfLqPoGiKpMY1nGsHL6k59VS/851aazekgtczLr9po5stZxzq9qVGQogFg
	 MKCNQXt7S8nRYPwki/LyXvzz/SIlfcqKBDFRuKICISavcpEG5F1jBk5qVmrgOuZo4tJua
	 Ol+TGBFmFXs5exgJAR316bNWBaoZKoatPOsIkf3yikwE2AXJ/tf2bcf6w/cHywUFqBxya
	 TaYWXZYievrADjM1ZMlUeqgLHikVwbQmaaxa6DdhdiyK9RME2FYX2QfGmkKyT5/qa5EpR
	 9dly8kBRXNDvyb4dzIv6qh1h+A03FEGYYa1qdFUVbDXxpeg6lK8P35VDX/35j+yRB/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917746;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=FCaYwBLfA7HMD5wUjAlqks6i8u+rS++5es1onTLlG+E=;
	b=A/Y8C3ipa5Lk/rmXtdmraKd6Lbi5Vdrkz4L3bLgN2U6XpJl6ajnWy/670dBBzN7DeU5/
	 O92m3U0Flx5vLkdUEHAJglNOT9MBTR3biwrbVw2pRFKBFxTrq60mmWqW5MPPGx+zIDFBN
	 WZetsUaDAHMSE8w4HF+qd0jxEJIdq3NHnIqcQrGvcJqlBQ8JFh25ogmNZhHaljtUgIBSj
	 VThFl+32j1nt+eHkqgzFFIVDQQtBaOVUMQ1LLnAvACII3bC3olSXuEqxUUg4WeKtq+yPX
	 bRDN7ph37kWknNqF+4YrspHYp34BmQeOSRapPC1j7J629V78h1swtNL7x5Yu/r/tkVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=IjY8y0Ay;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=IjY8y0Ay;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE639606A31B
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE639606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=IjY8y0Ay;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=IjY8y0Ay
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 41F2E1F395
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FCaYwBLfA7HMD5wUjAlqks6i8u+rS++5es1onTLlG+E=;
	b=IjY8y0AyTAEPvEme2Q+yzY3PtqIqsiNTpLABso/he5Jlg5TdauD1AZt9yQ8zIDEg2psZjf
	T47oMoYrgedhQ2lLe8TwYN+L6mrrFss63HWfKKWbO/baNFl7LBV+Fembk3SGEJJywL4+Wj
	ly4orzxJaCcPmLD8JXk8de+n3zy4H54=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FCaYwBLfA7HMD5wUjAlqks6i8u+rS++5es1onTLlG+E=;
	b=IjY8y0AyTAEPvEme2Q+yzY3PtqIqsiNTpLABso/he5Jlg5TdauD1AZt9yQ8zIDEg2psZjf
	T47oMoYrgedhQ2lLe8TwYN+L6mrrFss63HWfKKWbO/baNFl7LBV+Fembk3SGEJJywL4+Wj
	ly4orzxJaCcPmLD8JXk8de+n3zy4H54=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B3C913314
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mglvH9zA3Wq5HgAAD6G6ig:T12
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:22 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/12] btrfs-progs: image: reject incorrect super block size
Date: Sun, 25 Oct 2026 19:11:45 +1030
Message-ID: <160e4f485cd2264151dd967fe0a8a650024bfce7.1792914402.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792914402.git.wqu@suse.com>
References: <cover.1792914402.git.wqu@suse.com>
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

For an uncompressed image, if the super block size is smaller than
BTRFS_SUPER_INFO_SIZE, we know it's definitely corrupted, reject it or
later code can read beyond the allocated buffer.

This covers the following cases:

- build_chunk_tree()
  * Validate the compression level
  * Check the uncompressed super block size
  * Handle short decompression

- add_cluster()
  * Validate the compression level

- fill_mdres_info()
  if build_chunk_tree() is skipped, we read super block here.

  * Check the uncompressed super block size
  * Call btrfs_check_super() to validate the super block
  * Handle short decompression

Assisted-by: LLM (exposing the bug)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/image-restore.c | 42 ++++++++++++++++++++++++++++++++++++++----
 image/metadump.h      |  7 +++++--
 2 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/image/image-restore.c b/image/image-restore.c
index 525cdd4d32bc..7f3c9fdb6536 100644
--- a/image/image-restore.c
+++ b/image/image-restore.c
@@ -1141,6 +1141,11 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 		error("bad header in metadump image");
 		return -EIO;
 	}
+	if (header->compress >= COMPRESS_LAST) {
+		error("unsupported compression, has %u expect < %u",
+		      header->compress, COMPRESS_LAST);
+		return -EUCLEAN;
+	}
 
 	mdres->compress_method = header->compress;
 	nritems = get_unaligned_le32(&header->nritems);
@@ -1165,6 +1170,17 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 		return -EINVAL;
 	}
 
+	/*
+	 * The super block may get merged with the next block. So here
+	 * only reject uncompressed size that is smaller than a sb.
+	 */
+	if (mdres->compress_method == COMPRESS_NONE &&
+	    get_unaligned_le32(&item->size) < BTRFS_SUPER_INFO_SIZE) {
+		error("incorrect super block size, has %u expect >= %u",
+		      get_unaligned_le32(&item->size), BTRFS_SUPER_INFO_SIZE);
+		return -EUCLEAN;
+	}
+
 	buffer = malloc(get_unaligned_le32(&item->size));
 	if (!buffer) {
 		error_mem(NULL);
@@ -1188,8 +1204,8 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 			return -ENOMEM;
 		}
 		ret = uncompress(tmp, (unsigned long *)&size, buffer, get_unaligned_le32(&item->size));
-		if (ret != Z_OK) {
-			error("decompression failed with %d", ret);
+		if (ret != Z_OK || size < BTRFS_SUPER_INFO_SIZE) {
+			error("decompression failed or short result");
 			free(buffer);
 			free(tmp);
 			return -EIO;
@@ -1288,17 +1304,29 @@ static int fill_mdres_info(struct mdrestore_struct *mdres,
 			return -ENOMEM;
 		ret = uncompress(buffer, (unsigned long *)&size,
 				 async->buffer, async->bufsize);
-		if (ret != Z_OK) {
-			error("decompression failed with %d", ret);
+		if (ret != Z_OK || size < BTRFS_SUPER_INFO_SIZE) {
+			error("decompression failed or short result");
 			free(buffer);
 			return -EIO;
 		}
 		outbuf = buffer;
 	} else {
 		outbuf = async->buffer;
+		/* The same check in build_chunk_tree(). */
+		if (async->bufsize < BTRFS_SUPER_INFO_SIZE) {
+			error("incorrect super block size, has %zu expect >= %u",
+			      async->bufsize, BTRFS_SUPER_INFO_SIZE);
+			return -EUCLEAN;
+		}
 	}
 
 	super = (struct btrfs_super_block *)outbuf;
+	ret = btrfs_check_super(super, 0);
+	if (ret < 0) {
+		free(buffer);
+		error("invalid superblock");
+		return ret;
+	}
 	mdres->nodesize = btrfs_super_nodesize(super);
 	if (btrfs_super_incompat_flags(super) &
 	    BTRFS_FEATURE_INCOMPAT_METADATA_UUID)
@@ -1322,6 +1350,12 @@ static int add_cluster(struct meta_cluster *cluster,
 	int ret;
 
 	pthread_mutex_lock(&mdres->mutex);
+	if (header->compress >= COMPRESS_LAST) {
+		pthread_mutex_unlock(&mdres->mutex);
+		error("unsupported compression, has %u expect < %u",
+		      header->compress, COMPRESS_LAST);
+		return -EUCLEAN;
+	}
 	mdres->compress_method = header->compress;
 	pthread_mutex_unlock(&mdres->mutex);
 
diff --git a/image/metadump.h b/image/metadump.h
index a4c5d05ed1dd..3a7e38f82a8e 100644
--- a/image/metadump.h
+++ b/image/metadump.h
@@ -30,8 +30,11 @@
 #define ITEMS_PER_CLUSTER ((IMAGE_BLOCK_SIZE - sizeof(struct meta_cluster)) / \
 			   sizeof(struct meta_cluster_item))
 
-#define COMPRESS_NONE		0
-#define COMPRESS_ZLIB		1
+enum image_compression {
+	COMPRESS_NONE,
+	COMPRESS_ZLIB,
+	COMPRESS_LAST,
+};
 
 #define MAX_WORKER_THREADS	(32)
 
-- 
2.56.0

