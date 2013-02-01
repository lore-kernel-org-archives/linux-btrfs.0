Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:40541 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab3BAULe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Feb 2013 15:11:34 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id 060g9l5wRJp4kd1X (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 01 Feb 2013 13:11:33 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix double free of extent buffer
Date: Fri, 1 Feb 2013 15:18:24 -0500
Message-ID: <1359749904-12717-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Noticed this while looking for an segfault related to our eb cache in
btrfsck.  We free the eb in out: so we don't need this extra free.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfsck.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index ff2d7b5..b9dc0bd 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -2594,7 +2594,6 @@ static int run_next_block(struct btrfs_root *root,
 	if (!extent_buffer_uptodate(buf)) {
 		record_bad_block_io(root->fs_info,
 				    extent_cache, bytenr, size);
-		free_extent_buffer(buf);
 		goto out;
 	}
 
-- 
1.7.7.6

