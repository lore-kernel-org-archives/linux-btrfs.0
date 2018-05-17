Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56927 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752489AbeEQG2V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 02:28:21 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: jamespharvey20@gmail.com
Subject: [PATCH 4/4] btrfs: lzo: Hardern inline lzo compressed extent decompression
Date: Thu, 17 May 2018 14:27:53 +0800
Message-Id: <20180517062753.25973-5-wqu@suse.com>
In-Reply-To: <20180517062753.25973-1-wqu@suse.com>
References: <20180517062753.25973-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unlike regular lzo compressed extent, inline extent doesn't have Header
and only has one Segment.
And further more, inlined extent always has csum in its leaf header,
it's less possible to have corrupted data.

Anyway, still add extra segment header length check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/lzo.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 78ebc809072f..077851a9f498 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -425,6 +425,7 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	size_t in_len;
 	size_t out_len;
+	size_t max_segment_len = lzo1x_worst_compress(PAGE_SIZE);
 	int ret = 0;
 	char *kaddr;
 	unsigned long bytes;
@@ -434,6 +435,10 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	data_in += LZO_LEN;
 
 	in_len = read_compress_length(data_in);
+	if (in_len > max_segment_len) {
+		ret = -EUCLEAN;
+		goto out;
+	}
 	data_in += LZO_LEN;
 
 	out_len = PAGE_SIZE;
-- 
2.17.0

