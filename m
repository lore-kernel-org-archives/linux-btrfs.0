Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34388 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754673AbdHYJTO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 05:19:14 -0400
Received: by mail-wr0-f196.google.com with SMTP id y14so257209wrd.1
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 02:19:13 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v7 4/6] Btrfs: heuristic add detection of repeated data patterns
Date: Fri, 25 Aug 2017 12:18:43 +0300
Message-Id: <20170825091845.4120-5-nefelim4ag@gmail.com>
In-Reply-To: <20170825091845.4120-1-nefelim4ag@gmail.com>
References: <20170825091845.4120-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Walk over data sample and use memcmp to detect
repeated data (like zeroed)

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/heuristic.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
index 5192e51ab81e..f1fa6e4f1c11 100644
--- a/fs/btrfs/heuristic.c
+++ b/fs/btrfs/heuristic.c
@@ -66,6 +66,19 @@ static struct list_head *heuristic_alloc_workspace(void)
 	return ERR_PTR(-ENOMEM);
 }

+static bool sample_repeated_patterns(struct workspace *ws)
+{
+	u32 i = 0;
+	u8 *p = ws->sample;
+
+	for (; i < ws->sample_size - READ_SIZE; i += READ_SIZE) {
+		if(memcpy(&p[i], &p[i + READ_SIZE], READ_SIZE))
+			return false;
+	}
+
+	return true;
+}
+
 static int heuristic(struct list_head *ws, struct inode *inode,
 		     u64 start, u64 end)
 {
@@ -115,6 +128,9 @@ static int heuristic(struct list_head *ws, struct inode *inode,

 	workspace->sample_size = b;

+	if (sample_repeated_patterns(workspace))
+		return 1;
+
 	memset(workspace->bucket, 0, sizeof(*workspace->bucket)*BUCKET_SIZE);

 	for (a = 0; a < workspace->sample_size; a++) {
--
2.14.1
