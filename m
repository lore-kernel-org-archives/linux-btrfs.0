Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723B9C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35AB220821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:27:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WB+t9fv+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbfAIB1a (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:27:30 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39408 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729371AbfAIB13 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:29 -0500
Received: by mail-wm1-f68.google.com with SMTP id f81so6379280wmd.4;
        Tue, 08 Jan 2019 17:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zGgS84Gq9+9EStzwMBoxhU5dGRyEV00d97dwEE1ZdMg=;
        b=WB+t9fv+YlrqOvvDzgz019sLEI8mcP8YwQjkecen9cjXu3r6CK75J41rWJY3P5hKTe
         A3xgLtaYxDH6FJ+9kG2BoOtgihFAHXStlK4ukYljLwfAXhBskQflf7MZsp5RxkQ0c3Gh
         n5f7SGb9N1HsiCF9tKcCfBvzIxzA2SxDGud5i74gyrQrr1Te4yhxvYli2wXhAlRICfa/
         6VNepT4msxX3GyVtlvKcvTaDQZdZs+X4yEnT1fXIsJM95Ak3Gu+jOE1ByjmKZEWg/Dwm
         94DCfwPriXzsdow2BWU5RbFN5+bgEH1gXfeu054cgqF9H12bc0QdD9j53lllhpeaA6Cq
         0b+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=zGgS84Gq9+9EStzwMBoxhU5dGRyEV00d97dwEE1ZdMg=;
        b=W0aU3HQ3sUuKYleG2MfqvKEp1Xa+IqcwNc0jXcuvUpTpq18HvacDjZpIAcKY+Bnj60
         R/y/b9OK9+U3cMLXwU3hzrx8k7TmhFWoMy3+7yiohhQTgxi0XJJfjrkgTQio87wLhdju
         rir1n4NRu/IEYMavPEQY4ufIxWEG6pHh7Q3vZK854yImdyUQmPWYgrezn6rd+CGzuFFE
         owmHiIVtHlgk3pVrVvM1kzcj4icH2LdLipVNPWGjAChgE0qTCHrLLCVymjv4OWfubB1y
         IALXkfgw2fgGIrnGUFeTnQ/L21MdFADPOQn7G5kwEhlIK4ecbPbNxKMEKt4P7PSfeB5/
         FH+g==
X-Gm-Message-State: AJcUukfQaOD1M6cXNmIuUOsS3L4o9hFwjBJWVGbYDleqe0pWZthCG/v9
        mND1YodCMbg9bkerPbJgysOu3a7R9lI=
X-Google-Smtp-Source: ALg8bN4ttWSzysDgRvmxrndF27TePBgU2SbZOlwl2S6lxu/aETpgr4syZ464A9mzxHulBJVBBYKArg==
X-Received: by 2002:a7b:c442:: with SMTP id l2mr3498003wmi.140.1546997247107;
        Tue, 08 Jan 2019 17:27:27 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:26 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 04/19] btrfs: allow encrypted volumes to be mounted
Date:   Wed,  9 Jan 2019 01:26:46 +0000
Message-Id: <20190109012701.26441-4-mark@harmstone.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190109012701.26441-1-mark@harmstone.com>
References: <20190109012701.26441-1-mark@harmstone.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/ctree.h        |  3 ++-
 fs/btrfs/encryption.h   | 20 ++++++++++++++++++++
 fs/btrfs/tree-checker.c | 39 +++++++++++++++++++++++++++++----------
 3 files changed, 51 insertions(+), 11 deletions(-)
 create mode 100644 fs/btrfs/encryption.h

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bd2e59dd0eba..723e9b38e0aa 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -265,7 +265,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
+	 BTRFS_FEATURE_INCOMPAT_ENCRYPTION)
 
 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
 	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
diff --git a/fs/btrfs/encryption.h b/fs/btrfs/encryption.h
new file mode 100644
index 000000000000..b9a37e76e4a6
--- /dev/null
+++ b/fs/btrfs/encryption.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Mark Harmstone.  All rights reserved.
+ */
+
+#ifndef BTRFS_ENCRYPTION_H
+#define BTRFS_ENCRYPTION_H
+
+enum btrfs_encryption_type {
+	BTRFS_ENCRYPTION_NONE       = 0,
+	BTRFS_ENCRYPTION_AES256CTR  = 1,
+	BTRFS_ENCRYPTION_TYPES      = 1,
+};
+
+struct btrfs_encryption_header {
+	u64 key_number;
+	u8 iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
+};
+
+#endif
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 1a4e2b101ef2..c4fe1cb65d73 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -20,6 +20,7 @@
 #include "disk-io.h"
 #include "compression.h"
 #include "volumes.h"
+#include "encryption.h"
 
 /*
  * Error message should follow the following format:
@@ -140,10 +141,11 @@ static int check_extent_data_item(struct btrfs_fs_info *fs_info,
 			BTRFS_COMPRESS_TYPES);
 		return -EUCLEAN;
 	}
-	if (btrfs_file_extent_encryption(leaf, fi)) {
+	if (btrfs_file_extent_encryption(leaf, fi) > BTRFS_ENCRYPTION_TYPES) {
 		file_extent_err(fs_info, leaf, slot,
-			"invalid encryption for file extent, have %u expect 0",
-			btrfs_file_extent_encryption(leaf, fi));
+	"invalid encryption for file extent, have %u expect range [0, %u]",
+			btrfs_file_extent_encryption(leaf, fi),
+			BTRFS_ENCRYPTION_TYPES);
 		return -EUCLEAN;
 	}
 	if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
@@ -155,9 +157,14 @@ static int check_extent_data_item(struct btrfs_fs_info *fs_info,
 			return -EUCLEAN;
 		}
 
-		/* Compressed inline extent has no on-disk size, skip it */
+		/*
+		 * Compressed or encrypted inline extent has no on-disk size,
+		 * skip it
+		 */
 		if (btrfs_file_extent_compression(leaf, fi) !=
-		    BTRFS_COMPRESS_NONE)
+			BTRFS_COMPRESS_NONE ||
+			btrfs_file_extent_encryption(leaf, fi) !=
+			BTRFS_ENCRYPTION_NONE)
 			return 0;
 
 		/* Uncompressed inline extent size must match item size */
@@ -172,13 +179,25 @@ static int check_extent_data_item(struct btrfs_fs_info *fs_info,
 		return 0;
 	}
 
-	/* Regular or preallocated extent has fixed item size */
-	if (item_size != sizeof(*fi)) {
-		file_extent_err(fs_info, leaf, slot,
+	if (btrfs_file_extent_encryption(leaf, fi) == BTRFS_ENCRYPTION_NONE) {
+		/* Regular or preallocated extent has fixed item size */
+		if (item_size != sizeof(*fi)) {
+			file_extent_err(fs_info, leaf, slot,
 	"invalid item size for reg/prealloc file extent, have %u expect %zu",
-			item_size, sizeof(*fi));
-		return -EUCLEAN;
+				item_size, sizeof(*fi));
+			return -EUCLEAN;
+		}
+	} else {
+		if (item_size !=
+			sizeof(*fi) + sizeof(struct btrfs_encryption_header)) {
+			file_extent_err(fs_info, leaf, slot,
+	"invalid item size for encrypted file extent, have %u expect %zu",
+			  item_size,
+			  sizeof(*fi) + sizeof(struct btrfs_encryption_header));
+			return -EUCLEAN;
+		}
 	}
+
 	if (CHECK_FE_ALIGNED(fs_info, leaf, slot, fi, ram_bytes, sectorsize) ||
 	    CHECK_FE_ALIGNED(fs_info, leaf, slot, fi, disk_bytenr, sectorsize) ||
 	    CHECK_FE_ALIGNED(fs_info, leaf, slot, fi, disk_num_bytes, sectorsize) ||
-- 
2.19.2

