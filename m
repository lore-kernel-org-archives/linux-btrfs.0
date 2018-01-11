Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54301 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751089AbeAKFK2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:28 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 249E049F0E46
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:20 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 61/67] btrfs-progs: add the stack prefix for super_compat_flags set/get function
Date: Thu, 11 Jan 2018 13:09:33 +0800
Message-ID: <20180111050939.21251-62-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_compat_flags set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 2 +-
 ctree.h                   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 7308b476..24037125 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -406,7 +406,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("num_devices\t\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_num_devices(sb));
 	printf("compat_flags\t\t0x%llx\n",
-	       (unsigned long long)btrfs_super_compat_flags(sb));
+	       (unsigned long long)btrfs_stack_super_compat_flags(sb));
 	printf("compat_ro_flags\t\t0x%llx\n",
 	       (unsigned long long)btrfs_super_compat_ro_flags(sb));
 	print_readable_compat_ro_flag(btrfs_super_compat_ro_flags(sb));
diff --git a/ctree.h b/ctree.h
index 41b5785d..c18b5577 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2198,7 +2198,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_root_dir, struct btrfs_super_block,
 			 root_dir_objectid, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_super_num_devices, struct btrfs_super_block,
 			 num_devices, 64);
-BTRFS_SETGET_STACK_FUNCS(super_compat_flags, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_compat_flags, struct btrfs_super_block,
 			 compat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_compat_ro_flags, struct btrfs_super_block,
 			 compat_ro_flags, 64);
-- 
2.15.1



