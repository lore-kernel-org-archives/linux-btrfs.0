Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cheri.shyou.org ([74.208.174.96]:45454 "EHLO cheri.shyou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbbADD7K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Jan 2015 22:59:10 -0500
Received: from localhost (localhost [127.0.0.1])
	by cheri.shyou.org (Postfix) with ESMTP id EB3191303E0
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Jan 2015 22:49:29 -0500 (EST)
Received: from cheri.shyou.org ([127.0.0.1])
	by localhost (cheri.shyou.org [127.0.0.1]) (amavisd-new, port 10026)
	with LMTP id OEMHMh0KzmW4 for <linux-btrfs@vger.kernel.org>;
	Sat,  3 Jan 2015 22:49:27 -0500 (EST)
Date: Sat, 3 Jan 2015 22:49:27 -0500 (EST)
From: Danielle Church <dchurch@cheri.shyou.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: do not flush zlib buffer after every input page
In-Reply-To: <alpine.LNX.2.00.1501032236270.30995@cheri.shyou.org>
Message-ID: <alpine.LNX.2.00.1501032237360.30995@cheri.shyou.org>
References: <alpine.LNX.2.00.1501032236270.30995@cheri.shyou.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Moving the Z_FINISH into the loop also means we don't have to force a 
flush after every input page to guarantee that there won't be more than 4 
KiB to write at the end.  This patch lets zlib decide when to flush 
buffer, which offers a very moderate space savings (on my system, my 400MB 
test logfile goes from an 11.9% compression ratio to 11.2%, which is 
nothing to write home about) and might offer a similarly-slight 
performance boost.

Since the end result is still a valid zlib stream, it is completely 
backwards-compatible with the existing method.

Signed-off-by: Danielle Church <dchurch@cheri.shyou.org>
---
  fs/btrfs/zlib.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 1dc0455..df7d957 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -89,7 +89,7 @@ static int zlib_compress_pages(struct list_head *ws,
  	struct page *in_page = NULL;
  	struct page *out_page = NULL;
  	unsigned long bytes_left;
-	int deflate_flush = Z_SYNC_FLUSH;
+	int deflate_flush = Z_NO_FLUSH;

  	*out_pages = 0;
  	*total_out = 0;
-- 
2.2.1
