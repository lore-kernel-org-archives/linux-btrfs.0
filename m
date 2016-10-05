Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:50988 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753070AbcJEITk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Oct 2016 04:19:40 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 70283AC0132
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Oct 2016 17:08:18 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
        by m3051.s.css.fujitsu.com (Postfix) with SMTP id 50AB42C3
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Oct 2016 17:08:18 +0900 (JST)
Message-Id: <201610050807.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 05 Oct 2016 17:07:48 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: image: fix compiler warning
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In v4.8-rc1, gcc 5.3.1 gives following warning. Fixed it.

    [CC]     btrfs-image.o
btrfs-image.c: In function 'flush_pending':
btrfs-image.c:708:17: warning: 'start' may be used uninitialized in this function [-Wmaybe-uninitialized]
  header->bytenr = cpu_to_le64(start);
                 ^
btrfs-image.c:927:6: note: 'start' was declared here
  u64 start;
      ^

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 btrfs-image.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 0d410f8..47f36b9 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -924,7 +924,7 @@ static int flush_pending(struct metadump_struct *md, int done)
 	struct async_work *async = NULL;
 	struct extent_buffer *eb;
 	u64 blocksize = md->root->nodesize;
-	u64 start;
+	u64 start = 0;
 	u64 size;
 	size_t offset;
 	int ret = 0;
-- 
2.9.3

----
Tsutomu Itoh  t-itoh@jp.fujitsu.com
