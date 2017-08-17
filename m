Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:44954 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753147AbdHQUmC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 16:42:02 -0400
Received: from 68.79-160-168.customer.lyse.net ([79.160.168.68]:39700 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1diRc8-0004nU-AA
        for linux-btrfs@vger.kernel.org; Thu, 17 Aug 2017 22:42:00 +0200
Reply-To: waxhead@dirtcellar.net
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: waxhead <waxhead@dirtcellar.net>
Subject: 8 disk metadata radi10 + data raid1
Message-ID: <07f6dc04-7163-fe49-63ae-460b401f369c@dirtcellar.net>
Date: Thu, 17 Aug 2017 22:41:59 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On one of my machines I run a BTRFS filesystem with the following 
configuration

Kernel: 4.11.0-1-amd64 #1 SMP Debian 4.11.6-1 (2017-06-19) x86_64 GNU/Linux
Disks: 8
Metadata: Raid 10
Data: Raid1

One of the disks is going bad , and while the system still runs fine I 
ran some md5sum's on a few files and hit this bug.

Currently the only non-zero output from btrfs de st / is about 270000 
write_io_errs and 278000 read_io_errs

I do have backups (hah! you did not expect that Duncan did you!)
and the data is not important on this filesystem.
Even if I got thrown the below stuff in dmesg the system keeps running 
fine.

...the failed device disappeared as of writing this... so now the 
filesystem have one missing device.

---snip--- ( https://pastebin.ca/3856147 )
[120678.569637]  ? worker_thread+0x4d/0x490
[120678.570931]  ? kthread+0xfc/0x130
[120678.572206]  ? process_one_work+0x430/0x430
[120678.573480]  ? kthread_create_on_node+0x70/0x70
[120678.574756]  ? do_group_exit+0x3a/0xa0
[120678.576024]  ? ret_from_fork+0x26/0x40
[120678.577287] Code: 00 00 c7 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb 
d8 8d 48 02 eb da 41 89 e8 48 c7 c6 d8 67 4a c0 4c 89 e7 e8 c0 b9 fa ff 
eb 80 <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 41 57
[120678.580003] RIP: btrfs_check_repairable+0xe2/0xf0 [btrfs] RSP: 
ffffac3a419ffd60
[120678.581377] ------------[ cut here ]------------
[120678.581526] ---[ end trace 1f2b98046a799b47 ]---
[120678.584109] kernel BUG at 
/build/linux-C5oXKu/linux-4.11.6/fs/btrfs/extent_io.c:2315!
[120678.585477] invalid opcode: 0000 [#5] SMP
[120678.586821] Modules linked in: ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter cpufreq_userspace 
cpufreq_powersave cpufreq_conservative intel_powerclamp iTCO_wdt 
iTCO_vendor_support coretemp kvm_intel cdc_ether usbnet mii kvm joydev 
mgag200 ttm irqbypass intel_cstate evdev intel_uncore drm_kms_helper drm 
pcspkr i2c_algo_bit lpc_ich mfd_core ioatdma sg ipmi_si ipmi_devintf dca 
ipmi_msghandler i7core_edac button edac_core i5500_temp shpchp 
acpi_cpufreq binfmt_misc ip_tables x_tables autofs4 btrfs crc32c_generic 
xor raid6_pq sd_mod hid_generic usbhid hid sr_mod cdrom ata_generic 
crc32c_intel ata_piix i2c_i801 libata mptsas ehci_pci scsi_transport_sas 
uhci_hcd mptscsih mptbase ehci_hcd scsi_mod usbcore usb_common bnx2
[120678.595485] CPU: 0 PID: 15305 Comm: kworker/u32:3 Tainted: G      D 
  I     4.11.0-1-amd64 #1 Debian 4.11.6-1
[120678.596960] Hardware name: IBM Lenovo ThinkServer RD220 
-[379811G]-/59Y3827     , BIOS -[D6EL28AUS-1.03]- 08/20/2009
[120678.598476] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[120678.599943] task: ffff9a4dc7bd6d40 task.stack: ffffac3a44214000
[120678.601431] RIP: 0010:btrfs_check_repairable+0xe2/0xf0 [btrfs]
[120678.602867] RSP: 0000:ffffac3a44217d60 EFLAGS: 00010297
[120678.604271] RAX: 0000000000000001 RBX: ffff9a4daa28e080 RCX: 
0000000000000000
[120678.605660] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 
ffff9a4de67d6e18
[120678.607017] RBP: 0000000000000001 R08: 00000dbbb2240000 R09: 
00000dbbf2240000
[120678.608344] R10: 0000000000000000 R11: 00000000fffffffb R12: 
ffff9a4de67d6000
[120678.609641] R13: ffff9a4cfea6dda8 R14: ffff9a4cfea6dda8 R15: 
0000000000000000
[120678.610921] FS:  0000000000000000(0000) GS:ffff9a4def200000(0000) 
knlGS:0000000000000000
[120678.612190] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[120678.613435] CR2: 00005627a2d96ff0 CR3: 000000039310f000 CR4: 
00000000000006f0
[120678.614687] Call Trace:
[120678.615965]  ? end_bio_extent_readpage+0x42e/0x580 [btrfs]
[120678.617244]  ? btrfs_scrubparity_helper+0xcf/0x300 [btrfs]
[120678.618488]  ? process_one_work+0x197/0x430
[120678.619728]  ? worker_thread+0x4d/0x490
[120678.620960]  ? kthread+0xfc/0x130
[120678.622185]  ? process_one_work+0x430/0x430
[120678.623408]  ? kthread_create_on_node+0x70/0x70
[120678.624620]  ? do_group_exit+0x3a/0xa0
[120678.625817]  ? ret_from_fork+0x26/0x40
[120678.626994] Code: 00 00 c7 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb 
d8 8d 48 02 eb da 41 89 e8 48 c7 c6 d8 67 4a c0 4c 89 e7 e8 c0 b9 fa ff 
eb 80 <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 41 57
[120678.629525] RIP: btrfs_check_repairable+0xe2/0xf0 [btrfs] RSP: 
ffffac3a44217d60
[120678.630795] ------------[ cut here ]------------
[120678.630839] ---[ end trace 1f2b98046a799b48 ]---
[120678.633382] kernel BUG at 
/build/linux-C5oXKu/linux-4.11.6/fs/btrfs/extent_io.c:2315!
[120678.634625] invalid opcode: 0000 [#6] SMP
[120678.635820] Modules linked in: ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter cpufreq_userspace 
cpufreq_powersave cpufreq_conservative intel_powerclamp iTCO_wdt 
iTCO_vendor_support coretemp kvm_intel cdc_ether usbnet mii kvm joydev 
mgag200 ttm irqbypass intel_cstate evdev intel_uncore drm_kms_helper drm 
pcspkr i2c_algo_bit lpc_ich mfd_core ioatdma sg ipmi_si ipmi_devintf dca 
ipmi_msghandler i7core_edac button edac_core i5500_temp shpchp 
acpi_cpufreq binfmt_misc ip_tables x_tables autofs4 btrfs crc32c_generic 
xor raid6_pq sd_mod hid_generic usbhid hid sr_mod cdrom ata_generic 
crc32c_intel ata_piix i2c_i801 libata mptsas ehci_pci scsi_transport_sas 
uhci_hcd mptscsih mptbase ehci_hcd scsi_mod usbcore usb_common bnx2
[120678.643664] CPU: 1 PID: 15318 Comm: kworker/u32:5 Tainted: G      D 
  I     4.11.0-1-amd64 #1 Debian 4.11.6-1
[120678.645017] Hardware name: IBM Lenovo ThinkServer RD220 
-[379811G]-/59Y3827     , BIOS -[D6EL28AUS-1.03]- 08/20/2009
[120678.646437] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[120678.647808] task: ffff9a4dcf809240 task.stack: ffffac3a43e14000
[120678.649192] RIP: 0010:btrfs_check_repairable+0xe2/0xf0 [btrfs]
[120678.650530] RSP: 0000:ffffac3a43e17d60 EFLAGS: 00010297
[120678.651838] RAX: 0000000000000001 RBX: ffff9a4daa28ec80 RCX: 
0000000000000000
[120678.653134] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 
ffff9a4de67d6e18
[120678.654403] RBP: 0000000000000001 R08: 00000dbbb2240000 R09: 
00000dbbf2240000
[120678.655644] R10: 0000000000000000 R11: 00000000fffffffb R12: 
ffff9a4de67d6000
[120678.656853] R13: ffff9a4de4aa7728 R14: ffff9a4de4aa7728 R15: 
0000000000000000
[120678.658043] FS:  0000000000000000(0000) GS:ffff9a4def240000(0000) 
knlGS:0000000000000000
[120678.659227] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[120678.660386] CR2: 00007f335364dd3c CR3: 000000039310f000 CR4: 
00000000000006e0
[120678.661559] Call Trace:
[120678.662752]  ? end_bio_extent_readpage+0x42e/0x580 [btrfs]
[120678.663944]  ? btrfs_scrubparity_helper+0xcf/0x300 [btrfs]
[120678.665105]  ? process_one_work+0x197/0x430
[120678.666260]  ? worker_thread+0x4d/0x490
[120678.667410]  ? kthread+0xfc/0x130
[120678.668557]  ? process_one_work+0x430/0x430
[120678.669698]  ? kthread_create_on_node+0x70/0x70
[120678.670825]  ? do_group_exit+0x3a/0xa0
[120678.671939]  ? ret_from_fork+0x26/0x40
[120678.673037] Code: 00 00 c7 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb 
d8 8d 48 02 eb da 41 89 e8 48 c7 c6 d8 67 4a c0 4c 89 e7 e8 c0 b9 fa ff 
eb 80 <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 41 57
[120678.675384] RIP: btrfs_check_repairable+0xe2/0xf0 [btrfs] RSP: 
ffffac3a43e17d60
[120678.676613] ---[ end trace 1f2b98046a799b49 ]---
[120702.863359] btrfs_dev_stat_print_on_error: 252 callbacks suppressed
[120702.863367] BTRFS error (device sda1): bdev /dev/sda1 errs: wr 
270268, rd 278596, flush 0, corrupt 0, gen 0
[120702.863491] BTRFS error (device sda1): bdev /dev/sda1 errs: wr 
270269, rd 278596, flush 0, corrupt 0, gen 0
[120702.863604] BTRFS error (device sda1): bdev /dev/sda1 errs: wr 
270270, rd 278596, flush 0, corrupt 0, gen 0
[120702.863716] BTRFS error (device sda1): bdev /dev/sda1 errs: wr 
270271, rd 278596, flush 0, corrupt 0, gen 0
[120702.863839] BTRFS error (device sda1): bdev /dev/sda1 errs: wr 
270272, rd 278596, flush 0, corrupt 0, gen 0
[120703.353885] BTRFS warning (device sda1): lost page write due to IO 
error on /dev/sda1
[120703.353893] BTRFS error (device sda1): bdev /dev/sda1 errs: wr 
270273, rd 278596, flush 0, corrupt 0, gen 0
[120703.353900] BTRFS warning (device sda1): lost page write due to IO 
error on /dev/sda1
[120703.353903] BTRFS error (device sda1): bdev /dev/sda1 errs: wr 
270274, rd 278596, flush 0, corrupt 0, gen 0
[120703.353909] BTRFS warning (device sda1): lost page write due to IO 
error on /dev/sda1
[120703.353911] BTRFS error (device sda1): bdev /dev/sda1 errs: wr 
270275, rd 278596, flush 0, corrupt 0, gen 0
---snap---

