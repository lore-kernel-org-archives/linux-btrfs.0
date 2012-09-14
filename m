Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:28459 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab2INGCO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 02:02:14 -0400
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, hugo@carfax.org.uk
Subject: [PATCH] Btrfs-progs: making send.h inline with its kernel side change
Date: Fri, 14 Sep 2012 14:04:20 +0800
Message-Id: <1347602661-7576-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1347602661-7576-1-git-send-email-Anand.Jain@oracle.com>
References: <5052C5A0.4090803@oracle.com>
 <1347602661-7576-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 send.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/send.h b/send.h
index 9934e94..1bf4f32 100644
--- a/send.h
+++ b/send.h
@@ -130,4 +130,5 @@ enum {
 
 #ifdef __KERNEL__
 long btrfs_ioctl_send(struct file *mnt_file, void __user *arg);
+int write_buf(struct file *filp, const void *buf, u32 len, loff_t *off);
 #endif
-- 
1.7.1

