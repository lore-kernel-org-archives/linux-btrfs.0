Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19075 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbbK3H7t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 02:59:49 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tAU7xmtF023825
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 07:59:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id tAU7xmq7020486
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 07:59:48 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id tAU7xlm4003200
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 07:59:47 GMT
To: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Subject: [RFC] Btrfs device and pool management (wip)
Message-ID: <565C01F1.5030108@oracle.com>
Date: Mon, 30 Nov 2015 15:59:45 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(fixed alignment)


------------
  Data center systems are generally aligned with the RAS (Reliability,
Availability and Serviceability) attributes. When it comes to Storage,
RAS applies even more because its matter of trust. In this context, one
of the primary area that a typical volume manager should be well tested
is, how well RAS attributes are maintained in the context of device
failure, and its further reporting.

  But, identifying a failed device is not a straight forward code. If
you look at some statistics performed on failed and returned disks,
most of the disks ends up being classified as NTF (No Trouble Found).
That is, host failed-and-replaced a disk even before it has actually
failed. This is not good for a cost effective setup who would want to
stretch the life of an intermittently failing device to its maximum
tenure and would want to replace only when it has confirmed dead.

  Also on the other hand, some of the data center admins would like to
mitigate the risk (of low performance at peak of their business
productions) of a potential failure, and prefer to pro-actively replace
the disk at their low business/workload hours, or they may choose to
replace a device even for read errors (mainly due to performance
reasons).

  In short a large variant of real MTF (Mean Time to Failure) for the
devices across the industries/users.


Consideration:

  - Have user-tunable to support different context of usages, which
should be applied on top of a set of disk IO errors, and its out come
will be to know if the disk can be failed.

  - Distinguish real disk failure (failed state) VS IO errors due to
intermittent transport errors (offline state). (I am not sure how to do
that yet, basically in some means, block layer could help?, RFC ?).

  - A sysfs offline interface, so as to udev update the kernel, when
disk is pulled out.

  - Because even to fail a device it depends on the user requirements,
btrfs IO completion threads instead of directly reacting on an IO
error, it will continue to just report the IO error into device error
statistics, and a spooler up on errors will apply user/system
criticalness as provided by the user on the top, which will decide if
the device has to be marked as failed OR if it can continue to be in
online.

  - A FS load pattern (mostly outside of btrfs-kernel or with in btrfs-
kernel) may pick the right time to replace the failed device, or to run
other FS maintenance activities (balance, scrub) automatically.

  - Sysfs will help user land scripts which may want to bring device to
offline or failed.



Device State flow:

   A device in the btrfs kernel can be in any one of following state:

   Online
      A normal healthy device

   Missing
      Device wasn't found that the time of mount OR device scan.

   Offline (disappeared)
      Device was present at some point in time after the FS was mounted,
      however offlined by user or block layer or hot unplug or device
      experienced transport error. Basically due to any error other than
      media error.
      The device in offline state are not candidate for the replace.
      Since still there is a hope that device may be restored to online
      at some point in time, by user or transport-layer error recovery.
      For device pulled out, there will be udev script which will call
      offline through sysfs. In the long run, we would also need to know
      the block layer to distinguish from the transient write errors
      like writes failing  due to transport error, vs write errors which
      are confirmed as target-device/device-media failure.

   Failed
      Device has confirmed a write/flush failure for at least a block.
      (In general the disk/storage FW will try to relocate the bad block
      on write, it happens automatically and transparent even to the
      block layer. Further there might have been few retry from the block
      layer. And here btrfs assumes that such an attempt has also
      failed). Or it might set device as failed for extensive read
      errors if the user tuned profile demands it.


A btrfs pool can be in one of the state:

Online:
   All the chunks are as configured.

Degraded:
   One or more logical-chunks does not meet the redundancy level that
   user requested / configured.

Failed:
   One or more logical-chunk is incomplete. FS will be in a RO mode Or
   panic -dump as configured.


Flow diagram (also include pool states BTRFS_POOL_STATE_xx along with
device state BTRFS_DEVICE_STATE_xx):


                     [1]
                     BTRFS_DEVICE_STATE_ONLINE,
                      BTRFS_POOL_STATE_ONLINE
                                 |
                                 |
                                 V
                           new IO error
                                 |
                                 |
                                 V
                    check with block layer to know
                   if confirmed media/target:- failed
                 or fix-able transport issue:- offline.
                       and apply user config.
             can be ignored ?  --------------yes->[1]
                                 |
                                 |no
         _______offline__________/\______failed________
         |                                             |
         |                                             |
         V                                             V
(eg: transport issue [*], disk is good)     (eg: write media error)
         |                                             |
         |                                             |
         V                                             V
BTRFS_DEVICE_STATE_OFFLINE                BTRFS_DEVICE_STATE_FAILED
         |                                             |
         |                                             |
         |______________________  _____________________|
                                \/
                                 |
                         Missing chunk ? --NO--> goto [1]
                                 |
                                 |
                          Tolerable? -NO-> FS ERROR. RO.
                                      BTRFS_POOL_STATE_FAILED->remount?
                                 |
                                 |yes
                                 V
                       BTRFS_POOL_STATE_DEGRADED --> rebalance -> [1]
                                 |
         ______offline___________|____failed_________
         |                                           |
         |                                      check priority
         |                                           |
         |                                           |
         |                                      hot spare ?
         |                                    replace --> goto [1]
         |                                           |
         |                                           | no
         |                                           |
         |                                       spare-add
(user/sys notify issue is fixed,         (manual-replace/dev-delete)
   trigger scrub/balance)                            |
         |______________________  ___________________|
                                \/
                                 |
                                 V
                                [1]


Code status:
  Part-1: Provided device transitions from online to failed/offline,
          hot spare and auto replace.
          [PATCH 00/15] btrfs: Hot spare and Auto replace

  Next,
   . Add sysfs part on top of
     [PATCH] btrfs: Introduce device pool sysfs attributes
   . POOL_STATE flow and reporting
   . Device transactions from Offline to Online
   . Btrfs-progs mainly to show device and pool states
   . Apply user tolerance level to the IO errors
----------


Thanks, Anand
