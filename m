Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DFF509F0D
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 16:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788540138; cv=none; b=oVCP3tUk6oBEFH9D0+nx2ByRM5QKVRhnCtNPk6Xe2xyOoPQjBj9DQRf7ap3B5fzL4+bUzQhK6JjH9R7TqBte64Vw8MImlB6VGQkr2BpAIUj0KG+Icyehobb5kn3GMWwDYBjtmnTP/ItyjxxkrUU36PTy2GtaqJ2yArqn0UIB2Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788540138; c=relaxed/simple;
	bh=eaSmD6AakrGy8JzPNXWt4MIR9DWEhJZsdWuWmxUbYYI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V1IynmhlwGppWOBIa9QZDgRErxFASya3bAgzpuCy7UKkbxS+jeI0YghF5dlE76ofrFHky4IwkoMqHzmPtvpw/J86LF+AqW4LJkwlrZeEud9jRpuTwQjXdltgqx1RQVr82M53dy8n31sfJ56g2ccC1NM0yDRE8Lpwg7nEpOG+1G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vXNptXDO; arc=none smtp.client-ip=95.215.58.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vXNptXDO"
X-Envelope-To: linux-btrfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eaSmD6AakrGy8JzPNXWt4MIR9DWEhJZsdWuWmxUbYYI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788540133; v=1; x=1789144933;
 b=vXNptXDOkvrVUbDSCCkRbxAZAEX/t3e8I7bTbpBQWQvANSveH4IVmn5I31ld6SV1SZRE5gIu
 WAXhZARfbelXfsAdr1e95H3XhyEKJnMm7rLreOl2sxU4H2kK/y7WswxI6vq9VS7dser7ZKo14z/
 cp8kYXeprn+lORbfjmSnazG0=
X-Envelope-To: linux-btrfs@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id be01afa9177d88fe;
	Fri, 04 Sep 2026 16:42:03 +0000
X-Mizu-Trace-ID: be01afa9177d88fe
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: dsterba@suse.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	terrelln@fb.com,
	terrelln@meta.com,
	mason@kernel.org,
	clm@fb.com,
	fdmanana@suse.com,
	boris@bur.io,
	wqu@suse.com,
	loemra.dev@gmail.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] btrfs: zstd: avoid a copy in zstd_decompress_bio()
Date: Fri,  4 Sep 2026 09:41:48 -0700
Message-ID: <20260904164148.2664280-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zstd_decompress_bio() gives zstd a sectorsize-sized scratch buffer, and
btrfs_decompress_buf2page() then copies the part overlapping the read bio
into the destination folios. Every delivered byte is written twice.

Instead, choose the output buffer per streaming call. zstd_map_dest()
kmaps the current page-bounded segment of the read bio, so zstd writes
into the page cache directly. The scratch buffer is kept only for output
with no destination: the prefix before a read starting inside a
compressed extent, which zstd cannot skip, and gaps left by folios
already in the page cache.

Varying the output buffer across calls is safe: btrfs uses the default
ZSTD_bm_buffered mode, where the sliding window lives in the dstream's
internal buffer and the caller's dst is a pure sink. The read bio's
iterator must still advance by exactly the bytes delivered, since
btrfs_decompress_bio() zero-fills from it; that used to happen inside
btrfs_decompress_buf2page() and is now an explicit bio_advance(), made
only for output that reached a folio.

bio_iter_iovec() exposes at most one base page, so direct output is
page-bounded. Compared to the old sectorsize-sized chunks, this can
increase stream calls when sectorsize exceeds PAGE_SIZE, but eliminates
the extra btrfs copy for output delivered to the read bio; the 64 KiB
sectorsize row below shows the copy still wins there.

Benchmarked the change in 2-vCPU x86-64 KVM guests (4 KiB pages, RAM
disk) using a 64 MiB zstd-compressed file. Results are medians of seven
cold-cache reads in each of six interleaved A/B boot pairs; mincore
confirmed zero resident pages before every run.

Normal sequential reads with readahead produced:

  sectorsize       base       patched    reduction
  4 KiB          8.678 ms     8.004 ms       7.80%
  16 KiB         8.216 ms     7.934 ms       3.64%
  64 KiB         7.875 ms     7.344 ms       6.88%

Random 4 KiB preads at 4 KiB sectorsize, means of six interleaved A/B
boot pairs, patched better in all six:

  base           patched        gain
  264.33 MB/s    272.67 MB/s     3.2%

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/btrfs/zstd.c | 69 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 56 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 86919293fd546..c5aece6be6093 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -580,10 +580,48 @@ int zstd_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 	return ret;
 }
 
+/*
+ * Map the destination for the next chunk of output.
+ *
+ * @decompressed is the offset of the next output byte inside the fully
+ * decompressed extent.  If that offset has reached the current destination
+ * segment, its page-bounded bio_vec is kmapped so that zstd can write into the
+ * page cache directly, and the number of bytes writable there is returned.
+ * Otherwise @kaddr_ret is set to NULL and the number of bytes to skip before
+ * that segment is returned.  This covers both the initial prefix and gaps in
+ * the destination bio.
+ */
+static u32 zstd_map_dest(struct compressed_bio *cb, u32 decompressed,
+			 void **kaddr_ret)
+{
+	struct bio *orig_bio = &cb->orig_bbio->bio;
+	struct bio_vec bvec;
+	u32 bvec_offset;
+	u32 off;
+
+	bvec = bio_iter_iovec(orig_bio, orig_bio->bi_iter);
+	/*
+	 * cb->start may underflow, but subtracting that value can still give us
+	 * the correct offset inside the full decompressed extent.
+	 */
+	bvec_offset = page_offset(bvec.bv_page) + bvec.bv_offset - cb->start;
+
+	if (decompressed < bvec_offset) {
+		*kaddr_ret = NULL;
+		return bvec_offset - decompressed;
+	}
+
+	off = decompressed - bvec_offset;
+	ASSERT(off < bvec.bv_len);
+	*kaddr_ret = bvec_kmap_local(&bvec) + off;
+	return bvec.bv_len - off;
+}
+
 int zstd_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 {
 	struct btrfs_fs_info *fs_info = cb_to_fs_info(cb);
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	struct bio *orig_bio = &cb->orig_bbio->bio;
 	struct folio_iter fi;
 	size_t srclen = bio_get_size(&cb->bbio.bio);
 	zstd_dstream *stream;
@@ -591,7 +629,6 @@ int zstd_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 	const unsigned int min_folio_size = btrfs_min_folio_size(fs_info);
 	unsigned long folio_in_index = 0;
 	unsigned long total_folios_in = DIV_ROUND_UP(srclen, min_folio_size);
-	unsigned long buf_start;
 	unsigned long total_out = 0;
 
 	bio_first_folio(&fi, &cb->bbio.bio, 0);
@@ -615,15 +652,26 @@ int zstd_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 	workspace->in_buf.pos = 0;
 	workspace->in_buf.size = min_t(size_t, srclen, min_folio_size);
 
-	workspace->out_buf.dst = workspace->buf;
-	workspace->out_buf.pos = 0;
-	workspace->out_buf.size = fs_info->sectorsize;
-
-	while (1) {
+	while (orig_bio->bi_iter.bi_size) {
 		size_t ret2;
+		void *kaddr;
+		u32 dstlen;
+
+		dstlen = zstd_map_dest(cb, total_out, &kaddr);
+		if (kaddr) {
+			workspace->out_buf.dst = kaddr;
+			workspace->out_buf.size = dstlen;
+		} else {
+			workspace->out_buf.dst = workspace->buf;
+			workspace->out_buf.size = min_t(u32, dstlen,
+							fs_info->sectorsize);
+		}
+		workspace->out_buf.pos = 0;
 
 		ret2 = zstd_decompress_stream(stream, &workspace->out_buf,
 				&workspace->in_buf);
+		if (kaddr)
+			kunmap_local(kaddr);
 		if (unlikely(zstd_is_error(ret2))) {
 			struct btrfs_inode *inode = cb->bbio.inode;
 
@@ -634,14 +682,9 @@ int zstd_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 			ret = -EIO;
 			goto done;
 		}
-		buf_start = total_out;
 		total_out += workspace->out_buf.pos;
-		workspace->out_buf.pos = 0;
-
-		ret = btrfs_decompress_buf2page(workspace->out_buf.dst,
-				total_out - buf_start, cb, buf_start);
-		if (ret == 0)
-			break;
+		if (kaddr)
+			bio_advance(orig_bio, workspace->out_buf.pos);
 
 		if (workspace->in_buf.pos >= srclen)
 			break;

base-commit: 421066905cbceca1f78cba5f7d92b4980317ab2b
-- 
2.53.0-Meta

