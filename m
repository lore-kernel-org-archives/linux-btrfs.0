Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E29C432C3
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Jan 2021 12:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72B7A221FB
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Jan 2021 12:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388632AbhATMRw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 07:17:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:37906 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730403AbhATK11 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jan 2021 05:27:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611138331; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6z+EG+7IpnotCSDMVtrmTiDOYUmPuYXz7I0gDY6GKZg=;
        b=KXtMSpAKUNhE7f48HGtG+T0R8IxuFcLpXNmZ62tuJJJ85F+XcT7eHKncD3D1cZbZA/rgN8
        NHirTjV7cNEb9nwO37DOnWWlxu/SygRoziH8xfEIqTCtvCIKBbHoHYTWIPBBt3ASA/NOsf
        m5tL3HmTUnZZE8aP5ylr1Gnb99b7VSw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2CCB1B05E;
        Wed, 20 Jan 2021 10:25:31 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 14/14] btrfs: Enable W=1 checks for btrfs
Date:   Wed, 20 Jan 2021 12:25:26 +0200
Message-Id: <20210120102526.310486-15-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210120102526.310486-1-nborisov@suse.com>
References: <20210120102526.310486-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Now that the btrfs' codebase is clean of W=1 warning let's enable those
checks unconditionally for the entire fs/btrfs/ and its subdirectories.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/Makefile | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 9f1b1a88e317..44faee776027 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -1,5 +1,22 @@
 # SPDX-License-Identifier: GPL-2.0
 
+subdir-ccflags-y += -Wextra -Wunused -Wno-unused-parameter
+subdir-ccflags-y += -Wmissing-declarations
+subdir-ccflags-y += -Wmissing-format-attribute
+subdir-ccflags-y += -Wmissing-prototypes
+subdir-ccflags-y += -Wold-style-definition
+subdir-ccflags-y += -Wmissing-include-dirs
+subdir-ccflags-y += $(call cc-option, -Wunused-but-set-variable)
+subdir-ccflags-y += $(call cc-option, -Wunused-const-variable)
+subdir-ccflags-y += $(call cc-option, -Wpacked-not-aligned)
+subdir-ccflags-y += $(call cc-option, -Wstringop-truncation)
+# The following turn off the warnings enabled by -Wextra
+subdir-ccflags-y += -Wno-missing-field-initializers
+subdir-ccflags-y += -Wno-sign-compare
+subdir-ccflags-y += -Wno-type-limits
+
+cmd_checkdoc = $(srctree)/scripts/kernel-doc -none $<
+
 obj-$(CONFIG_BTRFS_FS) := btrfs.o
 
 btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
-- 
2.25.1

