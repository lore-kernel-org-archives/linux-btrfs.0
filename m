Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:58569 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDNIla (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 04:41:30 -0400
Received: by mail-ee0-f53.google.com with SMTP id b57so6302197eek.12
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Apr 2014 01:41:29 -0700 (PDT)
Message-ID: <534B9F35.6050008@gmail.com>
Date: Mon, 14 Apr 2014 11:41:25 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
CC: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, alanqk@gmail.com,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: Test results for [RFC PATCH v10 00/16] Online(inband) data deduplication
References: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Here are the test results from my testing of the latest patches of btrfs 
dedup.

TLDR;
I rsynced 10 separate copies of a 3.8GB folder with 138 RAW photographs 
(23-36MiB) on a btrfs volume with dedup enabled.
On the first try, the copy was very slow, and a sync after that took 
over 10 minutes to complete.
For the next copies sync was much faster, but still took up to one 
minute to complete.
The copy itself was quite slow, until the fifth try when it went from 
8MB/sec to 22-40MB/sec.
Each copy after the first consumed about 60-65MiB of metadata, or 
120-130MiB of free space due to metadata being DUP.

Obvious question:
Can dedup recognize that 2 files are the same and dedup them on a file 
level, saving much more space in the process?

In any case I am very thankful of the work being done here, and i am 
willing to help in any way i can.




AMD Phenom(tm) II X4 955 Processor
MemTotal:  8 GB
Hard Disk: Seagate Barracuda 7200.12 [160 GB]
kernel: 3.14.0-1-git

$ mkfs.btrfs /dev/loop0 -f && mount /storage/btrfs_dedup && mount |grep 
dedup && btrfs dedup enable /storage/btrfs_dedup && btrfs dedup on 
/storage/btrfs_dedup && for i in {01..10}; do time rsync -a 
/storage/btrfs/costas/Photo_library/2014/ /storage/btrfs_dedup/copy$i/ 
--stats && time btrfs fi sync /storage/btrfs_dedup/ && df 
/storage/btrfs_dedup/ && btrfs fi df /storage/btrfs_dedup ; done && time 
umount /storage/btrfs_dedup

/root/btrfs.img on /storage/btrfs_dedup type btrfs 
(rw,noatime,nodiratime,space_cache)

sent 4,017,134,246 bytes  received 2,689 bytes  8,274,226.44 bytes/sec
rsync -a /storage/btrfs/costas/Photo_library/2014/  --stats  21.85s user 
45.04s system 13% cpu 8:05.48 total
btrfs fi sync /storage/btrfs_dedup/  0.00s user 0.36s system 0% cpu 
10:43.27 total
/dev/loop1         46080  4119     40173  10% /storage/btrfs_dedup
Data, single: total=4.01GiB, used=3.74GiB
Metadata, DUP: total=1.00GiB, used=143.45MiB

sent 4,017,134,246 bytes  received 2,689 bytes  8,956,827.06 bytes/sec
rsync -a /storage/btrfs/costas/Photo_library/2014/  --stats  21.29s user 
42.32s system 14% cpu 7:28.74 total
btrfs fi sync /storage/btrfs_dedup/  0.00s user 0.01s system 0% cpu 
4.173 total
/dev/loop1         46080  4250     40173  10% /storage/btrfs_dedup
Data, single: total=5.01GiB, used=3.74GiB
Metadata, DUP: total=1.00GiB, used=208.72MiB

sent 4,017,134,246 bytes  received 2,689 bytes  9,691,524.57 bytes/sec
rsync -a /storage/btrfs/costas/Photo_library/2014/  --stats  20.95s user 
31.69s system 12% cpu 6:54.90 total
btrfs fi sync /storage/btrfs_dedup/  0.00s user 0.00s system 0% cpu 
3.254 total
/dev/loop1         46080  4371     40172  10% /storage/btrfs_dedup
Data, single: total=5.01GiB, used=3.74GiB
Metadata, DUP: total=1.00GiB, used=269.39MiB

sent 4,017,134,246 bytes  received 2,689 bytes  9,037,428.43 bytes/sec
rsync -a /storage/btrfs/costas/Photo_library/2014/  --stats  20.54s user 
36.70s system 12% cpu 7:23.93 total
btrfs fi sync /storage/btrfs_dedup/  0.00s user 0.01s system 0% cpu 
5.578 total
/dev/loop1         46080  4497     40172  11% /storage/btrfs_dedup
Data, single: total=5.01GiB, used=3.74GiB
Metadata, DUP: total=1.00GiB, used=331.98MiB

sent 4,017,134,246 bytes  received 2,689 bytes  29,004,598.81 bytes/sec
rsync -a /storage/btrfs/costas/Photo_library/2014/  --stats  22.30s user 
13.01s system 25% cpu 2:18.15 total
btrfs fi sync /storage/btrfs_dedup/  0.00s user 0.01s system 0% cpu 
23.447 total
/dev/loop1         46080  4617     40172  11% /storage/btrfs_dedup
Data, single: total=5.01GiB, used=3.74GiB
Metadata, DUP: total=1.00GiB, used=391.91MiB

sent 4,017,134,246 bytes  received 2,689 bytes  39,971,511.79 bytes/sec
rsync -a /storage/btrfs/costas/Photo_library/2014/  --stats  21.60s user 
11.85s system 33% cpu 1:39.74 total
btrfs fi sync /storage/btrfs_dedup/  0.00s user 0.01s system 0% cpu 
32.178 total
/dev/loop1         46080  4747     40171  11% /storage/btrfs_dedup
Data, single: total=5.01GiB, used=3.74GiB
Metadata, DUP: total=1.00GiB, used=456.48MiB

sent 4,017,134,246 bytes  received 2,689 bytes  32,009,059.24 bytes/sec
rsync -a /storage/btrfs/costas/Photo_library/2014/  --stats  25.68s user 
13.94s system 31% cpu 2:04.42 total
btrfs fi sync /storage/btrfs_dedup/  0.00s user 0.01s system 0% cpu 
29.313 total
/dev/loop1         46080  4870     40171  11% /storage/btrfs_dedup
Data, single: total=5.01GiB, used=3.74GiB
Metadata, DUP: total=1.00GiB, used=518.09MiB

sent 4,017,134,246 bytes  received 2,689 bytes  30,782,658.51 bytes/sec
rsync -a /storage/btrfs/costas/Photo_library/2014/  --stats  21.84s user 
12.63s system 26% cpu 2:10.20 total
btrfs fi sync /storage/btrfs_dedup/  0.00s user 0.00s system 0% cpu 
41.074 total
/dev/loop1         46080  4990     40171  12% /storage/btrfs_dedup
Data, single: total=5.01GiB, used=3.74GiB
Metadata, DUP: total=1.00GiB, used=578.16MiB

sent 4,017,134,246 bytes  received 2,689 bytes  22,379,592.95 bytes/sec
rsync -a /storage/btrfs/costas/Photo_library/2014/  --stats  28.57s user 
18.61s system 26% cpu 2:59.07 total
btrfs fi sync /storage/btrfs_dedup/  0.00s user 0.01s system 0% cpu 
55.714 total
/dev/loop1         46080  5114     40171  12% /storage/btrfs_dedup
Data, single: total=5.01GiB, used=3.74GiB
Metadata, DUP: total=1.00GiB, used=639.95MiB

sent 4,017,134,246 bytes  received 2,689 bytes  28,591,721.96 bytes/sec
rsync -a /storage/btrfs/costas/Photo_library/2014/  --stats  23.79s user 
15.97s system 28% cpu 2:20.61 total
btrfs fi sync /storage/btrfs_dedup/  0.00s user 0.01s system 0% cpu 
1:01.82 total
/dev/loop1         46080  5240     40170  12% /storage/btrfs_dedup
Data, single: total=5.01GiB, used=3.74GiB
Metadata, DUP: total=1.00GiB, used=702.59MiB

umount /storage/btrfs_dedup  0.00s user 0.60s system 59% cpu 1.007 total


