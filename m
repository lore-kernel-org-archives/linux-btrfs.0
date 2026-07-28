Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC9247ECFC
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 21:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274214; cv=none; b=rjIwONqXLRsOzd1ZhksIkYBikb3+35xeItj1pcIju1fTQAEn94r6ucA5XqI0yytj3VhkQmySY8agFYS145cS+lzbKe119JtjE14UONcjP9xDEAqF8aCqX2I3CV139Qd9+qaS9BIQ0Yiagw+sGM+IbvLre0EI9M/3riWa1yJ0uVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274214; c=relaxed/simple;
	bh=bt1fjQx57j1sUPSIKU54YXB3emwAGpiLG3SIBERbcvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MM4ijPhRnebatPBLvT2EwWZSRp/LUlnoHMIqFnQBfAZkaxbSIVBejUVIj08/LsHN8QK/0rLFRLswb92LuV8kQlHJxxL5mGVarUA8ZHrlMAG+ALHNJK4mlJ+ZmrbXgQiOh2YDoDxwpYjQEz37gfDyQPkHq0YsxX5XqbWRuhlfsIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D3I3XC6d; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D3I3XC6d"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-472326ca506so239279f8f.2
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 14:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274210; x=1785879010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mhCvEG3xgv0esCi48jrWlXZeUf+lVK0keP2zUsWb1Q8=;
        b=D3I3XC6dQ/oOKK2O/2ofvHmwDqjhElP2Cr/usPPiueWfnxSn291o1UoHCTlZeOOIVL
         4D0hz6PHOvhptiOnA2XMfGCTho/jrTmMeHMeaiKcW9CXsuQqojpwhUvNpCaMoyyAh7il
         T3/CXl9KoCt22vkEBKM9GTdSMrEIiT9rxrEfM4phZpjjKShmuR8flxyCxHxCWuoyylrJ
         jNJsleztVMOIFqxHPMpw2oqJ43P4msMjLX4W5xT0180dH0o09UsQDoUmJywdzP/RE8uF
         zDmVjFxxGG8kn34gn5KiBCq6veaRLjHl0rFSQu1Nou8MfP9W+dfpVN+PP4dZdFQ2guM6
         c0SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274210; x=1785879010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mhCvEG3xgv0esCi48jrWlXZeUf+lVK0keP2zUsWb1Q8=;
        b=CyHizaBBbnolUvGiYCbehbvsBk0KRZV0nQ81snM6+ifDuxceZkIXZ4WfWj0zrv5oZ/
         Qz2AKAosqemSonp4IoiN6kxlfggpzsru9Bcrvew1JFTFCh85IpjfiCdu3AA5149aIJbd
         s0u7Ze9PT9gTa1QBhDdEGIyUTz0Sq78HQkAwufGAFLtMqO76AULpMNJc2xpT+fGyaY97
         lRv1AHCJVmXmRpggewq2lLgpr6Zlts07ic/10Xeng2hpIrfVZz3lqippjZuVLsp6xXpT
         RGTGE10DhABdVDtcdDPE45NBE97v1py1RUvQz7m/kowyK1LD48TEpV3jmJM0dOqov6Vc
         z2Ow==
X-Forwarded-Encrypted: i=1; AHgh+RrERdmmwroPAqIb9Bj1tQoSfMR9nqT5WTzz3JQeN3XCX0QHLooTYqwVPucUuQDMDAwbbJrPlbo1xp0ZUw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4HVGWHygltxTBwBl+nIERHx8bdzBCDySHkd94c0rggq/p4ouv
	PuiMYjeOY8tmnxkUDaNF+JLPgY0jKAZ5Kvx0r3e/D7FsivamC8thgXU+
X-Gm-Gg: AR+sD13O4RsmQAteUDsnOv9GP9ywnAnVYiTNDvNb10U9dOEde30LGWMJ9lbtZSNQAeU
	qdRUOhJw3phA5gWPWewwTyU6RDfJVCyhAX4VnmUjKlKMDtmEII60bdslxLzyX+3X5q67JBq5DhD
	7RM4q9R8CNxAbVGHnGkxyMWOidPFEKNQ/aOkUHXjbLvCIcI9IxuDDCAxajAX0NsJcMlgYvAJ4my
	CcM60a3tNogWOs2KL/wrkgpkb4VHctEjfklw9vr7WFqApVy/6sYYYhGqWH11TJ9qNffNylraHd/
	LvVTS24ncbqzIMmsgoaTvAwN9ogfq6iW1Y9MppKZZXf8qpv4kYX7cKy5F1xNTCmuO5ECvBleSAd
	NfHvK+Y5zilKuSSsOBxx7/wscYQUS+j4McN+guVFSH5KEbAG+Gc50Wvv3XMPwFDm67Pdf+uGVU4
	0BuG1goXUJLd/QHAmO4RImd7FBQi0EubWDpeTrcrMWeF88j1wGPOXRwmFcVFFetSjyGEu2fSFAr
	KGA58XC
X-Received: by 2002:a05:6000:26c1:b0:476:8a:5 with SMTP id ffacd0b85a97d-47fb1f12d18mr4496873f8f.34.1785274210211;
        Tue, 28 Jul 2026 14:30:10 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:30:09 -0700 (PDT)
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
Subject: [PATCH v4 13/14] io_uring/rsrc: add regbuf import flags
Date: Tue, 28 Jul 2026 22:29:25 +0100
Message-ID: <9eac63cb6aae06f591e6d0c67505ea2c16dd99e6.1785274111.git.asml.silence@gmail.com>
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

We'll have special registered buffer types that can't be used with all
opcodes and need special handling. Add separate flags to control
registered buffer import, which will be used to specify what kind of
buffers the caller can handle.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c |  8 ++++----
 io_uring/rsrc.h | 24 ++++++++++++++++++++----
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d57e8a0380b5..05877b4c0ee5 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1245,9 +1245,9 @@ inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 	return NULL;
 }
 
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags)
+			unsigned issue_flags, unsigned import_flags)
 {
 	struct io_rsrc_node *node;
 
@@ -1656,9 +1656,9 @@ static int io_kern_bvec_size(struct iovec *iov, unsigned nr_iovs,
 	return 0;
 }
 
-int io_import_reg_vec(int ddir, struct iov_iter *iter,
+int __io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
-			unsigned nr_iovs, unsigned issue_flags)
+			unsigned nr_iovs, unsigned issue_flags, unsigned import_flags)
 {
 	struct io_rsrc_node *node;
 	struct io_mapped_ubuf *imu;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 83aa86e6f320..f12abaf63270 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -65,12 +65,28 @@ int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
 struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 				      unsigned issue_flags);
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags);
-int io_import_reg_vec(int ddir, struct iov_iter *iter,
+			unsigned issue_flags, unsigned import_flags);
+int __io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
-			unsigned nr_iovs, unsigned issue_flags);
+			unsigned nr_iovs, unsigned issue_flags,
+			unsigned import_flags);
+
+static inline int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+				    u64 buf_addr, size_t len, int ddir,
+				    unsigned issue_flags)
+{
+	return __io_import_reg_buf(req, iter, buf_addr, len, ddir, issue_flags, 0);
+}
+
+static inline int io_import_reg_vec(int ddir, struct iov_iter *iter,
+				    struct io_kiocb *req, struct iou_vec *vec,
+				    unsigned nr_iovs, unsigned issue_flags)
+{
+	return __io_import_reg_vec(ddir, iter, req, vec, nr_iovs, issue_flags, 0);
+}
+
 int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
 			const struct iovec __user *uvec, size_t uvec_segs);
 
-- 
2.54.0

