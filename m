Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:57272 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708Ab3EFTPR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 15:15:17 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs-progs: fixup: add flags to struct btrfs_ioctl_quota_rescan_args
Date: Mon,  6 May 2013 21:15:01 +0200
Message-Id: <1367867701-5054-1-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1367867657-4630-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1367867657-4630-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patch set previously sent was sent together with the kernel part, but
was not updated as I added some reserved bytes to the ioctl struct for
future compatibility. This fixes struct btrfs_ioctl_quota_rescan_args.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 ioctl.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/ioctl.h b/ioctl.h
index 1ee631a..abe6dd4 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -429,6 +429,7 @@ struct btrfs_ioctl_quota_ctl_args {
 struct btrfs_ioctl_quota_rescan_args {
 	__u64	flags;
 	__u64   progress;
+	__u64   reserved[6];
 };
 
 struct btrfs_ioctl_qgroup_assign_args {
-- 
1.7.1

