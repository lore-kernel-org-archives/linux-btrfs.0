Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56121 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab3KFXP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 15/16] btrfs-progs: annotate fallthroughs in parse_size
Date: Wed,  6 Nov 2013 17:15:54 -0600
Message-Id: <1383779755-18228-16-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We intentionally fall through these case statements;
just annotate it to be clear.

Resolves-Coverity-CID: 1054887
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 utils.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/utils.c b/utils.c
index ecacc29..9aeb5f8 100644
--- a/utils.c
+++ b/utils.c
@@ -1499,16 +1499,22 @@ u64 parse_size(char *s)
 		switch (c) {
 		case 'e':
 			mult *= 1024;
+			/* fallthrough */
 		case 'p':
 			mult *= 1024;
+			/* fallthrough */
 		case 't':
 			mult *= 1024;
+			/* fallthrough */
 		case 'g':
 			mult *= 1024;
+			/* fallthrough */
 		case 'm':
 			mult *= 1024;
+			/* fallthrough */
 		case 'k':
 			mult *= 1024;
+			/* fallthrough */
 		case 'b':
 			break;
 		default:
-- 
1.7.1

