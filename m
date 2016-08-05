Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:35574 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbcHEHqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Aug 2016 03:46:36 -0400
Received: by mail-lf0-f41.google.com with SMTP id f93so198250003lfi.2
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Aug 2016 00:46:35 -0700 (PDT)
MIME-Version: 1.0
From: Mordechay Kaganer <mkaganer@gmail.com>
Date: Fri, 5 Aug 2016 10:46:33 +0300
Message-ID: <CA+xOVSMz0PvC0m3NDRS1AmE_ZD0tnbV077Ggc7AnL9ytMTdupQ@mail.gmail.com>
Subject: BTRFS: Transaction aborted (ENOSPC)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

B.H.

Hello. I have a setup with 4 RAID10 arrays, 4 drives each (using md).
Device usage is as follows:

# btrfs device usage /storage/bkp1
/dev/md1, ID: 1
   Device size:            10.92TiB
   Device slack:              0.00B
   Data,single:            10.19TiB
   Metadata,RAID1:        199.00GiB
   System,RAID1:            8.00MiB
   Unallocated:           542.79GiB

/dev/md2, ID: 2
   Device size:            10.92TiB
   Device slack:              0.00B
   Data,single:            10.21TiB
   Metadata,RAID1:        181.00GiB
   System,RAID1:            8.00MiB
   Unallocated:           541.80GiB

/dev/md3, ID: 3
   Device size:            10.92TiB
   Device slack:              0.00B
   Data,single:            10.41TiB
   Metadata,RAID1:         65.00GiB
   Unallocated:           457.81GiB

/dev/md4, ID: 4
   Device size:            10.92TiB
   Device slack:              0.00B
   Data,single:             9.89TiB
   Metadata,RAID1:         89.00GiB
   Unallocated:           959.81GiB

Mount options: compress=zlib,commit=60,noatime

This setup is used to store regular backups from 2 different sites
(each on different subvolume with regular snapshots). The backup is
done using rsync as the source storage is using xfs not btrfs. This
setup has been working excellently for about 7 months. Curently, it
has about 100 snapshots in total.
Recently, i've started to face problems with "transaction aborted"
messages and volume going read-only. This happens unexpectedly, after
several hours of rsync running.

As a precursor, it throws several warnings about tasks blocked for 120
seconds, this is probably connected to a long time required to commit
transaction.

After transaction abort, i reboot the server, then restart the backup
and it seems to continue OK until the next crash.

Scrub didn't find and errors on the volume. I'm unable to run btrfs
check as it consumes all of the RAM and crashes.

Any suggestions what's going wrong and how to fix this?

# uname -a
Linux yemot-4u 4.4.0-31-generic #50-Ubuntu SMP Wed Jul 13 00:07:12 UTC
2016 x86_64 x86_64 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.7

Thanks in advance!

-- 
משיח NOW!
Moshiach is coming very soon, prepare yourself!
יחי אדוננו מורינו ורבינו מלך המשיח לעולם ועד!
