Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42414 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaLLTaG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 14:30:06 -0500
Date: Fri, 12 Dec 2014 22:30:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>, Miao Xie <miaox@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] Btrfs, scrub: uninitialized variable in
 scrub_extent_for_parity()
Message-ID: <20141212193000.GC22234@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The only way that "ret" is set is when we call scrub_pages_for_parity()
so the skip to "if (ret) " test doesn't make sense and causes a static
checker warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker work.  Not tested.  There are some other valid looking
warnings from the same file:

fs/btrfs/scrub.c:2933 scrub_raid56_parity() warn: XXX passing uninitialized 'extent_physical'
fs/btrfs/scrub.c:2933 scrub_raid56_parity() warn: XXX passing uninitialized 'extent_dev'
fs/btrfs/scrub.c:2933 scrub_raid56_parity() warn: XXX passing uninitialized 'extent_mirror_num'

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f2bb13a..9e1569f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2607,9 +2607,9 @@ static int scrub_extent_for_parity(struct scrub_parity *sparity,
 		ret = scrub_pages_for_parity(sparity, logical, l, physical, dev,
 					     flags, gen, mirror_num,
 					     have_csum ? csum : NULL);
-skip:
 		if (ret)
 			return ret;
+skip:
 		len -= l;
 		logical += l;
 		physical += l;
