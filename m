From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] btrfs/disk-io.c: quiet sparse noise; local functions should be static
Date: Fri, 9 Sep 2011 17:21:36 -0700
Message-ID: <201109091721.36577.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: <linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Local functions should be marked static. This quiets the following
sparse noise:

warning: symbol 'write_all_supers' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Chris Mason <chris.mason@oracle.com>
linux-btrfs@vger.kernel.org

---

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 64b1c07..573669d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2322,7 +2322,7 @@ static int write_dev_supers(struct btrfs_device *device,
 	return errors < i ? 0 : -1;
 }
 
-int write_all_supers(struct btrfs_root *root, int max_mirrors)
+static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
