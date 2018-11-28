Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D65EC04EBA
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 505102086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 505102086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbeK1OEW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:22 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:16765 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727268AbeK1OEV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:21 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766257"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:16 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1990A4B734A5
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:17 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:22 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 17/17] btrfs: add mount option "priority_alloc=%s"
Date:   Wed, 28 Nov 2018 11:11:48 +0800
Message-ID: <20181128031148.357-18-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: 1990A4B734A5.A7092
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add mount option "priority_alloc=%s", now %s only supports "usage" and
"off". The latter is used for remount.
"priority_alloc=usage" will active priority aware allocator.
This mount option changes the way of find_free_extent to search
block groups and may cost more time.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/super.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index cbc9d0d2c12d..4a6ccd4c29fd 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -326,6 +326,7 @@ enum {
 	Opt_treelog, Opt_notreelog,
 	Opt_usebackuproot,
 	Opt_user_subvol_rm_allowed,
+	Opt_priority_allocator,
 
 	/* Deprecated options */
 	Opt_alloc_start,
@@ -393,6 +394,7 @@ static const match_table_t tokens = {
 	{Opt_notreelog, "notreelog"},
 	{Opt_usebackuproot, "usebackuproot"},
 	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
+	{Opt_priority_allocator, "priority_alloc=%s"},
 
 	/* Deprecated options */
 	{Opt_alloc_start, "alloc_start=%s"},
@@ -765,6 +767,18 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		case Opt_skip_balance:
 			btrfs_set_opt(info->mount_opt, SKIP_BALANCE);
 			break;
+		case Opt_priority_allocator:
+			if (strcmp(args[0].from, "usage") == 0) {
+				btrfs_set_and_info(info, PRIORITY_USAGE,
+				   "using priority usage-aware allocator");
+			} else if (strcmp(args[0].from, "off") == 0) {
+				btrfs_clear_and_info(info, PRIORITY_USAGE,
+				   "priority awareallocator disabled");
+			} else {
+				ret = -EINVAL;
+				goto out;
+			}
+			break;
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 		case Opt_check_integrity_including_extent_data:
 			btrfs_info(info,
@@ -1337,6 +1351,10 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",inode_cache");
 	if (btrfs_test_opt(info, SKIP_BALANCE))
 		seq_puts(seq, ",skip_balance");
+	if (btrfs_test_opt(info, PRIORITY_USAGE))
+		seq_puts(seq, ",priority_alloc=usage");
+	else
+		seq_puts(seq, ",priority_alloc=off");
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	if (btrfs_test_opt(info, CHECK_INTEGRITY_INCLUDING_EXTENT_DATA))
 		seq_puts(seq, ",check_int_data");
-- 
2.19.1



