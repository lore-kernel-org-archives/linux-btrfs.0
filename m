Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbaGYE1e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 00:27:34 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6P4RXdW020846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 00:27:33 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s6P4RWAV030851
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 00:27:33 -0400
Message-ID: <53D1DCB4.8090409@redhat.com>
Date: Thu, 24 Jul 2014 23:27:32 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] mkfs.btrfs: round all device sizes to sectorsize
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

make_btrfs() rounds down the first device size to a multiple of sectorsize:

	num_bytes = (num_bytes / sectorsize) * sectorsize;

but subsequent device adds don't.

This seems a bit odd & inconsistent, and it makes xfstest btrfs/011
_notrun(), because it explicitly checks that devices are the same size.

I don't know that there is anything inherently wrong with having
a few device bytes extend past the last block, but to be consistent,
it seems like btrfs_add_to_fsid() should round the size in the same
way.

And now btrfs/011 runs more consistently; the test devices don't
have to be sectorsize multiples in order for all mkfs'd device
sizes to match.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

ideally this might go into btrfs_device_size(), but we don't have
the chosen sector size anywhere near there...

diff --git a/utils.c b/utils.c
index e130849..4d7ee35 100644
--- a/utils.c
+++ b/utils.c
@@ -554,7 +554,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	device->sector_size = sectorsize;
 	device->fd = fd;
 	device->writeable = 1;
-	device->total_bytes = block_count;
+	device->total_bytes = (block_count / sectorsize) * sectorsize;
 	device->bytes_used = 0;
 	device->total_ios = 0;
 	device->dev_root = root->fs_info->dev_root;

