From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/3]fs:btrfs:free-space-cache.c Remove extra semicolon.
Date: Mon, 21 Nov 2011 08:43:28 -0800
Message-ID: <1321893808-3721-3-git-send-email-justinmattock@gmail.com>
References: <1321893808-3721-1-git-send-email-justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: trivial@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1321893808-3721-1-git-send-email-justinmattock@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch below removes an extra semicolon. 
Note: I have not compile tested this patch, so am unsure if this breaks things.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: linux-btrfs@vger.kernel.org

---
 fs/btrfs/free-space-cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 181760f..75a7b11 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -418,7 +418,7 @@ static void io_ctl_set_crc(struct io_ctl *io_ctl, int index)
 	}
 
 	if (index == 0)
-		offset = sizeof(u32) * io_ctl->num_pages;;
+		offset = sizeof(u32) * io_ctl->num_pages;
 
 	crc = btrfs_csum_data(io_ctl->root, io_ctl->orig + offset, crc,
 			      PAGE_CACHE_SIZE - offset);
-- 
1.7.5.4
