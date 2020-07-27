Return-Path: <SRS0=3GY2=BG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE54DC433E1
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Jul 2020 15:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9D0D206E7
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Jul 2020 15:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbgG0Pix (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 Jul 2020 11:38:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:58424 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729509AbgG0Pix (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Jul 2020 11:38:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EFE0AAD87;
        Mon, 27 Jul 2020 15:39:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5F792DA701; Mon, 27 Jul 2020 17:38:24 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, kernel test robot <lkp@intel.com>
Subject: [PATCH] btrfs: use the correct const function attribute for btrfs_get_num_csums
Date:   Mon, 27 Jul 2020 17:38:19 +0200
Message-Id: <20200727153820.26996-1-dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The build robot reports

compiler: h8300-linux-gcc (GCC) 9.3.0
   In file included from fs/btrfs/tests/extent-map-tests.c:8:
>> fs/btrfs/tests/../ctree.h:2166:8: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
    2166 | size_t __const btrfs_get_num_csums(void);
         |        ^~~~~~~

The function attribute for const does not follow the expected scheme and
in this case is confused with a const type qualifier.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 2 +-
 fs/btrfs/ctree.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 70e49d8d4f6c..cd1cd673bc0b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -68,7 +68,7 @@ const char *btrfs_super_csum_driver(u16 csum_type)
 		btrfs_csums[csum_type].name;
 }
 
-size_t __const btrfs_get_num_csums(void)
+size_t __attribute_const__ btrfs_get_num_csums(void)
 {
 	return ARRAY_SIZE(btrfs_csums);
 }
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9c7e466f27a9..729b5b80014a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2262,7 +2262,7 @@ BTRFS_SETGET_STACK_FUNCS(super_uuid_tree_generation, struct btrfs_super_block,
 int btrfs_super_csum_size(const struct btrfs_super_block *s);
 const char *btrfs_super_csum_name(u16 csum_type);
 const char *btrfs_super_csum_driver(u16 csum_type);
-size_t __const btrfs_get_num_csums(void);
+size_t __attribute_const__ btrfs_get_num_csums(void);
 
 
 /*
-- 
2.25.0

