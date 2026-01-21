Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD274495531
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769013061; cv=none; b=Wv3LdHr1Z9J06iGTelEARTnoDhnOwSkOe8Bm8assu8DdHeZwjr2d7NDZiErzKx47VSn6qvi7OiLFjpE4PtM5nY5JNawy3TXgeSmXuxZk2IQS8SybApvi/2b3rpllZlxf+57WUxsN2qF4PoVPNNW5Ugwu6usqj7nYwSgKuk1RXGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769013061; c=relaxed/simple;
	bh=suTwCAFgDk2lL8k2VMZTz9GlxQ1RmB2hmMQ0mGE34jk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0F+o+MI3Dmka6p/t7/HzfXyShV0bNWS3qJ6NeOLgeOcwZ7rZvFcfP9cEF/mVP5G0hOSpvDJaTQ3NMgUnawbOb8BMs9HiEuPOhzSpmwy50/DgEvGQ/+SWBoUVUZglPthqfYZQiEZn5M5rJU8z33whh/GyZulzIa+dEmuc7ZOglg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y8WRXwKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y8WRXwKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAA8C4CEF1
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769013061;
	bh=suTwCAFgDk2lL8k2VMZTz9GlxQ1RmB2hmMQ0mGE34jk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Y8WRXwKZ4GxsNR6trlKWbwNE8PI0sURBNYEvxzafa0P37Aup9JJIBoLTiaPcdZfaB
	 gKyumznTYB14Faf8QZBMdc9fF0JZmDHQ/3edwN5MUPMJ8fWlNYhSgPqxty6r8X993t
	 5cG53p40aynF/tvkqPeGjBzJaFTUGB6h3T0egS3yJz7zWTlBltO3tq2TiK5IS+50z3
	 CZjPZ4coliVIrYSf0KQF979finnsF5J+UmQPZEPjWAm+wQ86keJFg9kjGVSWrigv7i
	 hZiOdBXez3sOxT6y0b3LK9hXDiWGtQ6g1Qh9Gd8ZRwg1bQe8p9LTeC7FimJ0KLQhea
	 VR4ekJddOv5AQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 14/19] btrfs: remove out label in lzo_decompress()
Date: Wed, 21 Jan 2026 16:30:40 +0000
Message-ID: <e1a07a769732443ccd6b9688273cea8f26569257.1769012877.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1769012876.git.fdmanana@suse.com>
References: <cover.1769012876.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There is no point in having the label since all it does is return the
value in the 'ret' variable. Instead make every goto return directly
and remove the label.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/lzo.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 83c106ca1c14..e15f7a778ed8 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -486,7 +486,7 @@ int lzo_decompress(struct list_head *ws, const u8 *data_in,
 	size_t in_len;
 	size_t out_len;
 	size_t max_segment_len = workspace_buf_length(fs_info);
-	int ret = 0;
+	int ret;
 
 	if (unlikely(srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * 2))
 		return -EUCLEAN;
@@ -497,10 +497,8 @@ int lzo_decompress(struct list_head *ws, const u8 *data_in,
 	data_in += LZO_LEN;
 
 	in_len = read_compress_length(data_in);
-	if (unlikely(in_len != srclen - LZO_LEN * 2)) {
-		ret = -EUCLEAN;
-		goto out;
-	}
+	if (unlikely(in_len != srclen - LZO_LEN * 2))
+		return -EUCLEAN;
 	data_in += LZO_LEN;
 
 	out_len = sectorsize;
@@ -512,19 +510,18 @@ int lzo_decompress(struct list_head *ws, const u8 *data_in,
 		"lzo decompression failed, error %d root %llu inode %llu offset %llu",
 			  ret, btrfs_root_id(inode->root), btrfs_ino(inode),
 			  folio_pos(dest_folio));
-		ret = -EIO;
-		goto out;
+		return -EIO;
 	}
 
 	ASSERT(out_len <= sectorsize);
 	memcpy_to_folio(dest_folio, dest_pgoff, workspace->buf, out_len);
 	/* Early end, considered as an error. */
 	if (unlikely(out_len < destlen)) {
-		ret = -EIO;
 		folio_zero_range(dest_folio, dest_pgoff + out_len, destlen - out_len);
+		return -EIO;
 	}
-out:
-	return ret;
+
+	return 0;
 }
 
 const struct btrfs_compress_levels  btrfs_lzo_compress = {
-- 
2.47.2

