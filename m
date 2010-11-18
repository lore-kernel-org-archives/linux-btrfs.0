From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 2/6] btrfs: Fix error handling in zlib
Date: Thu, 18 Nov 2010 10:10:01 +0800
Message-ID: <4CE48AF9.6070000@cn.fujitsu.com>
References: <4CE48ABB.5070302@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CE48ABB.5070302@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Return failure if alloc_page() fails to allocate memory,
and the upper code will just give up compression.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/zlib.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index e5b8b22..5a8ba17 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -225,6 +225,10 @@ int btrfs_zlib_compress_pages(struct address_space *mapping,
 	data_in = kmap(in_page);
 
 	out_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+	if (out_page == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	cpage_out = kmap(out_page);
 	pages[0] = out_page;
 	nr_pages = 1;
@@ -263,6 +267,10 @@ int btrfs_zlib_compress_pages(struct address_space *mapping,
 				goto out;
 			}
 			out_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+			if (out_page == NULL) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			cpage_out = kmap(out_page);
 			pages[nr_pages] = out_page;
 			nr_pages++;
-- 1.7.3.1 
