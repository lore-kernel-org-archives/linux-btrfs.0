From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: clear pages dirty for io and set them extent mapped
Date: Tue, 15 Nov 2011 09:32:56 -0500
Message-ID: <1321367576-2539-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When doing the io_ctl helpers to clean up the free space cache stuff I stopped
using our normal prepare_pages stuff, which means I of course forgot to do
things like set the pages extent mapped, which will cause us all sorts of
wonderful propblems.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 96cb54d..30e045d 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -351,6 +351,11 @@ static int io_ctl_prepare_pages(struct io_ctl *io_ctl, struct inode *inode,
 		}
 	}
 
+	for (i = 0; i < io_ctl->num_pages; i++) {
+		clear_page_dirty_for_io(io_ctl->pages[i]);
+		set_page_extent_mapped(io_ctl->pages[i]);
+	}
+
 	return 0;
 }
 
-- 
1.7.5.2

