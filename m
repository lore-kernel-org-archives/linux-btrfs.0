Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61986 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab3GCQHw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 12:07:52 -0400
Received: by mail-pa0-f53.google.com with SMTP id tj12so384229pac.12
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jul 2013 09:07:52 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl-fnst@cn.fujitsu.com
Subject: [PATCH 2/2] Btrfs-progs: fix possible memory leak related to subvolume/snapshot creation
Date: Thu,  4 Jul 2013 00:07:38 +0800
Message-Id: <1372867658-4144-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1372867658-4144-1-git-send-email-wangshilong1991@gmail.com>
References: <1372867658-4144-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

The operation related qgroup inherit may fails, if it fails, we should
free memory allocated,otherwise, memory leak happens.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 cmds-subvolume.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ccb4762..9db989e 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -89,13 +89,17 @@ static int cmd_subvol_create(int argc, char **argv)
 		switch (c) {
 		case 'c':
 			res = qgroup_inherit_add_copy(&inherit, optarg, 0);
-			if (res)
-				return res;
+			if (res) {
+				retval = res;
+				goto out;
+			}
 			break;
 		case 'i':
 			res = qgroup_inherit_add_group(&inherit, optarg);
-			if (res)
-				return res;
+			if (res) {
+				retval = res;
+				goto out;
+			}
 			break;
 		default:
 			usage(cmd_subvol_create_usage);
@@ -516,21 +520,27 @@ static int cmd_snapshot(int argc, char **argv)
 		switch (c) {
 		case 'c':
 			res = qgroup_inherit_add_copy(&inherit, optarg, 0);
-			if (res)
-				return res;
+			if (res) {
+				retval = res;
+				goto out;
+			}
 			break;
 		case 'i':
 			res = qgroup_inherit_add_group(&inherit, optarg);
-			if (res)
-				return res;
+			if (res) {
+				retval = res;
+				goto out;
+			}
 			break;
 		case 'r':
 			readonly = 1;
 			break;
 		case 'x':
 			res = qgroup_inherit_add_copy(&inherit, optarg, 1);
-			if (res)
-				return res;
+			if (res) {
+				retval = res;
+				goto out;
+			}
 			break;
 		default:
 			usage(cmd_snapshot_usage);
-- 
1.7.11.7

