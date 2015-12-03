Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43635 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbbLCSqF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Dec 2015 13:46:05 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-btrfs@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: only free root_path if it was allocated from the heap
Date: Thu,  3 Dec 2015 13:45:44 -0500
Message-Id: <1449168344-5803-1-git-send-email-nhorman@tuxdriver.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Noticed this while doing some snapshots in a chroot environment

btrfs receive can set root_path to either realmnt, which is passed in from the
command line, or to a heap allocated via find_mount_root  in do_receive.  We
should only free the later, not the former, as the former results in an invalid
pointer warning from glibc during free.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Josef Bacik <jbacik@fb.com>
CC: David Sterba <dsterba@suse.cz>
---
 cmds-receive.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 3a84a3b..c25dc59 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -1201,7 +1201,9 @@ out:
 		close(r->write_fd);
 		r->write_fd = -1;
 	}
-	free(r->root_path);
+
+	if (r->root_path != realmnt)
+		free(r->root_path);
 	r->root_path = NULL;
 	r->dest_dir_path = NULL;
 	free(dest_dir_full_path);
-- 
2.5.0

