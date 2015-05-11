Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33632 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbbEKH6e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 03:58:34 -0400
Received: by pdbnk13 with SMTP id nk13so140527853pdb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 00:58:34 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Miao Xie <miaoxie@huawei.com>, Philip <bugzilla@philip-seeger.de>,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 2/4] Btrfs: count devices correctly in readahead during RAID 5/6 replace
Date: Mon, 11 May 2015 00:58:13 -0700
Message-Id: <df88483593edb256ae04ac783c0fa75f9b2c55a5.1431330020.git.osandov@osandov.com>
In-Reply-To: <cover.1431330020.git.osandov@osandov.com>
References: <cover.1431330020.git.osandov@osandov.com>
In-Reply-To: <cover.1431330020.git.osandov@osandov.com>
References: <cover.1431330020.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 5fbc7c59fd22 ("Btrfs: fix unfinished readahead thread for raid5/6
degraded mounting") fixed a problem where we would skip a missing device
when we shouldn't have because there are no other mirrors to read from
in RAID 5/6. After commit 2c8cdd6ee4e7 ("Btrfs, replace: write dirty
pages into the replace target device"), the fix doesn't work when we're
doing a missing device replace on RAID 5/6 because the replace device is
counted as a mirror so we're tricked into thinking we can safely skip
the missing device. The fix is to count only the real stripes and decide
based on that.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/reada.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 0e7beea..4645cd1 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -328,6 +328,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	struct btrfs_device *prev_dev;
 	u32 blocksize;
 	u64 length;
+	int real_stripes;
 	int nzones = 0;
 	int i;
 	unsigned long index = logical >> PAGE_CACHE_SHIFT;
@@ -369,7 +370,8 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 		goto error;
 	}
 
-	for (nzones = 0; nzones < bbio->num_stripes; ++nzones) {
+	real_stripes = bbio->num_stripes - bbio->num_tgtdevs;
+	for (nzones = 0; nzones < real_stripes; ++nzones) {
 		struct reada_zone *zone;
 
 		dev = bbio->stripes[nzones].dev;
-- 
2.4.0

