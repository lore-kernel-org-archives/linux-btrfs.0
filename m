Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21085 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751020AbaJOVUS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 17:20:18 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s9FLJ0Js023466
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 14:20:18 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1q2070r3px-16
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 14:20:17 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: properly clean up btrfs_end_io_wq_cache
Date: Wed, 15 Oct 2014 17:19:59 -0400
Message-ID: <1413407999-1154-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In one of Dave's cleanup commits he forgot to call btrfs_end_io_wq_exit on
unload, which makes us unable to unload and then re-load the btrfs module.  This
fixes the problem.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b83ef15..c1d020f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2151,6 +2151,7 @@ static void __exit exit_btrfs_fs(void)
 	extent_map_exit();
 	extent_io_exit();
 	btrfs_interface_exit();
+	btrfs_end_io_wq_exit();
 	unregister_filesystem(&btrfs_fs_type);
 	btrfs_exit_sysfs();
 	btrfs_cleanup_fs_uuids();
-- 
1.8.3.1

