Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32.italiaonline.it ([212.48.25.160]:34218 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756352AbcECUnT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 May 2016 16:43:19 -0400
From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: RAID56 device replace/rebalance error: bad page state
Reply-To: kreijack@inwind.it
References: <20160502183305.GK21960@jeknote.loshitsa1.net>
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <57290B77.5010801@inwind.it>
Date: Tue, 3 May 2016 22:35:03 +0200
MIME-Version: 1.0
In-Reply-To: <20160502183305.GK21960@jeknote.loshitsa1.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-02 20:33, Yauhen Kharuzhy wrote:
> Hi.
> 
> While testing of various scenarios of RAID5 recovery I got kernel
> messages about bad page state with soft lockup afterwards.

Looking at your script, I found a little bug:

[...]
for i in `seq $n -1 $((n-2))`; do
	d=`basename ${DISKS[$((i-1))]}`

	echo "Remove $d"

	removed_dev_htl=`ls -l /sys/class/block/${d} | rev | cut -d "/" -f 3 | rev`
	_devmgt_remove ${removed_dev_htl} ${failed_disk}
                                          ^^^^^^^^^^^^^^
	dev_removed=1
[...]

If I understood correctly uor code, $failed_disk should be ${DISKS[$((i-1))]}

BR
G.Baroncelli


> 
> Tested kernel is vanilla 4.6-rc4 (also reproduced on 4.4.5) without any
> modifications. Platform is VirtualBox (2 virtual CPU), 64-bit Debian wheezy.
> 
> Script to reproduce this is attached. Run: "./test-replace-balance.sh <mount point> <drive1 drive2...>"
> 
> Sequence is:
> 1) Create RAID5, mount, write some data.
> 2) Remove drive.
> 3) Unmount file system and remount again in degraded mode (to detect of missing drive).
> 4) Replace missing device by another.
> 5) Start balance.
> 
> Kernel log:
> 
> [  884.607734] BTRFS: device fsid 6913f45e-d1b1-467c-80ad-440d64679790 devid 1 transid 3 /dev/sdc
> [  884.739823] BTRFS: device fsid 6913f45e-d1b1-467c-80ad-440d64679790 devid 2 transid 3 /dev/sdd
> [  884.927401] BTRFS: device fsid 6913f45e-d1b1-467c-80ad-440d64679790 devid 3 transid 3 /dev/sde
> [  884.960044] BTRFS: device fsid 6913f45e-d1b1-467c-80ad-440d64679790 devid 4 transid 3 /dev/sdf
> [  886.545691] BTRFS info (device sdf): disk space caching is enabled
> [  886.559215] BTRFS: has skinny extents
> [  886.570670] BTRFS: flagging fs with big metadata feature
> [  886.653966] BTRFS: creating UUID tree
> [  891.337060] sd 7:0:0:0: [sdf] Synchronizing SCSI cache
> [  891.348417] sd 7:0:0:0: [sdf] Stopping disk
> [  891.371520] ata8.00: disabled
> [  891.776862] BTRFS error (device sdf): bdev /dev/sdf errs: wr 0, rd 0, flush 1, corrupt 0, gen 0
> [  891.783309] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
> [  891.792851] BTRFS error (device sdf): bdev /dev/sdf errs: wr 1, rd 0, flush 1, corrupt 0, gen 0
> [  891.804431] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
> [  891.813735] BTRFS error (device sdf): bdev /dev/sdf errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
> [  894.680113] ata8: hard resetting link
> [  895.067539] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  895.072264] ata8.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
> [  895.078234] ata8.00: 16777216 sectors, multi 128: LBA48 NCQ (depth 31/32)
> [  895.096798] ata8.00: configured for UDMA/133
> [  895.100938] ata8: EH complete
> [  895.130822] scsi 7:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0 ANSI: 5
> [  895.181345] sd 7:0:0:0: [sdg] 16777216 512-byte logical blocks: (8.59 GB/8.00 GiB)
> [  895.183696] sd 7:0:0:0: Attached scsi generic sg6 type 0
> [  895.214179] sd 7:0:0:0: [sdg] Write Protect is off
> [  895.231026] sd 7:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [  895.288528] sd 7:0:0:0: [sdg] Attached SCSI disk
> [  897.596941] BTRFS error (device sdf): bdev /dev/sdf errs: wr 2, rd 0, flush 2, corrupt 0, gen 0
> [  897.604003] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
> [  897.611944] BTRFS error (device sdf): bdev /dev/sdf errs: wr 3, rd 0, flush 2, corrupt 0, gen 0
> [  897.627306] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
> [  897.634766] BTRFS error (device sdf): bdev /dev/sdf errs: wr 4, rd 0, flush 2, corrupt 0, gen 0
> [  897.834694] BTRFS info (device sde): allowing degraded mounts
> [  897.840566] BTRFS info (device sde): disk space caching is enabled
> [  897.852766] BTRFS: has skinny extents
> [  897.923986] BTRFS info (device sde): bdev /dev/sdf errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
> [  898.121025] BTRFS info (device sde): dev_replace from <missing disk> (devid 4) to /dev/sdg started
> [  904.029908] BTRFS info (device sde): dev_replace from <missing disk> (devid 4) to /dev/sdg finished
> [  904.863387] BTRFS info (device sde): relocating block group 6543114240 flags 132
> [  905.081558] BTRFS info (device sde): relocating block group 6476005376 flags 130
> [  905.743629] BTRFS info (device sde): relocating block group 3254779904 flags 129
> [  905.760509] BUG: Bad page state in process ksoftirqd/0  pfn:2b80b
> [  905.774543] page:ffffea0000ae02c0 count:0 mapcount:0 mapping:ffff88002b4a0f30 index:0x182000
> [  905.803071] flags: 0x1ffff800000012c(referenced|uptodate|lru|owner_priv_1)
> [  905.814529] page dumped because: page still charged to cgroup
> [  905.823817] page->mem_cgroup:ffff88002ce52c00
> [  905.830953] bad because of flags: 0x20(lru)
> [  905.836428] Modules linked in: cpufreq_userspace cpufreq_powersave cpufreq_stats cpufreq_conservative softdog nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc loop ipmi_devintf ipmi_msghandler joydev iTCO_wdt snd_pcm iTCO_vendor_support snd_timer snd psmouse lpc_ich soundcore mfd_core serio_raw ohci_pci evdev pcspkr ohci_hcd rng_core i2c_piix4 battery parport_pc 8250_fintek parport acpi_cpufreq video ac tpm_tis tpm button processor ext4 crc16 jbd2 mbcache crc32c_generic btrfs(O) xor raid6_pq dm_mod md_mod hid_generic usbhid hid xhci_pci xhci_hcd sg sr_mod cdrom sd_mod ata_generic ehci_pci ehci_hcd ahci usbcore ata_piix libahci libata usb_common scsi_mod e1000
> [  905.959393] CPU: 0 PID: 3 Comm: ksoftirqd/0 Tainted: G           O    4.6.0-rc4-scst31x-debug-12+ #2
> [  905.961129] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [  905.961129]  0000000000000000 ffffffff812e8935 ffffea0000ae02c0 ffffffff817d68f1
> [  905.961129]  ffffffff81167a45 0000000000000020 ffffea0000ae02c0 0000000000000001
> [  905.961129]  ffffffff8116867a ffff88002f339000 ffff88002f10a800 ffffea0000ae02c0
> [  905.961129] Call Trace:
> [  905.961129]  [<ffffffff812e8935>] ? dump_stack+0x5c/0x77
> [  905.961129]  [<ffffffff81167a45>] ? bad_page+0xd5/0x140
> [  905.961129]  [<ffffffff8116867a>] ? free_pages_prepare+0x2aa/0x2e0
> [  905.961129]  [<ffffffff8116a9f2>] ? free_hot_cold_page+0x32/0x180
> [  905.961129]  [<ffffffffa02d2c6e>] ? __free_raid_bio+0x7e/0x110 [btrfs]
> [  905.961129]  [<ffffffffa02d3567>] ? rbio_orig_end_io+0x47/0x80 [btrfs]
> [  905.961129]  [<ffffffff812bc9f5>] ? blk_update_request+0x85/0x310
> [  905.961129]  [<ffffffffa0032530>] ? scsi_end_request+0x30/0x1d0 [scsi_mod]
> [  905.961129]  [<ffffffffa0034a8e>] ? scsi_io_completion+0xae/0x610 [scsi_mod]
> [  905.961129]  [<ffffffff812c3cc8>] ? blk_done_softirq+0x78/0x90
> [  905.961129]  [<ffffffff8157e2b8>] ? __do_softirq+0xf8/0x28e
> [  905.961129]  [<ffffffff8107a135>] ? run_ksoftirqd+0x25/0x40
> [  905.961129]  [<ffffffff81094ed9>] ? smpboot_thread_fn+0xf9/0x150
> [  905.961129]  [<ffffffff81094de0>] ? sort_range+0x20/0x20
> [  905.961129]  [<ffffffff81091fdd>] ? kthread+0xbd/0xe0
> [  905.961129]  [<ffffffff8157ba22>] ? ret_from_fork+0x22/0x40
> [  905.961129]  [<ffffffff81091f20>] ? kthread_create_on_node+0x170/0x170
> [  906.122279] Disabling lock debugging due to kernel taint
> [  906.126973] BUG: Bad page state in process ksoftirqd/0  pfn:2b80c
> [  906.132504] page:ffffea0000ae0300 count:0 mapcount:0 mapping:ffff88002b4a0f30 index:0x182001
> [  906.145815] flags: 0x1ffff800000002c(referenced|uptodate|lru)
> [  906.149863] page dumped because: page still charged to cgroup
> [  906.159109] page->mem_cgroup:ffff88002ce52c00
> [  906.164593] bad because of flags: 0x20(lru)
> [  906.171565] Modules linked in: cpufreq_userspace cpufreq_powersave cpufreq_stats cpufreq_conservative softdog nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc loop ipmi_devintf ipmi_msghandler joydev iTCO_wdt snd_pcm iTCO_vendor_support snd_timer snd psmouse lpc_ich soundcore mfd_core serio_raw ohci_pci evdev pcspkr ohci_hcd rng_core i2c_piix4 battery parport_pc 8250_fintek parport acpi_cpufreq video ac tpm_tis tpm button processor ext4 crc16 jbd2 mbcache crc32c_generic btrfs(O) xor raid6_pq dm_mod md_mod hid_generic usbhid hid xhci_pci xhci_hcd sg sr_mod cdrom sd_mod ata_generic ehci_pci ehci_hcd ahci usbcore ata_piix libahci libata usb_common scsi_mod e1000
> [  906.306655] CPU: 0 PID: 3 Comm: ksoftirqd/0 Tainted: G    B      O    4.6.0-rc4-scst31x-debug-12+ #2
> [  906.309077] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [  906.309077]  0000000000000000 ffffffff812e8935 ffffea0000ae0300 ffffffff817d68f1
> [  906.309077]  ffffffff81167a45 0000000000000020 ffffea0000ae0300 0000000000000001
> [  906.309077]  ffffffff8116867a ffff88002f339000 ffff88002f10a800 ffffea0000ae0300
> [  906.309077] Call Trace:
> [  906.309077]  [<ffffffff812e8935>] ? dump_stack+0x5c/0x77
> [  906.309077]  [<ffffffff81167a45>] ? bad_page+0xd5/0x140
> [  906.309077]  [<ffffffff8116867a>] ? free_pages_prepare+0x2aa/0x2e0
> [  906.309077]  [<ffffffff8116a9f2>] ? free_hot_cold_page+0x32/0x180
> [  906.309077]  [<ffffffffa02d2c6e>] ? __free_raid_bio+0x7e/0x110 [btrfs]
> [  906.309077]  [<ffffffffa02d3567>] ? rbio_orig_end_io+0x47/0x80 [btrfs]
> [  906.309077]  [<ffffffff812bc9f5>] ? blk_update_request+0x85/0x310
> [  906.309077]  [<ffffffffa0032530>] ? scsi_end_request+0x30/0x1d0 [scsi_mod]
> [  906.309077]  [<ffffffffa0034a8e>] ? scsi_io_completion+0xae/0x610 [scsi_mod]
> [  906.309077]  [<ffffffff812c3cc8>] ? blk_done_softirq+0x78/0x90
> [  906.309077]  [<ffffffff8157e2b8>] ? __do_softirq+0xf8/0x28e
> [  906.309077]  [<ffffffff8107a135>] ? run_ksoftirqd+0x25/0x40
> [  906.309077]  [<ffffffff81094ed9>] ? smpboot_thread_fn+0xf9/0x150
> [  906.309077]  [<ffffffff81094de0>] ? sort_range+0x20/0x20
> [  906.309077]  [<ffffffff81091fdd>] ? kthread+0xbd/0xe0
> [  906.309077]  [<ffffffff8157ba22>] ? ret_from_fork+0x22/0x40
> [  906.309077]  [<ffffffff81091f20>] ? kthread_create_on_node+0x170/0x170
> [  906.636549] BUG: Bad page state in process ksoftirqd/0  pfn:2bbb6
> [  906.643307] page:ffffea0000aeed80 count:0 mapcount:0 mapping:ffff88002b4a0f30 index:0x182002
> [  906.657821] flags: 0x1ffff800000002c(referenced|uptodate|lru)
> [  906.662972] page dumped because: page still charged to cgroup
> [  906.672025] page->mem_cgroup:ffff88002ce52c00
> [  906.678670] bad because of flags: 0x20(lru)
> [  906.683654] Modules linked in: cpufreq_userspace cpufreq_powersave cpufreq_stats cpufreq_conservative softdog nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc loop ipmi_devintf ipmi_msghandler joydev iTCO_wdt snd_pcm
>   iTCO_vendor_support snd_timer snd psmouse lpc_ich soundcore mfd_core serio_raw ohci_pci evdev pcspkr ohci_hcd rng_core i2c_piix4 battery parport_pc 8250_fintek parport acpi_cpufreq video ac tpm_tis tpm button processor ext4 crc16 jbd2 mbc
> ache crc32c_generic btrfs(O) xor raid6_pq dm_mod md_mod hid_generic usbhid hid xhci_pci xhci_hcd sg sr_mod cdrom sd_mod ata_generic ehci_pci ehci_hcd ahci usbcore ata_piix libahci libata usb_common scsi_mod e1000
> [  906.832358] CPU: 0 PID: 3 Comm: ksoftirqd/0 Tainted: G    B      O    4.6.0-rc4-scst31x-debug-12+ #2
> [  906.836342] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [  906.836342]  0000000000000000 ffffffff812e8935 ffffea0000aeed80 ffffffff817d68f1
> [  906.836342]  ffffffff81167a45 0000000000000020 ffffea0000aeed80 0000000000000001
> [  906.836342]  ffffffff8116867a ffff88002f339000 ffff88002f10a800 ffffea0000aeed80
> [  906.836342] Call Trace:
> [  906.836342]  [<ffffffff812e8935>] ? dump_stack+0x5c/0x77
> [  906.836342]  [<ffffffff81167a45>] ? bad_page+0xd5/0x140
> [  906.836342]  [<ffffffff8116867a>] ? free_pages_prepare+0x2aa/0x2e0
> [  906.836342]  [<ffffffff8116a9f2>] ? free_hot_cold_page+0x32/0x180
> [  906.836342]  [<ffffffffa02d2c6e>] ? __free_raid_bio+0x7e/0x110 [btrfs]
> [  906.836342]  [<ffffffffa02d3567>] ? rbio_orig_end_io+0x47/0x80 [btrfs]
> [  906.836342]  [<ffffffff812bc9f5>] ? blk_update_request+0x85/0x310
> [  906.836342]  [<ffffffffa0032530>] ? scsi_end_request+0x30/0x1d0 [scsi_mod]
> [  906.836342]  [<ffffffffa0034a8e>] ? scsi_io_completion+0xae/0x610 [scsi_mod]
> [  906.836342]  [<ffffffff812c3cc8>] ? blk_done_softirq+0x78/0x90
> [  906.836342]  [<ffffffff8157e2b8>] ? __do_softirq+0xf8/0x28e
> [  906.836342]  [<ffffffff8107a135>] ? run_ksoftirqd+0x25/0x40
> [  906.836342]  [<ffffffff81094ed9>] ? smpboot_thread_fn+0xf9/0x150
> [  906.836342]  [<ffffffff81094de0>] ? sort_range+0x20/0x20
> [  906.836342]  [<ffffffff81091fdd>] ? kthread+0xbd/0xe0
> [  906.836342]  [<ffffffff8157ba22>] ? ret_from_fork+0x22/0x40
> [  906.836342]  [<ffffffff81091f20>] ? kthread_create_on_node+0x170/0x170
> [  907.037388] BUG: Bad page state in process ksoftirqd/0  pfn:2bbb5
> [  907.046272] page:ffffea0000aeed40 count:0 mapcount:0 mapping:ffff88002b4a0f30 index:0x182003
> [  907.057160] flags: 0x1ffff800000002c(referenced|uptodate|lru)
> [  907.064933] page dumped because: page still charged to cgroup
> [  907.070041] page->mem_cgroup:ffff88002ce52c00
> [  907.078497] bad because of flags: 0x20(lru)
> [  907.082406] Modules linked in: cpufreq_userspace cpufreq_powersave cpufreq_stats cpufreq_conservative softdog nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc loop ipmi_devintf ipmi_msghandler joydev iTCO_wdt snd_pcm iTCO_vendor_support snd_timer snd psmouse lpc_ich soundcore mfd_core serio_raw ohci_pci evdev pcspkr ohci_hcd rng_core i2c_piix4 battery parport_pc 8250_fintek parport acpi_cpufreq video ac tpm_tis tpm button processor ext4 crc16 jbd2 mbcache crc32c_generic btrfs(O) xor raid6_pq dm_mod md_mod hid_generic usbhid hid xhci_pci xhci_hcd sg sr_mod cdrom sd_mod ata_generic ehci_pci ehci_hcd ahci usbcore ata_piix libahci libata usb_common scsi_mod e1000
> [  907.172217] CPU: 0 PID: 3 Comm: ksoftirqd/0 Tainted: G    B      O    4.6.0-rc4-scst31x-debug-12+ #2
> [  907.176199] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [  907.176199]  0000000000000000 ffffffff812e8935 ffffea0000aeed40 ffffffff817d68f1
> [  907.176199]  ffffffff81167a45 0000000000000020 ffffea0000aeed40 0000000000000001
> [  907.176199]  ffffffff8116867a ffff88002f339000 ffff88002f10a800 ffffea0000aeed40
> [  907.176199] Call Trace:
> [  907.176199]  [<ffffffff812e8935>] ? dump_stack+0x5c/0x77
> [  907.176199]  [<ffffffff81167a45>] ? bad_page+0xd5/0x140
> [  907.176199]  [<ffffffff8116867a>] ? free_pages_prepare+0x2aa/0x2e0
> [  907.176199]  [<ffffffff8116a9f2>] ? free_hot_cold_page+0x32/0x180
> [  907.176199]  [<ffffffffa02d2c6e>] ? __free_raid_bio+0x7e/0x110 [btrfs]
> [  907.176199]  [<ffffffffa02d3567>] ? rbio_orig_end_io+0x47/0x80 [btrfs]
> [  907.176199]  [<ffffffff812bc9f5>] ? blk_update_request+0x85/0x310
> [  907.176199]  [<ffffffffa0032530>] ? scsi_end_request+0x30/0x1d0 [scsi_mod]
> [  907.176199]  [<ffffffffa0034a8e>] ? scsi_io_completion+0xae/0x610 [scsi_mod]
> [  907.176199]  [<ffffffff812c3cc8>] ? blk_done_softirq+0x78/0x90
> [  907.176199]  [<ffffffff8157e2b8>] ? __do_softirq+0xf8/0x28e
> [  907.176199]  [<ffffffff8107a135>] ? run_ksoftirqd+0x25/0x40
> [  907.176199]  [<ffffffff81094ed9>] ? smpboot_thread_fn+0xf9/0x150
> [  907.176199]  [<ffffffff81094de0>] ? sort_range+0x20/0x20
> [  907.176199]  [<ffffffff81091fdd>] ? kthread+0xbd/0xe0
> [  907.176199]  [<ffffffff8157ba22>] ? ret_from_fork+0x22/0x40
> [  907.176199]  [<ffffffff81091f20>] ? kthread_create_on_node+0x170/0x170
> [  908.223534] BTRFS info (device sde): found 1 extents
> [  910.631246] BTRFS info (device sde): found 1 extents
> [  910.775915] BTRFS info (device sde): relocating block group 33554432 flags 132
> [  911.028542] BTRFS info (device sde): found 9 extents
> [  911.132418] BTRFS info (device sde): relocating block group 20971520 flags 130
> [  911.372007] BTRFS info (device sde): found 1 extents
> [  911.888562] sd 6:0:0:0: [sde] Synchronizing SCSI cache
> [  911.898486] sd 6:0:0:0: [sde] Stopping disk
> [  911.936759] ata7.00: disabled
> [  912.352163] BTRFS error (device sde): bdev /dev/sde errs: wr 0, rd 0, flush 1, corrupt 0, gen 0
> [  912.362579] BTRFS warning (device sde): lost page write due to IO error on /dev/sde
> [  912.373375] BTRFS error (device sde): bdev /dev/sde errs: wr 1, rd 0, flush 1, corrupt 0, gen 0
> [  912.381443] BTRFS warning (device sde): lost page write due to IO error on /dev/sde
> [  912.388582] BTRFS error (device sde): bdev /dev/sde errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
> [  920.162025] ata7: hard resetting link
> [  920.571717] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  920.575470] ata7.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
> [  920.588670] ata7.00: 41943040 sectors, multi 128: LBA48 NCQ (depth 31/32)
> [  920.594698] ata7.00: configured for UDMA/133
> [  920.597904] ata7: EH complete
> [  920.622277] scsi 6:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0 ANSI: 5
> [  920.698264] sd 6:0:0:0: Attached scsi generic sg5 type 0
> [  920.708298] sd 6:0:0:0: [sdf] 41943040 512-byte logical blocks: (21.5 GB/20.0 GiB)
> [  920.740235] sd 6:0:0:0: [sdf] Write Protect is off
> [  920.764155] sd 6:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [  920.823199] BTRFS error (device sde): bdev /dev/sde errs: wr 2, rd 0, flush 2, corrupt 0, gen 0
> [  920.836207] BTRFS warning (device sde): lost page write due to IO error on /dev/sde
> [  920.868750] BTRFS error (device sde): bdev /dev/sde errs: wr 3, rd 0, flush 2, corrupt 0, gen 0
> [  920.895418] BTRFS warning (device sde): lost page write due to IO error on /dev/sde
> [  920.903712] BTRFS error (device sde): bdev /dev/sde errs: wr 4, rd 0, flush 2, corrupt 0, gen 0
> [  920.916416] sd 6:0:0:0: [sdf] Attached SCSI disk
> [  941.996388] INFO: rcu_sched self-detected stall on CPU[  942.010038] INFO: rcu_sched detected stalls on CPUs/tasks:
> [  942.010044]  1-...: (2833 ticks this GP) idle=59d/140000000000001/0 softirq=11688/11688 fqs=2994
> [  942.010044]  (detected by 0, t=5253 jiffies, g=10112, c=10111, q=267)
> [  942.010047] Task dump for CPU 1:
> [  942.010049] umount          R  running task        0  3460   3243 0x00000008
> [  942.010060]  0000000000182040 ffff880028e2bc78 ffffea0000ae02c0 ffffffffffffff10
> [  942.010063]  ffffffff811657cf 0000000000000010 0000000000000246 ffff880028e2bc78
> [  942.010065]  0000000000000018 ffffffff81165865 0000000000182000 0000000000182040
> [  942.010068] Call Trace:
> [  942.010079]  [<ffffffff811657cf>] ? find_get_entries+0x4f/0x170
> [  942.010121]  [<ffffffff81165865>] ? find_get_entries+0xe5/0x170
> [  942.010125]  [<ffffffff81173dba>] ? pagevec_lookup_entries+0x1a/0x30
> [  942.010127]  [<ffffffff81174069>] ? invalidate_inode_pages2_range+0x99/0x460
> [  942.010242]  [<ffffffffa025d1fc>] ? close_ctree+0x16c/0x360 [btrfs]
> [  942.010246]  [<ffffffff811de8d9>] ? generic_shutdown_super+0x69/0xf0
> [  942.010248]  [<ffffffff811deb9e>] ? kill_anon_super+0xe/0x20
> [  942.010262]  [<ffffffffa0230f23>] ? btrfs_kill_super+0x13/0x100 [btrfs]
> [  942.010264]  [<ffffffff811decf4>] ? deactivate_locked_super+0x34/0x60
> [  942.010266]  [<ffffffff811fae5b>] ? cleanup_mnt+0x3b/0x80
> [  942.010270]  [<ffffffff81090791>] ? task_work_run+0x71/0x90
> [  942.010273]  [<ffffffff8100330a>] ? exit_to_usermode_loop+0xba/0xc0
> [  942.010275]  [<ffffffff81003b25>] ? syscall_return_slowpath+0x45/0x50
> [  942.010278]  [<ffffffff8157b87e>] ? entry_SYSCALL_64_fastpath+0xa6/0xa8
> 
> [  941.996388]
> [  941.996388]  1-...: (2833 ticks this GP) idle=59d/140000000000001/0 softirq=11688/11688 fqs=3043
> [  941.996388]   (t=5309 jiffies g=10112 c=10111 q=270)
> [  941.996388] Task dump for CPU 1:
> [  941.996388] umount          R  running task        0  3460   3243 0x00000008
> [  941.996388]  ffffffff81a4f300 ffffffff810d0a23 ffff88002fd16940 ffffffff81a4f300
> [  941.996388]  0000000000000000 ffff88002b82adc0 ffffffff810d42dd ffff88002fd15bc0
> [  941.996388]  0000000000015bc0 0000000000000001 ffff88002fd03e88 ffff88002fd03e88
> [  941.996388] Call Trace:
> [  941.996388]  <IRQ>  [<ffffffff810d0a23>] ? rcu_dump_cpu_stacks+0x83/0xd0
> [  941.996388]  [<ffffffff810d42dd>] ? rcu_check_callbacks+0x4ad/0x760
> [  941.996388]  [<ffffffff810e87f0>] ? tick_sched_handle.isra.13+0x50/0x50
> [  941.996388]  [<ffffffff810da212>] ? update_process_times+0x32/0x60
> [  941.996388]  [<ffffffff810e87c0>] ? tick_sched_handle.isra.13+0x20/0x50
> [  941.996388]  [<ffffffff810e8828>] ? tick_sched_timer+0x38/0x70
> [  941.996388]  [<ffffffff810daa3a>] ? __hrtimer_run_queues+0xda/0x260
> [  941.996388]  [<ffffffff810db179>] ? hrtimer_interrupt+0x99/0x190
> [  941.996388]  [<ffffffff8157e0c9>] ? smp_apic_timer_interrupt+0x39/0x50
> [  941.996388]  [<ffffffff8157c3e2>] ? apic_timer_interrupt+0x82/0x90
> [  941.996388]  <EOI>  [<ffffffff811657cf>] ? find_get_entries+0x4f/0x170
> [  941.996388]  [<ffffffff81165865>] ? find_get_entries+0xe5/0x170
> [  941.996388]  [<ffffffff81173dba>] ? pagevec_lookup_entries+0x1a/0x30
> [  941.996388]  [<ffffffff81174069>] ? invalidate_inode_pages2_range+0x99/0x460
> [  941.996388]  [<ffffffffa025d1fc>] ? close_ctree+0x16c/0x360 [btrfs]
> [  941.996388]  [<ffffffff811de8d9>] ? generic_shutdown_super+0x69/0xf0
> [  941.996388]  [<ffffffff811deb9e>] ? kill_anon_super+0xe/0x20
> [  941.996388]  [<ffffffffa0230f23>] ? btrfs_kill_super+0x13/0x100 [btrfs]
> [  941.996388]  [<ffffffff811decf4>] ? deactivate_locked_super+0x34/0x60
> [  941.996388]  [<ffffffff811fae5b>] ? cleanup_mnt+0x3b/0x80
> [  941.996388]  [<ffffffff81090791>] ? task_work_run+0x71/0x90
> [  941.996388]  [<ffffffff8100330a>] ? exit_to_usermode_loop+0xba/0xc0
> [  941.996388]  [<ffffffff81003b25>] ? syscall_return_slowpath+0x45/0x50
> [  941.996388]  [<ffffffff8157b87e>] ? entry_SYSCALL_64_fastpath+0xa6/0xa8
> [  968.184777] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [umount:3460]
> [  968.184777] Modules linked in: cpufreq_userspace cpufreq_powersave cpufreq_stats cpufreq_conservative softdog nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc loop ipmi_devintf ipmi_msghandler joydev iTCO_wdt snd_pcm iTCO_vendor_support snd_timer snd psmouse lpc_ich soundcore mfd_core serio_raw ohci_pci evdev pcspkr ohci_hcd rng_core i2c_piix4 battery parport_pc 8250_fintek parport acpi_cpufreq video ac tpm_tis tpm button processor ext4 crc16 jbd2 mbcache crc32c_generic btrfs(O) xor raid6_pq dm_mod md_mod hid_generic usbhid hid xhci_pci xhci_hcd sg sr_mod cdrom sd_mod ata_generic ehci_pci ehci_hcd ahci usbcore ata_piix libahci libata usb_common scsi_mod e1000
> [  968.184777] CPU: 1 PID: 3460 Comm: umount Tainted: G    B      O    4.6.0-rc4-scst31x-debug-12+ #2
> [  968.184777] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [  968.184777] task: ffff88002b82adc0 ti: ffff880028e28000 task.ti: ffff880028e28000
> [  968.184777] RIP: 0010:[<ffffffff811657cf>]  [<ffffffff811657cf>] find_get_entries+0x4f/0x170
> [  968.184777] RSP: 0018:ffff880028e2bc78  EFLAGS: 00000246
> [  968.184777] RAX: ffff88002b452028 RBX: 0000000000000008 RCX: 0000000000000000
> [  968.184777] RDX: 0000000000182040 RSI: ffff880028e2bc78 RDI: ffffea0000ae02c0
> [  968.184777] RBP: ffff88002b4a0f38 R08: 0000000000000000 R09: 0000000000000000
> [  968.184777] R10: 0000000000000000 R11: 0000000000000220 R12: ffff88002b452028
> [  968.184777] R13: 000000000000000e R14: ffff880028e2bd80 R15: ffff880028e2bd00
> [  968.184777] FS:  00007ff3d87537e0(0000) GS:ffff88002fd00000(0000) knlGS:0000000000000000
> [  968.184777] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  968.184777] CR2: 0000000000625208 CR3: 000000002efe6000 CR4: 00000000000006e0
> [  968.184777] Stack:
> [  968.184777]  0000000000182000 0000000000182040 ffffea00009f4960 ffff880028e2bd70
> [  968.184777]  ffffffffffffffff ffff880028e2bd70 ffff880028e2bdf0 ffff88002b4a0f30
> [  968.184777]  ffffea0000a54640 ffffffff81173dba 00000000000021b4 ffffffff81174069
> [  968.184777] Call Trace:
> [  968.184777]  [<ffffffff81173dba>] ? pagevec_lookup_entries+0x1a/0x30
> [  968.184777]  [<ffffffff81174069>] ? invalidate_inode_pages2_range+0x99/0x460
> [  968.184777]  [<ffffffffa025d1fc>] ? close_ctree+0x16c/0x360 [btrfs]
> [  968.184777]  [<ffffffff811de8d9>] ? generic_shutdown_super+0x69/0xf0
> [  968.184777]  [<ffffffff811deb9e>] ? kill_anon_super+0xe/0x20
> [  968.184777]  [<ffffffffa0230f23>] ? btrfs_kill_super+0x13/0x100 [btrfs]
> [  968.184777]  [<ffffffff811decf4>] ? deactivate_locked_super+0x34/0x60
> [  968.184777]  [<ffffffff811fae5b>] ? cleanup_mnt+0x3b/0x80
> [  968.184777]  [<ffffffff81090791>] ? task_work_run+0x71/0x90
> [  968.184777]  [<ffffffff8100330a>] ? exit_to_usermode_loop+0xba/0xc0
> [  968.184777]  [<ffffffff81003b25>] ? syscall_return_slowpath+0x45/0x50
> [  968.184777]  [<ffffffff8157b87e>] ? entry_SYSCALL_64_fastpath+0xa6/0xa8
> [  968.184777] Code: 45 31 e4 48 8d 6f 08 48 83 ec 18 48 c7 04 24 00 00 00 00 48 89 74 24 08 eb 76 40 f6 c7 03 0f 85 d5 00 00 00 44 8b 4f 1c 45 85 c9 <74> 68 41 8d 51 01 48 8d 4f 1c 44 89 c8 f0 0f b1 57 1c 41 39 c1
> 
> 
> 
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
