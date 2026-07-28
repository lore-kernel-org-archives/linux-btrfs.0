Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A6F477286
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 21:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274194; cv=none; b=GC5iIvTe/9E3J6oTvzJcuRLM+NQbu4oKJ09e1IdMLvfCucoqIrK2LvKEQWZMT1gmlmxKwYzwRyqzYyT8fk61y9TVqT5nX25BfC/+PYDXsuk6IQf4RV7yA86Ov64V13Fzl4ZjvUYoyjX/o7yrsAbaYgKDuIpXVUxqYF+vS1cfXNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274194; c=relaxed/simple;
	bh=8xr8MwL4FN52J9Jpo5i7viXCOQG0jJEsaEIs2M6dEzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEc13VzD6Uz2vTH/rwXg4fH4WRnQd+IkGa9tNooAocwLDBT5/O5CyUaVPZu4xDS4IeP5lmKNT6DMlHnGhmFeJUuVguUYSflJKIrrsAUMsZFNcuhyoMrCWgsv2JGRC23jJhaTHM9UjSA9SxgO49U96/xCy6/3WEmHvgpFH3hok5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=csI9HarM; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="csI9HarM"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47f707e5d75so224906f8f.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 14:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274190; x=1785878990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9CVR7oFwap/NcOYCsrr92EnvOtaWQ9jX22O00IMi0SM=;
        b=csI9HarMjiyZMEy8p92p2UaIw77xnaj7XHbu4CDwG0PS5oFO+HFKqsfrV/yrow+89p
         KIlVLLeDX97AE7sKi+LzJFcJhL0CyL50wGCN4Z+TSo7IxfS28IwuoYfzErnb+dSgye4k
         866bJbyC0kpSZop+QCDFPKHL5WpzjyJOlL9w57r/6PGuy2rydHRD+amCYAPPtPXdZRVe
         uosMCrRaRKC4CNvoMts/WOEQy4U/VG3hAj48E0ptCLS0xGkNkOxKpCS1I6pxDveApMYk
         rSTFWITiT6y9w0zRcopYEUB6kexi53uJcIdCJhIE+R6p4ri1MZVpulnIxdRbyQOPcWUP
         jATw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274190; x=1785878990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9CVR7oFwap/NcOYCsrr92EnvOtaWQ9jX22O00IMi0SM=;
        b=aDnGg6wirLXySe1D+81DO2wGciQHBQmn5GcAJ1sALoq9QX6p0HNI+MQVZ72u81awib
         11UGNlnjiheVj/fb4Rrxv1OZbyeyI+l7KkmrvZvs5UMCnSU0vc93CXU8tTT1jMv17ggk
         v/3ZwJHOaUzr2HGbVeENlP2aRYV2pgLJvto9lyU2fhfj83xL3rGeUxFoHqPDyy0yY4lK
         iq2R7Ids1g2qFxx2PFiGRAQvwJ0rxGVjR4fAqrPiRojLLFCBQSh1JZGWjtjqGpSBLur+
         QJXLi2M6K2Ixw1pvnDY7e7aLCs+4gSdeuoUlaeUSTZvyyzhJHJOFuDN+MwrboNLeMp+o
         VS7w==
X-Forwarded-Encrypted: i=1; AHgh+RrNM4R0JuGDxRsDztpJ7zEaiWP+RnlrUyuYPPftRIjQiTNGR/apGvH3QGONpSntzwYdcj6gz61SWKVmXA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyxN8u9JrGqqbVVb8YsbP9N3GOQHbSZegLOfLgkoArUpLfZg4Hu
	UiGLRjN60zKMjIqy4/zuP0ErfAqldaxvpiRpLmhHm/lPIipoCN6TWSKA
X-Gm-Gg: AR+sD12u6uKMWWlFRibNVhmG9+FrgPOKLCGloti81QTSGyc73aU0797XFGz4yMYnPpB
	QyPOoAr7mXxlBxTbdrDOR2v6dvOprVyYYoRljhcnH2fx4DRWJalNch52rJfqmUrIgZZvW4IZylp
	jIiq7FyEvNuirN8/NiUQqEy1abx/oTtsx804pqH9P7vUqQ8LbFLjwgKxnH/D55HwAz/G/u56BzL
	a2IPxVQipIoyoDi9vf1dhAeRp513LWCNMtplryvq1PN8AxYAxQUzfNKvXIYNV+nfUYCLRrs7dv6
	ZQDTnRIi1aLKk0o5Lp16rrgFNg9xHHZrYyFKeGt1TmX4quph0s0a966JKxdexGdU7g2VCXDhuLH
	bTYPnFJeRCCJhNsiT9azy7u3oOxk+PFmIln+2ReurAFbjCr1mwaDBDwzWi31QEit1l2hp4/Xm0J
	fWK1j/88kt3WEynxHTqWNeShaLP8pJmq+qgxNDoYI0WgKLukCvydN2evxOCDPZutoBLHVfsfCr9
	WIEH4s8
X-Received: by 2002:a5d:584e:0:b0:47f:95ec:a49b with SMTP id ffacd0b85a97d-47fb1ea7d64mr4772853f8f.34.1785274190146;
        Tue, 28 Jul 2026 14:29:50 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:29:48 -0700 (PDT)
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
Subject: [PATCH v4 04/14] block: always adjust bi_offset on bio_advance_iter
Date: Tue, 28 Jul 2026 22:29:16 +0100
Message-ID: <8d4f786e3cb9ac6002bde5f3271dcb6d22c498b0.1785274111.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785274111.git.asml.silence@gmail.com>
References: <cover.1785274111.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend bio_no_advance_iter() iteration to also increment the offset.
It's not currently needed because the currently listed request types
don't have a buffer, but will be useful once we add bios backed by
dma-buf, which don't have a bvec but work with a single range.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/md/dm-io-rewind.c |  6 ++++--
 include/linux/bio.h       | 12 ++++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-io-rewind.c b/drivers/md/dm-io-rewind.c
index 04f3fc8aeb6f..b22719c6411c 100644
--- a/drivers/md/dm-io-rewind.c
+++ b/drivers/md/dm-io-rewind.c
@@ -113,10 +113,12 @@ static inline void dm_bio_rewind_iter(const struct bio *bio,
 	iter->bi_sector -= bytes >> 9;
 
 	/* No advance means no rewind */
-	if (bio_no_advance_iter(bio))
+	if (bio_no_advance_iter(bio)) {
 		iter->bi_size += bytes;
-	else
+		iter->bi_offset -= bytes;
+	} else {
 		dm_bvec_iter_rewind(bio->bi_io_vec, iter, bytes);
+	}
 }
 
 /**
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8f33f717b14f..dea9f567379d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -113,11 +113,13 @@ static inline void bio_advance_iter(const struct bio *bio,
 {
 	iter->bi_sector += bytes >> 9;
 
-	if (bio_no_advance_iter(bio))
+	if (bio_no_advance_iter(bio)) {
 		iter->bi_size -= bytes;
-	else
+		iter->bi_offset += bytes;
+	} else {
 		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
 		/* TODO: It is reasonable to complete bio with error here. */
+	}
 }
 
 /* @bytes should be less or equal to bvec[i->bi_idx].bv_len */
@@ -127,10 +129,12 @@ static inline void bio_advance_iter_single(const struct bio *bio,
 {
 	iter->bi_sector += bytes >> 9;
 
-	if (bio_no_advance_iter(bio))
+	if (bio_no_advance_iter(bio)) {
 		iter->bi_size -= bytes;
-	else
+		iter->bi_offset += bytes;
+	} else {
 		bvec_iter_advance_single(bio->bi_io_vec, iter, bytes);
+	}
 }
 
 void __bio_advance(struct bio *, unsigned bytes);
-- 
2.54.0

