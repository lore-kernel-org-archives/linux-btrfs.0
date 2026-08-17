Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC7F227EA7
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 07:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786951883; cv=none; b=qakc6fj2clTQgqaiGmOUxy+VFt9Y65NhflOorlYWuuCQcnHOERIq5VrhLk0JitR1nNAiGH7mBxs020mHjTMw3IYSp+0P9W+9KC7tshJHTf97F76syDVgZg3i0xpqorPWJXOTahr3vighR4nUZwY5KR+cznwMGTVQDKabzP6wsbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786951883; c=relaxed/simple;
	bh=JG0inu7EYkKvz0Z1PScR+9E2kcEHJFHkLaRWA67LtvI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gPiZj8mfs3ZrdM+xnCbKe/4IwCprSVTDH2tpMwDwddd7yfeZsajCCvr3cP2afwktDXNvfr8JbfFTXxckYJM30lTGF7Nx1hWSdLuGATq7vnckxfMdN0dOFO/QqMOMl08B0e7Na6284VzjRCRkb/M/ksbbpNKHKsOl8xCz8I+QozY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ds+4+PpW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WYo9EKv3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ds+4+PpW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WYo9EKv3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C85813E06;
	Mon, 17 Aug 2026 07:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786951875; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zLM8nG88PeEgk7V6oOlbSVipuKwG5olQD0ltaPYks5w=;
	b=ds+4+PpW6PNfOW79C1Spbb9gDcKNg5OeHFPKXR3MA9eeWUeGpf34WLi1ffVhMnpikz5B2N
	bQ1jpfLuz2WXcti1MCk+wdZuXS9Ajk9qDJid4V+si/+p+tbxQJ5CCYw9xlnkojbdtnt2X3
	Ov4da6z83IOZt5tuaWH/oznGxQF3yV4=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=WYo9EKv3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786951871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zLM8nG88PeEgk7V6oOlbSVipuKwG5olQD0ltaPYks5w=;
	b=WYo9EKv3fGr9mylBBNZRi5vlEEXHCUM/BXPvJ3fMm1/9Kj8ihsc9ZKIXVJYO8xghpcwz20
	g8VDlmJgQua3BuTRlC5ka1ibGiBCrd+1LKLitymHRnNt4RLwJjZffZG97hrn+NhbReOgux
	khVeMnW32D5rU5LW1LuoR/2Pr/r17Js=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D24E7934A;
	Mon, 17 Aug 2026 07:31:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dImkAb64gmrmSgAAD6G6ig
	(envelope-from <wqu@suse.com>); Mon, 17 Aug 2026 07:31:10 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH] btrfs: refactor read_key_bytes() to remove the dest_folio parameter
Date: Mon, 17 Aug 2026 17:00:43 +0930
Message-ID: <9dbe80bc5b11556619603748db55424cb75a4407.1786951820.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,kylinos.cn:email,suse.com:email,suse.com:mid,suse.com:dkim];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: C85813E06
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

The function read_key_bytes() have 3 call sites:

- For BTRFS_VERITY_DESC_ITEM_KEY offset 0 inside btrfs_get_verity_descriptor()
- For BTRFS_VERITY_DESC_ITEM_KEY offset 1 inside btrfs_get_verity_descriptor()
  Those are to read the description items, which are pretty small with
  fixed item size.

  Those call sites do not utilize the @dest_folio parameter.

- For btrfs_read_merkle_tree_page()
  This is to read the BTRFS_VERITY_MERKLE_ITEM_KEY, which can be pretty
  large and split into multiple items.

  This is the only call site utilizing the @dest_folio parameter.

Just for the only btrfs_read_merkle_tree_page() call site, we have a
complex scheme for @dest and @dest_folio parameters.
Since @dest can be NULL, it means if we pass @dest as NULL, then no
matter if @dest_folio is provided, the merkle data will not be loaded
into that @dest_folio.

This can lead to a bug where a highmem folio is not mapped, then we pass
folio_address(folio), which is NULL, into read_key_bytes(), causing no
data to be written into @dest_folio.

To address the complex scheme between @dest and @dest_folio, remove the
@dest_folio parameter completely, and let the only caller to map the
folio and pass the mapped kernel address into read_key_bytes() instead.

This not only reduces the parameter list, but also make it much clear on
the @dest parameter handling.
The only downside is a longer duration of locally mapped page, but this
should still be fine, as kmap_local_folio() can survive context switch.

Reported-by: Hongling Zeng <zenghongling@kylinos.cn>
Link: https://lore.kernel.org/linux-btrfs/20260817022012.19658-1-zenghongling@kylinos.cn/
Fixes: 146054090b08 ("btrfs: initial fsverity support")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/verity.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 4e0ab5842274..0c4b59759350 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -272,21 +272,17 @@ static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
  * @dest:       Buffer to read into. This parameter has slightly tricky
  *              semantics.  If it is NULL, the function will not do any copying
  *              and will just return the size of all the items up to len bytes.
- *              If dest_page is passed, then the function will kmap_local the
- *              page and ignore dest, but it must still be non-NULL to avoid the
- *              counting-only behavior.
  * @len:        length in bytes to read
- * @dest_folio: copy into this folio instead of the dest buffer
  *
  * Helper function to read items from the btree.  This returns the number of
  * bytes read or < 0 for errors.  We can return short reads if the items don't
  * exist on disk or aren't big enough to fill the desired length.  Supports
- * reading into a provided buffer (dest) or into the page cache
+ * reading into a provided buffer (dest).
  *
  * Returns number of bytes read or a negative error code on failure.
  */
 static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
-			  char *dest, u64 len, struct folio *dest_folio)
+			  char *dest, u64 len)
 {
 	BTRFS_PATH_AUTO_FREE(path);
 	struct btrfs_root *root = inode->root;
@@ -306,7 +302,11 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 	if (!path)
 		return -ENOMEM;
 
-	if (dest_folio)
+	/*
+	 * Merkle items can be large and split across multiple items,
+	 * so enable readahead for such cases.
+	 */
+	if (key_type == BTRFS_VERITY_MERKLE_ITEM_KEY)
 		path->reada = READA_FORWARD;
 
 	key.objectid = btrfs_ino(inode);
@@ -350,7 +350,7 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 				break;
 		}
 
-		/* desc = NULL to just sum all the item lengths */
+		/* dest == NULL to just sum all the item lengths */
 		if (!dest)
 			copy_end = item_end;
 		else
@@ -363,16 +363,10 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 		copy_offset = offset - key.offset;
 
 		if (dest) {
-			if (dest_folio)
-				kaddr = kmap_local_folio(dest_folio, 0);
-
 			data = btrfs_item_ptr(leaf, path->slots[0], void);
 			read_extent_buffer(leaf, kaddr + dest_offset,
 					   (unsigned long)data + copy_offset,
 					   copy_bytes);
-
-			if (dest_folio)
-				kunmap_local(kaddr);
 		}
 
 		offset += copy_bytes;
@@ -663,7 +657,7 @@ int btrfs_get_verity_descriptor(struct inode *inode, void *buf, size_t buf_size)
 
 	memset(&item, 0, sizeof(item));
 	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY, 0,
-			     (char *)&item, sizeof(item), NULL);
+			     (char *)&item, sizeof(item));
 	if (ret < 0)
 		return ret;
 
@@ -680,7 +674,7 @@ int btrfs_get_verity_descriptor(struct inode *inode, void *buf, size_t buf_size)
 		return -ERANGE;
 
 	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY, 1,
-			     buf, buf_size, NULL);
+			     buf, buf_size);
 	if (ret < 0)
 		return ret;
 	if (ret != true_size)
@@ -706,6 +700,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	struct folio *folio;
 	u64 off = (u64)index << PAGE_SHIFT;
 	loff_t merkle_pos = merkle_file_pos(inode);
+	void *kaddr;
 	int ret;
 
 	if (merkle_pos < 0)
@@ -749,6 +744,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	}
 
 read_folio:
+	kaddr = kmap_local_folio(folio, 0);
 	/*
 	 * Merkle item keys are indexed from byte 0 in the merkle tree.
 	 * They have the form:
@@ -756,7 +752,8 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	 * [ inode objectid, BTRFS_MERKLE_ITEM_KEY, offset in bytes ]
 	 */
 	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY, off,
-			     folio_address(folio), PAGE_SIZE, folio);
+			     kaddr, PAGE_SIZE);
+	kunmap_local(kaddr);
 	if (ret < 0) {
 		folio_unlock(folio);
 		folio_put(folio);
-- 
2.54.0

