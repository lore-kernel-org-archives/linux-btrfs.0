Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56131 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab3KFXP7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:59 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 16/16] btrfs-progs: annotate fallthroughs in parse_limit
Date: Wed,  6 Nov 2013 17:15:55 -0600
Message-Id: <1383779755-18228-17-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We intentionally fall through these case statements;
just annotate it to be clear.

Resolves-Coverity-CID: 1054884
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-qgroup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 4fe776c..5a393bd 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -120,12 +120,15 @@ static int parse_limit(const char *p, unsigned long long *s)
 	case 'T':
 	case 't':
 		size *= 1024;
+		/* fallthrough */
 	case 'G':
 	case 'g':
 		size *= 1024;
+		/* fallthrough */
 	case 'M':
 	case 'm':
 		size *= 1024;
+		/* fallthrough */
 	case 'K':
 	case 'k':
 		size *= 1024;
-- 
1.7.1

