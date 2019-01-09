Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826D6C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51E2720821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cvfh3DJP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbfAIB23 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:28:29 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41087 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729645AbfAIB1p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:45 -0500
Received: by mail-wr1-f65.google.com with SMTP id x10so5984472wrs.8;
        Tue, 08 Jan 2019 17:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q47fy5loRUVHIb1UHgPKU7qjSvOh44KxpjwL74IynKk=;
        b=Cvfh3DJP6og4ubbL0MrP2lOwA5Ojygy7cKT6XOfRGum6aX5ZGAOFr0GYRASnzh2mVf
         Kmz2lJthhLXOp4odt+TCFd2+RcwAtxIdc96ZClDspg1BVtzauAeLzluXZ8kRhnJrXjB1
         DCZLr9MaTUYBsD9yhtNZ+OXAg2zNiFE5JsR7iHrC0Xwo3ksZIBkGOQFdXuS1vm5/HZkT
         eb2YcINixiWZDRDMTCBUmkOrKcEhErbs85bMRMo7lg+vwQFf4wAcHYtXOe5BAiY5iw/1
         vhu3xlfKpTtCYRa5uWGwt8mAIZQ9vk11dck30Sr0g8gnj5dX6q5rnr/3opd6NfqTJmB3
         Ryjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=q47fy5loRUVHIb1UHgPKU7qjSvOh44KxpjwL74IynKk=;
        b=qhLVl4ZZK7Bv5JwLIsjIZ6UnkPTzThY81QyXNCQFQSLKPDlemCJqAPZOdBscYSnVLp
         3R7ifGz2YZFBpw2/OdIVboH+wCPxfjDNZExYbK9ltx2k+6ezjP8IxNf/2NGTmuZJRCla
         7eSWqjOw0KEsg0yzTbp/AtkaCaVP7hgTIuG2y5hkYZSY7AC31orxqOQW9egtmUI9Zt2v
         c4BanmVohaDUwhbZNEHMxzl95WnCTN461wm3Hwazl+vt6NSH57/f174AR8i3QtAcJ35R
         WC7WkiAzhrPLUsuMN5VYQpFV4ieU52eRgja47fqLVMiXKeHsY3CYY25roGHXAPh9S53+
         pJQw==
X-Gm-Message-State: AJcUukdnIwIDjxxskeG4I+eHGhGSkwG1fKweU8bOfG+XGICyor0SEC4v
        7hCt/rYtTsVAekbVdEIgk8E=
X-Google-Smtp-Source: ALg8bN5s/ohTNw+oR0dgolB6dsAunyf6w2gb6WAubFQf8w56MSYcEssRcD5W6EzWLunvLQ6jj29cKw==
X-Received: by 2002:a5d:6889:: with SMTP id h9mr3090108wru.222.1546997264067;
        Tue, 08 Jan 2019 17:27:44 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:43 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 14/19] btrfs: allow reading compressed encrypted extents
Date:   Wed,  9 Jan 2019 01:26:56 +0000
Message-Id: <20190109012701.26441-14-mark@harmstone.com>
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
 fs/btrfs/compression.c | 22 ++++++++++++++++++++++
 fs/btrfs/compression.h |  7 +++++++
 2 files changed, 29 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 2955a4ea2fa8..55d7b97a7dc9 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -26,6 +26,7 @@
 #include "compression.h"
 #include "extent_io.h"
 #include "extent_map.h"
+#include "encryption.h"
 
 static const char* const btrfs_compress_types[] = { "", "zlib", "lzo", "zstd" };
 
@@ -139,6 +140,20 @@ static void end_compressed_bio_read(struct bio *bio)
 	if (ret)
 		goto csum_failed;
 
+	if (cb->key_number != 0) {
+		struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+		unsigned int i;
+
+		for (i = 0; i < cb->nr_pages; i++) {
+			ret = btrfs_decrypt_page(fs_info,
+				cb->compressed_pages[i], cb->key_number,
+				cb->iv);
+
+			if (ret)
+				goto csum_failed;
+		}
+	}
+
 	/* ok, we're the last bio for this extent, lets start
 	 * the decompression.
 	 */
@@ -568,6 +583,13 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	em_len = em->len;
 	em_start = em->start;
 
+	if (em->encrypt_type == BTRFS_ENCRYPTION_NONE) {
+		cb->key_number = 0;
+	} else {
+		cb->key_number = em->key_number;
+		memcpy(cb->iv, em->iv, BTRFS_ENCRYPTION_BLOCK_LENGTH);
+	}
+
 	free_extent_map(em);
 	em = NULL;
 
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index ddda9b80bf20..86a536d8cd5f 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -7,6 +7,7 @@
 #define BTRFS_COMPRESSION_H
 
 #include <linux/sizes.h>
+#include <linux/btrfs_tree.h>
 
 /*
  * We want to make sure that amount of RAM required to uncompress an extent is
@@ -54,6 +55,12 @@ struct compressed_bio {
 	int errors;
 	int mirror_num;
 
+	/* encryption key number */
+	u64 key_number;
+
+	/* encryption initialization vector */
+	char iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
+
 	/* for reads, this is the bio we are copying the data into */
 	struct bio *orig_bio;
 
-- 
2.19.2

