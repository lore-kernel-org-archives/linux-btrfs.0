Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42711 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755962AbaFSBb5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 21:31:57 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J1VIxB019656
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 09:31:18 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/6] Btrfs-progs: btrfs-restore,check if specified root is fs/file tree firstly
Date: Thu, 19 Jun 2014 09:27:05 +0800
Message-ID: <1403141229-25565-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1403141229-25565-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1403141229-25565-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
 # mkfs.btrfs -f /dev/sda9
 # mount /dev/sda9 /mnt
 # dd if=/dev/zero of=/mnt/data bs=1M count=1
 # btrfs restore -r /dev/sda9 -r 2 -o /tmp

If users don't input a valid fs/file root objectid, btrfs restore still
continue and don't restore anything, this is unfriendly, we could
check it firstly.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-restore.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/cmds-restore.c b/cmds-restore.c
index 96b97e1..934755a 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1180,6 +1180,11 @@ int cmd_restore(int argc, char **argv)
 				break;
 			case 'r':
 				root_objectid = arg_strtou64(optarg);
+				if (!is_fstree(root_objectid)) {
+					fprintf(stderr, "objectid %llu is not a valid fs/file tree\n",
+							root_objectid);
+					exit(1);
+				}
 				break;
 			case 'l':
 				list_roots = 1;
-- 
1.9.0

