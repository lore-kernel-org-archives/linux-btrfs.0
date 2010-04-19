From: "Justin" <yoosty69@netzero.com>
Subject: btrfs balance failed and kernel oops'd
Date: Mon, 19 Apr 2010 19:18:30 GMT
Message-ID: <20100419.121830.21154.1@webmail20.vgs.untd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Backstory:
I had a FakeRAID setup with two SATA drives. The storage controller seems to be messed up 
on my motherboard so I popped in a PCI SATA controller and connected the two SATA drives 
to the controller.

Problem:
I already had two identical (thanks to the FakeRAID) btrfs partitions on two different 
drives. I wanted to see what would happen if I tried to use this setup without 
re-formatting so I mounted the first drive (sda3) to /mnt/mountpoint and did a 
"btrfs-vol -a /dev/sdb3 /mnt/mountpoint" and then a "btrfs-vol -b 
/mnt/mountpoint". The balance attempted to start (I could hear the drives start 
reading and/or writing, and the HDD light was blinking)  but then oops'd out a few 
seconds later. The error message on the console was:

zsh: killed     btrfs-vol -b /mnt/mountpoint

The following was in /var/log/messages:

[  236.514077] device label root devid 1 transid 2418 /dev/sda3
[  350.020671] device label root devid 1 transid 2418 /dev/sdb3
[  350.021059] device label root devid 1 transid 2422 /dev/sda3
[  369.489239] device label root devid 1 transid 2422 /dev/sda3
[  371.638660] device label root devid 1 transid 2418 /dev/sdb3
[  503.385888] device label root devid 1 transid 2422 /dev/sda3
[  559.492112] btrfs: relocating block group 35462840320 flags 1
[  559.655752] btrfs: relocating block group 34389098496 flags 1
[  559.780560] btrfs: relocating block group 33315356672 flags 1
[  559.905373] btrfs: relocating block group 32241614848 flags 1
[  560.005233] btrfs: relocating block group 31167873024 flags 1
[  560.096763] btrfs: relocating block group 30094131200 flags 1
[  560.196620] btrfs: relocating block group 29020389376 flags 1
[  560.296469] btrfs: relocating block group 27946647552 flags 1
[  560.396331] btrfs: relocating block group 26872905728 flags 1
[  560.496188] btrfs: relocating block group 25799163904 flags 1
[  560.587713] btrfs: relocating block group 24725422080 flags 1
[  560.679257] btrfs: relocating block group 23651680256 flags 1
[  560.737461] BUG: unable to handle kernel NULL pointer dereference at 000000000000003d
[  560.737465] IP: [<ffffffff810b9993>] page_cache_sync_readahead+0x10/0x37
[  560.737472] PGD 13ae50067 PUD 13b76b067 PMD 0 
[  560.737475] Oops: 0000 [#1] SMP 
[  560.737477] last sysfs file: 
/sys/devices/pci0000:00/0000:00:1e.0/0000:11:00.0/host2/target2:0:0/2:0:0:0/block/sda/sda3
/uevent
[  560.737480] CPU 0 
[  560.737481] Modules linked in: video shpchp hid_apple output x38_edac iTCO_wdt 
i2c_i801 pci_hotplug psmouse edac_core evdev pcspkr i2c_core iTCO_vendor_support 
serio_raw container button processor raid10 raid456 async_raid6_recov async_pq raid6_pq 
async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod sg sd_mod sr_mod 
crc_t10dif cdrom usbhid hid ata_generic uhci_hcd ehci_hcd ata_piix sata_promise thermal 
libata scsi_mod thermal_sys usbcore e1000e
[  560.737509] Pid: 2219, comm: btrfs-vol Not tainted 2.6.32.11-std152-amd64 #1 C2SBX
[  560.737511] RIP: 0010:[<ffffffff810b9993>]  [<ffffffff810b9993>] 
page_cache_sync_readahead+0x10/0x37
[  560.737515] RSP: 0000:ffff88013a667b58  EFLAGS: 00010206
[  560.737517] RAX: 0000000000000000 RBX: ffff88013b0fa240 RCX: 0000000000000000
[  560.737519] RDX: 0000000000000000 RSI: ffff88013b5ef200 RDI: ffff88013b0fa358
[  560.737520] RBP: ffff88013ac0b800 R08: 000000000000002d R09: 0000000000000000
[  560.737522] R10: ffff88013b0fa080 R11: 00000000fffffff4 R12: 0000000000000000
[  560.737524] R13: ffff88013b0fa0b0 R14: 0000000000000000 R15: 0000000000000000
[  560.737527] FS:  0000000000000000(0000) GS:ffff880005400000(0063) 
knlGS:00000000f7637700
[  560.737529] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  560.737531] CR2: 000000000000003d CR3: 000000013b768000 CR4: 00000000000006f0
[  560.737533] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  560.737535] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  560.737537] Process btrfs-vol (pid: 2219, threadinfo ffff88013a666000, task 
ffff88013a7a9c00)
[  560.737539] Stack:
[  560.737540]  0000000000000000 ffffffff812dbafc 0000000000000000 0000000581c00000
[  560.737543] <0> 000000000000002d 0000000000000000 000000000000002c 
ffff88013b5ef200
[  560.737545] <0> ffff88013ac0b800 ffff88013b0fa0b0 ffff88013b0fa2f8 
0000000581c00001
[  560.737549] Call Trace:
[  560.737554]  [<ffffffff812dbafc>] ? relocate_file_extent_cluster+0x165/0x361
[  560.737556]  [<ffffffff812dbd22>] ? relocate_data_extent+0x2a/0xb0
[  560.737559]  [<ffffffff812dcfa8>] ? relocate_block_group+0x280/0x350
[  560.737562]  [<ffffffff812aba87>] ? btrfs_clean_old_snapshots+0x84/0x122
[  560.737565]  [<ffffffff812dd1b0>] ? btrfs_relocate_block_group+0x138/0x2b5
[  560.737567]  [<ffffffff812c8376>] ? btrfs_relocate_chunk+0x5b/0x45f
[  560.737570]  [<ffffffff812c2bb7>] ? map_extent_buffer+0x60/0x97
[  560.737574]  [<ffffffff812b9799>] ? btrfs_item_offset+0xb7/0xc4
[  560.737576]  [<ffffffff812c8ccd>] ? btrfs_balance+0x1ca/0x223
[  560.737579]  [<ffffffff812ceed2>] ? btrfs_ioctl+0x77e/0x8d0
[  560.737582]  [<ffffffff810c9e55>] ? handle_mm_fault+0x335/0x76a
[  560.737585]  [<ffffffff810cdb1d>] ? __vma_link+0x42/0x4b
[  560.737587]  [<ffffffff810cdba6>] ? vma_link+0x80/0xa7
[  560.737591]  [<ffffffff8111fe98>] ? compat_sys_ioctl+0x1e1/0x48d
[  560.737594]  [<ffffffff810328fa>] ? do_page_fault+0x27e/0x29a
[  560.737598]  [<ffffffff8133dc12>] ? __up_read+0x13/0x85
[  560.737601]  [<ffffffff81037472>] ? ia32_sysret+0x0/0x5
[  560.737602] Code: 48 48 85 c0 74 0c 48 83 c4 20 31 f6 5b 5d 41 5c ff e0 48 83 c4 20 5b 
5d 41 5c c3 48 83 ec 08 83 7e 10 00 48 89 d0 48 89 ca 74 25 <f6> 40 3d 10 74 0d 41 
5b 4c 89 c1 48 89 c6 e9 cd fc ff ff 41 5a 
[  560.737623] RIP  [<ffffffff810b9993>] page_cache_sync_readahead+0x10/0x37
[  560.737626]  RSP <ffff88013a667b58>
[  560.737628] CR2: 000000000000003d
[  560.737630] ---[ end trace 6b42547c30d92a39 ]---


I ran "btrfs-vol -b /mnt/mountpoint" again and now it's sitting just sitting 
there not returning anything and there is no drive or CPU activity.

"btrfs-show" tells me:

Label: root  uuid: 330de3dd-7169-44d9-b978-024c02bfd7b1
	Total devices 2 FS bytes used 14.22GB
	devid    1 size 70.61GB used 27.04GB path /dev/sda3
	devid    2 size 70.61GB used 1.00GB path /dev/sdb3

Btrfs Btrfs v0.19


I'm running SysRescueCD-1.5.2-b6 with the 2.6.33.02 kernel.

Anything I should run? Any other info that might be helpful?


   Justin



____________________________________________________________
A Reverse Mortgage?
Near 70? Find out how much money you can get from a reverse mortgage.
http://thirdpartyoffers.netzero.net/TGL3231/4bccacdd7d172d50a3st01vuc
