Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:52761 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932560Ab3CDVkc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 16:40:32 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 06/14] btrfs-progs: check for null string in parse_size
Date: Mon,  4 Mar 2013 16:39:56 -0600
Message-Id: <1362436804-16766-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Because it's better than a segfault if it's called improperly,
and it makes static checkers happier.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 utils.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/utils.c b/utils.c
index 54d577c..a38ac70 100644
--- a/utils.c
+++ b/utils.c
@@ -1382,7 +1382,7 @@ u64 parse_size(char *s)
 	char c;
 	u64 mult = 1;
 
-	for (i=0 ; s[i] && isdigit(s[i]) ; i++) ;
+	for (i=0 ; s && s[i] && isdigit(s[i]) ; i++) ;
 	if (!i) {
 		fprintf(stderr, "ERROR: size value is empty\n");
 		exit(50);
-- 
1.7.1

