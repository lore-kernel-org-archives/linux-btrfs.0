From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] 254: fix to pass subvolid=0 to set default btrfs subvolme
Date: Fri, 18 Nov 2011 11:26:18 +0800
Message-ID: <4EC5D05A.4000503@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: xfs@oss.sgi.com,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The usage is 'btrfs subvolume set-default <id> <path>', not
'<path> <path>'.

The code happens to work because strotoull(path) returns 0, but it
will fail if in the future we check the argument more strict in
btrfs-progs.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 254 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/254 b/254
index 6320291..5216120 100755
--- a/254
+++ b/254
@@ -78,7 +78,7 @@ ls $SCRATCH_MNT/subvol
 echo "Creating file bar in subvol"
 dd if=/dev/zero of=$SCRATCH_MNT/subvol/bar bs=1M count=1 &> /dev/null
 echo "Setting subvol to the default"
-btrfs subvolume set-default $SCRATCH_MNT/subvol $SCRATCH_MNT/subvol | _filter_scratch
+btrfs subvolume set-default 0 $SCRATCH_MNT/subvol | _filter_scratch
 _scratch_remount
 echo "List root dir which is now subvol"
 ls $SCRATCH_MNT
@@ -88,7 +88,7 @@ _scratch_mount "-o subvolid=0"
 echo "List root dir"
 ls $SCRATCH_MNT
 echo "Setting the root dir as the default again"
-btrfs subvolume set-default $SCRATCH_MNT $SCRATCH_MNT | _filter_scratch
+btrfs subvolume set-default 0 $SCRATCH_MNT | _filter_scratch
 _scratch_remount
 echo "List root dir"
 ls $SCRATCH_MNT
-- 1.7.3.1 
