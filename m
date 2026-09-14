Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F01E382299
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 18:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411611; cv=none; b=IoISeX752ZQCJNu7z++JgYVCTHLISX2ZuXUS9wqASxX3ho6WGjyDCOc48Jv9J13rP1wBNXa6+wt/dcUIL6F2O3tK1GHiGZOyEam8ApAp9L56j13xJAf6vUXnjPePOvIN6zRA69dJdxwD8iUUYXJycJqdzwHLpB8mYLjd9CV1ILM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411611; c=relaxed/simple;
	bh=uz1IWsil5iZcBSl/OqzbUC0Sgav1ZJsp4sOGanKZ0w4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9ts3tcjQ/mZBbtB7b7t27qvFQAmKte25/WbTD/h/X7IuN77cmA4DEYo9zHeOsIDQQ6Ey2PQrSh3STIOjVeyN46H/D00z5XlWUxjeDwNmVTXBmNDVVN0Ph9XeSqBGJBdWSYt17X8w/HkY8/oXLKNIEQK2FL9UTZWMuWNzTdXvgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZVC+PjR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZVC+PjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CE11F000FF
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 18:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789411610;
	bh=F5DbEZ1EHHtFj/xneyHRm2kAk/bNYxCQCKExKblqMRo=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=SZVC+PjRFxNxWDpcZkFgGGLH1KW/T4kpzo1l1XD2XnE9oWZERVIus0xcgQdSWgIQf
	 3hq3y3mBkm8zcS6B2O/oF596doCgAesTWBnabC7PHmoN9zo5AQtpvTktUFwPrGWtRP
	 YOs3CQ7ayy+q5KlNdXGkcz7JaTqcimtmQgznWCj5RK6HFkP7E+u80HCMK3RNykM1SZ
	 eebezKcbneEfQ8SzRH/7NJgcw9PSPrdm6IDNnewf9fZcvVx8AwaLUgytuOtDCDOYXE
	 jXtKDTE2OIH91n8GBkZWvjkYh4eXQl+PmaKKhwxwj8EUrf+kfN+Rie6ijTM74rWTsX
	 ketODiMmjawsg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix creation of compressed inline extents that don't save space
Date: Mon, 14 Sep 2026 19:46:46 +0100
Message-ID: <422f0a1a6537835f43f52d58e5c8ff539d85b20b.1789411443.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <721d8fd2c73095d06cbdbfa714a6dfac9c488953.1789407346.git.fdmanana@suse.com>
References: <721d8fd2c73095d06cbdbfa714a6dfac9c488953.1789407346.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If the compressed data of an inline extent is larger than or equals to the
size of the uncompressed data, we are still allowing the creation of the
compressed inline extent, which does not result in any benefits, quite the
contrary as we waste metadata space and have to decompress when reading.

This is a recent regression introduced in commit 3eaf5f082c4c ("btrfs:
extract inlined creation into a dedicated delalloc helper").

It happens because we are passing the block size to btrfs_compress_bio()
instead of the inode's i_size. So unless the compressed size is greater
than or equals to the block size, we allow the creation of compressed
inline extents that waste metadata space.

Since that commit we are also trying the compression even when we can
not create an inline extent because its i_size is larger than the page
size. We check for that only after compressing.

The fix is to pass the i_size instead of the block size in the call to
btrfs_compress_bio(), but before we call this function, we also need
to make sure we can create an inline extent by calling
can_cow_file_range_inline() first to validate the i_size, otherwise
an excepcionally large i_size could trigger a lot of compression work
which would then be later discarded because the call to
can_cow_file_range_inline() that follows the btrfs_compress_bio() call
will return false.

Fixes: 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated delalloc helper")
Reported-by: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/c97652a5-ac6b-4de6-aa23-3cdebc01d00b@gmail.com/
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Check first if we can create an inline extent otherwise a too large
    i_size would create a lot of work just to be discarded later.

 fs/btrfs/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a85a7c561cf8..d06a328ddead 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2330,7 +2330,8 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 	 */
 	btrfs_check_folio_write_protected(locked_folio);
 
-	if (btrfs_inode_can_compress(inode) &&
+	if (can_cow_file_range_inline(inode, 0, i_size, 0) &&
+	    btrfs_inode_can_compress(inode) &&
 	    inode_need_compress(inode, 0, blocksize, true)) {
 		if (inode->defrag_compress > 0 &&
 		    inode->defrag_compress < BTRFS_NR_COMPRESS_TYPES) {
@@ -2339,7 +2340,7 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 		} else if (inode->prop_compress) {
 			compress_type = inode->prop_compress;
 		}
-		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
+		cb = btrfs_compress_bio(inode, 0, i_size, compress_type, compress_level, 0);
 		if (IS_ERR(cb)) {
 			cb = NULL;
 			/* Just fall back to non-compressed case. */
-- 
2.47.2

