Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:59058 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760807Ab3D3RE2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 13:04:28 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2BFC99A068E
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 11:04:28 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id jBQFgsbHPgQBeyNp (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 11:04:27 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix typo in send.c
Date: Tue, 30 Apr 2013 13:04:25 -0400
Message-ID: <1367341465-5155-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a bug where we do sizeof(*ptr * count) instead of sizeof(*ptr) *
count.  Fix this.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/send.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index ff40f1c..7c8964b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4587,8 +4587,8 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	}
 
 	if (!access_ok(VERIFY_READ, arg->clone_sources,
-			sizeof(*arg->clone_sources *
-			arg->clone_sources_count))) {
+			sizeof(*arg->clone_sources) *
+			arg->clone_sources_count)) {
 		ret = -EFAULT;
 		goto out;
 	}
-- 
1.7.7.6

