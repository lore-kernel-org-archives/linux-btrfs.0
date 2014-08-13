Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38737 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaHMAO6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 20:14:58 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7D0EueE008557
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 00:14:57 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7D0EtmO017698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 00:14:56 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7D0EtTl023865
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 00:14:55 GMT
From: Guangyu Sun <guangyu.sun@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: force mixed groups when -r rootdir is small
Date: Tue, 12 Aug 2014 17:13:54 -0700
Message-Id: <1407888835-15739-1-git-send-email-guangyu.sun@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mkfs.btrfs did not force mixed data/metadata groups if the size of
rootdir given by -r option is small.

 # mkdir -p /tmp/mydir
 # echo "aaa" > /tmp/mydir/myfile
 # mkfs.btrfs -f -r /tmp/mydir /dev/sdb1
 ...
 fs created label (null) on /dev/sdb1
 	nodesize 16384 leafsize 16384 sectorsize 4096 size 28.00MiB
 ...

leafsize and sectorsize are different means it is not using mixed
groups.

after this patch:

 # mkfs.btrfs -f -r /tmp/mydir /dev/sdb1
 ...
 Turning ON incompat feature 'mixed-bg': mixed data and metadata block
 groups
 ...
 fs created label (null) on /dev/sdb1
 	nodesize 4096 leafsize 4096 sectorsize 4096 size 28.00MiB
 ...

Also the size check in option -b is inconsistent with other similar
size checks in utils.c. Make it consistent by removing '='.

Signed-off-by: Guangyu Sun <guangyu.sun@oracle.com>
---
 mkfs.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 16e9222..71aea40 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1332,11 +1332,6 @@ int main(int ac, char **av)
 				break;
 			case 'b':
 				block_count = parse_size(optarg);
-				if (block_count <= 1024*1024*1024) {
-					printf("SMALL VOLUME: forcing mixed "
-					       "metadata/data groups\n");
-					mixed = 1;
-				}
 				zero_end = 0;
 				break;
 			case 'V':
@@ -1388,6 +1383,18 @@ int main(int ac, char **av)
 		mixed = 1;
 	}
 
+	if (source_dir_set) {
+		source_dir_size = size_sourcedir(source_dir, sectorsize,
+					     &num_of_meta_chunks, &size_of_data);
+		if (block_count < source_dir_size)
+			block_count = source_dir_size;
+	}
+
+	if (block_count && block_count < 1024 * 1024 * 1024 && !mixed) {
+		printf("SMALL VOLUME: forcing mixed metadata/data groups\n");
+		mixed = 1;
+	}
+
 	/*
 	* Set default profiles according to number of added devices.
 	* For mixed groups defaults are single/single.
@@ -1475,10 +1482,6 @@ int main(int ac, char **av)
 		}
 
 		first_file = file;
-		source_dir_size = size_sourcedir(source_dir, sectorsize,
-					     &num_of_meta_chunks, &size_of_data);
-		if(block_count < source_dir_size)
-			block_count = source_dir_size;
 		ret = zero_output_file(fd, block_count, sectorsize);
 		if (ret) {
 			fprintf(stderr, "unable to zero the output file\n");
-- 
1.7.9.5

