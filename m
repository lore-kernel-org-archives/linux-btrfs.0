Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39743 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3LVMjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Dec 2013 07:39:45 -0500
Received: from merkaba.localnet (ppp-88-217-103-226.dynamic.mnet-online.de [88.217.103.226])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id DF2ED11E
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Dec 2013 13:32:47 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Abysmal performance when doing a rm -r and rsync backup at the same time
Date: Sun, 22 Dec 2013 13:32:46 +0100
Message-ID: <2051639.8xYU6F6UDf@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Today I started my backup script which rsync´s my system to an external 3,5 
inch 2 TB harddisk with the wrong destination dir which I notices more than 
150 GiB of data has been copied twice instead of diffing with an existing 
subvolume.

Thus I rm -rf the misplaced backup and started the backup script at the same 
time before taking a bath. After the bath both the backup script and the rm -
rf were still running. Disk was 100% utilizized and it didn´t seem to go 
anywhere. Source of the backup was /home on an Intel SSD 320 which easily 
outperforms the harddisk.

I tried to look how much rm -rf already has deleted with du -sch but that du 
didn´t really like to complete as well. rm, rsync and du were often in D 
process state.

Then I stopped the backup script and the rm and let the disk settle for a few 
moments. After it has settled down I did the du -sch and about 150 GiB of data 
were still undeleted. There could only have been less than 239 GiB of data in 
there cause the home directory isn´t bigger than that and the rsync backup has 
not yet been completed. So most of the rm work was not yet done.

Well I run the rm command again and it completed rather quickly, say 10 
seconds or so.

Then I started the backup script and it already completed /home. Also quite 
quickly.


Is such a performance of a rsync versus rm -r issue known?

I have no exact measurements, but it virtually took ages. Harddisk was fully 
utilized, but I didn´t look closely at any throughput or IOPS numbers.


Kernel in use:

martin@merkaba:~> cat /proc/version
Linux version 3.13.0-rc4-tp520 (martin@merkaba) (gcc version 4.8.2 (Debian 
4.8.2-10) ) #39 SMP PREEMPT Tue Dec 17 13:57:12 CET 2013


Characteristics of backup data:

About 239 GiB, lzo compressed with lots of small mail files (easily a million), 
but also larger music files.

martin@merkaba:~> find -type d | wc -l
36359
martin@merkaba:~> find -type f | wc -l
1090049
martin@merkaba:~> find -type l | wc -l
1337


Mount info:

martin@merkaba:~> egrep "(home |steigerwald).*btrfs" /proc/mounts 
/dev/dm-1 /home btrfs rw,noatime,compress=lzo,ssd,space_cache 0 0
/dev/sdc1 /mnt/steigerwald btrfs 
rw,relatime,compress=lzo,space_cache,autodefrag 0 0


Subvolume amount:

General, most of them are snapshots:

merkaba:/mnt/steigerwald> btrfs subvol list .  | wc -l
32

Of which are snapshots:

merkaba:/mnt/steigerwald> btrfs subvol list . | grep -- -20 | wc -l 
23

Subvolume merkaba where the backup went into after fixing the path and its 
snapshots:

merkaba:/mnt/steigerwald> btrfs subvol list . | grep merkaba | wc -l 
13


This is the situation after the rm and most of the backup (just some small 
remote server left) has been completed:

# ./btrfs filesystem disk-usage -t /mnt/steigerwald
          Data   Metadata Metadata System System              
          Single Single   DUP      Single DUP      Unallocated
                                                              
/dev/sdc1 1.43TB   8.00MB  76.00GB 4.00MB  16.00MB    322.98GB
          ====== ======== ======== ====== ======== ===========
Total     1.43TB   8.00MB  38.00GB 4.00MB   8.00MB    322.98GB
Used      1.25TB     0.00  12.45GB   0.00 168.00KB

# ./btrfs device disk-usage /mnt/steigerwald
/dev/sdc1           1.82TB
   Data,Single:              1.43TB
   Metadata,Single:          8.00MB
   Metadata,DUP:            76.00GB
   System,Single:            4.00MB
   System,DUP:              16.00MB
   Unallocated:            322.98GB


# ./btrfs filesystem df /mnt/steigerwald
Disk size:                 1.82TB
Disk allocated:            1.50TB
Disk unallocated:        322.98GB
Used:                      1.26TB
Free (Estimated):        521.48GB       (Max: 529.46GB, min: 367.96GB)
Data to disk ratio:          98 %


(yeah I still love the patches by Goffredo regarding disk-usage output :)


# btrfs fi show
Label: 'steigerwald'  uuid: …
        Total devices 1 FS bytes used 1.26TB
        devid    1 size 1.82TB used 1.50TB path /dev/sdc1


Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
