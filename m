From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH 7/7] made btrfs-vol compile. looks unused, so no speed class support here for now.
Date: Tue,  1 Feb 2011 14:54:50 +0100
Message-ID: <1296568490-13264-8-git-send-email-list.btrfs@jan-o-sch.net>
References: <1296568490-13264-1-git-send-email-list.btrfs@jan-o-sch.net>
Cc: chris.mason@oracle.com, sensille@gmx.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296568490-13264-1-git-send-email-list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 btrfs-vol.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/btrfs-vol.c b/btrfs-vol.c
index 4ed799d..138c69c 100644
--- a/btrfs-vol.c
+++ b/btrfs-vol.c
@@ -143,7 +143,8 @@ int main(int ac, char **av)
 		exit(1);
 	}
 	if (cmd == BTRFS_IOC_ADD_DEV) {
-		ret = btrfs_prepare_device(devfd, device, 1, &dev_block_count);
+		ret = btrfs_prepare_device(devfd, device, 1, &dev_block_count,
+		                           BTRFS_DEVCLASS_ALL);
 		if (ret) {
 			fprintf(stderr, "Unable to init %s\n", device);
 			exit(1);
-- 
1.7.2.2

