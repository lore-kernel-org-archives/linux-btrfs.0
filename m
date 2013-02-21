Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:40975 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3BUM0Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 07:26:24 -0500
Received: by mail-da0-f52.google.com with SMTP id f10so4078629dak.39
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 04:26:23 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com
Subject: [PATCH] Btrfs-progs: fix parse_limit function to return errors when parsing unit
Date: Thu, 21 Feb 2013 20:26:15 +0800
Message-Id: <1361449575-1835-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Steps to reproduce:
	btrfs qgroup limit m <mnt>/subv

Here, unit(k/K/g/G/m/M/t/T) all will trigger the problem.
For the above command, the original code will parse the limit value as 0
and return successfully.It is wrong,fix it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 cmds-qgroup.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 1525c11..c75ef9b 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -214,6 +214,8 @@ static int parse_limit(const char *p, unsigned long long *s)
 {
 	char *endptr;
 	unsigned long long size;
+	int len = strlen(p);
+	int unit = 0;
 
 	if (strcasecmp(p, "none") == 0) {
 		*s = 0;
@@ -232,6 +234,7 @@ static int parse_limit(const char *p, unsigned long long *s)
 		size *= 1024;
 	case 'K':
 	case 'k':
+		unit = 1;
 		size *= 1024;
 		++endptr;
 		break;
@@ -241,7 +244,11 @@ static int parse_limit(const char *p, unsigned long long *s)
 		return 0;
 	}
 
-	if (*endptr)
+	/*
+	 * (len==1 && unit) means
+	 * limit passed is like k,K,m,M,g,G,t,T.
+	 */
+	if (*endptr || (len == 1 && unit))
 		return 0;
 
 	*s = size;
-- 
1.7.7.6

