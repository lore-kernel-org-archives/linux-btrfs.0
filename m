Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37642 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaGUUeF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jul 2014 16:34:05 -0400
Received: by mail-pd0-f175.google.com with SMTP id r10so8325110pdi.20
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jul 2014 13:34:04 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 21 Jul 2014 13:34:04 -0700
Message-ID: <CAN05THRDjQ0eM4n=4kO61C3aEf06ZGQKu8ABCtO1MK5vZjDQEQ@mail.gmail.com>
Subject: Testing with flaky disk
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

List, btrfs developers.

I started working on a test tool for SCSI initiators and filesystem folks.
It is a iSCSI target that implements a bad flaky disks where you
can set precise controls of how/what is broken which you can use to test
error and recovery paths in the initiator/filesystem.

The tool is available at :
https://github.com/rsahlberg/flaky-stgt.git
and is a modified version of the TGTD iscsi target.


Right now it is just an initial prototype and it needs more work to
add more types of errors as well as making it more userfriendly.
But it is still useful enough to illustrate certain failure cases
which could be helpful to btrfs and others.


Let me illustrate. Lets start by creating a BTRFS filesystem spanning
three 1G disks:
====
#
# Create three disks and export them through flaky iSCSI
#
truncate -s 1G /data/tmp/disk1.img
truncate -s 1G /data/tmp/disk2.img
truncate -s 1G /data/tmp/disk3.img

killall -9 tgtd
./usr/tgtd -f -d 1 &

sleep 3

./usr/tgtadm --op new --mode target --tid 1 -T iqn.ronnie.test

./usr/tgtadm --op new --mode logicalunit --tid 1 --lun 1 -b
/data/tmp/disk1.img --blocksize=4096
./usr/tgtadm --op new --mode logicalunit --tid 1 --lun 2 -b
/data/tmp/disk2.img --blocksize=4096
./usr/tgtadm --op new --mode logicalunit --tid 1 --lun 3 -b
/data/tmp/disk3.img --blocksize=4096

./usr/tgtadm --op bind --mode target --tid 1 -I ALL


#
# connect to the three disks
#
iscsiadm --mode discoverydb --type sendtargets --portal 127.0.0.1 --discover
iscsiadm --mode node --targetname iqn.ronnie.test --portal
127.0.0.1:3260 --login
#
# check dmesg, you should now have three new 1G disks
#
# Use: iscsiadm --mode node --targetname iqn.ronnie.test \
#      --portal 127.0.0.1:3260 --logout
# to disconnect the disks when you are finished.


# create a btrfs filesystem
mkfs.btrfs -f -d raid1
/dev/disk/by-path/ip-127.0.0.1:3260-iscsi-iqn.ronnie.test-lun-1
/dev/disk/by-path/ip-127.0.0.1:3260-iscsi-iqn.ronnie.test-lun-2
/dev/disk/by-path/ip-127.0.0.1:3260-iscsi-iqn.ronnie.test-lun-3

# mount the filesystem
mount /dev/disk/by-path/ip-127.0.0.1:3260-iscsi-iqn.ronnie.test-lun-1 /mnt
====

Then we can proceed to copy a bunch of data to the filesystem so that
there will be some blocks used.


Now we can see how/what happens in the case of a single bad disk.
Lets say the disk is gone bad,   it is still possible to read from the
disk but all writes fail with medium error.
Perhaps this is similar to the case of a cheap disk that has
completely run out of blocks to reallocate to?


===
# make all writes to the third disk fail with write error.
# 3 - MEDIUM ERROR
# 0x0c02 - WRITE ERROR AUTOREALLOCATION FAILED
#
./usr/tgtadm --mode error --op new --tid 1 --lun 3 --error
op=WRITE10,lba=0,len=99999999,pct=100,pause=0,repeat=0,action=CHECK_CONDITION,key=3,asc=0x0c02

# To show all current error injects:
# ./usr/tgtadm --mode error --op show
#
# To delete/clear all current error injects:
# ./usr/tgtadm --mode error --op delete
===



If you now know that this disk has gone bad,  you could try to delete
the device :

btrfs device delete
/dev/disk/by-path/ip-127.0.0.1:3260-iscsi-iqn.ronnie.test-lun-3 /mnt

but this will probably not work, since at least to semi-recent
versions of btrfs you can not remove a device from the filesystem
UNLESS you can also write to the device.

Thus making it impossible to remove the bad device in other ways that
physically removing the device.
This is suboptimal from a data integrity point of view since if the
disk is readable, it
can potentially still contain valid copies of the data which might be
silently errored
on the other mirror.

At some stage, from a data integrity and data robustness standpoint,
it would be nice to be able to device delete a device that is
readable, and contain a valid copy of the data, but still unwriteable.


There is a bunch of other things you can test and emulate with this too.
I have only tested this with semi-recent versions of btrfs and not the
latest version.
I will wait until the current versions of btrfs becomes more
stable/robust before I
will start experimenting with it.


Since I think this could be invaluably useful for a filesystem
developer, please have a look. I am more than happy to add additional
features that would make it even more useful for
filesystem-error-path-and-recovery-testing



regards
ronnie sahlberg
