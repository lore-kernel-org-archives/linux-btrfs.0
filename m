Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20478C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E28EB20821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:27:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OUngulBf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbfAIB1i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:27:38 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34917 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729463AbfAIB1g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:36 -0500
Received: by mail-wm1-f68.google.com with SMTP id t200so6440904wmt.0;
        Tue, 08 Jan 2019 17:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zaj8p7dWOpYuNmAgNlGZxQGCYKdm5qJGNKPeUOcGX+A=;
        b=OUngulBfffIWi1kkORp/ATAXx680ggpTyT63mtB7gsf9Kcdu4jb6l70CKS+NjwhMu1
         SwlqbRr2kz7lNqfAHw2kBakRrHC9X/a//BFz3y0F0SP0lAhabGjka/qskuYthtKZH+5K
         YrxvxhENhoLvpSZOF2SUXClrnQLT5Em+TvYM2yJLZse88EzDuY2kMk1HLTVWRz19Cc42
         0E33RW3Gw9t/lO4tpYonWnELmSgYqfr1gEVutfdoZ1TRYs7Oyeu77l49eTLRF6ujdfze
         tg70KrNK14B5mEDRmPxXH7jxZu8Fn2PEzMnpdB8cuL7RQsrHbqkXg4fD3kIhx5ZNUV8p
         WhsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Zaj8p7dWOpYuNmAgNlGZxQGCYKdm5qJGNKPeUOcGX+A=;
        b=NTkBcEO9CNSVbGQRYNfEoQB70VFc2rND4rBn/CnD5ZkRd/Kv2v2eVQ0v9MuQY+FSnH
         ciGnCZ0z/ezETzc5ayzO/z7jG7prCdoyRBJUvLMHvo2iIUqz7oBT9WQAfdxKlNiZfHua
         wwYw732RUe3siR9//zNJ8r2pWzmwt44a69BbMxRVHfH1udV6D8DE/qP3uCn67+bLTChg
         NqcZTB/KmZtxgxkXo+zTM3XDav2IWOamn5sZcmVTCdso/IU2LKGhjg6+gApJf6FtJlHD
         QaYk9sntktUh/5PYe8MTxfrPHkePRtaHjV48cD2qy+Up+LQdAlJntGkJecZqt8DNnwga
         sIFg==
X-Gm-Message-State: AJcUukdqv6z0Xjt5ampa7RHneeV1ajKbfbcGKdEeCWwjfG4aRbGDftyb
        WQoI4j3TvqMchtv/xl3PH9s=
X-Google-Smtp-Source: ALg8bN4huJ9ulJUr/KPX/D4hi7Q2EC6RJAZyL+guUezNZnGAxM4YoLQ99gHl2mm9P5IVI0Y4W57IBA==
X-Received: by 2002:a1c:63d5:: with SMTP id x204mr3421255wmb.137.1546997254465;
        Tue, 08 Jan 2019 17:27:34 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:33 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 08/19] btrfs: change extract in prop_handler to write into string
Date:   Wed,  9 Jan 2019 01:26:50 +0000
Message-Id: <20190109012701.26441-8-mark@harmstone.com>
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
 fs/btrfs/props.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index dc6140013ae8..e57a4edc88c4 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -19,7 +19,7 @@ struct prop_handler {
 	const char *xattr_name;
 	int (*validate)(const char *value, size_t len);
 	int (*apply)(struct inode *inode, const char *value, size_t len);
-	const char *(*extract)(struct inode *inode);
+	int (*extract)(struct inode *inode, char *value);
 	int inheritable;
 };
 
@@ -27,7 +27,7 @@ static int prop_compression_validate(const char *value, size_t len);
 static int prop_compression_apply(struct inode *inode,
 				  const char *value,
 				  size_t len);
-static const char *prop_compression_extract(struct inode *inode);
+static int prop_compression_extract(struct inode *inode, char *value);
 
 static struct prop_handler prop_handlers[] = {
 	{
@@ -298,14 +298,14 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 
 	for (i = 0; i < ARRAY_SIZE(prop_handlers); i++) {
 		const struct prop_handler *h = &prop_handlers[i];
-		const char *value;
+		char value[64];
 		u64 num_bytes;
 
 		if (!h->inheritable)
 			continue;
 
-		value = h->extract(parent);
-		if (!value)
+		ret = h->extract(parent, value);
+		if (ret)
 			continue;
 
 		num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
@@ -410,18 +410,29 @@ static int prop_compression_apply(struct inode *inode,
 	return 0;
 }
 
-static const char *prop_compression_extract(struct inode *inode)
+static int prop_compression_extract(struct inode *inode, char *value)
 {
 	switch (BTRFS_I(inode)->prop_compress) {
 	case BTRFS_COMPRESS_ZLIB:
 	case BTRFS_COMPRESS_LZO:
 	case BTRFS_COMPRESS_ZSTD:
-		return btrfs_compress_type2str(BTRFS_I(inode)->prop_compress);
+	{
+		const char *v;
+
+		v = btrfs_compress_type2str(BTRFS_I(inode)->prop_compress);
+
+		if (!v)
+			return -EINVAL;
+
+		strcpy(value, v);
+
+		return 0;
+	}
 	default:
 		break;
 	}
 
-	return NULL;
+	return -EINVAL;
 }
 
 
-- 
2.19.2

