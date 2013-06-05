Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43477 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063Ab3FEOk5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Jun 2013 10:40:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UkEtS-0000bI-PA
	for linux-btrfs@vger.kernel.org; Wed, 05 Jun 2013 16:40:54 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Jun 2013 16:40:54 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Jun 2013 16:40:54 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: btrfs raid1 on 16TB: "INFO: task rsync:11022 blocked for more than
 180 seconds"
Date: Wed, 05 Jun 2013 15:40:44 +0100
Message-ID: <konil7$e2o$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Devs,

I have x4 4TB HDDs formatted with:

mkfs.btrfs -L bu-16TB_0 -d raid1 -m raid1 /dev/sd[cdef]


/etc/fstab mounts with the options:

noatime,noauto,space_cache,inode_cache


All on kernel 3.8.13.


Upon using rsync to copy some heavily hardlinked backups from ReiserFS,
I've so far had various:

"INFO: task rsync:11022 blocked for more than 180 seconds"

and one:

"INFO: task btrfs-endio-wri:10816 blocked for more than 180 seconds"

Further detail listed below.


What's the fix or any debug worthwhile?

Regards,
Martin



x1 of these:

kernel: INFO: task rsync:11022 blocked for more than 180 seconds.
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
kernel: rsync           D 0000000000000000     0 11022  11021 0x00000000
kernel: ffff88012b0ae360 0000000000000082 ffffffff815f1400 00000000000120c0
kernel: 0000000000004000 ffff880108a67fd8 0000000000000000 ffffffff810312ac
kernel: ffff8801115ae748 ffffffff810e3bad ffff8801115ae748 0000000000000081
kernel: Call Trace:
kernel: [<ffffffff810312ac>] ? ns_capable+0x33/0x46
kernel: [<ffffffff810e3bad>] ? generic_permission+0x19e/0x1fe
kernel: [<ffffffff810e427d>] ? __inode_permission+0x2f/0x6d
kernel: [<ffffffff810e3d63>] ? lookup_fast+0x39/0x23c
kernel: [<ffffffff811f464c>] ? wait_current_trans.isra.29+0xa9/0xd8
kernel: [<ffffffff810427f0>] ? abort_exclusive_wait+0x79/0x79
kernel: [<ffffffff811f5b59>] ? start_transaction+0x3de/0x408
kernel: [<ffffffff810f013c>] ? setattr_copy+0x8c/0xcb
kernel: [<ffffffff811ff22b>] ? btrfs_dirty_inode+0x24/0xa4
kernel: [<ffffffff810effe8>] ? notify_change+0x1f0/0x2b8
kernel: [<ffffffff810ff680>] ? utimes_common+0x10c/0x135
kernel: [<ffffffff810df445>] ? cp_new_stat+0x10d/0x11f
kernel: [<ffffffff810ff79a>] ? do_utimes+0xf1/0x129
kernel: [<ffffffff810df7d9>] ? sys_newlstat+0x23/0x2b
kernel: [<ffffffff810ff89b>] ? sys_utimensat+0x64/0x6b
kernel: [<ffffffff81431652>] ? system_call_fastpath+0x16/0x1b


x2 of these:

kernel: INFO: task rsync:11022 blocked for more than 180 seconds.
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
kernel: rsync           D 0000000000000000     0 11022  11021 0x00000000
kernel: ffff88012b0ae360 0000000000000082 ffffffff815f1400 00000000000120c0
kernel: 0000000000004000 ffff880108a67fd8 0000000000000000 ffffffff810e3d63
kernel: ffff88012b0ae360 ffffffff810e3b65 ffff88001e959ef8 0000000000000081
kernel: Call Trace:
kernel: [<ffffffff810e3d63>] ? lookup_fast+0x39/0x23c
kernel: [<ffffffff810e3b65>] ? generic_permission+0x156/0x1fe
kernel: [<ffffffff810e427d>] ? __inode_permission+0x2f/0x6d
kernel: [<ffffffff810e3d63>] ? lookup_fast+0x39/0x23c
kernel: [<ffffffff811f464c>] ? wait_current_trans.isra.29+0xa9/0xd8
kernel: [<ffffffff810427f0>] ? abort_exclusive_wait+0x79/0x79
kernel: [<ffffffff811f5b59>] ? start_transaction+0x3de/0x408
kernel: [<ffffffff810f013c>] ? setattr_copy+0x8c/0xcb
kernel: [<ffffffff811ff22b>] ? btrfs_dirty_inode+0x24/0xa4
kernel: [<ffffffff810effe8>] ? notify_change+0x1f0/0x2b8
kernel: [<ffffffff810ff680>] ? utimes_common+0x10c/0x135
kernel: [<ffffffff810df445>] ? cp_new_stat+0x10d/0x11f
kernel: [<ffffffff810ff79a>] ? do_utimes+0xf1/0x129
kernel: [<ffffffff810df7d9>] ? sys_newlstat+0x23/0x2b
kernel: [<ffffffff810ff89b>] ? sys_utimensat+0x64/0x6b
kernel: [<ffffffff81431652>] ? system_call_fastpath+0x16/0x1b


x7 of these:

kernel: INFO: task rsync:11022 blocked for more than 180 seconds.
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
kernel: rsync           D 0000000000000000     0 11022  11021 0x00000000
kernel: ffff88012b0ae360 0000000000000082 ffffffff815f1400 00000000000120c0
kernel: 0000000000004000 ffff880108a67fd8 ffff88010d9270c9 ffffffff810e520b
kernel: 00007fffd5adb458 ffffffff811e2fba ffff880108a67d88 ffffffff810e3411
kernel: Call Trace:
kernel: [<ffffffff810e520b>] ? path_init+0x1da/0x32c
kernel: [<ffffffff811e2fba>] ? reserve_metadata_bytes.isra.59+0x7b/0x741
kernel: [<ffffffff810e3411>] ? complete_walk+0x85/0xd6
kernel: [<ffffffff810ecfbc>] ? __d_lookup+0x60/0x122
kernel: [<ffffffff811f464c>] ? wait_current_trans.isra.29+0xa9/0xd8
kernel: [<ffffffff810427f0>] ? abort_exclusive_wait+0x79/0x79
kernel: [<ffffffff811f5b59>] ? start_transaction+0x3de/0x408
kernel: [<ffffffff810e5b96>] ? kern_path_create+0x78/0x110
kernel: [<ffffffff81200836>] ? btrfs_link+0x75/0x185
kernel: [<ffffffff810e4c11>] ? vfs_link+0x102/0x184
kernel: [<ffffffff810e7e90>] ? sys_linkat+0x16d/0x1c7
kernel: [<ffffffff81431652>] ? system_call_fastpath+0x16/0x1b


x1 of these:

kernel: INFO: task btrfs-endio-wri:10816 blocked for more than 180 seconds.
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
kernel: btrfs-endio-wri D 0000000000000000     0 10816      2 0x00000000
kernel: ffff880129bf4f80 0000000000000046 ffffffff815f1400 00000000000120c0
kernel: 0000000000004000 ffff88010c635fd8 ffff8801294404ea ffff880129440000
Mkernel: 0000000000000000 0000000000000050 0000000000000000 ffff880129e85240
kernel: Call Trace:
kernel: [<ffffffff810d2dbf>] ? kmem_cache_alloc+0x3e/0xde
kernel: [<ffffffff812077ad>] ? btrfs_put_ordered_extent+0x77/0xb3
kernel: [<ffffffff812077ad>] ? btrfs_put_ordered_extent+0x77/0xb3
kernel: [<ffffffff810d2749>] ? kmem_cache_free+0x53/0xf9
kernel: [<ffffffff811f464c>] ? wait_current_trans.isra.29+0xa9/0xd8
kernel: [<ffffffff810427f0>] ? abort_exclusive_wait+0x79/0x79
kernel: [<ffffffff811f5b59>] ? start_transaction+0x3de/0x408
kernel: [<ffffffff811fc988>] ? btrfs_finish_ordered_io+0x13f/0x2ee
kernel: [<ffffffff81034152>] ? usleep_range+0x3e/0x3e
kernel: [<ffffffff8121748e>] ? worker_loop+0x15f/0x435
kernel: [<ffffffff8121732f>] ? btrfs_queue_worker+0x258/0x258
kernel: [<ffffffff810420b3>] ? kthread+0xad/0xb5
kernel: [<ffffffff81042006>] ? __kthread_parkme+0x5e/0x5e
kernel: [<ffffffff814315ac>] ? ret_from_fork+0x7c/0xb0
kernel: [<ffffffff81042006>] ? __kthread_parkme+0x5e/0x5e







