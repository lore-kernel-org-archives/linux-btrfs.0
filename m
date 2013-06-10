Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50376 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab3FJOws (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 10:52:48 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5AEqjMx027878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:46 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEqkl8006985
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:47 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEqkj1007522
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:46 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/9] btrfs-progs: coalesce of patches
Date: Mon, 10 Jun 2013 22:56:21 +0800
Message-Id: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A patch set revised/rebased on integration-20130524
these were posted before but havn't made into the repo yet.

I.
Introduce btrfs filesystem show --kernel

There are bugs surrounding btrfs filesystem show,
when ran immediately after the oprations like
btrfs fi label <mnt> <label> and btrfs dev delete <mnt>
the btrfs fi show will still show the contents which is
staled by the preceding label and device operation as show
below

btrfs fi show fails to report label immediately after label

----
btrfs fi label /btrfs test10

btrfs fi show
Label: 'test'  uuid: 22b6f318-07d4-4af4-b8e5-b2682cb83a7a
        Total devices 3 FS bytes used 28.00KB
        devid    3 size 15.00GB used 0.00 path /dev/dm-6
        devid    4 size 44.99GB used 1.03GB path /dev/dm-4

btrfs fi label /btrfs
test10

btrfs fi show --kernel
Label: 'test10'  uuid: 22b6f318-07d4-4af4-b8e5-b2682cb83a7a
        Total devices 2 FS bytes used 28.00KB
        devid    3 size 15.00GB used 0.00 path /dev/dm-6
        devid    4 size 44.99GB used 1.03GB path /dev/dm-4
-----

After dropping the cache its fine, but to expect the user
to drop the caches to get a consistent view is not a good idea..

-----
btrfs fi show
Label: 'test3'  uuid: 0a621111-ad84-4d80-842a-dd9c1c60bf51
    Total devices 2 FS bytes used 200.41MB
    devid    2 size 48.23GB used 2.03GB path /dev/dm-5
    devid    1 size 44.99GB used 2.04GB path /dev/dm-4

btrfs fi label /btrfs
test5

echo 3 > /proc/sys/vm/drop_caches
btrfs fi show
Label: 'test5'  uuid: 0a621111-ad84-4d80-842a-dd9c1c60bf51
    Total devices 2 FS bytes used 200.41MB
    devid    2 size 48.23GB used 2.03GB path /dev/dm-5
    devid    1 size 44.99GB used 2.04GB path /dev/dm-4
-----

bugs with btrfs fi show and btrfs device operation..
----
btrfs fi show
Label: 'test'  uuid: 22b6f318-07d4-4af4-b8e5-b2682cb83a7a
        Total devices 3 FS bytes used 28.00KB
        devid    3 size 15.00GB used 0.00 path /dev/dm-6
        devid    4 size 44.99GB used 0.00 path /dev/dm-4
        devid    2 size 48.23GB used 1.03GB path /dev/dm-5

btrfs dev del /dev/dm-5 /btrfs

(dm-5 is replaced with sde, the previous patch use mapper
will fix this, But reports missing since SB is not yet
updated on the disk) 
btrfs fi show
Label: 'test'  uuid: 22b6f318-07d4-4af4-b8e5-b2682cb83a7a
        Total devices 3 FS bytes used 28.00KB
        devid    3 size 15.00GB used 0.00 path /dev/dm-6
        devid    4 size 44.99GB used 1.03GB path /dev/dm-4
        devid    2 size 48.23GB used 1.03GB path /dev/sde


btrfs fi show --mapper
Label: 'test'  uuid: 22b6f318-07d4-4af4-b8e5-b2682cb83a7a
        Total devices 3 FS bytes used 28.00KB
        devid    4 size 44.99GB used 1.03GB path /dev/mapper/mpathe
        devid    3 size 15.00GB used 0.00 path /dev/mapper/mpathbp1
        *** Some devices missing

The newly introduced --kernel option is in line with the
device operation...

btrfs fi show --kernel
Label: 'test'  uuid: 22b6f318-07d4-4af4-b8e5-b2682cb83a7a
        Total devices 2 FS bytes used 28.00KB
        devid    3 size 15.00GB used 0.00 path /dev/dm-6
        devid    4 size 44.99GB used 1.03GB path /dev/dm-4
--------

In long run, I hope to make the --kernel a default option
for the mounted fs and scan devpath to look for non-mounted
btrfs.

II.
  btrfs-progs: device delete to get errors from the kernel
  v3: rebased with other patches here.

III. (patch 1/8 to 5/8)
The idea was to introduce /dev/mapper to find for btrfs disk, 
However I found first we need to congregate the disk scan
procedure at a function so it would help to consistently tune
it across the btrfs-progs. As of now both fi show and
dev scan use the disks scan they do it on their own.

So here it would congregate btrfs-disk scans at the function
scan_devs_for_btrfs, adds /dev/mapper to be used to scan
for btrfs, and updates its calling functions and few bug fixes.

v1->v2:
 Rebased on top of David' integration branch origin/integration-20130524

 patch 1 to 5 (below) are made independent of the idea to have the
 /dev/mapper as one of the path to recognize the btrfs disks.
 Which means they can be installed with out having anything
 new. It just adds the framework/improves to integrated a
 /dev/mapper path, which is only done in the patch 6.
 So patch 1 to 5 are safe.
 Also in v1 I suggested that we have -d option instead of
 long option --all-devices which I have dropped that idea
 here in v2.

 Patch 6: adds a new option --mapper to the filesystem show
 and device scan which inturn will use /dev/mapper to scan
 for the btrfs.

 Example output of using the --mapper option is as below..

btrfs filesystem show --mapper
Label: none  uuid: 0a621111-ad84-4d80-842a-dd9c1c60bf51
	Total devices 2 FS bytes used 1.17MB
	devid    1 size 44.99GB used 2.04GB path /dev/mapper/mpathe
	devid    2 size 48.23GB used 2.03GB path /dev/mapper/mpathd

Label: none  uuid: bad9105f-bdc6-4626-9ba7-80bd97aebe19
	Total devices 1 FS bytes used 28.00KB
	devid    1 size 15.00GB used 2.04GB path /dev/mapper/mpathbp1

Btrfs v0.20-rc1-350-g7731651

btrfs device scan --mapper
-----
[1118885.473298] device fsid bad9105f-bdc6-4626-9ba7-80bd97aebe19 devid 1 transid 4 /dev/mapper/mpathbp1
[1118885.474077] device fsid 0a621111-ad84-4d80-842a-dd9c1c60bf51 devid 2 transid 103 /dev/mapper/mpathd
[1118885.474133] device fsid 0a621111-ad84-4d80-842a-dd9c1c60bf51 devid 1 transid 103 /dev/mapper/mpathe
-----

Anand Jain (9):
  btrfs-progs: btrfs_scan_for_fsid doesn't need all the arguments
  btrfs-progs: label option in btrfs filesystem show is not coded
  btrfs-progs: update device scan usage
  btrfs-progs: congregate dev scan
  btrfs-progs: btrfs_scan_one_dir not to skip links when /dev/mapper is
    provided
  btrfs-progs: scan /dev/mapper in filesystem show and device scan
  btrfs-progs: device delete to get errors from the kernel
  btrfs-progs: get_label_mounted to return label instead of print
  btrfs-progs: introduce btrfs filesystem show --kernel

 btrfs-find-root.c |   2 +-
 cmds-device.c     |  29 ++++--
 cmds-filesystem.c |  21 ++--
 ctree.h           |   1 -
 disk-io.c         |   2 +-
 ioctl.h           | 107 ++++++++++++++++++-
 man/btrfs.8.in    |  16 +--
 utils.c           | 300 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 utils.h           |  13 ++-
 volumes.c         |  20 +++-
 volumes.h         |   3 +
 11 files changed, 467 insertions(+), 47 deletions(-)

-- 
1.8.1.227.g44fe835

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
