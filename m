Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37707282F15
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 02:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786932949; cv=none; b=B9+7NJJxkqkhUksQeBvhzWTSUdm4wGVh15lXRMwEdh98UtRbpPPzdLecAp2igWD+qNxU9Axc7yEKt8B+oyTL3zDBlUWlVpj0fCRHUF9cHXm8HA9j5gVE8wEcm7luZjebXo+wPoXSDfUbW43dCp0bOdeI56DnljZ3gQ2YMfJklZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786932949; c=relaxed/simple;
	bh=Q7VEEYC3Vx/rZ+6Z0y7lNBsNBzKQtd+Fo8kHdjcP2LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzOZ/j1rxRP/GL22GK/r7rGNkpzG0GMx5QzXHKR68gntqixmjYJVdHzQLWc5iC/nO9U4oyhQ1/hun/2v+yiWx2id0c84n/wUuwF1HYci8WqUmK8h7tioVG4usXC3PBzYTPgya+op2/tSGcnfi/5i4u7o08b8SKiScGE9ff43ozU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LonEef/B; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LonEef/B"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8efbafa1bacso15049776d6.1
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Aug 2026 19:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786932947; x=1787537747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BMwtLhfF7eGaRL2jkfy7ArtsmZ+sXPQ/z21g6BOb5X8=;
        b=LonEef/B3Ir+fIXg0+E0NoDgYo92dPDlDvivk1j6kko/nfezXI8aHD9luP+D2zsYf8
         u70xtsAM90Wtfa3s8gvsb+UQKqp+bMZ57h6Y2NfTTs76aZ+BAVyPFBmp4siu91GpGPth
         uZXgN6v610/PX+iaFYx0rQNvXkdw5iEHVf4p+cmkvP0CAtHxQghBkidSZT0PK20wDuSd
         EMvSu4jPvh/lwctgNxq00wmifyBrV/d9pnKQH7uTBiZDQWKzG6/Pe1f0pX6Mak+4W9QQ
         U2ybeCc/xOQtzEbDCt+h9lc4pzJXsg340W8id2A/hFHTmIKpy4nvflPIxjhhZzklocxY
         fr7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786932947; x=1787537747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BMwtLhfF7eGaRL2jkfy7ArtsmZ+sXPQ/z21g6BOb5X8=;
        b=gVz0jln+k6D5Fj5x+K1HfBL3hP2/u7ApRT1kaVOH4QhV2SoOXVWWbtyN/eIBrJP/pr
         aWEWf8sXKHQGutEUgfFsZui/GnQ+oewxNR1IXLOQ8AkGfYg5hgRAVSma69Y1Fdk7Kj9b
         GvfCwO2o5e5V5Rv763Hyzf1IZh6tzSZZtDwveJEVfEEvVz6V8IXvL5wiYQeqnzdMWseZ
         mhD7AHw2+6L/3oQ24b+Q7SXR48X8Hmw05vckUw/yekanPxZLehBV+3dZgGCioNxViIdc
         9Di7EgIcbfOM7AobEEzE9gm31mk/uXS9Yv60AFKow3O75Moqnvyi4FineC+7Py2m2X/5
         t8lw==
X-Gm-Message-State: AOJu0Yzo0KjnHdKbkmSOa+DONjME9k1qT8Dy8B4WqitVBfseXvbsYJ9J
	7vE/qXM2mMQ2kldPtx182GpG4aDYXVe9xnSurd0j7nDIG3GzFY9gHWwpqifl6q39
X-Gm-Gg: AR+sD13AVVyiUaaguxNRxwnPwvcL/PEF0AL3059Qb1ut0vTw3F92yIzUQ+2iBPoNiza
	QvpUdmndCl1NS6ftEYv5eDImLWsMBMT9mRn7+Pd9Wf3yvRNSTHl2UX89iwrURAzgSnEZV3hABH/
	7aVGtI1plwjlUZKFKuJYjMcbGrBAd6sHOg4szLI5t0TM6DwOj+4e/+ZO/HVD8xb617HV5eAldl6
	0VqmdeJ7saRxnzup2epm7a/bbdKS/cIZ8CeyB+gFW8WPSMMMgeQjJDIXr93HbL8X/2FkOjKHVqD
	5xSvyertv+Ccy92zioc/+dEKzanGFgKJIylw5nshKFaDZ2WLHsBVdIJi410aiFFfMheVNImaRrl
	dUbbXBXKf7++5Vt8+gE7iN6FJpIvl3kBSc7K0DEn8joAQ7YzDjFZ5QCKNVH9tq3hZQVRQ3TcbLo
	kH2Ya+G7e9vI5xowFMKVSKx6MTojd29OX2QbthzNBtncXJV5NP3qEnYPpJ7SqXtXuoRBWq4CPIO
	NHfjn3WKqwd1qvf7w==
X-Received: by 2002:a05:6214:4281:b0:90a:3291:7ba3 with SMTP id 6a1803df08f44-90a91c5c3d4mr258485556d6.5.1786932947088;
        Sun, 16 Aug 2026 19:15:47 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a921e4f43sm72999066d6.9.2026.08.16.19.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 19:15:46 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	wqu@suse.com
Subject: [PATCH v2] btrfs: fix transaction use-after-free in raid stripe insertion
Date: Sun, 16 Aug 2026 22:15:12 -0400
Message-ID: <20260817021512.3010812-1-shuangpeng.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260817012733.2962781-1-shuangpeng.kernel@gmail.com>
References: <20260817012733.2962781-1-shuangpeng.kernel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If allocation of a RAID stripe extent fails,
btrfs_insert_one_raid_extent() aborts and ends the transaction before
returning -ENOMEM.

btrfs_finish_one_ordered(), the production caller through
btrfs_insert_raid_extent(), still owns the transaction handle. It handles
the error by aborting the transaction and then reaches the common exit
path, which ends the transaction again.

The premature end can free the handle and drop its transaction reference.
Transaction cleanup can then free the transaction before the caller's
second abort accesses the handle and transaction, resulting in
use-after-free.

Keep the abort at the failure site, but let the caller's common exit path
end the transaction once, after it has finished using both objects.

Fixes: 02c372e1f016 ("btrfs: add support for inserting raid stripe extents")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
---
Changes in v2:
- Add the Assisted-by tag to disclose LLM usage.

v1: https://lore.kernel.org/r/20260817012733.2962781-1-shuangpeng.kernel@gmail.com

 fs/btrfs/raid-stripe-tree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index b210371ce91e..89e259a47d8d 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -337,7 +337,6 @@ int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
 	stripe_extent = kzalloc(item_size, GFP_NOFS);
 	if (unlikely(!stripe_extent)) {
 		btrfs_abort_transaction(trans, -ENOMEM);
-		btrfs_end_transaction(trans);
 		return -ENOMEM;
 	}
 
-- 
2.43.0
