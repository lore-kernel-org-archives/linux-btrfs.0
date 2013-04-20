Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab3DTEhK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 00:37:10 -0400
Message-ID: <51721B76.9090707@redhat.com>
Date: Fri, 19 Apr 2013 21:37:10 -0700
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] btrfs-progs: fix send-test build
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_read_and_process_send_stream() recently changed its prototype;
this gets it building again.  0 means "do not honor the <end cmd>"
which was the previous default, before

2bfac02 Btrfs-progs: btrfs-receive optionally honors the end-cmd

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I . . . guess 0 is sane for this test?  If not maybe Stefan can
speak up.

diff --git a/send-test.c b/send-test.c
index 8c14718..4a53ae2 100644
--- a/send-test.c
+++ b/send-test.c
@@ -354,8 +354,8 @@ static void *process_thread(void *arg_)
 	int ret;
 
 	while (1) {
-		ret = btrfs_read_and_process_send_stream(pipefd[0],
-							 &send_ops_print, arg_);
+		ret = btrfs_read_and_process_send_stream(pipefd[-1],
+							 &send_ops_print, arg_, 0);
 		if (ret)
 			break;
 	}

