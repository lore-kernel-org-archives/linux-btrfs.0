Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAB449B21F
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 16:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789143362; cv=none; b=F1yG3vLbPUk8x0kAYz+xI4WR600//r8xhl1cwVB7nA/m46eecQznfIlyiQ9Q3B2W4ItF5e+TsdwcZZBwYkCbXwYIasyrkCDyAqsgBl3k/Bhycs7yRTMSbLAXzYBOmm3pvSNBGSpnT4SeVykVbqZlh9EKZGwXfDOXzu+TD2EYY2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789143362; c=relaxed/simple;
	bh=zz8mnuKmjpH0Gt2LFVGaegM1CKS1x7qu8fdBp0/+75Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=DvkEJV6SGNRR16d259YftXVfcTnZF+pLxqoqYnFtaalLdwcgb8SGCFB6mU5ps3psJ0e9Vtm7AmsddkuOnHZ2oxdAmBZj+MIoJfwB0gA0ae1HItLvQ895mrhoUSfHOvlZR5RMN7UlFM6fe/mXqbCMs7UTZ5EB8WVpn4btNK+kio4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K0kcBoOz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0kcBoOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1FC1F000FF
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 16:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789143360;
	bh=ApPykI903o9lpfYsyLQgBr5lyiKABLDGkh/2IJqV3r0=;
	h=From:To:Subject:Date;
	b=K0kcBoOzKODQdFXSwTVV8iQjjvi6vEHBk/aRbjq8t9BEENSzXAyFDnuH490mbMaUz
	 0acBwpvozi5WWJsgAtnmHTIlvUHbJrrXv29eJrN/JF9OMt0GQVLMsSMjn+yl3S6TWa
	 c64yS/Epr4/ckA5hOKS6aVfBa3fYfKfntxrOjUP/ozGDshspxyxrpztoygRoY0ICp0
	 A7MQTdoJ/XMMOnWzEspTDGK1bVv3YxxIQF1v9mtGfMrXOkFNzGgaroTGqOC4KyjzG0
	 yzRW/+7PDNHtIFjc0i6aiBsvyxOFlkstWz67WZEtxds1jNY8pVQAkXNic7AQumR7Of
	 w/StCGYU55elg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tree-checker: cache accessor return value in CHECK_FE_ALIGNED()
Date: Fri, 11 Sep 2026 17:15:56 +0100
Message-ID: <bfbeb06553e40d94aadfe5490f2749b3e43bc83f.1789143253.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We are calling an accessor for a file extent item multiple times in the
CHECK_FE_ALIGNED() macro, even when we don't find a corruption (once in
the if statement's expression and then once again in the expression for
the return value). This adds extra runtime overhead (which is critical
since the tree checker runs against every extent buffer when it's read
or before persisting it) and increases the module's size.

So cache the accessor's return value in a variable and use it, reducing
runtime, object size and making the source code shorter too. Also avoid
repeating twice the IS_ALIGNED() computation.

Before:

  $ size fs/btrfs/btrfs.ko
     text	   data	    bss	    dec	    hex	filename
  2073340	 217928	  15624	2306892	 23334c	fs/btrfs/btrfs.ko

After:

  $ size fs/btrfs/btrfs.ko
     text	   data	    bss	    dec	    hex	filename
  2073076	 217928	  15624	2306628	 233244	fs/btrfs/btrfs.ko

Also running the following fsstress test and capturing the runtime of
check_extent_data_item() (the only caller of CHECK_FE_ALIGNED()) in
nanoseconds (using bpftrace), showed the following runtime improvements:

Test:

  mkfs.btrfs -f /dev/nullb0
  mount /dev/nullb0 /mnt
  fsstress -w -p 8 -n 5000 -s 12345 -d /mnt
  umount /mnt

Before:

  Count: 2033671
  Range:  0.000 - 1336060.000; Mean: 679.642; Median: 656.000; Stddev: 2031.323
  Percentiles:  90th: 850.000; 95th: 909.000; 99th: 1272.000
     0.000 -    6.647:      11 |
     6.647 -   28.241:      36 |
    28.241 -  110.807:     176 |
   110.807 -  426.512:   38012 #
   426.512 - 1633.663: 1983372 #####################################################
  1633.663 - 6249.399:    8315 |
  6249.399 - 23898.422:   3243 |
  23898.422 - 91382.340:   153 |
  91382.340 - 349418.114:   36 |
  349418.114 - 1336060.000: 11 |

After:

  Count: 2092797
  Range:  0.000 - 1677284.000; Mean: 627.650; Median: 617.000; Stddev: 1848.010
  Percentiles:  90th: 809.000; 95th: 859.000; 99th: 1209.000
     0.000 -    6.823:       18 |
     6.823 -   29.602:       82 |
    29.602 -  118.702:      416 |
   118.702 -  467.232:   515774 #################
   467.232 - 1830.549:  1565599 #####################################################
  1830.549 - 7163.339:     5297 |
  7163.339 - 28023.237:    4186 |
  28023.237 - 109619.427:   166 |
  109619.427 - 428793.471:   25 |
  428793.471 - 1677284.000:   4 |

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-checker.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 857ded43c3b9..081365770c51 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -108,13 +108,14 @@ static void file_extent_err(const struct extent_buffer *eb, int slot,
  */
 #define CHECK_FE_ALIGNED(leaf, slot, fi, name, alignment)		      \
 ({									      \
-	if (unlikely(!IS_ALIGNED(btrfs_file_extent_##name((leaf), (fi)),      \
-				 (alignment))))				      \
+	const u64 val = btrfs_file_extent_##name((leaf), (fi));               \
+	const bool not_aligned = !IS_ALIGNED(val, (alignment));		      \
+									      \
+	if (unlikely(not_aligned))			      		      \
 		file_extent_err((leaf), (slot),				      \
 	"invalid %s for file extent, have %llu, should be aligned to %u",     \
-			(#name), btrfs_file_extent_##name((leaf), (fi)),      \
-			(alignment));					      \
-	(!IS_ALIGNED(btrfs_file_extent_##name((leaf), (fi)), (alignment)));   \
+			(#name), val, (alignment));			      \
+	not_aligned;			                                      \
 })
 
 static u64 file_extent_end(struct extent_buffer *leaf,
-- 
2.47.2

