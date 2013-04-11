Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840Ab3DKPjb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 11:39:31 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3BFdVk1001069
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Apr 2013 11:39:31 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r3BFdUhC017753
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Apr 2013 11:39:30 -0400
Message-ID: <5166D932.5010105@redhat.com>
Date: Thu, 11 Apr 2013 10:39:30 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: replace blkid_probe_get_wholedisk_devno
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

blkid_probe_get_wholedisk_devno() isn't available in some older
versions of libblkid.  It was used to work around an old
bug in blkid_devno_to_wholedisk(), but that has been fixed since
5cd0823 libblkid: fix blkid_devno_to_wholedisk(), present in
util-linux 2.17 and beyond.

If we happen to be missing that fix, the worst that happens is
that we'd fail to detect that a device is an ssd; the upside is
that this code compiles on older systems.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs.c b/mkfs.c
index c8cb395..7df78fc 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1215,9 +1215,8 @@ static int check_leaf_or_node_size(u32 size, u32 sectorsize)
 
 static int is_ssd(const char *file)
 {
-	char *devname;
 	blkid_probe probe;
-	char *dev;
+	char dev[32];
 	char path[PATH_MAX];
 	dev_t disk;
 	int fd;
@@ -1227,24 +1226,16 @@ static int is_ssd(const char *file)
 	if (!probe)
 		return 0;
 
-	/*
-	 * We want to use blkid_devno_to_wholedisk() but it's broken for some
-	 * reason on F17 at least so we'll do this trickery
-	 */
-	disk = blkid_probe_get_wholedisk_devno(probe);
+	/* Device number of this disk (possibly a partition) */
+	disk = blkid_probe_get_devno(probe);
 	if (!disk)
 		return 0;
 
-	devname = blkid_devno_to_devname(disk);
-	if (!devname)
-		return 0;
-
-	dev = strrchr(devname, '/');
-	dev++;
+	/* Get whole disk name (not full path) for this devno */
+	blkid_devno_to_wholedisk(disk, dev, sizeof(dev), NULL);
 
 	snprintf(path, PATH_MAX, "/sys/block/%s/queue/rotational", dev);
 
-	free(devname);
 	blkid_free_probe(probe);
 
 	fd = open(path, O_RDONLY);


