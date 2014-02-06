Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284AbaBFO3W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 09:29:22 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 04304ABB3
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Feb 2014 14:29:22 +0000 (UTC)
From: David Disseldorp <ddiss@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>
Subject: [PATCH] ioctl: add note regarding CLONE_RANGE(len=0) behaviour
Date: Thu,  6 Feb 2014 15:29:18 +0100
Message-Id: <1391696958-4522-1-git-send-email-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A BTRFS_IOC_CLONE_RANGE request with a src_length value of zero has the
effect of cloning all data from src_offset through to end-of-file.

Document this behaviour in the header file for those who (like me)
incorrectly assume that no data is cloned in such a case.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 ioctl.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ioctl.h b/ioctl.h
index a589cd7..f7d435d 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -506,6 +506,7 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
 				   struct btrfs_ioctl_vol_args)
 
+/* With a @src_length of zero, the range from @src_offset->EOF is cloned! */
 struct btrfs_ioctl_clone_range_args {
 	__s64 src_fd;
 	__u64 src_offset, src_length;
-- 
1.8.4.5

