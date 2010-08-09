From: =?ISO-8859-1?Q?Andr=E9_Nogueira?= <andre.neo.net@gmail.com>
Subject: [PATCH] Function btree_get_extent: Incorrect if-else if statement
Date: Mon, 9 Aug 2010 11:47:48 +0100
Message-ID: <AANLkTimCtN1hten5v+tdwG9yiKsFmSMPcQU-eLefDQkc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The btree_get_extent function (in file disk-io.c) calls the
add_extent_mapping (in file extent_map.c). The add_extent_mapping
function can return two values: 0 or -EEXIST.

After the call, it is used an if-else if statement. If the result is
-EEXIST, the if statement is executed. If the result is 0, the else if
statement will not be executed because it is false.

Thank you.

Signed-off-by: Andre Nogueira <andre.neo.net@gmail.com>

---
 fs/btrfs/disk-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 34f7c37..76eb161 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -164,7 +164,7 @@ static struct extent_map *btree_get_extent(struct
inode *inode,
 						   failed_len);
 			ret = -EIO;
 		}
-	} else if (ret) {
+	} else {
 		free_extent_map(em);
 		em = NULL;
 	}
-- 
1.6.3.3
