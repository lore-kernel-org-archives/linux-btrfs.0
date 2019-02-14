Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB7AC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E255222A1
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="y9Yaj6Wc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438186AbfBNKBW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 05:01:22 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43709 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438150AbfBNKBI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 05:01:08 -0500
Received: by mail-pf1-f194.google.com with SMTP id q17so2837497pfh.10
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2019 02:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fTk0FyiVC4C7S5X6h/HN++rzsGBLDjcJTciO7DC+crI=;
        b=y9Yaj6WcgjusayyYM5Aorfv4cGv5yMWbdVWmHpG76OC/LcK0upaLsLOdU4ca14Oxtg
         /jEZ2O/z/AMEwRW/68k8ycysACwXQAlb4kVmZuSxEsQgq+TttJ12uFsenUy1oofinIJW
         584qHI+fSFc2N24PJM5KIksg154F4i734W6DTOUNfJWDRXh2qRl3fGt+xorIOhy0mTAK
         KBFkVC5Q62yIjyY5D3jNfPtp3Hn9jNL1E9psK50mdleOqVB7v8Tv0ew1yokCP2ZoiFlp
         Y35OyQFRmzmMw2hZbJBT6uNdwI64QHZisy2cTvIHKv/EAXiHshp5yYfPiCBQAkwusb4D
         Rgag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fTk0FyiVC4C7S5X6h/HN++rzsGBLDjcJTciO7DC+crI=;
        b=ROS2zh356xFRk/o9S6jLqPwjTDQnwFnczp2kCtoEQqgehYaJNibB54P4851U7XIC7S
         JK8XLKQ35L8cuWBdEv/x5o0SYFqD7Nfmhl5AxtTHDHjVrvwdVATwwGdKCf0JmAFV+1n5
         y/U4eJYp8dfYxvL2gYW/b+HaEtC1tGRC9FexN2dnLkOrNAkjORhg17LIAvXBsu6F6vA5
         pessPCpjkOw61nAEquTjobA/DKp4QZklduN0nKkcmBtSwAEVmxPCYWL7gQqyHu2Ou/jr
         3MNEJwb/6F76cxTfELvYeUETtqz3sLnlMPmOzCJ9RBEct5NyjbOSVS/iuIFVpdW43U6J
         KA7g==
X-Gm-Message-State: AHQUAubz6Gey9Pb681R7yB/PhLUFEj9H1d0hy3T09+sATc84O4pZ6DfP
        zTXaJd/eX62vVTBToMzxp7m6AA==
X-Google-Smtp-Source: AHgI3IZx8Umv7Vjiiq1lW+1CsCbGd8SRwLIkK8mTGw+gp3D0GueHp0jnouvmQm42uVNCErrgJd9ZWg==
X-Received: by 2002:a63:2a86:: with SMTP id q128mr2978793pgq.424.1550138467024;
        Thu, 14 Feb 2019 02:01:07 -0800 (PST)
Received: from vader.thefacebook.com ([2620:10d:c090:180::1:5849])
        by smtp.gmail.com with ESMTPSA id i184sm2686952pfc.41.2019.02.14.02.01.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 02:01:06 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc:     kernel-team@fb.com, linux-api@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: [RFC PATCH 6/6] xfs: add support for setting btime
Date:   Thu, 14 Feb 2019 02:00:13 -0800
Message-Id: <853e0dbdcd881e7dae13ada9dbb5924f6f5c4d9c.1550136164.git.osandov@fb.com>
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

The XFS inode format includes btime (under the name crtime) in inode
version 3. Also update the comments in libxfs to reflect that di_crtime
can now change.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/libxfs/xfs_format.h     |  2 +-
 fs/xfs/libxfs/xfs_log_format.h |  2 +-
 fs/xfs/xfs_iops.c              | 11 +++++++++--
 fs/xfs/xfs_super.c             |  2 +-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9bb3c48843ec..ff6cb860ae77 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -884,9 +884,9 @@ typedef struct xfs_dinode {
 	__be64		di_flags2;	/* more random flags */
 	__be32		di_cowextsize;	/* basic cow extent size for file */
 	__u8		di_pad2[12];	/* more padding for future expansion */
+	xfs_timestamp_t	di_crtime;	/* time created */
 
 	/* fields only written to during inode creation */
-	xfs_timestamp_t	di_crtime;	/* time created */
 	__be64		di_ino;		/* inode number */
 	uuid_t		di_uuid;	/* UUID of the filesystem */
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e5f97c69b320..5cb35b3db870 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -415,9 +415,9 @@ struct xfs_log_dinode {
 	uint64_t	di_flags2;	/* more random flags */
 	uint32_t	di_cowextsize;	/* basic cow extent size for file */
 	uint8_t		di_pad2[12];	/* more padding for future expansion */
+	xfs_ictimestamp_t di_crtime;	/* time created */
 
 	/* fields only written to during inode creation */
-	xfs_ictimestamp_t di_crtime;	/* time created */
 	xfs_ino_t	di_ino;		/* inode number */
 	uuid_t		di_uuid;	/* UUID of the filesystem */
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f48ffd7a8d3e..20570f61ffeb 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -582,6 +582,10 @@ xfs_setattr_time(
 		inode->i_ctime = iattr->ia_ctime;
 	if (iattr->ia_valid & ATTR_MTIME)
 		inode->i_mtime = iattr->ia_mtime;
+	if (iattr->ia_valid & ATTR_BTIME) {
+		ip->i_d.di_crtime.t_sec = iattr->ia_btime.tv_sec;
+		ip->i_d.di_crtime.t_nsec = iattr->ia_btime.tv_nsec;
+	}
 }
 
 static int
@@ -1025,11 +1029,14 @@ xfs_vn_setattr(
 	struct dentry		*dentry,
 	struct iattr		*iattr)
 {
+	struct inode		*inode = d_inode(dentry);
+	struct xfs_inode	*ip = XFS_I(inode);
 	int			error;
 
+	if ((iattr->ia_valid & ATTR_BTIME) && ip->i_d.di_version != 3)
+		return -EOPNOTSUPP;
+
 	if (iattr->ia_valid & ATTR_SIZE) {
-		struct inode		*inode = d_inode(dentry);
-		struct xfs_inode	*ip = XFS_I(inode);
 		uint			iolock;
 
 		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c9097cb0b955..54df86bc634b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1860,7 +1860,7 @@ static struct file_system_type xfs_fs_type = {
 	.name			= "xfs",
 	.mount			= xfs_fs_mount,
 	.kill_sb		= kill_block_super,
-	.fs_flags		= FS_REQUIRES_DEV,
+	.fs_flags		= FS_REQUIRES_DEV | FS_HAS_BTIME,
 };
 MODULE_ALIAS_FS("xfs");
 
-- 
2.20.1

