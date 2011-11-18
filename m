From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] 254: disable space cache
Date: Fri, 18 Nov 2011 16:43:47 +0800
Message-ID: <4EC61AC3.6010806@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: xfs@oss.sgi.com,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I can't pass 254, and below is the output:

254 3s ... - output mismatch (see 254.out.bad)
...
 ID 256 top level 5 path snap
-ID 257 top level 5 path subvol
+ID 258 top level 5 path subvol

When space cache is enabled (and now mkfs.btrfs always enables it),
there will be some space cache inodes in the root tree, and they
consume some IDs, and that's why "subvol" has the ID 258 but not 257.

Just disable space cache for this test case.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 254 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/254 b/254
index 5216120..1cd4832 100755
--- a/254
+++ b/254
@@ -48,7 +48,7 @@ _supported_os Linux
 _require_scratch
 
 _scratch_mkfs > /dev/null 2>&1
-_scratch_mount
+_scratch_mount -o nospace_cache
 
 # First test basic snapshotting
 echo "Creating file foo in root dir"
-- 
1.7.3.1
