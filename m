Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62501 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761223Ab2EQOVD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 10:21:03 -0400
Received: by yenm10 with SMTP id m10so1806219yen.19
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2012 07:21:02 -0700 (PDT)
Message-ID: <4FB5094C.30407@webstarts.com>
Date: Thu, 17 May 2012 10:21:00 -0400
From: Jim <jim@webstarts.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Btrfs storage advice
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi btrfs list,
I am looking for some counsel regarding how to best (and most safely) 
utilize extra space on my btrfs installation.  I set up a btrfs 
installation about 6 months ago.  I wanted to test the system while 
waiting for mainline acceptance and support.  The machine being used has 
13 1Tb drives.  12 as a btrfs collection (stripe data, mirror metadata) 
and 1 ext4 as a system drive.  We are running kernel 3.2.0-rc4.  I know 
that it is not the latest, but it has been extremely stable for our 
needs.  Currently the system holds backup files.  2 other filesystems 
are nfs mounts on the machine and backups are created by rsyncing these 
mounts onto btrfs.  The btrfs copies are also snapshotted, so 2 copies 
exist of backup data.  I have added the output of btrfs fi show and 
btrfs fi df below so you can see the layout, as well as a standard df 
-h.  As will be readily apparent, my nfs disks are approaching storage 
limits.  Due to financial constraints I must use the space on the btrfs 
system for nfs storage.  My first thought is to take 3 or 4 T as a 
subvol and export it as nfs.  I have not heard of anyone else exporting 
btrfs, is it possible?  Next idea is to split several drives off the 
btrfs system.  I have removed drives and replaced them as experiments 
with the fs but had much less data on them when I was trying that.  I 
have read many times on the list, about size issues with btrfs, and 
filesystems reporting full when they were far from it.  As my system has 
been very stable just r/w data and creating and removing subvols, I am 
reluctant to change the disk layout, but we will do what we have to.  
Also, if I split disks out they could be mirrored, like our other nfs 
systems.  However, I can stand a small amount of filesystem downtime.  
Therefore to maximize space we may look at not mirroring the segment but 
just mount a backup snapshot if a main fs drive goes out.  Final 
question is what about backup space.  Regardless of how I structure the 
new storage segment, it will need to be backed up with the rest of the 
system.  Once again, I am between maximizing available storage and 
leaving breathing room for btrfs.  As I currently backup over 4T on 
btrfs perhaps I should only allocate 2T for new storage thus creating 2T 
storage, 6+T backup and 1+T breathing room.  I am not in a panic 
situation, but I will need to create the new storage over the next 2 
months.  I would really appreciate any feed back and comments concerning 
this operation.  Thanks in advance.
Jim Maloney

[root@btrfs ~]# btrfs fi show
failed to read /dev/sr0
Label: none  uuid: c21f1221-a224-4ba4-92e5-cdea0fa6d0f9
         Total devices 12 FS bytes used 4.62TB
         devid   12 size 930.99GB used 414.75GB path /dev/sdl
         devid   11 size 930.99GB used 414.75GB path /dev/sdk
         devid   10 size 930.99GB used 414.99GB path /dev/sdj
         devid    9 size 930.99GB used 414.99GB path /dev/sdi
         devid    5 size 930.99GB used 414.99GB path /dev/sde
         devid    2 size 930.99GB used 414.74GB path /dev/sdb
         devid    1 size 930.99GB used 414.76GB path /dev/sda
         devid    7 size 930.99GB used 414.99GB path /dev/sdg
         devid    3 size 930.99GB used 414.74GB path /dev/sdc
         devid    4 size 930.99GB used 414.74GB path /dev/sdd
         devid    6 size 930.99GB used 414.99GB path /dev/sdf
         devid    8 size 930.99GB used 414.99GB path /dev/sdh

[root@btrfs ~]# btrfs fi df /btrfs
Data, RAID0: total=4.54TB, used=4.50TB
Data: total=8.00MB, used=0.00
System, RAID1: total=8.00MB, used=324.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=164.25GB, used=122.97GB
Metadata: total=8.00MB, used=0.00

[root@btrfs ~]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdm2             196G   49G  138G  26% /
tmpfs                  16G     0   16G   0% /dev/shm
/dev/sdm1             2.0G  137M  1.8G   8% /boot
/dev/sdm5             1.2T   19G  1.1T   2% /var
/dev/sda               11T  4.8T  6.1T  44% /btrfs
10.2.0.42:/data/sites
                       2.6T  2.1T  388G  85% /nfs2/data/sites
10.2.0.40:/data/sites
                       2.6T  2.3T  218G  92% /nfs1/data/sites


