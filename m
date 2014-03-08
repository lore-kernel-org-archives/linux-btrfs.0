Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shadow.officetone.com ([38.109.180.24]:45685 "EHLO
	shadow.officetone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaCHSqH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Mar 2014 13:46:07 -0500
Received: from maria.officetone.com (shadow.officetone.com [127.0.0.1])
	by shadow.officetone.com (Postfix) with ESMTP id F3E87168242
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Mar 2014 18:40:54 +0000 (UTC)
Message-ID: <531B6434.1080409@travislists.com>
Date: Sat, 08 Mar 2014 18:40:52 +0000
From: Travis Cross <tc@travislists.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs send kernel error btrfs_compare_tree
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings,

A call to:

  btrfs send -vvv -p <parent> <child> | ssh <host> "btrfs receive -vvve <dir>"

fails with:

ERROR: send ioctl failed with -5: Input/output error
ERROR: unexpected EOF in stream.

Resulting in the kernel log below on the sending system.  The key line
seems to be:

Mar  8 18:13:23 kernel: [ 2041.956270] btrfs: btrfs_compare_tree detected a change in one of the trees while iterating. This is probably a bug.

I've searched but Google didn't seem to find anyone reporting a
similar error.  This is running on Debian sid, fully up to date.  The
source drive is an Intel 320 SSD and smartctl doesn't indicate any
issues with it.

The read-only subvolumes acting as the parent and child would have
been created with an older kernel, perhaps 3.2.  I tried taking a new
read-only snapshot of the child and sending that, but the effect was
the same.  I also tried mounting the source filesystem read-only, but
there was no difference.  If I make a read-only snapshot of the parent
and send that snapshot as a child of the parent, that sends OK.

Please let me know if I can provide any further assistance in tracking
this down (and thanks for all the great work on btrfs).

$ uname -a
Linux 3.13-1-amd64 #1 SMP Debian 3.13.5-1 (2014-03-04) x86_64 GNU/Linux

Mar  8 18:12:51 kernel: [ 2009.568506] ------------[ cut here ]------------
Mar  8 18:12:51 kernel: [ 2009.568564] WARNING: CPU: 1 PID: 1264 at /build/linux-UvfduQ/linux-3.13.5/fs/btrfs/send.c:4687 btrfs_ioctl_send+0xba6/0xbc0 [btrfs]()
Mar  8 18:12:51 kernel: [ 2009.568569] Modules linked in: ext4 crc16 mbcache jbd2 iTCO_wdt coretemp iTCO_vendor_support psmouse serio_raw pcspkr i2c_i801 i2c_core lpc_ich mfd_core joydev evdev processor button thermal_sys raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx md_mod ipmi_si ipmi_devintf ipmi_msghandler autofs4 btrfs xor raid6_pq crc32c libcrc32c sg sd_mod crct10dif_generic crc_t10dif crct10dif_common hid_generic usbhid hid ata_generic ata_piix libata scsi_mod e1000e ptp pps_core ehci_pci uhci_hcd ehci_hcd usbcore usb_common
Mar  8 18:12:51 kernel: [ 2009.568635] CPU: 1 PID: 1264 Comm: btrfs Tainted: G        W    3.13-1-amd64 #1 Debian 3.13.5-1
Mar  8 18:12:51 kernel: [ 2009.568639] Hardware name: Supermicro X7SPA-HF/X7SPA-HF, BIOS 1.2a       02/21/12
Mar  8 18:12:51 kernel: [ 2009.568643]  0000000000000009 ffffffff814a0927 0000000000000000 ffffffff8105ba72
Mar  8 18:12:51 kernel: [ 2009.568652]  00007fff1006a1e8 ffff8800b92d9380 00007fff1006a1e8 ffff8800b92d9380
Mar  8 18:12:51 kernel: [ 2009.568658]  0000000000000001 ffffffffa0214e96 ffff88013fff9b08 ffff8800360f8000
Mar  8 18:12:51 kernel: [ 2009.568666] Call Trace:
Mar  8 18:12:51 kernel: [ 2009.568677]  [<ffffffff814a0927>] ? dump_stack+0x41/0x51
Mar  8 18:12:51 kernel: [ 2009.568685]  [<ffffffff8105ba72>] ? warn_slowpath_common+0x72/0x90
Mar  8 18:12:51 kernel: [ 2009.568714]  [<ffffffffa0214e96>] ? btrfs_ioctl_send+0xba6/0xbc0 [btrfs]
Mar  8 18:12:51 kernel: [ 2009.568723]  [<ffffffff8111eee9>] ? __alloc_pages_nodemask+0x149/0x9d0
Mar  8 18:12:51 kernel: [ 2009.568731]  [<ffffffff811607c9>] ? kmem_getpages+0xb9/0x140
Mar  8 18:12:51 kernel: [ 2009.568758]  [<ffffffffa01e4b6a>] ? btrfs_ioctl+0xfca/0x25d0 [btrfs]
Mar  8 18:12:51 kernel: [ 2009.568766]  [<ffffffff8108706c>] ? set_task_cpu+0x5c/0x160
Mar  8 18:12:51 kernel: [ 2009.568775]  [<ffffffff8126f860>] ? cpumask_next_and+0x30/0x40
Mar  8 18:12:51 kernel: [ 2009.568781]  [<ffffffff8108d4ef>] ? select_task_rq_fair+0x2af/0x6f0
Mar  8 18:12:51 kernel: [ 2009.568789]  [<ffffffff8101981f>] ? native_sched_clock+0xf/0x70
Mar  8 18:12:51 kernel: [ 2009.568796]  [<ffffffff8108f827>] ? enqueue_task_fair+0x2c7/0xe10
Mar  8 18:12:51 kernel: [ 2009.568803]  [<ffffffff81086e25>] ? check_preempt_curr+0x65/0x90
Mar  8 18:12:51 kernel: [ 2009.568810]  [<ffffffff81088c45>] ? wake_up_new_task+0xd5/0x160
Mar  8 18:12:51 kernel: [ 2009.568817]  [<ffffffff8118b5bf>] ? do_vfs_ioctl+0x2cf/0x4a0
Mar  8 18:12:51 kernel: [ 2009.568823]  [<ffffffff8118b810>] ? SyS_ioctl+0x80/0xa0
Mar  8 18:12:51 kernel: [ 2009.568831]  [<ffffffff814ade99>] ? stub_clone+0x69/0x90
Mar  8 18:12:51 kernel: [ 2009.568838]  [<ffffffff814adb39>] ? system_call_fastpath+0x16/0x1b
Mar  8 18:12:51 kernel: [ 2009.568843] ---[ end trace 627af7edfbb43119 ]---
Mar  8 18:13:23 kernel: [ 2041.956215] ------------[ cut here ]------------
Mar  8 18:13:23 kernel: [ 2041.956264] WARNING: CPU: 1 PID: 1264 at /build/linux-UvfduQ/linux-3.13.5/fs/btrfs/ctree.c:5246 btrfs_compare_trees+0x461/0x960 [btrfs]()
Mar  8 18:13:23 kernel: [ 2041.956270] btrfs: btrfs_compare_tree detected a change in one of the trees while iterating. This is probably a bug.
Mar  8 18:13:23 kernel: [ 2041.956274] Modules linked in: ext4 crc16 mbcache jbd2 iTCO_wdt coretemp iTCO_vendor_support psmouse serio_raw pcspkr i2c_i801 i2c_core lpc_ich mfd_core joydev evdev processor button thermal_sys raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx md_mod ipmi_si ipmi_devintf ipmi_msghandler autofs4 btrfs xor raid6_pq crc32c libcrc32c sg sd_mod crct10dif_generic crc_t10dif crct10dif_common hid_generic usbhid hid ata_generic ata_piix libata scsi_mod e1000e ptp pps_core ehci_pci uhci_hcd ehci_hcd usbcore usb_common
Mar  8 18:13:23 kernel: [ 2041.956358] CPU: 1 PID: 1264 Comm: btrfs Tainted: G        W    3.13-1-amd64 #1 Debian 3.13.5-1
Mar  8 18:13:23 kernel: [ 2041.956363] Hardware name: Supermicro X7SPA-HF/X7SPA-HF, BIOS 1.2a       02/21/12
Mar  8 18:13:23 kernel: [ 2041.956368]  0000000000000009 ffffffff814a0927 ffff8800b4df7bc8 ffffffff8105ba72
Mar  8 18:13:23 kernel: [ 2041.956380]  ffff8800ba272100 ffff8800b4df7c18 ffff8800b920f000 0000000000000001
Mar  8 18:13:23 kernel: [ 2041.956389]  0000000000000000 ffffffff8105bad7 ffffffffa0225c70 ffffffff00000018
Mar  8 18:13:23 kernel: [ 2041.956399] Call Trace:
Mar  8 18:13:23 kernel: [ 2041.956414]  [<ffffffff814a0927>] ? dump_stack+0x41/0x51
Mar  8 18:13:23 kernel: [ 2041.956426]  [<ffffffff8105ba72>] ? warn_slowpath_common+0x72/0x90
Mar  8 18:13:23 kernel: [ 2041.956435]  [<ffffffff8105bad7>] ? warn_slowpath_fmt+0x47/0x50
Mar  8 18:13:23 kernel: [ 2041.956468]  [<ffffffffa0195a61>] ? btrfs_compare_trees+0x461/0x960 [btrfs]
Mar  8 18:13:23 kernel: [ 2041.956504]  [<ffffffffa0213920>] ? process_extent+0x1130/0x1130 [btrfs]
Mar  8 18:13:23 kernel: [ 2041.956542]  [<ffffffffa0214b20>] ? btrfs_ioctl_send+0x830/0xbc0 [btrfs]
Mar  8 18:13:23 kernel: [ 2041.956554]  [<ffffffff8111eee9>] ? __alloc_pages_nodemask+0x149/0x9d0
Mar  8 18:13:23 kernel: [ 2041.956589]  [<ffffffffa01e4b6a>] ? btrfs_ioctl+0xfca/0x25d0 [btrfs]
Mar  8 18:13:23 kernel: [ 2041.956600]  [<ffffffff8108706c>] ? set_task_cpu+0x5c/0x160
Mar  8 18:13:23 kernel: [ 2041.956612]  [<ffffffff8126f860>] ? cpumask_next_and+0x30/0x40
Mar  8 18:13:23 kernel: [ 2041.956621]  [<ffffffff8108d4ef>] ? select_task_rq_fair+0x2af/0x6f0
Mar  8 18:13:23 kernel: [ 2041.956631]  [<ffffffff8101981f>] ? native_sched_clock+0xf/0x70
Mar  8 18:13:23 kernel: [ 2041.956641]  [<ffffffff8108f827>] ? enqueue_task_fair+0x2c7/0xe10
Mar  8 18:13:23 kernel: [ 2041.956650]  [<ffffffff81086e25>] ? check_preempt_curr+0x65/0x90
Mar  8 18:13:23 kernel: [ 2041.956661]  [<ffffffff81088c45>] ? wake_up_new_task+0xd5/0x160
Mar  8 18:13:23 kernel: [ 2041.956672]  [<ffffffff8118b5bf>] ? do_vfs_ioctl+0x2cf/0x4a0
Mar  8 18:13:23 kernel: [ 2041.956681]  [<ffffffff8118b810>] ? SyS_ioctl+0x80/0xa0
Mar  8 18:13:23 kernel: [ 2041.956691]  [<ffffffff814ade99>] ? stub_clone+0x69/0x90
Mar  8 18:13:23 kernel: [ 2041.956701]  [<ffffffff814adb39>] ? system_call_fastpath+0x16/0x1b
Mar  8 18:13:23 kernel: [ 2041.956707] ---[ end trace 627af7edfbb4311a ]---

Cheers,

-- TC
