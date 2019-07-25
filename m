Return-Path: <SRS0=fwWV=VW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC35C761A8
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Jul 2019 09:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 763FA2084D
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Jul 2019 09:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403795AbfGYJeL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Jul 2019 05:34:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:52306 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390576AbfGYJeK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jul 2019 05:34:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 048A6AD9C
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2019 09:34:09 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [RFC PATCH 2/4] btrfs: create structure to encode checksum type and length
Date:   Thu, 25 Jul 2019 11:33:49 +0200
Message-Id: <944b685765a68c3389888159d3fe228c2e78eb22.1564046812.git.jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <cover.1564046812.git.jthumshirn@suse.de>
References: <cover.1564046812.git.jthumshirn@suse.de>
In-Reply-To: <cover.1564046812.git.jthumshirn@suse.de>
References: <cover.1564046812.git.jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Create a structure to encode the type and length for the known on-disk
checksums. Also add a table and a convenience macro for adding the
checksum types to the table.

This makes it easier to add new checksums later.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/ctree.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index da97ff10f421..099401f5dd47 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -82,9 +82,15 @@ struct btrfs_ref;
  */
 #define BTRFS_LINK_MAX 65535U
 
-/* four bytes for CRC32 */
-static const int btrfs_csum_sizes[] = { 4 };
-static const char *btrfs_csum_names[] = { "crc32c" };
+#define BTRFS_CHECKSUM_TYPE(_type, _size, _name) \
+	[_type] = { .size = _size, .name = _name }
+
+static const struct btrfs_csums {
+	u16		size;
+	const char	*name;
+} btrfs_csums[] = {
+	BTRFS_CHECKSUM_TYPE(BTRFS_CSUM_TYPE_CRC32, 4, "crc32c"),
+};
 
 #define BTRFS_EMPTY_DIR_SIZE 0
 
@@ -2373,13 +2379,13 @@ static inline int btrfs_super_csum_size(const struct btrfs_super_block *s)
 	/*
 	 * csum type is validated at mount time
 	 */
-	return btrfs_csum_sizes[t];
+	return btrfs_csums[t].size;
 }
 
 static inline const char *btrfs_super_csum_name(u16 csum_type)
 {
 	/* csum type is validated at mount time */
-	return btrfs_csum_names[csum_type];
+	return btrfs_csums[csum_type].name;
 }
 
 /*
-- 
2.16.4

