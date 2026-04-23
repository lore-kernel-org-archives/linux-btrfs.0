Received: from mail-yw1-f196.google.com (mail-yw1-f196.google.com [209.85.128.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4422A376BD9
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 22:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776984222; cv=none; b=FVXRSyG8RrK6aOhuak4KzS2CWIl8V3ZSJL6GbPYrkoVv/lbjlE4lJlFz7a7QgAc+vi2PNb/axzofWLucrQZvcItSqHlOkWJoCPv/4/koDSsaWCM2CyaqUQ7uBS94dxYB5mMscjOVIS8KbIESepgGPZjE/53Alu7r6bzJC4GCstU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776984222; c=relaxed/simple;
	bh=JUaDyqadwJlOxiIoyuPS/jGTr5Nh6qKrm9/2S/3xbps=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=lxvLXA8rL3p//oDSyxp7Dg9ooAhHEzVLEaj6zcmHNzoCpJOfJ2+pOWe/wn/CMTx74RCePrZzjT8agNgIYw0JMRg1g9r/EREkwaNbxQObw1UyuEbD1//OvG0WhaPnt3S4K31Ux2olY3WKgb+spGtiSA1XuY3NLSPWL4Hx7c8VkUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DQA1l1JS; arc=none smtp.client-ip=209.85.128.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DQA1l1JS"
Received: by mail-yw1-f196.google.com with SMTP id 00721157ae682-799001d73bdso52922087b3.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 15:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776984220; x=1777589020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=xh/0Xyk9BDuq5LfDNEQpOtDu2QNt8MBxsOnOED/IXEs=;
        b=DQA1l1JScj5QE109/1GrA7apgR4ksqySZvQ4CNTKgI8168/PCM8KxjPi9AyV05Zoyi
         smImM7mIW5rFvm/hLjX/slSl22aebIuoMikCL+BwhahFzuYaE8DDbbBr+Fl9aMdUzmqw
         j4sACjeiYKR74/CEstmuRn5aK4wcrS3Ix3XzaHMnEDZGR1fuLtRxcIlsEk9Ak+BGpUu3
         b2mUnDMiZrobOLJkLpkU3TqsCsjqFkG08dBTC0kUiNqgy3RYAYQjmXeJqOLvUIKnlJDv
         orvrkng2pH45g7Is0Bu4Pki2IbajTe/Q8X3J5iVjBffM4wHRqSTEyJNNzXi04cGVjf/+
         FtDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776984220; x=1777589020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xh/0Xyk9BDuq5LfDNEQpOtDu2QNt8MBxsOnOED/IXEs=;
        b=gPR/5gyk/UmoltzA/i126p7y2NSY4bp3O/VEUmwhg1ZdhjqDo60tVcq5n5ou5DveBv
         UC1n94bgcPtP8UWl4XvpXIrQpzN71wOX3xFxXhG+bMIGyID6s+P3M8Cx/KEqJmBnucUs
         HCF/ulJhThqoY9AwZRUAQyJBxs4pErc2Xqeu5YHGhlvOvwI9KwJSSfFt+k0lBP+JAriK
         T4/LM9nMMrGfn0qXfNNcD4vwNwNAc4rvX6M5Gdz+EVPck/J3vWXyKYvFX2ndfyXMogw9
         jEVkXMJSf+EN2gqGYPELgcmlWrrlCrAT7Ks6XRSa47NkdIdaA+QG7Q/L3L5ZPI8/CAh4
         +ZAA==
X-Gm-Message-State: AOJu0YwW44PA+F+Qi4aDpa6Rhji7gquSlD0HQqrXwG1CkmNq0n052sc/
	bK4fsarW/REuUNSwQBT18Yozcfof78QAFP3lAadZD1AdmQ7fkwa6vRwqSudpkFJo
X-Gm-Gg: AeBDiesJfaFwpFO1ij6bnlJnPg+akq2NUNKfCGxiLD31GlK54HAk24/w1UHHppbCymx
	hmvuKWWwOEdieDLqryIu3AaA0lTEJWk7fMqDiCypW7vA2rEJupFPXvG80KWqug4ocw8p780jbkT
	K3RjF5BjMXZaFVvD/a7a83YdjUNw5Kfe/NG/O7XFHr6z+toohIMOOwQC2KE43xQaE0WY1lEZtM4
	t31H0TduSoLJp97gwM/sfAo12fq6cQ6AXTwUmZffXFVhMRDxrWzt5VRL/uqJbCmB+5PLXGqEYUe
	jWYGHhNkfjxPGJT8DXGWbUMDZGJ/zt8wlTK5AmF1ve8m/dqw0GtGIHPP5U1lqd+1aJouY112EX1
	qteIqS0k+QbKqEqC/29DqT1TowEHsKZG9oxrcH+s2K6Um84/kDcwRUSb83VzSVaWvsEIl5YYB12
	FSAFXKmBhhd7XJBxhwkCRBdEcc47g=
X-Received: by 2002:a05:690c:e3c8:b0:7b3:2798:fc93 with SMTP id 00721157ae682-7b9ece695efmr321399017b3.6.1776984219928;
        Thu, 23 Apr 2026 15:43:39 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:2::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bb11264ddbsm23673607b3.30.2026.04.23.15.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 15:43:39 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 0/2] btrfs: skip COW for written extent buffers
Date: Thu, 23 Apr 2026 15:43:32 -0700
Message-ID: <cover.1776899536.git.loemra.dev@gmail.com>
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
2.52.0

