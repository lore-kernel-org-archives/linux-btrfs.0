Received: from mail-yx1-f66.google.com (mail-yx1-f66.google.com [74.125.224.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8723254BB
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 15:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897084; cv=none; b=Y2Hf28GvsDDaj1mg1HyRi+a5BrD+hP6nFhUNwUZzC19waMihbdIgALX41I6iyEnMbamxViqntuWckKq3ccjzKRNNga3KtTtpuMy8t55MUgjaaO0jfLLqqGf2YGE/5BWWhzxe7JXzacY0oQJGAKKGckugjsmTjbltPrP/6p1OBEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897084; c=relaxed/simple;
	bh=hYqS1ONzr0hpnUJ1No9Ealkh01coGiqIb+OFqI97Zzk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=o25/ORlOaa0Y3N+Xmf3kJB53MOP0Do8PIrNmoljTQgB3qz3gCEDVIO8Tt4KWzOQzd+J5PC+MINrZVAs06TThpI786TWA1HulpNyt36p6rEq95P0CU/aMJaaQ1jmQxGQDrBYwtoneISjedYrI25YgLbGNEQa7V/T7kh4S8tmB7FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TEwiDR+e; arc=none smtp.client-ip=74.125.224.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TEwiDR+e"
Received: by mail-yx1-f66.google.com with SMTP id 956f58d0204a3-65dead17c24so11041547d50.2
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 08:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779897083; x=1780501883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Wg14JyZauMvyUREp2BQI/yu4snQ9ClL6G3EhofaTxkw=;
        b=TEwiDR+eEMaehRcQtGnKtS5GgnZXG8z0hh4lGE03o/9UJ8Pav99yHCZNlgnZlCHzNN
         WggiT7EoP7/gfsYvC83zf5mQxlwZaU/WVB56lElC+CQtalCe/rRCDzHaDSCYbILOlFoD
         NepliQFWegJjTimVxX18fCJwHMjTnW69iLSU8H0+fMa5Z+e2a4FxNti4wqOX58B6hWeg
         JzT8sRuGCQoy0mraODXo4HZeECIzVxKSZoTEUI9Jz3cP3XLxcu4IE3ojD4JL/28+A16c
         WuIUYPYc9dh8IulZZy7blbgFEcJrVUWWHwhB4ZhD4eBzJ4C5pXK5Cz9oPsoebh5B1hmQ
         iRuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779897083; x=1780501883;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wg14JyZauMvyUREp2BQI/yu4snQ9ClL6G3EhofaTxkw=;
        b=oBsets9ar0ZFZoJJSO/znrVrGFu5CRSh/1Un+AVnYYsmocV4Uq9LXYm/0xln3/lf+c
         /reAFSfX9Tp4wVDZAhSTGlBc5DiO1BQ8dAOwZ46OJFjEW3MlYp9Lw0rqhSXS6MZ80FaU
         D/AqV65JfgQGgMljvB8Sf3SRA6+8byA3PthXt7uWtHjfj3Lrvp7EYkzcAYB2rpc/oEhw
         vJTRVKKfi/EERm82Cc5tba32kKVNYMRppTvLmuh6uCejdkSeJL6CKA/zPkoEUOk03XMK
         KZHSAwFz/2OjJE8zbeKRHjDxAoyyVAKJB0V7Ey0w8sFVXY27aAwCrfu8vpr0ERscAVUs
         TjUw==
X-Gm-Message-State: AOJu0YzmA13mCC/pc3VVLd7Y5ranww2c9m1VdkRf51YSKoJD7tsW1HzV
	lf++ua8vjqQgLHw4WGDa9hRlg5SevLzJ6OMp27pTPdutZEk4+QwvJSL6oWfRm9L0
X-Gm-Gg: Acq92OHnHHGsnmJ3Wcr3R9FLB5D80tbMDkn5t2eJCMVp0dEOi4Mkyh2bVmFwxSyD/Su
	YLzCAbmf3uiR09OcBTDQ/NxAVR1FlVWjMq45GkQYGWi3C5/YA6jM3H5WL3Z4jo6zK3ygMZzSbRO
	yD8bLToIrIyN8YzzJtgRk4T2jYnQY2B+Hm66HQzf63CvhPboaJW3jQxLOusMVGM2AUg73u4kCgP
	kt08tFF3rKSiB51fbKvuIDSLWllMO7N6Eynz5aEz/BUwAX00zoL08C/ylkO3oBni9edn4bC7pvn
	Z+DdrQcT9GXqHWfN+9Un0H6ncZXhYQMdLQwYUp6DfrCfUjgAEAw/3HpntQfgnMe9MRv+IOrVizq
	Hu+4rFljaztpYm13mOXx7IrOwSx9qd29VrHj6e6ykzXOwrEBbJm1k5LTURiC3kdHfUUTG2e01GZ
	3HQ+eWVBSyvEA1DRq43O/9fH9oJZWn
X-Received: by 2002:a53:d050:0:20b0:65c:7352:7afc with SMTP id 956f58d0204a3-65ec98ea67bmr18535093d50.31.1779897082618;
        Wed, 27 May 2026 08:51:22 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:5b::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65ecfb23889sm7649683d50.4.2026.05.27.08.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 08:51:22 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 0/2] btrfs: skip COW for written extent buffers
Date: Wed, 27 May 2026 08:51:07 -0700
Message-ID: <cover.1779895842.git.loemra.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds an optimization to skip redundant COW operations on
extent buffers that were allocated in the current transaction but
already written back to disk due to memory pressure.

When writeback sets BTRFS_HEADER_FLAG_WRITTEN on a buffer, subsequent
btrfs_search_slot() calls re-COW it unnecessarily -- the committed
superblock doesn't reference blocks from the uncommitted transaction,
so overwriting in place is crash-safe. This COW amplification can
exhaust block reservations and degrade throughput under memory
pressure.

The first patch fixes a latent issue in qgroup snapshot accounting:
qgroup_account_snapshot() calls commit_fs_roots() mid-transaction to
persist root items, but commit_fs_roots() also clears
BTRFS_ROOT_FORCE_COW as a finalization step. This leaves snapshotted
roots in an incorrect state where blocks are shared via
btrfs_copy_root() but FORCE_COW no longer reflects that. This is
currently harmless because WRITTEN buffers are always COW'd, but
becomes a corruption vector once the skip-COW optimization relies on
FORCE_COW to protect shared blocks. The fix extracts the root item
persistence into qgroup_commit_fs_roots(), which does only what
qgroup accounting needs without the finalization side effects.

The second patch adds the skip-COW optimization itself, and was
previously sent and reviewed but reverted due to the qgroup
interaction fixed in patch 1. The code is unchanged from the
reviewed version. When should_cow_block() encounters a WRITTEN
buffer from the current transaction, it re-dirties the buffer and
overwrites in place instead of allocating a new block. FORCE_COW,
EXTENT_BUFFER_WRITEBACK, log trees, zoned devices, and relocation
are all excluded.

Changes since v1:
 - Patch 1: rename qgroup_commit_fs_roots()'s ret to nr since it
   holds the radix lookup count and is never returned. 
   Renamed the inner loop's ret2 to ret accordingly.
 - Patch 1: lift the index advance out of the inner for loop and
   compute it once from gang[nr - 1] after the loop completes, since
   only the final value is consumed by the next radix lookup.

Leo Martins (2):
  btrfs: don't finalize fs roots during qgroup snapshot accounting
  btrfs: skip COW for written extent buffers allocated in current
    transaction

 fs/btrfs/ctree.c       |  83 +++++++++++++++++++++++++-------
 fs/btrfs/disk-io.c     |   2 +-
 fs/btrfs/extent_io.c   |   4 --
 fs/btrfs/transaction.c | 105 +++++++++++++++++++++++++++++------------
 4 files changed, 142 insertions(+), 52 deletions(-)

-- 
2.53.0-Meta

