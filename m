Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077AC47DD50
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 21:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274212; cv=none; b=d1BvtmM13CBsIhgosA0dHQwgjvOfwBGNDcbA+JF4B4TWA+xqBb+U16LU+ZLVfX3AjFaSJOit9WsH84njluQUO+bRiRDzKgKcwaVSwjjMScSQtv09lDGl7Rnz16o9pXo3yphuaO/upU9PcnfhHgqTu2sE7yAcTXHEFOeMA99P/lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274212; c=relaxed/simple;
	bh=GOpsniia9YGwJC5+Tf9jZp7skqJgnlIpNpZfRP/ds68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c99zr92yIzlDzPGfaiFcB3+e5iad6onW/uqp6X30YNxyhK4g6TLjqjGjGWnyDNOB2plNlatsGH+zRC8UCLFnz1ejeVshMhJwp/+3OProv0zMfUNhFf1+HRyVOTj+i35Isv/1BokNCPEQUrFW1tN0Eju4BThijQn7I84/4rtGZd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H5Ym4u/V; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H5Ym4u/V"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f7854678bso136598f8f.3
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 14:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274208; x=1785879008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jomHTWh5pLJKgL2wIyki6K11K3ENYcuFeD6DEOIqSFg=;
        b=H5Ym4u/VExLT6WCLEE6Kv4YIjIw58vB034j8JEtU73/52h+pQnIHzfk9AFZZ7sYOjb
         8zlZzzwzcZzyJN9OYpWJ55tzNZb0Mo6Waf1q38cQDVRs8lfGOHXMPls5sh4/rm8Leqmy
         gXWt8McGH1ltozIKZ+VJYO62dYGsgiFSxlNJtrV9ymcJBGJA7MTfe0qICFv3efxNTiUi
         Ewfiu/Ea/sINTuGolpH0q03ARYDniehuDgUm3WrSEVB4y7Nf8kgeqlwD7CDcQQ4L8f8u
         Ao9Ov92XKpNK+yJ/fcgLbF6EbI1zlAJ6KEoSzfPPH9VNM8LzJsDWMTMZKpQ3fvXK7dMo
         lepQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274208; x=1785879008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jomHTWh5pLJKgL2wIyki6K11K3ENYcuFeD6DEOIqSFg=;
        b=ZJCGRAkf0yD8bQwUN94JxKceZUz883xt0nnyBDXmiy/E7wI7TdkXNb69gXH4hzUoxG
         Sv4dTyPtIUgqcA9osEVY6E8sVqBpA68M5UnlE6/3EOZzdO0DjR9i5Z4ux1HWxf8pPv3/
         u1DGELH+pP9vz/+NGerPKErgu4tLfBKQJGcquCQelUZe4TjVmNrFxpw2quOiV9AFZs2V
         4bIFcpsomz5SWlkUigODG25bvax7id739bgn2RsH+pWSGU8Cd5TD2nnKv8pk0nPNHGSR
         PLZAHeLjZHiZXPvOdNslQLCi674AC9urpmwDc2TYAqlEh89GZ/w77SyyZliQxzVyyZzZ
         ojpg==
X-Forwarded-Encrypted: i=1; AHgh+RqXIWjXqQ5FDyOqrPQ1SZSAXFB612vx8fPNW1rzk5A7ZOOgje9hv2j/m3k2sJ6T8oF1xzfUaheE++1eUw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxiq1sNRLzf0ayEW50rkyGHOQf1kJhIxAePoYYKggFG4X+DhX68
	NcCZIGIpiDwTeWjkhXnzOP4C61WFG6rsWJ1kcPXU0au8p9IqujFtq3p0
X-Gm-Gg: AR+sD11FCx6nDIU5ow6CK+bnt+GuCV+9EiMzqwDE3y/m6LbGnOr1/R5oqhdahuEO6Fu
	a5188oXJcgUN5wohKcvTZZWRVwyQNywuoVj6cvWr7MyjHL03KBcaHsBsENhGrwntNH5cZuygepy
	zYJC7+gODh4tXuZdIHHKqWptNUYpzV3651zROTgALwE3R0KFqK7b4dx1iJc4GcGHMMeMHZztktt
	n1V5ejhIAPqApxpSeCeNA9+R/8Ekc0K6aO8Qd0Wg91VhkoPf138WWrqFcSmj8o/AZXb2NQHzgpD
	ETSMoQfFzFg+GVGgfP0Y4S5837iR0uPDtdGVM/WC2ZTWZojvmpcnuS+whcvxo3x1a3bt0lCcytl
	R9vTV6CforjKmHGrE06KQJ1LyEkBcHGD9bUdyPzbTVzJvhWf/m7I9A1QCkVQqGlKpMAaIudyTMX
	C+xt+1uaGjhD9MY4l5DpJSKDkG2akztARiIIY7H40aTsi/Tszrf3A03H6Qn7Zy0PKcSRoPXYt0B
	YCHUj4e9csmwnYH5MY=
X-Received: by 2002:a05:6000:2f81:b0:47f:97a4:f121 with SMTP id ffacd0b85a97d-47fb1f108a5mr5045703f8f.30.1785274208062;
        Tue, 28 Jul 2026 14:30:08 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:30:05 -0700 (PDT)
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
Subject: [PATCH v4 12/14] io_uring/rsrc: add uncloneable regbuf flag
Date: Tue, 28 Jul 2026 22:29:24 +0100
Message-ID: <a138961611aadf950ce6ab9215f00ae888b8ce72.1785274111.git.asml.silence@gmail.com>
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
index 24fc3232a66a..d57e8a0380b5 100644
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

