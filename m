Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5849FC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BF9220821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:29:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="txthAS24"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbfAIB27 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:28:59 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:47031 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729526AbfAIB1h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:37 -0500
Received: by mail-wr1-f65.google.com with SMTP id l9so5962068wrt.13;
        Tue, 08 Jan 2019 17:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fAGKYpUHFH6IxKnG66w6623xEKHssEriDLH5eETIzro=;
        b=txthAS24negzhm6/1RtYgmjDoc5S0LFxg8jvDWyj0fduYF6Q/81nOOzdAIWinNJs0L
         D9VIbHJ4Fl0+AMYaWF+HWnyku3c5MwcLZEwy6Tjo8WLuW8w9M3L4PVS+ZJN3dDBclgre
         MW3FsH8QROr37g6tVi3BxGsmeEiZG/fnhBb1+KUumfAhsL3sJowskHZN8H6L/ABBcoYq
         N0EfXVJP5vV1Jhs1m2PeadXfI2Aq96HWQJhyV5VmLUdHpazPz6xmMcgieCRpt1emah34
         /Qwha2xzui+VaXkG8SX40Dr7djEENVK5FcFdKw5CWsp4wbJrcSC7gyQtpjAoDpzFyJsz
         9H1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=fAGKYpUHFH6IxKnG66w6623xEKHssEriDLH5eETIzro=;
        b=tBdKB6n54ffWZ/aCJVqjCcMsT6nqnohSP/pNkMA0k9zKwJvtI1YfF8giYijqfzF3GI
         XWBda/P/pK5g1o+nCeV14PVOdXYsa9rJIR2lcA4ARRo39D3G96qHE75En5UarWFUTtCN
         ZJel4fRuW1V18yBpZv4QDCiezvWxdadgVtWYlqAsV+JicuI34xgWkHKnIWUVXIzfGQDz
         KtCvvsQ3EJSy+Zu1+ZQKJ8GZ4BiEFupI6itNHmdAbfqlZ13Y2w9KkLUJGWM/wHrfte5u
         F+eymN/T5agNt9uycaIjsoIR9DSwKneLg40ZTCI0m2ii8Bkv/iiIkMo8X9TGjxXcu10G
         H2fw==
X-Gm-Message-State: AJcUukcJWX5CP+iDNHamptcHI3KHrR3yLXQKLkr/qq6yWk8VdhJJ9iux
        QV13XgF5CGiuBrvQBHN+cdOlt/n1xGM=
X-Google-Smtp-Source: ALg8bN6PK+xHjd3xyj1KcozBbPVSnTVf01NP7m39CA4UsSFXH+ssG3f8/o9ZVHfqg90AcRXaRh4Apw==
X-Received: by 2002:adf:d089:: with SMTP id y9mr3173540wrh.22.1546997255898;
        Tue, 08 Jan 2019 17:27:35 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:35 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 09/19] btrfs: add btrfs.key property
Date:   Wed,  9 Jan 2019 01:26:51 +0000
Message-Id: <20190109012701.26441-9-mark@harmstone.com>
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
 fs/btrfs/btrfs_inode.h |  5 ++++
 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/inode.c       |  1 +
 fs/btrfs/props.c       | 68 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 97d91e55b70a..cf9f50bbe4ef 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -175,6 +175,11 @@ struct btrfs_inode {
 	 */
 	unsigned defrag_compress;
 
+	/*
+	 * Salt of preferred encryption key
+	 */
+	u64 prop_key;
+
 	struct btrfs_delayed_node *delayed_node;
 
 	/* File creation time. */
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4bab57e01e21..a1368c5c1236 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1453,6 +1453,7 @@ do {                                                                   \
 #define BTRFS_INODE_NOATIME		(1 << 9)
 #define BTRFS_INODE_DIRSYNC		(1 << 10)
 #define BTRFS_INODE_COMPRESS		(1 << 11)
+#define BTRFS_INODE_ENCRYPT		(1 << 12)
 
 #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9ea4c6f0352f..1d1084cf9289 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9167,6 +9167,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->runtime_flags = 0;
 	ei->prop_compress = BTRFS_COMPRESS_NONE;
 	ei->defrag_compress = BTRFS_COMPRESS_NONE;
+	ei->prop_key = 0;
 
 	ei->delayed_node = NULL;
 
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index e57a4edc88c4..ebe04194acbd 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -29,6 +29,12 @@ static int prop_compression_apply(struct inode *inode,
 				  size_t len);
 static int prop_compression_extract(struct inode *inode, char *value);
 
+static int prop_key_validate(const char *value, size_t len);
+static int prop_key_apply(struct inode *inode,
+			  const char *value,
+			  size_t len);
+static int prop_key_extract(struct inode *inode, char *value);
+
 static struct prop_handler prop_handlers[] = {
 	{
 		.xattr_name = XATTR_BTRFS_PREFIX "compression",
@@ -37,6 +43,13 @@ static struct prop_handler prop_handlers[] = {
 		.extract = prop_compression_extract,
 		.inheritable = 1
 	},
+	{
+		.xattr_name = XATTR_BTRFS_PREFIX "key",
+		.validate = prop_key_validate,
+		.apply = prop_key_apply,
+		.extract = prop_key_extract,
+		.inheritable = 1
+	},
 };
 
 void __init btrfs_props_init(void)
@@ -435,4 +448,59 @@ static int prop_compression_extract(struct inode *inode, char *value)
 	return -EINVAL;
 }
 
+static int prop_key_validate(const char *value, size_t len)
+{
+	unsigned int i;
+
+	if (len != 16)
+		return -EINVAL;
+
+	for (i = 0; i < 16; i++) {
+		if (hex_to_bin(value[i]) == -1)
+			return -EINVAL;
+	}
 
+	return 0;
+}
+
+static int prop_key_apply(struct inode *inode,
+			  const char *value,
+			  size_t len)
+{
+	u64 salt;
+
+	if (len == 0) {
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_ENCRYPT;
+		BTRFS_I(inode)->prop_key = 0;
+
+		return 0;
+	}
+
+	if (len != 16)
+		return -EINVAL;
+
+	if (hex2bin((u8 *)&salt, value, len / 2))
+		return -EINVAL;
+
+	salt = be64_to_cpu(salt);
+
+	BTRFS_I(inode)->flags |= BTRFS_INODE_ENCRYPT;
+	BTRFS_I(inode)->prop_key = salt;
+
+	return 0;
+}
+
+static int prop_key_extract(struct inode *inode, char *value)
+{
+	u64 salt;
+
+	if (BTRFS_I(inode)->prop_key == 0)
+		return -EINVAL;
+
+	salt = cpu_to_be64(BTRFS_I(inode)->prop_key);
+	bin2hex(value, &salt, sizeof(salt));
+
+	value[16] = 0;
+
+	return 0;
+}
-- 
2.19.2

