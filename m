Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AEF3C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A95B222A1
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="flSeOV67"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438140AbfBNKBF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 05:01:05 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38270 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438126AbfBNKBD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 05:01:03 -0500
Received: by mail-pl1-f193.google.com with SMTP id e5so2904916plb.5
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2019 02:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z1iJdJ3ICufViigzY8ArSNJ8k4Y0JN5jmw8hA8KfmFU=;
        b=flSeOV67kqykhRwclnrfrqoGKGW89REoU5Hj3g1pDXyBpBurQb2WVbHnHGfaabPXdH
         eKSDz9iBLVBH6TXcJNKLXZJap0/h8DRGo8G/gzkD0GUDf8FD/etzCzTTEqkkXDFXIdJc
         hjVZm9tfRGvQNK419c1V7l8hrPfdXq3wlRMPwfjeufOh/yml3DSYcVPBc2pga/OkMVfF
         nM5e+JjSOCkBu/xCvjduIggPnLBWzR8qLBjq2dQ2IyilRt/iJvogtDrMC9sgrgvNMDFE
         490OtH/PMfgJUxT3sDxj3fMVRc2qOHjshCd52BoIM5c8zvZnS82pGDv5tLy8rBbHrWD1
         IQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z1iJdJ3ICufViigzY8ArSNJ8k4Y0JN5jmw8hA8KfmFU=;
        b=gMZ1NgSdEwqW9Rjd9CS/zlwpFiaMSnY1ElbUDUe+MgwBnKjqSVf6nKnWF9dedCVYRT
         MqFZGrSqK2klDu7s87SRPoOv3mYIs8kK61fNxVNe8D0XP2Ir/1oXqgGYv7WSvbM8l94L
         K+OIPRHZGFkwdtsQeX0Ob1lYiM+kGdAi3GprCrHcr+3qsbis1JwRGNIcDJBBDqhp3j3i
         +3TE0LEz1mUuCVN2LuAxZ6ho456+xq4oW/F6Pw81SaZk0UzP5w6w6n/YfGN4JudYnLc3
         fpiV20r7Fn7kDLIjVnqJz/0gCxZgZMQR41y86+RYHAj91UfJ3NxyNl+WyanctVhVwmL6
         QwLw==
X-Gm-Message-State: AHQUAuazoFmkfWUf6uq+qKKmB9HwaYrstroIsHgtgB+5yxqtTo4N0HT5
        xGJNjQFZefB9eT3NqBK7dEFqwQ==
X-Google-Smtp-Source: AHgI3Ibyqg3SB+jzXjDULbQ1xxmVIWOPdoCIOX55ghDRePdqF29R1HktJeP2hFm85ktvyjbG1CXwlw==
X-Received: by 2002:a17:902:31a4:: with SMTP id x33mr3169876plb.198.1550138462471;
        Thu, 14 Feb 2019 02:01:02 -0800 (PST)
Received: from vader.thefacebook.com ([2620:10d:c090:180::1:5849])
        by smtp.gmail.com with ESMTPSA id i184sm2686952pfc.41.2019.02.14.02.01.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 02:01:01 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc:     kernel-team@fb.com, linux-api@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: [RFC PATCH 3/6] Btrfs: add support for setting btime
Date:   Thu, 14 Feb 2019 02:00:10 -0800
Message-Id: <60b83d5151d3c80bf73bb257b971aeb66120d4d5.1550136164.git.osandov@fb.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550136164.git.osandov@fb.com>
References: <cover.1550136164.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

The Btrfs inode format has always included btime (under the name otime),
so setting it is trivial.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 2 ++
 fs/btrfs/super.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5c349667c761..49ad777d8057 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5153,6 +5153,8 @@ static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if (attr->ia_valid) {
 		setattr_copy(inode, attr);
+		if (attr->ia_valid & ATTR_BTIME)
+			BTRFS_I(inode)->i_otime = attr->ia_btime;
 		inode_inc_iversion(inode);
 		err = btrfs_dirty_inode(inode);
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0a3f122dd61f..2af368cad2aa 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2140,7 +2140,7 @@ static struct file_system_type btrfs_fs_type = {
 	.name		= "btrfs",
 	.mount		= btrfs_mount,
 	.kill_sb	= btrfs_kill_super,
-	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA,
+	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA | FS_HAS_BTIME,
 };
 
 static struct file_system_type btrfs_root_fs_type = {
@@ -2148,7 +2148,7 @@ static struct file_system_type btrfs_root_fs_type = {
 	.name		= "btrfs",
 	.mount		= btrfs_mount_root,
 	.kill_sb	= btrfs_kill_super,
-	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA,
+	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA | FS_HAS_BTIME,
 };
 
 MODULE_ALIAS_FS("btrfs");
-- 
2.20.1

