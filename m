Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:24081 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932576Ab3CDVkd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 16:40:33 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 13/14] btrfs-progs: better option/error handling for btrfs-vol
Date: Mon,  4 Mar 2013 16:40:03 -0600
Message-Id: <1362436804-16766-14-git-send-email-sandeen@redhat.com>
In-Reply-To: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Today wrong cmdlines give odd results:

	# ./btrfs-vol /dev/sdb1
	Unable to open device (null)
	# ./btrfs-vol -a /dev/sdb1
	usage: btrfs-vol [options] mount_point ...

Make it a bit more informative:

	# ./btrfs-vol /dev/sdb1
	No command specified
	usage: btrfs-vol [options] mount_point ...
	# ./btrfs-vol -a /dev/sdb1
	No mountpoint specified
	usage: btrfs-vol [options] mount_point ...

(even though it's deprecated ...)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 btrfs-vol.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/btrfs-vol.c b/btrfs-vol.c
index 3cc1c32..e37b41a 100644
--- a/btrfs-vol.c
+++ b/btrfs-vol.c
@@ -106,8 +106,13 @@ int main(int ac, char **av)
 		}
 	}
 	ac = ac - optind;
-	if (ac == 0)
+	if (ac == 0 || !cmd) {
+		if (!ac)
+			fprintf(stderr, "No mountpoint specified\n");
+		else
+			fprintf(stderr, "No command specified\n");
 		print_usage();
+	}
 	mnt = av[optind];
 
 	if (device && strcmp(device, "missing") == 0 &&
-- 
1.7.1

