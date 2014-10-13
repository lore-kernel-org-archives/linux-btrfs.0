Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:42893 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaJMEm4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 00:42:56 -0400
Received: by mail-pd0-f181.google.com with SMTP id z10so4860764pdj.26
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Oct 2014 21:42:55 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] btrfs-progs: add new dev replace result
Date: Mon, 13 Oct 2014 12:42:13 +0800
Message-Id: <1413175333-26095-2-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1413175333-26095-1-git-send-email-guaneryu@gmail.com>
References: <1413175333-26095-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A new dev replace result was introduced by kernel commit

Btrfs: return failure if btrfs_dev_replace_finishing() failed

Make the userspace know about the new result too.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 cmds-replace.c | 2 ++
 ioctl.h        | 1 +
 2 files changed, 3 insertions(+)

diff --git a/cmds-replace.c b/cmds-replace.c
index 9fe7ad8..7a45cef 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -53,6 +53,8 @@ static const char *replace_dev_result2string(__u64 result)
 		return "not started";
 	case BTRFS_IOCTL_DEV_REPLACE_RESULT_ALREADY_STARTED:
 		return "already started";
+	case BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS:
+		return "scrub is in progress";
 	default:
 		return "<illegal result value>";
 	}
diff --git a/ioctl.h b/ioctl.h
index f0fc060..0e02fae 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -144,6 +144,7 @@ struct btrfs_ioctl_dev_replace_status_params {
 #define BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR			0
 #define BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED		1
 #define BTRFS_IOCTL_DEV_REPLACE_RESULT_ALREADY_STARTED		2
+#define BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS		3
 struct btrfs_ioctl_dev_replace_args {
 	__u64 cmd;	/* in */
 	__u64 result;	/* out */
-- 
1.8.3.1

