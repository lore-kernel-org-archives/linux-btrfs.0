Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE523C282CE
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 14:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CC43218FD
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 14:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731754AbfDXOuN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 10:50:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:51692 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731194AbfDXOsD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 10:48:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4D9FAADEA
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 14:48:02 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 1/3] btrfs-progs: factor out super_block reading from load_and_dump_sb
Date:   Wed, 24 Apr 2019 16:47:52 +0200
Message-Id: <20190424144754.4612-2-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190424144754.4612-1-jthumshirn@suse.de>
References: <20190424144754.4612-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

inspect-internal dump-superblock's load_and_dump_sb() already reads a
super block from a file descriptor and places it into a 'struct
btrfs_super_block'.

For inspect-internal dump-csum we need this super block as well but don't
care about printing it.

Separate the read from the dump phase so we can re-use it elsewhere.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 cmds-inspect-dump-super.c |  6 +++---
 utils.c                   | 17 +++++++++++++++++
 utils.h                   |  2 ++
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 7815c863f2ed..516760fad3da 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -483,10 +483,10 @@ static int load_and_dump_sb(char *filename, int fd, u64 sb_bytenr, int full,
 
 	sb = (struct btrfs_super_block *)super_block_data;
 
-	ret = pread64(fd, super_block_data, BTRFS_SUPER_INFO_SIZE, sb_bytenr);
-	if (ret != BTRFS_SUPER_INFO_SIZE) {
+	ret = load_sb(fd, sb_bytenr, sb, BTRFS_SUPER_INFO_SIZE);
+	if (ret) {
 		/* check if the disk if too short for further superblock */
-		if (ret == 0 && errno == 0)
+		if (ret == -ENOSPC)
 			return 0;
 
 		error("failed to read the superblock on %s at %llu",
diff --git a/utils.c b/utils.c
index 9e26c884cc6c..b15cfcf5a434 100644
--- a/utils.c
+++ b/utils.c
@@ -2593,3 +2593,20 @@ void print_all_devices(struct list_head *devices)
 		print_device_info(dev, "\t");
 	printf("\n");
 }
+
+int load_sb(int fd, u64 bytenr, struct btrfs_super_block *sb, size_t size)
+{
+	int ret;
+
+	if (size != BTRFS_SUPER_INFO_SIZE)
+		return -EINVAL;
+
+	ret = pread64(fd, sb, size, bytenr);
+	if (ret != size) {
+		if (ret == 0 && errno == 0)
+			return -ENOSPC;
+
+		return -errno;
+	}
+	return 0;
+}
diff --git a/utils.h b/utils.h
index 7c5eb798557d..65549374b19c 100644
--- a/utils.h
+++ b/utils.h
@@ -171,6 +171,8 @@ unsigned long total_memory(void);
 void print_device_info(struct btrfs_device *device, char *prefix);
 void print_all_devices(struct list_head *devices);
 
+int load_sb(int fd, u64 bytenr, struct btrfs_super_block *sb, size_t size);
+
 /*
  * Global program state, configurable by command line and available to
  * functions without extra context passing.
-- 
2.16.4

