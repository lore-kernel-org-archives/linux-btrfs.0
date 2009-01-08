From: jim owens <jowens@hp.com>
Subject: [PATCH] Btrfs: warn user that this release is experimental
Date: Thu, 08 Jan 2009 11:29:08 -0500
Message-ID: <496629D4.1080408@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Post wiki pointer message for getting version
status, limitations, and known problems.

Signed-off-by: jim owens <jowens@hp.com>
---
  mkfs.c |    3 +++
  1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index cb21db6..d664254 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -403,6 +403,9 @@ int main(int ac, char **av)
  	if (ac == 0)
  		print_usage();

+	printf("\nWARNING! - %s IS EXPERIMENTAL\n", BTRFS_BUILD_VERSION);
+	printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
+
  	file = av[optind++];
  	ret = check_mounted(file);
  	if (ret < 0) {
-- 
1.5.4.3

