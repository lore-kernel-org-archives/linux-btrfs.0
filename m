Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58526 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbeGKHuE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jul 2018 03:50:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6B7iVES012443
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jul 2018 07:47:05 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2k2p7651mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jul 2018 07:47:05 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6B7l5iK005311
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jul 2018 07:47:05 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6B7l5k5023081
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jul 2018 07:47:05 GMT
From: Anand Jain <anand.jain@oracle.com>
Subject: [DOC] BTRFS Volume operations, Device Lists and Locks all in one page
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Anand Jain <anand.jain@oracle.com>
Message-ID: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>
Date: Wed, 11 Jul 2018 15:50:25 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



BTRFS Volume operations, Device Lists and Locks all in one page:

Devices are managed in two contexts, the scan context and the mounted 
context. In scan context the threads originate from the btrfs_control 
ioctl and in the mounted context the threads originates from the mount 
point ioctl.
Apart from these two context, there also can be two transient state 
where device state are transitioning from the scan to the mount context 
or from the mount to the scan context.

Device List and Locks:-

  Count: btrfs_fs_devices::num_devices
  List : btrfs_fs_devices::devices -> btrfs_devices::dev_list
  Lock : btrfs_fs_devices::device_list_mutex

  Count: btrfs_fs_devices::rw_devices
  List : btrfs_fs_devices::alloc_list -> btrfs_devices::dev_alloc_list
  Lock : btrfs_fs_info::chunk_mutex

  Lock: set_bit btrfs_fs_info::flags::BTRFS_FS_EXCL_OP

FSID List and Lock:-

  Count : None
  HEAD  : Global::fs_uuids -> btrfs_fs_devices::fs_list
  Lock  : Global::uuid_mutex


After the fs_devices is mounted, the btrfs_fs_devices::opened > 0.

In the scan context we have the following device operations..

Device SCAN:-  which creates the btrfs_fs_devices and its corresponding 
btrfs_device entries, also checks and frees the duplicate device entries.
Lock: uuid_mutex
   SCAN
   if (found_duplicate && btrfs_fs_devices::opened == 0)
      Free_duplicate
Unlock: uuid_mutex

Device READY:- check if the volume is ready. Also does an implicit scan 
and duplicate device free as in Device SCAN.
Lock: uuid_mutex
   SCAN
   if (found_duplicate && btrfs_fs_devices::opened == 0)
      Free_duplicate
   Check READY
Unlock: uuid_mutex

Device FORGET:- (planned) free a given or all unmounted devices and 
empty fs_devices if any.
Lock: uuid_mutex
   if (found_duplicate && btrfs_fs_devices::opened == 0)
     Free duplicate
Unlock: uuid_mutex

Device mount operation -> A Transient state leading to the mounted context
Lock: uuid_mutex
  Find, SCAN, btrfs_fs_devices::opened++
Unlock: uuid_mutex

Device umount operation -> A transient state leading to the unmounted 
context or scan context
Lock: uuid_mutex
   btrfs_fs_devices::opened--
Unlock: uuid_mutex


In the mounted context we have the following device operations..

Device Rename through SCAN:- This is a special case where the device 
path gets renamed after its been mounted. (Ubuntu changes the boot path 
during boot up so we need this feature). Currently, this is part of 
Device SCAN as above. And we need the locks as below, because the 
dynamic disappearing device might cleanup the btrfs_device::name
Lock: btrfs_fs_devices::device_list_mutex
    Rename
Unlock: btrfs_fs_devices::device_list_mutex

Commit Transaction:- Write All supers.
Lock: btrfs_fs_devices::device_list_mutex
   Write all super of btrfs_devices::dev_list
Unlock: btrfs_fs_devices::device_list_mutex

Device add:- Add a new device to the existing mounted volume.
set_bit: btrfs_fs_info::flags::BTRFS_FS_EXCL_OP
Lock: btrfs_fs_devices::device_list_mutex
Lock: btrfs_fs_info::chunk_mutex
    List_add btrfs_devices::dev_list
    List_add btrfs_devices::dev_alloc_list
Unlock: btrfs_fs_info::chunk_mutex
Unlock: btrfs_fs_devices::device_list_mutex

Device remove:- Remove a device from the mounted volume.
set_bit: btrfs_fs_info::flags::BTRFS_FS_EXCL_OP
Lock: btrfs_fs_devices::device_list_mutex
Lock: btrfs_fs_info::chunk_mutex
    List_del btrfs_devices::dev_list
    List_del btrfs_devices::dev_alloc_list
Unlock: btrfs_fs_info::chunk_mutex
Unlock: btrfs_fs_devices::device_list_mutex

Device Replace:- Replace a device.
set_bit: btrfs_fs_info::flags::BTRFS_FS_EXCL_OP
Lock: btrfs_fs_devices::device_list_mutex
Lock: btrfs_fs_info::chunk_mutex
    List_update btrfs_devices::dev_list
    List_update btrfs_devices::dev_alloc_list
Unlock: btrfs_fs_info::chunk_mutex
Unlock: btrfs_fs_devices::device_list_mutex

Sprouting:- Add a RW device to the mounted RO seed device, so to make 
the mount point writable.
The following steps are used to hold the seed and sprout fs_devices.
(first two steps are not necessary for the sprouting, they are there to 
ensure the seed device remains scanned, and it might change)
. Clone the (mounted) fs_devices, lets call it as old_devices
. Now add old_devices to fs_uuids (yeah, there is duplicate fsid in the 
list but we change the other fsid before we release the uuid_mutex, so 
its fine).

. Alloc a new fs_devices, lets call it as seed_devices
. Copy fs_devices into the seed_devices
. Move fs_deviecs devices list into seed_devices
. Bring seed_devices to under fs_devices (fs_devices->seed = seed_devices)
. Assign a new FSID to the fs_devices and add the new writable device to 
the fs_devices.

In the unmounted context the fs_devices::seed is always NULL.
We alloc the fs_devices::seed only at the time of mount and or at 
sprouting. And free at the time of umount or if the seed device is 
replaced or deleted.

Locks: Sprouting:
Lock: uuid_mutex <-- because fsid rename and Device SCAN
Reuses Device Add code

Locks: Splitting: (Delete OR Replace a seed device)
uuid_mutex is not required as fs_devices::seed which is local to 
fs_devices is being altered.
Reuses Device replace code


Device resize:- Resize the given volume or device.
Lock: btrfs_fs_info::chunk_mutex
    Update
Unlock: btrfs_fs_info::chunk_mutex


(Planned) Dynamic Device missing/reappearing:- A missing device might 
reappear after its volume been mounted, we have the same btrfs_control 
ioctl which does the scan of the reappearing device but in the mounted 
context. In the contrary a device of a volume in a mounted context can 
go missing as well, and still the volume will continue in the mounted 
context.
Missing:
Lock: btrfs_fs_devices::device_list_mutex
Lock: btrfs_fs_info::chunk_mutex
   List_del: btrfs_devices::dev_alloc_list
   Close_bdev
   btrfs_device::bdev == NULL
   btrfs_device::name = NULL
   set_bit BTRFS_DEV_STATE_MISSING
   set_bit BTRFS_VOL_STATE_DEGRADED
Unlock: btrfs_fs_info::chunk_mutex
Unlock: btrfs_fs_devices::device_list_mutex

Reappearing:
Lock: btrfs_fs_devices::device_list_mutex
Lock: btrfs_fs_info::chunk_mutex
   Open_bdev
   btrfs_device::name = PATH
   clear_bit BTRFS_DEV_STATE_MISSING
   clear_bit BTRFS_VOL_STATE_DEGRADED
   List_add: btrfs_devices::dev_alloc_list
   set_bit BTRFS_VOL_STATE_RESILVERING
   kthread_run HEALTH_CHECK
Unlock: btrfs_fs_info::chunk_mutex
Unlock: btrfs_fs_devices::device_list_mutex

-----------------------------------------------------------------------

Thanks, Anand
