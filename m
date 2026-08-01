Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6B923E358
	for <linux-btrfs@vger.kernel.org>; Sat,  1 Aug 2026 15:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599216; cv=none; b=KKfaLuo+sqj0I+HIURyS5Cg3PNdeo1Nd9s4Ge1WQepb6NuYL1dnOeU3asI4jNN9kai/jF53ZsLfqFUf941p8S4ClgKhmFZvFXs0+gV9/FjkctJoAk2QQFecXL8+f/mnuYwMkEsAWF830YcxhXV8+Zl6JJDYG0iVuQ0UOWTWWN0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599216; c=relaxed/simple;
	bh=Y+F1HB+tbEbIakNHePIXL19RIP7js/Qa1d0d1IS0Cbc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TzoNesjnaCEKM07G2pRKsypsS8oc1Vnysr+AbVJzjS9qDeErEutfQCxLQ3L/cRC7sAzYqWNCVo+gX8FjwirygE6FGEX9aWKKwHh47Mjc3ZomkB8WIwDaZfiRaEwxzR4H0S+2P/v7cY+46zT30YLDzmX6lZLsJPL5DSpCGj5s2MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZRsS50g5; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZRsS50g5"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cab973140bso24774245ad.3
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2026 08:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599213; x=1786204013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YTrKNi3+MrECxNlqKVpRT5BFV68pBJo2ri08VcWIuD4=;
        b=ZRsS50g52b17YRQxkyDh/Htty0MwZ7IJBQTgQ/3LGYNl7sibKb5mgsuWphVmXdzZdK
         FanDx2nEhYIl0Ox26Np3qgfs87ZfJKnpv9xS4ioAAW5TnhD8iEJ8Trv/GXDx4x6webiI
         pjspR3yUNwy3stIJ6OCSaqws6p1EWmApg6uHFLvX3skdxzeHMPEby0pPSQpJDjyRf2lM
         zCcmGPmBnQwCT+UMY4sUVyzaZMORRXrx0bnnSD5KYarkexXCzaOBGpl/UJXCLjNqnMl6
         dTnyX5FQykzfy/aYD0C0EaWSjxm053JGJT/p70CFLNcKpBSNXH3W0pf4HwFyBElatQsH
         hOMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599213; x=1786204013;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YTrKNi3+MrECxNlqKVpRT5BFV68pBJo2ri08VcWIuD4=;
        b=b0jnQV7M3gQ+9PzaAs6spHxFIho8gR+u+fPA1zqBuEKHJaR9wm7tYIYTtxddOTGkFj
         uQjuv3tzgrrrJMlYLSsffzZqtnMZON4/P81/RiUVybMiUVl8bNstZqA2oCXOI6yE8o4J
         cIiY1bj7W7JLKr3dI1NjkI13CKPtywQant8RsDCx+7YtT65Gn2zKb5U8SQSS/l0ddruZ
         ehknJdE82wcASNO5dMn7jdXI0Uppf3JceXljjPisVUBpDfbG5QRRpA05vsGnkbZsOpfY
         CzlCAlIDXaczMoNUNJiV/tq8tuhOnBTA5PDuYKh/kmWj4FsLMsXBaSkDSQJTpZXs34rI
         pTaQ==
X-Forwarded-Encrypted: i=1; AHgh+RpP16WyPfAjXOboR9fufj6W81tZDq/zNNBOCYrMoF7fYQCflxDz9rDCid0hb/JewGjHd7siucuQ89EFzg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy62wJhT6V1JWb8D/XGUYBk7s277VF5bxJTzO5lPUs1Q5k5Mpr5
	rRm8kQmkvj017H2vIIEGv5WGEKoPQ0kuNCU/Q4nqPx1KVr7ccpk3A9wl
X-Gm-Gg: AR+sD11bZnlD2LXOTz6HA8VEvty5xw5AH1rEwR8TRtbfPrfNWWAOxMzrqDZqyJlcAZB
	DWin6QfHTjD3JDVVfDc3tTDVbZp2a7isvGS4AoKEzKVYcBFbWtpuJq06d4oDiUG7Xx3fiz+dnTP
	/L9jCx85xQ1h/B4n3hRn+8+HXj1PY8iI9Mw2+XXyIoWchHfK6gku7rvKtRwvj2ko3AEPM5k+BJF
	UlEl+l4dtLE6zdZwAVZZh1ONmTxS/eojXuD+iZ9IQi+DhL1xfbsmQ4s2rXQ/wjU6nc96FKGMWFv
	T+mw9tpdlkQus3gZXMmbyKU7Jntj70bFZjlfXNjGKQLt8eEaauhr/xRKWuthICMlhZJqX8z/867
	yIiwNfWmnaeNpO9Swui8CmatawH32UJbnt8a6eqbXAwu1IddWHYqQ0KtA69YoWA5AUBG8CysgwR
	IF6NiA7soJDLdiJCBF2uQjCxQL49yhe5QkWGCAEi8VJYi6LqHiOk0a8yTYW5MluMyhZJic6ZbSp
	H7tJrOBJOeEkGCzADNxkowqmb3Rde0nsLhIEcZV6bbsGoA=
X-Received: by 2002:a17:902:e943:b0:2cf:ba0c:aa5a with SMTP id d9443c01a7336-2d05241650emr38409935ad.47.1785599212500;
        Sat, 01 Aug 2026 08:46:52 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:46:50 -0700 (PDT)
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
Subject: [PATCH v5 00/16] Add dmabuf read/write via io_uring
Date: Sat,  1 Aug 2026 16:46:12 +0100
Message-ID: <cover.1785596451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The patch set allows to register a dmabuf to an io_uring instance for
a specified file and use it with io_uring read / write requests. The
infrastructure is not tied to io_uring and there could be more users
in the future. A similar idea was attempted some years ago by Keith [1]
(from where I borrowed a good number of changes). Later it was brough
back up to life by Tushar and Vishal.

It's an opt-in feature for files, and they need to implement a new
file operation to use it. Only NVMe block devices are supported in this
series. The user API is built on top of io_uring's "registered buffers",
where a dmabuf is registered in a special way, but after it can be used
as any other "registered buffer" with IORING_OP_{READ,WRITE}_FIXED
requests. It's created via a new file operation and the resulted map is
then passed through the I/O stack in a new iterator type. There is some
additional infrastructure to glue it together, count requests, manage
lifetime and implement invalidation.

Tushar, William, Phil as well as Kanchan, Anuj and Nitesh did a lot of
testing and experimentation on various devices with previous versions of
the patch set (separate thanks for trying it out and investigating
problems). Earlier benchmarks by Anuj for IOMMU optimisations with
udmabuf showed:

STRICT: before = 570 KIOPS, after = 5.01 MIOPS
LAZY: before = 1.93 MIOPS, after = 5.01 MIOPS
PASSTHROUGH: before = 5.01 MIOPS, after = 5.01 MIOPS

# Patch set structure:
- Patches 1-2 introduce internal API and infrastructure mediating
  io_uring and target subsystem / devices
- Patches 3-8: block layer support + prep patches
- Patches 9-11 implement NVMe support
- Patches 12-16 add io_uring support and uapi. Patch 14 specifically
  enables dma-buf support, the rest are preparation patches.

There are some liburing tests that can serve as an example:
git: https://github.com/isilence/liburing.git rw-dmabuf-tests-v5
url: https://github.com/isilence/liburing/tree/rw-dmabuf-tests-v5

The patches are based on Jens' for-next. Also available as a branch:
git: https://github.com/isilence/linux.git rw-dmabuf-v5
url: https://github.com/isilence/linux/tree/rw-dmabuf-v5

[1] https://lore.kernel.org/io-uring/20220805162444.3985535-1-kbusch@fb.com/

v5: - Reject dma-buf with buffered IO for raw bdev
    - Add lim->max_segments bio splitting
    - Add bio_iov_iter_set() helper
    - Fix io_uring uapi validation
    - Other minor changes
    NVMe:
    - Rename nvme_pci_sgl_set_data() to nvme_pci_dma_iter_set_sgl(), split 
      into its own prep patch.
    - Convert segment walk loops to do-while.
    - Drop adjacent segment coalescing logic.
    - Drop first_dma/first_len from nvme_pci_dmabuf_sgl_nents()
    - Remove entries > NVME_MAX_SEGS bailout; moving to the block layer.
    - Factor SGL vs PRP decision making into a helper.

v4: - https://lore.kernel.org/all/cover.1785274111.git.asml.silence@gmail.com/
    - Add sgl support from Anuj
    - Move it under drivers/dma-buf/ and rename
    - Fix mis-sized allocations
    - Fix io_uring re-import mishandling
    - Drop map before io_uring "task work"
    - Move blk-mq callback to block_device_operations
    - Convert bio flag to REQ_OP*
    - Other small changes

v3: https://lore.kernel.org/io-uring/cover.1777475843.git.asml.silence@gmail.com/
    - Rework io_uring registration
    - Move token/map infrastructure code out of blk-mq
    - Simplify callbacks: remove a separate blk-mq table, which was
      mostly just forwarding calls (to nvme).
    - Don't skip dma sync depending on request direction
    - Fix a couple of hangs
    - Rename s/dma/dmabuf/
    - Other small changes

v2: - Don't pass raw dma addresses, wrap it into a driver specific object
    - Split into two objects: token and map
    - Implement move_notify

Anuj Gupta (2):
  nvme-pci: rename nvme_pci_sgl_set_data to nvme_pci_dma_iter_set_sgl
  nvme-pci: add SGL support for the dmabuf path

Pavel Begunkov (14):
  dma-buf: introduce initial file I/O infrastructure
  iov_iter: add iterator type for dmabuf maps
  block: rename bi_bvec_done
  block: always adjust bi_offset on bio_advance_iter
  block: move bvec init into __bio_clone
  block: introduce bio_iov_iter_set()
  block: introduce dma map backed bio type
  block: add dma-buf support for raw bdev
  nvme-pci: implement dma-buf backed requests
  io_uring/rsrc: introduce buf registration structure
  io_uring/rsrc: extend buffer update
  io_uring/rsrc: add uncloneable regbuf flag
  io_uring/rsrc: add regbuf import flags
  io_uring/rsrc: add dmabuf backed registered buffers

 Documentation/block/biovecs.rst |   8 +-
 block/bio.c                     |  33 ++-
 block/blk-map.c                 |   2 +-
 block/blk-merge.c               |  45 +++-
 block/blk-mq-dma.c              |   2 +-
 block/blk.h                     |   2 +-
 block/fops.c                    |  35 ++-
 drivers/block/loop.c            |   2 +-
 drivers/block/zloop.c           |   2 +-
 drivers/dma-buf/Makefile        |   2 +-
 drivers/dma-buf/dma-buf-io.c    | 278 +++++++++++++++++++++
 drivers/md/dm-io-rewind.c       |  16 +-
 drivers/md/dm-pcache/segment.c  |   4 +-
 drivers/nvdimm/btt.c            |   2 +-
 drivers/nvme/host/core.c        |  12 +
 drivers/nvme/host/nvme.h        |   2 +
 drivers/nvme/host/pci.c         | 424 +++++++++++++++++++++++++++++++-
 drivers/nvme/host/tcp.c         |   2 +-
 fs/btrfs/misc.h                 |   2 +-
 include/linux/bio.h             |  23 +-
 include/linux/blk-mq.h          |   7 +
 include/linux/blk_types.h       |  14 +-
 include/linux/blkdev.h          |   2 +
 include/linux/bvec.h            |  17 +-
 include/linux/dma-buf-io.h      |  92 +++++++
 include/linux/fs.h              |   2 +
 include/linux/io_uring_types.h  |   5 +
 include/linux/uio.h             |  11 +
 include/uapi/linux/io_uring.h   |  31 ++-
 io_uring/io_uring.c             |   3 +-
 io_uring/net.c                  |   4 +-
 io_uring/rsrc.c                 | 280 ++++++++++++++++++---
 io_uring/rsrc.h                 |  45 +++-
 io_uring/rw.c                   |   6 +-
 lib/iov_iter.c                  |  31 ++-
 net/ceph/messenger.c            |   4 +-
 36 files changed, 1321 insertions(+), 131 deletions(-)
 create mode 100644 drivers/dma-buf/dma-buf-io.c
 create mode 100644 include/linux/dma-buf-io.h

-- 
2.54.0

