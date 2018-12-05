Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AB4C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76E572082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76E572082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbeLEGkq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 01:40:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:49766 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727161AbeLEGkp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 01:40:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B95DAAEB4
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 06:40:43 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 11/13] btrfs-progs: Introduce rescue.h to resolve missing-prototypes for chunk and super rescue
Date:   Wed,  5 Dec 2018 14:40:16 +0800
Message-Id: <20181205064018.27755-12-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205064018.27755-1-wqu@suse.com>
References: <20181205064018.27755-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We don't have any header declaring btrfs_recover_chunk_tree() nor
btrfs_recover_superblocks(), thus W=1 gives missing-prototypes warning
on them.

Fix it by introducing a new header, rescue.h for these two functions, so
make W=1 could be much happier.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 chunk-recover.c |  1 +
 cmds-rescue.c   |  4 +---
 rescue.h        | 21 +++++++++++++++++++++
 super-recover.c |  1 +
 4 files changed, 24 insertions(+), 3 deletions(-)
 create mode 100644 rescue.h

diff --git a/chunk-recover.c b/chunk-recover.c
index 1d30db51d8ed..1e554b8e8750 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -40,6 +40,7 @@
 #include "utils.h"
 #include "btrfsck.h"
 #include "commands.h"
+#include "rescue.h"
 
 struct recover_control {
 	int verbose;
diff --git a/cmds-rescue.c b/cmds-rescue.c
index 2bc50c0841ed..36e9e1277e40 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -26,15 +26,13 @@
 #include "commands.h"
 #include "utils.h"
 #include "help.h"
+#include "rescue.h"
 
 static const char * const rescue_cmd_group_usage[] = {
 	"btrfs rescue <command> [options] <path>",
 	NULL
 };
 
-int btrfs_recover_chunk_tree(const char *path, int verbose, int yes);
-int btrfs_recover_superblocks(const char *path, int verbose, int yes);
-
 static const char * const cmd_rescue_chunk_recover_usage[] = {
 	"btrfs rescue chunk-recover [options] <device>",
 	"Recover the chunk tree by scanning the devices one by one.",
diff --git a/rescue.h b/rescue.h
new file mode 100644
index 000000000000..de486e2e2004
--- /dev/null
+++ b/rescue.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2018 SUSE.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BTRFS_RESCUE_H__
+#define __BTRFS_RESCUE_H__
+
+int btrfs_recover_superblocks(const char *path, int verbose, int yes);
+int btrfs_recover_chunk_tree(const char *path, int verbose, int yes);
+
+#endif
diff --git a/super-recover.c b/super-recover.c
index 86b3df9867dc..a1af71786034 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -34,6 +34,7 @@
 #include "crc32c.h"
 #include "volumes.h"
 #include "commands.h"
+#include "rescue.h"
 
 struct btrfs_recover_superblock {
 	struct btrfs_fs_devices *fs_devices;
-- 
2.19.2

