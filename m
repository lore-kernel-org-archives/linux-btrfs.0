Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38226 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbdHWWqB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 18:46:01 -0400
Received: by mail-wm0-f68.google.com with SMTP id a70so936118wmd.5
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 15:46:00 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v6 4/6] Btrfs: heuristic add detection of repeated data patterns
Date: Thu, 24 Aug 2017 01:45:43 +0300
Message-Id: <20170823224545.16375-5-nefelim4ag@gmail.com>
In-Reply-To: <20170823224545.16375-1-nefelim4ag@gmail.com>
References: <20170823224545.16375-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Walk over data sample and use memcmp to detect
repeated data (like zeroed)

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/heuristic.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
index 001118f98143..8df56ea93064 100644
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
@@ -118,6 +131,9 @@ static int heuristic(struct list_head *ws, struct inode *inode,

 	workspace->sample_size = b;

+	if (sample_repeated_patterns(workspace))
+		return 1;
+
 	memset(workspace->bucket, 0, sizeof(*workspace->bucket)*BUCKET_SIZE);

 	for (a = 0; a < workspace->sample_size; a++) {
--
2.14.1
