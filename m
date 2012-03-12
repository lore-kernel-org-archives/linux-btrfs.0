From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 1/3] Btrfs-progs: nuke redundant zeroing in __list_subvol_search()
Date: Mon, 12 Mar 2012 20:05:45 +0200
Message-ID: <1331575547-5796-2-git-send-email-idryomov@gmail.com>
References: <1331575547-5796-1-git-send-email-idryomov@gmail.com>
Cc: idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1331575547-5796-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

There's no need to zero out things twice.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 btrfs-list.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 5f4a9be..44a73de 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -569,10 +569,6 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	root_lookup_init(root_lookup);
 	memset(&args, 0, sizeof(args));
 
-	root_lookup_init(root_lookup);
-
-	memset(&args, 0, sizeof(args));
-
 	/* search in the tree of tree roots */
 	sk->tree_id = 1;
 
-- 
1.7.9.1

