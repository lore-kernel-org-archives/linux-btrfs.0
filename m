Return-Path: <SRS0=avBk=YQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E1DCA9EBC
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Oct 2019 22:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96A8720663
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Oct 2019 22:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571871215;
	bh=gZICtkjVbDPGYWD6LP7lvCuQxMp72urCy8KuC/QQFk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
	 References:List-ID:From;
	b=B56zb3h8+xohGF3q1u8P+hhyx7Lfu2+I7jZChZOIIdJ/In7QmNr3ff7DhymfrFwq9
	 je9ix9dPFV8CD5gEb41VWe/6k3IO//958MOGNa09f4ev7tkW8p3emUyW3XDBGiLF7W
	 JgvH8v0cDx1m73fF1sqQq5U8wmBppEE3B2ptSW0w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436927AbfJWWxd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Oct 2019 18:53:33 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42932 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436923AbfJWWxd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Oct 2019 18:53:33 -0400
Received: by mail-qt1-f195.google.com with SMTP id w14so34720141qto.9
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2019 15:53:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=w6sRwSjS0xaFTOroj8Wuxyc0NKzfoDPX14bR6M8eUCI=;
        b=JuCCUSdRAnNQMFSZrQaNuNWhjV64z4NPoNuJcdKoRbn70YsMGCPlaoxG59FCayzn/t
         IL8tx5acArGuoAD05CnoSwXz0Ysjcm+WO1mHLuz6OklJO+nsMIZBBK8g33y0rGcbMwe3
         4qT0hO4fQpfRCrMK+lmK4dIFUoCDnv9JAx86wQxAGkXONPjwdy7Kzs2rA9D16L4sZ0Vh
         1a5RtrKeNfcoN1Eym7vAGYHwTFXo/H7I9xCFdih7KyvKq3V7Vm6xUhMiHloOtmWJv2LY
         k5nj9nJsa13mNr6tSr70FFCiUUqxa8wDy8+XlYLG5dLpt8RMFuX0OkzLPCv0zonl7uFg
         ZZoQ==
X-Gm-Message-State: APjAAAVDdylTbyqqw/iBuX2LvSwJ18z1aeWCVxBVZEEONAgBitfZK4au
        Q5X1/I4vm9Vggyfl/+UZ7H4=
X-Google-Smtp-Source: APXvYqwRd8JEc4CN19xt7Tm4Bdtxg9uAI5tJLkfY5vEF0pZWmm5wmin7BJZyGwTVu9QBSW0U3Rhp8Q==
X-Received: by 2002:a0c:b303:: with SMTP id s3mr11513102qve.172.1571871210720;
        Wed, 23 Oct 2019 15:53:30 -0700 (PDT)
Received: from dennisz-mbp.thefacebook.com ([163.114.130.128])
        by smtp.gmail.com with ESMTPSA id j4sm11767542qkf.116.2019.10.23.15.53.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 15:53:30 -0700 (PDT)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 10/22] btrfs: add discard sysfs directory
Date:   Wed, 23 Oct 2019 18:53:04 -0400
Message-Id: <ddd9245fc0653d1b10538a5db7cbd2143a32ae0a.1571865774.git.dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <cover.1571865774.git.dennis@kernel.org>
References: <cover.1571865774.git.dennis@kernel.org>
In-Reply-To: <cover.1571865774.git.dennis@kernel.org>
References: <cover.1571865774.git.dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Setup sysfs directory for discard stats + tunables.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 fs/btrfs/ctree.h |  1 +
 fs/btrfs/sysfs.c | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8a34a90ce77f..835144930833 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -931,6 +931,7 @@ struct btrfs_fs_info {
 
 #ifdef CONFIG_BTRFS_DEBUG
 	struct kobject *debug_kobj;
+	struct kobject *discard_kobj;
 #endif
 };
 
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 03694792d621..4b26de87d0ac 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -313,6 +313,13 @@ static const struct attribute_group btrfs_static_feature_attr_group = {
 
 #ifdef CONFIG_BTRFS_DEBUG
 
+/*
+ * Discard statistics and tunables.
+ */
+static const struct attribute *discard_attrs[] = {
+	NULL,
+};
+
 /*
  * Runtime debugging exported via sysfs
  *
@@ -737,6 +744,11 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
 		kobject_put(fs_info->space_info_kobj);
 	}
 #ifdef CONFIG_BTRFS_DEBUG
+	if (fs_info->discard_kobj) {
+		sysfs_remove_files(fs_info->discard_kobj, discard_attrs);
+		kobject_del(fs_info->discard_kobj);
+		kobject_put(fs_info->discard_kobj);
+	}
 	if (fs_info->debug_kobj) {
 		sysfs_remove_files(fs_info->debug_kobj,
 				   btrfs_debug_mount_attrs);
@@ -1092,6 +1104,18 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 				   btrfs_debug_mount_attrs);
 	if (error)
 		goto failure;
+
+	/* Discard directory. */
+	fs_info->discard_kobj = kobject_create_and_add("discard",
+						       fs_info->debug_kobj);
+	if (!fs_info->discard_kobj) {
+		error = -ENOMEM;
+		goto failure;
+	}
+
+	error = sysfs_create_files(fs_info->discard_kobj, discard_attrs);
+	if (error)
+		goto failure;
 #endif
 
 	error = addrm_unknown_feature_attrs(fs_info, true);
-- 
2.17.1

