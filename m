Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26913 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab3LJLTN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 06:19:13 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBABJASJ020007
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Dec 2013 19:19:10 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: fix a manpage item for btrfstune
Date: Tue, 10 Dec 2013 19:16:31 +0800
Message-Id: <1386674191-31182-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfstune operates on umounted devices <device>,
not mount points <mnt>. fix it.
---
 man/btrfstune.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/btrfstune.8.in b/man/btrfstune.8.in
index d4b2b7c..0313324 100644
--- a/man/btrfstune.8.in
+++ b/man/btrfstune.8.in
@@ -2,7 +2,7 @@
 .SH NAME
 btrfstune \- tune various filesystem parameters.
 .SH SYNOPSIS
-.B btrfstune [\fIoptions\fP] \fI<mnt>\fP
+.B btrfstune [\fIoptions\fP] \fI<device>\fP
 .SH DESCRIPTION
 \fBbtrfstune\fP is used to tune various filesystem parameters,you can
 enable/disable some extended features for btrfs.
-- 
1.8.0.1

