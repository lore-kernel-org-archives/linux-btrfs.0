Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45102 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbeBXOGH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Feb 2018 09:06:07 -0500
Subject: Re: [PATCH 1/1] btrfs: fix NPD when target device is missing
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180220144625.8909-1-anand.jain@oracle.com>
 <20180223225545.GP1469@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <3924655c-6f90-7528-0b76-c775c9eb3acf@oracle.com>
Date: Sat, 24 Feb 2018 22:07:33 +0800
MIME-Version: 1.0
In-Reply-To: <20180223225545.GP1469@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/24/2018 06:55 AM, David Sterba wrote:
> On Tue, Feb 20, 2018 at 10:46:25PM +0800, Anand Jain wrote:
>> The replace target device can be missing in which case we don't
>> allocate a missing btrfs_device when mounted with the -o degraded.
>> So check the device before access.
>>
>> BUG: unable to handle kernel NULL pointer dereference at 00000000000000b0
> 
> Please don't use uncommon acronyms, NPD is quite confusing, null pointer
> deref should be fine.

  Ok, sent v2.

>> IP: btrfs_destroy_dev_replace_tgtdev+0x43/0xf0 [btrfs]
>> Call Trace:
>> btrfs_dev_replace_cancel+0x15f/0x180 [btrfs]
>> btrfs_ioctl+0x2216/0x2590 [btrfs]
>> do_vfs_ioctl+0x625/0x650
>> SyS_ioctl+0x4e/0x80
>> do_syscall_64+0x5d/0x160
>> entry_SYSCALL64_slow_path+0x25/0x25
> 
> Do you have a reproducer for that?

  For now, I used a tweaked btrfs.ko [1], then

  mkfs.btrfs -fq /dev/sdb && mount /dev/sdb /btrfs
  btrfs rep start -B /dev/sdb /dev/sdc
    after reboot, we have the replace target device
    and now use non-tweaked btrfs.ko
  mount -o degraded /dev/sdb /btrfs

[1]
-----------
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 476981c2cf55..8ea4856b6368 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -25,6 +25,7 @@
  #include <linux/capability.h>
  #include <linux/kthread.h>
  #include <linux/math64.h>
+#include <linux/reboot.h>
  #include <asm/div64.h>
  #include "ctree.h"
  #include "extent_map.h"
@@ -419,6 +420,8 @@ int btrfs_dev_replace_start(struct btrfs_fs_info 
*fs_info,
                               btrfs_device_get_total_bytes(src_device),
                               &dev_replace->scrub_progress, 0, 1);

+       emergency_restart();
+
         ret = btrfs_dev_replace_finishing(fs_info, ret);
         if (ret == -EINPROGRESS) {
                 ret = BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS;
------------


Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
