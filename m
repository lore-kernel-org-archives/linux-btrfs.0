Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35495 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaCIMP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Mar 2014 08:15:28 -0400
Received: from merkaba.localnet (ppp-88-217-103-5.dynamic.mnet-online.de [88.217.103.5])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 3E7BAB8
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Mar 2014 13:13:43 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS SSD RAID 1: Does it trim on both devices? :)
Date: Sun, 09 Mar 2014 13:15:26 +0100
Message-ID: <1585266.SqtCUSphXX@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Since a few days this ThinkPad T520 has 780 GB SSD capacity. The 300 GB of
the Intel SSD 320 were almost full and that 480 GB Crucial m500 mSATA SSD
was cheap enough to just buy it.

I created a new logical volume for big and not that often changed files that
is just on the msata and moved all the music and photo files to it.

Then I thought I´d work in place, just shrink the /home volume on the Intel
SSD 320 and then add a similar sized volume on the Crucial and have it
rebalanced to metadata and data RAID 1. Unfortunately the shrinking hung
at some time. I didn´t check with a scrub afterward, but I rsync´d all
data to a newly created volume on the Crucial and then rebalanced the
other way around. Since the rsync didn´t show any I/O errors I suppose
the BTRFS with the shrink failure was still okay. I report this shrink
failure separately.

So now I have a BTRFS RAID 1 for /home and / and I wondered: Does BTRFS
trim on all devices on issuing fstrim?



Some details:

merkaba:~> btrfs fi show
Label: debian  uuid: […]
        Total devices 2 FS bytes used 15.89GiB
        devid    1 size 30.00GiB used 19.03GiB path /dev/mapper/sata-debian
        devid    2 size 30.00GiB used 19.01GiB path /dev/dm-2

Label: home  uuid: […]
        Total devices 2 FS bytes used 91.59GiB
        devid    1 size 150.00GiB used 102.00GiB path /dev/dm-0
        devid    2 size 150.00GiB used 102.00GiB path /dev/mapper/sata-home

Label: daten  uuid: […]
        Total devices 1 FS bytes used 148.36GiB
        devid    1 size 200.00GiB used 150.02GiB path /dev/mapper/msata-daten



merkaba:~> LANG=C df -hT -t btrfs
Filesystem              Type   Size  Used Avail Use% Mounted on
/dev/mapper/sata-debian btrfs   60G   32G   26G  56% /
/dev/dm-0               btrfs  300G  184G  113G  62% /home
/dev/mapper/sata-debian btrfs   60G   32G   26G  56% /mnt/debian-zeit
/dev/dm-0               btrfs  300G  184G  113G  62% /mnt/home-zeit
/dev/mapper/msata-daten btrfs  200G  149G   51G  75% /daten

(the "zeit" mounts show the root sub volume for snapshots)



merkaba:[…]> ./btrfs fi df /
Disk size:                60.00GB
Disk allocated:           38.04GB
Disk unallocated:         21.96GB
Used:                     15.89GB
Free (Estimated):         14.13GB       (Max: 25.10GB, min: 14.12GB)
Data to disk ratio:          50 %
merkaba:[…]> ./btrfs fi df /home
Disk size:               300.00GB
Disk allocated:          204.00GB
Disk unallocated:         96.00GB
Used:                     91.59GB
Free (Estimated):         58.41GB       (Max: 106.41GB, min: 58.41GB)
Data to disk ratio:          50 %



merkaba:[…]> ./btrfs device disk-usage /
/dev/dm-2          30.00GB
   Data,RAID1:              17.00GB
   Metadata,RAID1:           2.00GB
   System,RAID1:             8.00MB
   Unallocated:             10.99GB

/dev/mapper/sata-debian    30.00GB
   Data,Single:              8.00MB
   Data,RAID1:              17.00GB
   Metadata,Single:          8.00MB
   Metadata,RAID1:           2.00GB
   System,Single:            4.00MB
   System,RAID1:             8.00MB
   Unallocated:             10.97GB

merkaba:[…]> ./btrfs filesystem disk-usage -t /
                        Data   Data    Metadata Metadata System System             
                        Single RAID1   Single   RAID1    Single RAID1   Unallocated
                                                                                   
/dev/dm-2                    - 17.00GB        -   2.00GB      -  8.00MB     10.99GB
/dev/mapper/sata-debian 8.00MB 17.00GB   8.00MB   2.00GB 4.00MB  8.00MB     10.97GB
                        ====== ======= ======== ======== ====== ======= ===========
Total                   8.00MB 17.00GB   8.00MB   2.00GB 4.00MB  8.00MB     21.96GB
Used                      0.00 15.13GB     0.00 778.00MB   0.00 16.00KB 



merkaba:[…]> ./btrfs device disk-usage /home   
/dev/dm-0         150.00GB
   Data,RAID1:              98.00GB
   Metadata,RAID1:           4.00GB
   System,Single:            4.00MB
   Unallocated:             48.00GB

/dev/mapper/sata-home     150.00GB
   Data,RAID1:              98.00GB
   Metadata,RAID1:           4.00GB
   Unallocated:             48.00GB

merkaba:[…]> ./btrfs filesystem disk-usage -t /home
                      Data    Metadata System             
                      RAID1   RAID1    Single  Unallocated
                                                          
/dev/dm-0             98.00GB   4.00GB  4.00MB     48.00GB
/dev/mapper/sata-home 98.00GB   4.00GB       -     48.00GB
                      ======= ======== ======= ===========
Total                 98.00GB   4.00GB  4.00MB     96.00GB
Used                  89.60GB   1.99GB 16.00KB



And some healthly over prosioning:

merkaba:~> vgs
  VG    #PV #LV #SN Attr   VSize   VFree 
  msata   1   3   0 wz--n- 446,64g 66,64g
  sata    1   3   0 wz--n- 278,99g 86,99g

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
