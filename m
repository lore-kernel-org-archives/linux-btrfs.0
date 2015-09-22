Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36676 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933369AbbIVNiQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 09:38:16 -0400
Received: by wicgb1 with SMTP id gb1so160554365wic.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 06:38:15 -0700 (PDT)
Received: from localhost (ip5f5ba60a.dynamic.kabel-deutschland.de. [95.91.166.10])
        by smtp.gmail.com with ESMTPSA id ex17sm3201818wid.23.2015.09.22.06.38.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Sep 2015 06:38:14 -0700 (PDT)
Date: Tue, 22 Sep 2015 15:38:13 +0200
From: "S. Fricke" <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: problem with long running btrfs mount operation
Message-ID: <20150922133813.GA14395@sfserver>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a problem with one of my btrfs hdds. If I mount it, it needs more than
135 minutes for this operation. After the mounting it works normaly. This is
reproducible only with this hdd.

Maybe someone has a clue what is going wrong here.


Silvio

% uname -a
Linux develbox 4.1.6-1-ARCH #1 SMP PREEMPT Mon Aug 17 08:52:28 CEST 2015 x86_64 GNU/Linux
% btrfs --version
btrfs-progs v4.2
% sudo btrfs fi show
Label: none  uuid: 2299f474-aae8-4d43-909c-d69f724ea65d
        Total devices 1 FS bytes used 203.54GiB
        devid    1 size 911.51GiB used 215.04GiB path /dev/sdb2

Label: none  uuid: 4db27f9b-d8fe-4341-985a-4ce55ea9fd25
        Total devices 1 FS bytes used 668.39GiB
        devid    1 size 867.11GiB used 710.06GiB path /dev/sda1
% sudo btrfs fi df /storage
Data, single: total=632.00GiB, used=631.98GiB
System, DUP: total=32.00MiB, used=96.00KiB
Metadata, DUP: total=39.00GiB, used=36.41GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

And the related parts to btrfs from dmesg:

[Sep22 12:48] INFO: task btrfs-transacti:3280 blocked for more than 120 seconds.
[  +0.000096]       Tainted: P           O    4.1.6-1-ARCH #1
[  +0.000085] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  +0.000117] btrfs-transacti D ffff880ffe55fd68     0  3280      2 0x00000000
[  +0.000004]  ffff880ffe55fd68 ffff881008068000 ffff881006ad8a30 ffff880ffe55fdd8
[  +0.000002]  ffff880ffe560000 ffff880fff1811f0 ffff880fff1811f0 ffff880febdb60b0
[  +0.000002]  0000000000000000 ffff880ffe55fd88 ffffffff81588377 ffff880fff1811f0
[  +0.000002] Call Trace:
[  +0.000008]  [<ffffffff81588377>] schedule+0x37/0x90
[  +0.000013]  [<ffffffffa0f088ef>] wait_current_trans.isra.9+0xcf/0x120 [btrfs]
[  +0.000005]  [<ffffffff810bc720>] ? wake_atomic_t_function+0x60/0x60
[  +0.000007]  [<ffffffffa0f0a598>] start_transaction+0x3e8/0x5b0 [btrfs]
[  +0.000006]  [<ffffffffa0f0a817>] btrfs_attach_transaction+0x17/0x20 [btrfs]
[  +0.000006]  [<ffffffffa0f04f8e>] transaction_kthread+0x18e/0x240 [btrfs]
[  +0.000006]  [<ffffffffa0f04e00>] ? btrfs_cleanup_transaction+0x5a0/0x5a0 [btrfs]
[  +0.000004]  [<ffffffff81097868>] kthread+0xd8/0xf0
[  +0.000003]  [<ffffffff81097790>] ? kthread_worker_fn+0x170/0x170
[  +0.000003]  [<ffffffff8158c3a2>] ret_from_fork+0x42/0x70
[  +0.000002]  [<ffffffff81097790>] ? kthread_worker_fn+0x170/0x170
[Sep22 12:50] INFO: task btrfs-transacti:3280 blocked for more than 120 seconds.
[  +0.000096]       Tainted: P           O    4.1.6-1-ARCH #1
[  +0.000085] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  +0.000117] btrfs-transacti D ffff880ffe55fd68     0  3280      2 0x00000000
[  +0.000004]  ffff880ffe55fd68 ffff881008068000 ffff881006ad8a30 ffff880ffe55fdd8
[  +0.000002]  ffff880ffe560000 ffff880fff1811f0 ffff880fff1811f0 ffff880febdb60b0
[  +0.000002]  0000000000000000 ffff880ffe55fd88 ffffffff81588377 ffff880fff1811f0
[  +0.000002] Call Trace:
[  +0.000008]  [<ffffffff81588377>] schedule+0x37/0x90
[  +0.000014]  [<ffffffffa0f088ef>] wait_current_trans.isra.9+0xcf/0x120 [btrfs]
[  +0.000005]  [<ffffffff810bc720>] ? wake_atomic_t_function+0x60/0x60
[  +0.000007]  [<ffffffffa0f0a598>] start_transaction+0x3e8/0x5b0 [btrfs]
[  +0.000006]  [<ffffffffa0f0a817>] btrfs_attach_transaction+0x17/0x20 [btrfs]
[  +0.000006]  [<ffffffffa0f04f8e>] transaction_kthread+0x18e/0x240 [btrfs]
[  +0.000006]  [<ffffffffa0f04e00>] ? btrfs_cleanup_transaction+0x5a0/0x5a0 [btrfs]
[  +0.000003]  [<ffffffff81097868>] kthread+0xd8/0xf0
[  +0.000002]  [<ffffffff81097790>] ? kthread_worker_fn+0x170/0x170
[  +0.000003]  [<ffffffff8158c3a2>] ret_from_fork+0x42/0x70
[  +0.000002]  [<ffffffff81097790>] ? kthread_worker_fn+0x170/0x170
[Sep22 13:07] INFO: task mount:3257 blocked for more than 120 seconds.
[  +0.000092]       Tainted: P           O    4.1.6-1-ARCH #1
[  +0.000086] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  +0.000116] mount           D ffff880fff70f958     0  3257   3256 0x00000000
[  +0.000004]  ffff880fff70f958 ffff88100879bd20 ffff880fff0a0a30 0000000000000001
[  +0.000003]  ffff880fff710000 ffff880fff1811f0 ffff880fff1811f0 ffff880febd524d0
[  +0.000002]  0000000000000001 ffff880fff70f978 ffffffff81588377 ffff880fff1811f0
[  +0.000002] Call Trace:
[  +0.000008]  [<ffffffff81588377>] schedule+0x37/0x90
[  +0.000014]  [<ffffffffa0f088ef>] wait_current_trans.isra.9+0xcf/0x120 [btrfs]
[  +0.000004]  [<ffffffff810bc720>] ? wake_atomic_t_function+0x60/0x60
[  +0.000007]  [<ffffffffa0f0a5eb>] start_transaction+0x43b/0x5b0 [btrfs]
[  +0.000007]  [<ffffffffa0efa910>] ? btrfs_update_root+0xf0/0x290 [btrfs]
[  +0.000007]  [<ffffffffa0f0a77b>] btrfs_start_transaction+0x1b/0x20 [btrfs]
[  +0.000006]  [<ffffffffa0ef62fb>] btrfs_drop_snapshot+0x57b/0x8a0 [btrfs]
[  +0.000008]  [<ffffffffa0f610b9>] merge_reloc_roots+0xe9/0x280 [btrfs]
[  +0.000007]  [<ffffffffa0f62002>] btrfs_recover_relocation+0x3b2/0x460 [btrfs]
[  +0.000006]  [<ffffffffa0f06e45>] open_ctree+0x1ab5/0x21c0 [btrfs]
[  +0.000005]  [<ffffffffa0eda8bf>] btrfs_mount+0x83f/0x910 [btrfs]
[  +0.000004]  [<ffffffff812de5e5>] ? find_next_bit+0x15/0x30
[  +0.000002]  [<ffffffff81188a7a>] ? pcpu_alloc+0x39a/0x6a0
[  +0.000003]  [<ffffffff811e5078>] mount_fs+0x38/0x190
[  +0.000002]  [<ffffffff81188db5>] ? __alloc_percpu+0x15/0x20
[  +0.000002]  [<ffffffff8120139b>] vfs_kern_mount+0x6b/0x120
[  +0.000003]  [<ffffffff81203c9a>] do_mount+0x24a/0xd40
[  +0.000002]  [<ffffffff81204ae3>] SyS_mount+0xa3/0x110
[  +0.000003]  [<ffffffff8158bfae>] system_call_fastpath+0x12/0x71
[Sep22 13:09] INFO: task mount:3257 blocked for more than 120 seconds.
[  +0.000093]       Tainted: P           O    4.1.6-1-ARCH #1
[  +0.000086] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  +0.000116] mount           D ffff880fff70f958     0  3257   3256 0x00000000
[  +0.000004]  ffff880fff70f958 ffff88100879bd20 ffff880fff0a0a30 0000000000000001
[  +0.000002]  ffff880fff710000 ffff880fff1811f0 ffff880fff1811f0 ffff880febd524d0
[  +0.000002]  0000000000000001 ffff880fff70f978 ffffffff81588377 ffff880fff1811f0
[  +0.000002] Call Trace:
[  +0.000008]  [<ffffffff81588377>] schedule+0x37/0x90
[  +0.000014]  [<ffffffffa0f088ef>] wait_current_trans.isra.9+0xcf/0x120 [btrfs]
[  +0.000005]  [<ffffffff810bc720>] ? wake_atomic_t_function+0x60/0x60
[  +0.000007]  [<ffffffffa0f0a5eb>] start_transaction+0x43b/0x5b0 [btrfs]
[  +0.000007]  [<ffffffffa0efa910>] ? btrfs_update_root+0xf0/0x290 [btrfs]
[  +0.000006]  [<ffffffffa0f0a77b>] btrfs_start_transaction+0x1b/0x20 [btrfs]
[  +0.000007]  [<ffffffffa0ef62fb>] btrfs_drop_snapshot+0x57b/0x8a0 [btrfs]
[  +0.000007]  [<ffffffffa0f610b9>] merge_reloc_roots+0xe9/0x280 [btrfs]
[  +0.000007]  [<ffffffffa0f62002>] btrfs_recover_relocation+0x3b2/0x460 [btrfs]
[  +0.000007]  [<ffffffffa0f06e45>] open_ctree+0x1ab5/0x21c0 [btrfs]
[  +0.000005]  [<ffffffffa0eda8bf>] btrfs_mount+0x83f/0x910 [btrfs]
[  +0.000003]  [<ffffffff812de5e5>] ? find_next_bit+0x15/0x30
[  +0.000002]  [<ffffffff81188a7a>] ? pcpu_alloc+0x39a/0x6a0
[  +0.000004]  [<ffffffff811e5078>] mount_fs+0x38/0x190
[  +0.000001]  [<ffffffff81188db5>] ? __alloc_percpu+0x15/0x20
[  +0.000003]  [<ffffffff8120139b>] vfs_kern_mount+0x6b/0x120
[  +0.000002]  [<ffffffff81203c9a>] do_mount+0x24a/0xd40
[  +0.000003]  [<ffffffff81204ae3>] SyS_mount+0xa3/0x110
[  +0.000003]  [<ffffffff8158bfae>] system_call_fastpath+0x12/0x71
[Sep22 14:53] ------------[ cut here ]------------
[  +0.000018] WARNING: CPU: 1 PID: 3257 at fs/btrfs/extent-tree.c:6283 __btrfs_free_extent+0x9a1/0xc80 [btrfs]()
[  +0.000001] Modules linked in: nls_utf8 ntfs uas usb_storage pci_stub vboxpci(O) vboxnetflt(O) vboxnetadp(O) vboxdrv(O) fuse bridge stp llc msr ax88179_178a usbnet btrfs mii joydev mousedev xor raid6_pq intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_realtek snd_hda_codec_hdmi kvm_i
[  +0.000044]  oid_registry nfs_acl lockd grace sunrpc fscache ip_tables x_tables ext4 crc16 mbcache jbd2 sd_mod hid_generic usbhid hid atkbd libps2 isci ahci libsas libahci scsi_transport_sas xhci_pci xhci_hcd ehci_pci ehci_hcd libata usbcore usb_common scsi_mod i8042 serio button
[  +0.000020] CPU: 1 PID: 3257 Comm: mount Tainted: P           O    4.1.6-1-ARCH #1
[  +0.000002] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A13 05/11/2014
[  +0.000001]  0000000000000000 00000000015cd577 ffff880fff70f708 ffffffff815866ee
[  +0.000003]  0000000000000000 0000000000000000 ffff880fff70f748 ffffffff81078cba
[  +0.000001]  0000000000001000 000001bc7a3b9000 ffff880ffe4ee000 ffff880f0738ab40
[  +0.000003] Call Trace:
[  +0.000006]  [<ffffffff815866ee>] dump_stack+0x4c/0x6e
[  +0.000004]  [<ffffffff81078cba>] warn_slowpath_common+0x8a/0xc0
[  +0.000001]  [<ffffffff81078dea>] warn_slowpath_null+0x1a/0x20
[  +0.000006]  [<ffffffffa0eee081>] __btrfs_free_extent+0x9a1/0xc80 [btrfs]
[  +0.000007]  [<ffffffffa0ef2f17>] __btrfs_run_delayed_refs+0xa17/0x1310 [btrfs]
[  +0.000004]  [<ffffffff812f358d>] ? __percpu_counter_add+0x5d/0xa0
[  +0.000005]  [<ffffffffa0eeb17a>] ? add_pinned_bytes+0x4a/0x60 [btrfs]
[  +0.000006]  [<ffffffffa0ef3fb7>] ? walk_up_proc+0xd7/0x500 [btrfs]
[  +0.000007]  [<ffffffffa0ef7c53>] btrfs_run_delayed_refs.part.36+0x73/0x270 [btrfs]
[  +0.000006]  [<ffffffffa0ef7e65>] btrfs_run_delayed_refs+0x15/0x30 [btrfs]
[  +0.000007]  [<ffffffffa0f08eea>] btrfs_should_end_transaction+0x5a/0x60 [btrfs]
[  +0.000007]  [<ffffffffa0ef61d5>] btrfs_drop_snapshot+0x455/0x8a0 [btrfs]
[  +0.000007]  [<ffffffffa0f610b9>] merge_reloc_roots+0xe9/0x280 [btrfs]
[  +0.000007]  [<ffffffffa0f62002>] btrfs_recover_relocation+0x3b2/0x460 [btrfs]
[  +0.000007]  [<ffffffffa0f06e45>] open_ctree+0x1ab5/0x21c0 [btrfs]
[  +0.000005]  [<ffffffffa0eda8bf>] btrfs_mount+0x83f/0x910 [btrfs]
[  +0.000003]  [<ffffffff812de5e5>] ? find_next_bit+0x15/0x30
[  +0.000002]  [<ffffffff81188a7a>] ? pcpu_alloc+0x39a/0x6a0
[  +0.000003]  [<ffffffff811e5078>] mount_fs+0x38/0x190
[  +0.000002]  [<ffffffff81188db5>] ? __alloc_percpu+0x15/0x20
[  +0.000003]  [<ffffffff8120139b>] vfs_kern_mount+0x6b/0x120
[  +0.000002]  [<ffffffff81203c9a>] do_mount+0x24a/0xd40
[  +0.000002]  [<ffffffff81204ae3>] SyS_mount+0xa3/0x110
[  +0.000003]  [<ffffffff8158bfae>] system_call_fastpath+0x12/0x71
[  +0.000002] ---[ end trace 8284bbbaadd0330d ]---
[Sep22 14:55] BTRFS: checking UUID tree
[  +0.000076] BTRFS info (device sda1): continuing balance
[  +0.224293] BTRFS info (device sda1): relocating block group 1910283173888 flags 36
[Sep22 14:58] ------------[ cut here ]------------
[  +0.000020] WARNING: CPU: 1 PID: 7584 at fs/btrfs/extent-tree.c:6283 __btrfs_free_extent+0x9a1/0xc80 [btrfs]()
[  +0.000002] Modules linked in: nls_utf8 ntfs uas usb_storage pci_stub vboxpci(O) vboxnetflt(O) vboxnetadp(O) vboxdrv(O) fuse bridge stp llc msr ax88179_178a usbnet btrfs mii joydev mousedev xor raid6_pq intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_realtek snd_hda_codec_hdmi kvm_i
[  +0.000043]  oid_registry nfs_acl lockd grace sunrpc fscache ip_tables x_tables ext4 crc16 mbcache jbd2 sd_mod hid_generic usbhid hid atkbd libps2 isci ahci libsas libahci scsi_transport_sas xhci_pci xhci_hcd ehci_pci ehci_hcd libata usbcore usb_common scsi_mod i8042 serio button
[  +0.000020] CPU: 1 PID: 7584 Comm: btrfs-balance Tainted: P        W  O    4.1.6-1-ARCH #1
[  +0.000002] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A13 05/11/2014
[  +0.000002]  0000000000000000 000000009d52dc0b ffff880eb6b5f808 ffffffff815866ee
[  +0.000002]  0000000000000000 0000000000000000 ffff880eb6b5f848 ffffffff81078cba
[  +0.000002]  0000000000001000 000001bc7a3b9000 ffff880ffe4ee000 ffff88009ffbb3f0
[  +0.000003] Call Trace:
[  +0.000006]  [<ffffffff815866ee>] dump_stack+0x4c/0x6e
[  +0.000003]  [<ffffffff81078cba>] warn_slowpath_common+0x8a/0xc0
[  +0.000002]  [<ffffffff81078dea>] warn_slowpath_null+0x1a/0x20
[  +0.000006]  [<ffffffffa0eee081>] __btrfs_free_extent+0x9a1/0xc80 [btrfs]
[  +0.000007]  [<ffffffffa0ef2f17>] __btrfs_run_delayed_refs+0xa17/0x1310 [btrfs]
[  +0.000006]  [<ffffffffa0ef3fb7>] ? walk_up_proc+0xd7/0x500 [btrfs]
[  +0.000007]  [<ffffffffa0ef7c53>] btrfs_run_delayed_refs.part.36+0x73/0x270 [btrfs]
[  +0.000006]  [<ffffffffa0ef7e65>] btrfs_run_delayed_refs+0x15/0x30 [btrfs]
[  +0.000007]  [<ffffffffa0f08eea>] btrfs_should_end_transaction+0x5a/0x60 [btrfs]
[  +0.000007]  [<ffffffffa0ef61d5>] btrfs_drop_snapshot+0x455/0x8a0 [btrfs]
[  +0.000008]  [<ffffffffa0f610b9>] merge_reloc_roots+0xe9/0x280 [btrfs]
[  +0.000006]  [<ffffffffa0f614be>] relocate_block_group+0x26e/0x720 [btrfs]
[  +0.000007]  [<ffffffffa0f61b46>] btrfs_relocate_block_group+0x1d6/0x2e0 [btrfs]
[  +0.000007]  [<ffffffffa0f33a9e>] btrfs_relocate_chunk.isra.20+0x3e/0xc0 [btrfs]
[  +0.000007]  [<ffffffffa0f352e4>] btrfs_balance+0xa04/0xf90 [btrfs]
[  +0.000007]  [<ffffffffa0f358cd>] balance_kthread+0x5d/0x80 [btrfs]
[  +0.000006]  [<ffffffffa0f35870>] ? btrfs_balance+0xf90/0xf90 [btrfs]
[  +0.000004]  [<ffffffff81097868>] kthread+0xd8/0xf0
[  +0.000002]  [<ffffffff81097790>] ? kthread_worker_fn+0x170/0x170
[  +0.000004]  [<ffffffff8158c3a2>] ret_from_fork+0x42/0x70
[  +0.000002]  [<ffffffff81097790>] ? kthread_worker_fn+0x170/0x170
[  +0.000001] ---[ end trace 8284bbbaadd0330e ]---
[Sep22 15:03] BTRFS info (device sda1): found 11029 extents



-- 
-- S. Fricke ---------------------------------------- silvio@port1024.net --
   Diplom-Informatiker (FH)
   Linux-Entwicklung             JABBER: silvio@conversation.port1024.net   
----------------------------------------------------------------------------
