Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:57421 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758692Ab3BYVzQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 05/17] btrfs-progs: avoid double-free in __btrfs_map_block
Date: Mon, 25 Feb 2013 16:54:38 -0600
Message-Id: <1361832890-40921-6-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_map_block() can possibly do the goto again: loop after
having allocated & freed the "multi" pointer.  There are then
a couple error conditions where it will attempt to again kfree
the now non-NULL multi pointer.  So before retrying, reset
multi to NULL after we free it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 volumes.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/volumes.c b/volumes.c
index c8fbde3..ca1b402 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1226,6 +1226,7 @@ again:
 	if (multi_ret && stripes_allocated < stripes_required) {
 		stripes_allocated = stripes_required;
 		kfree(multi);
+		multi = NULL;
 		goto again;
 	}
 	stripe_nr = offset;
-- 
1.7.1

