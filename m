From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs-progs: make btrfsctl return values like everybody
	else
Date: Tue, 2 Feb 2010 09:52:53 -0500
Message-ID: <20100202145252.GA15957@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes btrfsctl return 0 for success and 1 for failure, which is the
behavior of all other userspace applications.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 btrfsctl.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/btrfsctl.c b/btrfsctl.c
index 66c4e89..73d9c30 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -231,9 +231,7 @@ int main(int ac, char **av)
 		printf("ioctl failed with error %d\n", ret);
 	}
 	printf("%s\n", BTRFS_BUILD_VERSION);
-	if (ret)
-		exit(0);
-	else
-		exit(1);
+
+	return ret ? 1 : 0;
 }
 
-- 
1.6.6

