Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBCC24DCF6
	for <linux-btrfs@vger.kernel.org>; Sat,  1 Aug 2026 15:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599344; cv=none; b=Zaccynvpcc+t55Zt0TjfQ5po5EIH8+FlDCpnKzvBpQptXvvGk5Aur2C4KYVvd00xbMeih8DplTY6zPwNslyRFvivOAAVcwrG8ATAuW/ZYFoaqBfvSsQyoXw91BaZw1UX7NkHO0Raphl6QlJJTQUeHMLvIYWE0ipjR1eBHlI/nfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599344; c=relaxed/simple;
	bh=l/ge8TugHemWMqrNxxHjTUj8j/KX2qzLG7MG78we1Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFghEsRh7iLJYm7PJt5mn4KICPoTONczU5cMy8O2JbwPKLNOW0jSYZ9y3hFxkU+aE1rUtLN7b0JgNJhdosBaMnzSQGyU5KztX3RBxHPy9rUqx0VSBkT6lDH/QTxbWM6kygxMbJWUcUr8HQ3r9790ZhjMhWhNpCTZuokOW+Up9JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XM9ktqES; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XM9ktqES"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ceb096e675so24042265ad.0
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2026 08:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599339; x=1786204139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7ojEbSoOEAjcpRPJZN1aYCrlxFzJ3/XljVJRrzaFsbs=;
        b=XM9ktqESqb3mFRQ8X89TnKjm0U7zRTnOGXTc9kenfXUtbDBAOuxVkoNQ6LpqJV+JQ2
         UXuqk0Et+vWNhoXqeM6M/Ghna75QUy9aAW4TRs9LY6h1Mm0PC7lCqdpGUC/NmU0pNPZZ
         XDLnZo0nkIRsQ5Ymu6DGVDuRswfY3hXN3V1PkxQPPRJ4/o2cYRR43v1ARr7wJCKrh4PB
         e167VzWtGagxJ2ANl37Ea4YSb0TF1jbtLX/qFICqFKHShJru9NNateuhe2WkrBfQUSwV
         kuH0mYfGVs0GkyZoRTeFn/iPvD3y93ETWhFzy8C4wTS5q8vfdm49Jh+j9caT7z/+A8+5
         a0kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599339; x=1786204139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7ojEbSoOEAjcpRPJZN1aYCrlxFzJ3/XljVJRrzaFsbs=;
        b=hk561r7ERH1D5HTwy0PCm6Jwp93PweDVQq0GuK8xiOdvCbg5mZUAHAjFhXlEzXUjlh
         Z3p9UD/w20HTRpXwkWwocfqN0uWpVCwIZlIs9QQL2OQ36prfvFsCz1uLUX7+RUCU+HOu
         5zrQW+sArLoDzsRLCM9gBmduIaXfCrV+Q/Qmp7ods8VuoDn3wp8pB4YQ7TiOFE7bPSwk
         OMHtHjx/++QwILAk2iZ93aTN4D2g8CRVGIhUOcOp9t0JRcC8Psf64Yn4jkXYxtWSmcHc
         f8FDxo2o0Xv0XfwwnOs5HDCVPmePBhlFBFUUpKmGFGoJZWmU6h272Fo0g40I15wjadhq
         50QA==
X-Forwarded-Encrypted: i=1; AHgh+RoHsz+z0pdu08LmaRGhdmtPjcKkjpzVwItKbuCY2sNTTwcKCCfoRGiYPDrBa6A/V2N0S8SLaA32olc1bw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyoh88nhu0Xcru+Ji92TlS46WEaKO9oX/ejD0877XLPpXuprCui
	yTWFPn6zk29/W54bB2LFuxS7ArnEEKeYXqVA7vJF1neKhMsx+l4L/B6o
X-Gm-Gg: AR+sD10bnS05wNjeUUhHviB7aqLYNwo9xaYTSfoGyzlESNStbOXYzwBM5z5fwY43zJV
	nRZobcJjbiwrpsaEou7cEDrnxofGssJ89O+1XfjHySYVvkTVR922XHSahoo6NhSUfeUGqZyr7jR
	5PP9aviZF/+WhtASS6BnLMhqLhTJwNSx+tosdIh28aSuvyKRFbulZ7RpObVIvoZTaaaAattAx5H
	MKkGSmGgjWjir/zk9F83fw+cFCnxm4QdiZc1w3CGzUYwUMu+Bkik6ipaWqmaTjpECB6obMVsbRc
	aOwMgqYSe+32r24sC3VugTgmQ6KYDz7lbqYjiRe1E1PStv3FsiarT14bFK5mzIjrW1k6PVt8Dmz
	4cSFHEdNgb66A25i2A36HBHLXxU32flahMhRJCLbgsB+ZNX4NyNHID7y7KVpssoUjhnhkvjaUVP
	6apya0u4JmgTFLQPwUsoNj7YGrRFd7/Q/d1Cs9MSxFy6knDGgN4M8mtjJTDzppsjSwYx2LSZMcn
	a4egDFJ1yGyn+214phvR0CBOTbyvJAPHZNV1V+8VfUITvk=
X-Received: by 2002:a17:903:19c7:b0:2d0:4021:bb6b with SMTP id d9443c01a7336-2d0520362cdmr40118035ad.0.1785599339056;
        Sat, 01 Aug 2026 08:48:59 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:48:58 -0700 (PDT)
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
Subject: [PATCH v5 06/16] block: introduce bio_iov_iter_set()
Date: Sat,  1 Aug 2026 16:46:18 +0100
Message-ID: <4686a0e47fc14f3f888967a80d45a6f66044f1e0.1785596451.git.asml.silence@gmail.com>
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

In preparation to supporting dma-buf backed iterators and bios,
introduce bio_iov_iter_set() which attempts to set up the bio directly
from the given iterator. For now, it only supports bvec and expects
users to check the result and fall back to other means if fails, but
later we'll add more types.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c         | 13 ++++++++-----
 block/blk-map.c     |  2 +-
 block/fops.c        | 16 +++++++---------
 include/linux/bio.h |  2 +-
 4 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 00f99d03ac91..898b2f5ef8c8 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1181,8 +1181,11 @@ void __bio_release_pages(struct bio *bio, bool mark_dirty)
 }
 EXPORT_SYMBOL_GPL(__bio_release_pages);
 
-void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter)
+bool bio_iov_iter_set(struct bio *bio, const struct iov_iter *iter)
 {
+	if (!iov_iter_is_bvec(iter))
+		return false;
+
 	WARN_ON_ONCE(bio->bi_max_vecs);
 
 	bio->bi_io_vec = (struct bio_vec *)iter->bvec;
@@ -1190,6 +1193,7 @@ void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter)
 	bio->bi_iter.bi_offset = iter->iov_offset;
 	bio->bi_iter.bi_size = iov_iter_count(iter);
 	bio_set_flag(bio, BIO_CLONED);
+	return true;
 }
 
 /*
@@ -1284,10 +1288,9 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return -EIO;
 
-	if (iov_iter_is_bvec(iter)) {
-		bio_iov_bvec_set(bio, iter);
-
-		if (!bio_iov_bvec_aligned(bio, mem_align_mask))
+	if (bio_iov_iter_set(bio, iter)) {
+		if (iov_iter_is_bvec(iter) &&
+		    !bio_iov_bvec_aligned(bio, mem_align_mask))
 			return -EINVAL;
 
 		iov_iter_advance(iter, bio->bi_iter.bi_size);
diff --git a/block/blk-map.c b/block/blk-map.c
index 615d29bb840e..9cb9605d1f62 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -473,7 +473,7 @@ static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter)
 	bio = blk_rq_map_bio_alloc(rq, 0, GFP_KERNEL);
 	if (!bio)
 		return -ENOMEM;
-	bio_iov_bvec_set(bio, iter);
+	bio_iov_iter_set(bio, iter);
 
 	ret = blk_rq_append_bio(rq, bio);
 	if (ret)
diff --git a/block/fops.c b/block/fops.c
index 3c2099dfef1d..d11923053afe 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -342,15 +342,13 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	bio->bi_end_io = blkdev_bio_end_io_async;
 	bio->bi_ioprio = iocb->ki_ioprio;
 
-	if (iov_iter_is_bvec(iter)) {
-		/*
-		 * Users don't rely on the iterator being in any particular
-		 * state for async I/O returning -EIOCBQUEUED, hence we can
-		 * avoid expensive iov_iter_advance(). Bypass
-		 * bio_iov_iter_get_pages() and set the bvec directly.
-		 */
-		bio_iov_bvec_set(bio, iter);
-	} else {
+	/*
+	 * Users don't rely on the iterator being in any particular
+	 * state for async I/O returning -EIOCBQUEUED, hence we can
+	 * avoid expensive iov_iter_advance(). Bypass
+	 * bio_iov_iter_get_pages() and set the bvec directly.
+	 */
+	if (!bio_iov_iter_set(bio, iter)) {
 		ret = blkdev_iov_iter_get_pages(bio, iter, bdev);
 		if (unlikely(ret))
 			goto out_bio_put;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index f9b8903c6a87..0d27e0c72905 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -522,7 +522,7 @@ int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 		unsigned mem_align_mask, unsigned len_align_mask);
 
-void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter);
+bool bio_iov_iter_set(struct bio *bio, const struct iov_iter *iter);
 void __bio_release_pages(struct bio *bio, bool mark_dirty);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
-- 
2.54.0

