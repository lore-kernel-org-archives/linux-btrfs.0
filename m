Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33538 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbbHRAIE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Aug 2015 20:08:04 -0400
Received: by wijp15 with SMTP id p15so87075941wij.0
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2015 17:08:02 -0700 (PDT)
Received: from capella.inverchapel.me.uk (host-78-148-112-62.as13285.net. [78.148.112.62])
        by smtp.gmail.com with ESMTPSA id lg8sm18826019wic.12.2015.08.17.17.08.01
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Aug 2015 17:08:01 -0700 (PDT)
From: derek@valedon.co.uk
To: linux-btrfs@vger.kernel.org
Subject: kernel BUG as fs/btrfs/extent-tree/c:1833 while executing device remove under 4.2.0-rc5
Message-Id: <20150818000742.5D181132F@capella.inverchapel.me.uk>
Date: Tue, 18 Aug 2015 01:07:42 +0100 (BST)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A couple of days ago while running 4.2.0-RC5 I had a suspected fault on one of the disks of my 6-disk RAID-1 btrfs filesystem so removed the offending drive and tried a "btrfs device remove...". 

While trying it, the system repeated hung with a kernel BUG after varying amounts of time ranging from a couple of minutes to over an hour. I eventually booted the Debian release kernel 4.1.0-1 and completed the device remove using that without any error.

The kernel only local modification to the kernel was the change the export of one sysmbol in workqueue.c to allow installation of the latest NVIDIA driver (hence the Tainted and -dirty on the version below).

Aug 15 10:42:44 capella kernel: ------------[ cut here ]------------
Aug 15 10:42:44 capella kernel: kernel BUG at fs/btrfs/extent-tree.c:1833!
Aug 15 10:42:44 capella kernel: invalid opcode: 0000 [#1] SMP 
Aug 15 10:42:44 capella kernel: Modules linked in: nfsd nfs_acl rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache qt1010 af9013 dvb_usb_af9015 dvb_usb_v2 dvb_core rc_core sp5100_tco kvm_amd kvm pcspkr snd_hda_codec_hdmi evdev amd64_edac_mod edac_mce_amd edac_core nvidia(PO) i2c_piix4 snd_hda_intel snd_hda_codec snd_hda_core sg snd_hwdep snd_pcm tpm_infineon tpm_tis tpm snd_timer snd soundcore drm acpi_cpufreq processor thermal_sys button shpchp md_mod k10temp jc42 i2c_core loop parport_pc ppdev lp parport autofs4 ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor raid6_pq dm_mod hid_generic usbhid hid sd_mod usb_storage ohci_pci tg3 ptp pps_core libphy ahci libahci libata ehci_pci ohci_hcd ehci_hcd scsi_mod usbcore usb_common
Aug 15 10:42:44 capella kernel: CPU: 1 PID: 95 Comm: kworker/u8:7 Tainted: P           O    4.2.0-rc5-derek-00033-g6c84461-dirty #5
Aug 15 10:42:44 capella kernel: Hardware name: HP ProLiant MicroServer, BIOS O41     10/01/2013
Aug 15 10:42:44 capella kernel: Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
Aug 15 10:42:44 capella kernel: task: ffff880213b8cd00 ti: ffff880213b90000 task.ti: ffff880213b90000
Aug 15 10:42:44 capella kernel: RIP: 0010:[<ffffffffa020e4b3>]  [<ffffffffa020e4b3>] insert_inline_extent_backref+0xe3/0xf0 [btrfs]
Aug 15 10:42:44 capella kernel: RSP: 0018:ffff880213b93af8  EFLAGS: 00010293
Aug 15 10:42:44 capella kernel: RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
Aug 15 10:42:44 capella kernel: RDX: ffff880000000000 RSI: 0000000000000001 RDI: 0000000000000000
Aug 15 10:42:44 capella kernel: RBP: ffff8800daef2800 R08: 0000000000004000 R09: ffff880213b93a08
Aug 15 10:42:44 capella kernel: R10: 0000000000000000 R11: 0000000000000003 R12: ffff8801d797dad0
Aug 15 10:42:44 capella kernel: R13: 0000000000004b18 R14: 0000000000000000 R15: 00001c7de0f8c000
Aug 15 10:42:44 capella kernel: FS:  00007fab947cb8c0(0000) GS:ffff88021fc80000(0000) knlGS:0000000000000000
Aug 15 10:42:44 capella kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 15 10:42:44 capella kernel: CR2: 00000000010928d8 CR3: 00000000aa465000 CR4: 00000000000006e0
Aug 15 10:42:44 capella kernel: Stack:
Aug 15 10:42:44 capella kernel:  00001c7de0f8c000 0000000000004b18 0000000000000000 0000000000000000
Aug 15 10:42:44 capella kernel:  0000000000000001 0000000000000282 ffff8801d797dad0 ffffffffa020f9c0
Aug 15 10:42:44 capella kernel:  ffff880213b93bb4 00000000000034bd ffff8801d797dae0 ffff8800db81b000
Aug 15 10:42:44 capella kernel: Call Trace:
Aug 15 10:42:44 capella kernel:  [<ffffffffa020f9c0>] ? __btrfs_free_extent.isra.68+0x320/0xd50 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffffa020e927>] ? __btrfs_inc_extent_ref.isra.52+0xa7/0x280 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffffa0273fb2>] ? find_ref_head+0x52/0x70 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffffa0213ce1>] ? __btrfs_run_delayed_refs+0xc41/0x1070 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffff8101c6a5>] ? sched_clock+0x5/0x10
Aug 15 10:42:44 capella kernel:  [<ffffffff811b9292>] ? __sb_start_write+0x42/0xe0
Aug 15 10:42:44 capella kernel:  [<ffffffffa0216c81>] ? btrfs_run_delayed_refs.part.73+0x71/0x270 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffff8109aef0>] ? update_curr+0xb0/0xf0
Aug 15 10:42:44 capella kernel:  [<ffffffffa0216f18>] ? delayed_ref_async_start+0x78/0x90 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffffa0259bb0>] ? btrfs_scrubparity_helper+0xc0/0x280 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffff81083401>] ? process_one_work+0x1a1/0x430
Aug 15 10:42:44 capella kernel:  [<ffffffff810836d7>] ? worker_thread+0x47/0x4a0
Aug 15 10:42:44 capella kernel:  [<ffffffff81083690>] ? process_one_work+0x430/0x430
Aug 15 10:42:44 capella kernel:  [<ffffffff810890f1>] ? kthread+0xc1/0xe0
Aug 15 10:42:44 capella kernel:  [<ffffffff81089030>] ? kthread_worker_fn+0x170/0x170
Aug 15 10:42:44 capella kernel:  [<ffffffff81539b9f>] ? ret_from_fork+0x3f/0x70
Aug 15 10:42:44 capella kernel:  [<ffffffff81089030>] ? kthread_worker_fn+0x170/0x170
Aug 15 10:42:44 capella kernel: Code: 89 d9 4c 89 34 24 4d 89 e8 4c 89 f9 4c 89 e6 48 89 ef 48 89 44 24 10 8b 84 24 a8 00 00 00 89 44 24 08 e8 f1 d6 ff ff 31 c0 eb b3 <0f> 0b 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 56 41 
Aug 15 10:42:44 capella kernel: RIP  [<ffffffffa020e4b3>] insert_inline_extent_backref+0xe3/0xf0 [btrfs]
Aug 15 10:42:44 capella kernel:  RSP <ffff880213b93af8>
Aug 15 10:42:44 capella kernel: ---[ end trace 1cdbb5a82e302412 ]---
Aug 15 10:42:44 capella kernel: BUG: unable to handle kernel paging request at ffffffffffffffd8
Aug 15 10:42:44 capella kernel: IP: [<ffffffff8108951c>] kthread_data+0xc/0x20
Aug 15 10:42:44 capella kernel: PGD 180f067 PUD 1811067 PMD 0 
Aug 15 10:42:44 capella kernel: Oops: 0000 [#2] SMP 
Aug 15 10:42:44 capella kernel: Modules linked in: nfsd nfs_acl rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache qt1010 af9013 dvb_usb_af9015 dvb_usb_v2 dvb_core rc_core sp5100_tco kvm_amd kvm pcspkr snd_hda_codec_hdmi evdev amd64_edac_mod edac_mce_amd edac_core nvidia(PO) i2c_piix4 snd_hda_intel snd_hda_codec snd_hda_core sg snd_hwdep snd_pcm tpm_infineon tpm_tis tpm snd_timer snd soundcore drm acpi_cpufreq processor thermal_sys button shpchp md_mod k10temp jc42 i2c_core loop parport_pc ppdev lp parport autofs4 ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor raid6_pq dm_mod hid_generic usbhid hid sd_mod usb_storage ohci_pci tg3 ptp pps_core libphy ahci libahci libata ehci_pci ohci_hcd ehci_hcd scsi_mod usbcore usb_common
Aug 15 10:42:44 capella kernel: CPU: 1 PID: 95 Comm: kworker/u8:7 Tainted: P      D    O    4.2.0-rc5-derek-00033-g6c84461-dirty #5
Aug 15 10:42:44 capella kernel: Hardware name: HP ProLiant MicroServer, BIOS O41     10/01/2013
Aug 15 10:42:44 capella kernel: task: ffff880213b8cd00 ti: ffff880213b90000 task.ti: ffff880213b90000
Aug 15 10:42:44 capella kernel: RIP: 0010:[<ffffffff8108951c>]  [<ffffffff8108951c>] kthread_data+0xc/0x20
Aug 15 10:42:44 capella kernel: RSP: 0018:ffff880213b93880  EFLAGS: 00010002
Aug 15 10:42:44 capella kernel: RAX: 0000000000000000 RBX: 0000000000000001 RCX: 000000000000000b
Aug 15 10:42:44 capella kernel: RDX: 000000000000000b RSI: 0000000000000001 RDI: ffff880213b8cd00
Aug 15 10:42:44 capella kernel: RBP: ffff880213b8cd00 R08: 00000000ffffffff R09: 0000000000000001
Aug 15 10:42:44 capella kernel: R10: 0000000000000006 R11: ffff8800d9ec002f R12: 0000000000015380
Aug 15 10:42:44 capella kernel: R13: ffff880213b8d1a8 R14: 0000000000000001 R15: 0000000000000000
Aug 15 10:42:44 capella kernel: FS:  00007f2ffcdb08c0(0000) GS:ffff88021fc80000(0000) knlGS:0000000000000000
Aug 15 10:42:44 capella kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 15 10:42:44 capella kernel: CR2: 0000000000000028 CR3: 00000000d9cf7000 CR4: 00000000000006e0
Aug 15 10:42:44 capella kernel: Stack:
Aug 15 10:42:44 capella kernel:  ffffffff8108408d ffff88021fc95380 ffffffff815359aa ffff880213ad6b98
Aug 15 10:42:44 capella kernel:  0000000000000246 ffff8802161c8c00 ffff880213b94000 ffff880213b93928
Aug 15 10:42:44 capella kernel:  ffff880213b93550 ffff8802161c8c00 0000000000000001 00001c7de0f8c000
Aug 15 10:42:44 capella kernel: Call Trace:
Aug 15 10:42:44 capella kernel:  [<ffffffff8108408d>] ? wq_worker_sleeping+0xd/0x90
Aug 15 10:42:44 capella kernel:  [<ffffffff815359aa>] ? __schedule+0x50a/0x8b0
Aug 15 10:42:44 capella kernel:  [<ffffffff81535d7f>] ? schedule+0x2f/0x70
Aug 15 10:42:44 capella kernel:  [<ffffffff8106f298>] ? do_exit+0x7f8/0xaf0
Aug 15 10:42:44 capella kernel:  [<ffffffff81016f55>] ? oops_end+0x95/0xc0
Aug 15 10:42:44 capella kernel:  [<ffffffff810143b0>] ? do_error_trap+0x70/0xd0
Aug 15 10:42:44 capella kernel:  [<ffffffffa020e4b3>] ? insert_inline_extent_backref+0xe3/0xf0 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffffa0242c5e>] ? btrfs_get_token_64+0xee/0x110 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffff8153b09e>] ? invalid_op+0x1e/0x30
Aug 15 10:42:44 capella kernel:  [<ffffffffa020e4b3>] ? insert_inline_extent_backref+0xe3/0xf0 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffffa020e42f>] ? insert_inline_extent_backref+0x5f/0xf0 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffffa020f9c0>] ? __btrfs_free_extent.isra.68+0x320/0xd50 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffffa020e927>] ? __btrfs_inc_extent_ref.isra.52+0xa7/0x280 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffffa0273fb2>] ? find_ref_head+0x52/0x70 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffffa0213ce1>] ? __btrfs_run_delayed_refs+0xc41/0x1070 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffff8101c6a5>] ? sched_clock+0x5/0x10
Aug 15 10:42:44 capella kernel:  [<ffffffff811b9292>] ? __sb_start_write+0x42/0xe0
Aug 15 10:42:44 capella kernel:  [<ffffffffa0216c81>] ? btrfs_run_delayed_refs.part.73+0x71/0x270 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffff8109aef0>] ? update_curr+0xb0/0xf0
Aug 15 10:42:44 capella kernel:  [<ffffffffa0216f18>] ? delayed_ref_async_start+0x78/0x90 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffffa0259bb0>] ? btrfs_scrubparity_helper+0xc0/0x280 [btrfs]
Aug 15 10:42:44 capella kernel:  [<ffffffff81083401>] ? process_one_work+0x1a1/0x430
Aug 15 10:42:44 capella kernel:  [<ffffffff810836d7>] ? worker_thread+0x47/0x4a0
Aug 15 10:42:44 capella kernel:  [<ffffffff81083690>] ? process_one_work+0x430/0x430
Aug 15 10:42:44 capella kernel:  [<ffffffff810890f1>] ? kthread+0xc1/0xe0
Aug 15 10:42:44 capella kernel:  [<ffffffff81089030>] ? kthread_worker_fn+0x170/0x170
Aug 15 10:42:44 capella kernel:  [<ffffffff81539b9f>] ? ret_from_fork+0x3f/0x70
Aug 15 10:42:44 capella kernel:  [<ffffffff81089030>] ? kthread_worker_fn+0x170/0x170
Aug 15 10:42:44 capella kernel: Code: 50 04 00 00 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 50 04 00 00 <48> 8b 40 d8 c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 
Aug 15 10:42:44 capella kernel: RIP  [<ffffffff8108951c>] kthread_data+0xc/0x20
Aug 15 10:42:44 capella kernel:  RSP <ffff880213b93880>
Aug 15 10:42:44 capella kernel: CR2: ffffffffffffffd8
Aug 15 10:42:44 capella kernel: ---[ end trace 1cdbb5a82e302413 ]---
Aug 15 10:42:44 capella kernel: Fixing recursive fault but reboot is needed!
-- Reboot --

A second traceback appears identical to the first,as far as btrfs is concerned:

Aug 15 21:28:29 capella kernel: ------------[ cut here ]------------
Aug 15 21:28:29 capella kernel: kernel BUG at fs/btrfs/extent-tree.c:1833!
Aug 15 21:28:29 capella kernel: invalid opcode: 0000 [#1] SMP 
Aug 15 21:28:29 capella kernel: Modules linked in: rpcsec_gss_krb5 nfsv4 dns_resolver nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc qt1010 af9013 dvb_usb_af9015 dvb_usb_v2 dvb_core rc_core sp5100_tco evdev snd_hda_codec_hdmi kvm_amd kvm pcspkr amd64_edac_mod edac_mce_amd edac_core nvidia(PO) i2c_piix4 snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_pcm sg snd_timer tpm_infineon snd tpm_tis soundcore drm tpm acpi_cpufreq shpchp processor button thermal_sys md_mod k10temp jc42 i2c_core loop parport_pc ppdev lp parport autofs4 ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor raid6_pq dm_mod hid_generic usbhid hid sd_mod usb_storage ohci_pci tg3 ohci_hcd ehci_pci ehci_hcd ptp usbcore usb_common pps_core libphy ahci libahci libata scsi_mod
Aug 15 21:28:29 capella kernel: CPU: 0 PID: 98 Comm: kworker/u8:7 Tainted: P           O    4.2.0-rc5-derek-00033-g6c84461-dirty #5
Aug 15 21:28:29 capella kernel: Hardware name: HP ProLiant MicroServer, BIOS O41     10/01/2013
Aug 15 21:28:29 capella kernel: Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
Aug 15 21:28:29 capella kernel: task: ffff8800df858180 ti: ffff8800df854000 task.ti: ffff8800df854000
Aug 15 21:28:29 capella kernel: RIP: 0010:[<ffffffffa02ae4b3>]  [<ffffffffa02ae4b3>] insert_inline_extent_backref+0xe3/0xf0 [btrfs]
Aug 15 21:28:29 capella kernel: RSP: 0018:ffff8800df857af8  EFLAGS: 00010293
Aug 15 21:28:29 capella kernel: RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
Aug 15 21:28:29 capella kernel: RDX: ffff880000000000 RSI: 0000000000000001 RDI: 0000000000000000
Aug 15 21:28:29 capella kernel: RBP: ffff88021399f800 R08: 0000000000004000 R09: ffff8800df857a08
Aug 15 21:28:29 capella kernel: R10: 0000000000000000 R11: 0000000000000003 R12: ffff8800a1723e30
Aug 15 21:28:29 capella kernel: R13: 0000000000004a83 R14: 0000000000000000 R15: 00001f0347bf8000
Aug 15 21:28:29 capella kernel: FS:  00007fd01e1af880(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
Aug 15 21:28:29 capella kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 15 21:28:29 capella kernel: CR2: 00007fd01bd11150 CR3: 000000000180c000 CR4: 00000000000006f0
Aug 15 21:28:29 capella kernel: Stack:
Aug 15 21:28:29 capella kernel:  00001f0347bf8000 0000000000004a83 0000000000000000 0000000000000000
Aug 15 21:28:29 capella kernel:  ffff880000000001 0000000000000286 ffff8800a1723e30 0000000000000000
Aug 15 21:28:29 capella kernel:  ffff8800a1723e30 00000000000036eb 000000000004f4c5 ffff880213818000
Aug 15 21:28:29 capella kernel: Call Trace:
Aug 15 21:28:29 capella kernel:  [<ffffffffa02ae927>] ? __btrfs_inc_extent_ref.isra.52+0xa7/0x280 [btrfs]
Aug 15 21:28:29 capella kernel:  [<ffffffffa02b3ce1>] ? __btrfs_run_delayed_refs+0xc41/0x1070 [btrfs]
Aug 15 21:28:29 capella kernel:  [<ffffffff8101c6a5>] ? sched_clock+0x5/0x10
Aug 15 21:28:29 capella kernel:  [<ffffffff811b9292>] ? __sb_start_write+0x42/0xe0
Aug 15 21:28:29 capella kernel:  [<ffffffffa02b6c81>] ? btrfs_run_delayed_refs.part.73+0x71/0x270 [btrfs]
Aug 15 21:28:29 capella kernel:  [<ffffffff8109aef0>] ? update_curr+0xb0/0xf0
Aug 15 21:28:29 capella kernel:  [<ffffffffa02b6f18>] ? delayed_ref_async_start+0x78/0x90 [btrfs]
Aug 15 21:28:29 capella kernel:  [<ffffffffa02f9bb0>] ? btrfs_scrubparity_helper+0xc0/0x280 [btrfs]
Aug 15 21:28:29 capella kernel:  [<ffffffff81083401>] ? process_one_work+0x1a1/0x430
Aug 15 21:28:29 capella kernel:  [<ffffffff810836d7>] ? worker_thread+0x47/0x4a0
Aug 15 21:28:29 capella kernel:  [<ffffffff81083690>] ? process_one_work+0x430/0x430
Aug 15 21:28:29 capella kernel:  [<ffffffff810890f1>] ? kthread+0xc1/0xe0
Aug 15 21:28:29 capella kernel:  [<ffffffff81089030>] ? kthread_worker_fn+0x170/0x170
Aug 15 21:28:29 capella kernel:  [<ffffffff81539b9f>] ? ret_from_fork+0x3f/0x70
Aug 15 21:28:29 capella kernel:  [<ffffffff81089030>] ? kthread_worker_fn+0x170/0x170
Aug 15 21:28:29 capella kernel: Code: 89 d9 4c 89 34 24 4d 89 e8 4c 89 f9 4c 89 e6 48 89 ef 48 89 44 24 10 8b 84 24 a8 00 00 00 89 44 24 08 e8 f1 d6 ff ff 31 c0 eb b3 <0f> 0b 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 56 41 
Aug 15 21:28:29 capella kernel: RIP  [<ffffffffa02ae4b3>] insert_inline_extent_backref+0xe3/0xf0 [btrfs]
Aug 15 21:28:29 capella kernel:  RSP <ffff8800df857af8>
Aug 15 21:28:29 capella kernel: ---[ end trace 60d558aa37b96dd3 ]---
Aug 15 21:28:29 capella kernel: BUG: unable to handle kernel paging request at ffffffffffffffd8
Aug 15 21:28:29 capella kernel: IP: [<ffffffff8108951c>] kthread_data+0xc/0x20
-- Reboot --

Unfortunately, I don't have a dump.

I notice that a similar traceback as posted on July 31 relating to 4.2-RC3, but there's no indication what was in progress at the time.

--
Derek
