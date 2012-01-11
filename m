From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 02/11] Btrfs: avoid possible NULL deref in io_ctl_drop_pages()
Date: Wed, 11 Jan 2012 13:52:23 +0800
Message-ID: <4F0D2397.9030603@cn.fujitsu.com>
References: <4F0D236E.2010306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F0D236E.2010306@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

If we run into some failure path in io_ctl_prepare_pages(),
io_ctl->pages[] array may have some NULL pointers.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 01840ef..4e55af3 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -319,9 +319,11 @@ static void io_ctl_drop_pages(struct io_ctl *io_ctl)
 	io_ctl_unmap_page(io_ctl);
 
 	for (i = 0; i < io_ctl->num_pages; i++) {
-		ClearPageChecked(io_ctl->pages[i]);
-		unlock_page(io_ctl->pages[i]);
-		page_cache_release(io_ctl->pages[i]);
+		if (io_ctl->pages[i]) {
+			ClearPageChecked(io_ctl->pages[i]);
+			unlock_page(io_ctl->pages[i]);
+			page_cache_release(io_ctl->pages[i]);
+		}
 	}
 }
 
-- 
1.7.3.1
