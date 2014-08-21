Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37860 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbaHUFzH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 01:55:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XKLKy-0003AG-4P
	for linux-btrfs@vger.kernel.org; Thu, 21 Aug 2014 07:55:04 +0200
Received: from zmail.pkvoda.ru ([77.82.81.84])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Aug 2014 07:55:04 +0200
Received: from kamheric by zmail.pkvoda.ru with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Aug 2014 07:55:04 +0200
To: linux-btrfs@vger.kernel.org
From: Mihail Zaporozhets <kamheric@gmail.com>
Subject: btrfs restore
Date: Thu, 21 Aug 2014 05:52:01 +0000 (UTC)
Message-ID: <loom.20140821T061503-238@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I'm create btrfs multi-device volume: (2TB * 5disks)
1. one device was converted from ext3, 
then delete sub-volume 'ext2'; 
2. 'btrfs device add /dev/sd* /mnt/sdc1'; 
and some times again,  Every disk adds by one, then move data from other
disks. 2 times was running 'btrfs fi defrag -r -v -t 700K /mnt/sdc1; btrfs
balance start /mnt/sdc1; btrfs scrub start /mnt/sdc1'. Finally I have FS at
5 devices.

After, go to reboot pc, and I seen that 1 drive have no any partition. I'm
full of sadness. I think that device was not correctly unmounted and one
disk fail.
mount -t btrfs -o degreded,ro,recovery,nospace_cache ...
mount -t btrfs -o recovery,nospace_cache ...
btrfs-find-root, btrfs-zero-log .. 

Finaly:
btrfs restore -t 10404875644928 -v -i /dev/sda1 /mnt/uh1/eric/ - 
Success! but some directory is absent; 3.4 TB restored, but 4 (available
disks)*1.82 Tb = 7.28 TB; and 7.28-3.4 = about 3.8 TB which is missing .
Where is it ? How can i get it back? 

How can i try to restore more data? 

Please advice.

_____
mount -t btrfs -o degraded,ro,recovery,nospace_cache /dev/sda1 /mnt/tmp3;
dmesg | tail

[11774.958996] BTRFS info (device sde1): allowing degraded mounts
[11774.959001] BTRFS info (device sde1): enabling auto recovery
[11774.959003] BTRFS info (device sde1): disabling disk space caching
[11774.959955] BTRFS warning (device sde1): devid 5 missing
[11774.986391] BTRFS: failed to read tree root on sde1
[11774.986408] BTRFS: failed to read tree root on sde1
[11774.986456] BTRFS: failed to read tree root on sde1
[11774.986473] BTRFS: failed to read tree root on sde1
[11774.986481] BTRFS: failed to read tree root on sde1
[11775.014471] BTRFS: open_ctree failed
    
# btrfs-zero-log /dev/sda1                         
warning devid 5 not found already
Check tree block failed, want=16845270495232, have=0
read block failed check_tree_block
Couldn't read tree root
______
# uname -a
Linux oit-875u 3.16.0-031600rc7-generic #201407271635 SMP Sun Jul 27
20:36:48 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
    # btrfs fi show                                         
Label: none  uuid: 841f1b5c-adb2-485f-a4cf-83bbf880dced
        Total devices 5 FS bytes used 9.09TiB
        devid    1 size 1.82TiB used 1.82TiB path /dev/sda1
        devid    2 size 1.82TiB used 1.82TiB path /dev/sdc1
        devid    3 size 1.82TiB used 1.82TiB path /dev/sdd1
        devid    4 size 1.82TiB used 1.82TiB path /dev/sde1
        *** Some devices missing

Btrfs v3.14.1


