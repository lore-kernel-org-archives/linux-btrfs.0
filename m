Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117B2329C7B
	for <linux-btrfs@vger.kernel.org>; Sat,  1 Aug 2026 15:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599510; cv=none; b=cg3XiDFvCgbW7mlVAF/ScQ0DvH5CFYJtnzdemTkxVQ8xv8lW9Lv4ZdyM5doYT4QvXYy2uds6zsiDpYmu3h7eKF3hBXexLVozQ3f9IH5ZMhJYRTVk2nHoqynB5FYrOQnOiJora3q1Sr6LCQhdYK1xzLSrnJZWMLPhDDepBLSRlCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599510; c=relaxed/simple;
	bh=PHUqDIjZ/fDz2a0/0v9uQuWQT4kuiEnCn87yNoeA1yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceyifdA5bUClvJbDPSQaKkrcy4C3enoNl+neSOXUnCzBv/X2TqduG7VJ1UHPj5Gr1L9NGmie0qWAAbux0UxlM/mU2N0x1HFP0dt9s0AgTExi2DiuXa6R697wu3R9Oq2lZZpK3OCkDaOnTg62CXynyf7ZTNcQk9x92yvvSzo8XTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NgBn7OYN; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NgBn7OYN"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cf27856f9cso20477485ad.2
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2026 08:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599508; x=1786204308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ijUzk6DmoV2KfP6NttCifTbOeJnZ78uDbymc6z2HdV8=;
        b=NgBn7OYNrfRieIBwlg4KoAGaQqQTlisou0OcugD6Ej6l/TaCFca1OiqCFyMpkC//QX
         r3UzS7SaCQ0sXrHi0EcoqlS4Ji6HKYLrWuwEJBOJt4z4LQTy7a1Sd86sPqoLTYbS5LWz
         lNyKClBDTeDgtecTN+13oelghUTMJ+Rk9K+65P+ktmgYx3fzP29/3slmIrJuXwEcqjK5
         HZihhFREitU7d+ghO6rCdjhDYR9CoWDEjMYxL8E0TOjUIkmdI4wd6zO+NZR73cE7hvah
         7vUJQry9aFAW3SldEaNxvG9FSt2XLDzrfqX5y3najTxpF3VuU2eOA+ZOvct8Y0iX7o0C
         uKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599508; x=1786204308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ijUzk6DmoV2KfP6NttCifTbOeJnZ78uDbymc6z2HdV8=;
        b=cXk4Ys9f+lIltTL06ZTwEOodaOB8q9Iq3bKZcMqIkznk6COSZcSjEwHddft4VgaVZw
         cDES3mhTnjuOkb5Hgsf2AyZW5Fpy1GV5JgPr9bowEfTRvmYX5Q9xJEJQa5sDam40bO1M
         5Z9YC5H7EcfkyIFO0iZJpaxIsks28QYebdMLWITrHa8xwaMX4uQsstAQ9yGavFaDexds
         J1COhhGnxdHAOelMW0KFtG/ej9iTTWuJANxQPqYKWCsReqcII7BsBYFiImU35MVeec1Y
         bIPxCp6ied6mYeWxpJJsFuEyi2hWapNOasQZOddZmgiFKcB9Kh6e/QJw8xrLeY2Blurz
         bz1g==
X-Forwarded-Encrypted: i=1; AHgh+Ro+7V9nL2skC7Ipssf5MG+jfo4hBWE0cFyPqPMVF2dOQEaWQ6+0e4O95Df57KQ1WpGfD7ECtTI0SuMjog==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxgj8A8GqZXYX2vXbxee7l7xBxFKWJ7MEKJD1LfVZIuRHor57lJ
	7RHpPFQx2K/Tv7/RgpbJz5Ed7Iawukw93VIPiJU95doZL49RDfeWkXh2
X-Gm-Gg: AR+sD11SZrnZ2IO+e3VdX3v6SmImdDsW2ycDs//7i4wjKX5xYJ91Uethp4sYLdrKysY
	j5oi0d3Ck0YGMIpsZKac3Y4d53Ah/vruan7JYJvA2siP2FJSvY0S7LYroOw3DuTPPPdghlDMWn/
	kO+KKubXUGT8aXb8X641YAHn4mBg2V7ZdsyQxhq1rX0D0eRO0kGZopxfR3Hfxuv/gKVzbhlIP0y
	qvTmVHlPeRT7c0kKzyn397EpBUUyayqb/hREq1yLMRS6OtkAhfl143VdZHu79M0SMsMsMy1FWrc
	kfQaPfXVDG8DVVvSHnm4MXPtEvPCPnX3fErl1gMCw4IV1TCeLcu/KEMWFpu2MghuloUZocMz62H
	sOZTS5nI6avKQ/x4SCF7TGfkq9o6/xIiOlCUTLWsAFR1LnYnAFCO6SkuevTHSIi7Kl7P/2TUZ38
	VVBfkVFuEgLz6OTYj6yMs8FYoakKdxx9TMm+mSVqdrxEPY8Cvd3NsZGP+3j3RQNe5ggbtQ1Fk1A
	5CaP3oKLAEvcLczMAH0llGwdG0KSWJQTelwwimHg2R53y6ljoe7/1l3RVY=
X-Received: by 2002:a17:902:e945:b0:2cc:9179:335 with SMTP id d9443c01a7336-2d0521e87a4mr39523185ad.8.1785599508438;
        Sat, 01 Aug 2026 08:51:48 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:51:47 -0700 (PDT)
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
Subject: [PATCH v5 14/16] io_uring/rsrc: add uncloneable regbuf flag
Date: Sat,  1 Aug 2026 16:46:26 +0100
Message-ID: <65be6058af60c33328f9ccd8133d24e2bbbd0f84.1785596451.git.asml.silence@gmail.com>
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

It's hard to implement cloning if the internal structure needs to be
mutable and/or relies on other ring resources. In preparation to such
buffer types, add a flag indicating that the buffer can't be cloned. It
might be possible to add cloning in the future for them, but that would
likely need reallocating the structure and reacquiring resources in case
by case manner.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 5 +++++
 io_uring/rsrc.h | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 406619158fbb..f041b0db77af 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1381,6 +1381,11 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		if (!src_node) {
 			dst_node = NULL;
 		} else {
+			if (src_node->buf->flags & IO_REGBUF_F_UNCLONEABLE) {
+				io_rsrc_data_free(ctx, &data);
+				return -ENOMEM;
+			}
+
 			dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 			if (!dst_node) {
 				io_rsrc_data_free(ctx, &data);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 98ae8ef51009..83aa86e6f320 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -29,7 +29,8 @@ enum {
 };
 
 enum {
-	IO_REGBUF_F_KBUF		= 1,
+	IO_REGBUF_F_KBUF		= 1 << 0,
+	IO_REGBUF_F_UNCLONEABLE		= 1 << 1,
 };
 
 struct io_mapped_ubuf {
-- 
2.54.0

