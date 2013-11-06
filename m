Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56123 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab3KFXP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/16] btrfs-progs: don't leak buffer on add_file_items() error
Date: Wed,  6 Nov 2013 17:15:46 -0600
Message-Id: <1383779755-18228-8-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

add_file_items() leaked "buffer" on this error return.
Free it first.

Resolves-Coverity-CID: 1125937
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 mkfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index d576797..f29f5cd 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -629,6 +629,7 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 		ret_read = pread64(fd, buffer, st->st_size, bytes_read);
 		if (ret_read == -1) {
 			fprintf(stderr, "%s read failed\n", path_name);
+			free(buffer);
 			goto end;
 		}
 
-- 
1.7.1

