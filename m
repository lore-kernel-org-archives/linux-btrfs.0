Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:34474 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752065AbcKINDH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 08:03:07 -0500
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
        by len.romanrm.net (Postfix) with SMTP id 1860D2F0B6
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Nov 2016 13:03:02 +0000 (UTC)
Date: Wed, 9 Nov 2016 18:03:01 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [RFC] [PATCH] Mounting "degraded,rw" should allow for any number of
 devices missing
Message-ID: <20161109180301.17aa7726@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Mounting "degraded,rw" should allow for any number of devices missing, as in
many cases the current check seems overly strict and not helpful during what
is already a manual recovery scenario. Let's assume the user applying the
"degraded" option knows best what condition their FS is in and what are the
next steps required to recover from the degraded state.

Specifically this would allow salvaging "JBOD-style" arrays of data=single
metadata=RAID1, if the user is ready to accept loss of data portions which
were on the removed drive. Currently if one of the disks got removed it is not
possible for such array to be mounted rw at all -- hence not possible to
"dev delete missing" and the only solution is to recreate the FS.

Besides, I am currently testing a concept of SSD+HDD array with data=single
and metadata=RAID1, where the SSD is used for RAID1 metadata chunks only.
E.g. my 13 TB FS only has about 14 GB of metadata at the moment, so I could
comfortably use a spare 60GB SSD as a metadata-only device for it.
(Making all metadata reads prefer SSD could be the next step.)
It would be nice to be able to just lose/fail/forget that SSD, without having
to redo the entire FS. But again, since the remaining device has data=single,
currently it won't be write-mountable in the degraded state, even though the
missing device had only ever contained RAID1 chunks.

Maybe someone has other ideas how to solve the above scenarios?

Thanks

--- linux-amd64-4.4/fs/btrfs/disk-io.c.orig	2016-11-09 16:19:50.431117913 +0500
+++ linux-amd64-4.4/fs/btrfs/disk-io.c	2016-11-09 16:20:31.567117874 +0500
@@ -2992,7 +2992,8 @@
 		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
 	if (fs_info->fs_devices->missing_devices >
 	     fs_info->num_tolerated_disk_barrier_failures &&
-	    !(sb->s_flags & MS_RDONLY)) {
+	    !(sb->s_flags & MS_RDONLY) &&
+	    !btrfs_raw_test_opt(fs_info->mount_opt, DEGRADED)) {
 		pr_warn("BTRFS: missing devices(%llu) exceeds the limit(%d), writeable mount is not allowed\n",
 			fs_info->fs_devices->missing_devices,
 			fs_info->num_tolerated_disk_barrier_failures);
