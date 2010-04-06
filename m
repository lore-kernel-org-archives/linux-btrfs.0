From: "yoosty69@netzero.com" <yoosty69@netzero.com>
Subject: btrfs Bug?
Date: Tue, 6 Apr 2010 17:08:12 GMT
Message-ID: <20100406.100812.1985.1@webmail22.vgs.untd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Background:
Was checking E-mail and browsing the internet when suddenly Pidgin crashed out. I thought that was pretty weird so I went to go re-start Pidgin when I noticed the machine hang really hard for about 30 seconds. The machine finally came back and that's when I noticed that my E-mail client (Claws Mail) had stopped responding. I 'touch'ed a file in my home dir and that was fine, but then I went to md5sum a large file and it came back with an I/O error. I ran dmesg and found that there had been a kernel dump (or whatever the proper term is) related to BTRFS. I went to shut down my programs gracefully and do a reboot, unfortunately none of my programs (FF, Pidgin, Claws-Mail, one or two others) wanted to respond so I just used the power-button.

I switched my Intel X-25M (2nd gen, latest FW as of about a month ago) to a different SATA cable and on a different port on the motherboard (Supermicro C2SBX) to see if there was some sort of hardware problem there. I booted again into Gentoo and the boot failed (I'm guessing it failed after trying to mount the root partition as RO the first time).

I booted in to System Rescue CD 1.5.1 and tried to mount the partition and mount returned with a SegFault and dmesg spit out the following:

[code]

[   75.218065] device label root devid 1 transid 4446 /dev/sda3
[   75.225843] btrfs: sda3 checksum verify failed on 42488987648 wanted FC733AC3 found F7794308 level 1
[   75.226049] btrfs: sda3 checksum verify failed on 42488987648 wanted FC733AC3 found F7794308 level 1
[   75.226238] btrfs: sda3 checksum verify failed on 42488987648 wanted FC733AC3 found F7794308 level 1
[   75.226271] Btrfs detected SSD devices, enabling SSD mode
[   75.226490] ------------[ cut here ]------------
[   75.226492] kernel BUG at fs/btrfs/extent-tree.c:3541!
[   75.226494] invalid opcode: 0000 [#1] SMP
[   75.226497] last sysfs file: /sys/kernel/uevent_seqnum
[   75.226499] CPU 0
[   75.226500] Modules linked in: video nvidiafb output shpchp pci_hotplug hid_apple i2c_i801 processor button container i2c_core pcspkr psmouse serio_raw vgastate evdev iTCO_wdt iTCO_vendor_support x38_edac edac_core raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod sg sd_mod sr_mod crc_t10dif cdrom usbhid hid uhci_hcd ahci libata e1000e ehci_hcd scsi_mod thermal usbcore thermal_sys
[   75.226534] Pid: 1804, comm: mount Not tainted 2.6.32.10-std151-amd64 #1 C2SBX
[   75.226536] RIP: 0010:[<ffffffff81298c44>]  [<ffffffff81298c44>] btrfs_pin_extent+0x28/0xab
[   75.226545] RSP: 0018:ffff88013abeba48  EFLAGS: 00010246
[   75.226547] RAX: 0000000000000000 RBX: 00000009e492c000 RCX: 00000007c1bfffff
[   75.226549] RDX: 0000000000000000 RSI: ffff88013a93e000 RDI: 0000000040000000
[   75.226552] RBP: 0000000000001000 R08: ffff88013abebb68 R09: 0000000000080050
[   75.226554] R10: 000000000000027c R11: 00000000000338c6 R12: ffff88013a414000
[   75.226556] R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff812cb15f
[   75.226564] FS:  0000000000000000(0000) GS:ffff880005400000(0063) knlGS:00000000f75e4b60
[   75.226566] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[   75.226568] CR2: 00000000f76b2890 CR3: 000000013b324000 CR4: 00000000000006f0
[   75.226570] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   75.226572] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   75.226574] Process mount (pid: 1804, threadinfo ffff88013abea000, task ffff88013ab71500)
[   75.226575] Stack:
[   75.226576]  ffff880134781a20 ffff88013abebb68 000000000000115f 0000000000001000
[   75.226579] <0> ffff88013abebb68 ffffffff812cb18b ffff88013abebb14 ffff880134781b40
[   75.226582] <0> ffff88013dd8f800 ffffffff812caa63 fffffffffffffffa 00000009e492c000
[   75.226585] Call Trace:
[   75.226589]  [<ffffffff812cb18b>] ? process_one_buffer+0x2c/0x5e
[   75.226592]  [<ffffffff812caa63>] ? walk_down_log_tree+0x2c3/0x362
[   75.226595]  [<ffffffff812cab7a>] ? walk_log_tree+0x78/0x183
[   75.226598]  [<ffffffff812a723f>] ? join_transaction+0x174/0x1a0
[   75.226601]  [<ffffffff812ce073>] ? btrfs_recover_log_trees+0x92/0x283
[   75.226603]  [<ffffffff812a2b14>] ? btree_get_extent+0x0/0x18b
[   75.226606]  [<ffffffff812cb15f>] ? process_one_buffer+0x0/0x5e
[   75.226609]  [<ffffffff812a2a62>] ? btree_read_extent_buffer_pages+0x65/0xa3
[   75.226612]  [<ffffffff812a6362>] ? open_ctree+0xee5/0x1137
[   75.226615]  [<ffffffff8133a08d>] ? vsnprintf+0x3f4/0x42d
[   75.226619]  [<ffffffff8128fe79>] ? btrfs_get_sb+0x1ad/0x3a2
[   75.226623]  [<ffffffff810ecbb8>] ? vfs_kern_mount+0x96/0x15b
[   75.226626]  [<ffffffff810eccdc>] ? do_kern_mount+0x49/0xe7
[   75.226629]  [<ffffffff8110029c>] ? do_mount+0x73e/0x7a4
[   75.226633]  [<ffffffff8111ce06>] ? compat_sys_mount+0x1f6/0x231
[   75.226636]  [<ffffffff81037472>] ? ia32_sysret+0x0/0x5
[   75.226637] Code: 41 5d c3 41 56 41 55 41 89 cd 41 54 55 48 89 d5 53 4c 8b a7 28 01 00 00 48 89 f3 4c 89 e7 e8 d7 e1 ff ff 48 85 c0 49 89 c6 75 04 <0f> 0b eb fe 48 8b b8 90 00 00 00 48 81 c7 b8 00 00 00 e8 65 de
[   75.226658] RIP  [<ffffffff81298c44>] btrfs_pin_extent+0x28/0xab
[   75.226662]  RSP <ffff88013abeba48>
[   75.226664] ---[ end trace 0ab19e2d653aad66 ]---
root@sysresccd /root %
[/code]

I tried to mount it again to see if I got a different error but then the machine hung and never came back from it's vacation.

After another hard restart I tried mounting the filesystem again and got the same exact kernel dump (AFAICT anyways, I'm sure then memory locations are different but the rest looks the same).

After yet another hard restart (the previous mount attempt didn't want to let me do a reboot) I tried a btrfsck and it spit out basically the same checksum errors:

[code]

checksum verify failed on 42488987648 wanted FC733AC3 found F7794308
checksum verify failed on 42488987648 wanted FC733AC3 found F7794308
checksum verify failed on 42488987648 wanted FC733AC3 found F7794308

[/code]

and then btrfsck segfaulted. I got the following as I attempted the btrfsck from 'tail -f /var/log/messages'

[code]

Apr  5 18:31:10 sysresccd kernel: [  262.847992] btrfsck[1849]: segfault at a8 ip 0000000008054269 sp 00000000ffc862a0 error 4 in btrfsck[8048000+1c000]

[/code]

I'm using gentoo-sources-2.6.33, and System Rescue CD 1.5.1 uses 2.6.32.10.


   Justin


____________________________________________________________
Get Free Email with Video Mail & Video Chat!
http://www.netzero.net/freeemail?refcd=NZTAGOUT1FREM0210
