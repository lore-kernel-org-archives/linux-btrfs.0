Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab3A2Uca (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 15:32:30 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0TKWUT0011801
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2013 15:32:30 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r0TKWSga009083
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2013 15:32:29 -0500
Message-ID: <510831DC.4070709@redhat.com>
Date: Tue, 29 Jan 2013 14:32:28 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: fix mkfs.btrfs -r option
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 605e806166847872bb91831b397d58f95027975a broke the
mkfs.btrfs -r option, because it calls make_btrfs
without ever setting dev_block_count, in the -r case,
so we tell it to make a filesystem of size 0.

Then we wander into ENOSPC land and segfault.

As a quick one-line-fix, just set the dev_block_count
to the size of the destination image file.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs.c b/mkfs.c
index fbf8319..940702d 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1337,6 +1337,8 @@ int main(int ac, char **av)
 			fprintf(stderr, "unable to zero the output file\n");
 			exit(1);
 		}
+		/* our "device" is the new image file */
+		dev_block_count = block_count;
 	}
 	if (mixed) {
 		if (metadata_profile != data_profile) {

