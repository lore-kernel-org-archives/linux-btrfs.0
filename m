Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BECB5C169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 06:57:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 882AD2148E
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 06:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbfA2G5o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 01:57:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:38444 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbfA2G5o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 01:57:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0625AAB48
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2019 06:57:43 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: balance: Sync the fs before balancing metadata chunks
Date:   Tue, 29 Jan 2019 14:57:39 +0800
Message-Id: <20190129065739.31707-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
Btrfs will report false ENOSPC balancing metadata chunk.
The following script can easily reproduce it:

  #!/bin/bash
  dev=/dev/test/test
  mnt=/mnt/btrfs

  umount $dev &> /dev/null
  umount $mnt &> /dev/null
  mkfs.btrfs -f $dev

  mount $dev $mnt
  btrfs subv create $mnt/subv
  for ((i = 0; i < 1024; i++)) do
  	xfs_io -f -c "pwrite 0 4k" $mnt/subv/file_$i > /dev/null
  done
  btrfs balance start -m $mnt

[CAUSE]
It's metadata space_info::bytes_may_use causing the problem.
For above case, we need to reserve enough metadata space for all the
created small files.

[FIX]
The most straightforward is to sync the fs before balancing metadata
chunks.

We could enhance the kernel bytes_may_use calculation, but I doubt about
the complexity.
So I take the easy fix to reduce the false ENOSPC reports.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-balance.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/cmds-balance.c b/cmds-balance.c
index 15dc385e..a617a1d2 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -24,6 +24,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <errno.h>
+#include <btrfsutil.h>
 
 #include "kerncompat.h"
 #include "ctree.h"
@@ -32,6 +33,7 @@
 
 #include "commands.h"
 #include "utils.h"
+#include "utils.h"
 #include "help.h"
 
 static const char * const balance_cmd_group_usage[] = {
@@ -455,6 +457,22 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
 		printf("\nStarting balance without any filters.\n");
 	}
 
+	/*
+	 * There may be many over-reserved space for metadata block groups,
+	 * especially for inlined file extents.
+	 *
+	 * Do a sync here will free those over-reserved space and hugely
+	 * reduce the possibility of some false ENOSPC
+	 */
+	if (args->flags & BTRFS_BALANCE_METADATA) {
+		ret = btrfs_util_sync(path);
+		if (ret) {
+			error("failed to sync the fs before balance: %m");
+			ret = -errno;
+			goto out;
+		}
+	}
+
 	ret = ioctl(fd, BTRFS_IOC_BALANCE_V2, args);
 	if (ret < 0) {
 		/*
-- 
2.18.0

