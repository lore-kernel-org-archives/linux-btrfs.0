Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44012 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaISItH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 04:49:07 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id ED93C3EE113
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 17:49:05 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 1A14DAC09A9
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 17:49:05 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 5BE1C1DB8047
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 17:49:04 +0900 (JST)
Message-ID: <541BEDF8.7010009@jp.fujitsu.com>
Date: Fri, 19 Sep 2014 17:48:56 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/4] btrfs: introduce new compression property to disable
 compression at all
References: <541BED3D.5020803@jp.fujitsu.com>
In-Reply-To: <541BED3D.5020803@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Naohiro Aota <naota@elisp.net>

This new compression property, "off", to disable compression of
the file at all.

Signed-off-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 fs/btrfs/props.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index bf005f4..38efbe1 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -382,6 +382,8 @@ static int prop_compression_validate(const char *value, size_t len)
 		return 0;
 	else if (!strncmp("zlib", value, len))
 		return 0;
+	else if (!strncmp("off", value, len))
+		return 0;
 
 	return -EINVAL;
 }
@@ -400,6 +402,14 @@ static int prop_compression_apply(struct inode *inode,
 		return 0;
 	}
 
+	if (!strncmp("off", value, len)) {
+		BTRFS_I(inode)->flags |= BTRFS_INODE_NOCOMPRESS;
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_COMPRESS;
+		BTRFS_I(inode)->force_compress = BTRFS_COMPRESS_NONE;
+
+		return 0;
+	}
+
 	if (!strncmp("lzo", value, len))
 		type = BTRFS_COMPRESS_LZO;
 	else if (!strncmp("zlib", value, len))
@@ -423,5 +433,8 @@ static const char *prop_compression_extract(struct inode *inode)
 		return "lzo";
 	}
 
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
+		return "off";
+
 	return NULL;
 }
-- 1.8.3.1 

