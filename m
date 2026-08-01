Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDEF30CD89
	for <linux-btrfs@vger.kernel.org>; Sat,  1 Aug 2026 15:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599363; cv=none; b=hB5WNk6El1H6fvL+w2P0uk60UJ63hkOGieaHOlALP38e0yW+wJhS8XvHlkxhKWGoL7SCGd9Rs0r7No2QqbVnMh+tMBLmWUg+lYEEgnEs7USbDibnMjIDaWnON2G+kF9ARkW3iRgYKRYH59NUDkMrjHC0jkaDACPK3Btzy+FiWPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599363; c=relaxed/simple;
	bh=mP13sIaz/uSaF6Esn0yYPf+U2z6tVI/3VUVHDykoSls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2azUfMJjlT0QhlVzOhRSp2I8rfBd4dLCLkS0YSeRogxzDP02kOHdoD61OUHOcmgCEb37N93L6A5nZJD2FtWcY40T8m31jZ5TyJF/cdn3Km/mVhas2VH3cTJ27kaaDOObVb2IRkS3f5KvbzjoODsYKL5yM/3WZFz/yP/xtnkOiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XBPsq6sN; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XBPsq6sN"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cf6d65d8a7so26944285ad.0
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2026 08:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599360; x=1786204160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t+AvYci/1M+OHdtKziq8qWWexl7ZKxnQwPLL2mZLyuw=;
        b=XBPsq6sNGXGZBFT8foKN8feA9HtMTUedsR6cktaPmy/bwKihbuJ5V3Eqt5oOlmEFlQ
         t09+vDn2bP8EjrYgYGWTWeuvkYxlSzi82SrdqTnmNljl8Sfoh483KxIjnb39JlciS0BC
         wwj4L4gIbCE+dYWnFcmGo8J4sSKlVKCeG8WAImAUTL3WNVz6QBHjla+LFfh/W/9+Li4f
         xwgC7aUHqJGjeRiyjswKCGD6Wg287DXNvDfGjR40CBvw9dypITNHOS4yZjnvLpCtf8du
         nPMktRxs5jnkvHY5XLYHbPmIYAtCkIDA3BEGb0+5WbwQsqEO6iMOZYMtKaskzqfdNRt3
         ZL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599360; x=1786204160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t+AvYci/1M+OHdtKziq8qWWexl7ZKxnQwPLL2mZLyuw=;
        b=ok0CUnbbPtHuB8J/YoO9eRf6W4IifQAcKIxiP43Xahnsuus27xwPSfLcdC+8k3kef1
         pev+GJPSSc/JloM+Gz4tDcE3wjAatfIO0Rw17PR/g2pkFeGaStBBD4ZJ4vEA8GWBQqI1
         E468DCjuc6W+K4qnyY1fQZaXIa6HIEu2uHRCUsW2XNTCqBXDAa/FUtXY/Cjq78r3IhOS
         QFU8gG59/Fz+utPPfhqVaeIxb1+PI36wppTLWXnUvrdWmmuuSfE1jgaW5uXO4S8U6+vt
         OSWYYIg01yp1MIZPQc40r7kCpfyBPKTC4HIsIVgddIFdG19ujlcLp8bv4H4CzgFlFo5m
         p9JA==
X-Forwarded-Encrypted: i=1; AHgh+Rqaf6S9NjiLURfr++tdcjdj4b55MD4xtIpUQgg/4fU0UI0y0Fh4U/HOxybfzgQUvyjj8zi+YXIAUFGxpQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzbnXTAkgiDv3yKqHlWb9nzzhidTuJRB0eZH2EcgQ1IAdr1q1UI
	nyq/+p93miTDFSVXbkc+OJb5owxVfOqdkjqcR75qhm8ks6BS1BC20NET
X-Gm-Gg: AR+sD10bF1iprd1pwCaUkRziD4ncuy0khTTnJ0ewJx61wotGZJE/y3xQoPFQb+9bXw9
	mG/naMPekxUaKZfXmt2a+Sny9tvTaDe4RDarz0J1RDzWCbrCO6K7nUTU4vDttzVhM946XhfrheL
	FAiyaioLPmWBplptPA//X/Cxk5f3Z5zTbSgHbibjuKSiwHt/knprJp+ofwPNZU/b2vKh8Dqi62l
	Cl1TvKjXfKunv1xhEL/noJn9kgq/cbnMIiJTX43aKLg9VGpDaVtned9bT/h04dMeCQPEKzYdxX6
	rYBh9hSk1GSfumqE47BkU3FF2fYvMYJV8k7i5h1PBGLH2te8JRAKfcS9cqt9wwm9D2mAZwqjcgl
	ea4aO3SXJIXaOczYPBimR21ctDaFWKN0oxroUQ6aMJkDNXd95nN/4QwwMcXXLEyHR9Okby6lJGS
	WFiqaz06SE7YaveldZg/2I7SitElJU/VmonHTw7V3hrqaM3aPUycovxWKhesw+IFYt4wtIHSYEQ
	NMFwxjGl52IQVzprCRukZRJzqInLfKrmtaSV8Bqq3qe7mI=
X-Received: by 2002:a17:903:1450:b0:2ca:ca48:c380 with SMTP id d9443c01a7336-2d05243a2e9mr42273125ad.47.1785599360127;
        Sat, 01 Aug 2026 08:49:20 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:49:19 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: [PATCH v5 07/16] block: introduce dma map backed bio type
Date: Sat,  1 Aug 2026 16:46:19 +0100
Message-ID: <e26aefbcb383be7092dc76343ce745013e671334.1785596451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785596451.git.asml.silence@gmail.com>
References: <cover.1785596451.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Premapped buffers don't require a generic bio_vec since these have
already been dma mapped. Repurpose the bi_io_vec space to strore dmabuf
maps as they are mutually exclusive.

Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c               | 15 +++++++++++++--
 block/blk-merge.c         | 37 +++++++++++++++++++++++++++++++++++++
 block/fops.c              |  2 +-
 include/linux/bio.h       |  9 +++++----
 include/linux/blk-mq.h    |  7 +++++++
 include/linux/blk_types.h | 14 +++++++++++++-
 include/linux/bvec.h      |  3 ++-
 7 files changed, 78 insertions(+), 9 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 898b2f5ef8c8..1602eab05761 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -860,7 +860,11 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 	bio->bi_write_hint = bio_src->bi_write_hint;
 	bio->bi_write_stream = bio_src->bi_write_stream;
 	bio->bi_iter = bio_src->bi_iter;
-	bio->bi_io_vec = bio_src->bi_io_vec;
+
+	if (op_is_dmabuf(bio->bi_opf))
+		bio->bi_dmabuf_map = bio_src->bi_dmabuf_map;
+	else
+		bio->bi_io_vec = bio_src->bi_io_vec;
 
 	if (bio->bi_bdev) {
 		if (bio->bi_bdev == bio_src->bi_bdev &&
@@ -1183,16 +1187,23 @@ EXPORT_SYMBOL_GPL(__bio_release_pages);
 
 bool bio_iov_iter_set(struct bio *bio, const struct iov_iter *iter)
 {
-	if (!iov_iter_is_bvec(iter))
+	if (!iov_iter_is_bvec(iter) && !iov_iter_is_dmabuf_map(iter))
 		return false;
 
 	WARN_ON_ONCE(bio->bi_max_vecs);
 
+	static_assert(offsetof(struct bio, bi_io_vec) ==
+		      offsetof(struct bio, bi_dmabuf_map));
+	static_assert(offsetof(struct iov_iter, bvec) ==
+		      offsetof(struct iov_iter, dmabuf_map));
+
 	bio->bi_io_vec = (struct bio_vec *)iter->bvec;
 	bio->bi_iter.bi_idx = 0;
 	bio->bi_iter.bi_offset = iter->iov_offset;
 	bio->bi_iter.bi_size = iov_iter_count(iter);
 	bio_set_flag(bio, BIO_CLONED);
+	if (iov_iter_is_dmabuf_map(iter))
+		bio->bi_opf |= REQ_NOMERGE | REQ_DMABUF;
 	return true;
 }
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 258a726071d1..1beedc42a85d 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -9,6 +9,7 @@
 #include <linux/blk-integrity.h>
 #include <linux/part_stat.h>
 #include <linux/blk-cgroup.h>
+#include <linux/dma-buf-io.h>
 
 #include <trace/events/block.h>
 
@@ -319,6 +320,28 @@ static inline unsigned int bvec_seg_gap(struct bio_vec *bvprv,
 	return bv->bv_offset | (bvprv->bv_offset + bvprv->bv_len);
 }
 
+static inline int bio_split_io_at_dmabuf(struct bio *bio,
+		const struct queue_limits *lim, unsigned *segs,
+		unsigned max_bytes, unsigned len_align_mask,
+		unsigned start_align_mask)
+{
+	unsigned bytes = min(bio->bi_iter.bi_size, max_bytes);
+	unsigned seg_shift = bio->bi_dmabuf_map->seg_shift;
+	unsigned offset = bio->bi_iter.bi_offset & ((1U << seg_shift) - 1);
+
+	if ((bio->bi_iter.bi_offset & start_align_mask) ||
+	    (bio->bi_iter.bi_size & len_align_mask))
+		return -EINVAL;
+
+	/* single contiguous range into the dma-buf */
+	*segs = 1;
+
+	bytes = min(bytes, ((unsigned)lim->max_segments << seg_shift) - offset);
+	if (bytes != bio->bi_iter.bi_size)
+		return bytes;
+	return 0;
+}
+
 /**
  * bio_split_io_at - check if and where to split a bio
  * @bio:  [in] bio to be split
@@ -346,6 +369,19 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 		len_align_mask |= (bc->bc_key->crypto_cfg.data_unit_size - 1);
 	}
 
+	if (op_is_dmabuf(bio->bi_opf)) {
+		int ret;
+
+		ret = bio_split_io_at_dmabuf(bio, lim, &nsegs, max_bytes,
+					     len_align_mask, start_align_mask);
+		if (ret < 0)
+			return ret;
+		if (!ret)
+			goto out;
+		bytes = ret;
+		goto split;
+	}
+
 	bio_for_each_bvec(bv, bio, iter) {
 		if (bv.bv_offset & start_align_mask ||
 		    bv.bv_len & len_align_mask)
@@ -376,6 +412,7 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 		bvprvp = &bvprv;
 	}
 
+out:
 	*segs = nsegs;
 	bio->bi_bvec_gap_bit = ffs(gaps);
 	return 0;
diff --git a/block/fops.c b/block/fops.c
index d11923053afe..56bbacf6e317 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -346,7 +346,7 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	 * Users don't rely on the iterator being in any particular
 	 * state for async I/O returning -EIOCBQUEUED, hence we can
 	 * avoid expensive iov_iter_advance(). Bypass
-	 * bio_iov_iter_get_pages() and set the bvec directly.
+	 * bio_iov_iter_get_pages() and set the bvec/dmabuf directly.
 	 */
 	if (!bio_iov_iter_set(bio, iter)) {
 		ret = blkdev_iov_iter_get_pages(bio, iter, bdev);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 0d27e0c72905..22ce9deb2feb 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -80,7 +80,8 @@ static inline bool bio_no_advance_iter(const struct bio *bio)
 {
 	return bio_op(bio) == REQ_OP_DISCARD ||
 	       bio_op(bio) == REQ_OP_SECURE_ERASE ||
-	       bio_op(bio) == REQ_OP_WRITE_ZEROES;
+	       bio_op(bio) == REQ_OP_WRITE_ZEROES ||
+	       op_is_dmabuf(bio->bi_opf);
 }
 
 static inline void *bio_data(struct bio *bio)
@@ -438,12 +439,12 @@ static inline void bio_wouldblock_error(struct bio *bio)
 
 /*
  * Calculate number of bvec segments that should be allocated to fit data
- * pointed by @iter. If @iter is backed by bvec it's going to be reused
- * instead of allocating a new one.
+ * pointed by @iter. If @iter is backed by a bvec or a dmabuf, the bvec array /
+ * the dma map are going to be reused, and so no extra allocation is required.
  */
 static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
 {
-	if (iov_iter_is_bvec(iter))
+	if (iov_iter_is_bvec(iter) || iov_iter_is_dmabuf_map(iter))
 		return 0;
 	return iov_iter_npages(iter, max_segs);
 }
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index af878597afb8..7c7504c84e09 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -1017,6 +1017,13 @@ static inline void *blk_mq_rq_to_pdu(struct request *rq)
 	return rq + 1;
 }
 
+static inline bool blk_mq_rq_is_dmabuf(struct request *rq)
+{
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return false;
+	return rq->bio && op_is_dmabuf(rq->bio->bi_opf);
+}
+
 static inline struct blk_mq_hw_ctx *queue_hctx(struct request_queue *q, int id)
 {
 	struct blk_mq_hw_ctx *hctx;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d49d97a050d0..a305951f0312 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -233,7 +233,12 @@ struct bio {
 	atomic_t		__bi_remaining;
 
 	/* The actual vec list, preserved by bio_reset() */
-	struct bio_vec		*bi_io_vec;
+	union {
+		struct bio_vec		*bi_io_vec;
+		/* Driver specific dma map, valid IFF REQ_DMABUF is set */
+		struct dma_buf_io_map	*bi_dmabuf_map;
+	};
+
 	struct bvec_iter	bi_iter;
 
 	union {
@@ -402,6 +407,7 @@ enum req_flag_bits {
 	__REQ_DRV,		/* for driver use */
 	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
 	__REQ_ATOMIC,		/* for atomic write operations */
+	__REQ_DMABUF,		/* Using premmaped dma buffers */
 	/*
 	 * Command specific flags, keep last:
 	 */
@@ -434,6 +440,7 @@ enum req_flag_bits {
 #define REQ_DRV		(__force blk_opf_t)(1ULL << __REQ_DRV)
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
 #define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
+#define REQ_DMABUF	(__force blk_opf_t)(1ULL << __REQ_DMABUF)
 
 #define REQ_NOUNMAP	(__force blk_opf_t)(1ULL << __REQ_NOUNMAP)
 
@@ -487,6 +494,11 @@ static inline bool op_is_discard(blk_opf_t op)
 	return (op & REQ_OP_MASK) == REQ_OP_DISCARD;
 }
 
+static inline bool op_is_dmabuf(blk_opf_t op)
+{
+	return op & REQ_DMABUF;
+}
+
 /*
  * Check if a bio or request operation is a zone management operation.
  */
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index fc566ee1c1ff..b63914ff56e3 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -108,7 +108,8 @@ struct bvec_iter {
 	unsigned int		bi_idx;
 
 	/*
-	 * Current offset in the bvec entry pointed to by `bi_idx`.
+	 * Current offset in the bvec entry pointed to by `bi_idx` or into
+	 * a dma-buf map.
 	 */
 	unsigned int		bi_offset;
 } __packed __aligned(4);
-- 
2.54.0

