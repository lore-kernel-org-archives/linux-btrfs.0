Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33687 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752770AbdHWA1M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 20:27:12 -0400
Received: by mail-wm0-f68.google.com with SMTP id q189so723320wmd.0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 17:27:11 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v5 4/6] Btrfs: heuristic add detection of zeroed sample
Date: Wed, 23 Aug 2017 03:26:48 +0300
Message-Id: <20170823002650.3133-5-nefelim4ag@gmail.com>
In-Reply-To: <20170823002650.3133-1-nefelim4ag@gmail.com>
References: <20170823002650.3133-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use memcmp for check sample data to zeroes.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/heuristic.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
index 5336638a3b7c..4557ea1db373 100644
--- a/fs/btrfs/heuristic.c
+++ b/fs/btrfs/heuristic.c
@@ -73,6 +73,21 @@ static struct list_head *heuristic_alloc_workspace(void)
 	return ERR_PTR(-ENOMEM);
 }

+static bool sample_zeroed(struct workspace *workspace)
+{
+	u32 i;
+	u8 zero[READ_SIZE];
+
+	memset(&zero, 0, sizeof(zero));
+
+	for (i = 0; i < workspace->sample_size; i += sizeof(zero)) {
+		if (memcmp(&workspace->sample[i], &zero, sizeof(zero)))
+			return false;
+	}
+
+	return true;
+}
+
 static int heuristic(struct list_head *ws, struct inode *inode,
 		     u64 start, u64 end)
 {
@@ -110,6 +125,9 @@ static int heuristic(struct list_head *ws, struct inode *inode,

 	workspace->sample_size = b;

+	if (sample_zeroed(workspace))
+		return 1;
+
 	memset(workspace->bucket, 0, sizeof(*workspace->bucket)*BUCKET_SIZE);

 	for (a = 0; a < workspace->sample_size; a++) {
--
2.14.1
