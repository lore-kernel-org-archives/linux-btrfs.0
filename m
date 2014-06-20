Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965546AbaFTKHS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 06:07:18 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/2] btrfs: use E2BIG instead of EIO if compression does not help
Date: Fri, 20 Jun 2014 12:07:14 +0200
Message-Id: <b934864cc8b08eb358748b06468b9cca64026c1e.1403258477.git.dsterba@suse.cz>
In-Reply-To: <cover.1403258476.git.dsterba@suse.cz>
References: <cover.1403258476.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Return codes got updated in 60e1975acb48fc3d74a3422b21dde74c977ac3d5
(btrfs: return errno instead of -1 from compression)
lzo wrapper returns E2BIG in this case, do the same for zlib.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/zlib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 4f196314c0c1..b67d8fc81277 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -136,7 +136,7 @@ static int zlib_compress_pages(struct list_head *ws,
 		if (workspace->def_strm.total_in > 8192 &&
 		    workspace->def_strm.total_in <
 		    workspace->def_strm.total_out) {
-			ret = -EIO;
+			ret = -E2BIG;
 			goto out;
 		}
 		/* we need another page for writing out.  Test this
-- 
1.7.9

