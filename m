Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B4630FC1D
	for <linux-btrfs@vger.kernel.org>; Sat,  1 Aug 2026 15:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599301; cv=none; b=bPtJD9ZcsJcJhdM5Dj0Eq76EkUCGJ5dHpByKWUYfrGRpnhn1BPx0GiNdu7A2GgjpFZ6Is7hSo74339k9pB+KBJb+pmMJSJzVxe2lzTDFlq2v0yjN65rvlPqdziM1EpmPnQYt816Hve6evPq48fmAXy+7brUBzoJBcGqmJTQpgoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599301; c=relaxed/simple;
	bh=X3zRjuSdVBD5i7gQmFjvEEAtiBuCzXBqrfu9vE0MnhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFlxeml1yw5a4XCYMoowhERSK+6+nX5XIWBXw+Nq/pkaYlizbvvatoXkgxklTDulh4TRi/2xOW1qhG43SkEknaOxeIogJPcXSYVPaK2o1BcI/AKWXi9yPFV66HKJ32EAESwUFJUL0Xdlo5KAssB/eiW5zdUujAmoDXIa0Uit4Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s5Yo/707; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s5Yo/707"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cc73e322dbso18795845ad.1
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2026 08:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599297; x=1786204097; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R0GcIDTsY2CDASlyPqk465WOkbyFB/dgtSdtycnJJZM=;
        b=s5Yo/707MVtufZXlHpHeR9eOrEXTbwgJPhF30vx7pJGrFzN0hryZ/O84JB91C4DJFA
         TbHYUGYAXTW6nMuGTNQtbiGKzpYEL73jW/itojS9/HilH4tYfy2jMvI15KYkZhiECBud
         CMwX7/yc3W6yyRGL1mBGzkmfAnYZ3XwdGBpwe024v1IsKk4ZBqgr7shg2iNzUU12r/pG
         VTCGh7jP54IJsoHCaPyqt86UdTYcW9xsmoaMvH+qVR033WqEJ6V+aeAoXboHyY87aam0
         lWSJ+5dsyJmPYmlHC8trWpIu+mHIlM0FNORMvLLyxc/Zlayu05yoAXz/zvgDhti7Tz+C
         M7Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599297; x=1786204097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R0GcIDTsY2CDASlyPqk465WOkbyFB/dgtSdtycnJJZM=;
        b=RFq91PjUjp8gYSqVu2cqlN6MBettKlHo7L+3HntMcmwRY3XUl2ayAZmRLGKUXChuy0
         B/QmvzgHQWoE19eJh2/44sPBUWsRPpbB7mbx72nvk+bhTJoZFdB+ND3lKRfJ+O7yELy0
         Kf0c7VIB0Ykd8hpECrLR4U3YBtFLpRCQeRIHX8Eqo2yEGnzcDfUTh+m7gr6v/CAM6uMw
         vQyAnZM5HFDePFdm5r1DTBU+qjH/LMPshL/gps7q3OnnPILnJH+2ErR6wCUkB/itAaIK
         ByOuV+12QbR/RsXwuRUupfXIyDGPGp2Ml9KFOcKBNdDBHGy7TL7ngaKDIHtEwF+uKDJ2
         yiWQ==
X-Forwarded-Encrypted: i=1; AHgh+RqEEpbKbDQQiKLQ2cWxSipHIm+ZepohIMO9K+qMEonmpDfffywYS8OUCucEoQrncRI9dFgbsgwGjazB8A==@vger.kernel.org
X-Gm-Message-State: AOJu0YypOafaGba2egyoBWoKiMpwi+USnw83ZS1y3eXrr5mDKlilS/TG
	APljjKiBulJPvGatL1T4ETbqNjGgTKfv9SxZdvCanK4n3vk1dtxt5XPt
X-Gm-Gg: AR+sD13HRPC9G1zq7GfmYpSffPg4FJnCQo+KBgMMWD96XZtyZuffM14Bgb9009wmT8P
	EzSqRAf6w7EqlwFgHYEQfDDNSzZxS15G8LdkgAAe+uyvDOQQxRNWFPKV9hEG44lryhuYHHU+bCu
	ByjWW1IdbfJMHpQxpP4SL7uRGjsI5vIQ4b/uNb672+ERIaOf47kbGXnAebmwk5YfIXPDKCncpbY
	/b54VaAmFLfJ99DAG/lXCTkv/XBkPxNtdWBVP4WUTKiPXEjRiOBlJ4j42H94dIODz/w47Jb8Bpk
	qfUX8gQCK5iaKHd3kOyri3u25BE8M2Lkk7M3azTdI6I4lVFTVjMBK6OL4JzACuRmv4nKbiwSSVI
	6BTlZOn/hmbvf/hK9/n66XuikzhHFi39vi1LyHtcPmkO4xyWFhTwDjboSvhGQp9e0AkfEne8jXV
	GX0JGhIBb9lcZ5GA4Sr/kbsk276W1evrxVC+MYWYPuUJlyaYnzv6ZrQyfveoUpBKgN0cSi6iJdP
	JCWzdb4vxJwW72bU5Z8Vy++BVt8ss/gQkaEi7E74xKPSbA=
X-Received: by 2002:a17:903:22c3:b0:2c0:a555:80d6 with SMTP id d9443c01a7336-2d0521bcb54mr36749555ad.2.1785599297067;
        Sat, 01 Aug 2026 08:48:17 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:48:16 -0700 (PDT)
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
Subject: [PATCH v5 04/16] block: always adjust bi_offset on bio_advance_iter
Date: Sat,  1 Aug 2026 16:46:16 +0100
Message-ID: <64f559a1d1ac43880149de5950187beee6bc2aaf.1785596451.git.asml.silence@gmail.com>
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

Extend bio_no_advance_iter() iteration to also increment the offset.
It's not currently needed because the currently listed request types
don't have a buffer, but will be useful once we add bios backed by
dma-buf, which don't have a bvec but work with a single range.

Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 0445ecba3b24..f9b8903c6a87 100644
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

