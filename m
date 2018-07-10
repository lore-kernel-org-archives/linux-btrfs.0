Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44984 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732272AbeGJWxC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 18:53:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6AHsEub043148
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 17:57:15 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2k2p7vb0xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 17:57:15 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6AHvE7o008141
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 17:57:14 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6AHvEEl002538
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 17:57:14 GMT
From: Anand Jain <anand.jain@oracle.com>
Subject: lockdep warning is impractical
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <83faa761-4b88-4651-e098-d6b39e2662d2@oracle.com>
Date: Wed, 11 Jul 2018 02:00:35 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

I can reproduce the below circular locking warning [1] using the test
case btrfs/161. It can also be reproduced with 4.1 kernel so its not
due to any of the recent patches.

And this warning is unreasonable too .. here is why.

 From [1], Thread #0 is when mounting the sprout device, and thread #1
is when the sprout device is being added to the seed device. As they
both can't be in the same time space this circular locking can't be
practical.

One way to workaround this, is to change the address of the fs_devices
across unmount mount cycle, just by reloading the btrfs.ko [2]. and this
warning goes away.

But, for now I am going to ignore this warning. Any feedback/suggestion?
pls let me know.

By the way is there anyway not to disable the lockdep check after the
first report?

Thanks, Anand


[1]
-------------------------------------------------------------------------
[   47.246043] ======================================================
[   47.247177] WARNING: possible circular locking dependency detected
[   47.248239] 4.17.0-rc7+ #5 Not tainted
[   47.248924] ------------------------------------------------------
[   47.250282] mount/3470 is trying to acquire lock:
[   47.251132] 00000000a04c7a49 (&fs_devs->device_list_mutex){+.+.}, at: 
clone_fs_devices+0x3d/0x170 [btrfs]
[   47.252913]
                but task is already holding lock:
[   47.254056] 00000000d4401221 (&fs_info->chunk_mutex){+.+.}, at: 
btrfs_read_chunk_tree+0x67/0x750 [btrfs]
[   47.255673]
                which lock already depends on the new lock.

[   47.257178]
                the existing dependency chain (in reverse order) is:
[   47.258480]
                -> #1 (&fs_info->chunk_mutex){+.+.}:
[   47.261529]        btrfs_init_new_device+0x553/0x1060 [btrfs]
[   47.262532]        btrfs_ioctl+0xa33/0x22a0 [btrfs]
[   47.263411]        do_vfs_ioctl+0x635/0x680
[   47.264208]        ksys_ioctl+0x4e/0x80
[   47.264932]        __x64_sys_ioctl+0x16/0x20
[   47.265715]        do_syscall_64+0x57/0x150
[   47.266493]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   47.267516]
                -> #0 (&fs_devs->device_list_mutex){+.+.}:
[   47.268923]        __mutex_lock+0x7f/0x990
[   47.270068]        clone_fs_devices+0x3d/0x170 [btrfs]
[   47.270982]        btrfs_read_chunk_tree+0x280/0x750 [btrfs]
[   47.271986]        open_ctree+0x1545/0x2180 [btrfs]
[   47.272870]        btrfs_mount_root+0x49f/0x790 [btrfs]
[   47.273797]        mount_fs+0x89/0x130
[   47.274543]        vfs_kern_mount+0x69/0x160
[   47.275378]        btrfs_mount+0x181/0x8f0 [btrfs]
[   47.276265]        mount_fs+0x89/0x130
[   47.277038]        vfs_kern_mount+0x69/0x160
[   47.277875]        do_mount+0x915/0xd10
[   47.278648]        ksys_mount+0x8d/0xc0
[   47.279382]        __x64_sys_mount+0x21/0x30
[   47.280174]        do_syscall_64+0x57/0x150
[   47.280924]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   47.281885]
                other info that might help us debug this:

[   47.283385]  Possible unsafe locking scenario:

[   47.284488]        CPU0                    CPU1
[   47.285339]        ----                    ----
[   47.286160]   lock(&fs_info->chunk_mutex);
[   47.286898] 
lock(&fs_devs->device_list_mutex);
[   47.288130]                                lock(&fs_info->chunk_mutex);
[   47.307756]   lock(&fs_devs->device_list_mutex);
[   47.308552]
                 *** DEADLOCK ***
------------------------


Thread #0
------------------------------------
btrfs_read_chunk_tree()
::
         mutex_lock(&uuid_mutex);
         mutex_lock(&fs_info->chunk_mutex);  <----
::
                         ret = read_one_dev(fs_info, leaf, dev_item);


read_one_dev()
::
                 fs_devices = open_seed_devices(fs_info, fs_uuid);


open_seed_devices()
::
         fs_devices = find_fsid(fsid);
::
         fs_devices = clone_fs_devices(fs_devices);

clone_fs_devices(orig)
::
         mutex_lock(&orig->device_list_mutex); <---
------------------------------------


Thread #1
------------------------------------
static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)

         mutex_lock(&fs_info->fs_devices->device_list_mutex); <---
::
         mutex_lock(&fs_info->chunk_mutex); <---
-------------------------------------

[2]
---------------------
diff --git a/tests/btrfs/161 b/tests/btrfs/161
index dfff8b871fa3..88e982d81e5b 100755
--- a/tests/btrfs/161
+++ b/tests/btrfs/161
@@ -26,6 +26,7 @@ _cleanup()
  # get standard environment, filters and checks
  . ./common/rc
  . ./common/filter
+. ./common/module

  # remove previous $seqres.full before test
  rm -f $seqres.full
@@ -37,6 +38,7 @@ _supported_fs btrfs
  _supported_os Linux
  _require_command "$BTRFS_TUNE_PROG" btrfstune
  _require_scratch_dev_pool 2
+_require_loadable_fs_module "btrfs"

  _scratch_dev_pool_get 2

@@ -61,7 +63,8 @@ create_sprout()
  {
         _run_btrfs_util_prog device add -f $dev_sprout $SCRATCH_MNT
         _scratch_unmount
-       run_check _mount $dev_sprout $SCRATCH_MNT
+       _reload_fs_module "btrfs"
+       run_check _mount -o device=$dev_seed $dev_sprout $SCRATCH_MNT
         echo -- sprout --
         od -x $SCRATCH_MNT/foobar
         _scratch_unmount
----------------------------------


Thanks, Anand
