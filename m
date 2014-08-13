Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38736 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaHMAO6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 20:14:58 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7D0EuEd008559
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 00:14:57 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7D0EtiW009074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 00:14:56 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7D0Etfb023880
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 00:14:55 GMT
From: Guangyu Sun <guangyu.sun@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: don't zero dev if dev size is smaller than -r rootdir size
Date: Tue, 12 Aug 2014 17:13:55 -0700
Message-Id: <1407888835-15739-2-git-send-email-guangyu.sun@oracle.com>
In-Reply-To: <1407888835-15739-1-git-send-email-guangyu.sun@oracle.com>
References: <1407888835-15739-1-git-send-email-guangyu.sun@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Even if the size of rootdir given by -r option is larger than the
specified partition, zero_output_file() is still called. It will take
time to fill up the partition with zero if the partition is big, and
end up with an EIO.

The size should be checked before zeroing the partition.

Signed-off-by: Guangyu Sun <guangyu.sun@oracle.com>
---
 mkfs.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mkfs.c b/mkfs.c
index 71aea40..ea61180 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1475,12 +1475,31 @@ int main(int ac, char **av)
 			exit(1);
 		}
 	} else {
+		struct stat st;
+		u64 size;
+
 		fd = open_target(file);
 		if (fd < 0) {
 			fprintf(stderr, "unable to open the %s\n", file);
 			exit(1);
 		}
 
+		if (fstat(fd, &st) < 0) {
+			fprintf(stderr, "unable to stat %s\n", file);
+			exit(1);
+		}
+
+		size = btrfs_device_size(fd, &st);
+		if (size == 0) {
+			fprintf(stderr, "unable to find %s size\n", file);
+			exit(1);
+		}
+
+		if (size < block_count) {
+			fprintf(stderr, "%s is smaller than requested size\n", file);
+			exit(1);
+		}
+
 		first_file = file;
 		ret = zero_output_file(fd, block_count, sectorsize);
 		if (ret) {
-- 
1.7.9.5

