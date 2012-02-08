From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] Btrfs: avoid positive number with ERR_PTR
Date: Wed,  8 Feb 2012 16:01:01 +0100
Message-ID: <1328713261-14134-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <20120208085712.GA6554@elgon.mountain>
Cc: linux-btrfs@vger.kernel.org
To: dan.carpenter@oracle.com, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120208085712.GA6554@elgon.mountain>
List-ID: <linux-btrfs.vger.kernel.org>

inode_ref_info() returns 1 when the element wasn't found and < 0 on error,
just like btrfs_search_slot(). In iref_to_path() it's an error when the
inode ref can't be found, thus we return ERR_PTR(ret) in that case. In order
to avoid ERR_PTR(1), we now set ret to -ENOENT in that case.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
On 08.02.2012 10:18, Dan Carpenter wrote:
> I looked at the code, but couldn't tell if it was intentional or not.

It wasn't :-)

Thank you,
-Jan
---
 fs/btrfs/backref.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
---

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 633c701..98f6bf10 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -892,6 +892,8 @@ static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 		if (eb != eb_in)
 			free_extent_buffer(eb);
 		ret = inode_ref_info(parent, 0, fs_root, path, &found_key);
+		if (ret > 0)
+			ret = -ENOENT;
 		if (ret)
 			break;
 		next_inum = found_key.offset;
-- 
1.7.3.4

