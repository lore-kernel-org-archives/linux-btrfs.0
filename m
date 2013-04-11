Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936298Ab3DKPoT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 11:44:19 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3BFiJCO031783
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Apr 2013 11:44:19 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r3BFiIcs020016
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Apr 2013 11:44:18 -0400
Message-ID: <5166DA52.7000809@redhat.com>
Date: Thu, 11 Apr 2013 10:44:18 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: use clearer var names in is_ssd()
References: <5166D932.5010105@redhat.com>
In-Reply-To: <5166D932.5010105@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

is_ssd() uses nondescript variable names; path - to what?
disk - it's a dev_t not a disk name, unlike dev, which is
a name not a dev_t!

Rename some vars to make things hopefully clearer:

 wholedisk - the name of the node for the entire disk
 devno - the dev_t of the device we're mkfs'ing
 sysfs_path - the path in sysfs we ultimately check

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Hopefully that's slightly clearer; if not, this patch is
just cleanup, so it's not at all critical.

diff --git a/mkfs.c b/mkfs.c
index 7df78fc..d735d65 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1216,9 +1216,9 @@ static int check_leaf_or_node_size(u32 size, u32 sectorsize)
 static int is_ssd(const char *file)
 {
 	blkid_probe probe;
-	char dev[32];
-	char path[PATH_MAX];
-	dev_t disk;
+	char wholedisk[32];
+	char sysfs_path[PATH_MAX];
+	dev_t devno;
 	int fd;
 	char rotational;
 
@@ -1227,18 +1227,19 @@ static int is_ssd(const char *file)
 		return 0;
 
 	/* Device number of this disk (possibly a partition) */
-	disk = blkid_probe_get_devno(probe);
-	if (!disk)
+	devno= blkid_probe_get_devno(probe);
+	if (!devno)
 		return 0;
 
 	/* Get whole disk name (not full path) for this devno */
-	blkid_devno_to_wholedisk(disk, dev, sizeof(dev), NULL);
+	blkid_devno_to_wholedisk(devno, wholedisk, sizeof(wholedisk), NULL);
 
-	snprintf(path, PATH_MAX, "/sys/block/%s/queue/rotational", dev);
+	snprintf(sysfs_path, PATH_MAX, "/sys/block/%s/queue/rotational",
+		 wholedisk);
 
 	blkid_free_probe(probe);
 
-	fd = open(path, O_RDONLY);
+	fd = open(sysfs_path, O_RDONLY);
 	if (fd < 0) {
 		return 0;
 	}


