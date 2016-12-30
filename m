Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 162-144-52-249.unifiedlayer.com ([162.144.52.249]:45752 "EHLO
        cl65.servermonkeys.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbcL3BXd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Dec 2016 20:23:33 -0500
Received: from cpe-104-231-13-247.cinci.res.rr.com ([104.231.13.247]:40110 helo=[10.1.10.13])
        by cl65.servermonkeys.com with esmtpa (Exim 4.87)
        (envelope-from <rich@richgannon.net>)
        id 1cMlAx-0006lD-IX
        for linux-btrfs@vger.kernel.org; Fri, 30 Dec 2016 00:36:03 +0000
To: linux-btrfs@vger.kernel.org
From: Rich Gannon <rich@richgannon.net>
Subject: Can't add/replace a device on degraded filesystem
Message-ID: <86f5b7b9-b54e-8b80-26a9-6f13f3609a7b@richgannon.net>
Date: Thu, 29 Dec 2016 19:27:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well I certainly got myself into a pickle.  Been a Btrfs user since 2008 
and this is the first time I've had a serious problem....and I got two 
on the same day (I'm separating them in a different emails).

I had 4x 4TB harddrives in a d=single m=raid1 array for about a year now 
containing many media files I really want to save.  Yesterday I removed 
them from my desktop, installed them into a "new-to-me" Supermicro 2U 
server and even swapped over my HighPoint MegaRAID 2720 SAS HBA (yes, 
it's acting as a direct pass-thruHBA only).  With the added space, I 
also installed an additional 4TB drive to the filesystem and was 
performing a rebalance with filters:

btrfs balance start -dconvert=raid10 -mconvert=raid10 /mnt/bpool-btrfs

I found that the new drive dropped off-line during the rebalance.  I 
swapped the drive into a different bay to see if it was backplane,cord, 
or drive related.  Upon remount, the same drive dropped offline.  I had 
another new 4TB drive and swapped it in for the dead drive.

I can mount my filesystem with -o degraded, but I can not do btrfs 
replace or btrfs device add as the filesystem is in read-only mode, and 
I can not mount read-write.

 From my understanding, my data should all be safe as during the 
balance, no single-copy files should have made it onto the new drive 
(that subsequently failed).  Is this a correct assumption?

Here is some btrfs data:
proton bpool-btrfs # btrfs fi df /mnt/bpool-btrfs/
Data, RAID10: total=2.17TiB, used=1.04TiB
Data, single: total=7.79TiB, used=7.59TiB
System, RAID1: total=32.00MiB, used=1.08MiB
Metadata, RAID10: total=1.00GiB, used=1023.88MiB
Metadata, RAID1: total=10.00GiB, used=8.24GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
proton bpool-btrfs # btrfs fi sh /mnt/bpool-btrfs/
Label: 'bigpool'  uuid: 85e8b0dd-fbbd-48a2-abc4-ccaefa5e8d18
         Total devices 5 FS bytes used 8.64TiB
         devid    5 size 3.64TiB used 2.77TiB path /dev/mapper/bpool-3
         devid    6 size 3.64TiB used 2.77TiB path /dev/mapper/bpool-4
         devid    7 size 3.64TiB used 2.77TiB path /dev/mapper/bpool-1
         devid    8 size 3.64TiB used 2.77TiB path /dev/mapper/bpool-2
         *** Some devices missing


NOTE: The drives are all fully encrypted with LUKS/dm_crypt.

Please help me save the data :)

Rich
