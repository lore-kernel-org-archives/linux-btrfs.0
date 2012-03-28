From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] btrfs-progs: enforce block count on all devices in mkfs
Date: Wed, 28 Mar 2012 14:20:52 -0400
Message-ID: <1332958852-5953-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I had a test that creates a 7gig raid1 device but it was ending up wonky
because the second device that gets added is the full size of the disk
instead of the limited size.  So enforce the limited size on all disks
passed in at mkfs time, otherwise our threshold calculations end up wonky
when doing chunk allocations.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 mkfs.c  |    1 +
 utils.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index c531ef2..6ae412f 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1404,6 +1404,7 @@ int main(int ac, char **av)
 			close(fd);
 			continue;
 		}
+		dev_block_count = block_count;
 		ret = btrfs_prepare_device(fd, file, zero_end,
 					   &dev_block_count, &mixed);
 		mixed = old_mixed;
diff --git a/utils.c b/utils.c
index ee7fa1b..552233b 100644
--- a/utils.c
+++ b/utils.c
@@ -555,6 +555,8 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 		fprintf(stderr, "unable to find %s size\n", file);
 		exit(1);
 	}
+	if (*block_count_ret)
+		block_count = min(block_count, *block_count_ret);
 	zero_end = 1;
 
 	if (block_count < 1024 * 1024 * 1024 && !(*mixed)) {
-- 
1.7.5.2

