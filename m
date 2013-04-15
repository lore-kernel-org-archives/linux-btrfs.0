Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41867 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3DONro (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 09:47:44 -0400
Received: by mail-ie0-f177.google.com with SMTP id 9so5277061iec.8
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2013 06:47:43 -0700 (PDT)
From: Dan McGrath <danmcgrath.ca@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Dan McGrath <danmcgrath.ca@gmail.com>
Subject: [PATCH] btrfs-progs: No-op when called as fsck.btrfsck
Date: Mon, 15 Apr 2013 09:47:09 -0400
Message-Id: <1366033629-25121-2-git-send-email-danmcgrath.ca@gmail.com>
In-Reply-To: <1366033629-25121-1-git-send-email-danmcgrath.ca@gmail.com>
References: <1366033629-25121-1-git-send-email-danmcgrath.ca@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As per FAQ: It is safe to and recommended to turn fsck.btrfs into a no-op

Signed-off-by: Dan McGrath <danmcgrath.ca@gmail.com>
---
 btrfs.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/btrfs.c b/btrfs.c
index 691adef..78161a9 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -272,6 +272,8 @@ int main(int argc, char **argv)
 
 	if (!strcmp(bname, "btrfsck")) {
 		argv[0] = "check";
+	} else if (!strcmp(bname, "fsck.btrfsck")) {
+		exit(0);
 	} else {
 		argc--;
 		argv++;
-- 
1.7.9.5

