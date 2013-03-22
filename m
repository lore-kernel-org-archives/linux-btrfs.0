Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56332 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932825Ab3CVLxg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 07:53:36 -0400
Received: by mail-pb0-f46.google.com with SMTP id uo15so3030339pbc.19
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 04:53:35 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: koen.de.wit@oracle.com, wangshilong1991@gmail.com
Subject: [PATCH] Btrfs-progs: fix overflow when printing qgroup info
Date: Fri, 22 Mar 2013 19:53:28 +0800
Message-Id: <1363953208-2342-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Since btrfs quota rescan has not been implemented yet,
a user complains that "btrfs qgroup show" lists qgroup
referenced/exclusive be negative. However, this should
not happen even if overflow happens,because the type for
qgroup referenced/exclusive is u64,fix it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reported-by: Koen De Wit <koen.de.wit@oracle.com>
---
 cmds-qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 60ca33d..fc4cb13 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -105,7 +105,7 @@ static int qgroup_create(int create, int argc, char **argv)
 
 void print_qgroup_info(u64 objectid, struct btrfs_qgroup_info_item *info)
 {
-	printf("%llu/%llu %lld %lld\n", objectid >> 48,
+	printf("%llu/%llu %llu %llu\n", objectid >> 48,
 		objectid & ((1ll << 48) - 1),
 		btrfs_stack_qgroup_info_referenced(info),
 		btrfs_stack_qgroup_info_exclusive(info));
-- 
1.7.11.7

