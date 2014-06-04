Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:53062 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbaFDMEJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jun 2014 08:04:09 -0400
From: Antonio Ospite <ao2@ao2.it>
To: Jiri Kosina <trivial@kernel.org>
Cc: Antonio Ospite <ao2@ao2.it>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH 10/12] trivial: fs/btrfs/ioctl.c: fix typo s/substract/subtract/
Date: Wed,  4 Jun 2014 14:03:48 +0200
Message-Id: <1401883430-19492-11-git-send-email-ao2@ao2.it>
In-Reply-To: <1401883430-19492-1-git-send-email-ao2@ao2.it>
References: <1401883430-19492-1-git-send-email-ao2@ao2.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Antonio Ospite <ao2@ao2.it>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2f6d7b1..b0a206f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3051,11 +3051,11 @@ process_slot:
 				 * | ------------- extent ------------- |
 				 */
 
-				/* substract range b */
+				/* subtract range b */
 				if (key.offset + datal > off + len)
 					datal = off + len - key.offset;
 
-				/* substract range a */
+				/* subtract range a */
 				if (off > key.offset) {
 					datao += off - key.offset;
 					datal -= off - key.offset;
-- 
2.0.0

