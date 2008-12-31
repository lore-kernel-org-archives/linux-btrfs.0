From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] Btrfs-progs: btrfs file system size should be bigger then
 256m
Date: Wed, 31 Dec 2008 14:12:36 +0800
Message-ID: <495B0D54.7060806@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

According to btrfs_prepare_device, btrfs file sysstem size
should be bigger then 256m.

If mkfs.btrfs specifies the file system size samaller then
that, mkfs.btrfs should report error.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 mkfs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index be93aaa..447e8d7 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -377,6 +377,10 @@ int main(int ac, char **av)
 				break;
 			case 'b':
 				block_count = parse_size(optarg);
+				if (block_count < 256*1024*1024) {
+					fprintf(stderr, "File system size is too small\n");
+					exit(1);
+				}
 				zero_end = 0;
 				break;
 			default:
-- 
1.6.0.6
