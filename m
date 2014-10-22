Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48323 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaJVAcU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 20:32:20 -0400
Date: Wed, 22 Oct 2014 02:32:18 +0200
From: Petr Janecek <janecek@ucw.cz>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs-progs release 3.17
Message-ID: <20141022003217.GA15721@atrey.karlin.mff.cuni.cz>
References: <20141021212822.GA22009@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141021212822.GA22009@atrey.karlin.mff.cuni.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
      one more thing: I just overwrote part of one disk.
"btrfs filesystem show" could be more helpful diagnosing this:

# btrfs fi sh
Label: 'BTRFSROOT'  uuid: d877125e-9b8d-47ea-b57b-7411292fd26c
        Total devices 1 FS bytes used 2.91GiB
        devid    1 size 29.44GiB used 5.04GiB path /dev/sdi1

Label: 'BTR1'  uuid: 2ec4b5a1-a2c4-4687-9015-cf5b519297f3
        Total devices 3 FS bytes used 2.47TiB
        devid    1 size 3.64TiB used 1.79TiB path /dev/sdn
        devid    2 size 3.64TiB used 1.79TiB path /dev/sdo
        devid    3 size 3.64TiB used 1.79TiB path /dev/sdp

Label: 'BTR0'  uuid: 0ec83db3-4574-4e40-8d57-ebbe9fe246e1
        Total devices 4 FS bytes used 2.41TiB
        devid    1 size 2.73TiB used 1.21TiB path /dev/sda
        devid    2 size 2.73TiB used 1.21TiB path /dev/sdb
        devid    3 size 2.73TiB used 1.21TiB path /dev/sdc
        devid    4 size 2.73TiB used 1.21TiB path /dev/sdd

Label: 'BTR3'  uuid: 89f2016b-984f-4811-99d9-df3b8b5ce318
        Total devices 4 FS bytes used 896.00KiB
        devid    1 size 2.73TiB used 2.02GiB path /dev/sde
        devid    2 size 2.73TiB used 2.00GiB path /dev/sdf
        devid    3 size 2.73TiB used 1.01GiB path /dev/sdg
        devid    4 size 2.73TiB used 1.01GiB path /dev/sdh

warning, device 3 is missing
warning devid 3 not found already
Btrfs v3.17

-- there are three disks with devid 3, can't tell which one it is. The
fs uuid can be displayed with very little effort:

diff --git a/volumes.c b/volumes.c
index 5b007fc..02866bc 100644
--- a/volumes.c
+++ b/volumes.c
@@ -30,6 +30,7 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "math.h"
+#include "utils.h"
 
 struct stripe {
 	struct btrfs_device *dev;
@@ -1625,9 +1626,11 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 		map->stripes[i].dev = btrfs_find_device(root, devid, uuid,
 							NULL);
 		if (!map->stripes[i].dev) {
+			char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
+			uuid_unparse(root->fs_info->fsid, uuidbuf);
 			map->stripes[i].dev = fill_missing_device(devid);
-			printf("warning, device %llu is missing\n",
-			       (unsigned long long)devid);
+			printf("warning, device %llu from fs %s is missing\n",
+			       (unsigned long long)devid, uuidbuf);
 		}
 
 	}
@@ -1720,8 +1723,10 @@ static int read_one_dev(struct btrfs_root *root,
 
 	device = btrfs_find_device(root, devid, dev_uuid, fs_uuid);
 	if (!device) {
-		printk("warning devid %llu not found already\n",
-			(unsigned long long)devid);
+		char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
+		uuid_unparse(fs_uuid, uuidbuf);
+		printk("warning devid %llu from fs %s not found already\n",
+			(unsigned long long)devid, uuidbuf);
 		device = kzalloc(sizeof(*device), GFP_NOFS);
 		if (!device)
 			return -ENOMEM;


Regards,

Petr
