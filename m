Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60524 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbcCYLtV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 07:49:21 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 5C22D20395
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 07:49:20 -0400 (EDT)
Message-Id: <1458906560.3786108.559411242.3678497C@webmail.messagingengine.com>
From: Stephen Williams <stephenw@veryfast.biz>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: Possible Raid Bug
Date: Fri, 25 Mar 2016 11:49:20 +0000
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Find instructions on how to recreate below -

I have a BTRFS raid 10 setup in Virtualbox (I'm getting to grips with
the Filesystem) 
I have the raid mounted to /mnt like so -
 
[root@Xen ~]# btrfs filesystem show /mnt/
Label: none  uuid: ad1d95ee-5cdc-420f-ad30-bd16158ad8cb
        Total devices 4 FS bytes used 1.00GiB
        devid    1 size 2.00GiB used 927.00MiB path /dev/sdb
        devid    2 size 2.00GiB used 927.00MiB path /dev/sdc
        devid    3 size 2.00GiB used 927.00MiB path /dev/sdd
        devid    4 size 2.00GiB used 927.00MiB path /dev/sde
And -
[root@Xen ~]# btrfs filesystem usage /mnt/
Overall:
    Device size:                   8.00GiB
    Device allocated:              3.62GiB
    Device unallocated:            4.38GiB
    Device missing:                  0.00B
    Used:                          2.00GiB
    Free (estimated):              2.69GiB      (min: 2.69GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:               16.00MiB      (used: 0.00B)

Data,RAID10: Size:1.50GiB, Used:1.00GiB
   /dev/sdb      383.50MiB
   /dev/sdc      383.50MiB
   /dev/sdd      383.50MiB
   /dev/sde      383.50MiB

Metadata,RAID10: Size:256.00MiB, Used:1.16MiB
   /dev/sdb       64.00MiB
   /dev/sdc       64.00MiB
   /dev/sdd       64.00MiB
   /dev/sde       64.00MiB

System,RAID10: Size:64.00MiB, Used:16.00KiB
   /dev/sdb       16.00MiB
   /dev/sdc       16.00MiB
   /dev/sdd       16.00MiB
   /dev/sde       16.00MiB

Unallocated:
   /dev/sdb        1.55GiB
   /dev/sdc        1.55GiB
   /dev/sdd        1.55GiB
   /dev/sde        1.55GiB

Right so everything looks good and I stuck some dummy files in there too
-
[root@Xen ~]# ls -lh /mnt/
total 1.1G
-rw-r--r-- 1 root root 1.0G May 30  2008 1GB.zip
-rw-r--r-- 1 root root   28 Mar 24 15:16 hello
-rw-r--r-- 1 root root    6 Mar 24 16:12 niglu
-rw-r--r-- 1 root root    4 Mar 24 15:32 test

The bug appears to happen when you try and test out it's ability to
handle a dead drive.
If you follow the instructions here:
https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Replacing_failed_devices
It tells you do mount the drive with the 'degraded' option,, however
this just does not work, allow me to show -

1) I power off the VM and remove one of the drives (Simulating a drive
being pulled from a machine)
2) Power on the VM
3) Check DMESG - Everything looks good
4) Check how BTRFS is feeling -

Label: none  uuid: ad1d95ee-5cdc-420f-ad30-bd16158ad8cb
        Total devices 4 FS bytes used 1.00GiB
        devid    1 size 2.00GiB used 1.31GiB path /dev/sdb
        devid    2 size 2.00GiB used 1.31GiB path /dev/sdc
        devid    3 size 2.00GiB used 1.31GiB path /dev/sdd
        *** Some devices missing

So far so good, /dev/sde is missing and BTRFS has detected this.
5) Try and mount it as per the wiki so I can remove the bad drive and
replace it with a good one -

[root@Xen ~]# mount -o degraded /dev/sdb /mnt/
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

Ok, this is not good, I check DMESG -

[root@Xen ~]# dmesg | tail
[    4.416445] e1000: enp0s3 NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: RX
[    4.416672] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s3: link becomes ready
[    4.631812] snd_intel8x0 0000:00:05.0: white list rate for 1028:0177
is 48000
[    7.091047] floppy0: no floppy controllers found
[   27.488345] BTRFS info (device sdb): allowing degraded mounts
[   27.488348] BTRFS info (device sdb): disk space caching is enabled
[   27.488349] BTRFS: has skinny extents
[   27.489794] BTRFS warning (device sdb): devid 4 uuid
ebcd53d9-5956-41d9-b0ef-c59d08e5830f is missing
[   27.491465] BTRFS: missing devices(1) exceeds the limit(0), writeable
mount is not allowed
[   27.520231] BTRFS: open_ctree failed

So here lies the problem - BTRFS needs you to have all the devices
present in order to mount is as writeable, however if a drive dies
spectacularly (as they can do) You can't have that do that. And as a
result you cannot mount any of the remaining drives and fix the problem. 
Now you ARE able to mount it read only but you can't issue the fix that
is recommend on the wiki, see here -

[root@Xen ~]# mount -o ro,degraded /dev/sdb /mnt/
[root@Xen ~]# btrfs device delete missing /mnt/
ERROR: error removing device 'missing': Read-only file system

So catch 22, you need all the drives otherwise it won't let you mount,
But what happens if a drive dies and the OS doesn't detect it? BTRFS
wont allow you to mount the raid volume to remove the bad disk! 

I also tried it with read only -

[root@Xen ~]# mount -o ro,degraded /dev/sdb /mnt/
[root@Xen ~]# btrfs device delete missing /mnt/
ERROR: error removing device 'missing': Read-only file system

subscribe linux-btrfs
