From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 1/5] Btrfs: fix memory leak in btrfs_parse_early_options()
Date: Wed,  9 Nov 2011 16:38:33 +0200
Message-ID: <1320849517-13172-2-git-send-email-idryomov@gmail.com>
References: <1320849517-13172-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1320849517-13172-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Don't leak subvol_name string in case multiple subvol= options are
given.  "The lastest option is effective" behavior (consistent with
subvolid= and subvolrootid= options) is preserved.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index dcd5aef..6befcaf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -448,6 +448,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_subvol:
+			kfree(*subvol_name);
 			*subvol_name = match_strdup(&args[0]);
 			break;
 		case Opt_subvolid:
-- 
1.7.6.3

