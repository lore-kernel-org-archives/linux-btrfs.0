Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbbDTF2q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 01:28:46 -0400
From: NeilBrown <neilb@suse.de>
To: David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Date: Mon, 20 Apr 2015 15:27:52 +1000
Subject: [PATCH 3/3] btrfs: set FS_SUPPORTS_SEEK_HOLE flag.
Cc: linux-cachefs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <20150420052752.26554.13596.stgit@notabene.brown>
In-Reply-To: <20150420052558.26554.97143.stgit@notabene.brown>
References: <20150420052558.26554.97143.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This allows fscache to cachefiles in a btrfs filesystem.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/btrfs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 05fef198ff94..d3c5d2b40f8e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1904,7 +1904,8 @@ static struct file_system_type btrfs_fs_type = {
 	.name		= "btrfs",
 	.mount		= btrfs_mount,
 	.kill_sb	= btrfs_kill_super,
-	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA,
+	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA |
+			  FS_SUPPORTS_SEEK_HOLE,
 };
 MODULE_ALIAS_FS("btrfs");
 


