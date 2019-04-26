Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF92C43218
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 03:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64209206A3
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 03:01:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="B6xQ19eh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfDZDBi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 23:01:38 -0400
Received: from mail.synology.com ([211.23.38.101]:58835 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726196AbfDZDBh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 23:01:37 -0400
Received: from localhost.localdomain (unknown [10.17.32.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id 5E3F01FA63795;
        Fri, 26 Apr 2019 11:01:35 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1556247695; bh=DArfLu22yNIG67lrD2hSyq8GxXuKOULRE10NmcJreJA=;
        h=From:To:Cc:Subject:Date;
        b=B6xQ19ehwOvRvKzwf0N1LQy9sa+D429PKNIxGVlFJKJ0m3wAUpK1cYsLM0FaGl8GY
         2SJt0sXGAmeLC8KrNluxS+CCacF6n/O62iIboAJ3G3hTNbAIJTTJwFbUKYZCka07+b
         HQ7DU13NxD86vYX52hFY0/ZrsFZ21JcwibsSmO1Y=
From:   Johnny Chang <johnnyc@synology.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Johnny Chang <johnnyc@synology.com>
Subject: [PATCH] btrfs: Check the compression level before getting a workspace
Date:   Fri, 26 Apr 2019 11:01:05 +0800
Message-Id: <1556247665-22859-1-git-send-email-johnnyc@synology.com>
X-Mailer: git-send-email 2.7.4
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When a file's compression property is set as zlib or zstd but leave
the compression mount option not be set, that means btrfs will try
to compress the file with default compression level. But in
btrfs_compress_pages(), it calls get_workspace() with level = 0.
This will return a workspace with a wrong compression level.
For zlib, the compression level in the workspace will be 0
(that means "store only"). And for zstd, the compression in the
workspace will be 1, not the default level 3.

How to reproduce:
mkfs -t btrfs /dev/sdb
mount /dev/sdb /mnt/
mkdir /mnt/zlib
btrfs property set /mnt/zlib/ compression zlib
dd if=/dev/zero of=/mnt/zlib/compression-friendly-file-10M bs=1M count=10
sync
btrfs-debugfs -f /mnt/zlib/compression-friendly-file-10M

btrfs-debugfs output:
* before:
...
(258 9961472): ram 524288 disk 1106247680 disk_size 524288
file: ... extents 20 disk size 10485760 logical size 10485760 ratio 1.00

* after:
...
(258 10354688): ram 131072 disk 14217216 disk_size 4096
file: ... extents 80 disk size 327680 logical size 10485760 ratio 32.00

The steps for zstd are similar, but need to put a degging message to
show the level of the return workspace in zstd_get_workspace().

This commit adds a check of the compression level before getting a
workspace by set_level().

Signed-off-by: Johnny Chang <johnnyc@synology.com>
---
 fs/btrfs/compression.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 4f2a8ae..716656d 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1009,6 +1009,7 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
 	struct list_head *workspace;
 	int ret;
 
+	level = btrfs_compress_op[type]->set_level(level);
 	workspace = get_workspace(type, level);
 	ret = btrfs_compress_op[type]->compress_pages(workspace, mapping,
 						      start, pages,
-- 
2.7.4

