Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:33389 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664AbcEEKhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 May 2016 06:37:01 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram =?iso-8859-1?Q?and_disk_are_ok._it_still_mounts,_but_I_cannot_repair?=
Date: Thu, 05 May 2016 12:36:52 +0200
MIME-Version: 1.0
Message-ID: <c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
In-Reply-To: <CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
 <CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On giovedì 5 maggio 2016 03:07:37 CEST, Chris Murphy wrote:
> I suggest using defaults for starters. The only thing in that list
> that needs be there is either subvolid or subvold, not both. Add in
> the non-default options once you've proven the defaults are working,
> and add them one at a time.

Yes I read your previous suggestion and I already dropped subvolid, but 
since the problem already happened I left it in the mail for completeness.
Anyway the culprit here is genfstab and that's probably what a beginner is 
going to use when installing a distro: 
https://wiki.archlinux.org/index.php/beginners'_guide#fstab

>> Disk is a SAMSUNG SSD PM851 M.2 2280 256GB (Firmware Version: EXT25D0Q).
>
> The firmware is old if I understand the naming scheme used by Dell. It
> says EXT49D0Q is current.
>
> http://www.dell.com/support/home/al/en/aldhs1/Drivers/DriversDetails?driverId=0NXHH

According to this 
(http://forum.notebookreview.com/threads/2015-xps-13-ssd-fw-problem-with-m-2-samsung-pm851.770501/) 
the firmware you linked is for the mSATA version of the drive, not the M.2 
one. EXT25D0Q seems to be the very latest one for my drive.

> I advice using all defaults for everything for
> now, otherwise it's anyone's guess what you're running into.

On giovedì 5 maggio 2016 06:12:28 CEST, Qu Wenruo wrote:
> Would it be OK for you to test your btrfs on a plain ssd, 
> without encryption?
> And just as Chris Murphy said, reducing mount option is also a 
> pretty good debugging start point.

Ok, I will remove dmcrypt, discard, compress=lzo, nodefrag and see what 
happens.

>> I made a copy of /dev/mapper/cryptroot with dd on an external drive and
>> I run btrfs check on it (btrfs-progs 4.5.2):
>> https://drive.google.com/open?id=0Bwe9Wtc-5xF1SjJacXpMMU5mems (37MB)
>
> Checked, but seems the output is truncated?

No, I didn't truncate the btrfs check output because it wasn't endless. I 
just truncated the repair output.

I also have something new to report. Do you remember when I said that my 
screen was black and so I had to forcedly power off the system? Something 
similar happened today and since in the meantime I enabled magic sysrq keys 
I have been able to recover this from the logs:

mag 05 11:55:51 arch-laptop kdeinit5[960]: Registering 
"org.kde.StatusNotifierItem-1060-1/StatusNotifierItem" to system tray
mag 05 11:55:51 arch-laptop obexd[1098]: OBEX daemon 5.39
mag 05 11:55:51 arch-laptop dbus-daemon[920]: Successfully activated 
service 'org.bluez.obex'
mag 05 11:55:51 arch-laptop systemd[898]: Started Bluetooth OBEX service.
mag 05 11:55:51 arch-laptop korgac[1044]: log_kidentitymanagement: 
IdentityManager: There was no default identity. Marking first one as 
default.
mag 05 11:55:51 arch-laptop kernel: BUG: unable to handle kernel paging 
request at 0000000000017d11
mag 05 11:55:51 arch-laptop kernel: IP: [<ffffffff81194f9f>] 
anon_vma_interval_tree_insert+0x3f/0x90
mag 05 11:55:51 arch-laptop kernel: PGD 0 
mag 05 11:55:51 arch-laptop kernel: Oops: 0000 [#1] PREEMPT SMP 
mag 05 11:55:51 arch-laptop kernel: Modules linked in: rfcomm(+) visor bnep 
uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core 
videodev media btusb btrtl btbcm btintel cdc_ether bluetooth usbnet r8152 
crc16 mii joydev mousedev nvr
mag 05 11:55:51 arch-laptop kernel:  mei_me syscopyarea sysfillrect snd 
sysimgblt fb_sys_fops i2c_algo_bit shpchp soundcore mei wmi thermal fan 
intel_hid sparse_keymap int3403_thermal video processor_thermal_device 
dw_dmac snd_soc_sst_acpi snd_soc_sst_m
mag 05 11:55:51 arch-laptop kernel:  lrw gf128mul glue_helper ablk_helper 
cryptd ahci libahci libata scsi_mod xhci_pci rtsx_pci
mag 05 11:55:51 arch-laptop kernel: Bluetooth: RFCOMM TTY layer initialized
mag 05 11:55:51 arch-laptop kernel: Bluetooth: RFCOMM socket layer 
initialized
mag 05 11:55:51 arch-laptop kernel: Bluetooth: RFCOMM ver 1.11
mag 05 11:55:51 arch-laptop kernel:  xhci_hcd
mag 05 11:55:51 arch-laptop kernel:  i8042 serio sdhci_acpi sdhci led_class 
mmc_core pl2303 mos7720 usbserial parport hid_generic usbhid hid usbcore 
usb_common
mag 05 11:55:51 arch-laptop kernel: CPU: 0 PID: 351 Comm: systemd-udevd Not 
tainted 4.5.1-1-ARCH #1
mag 05 11:55:51 arch-laptop kernel: Hardware name: Dell Inc. XPS 13 
9343/0F5KF3, BIOS A07 11/11/2015
mag 05 11:55:51 arch-laptop kernel: task: ffff88021347d580 ti: 
ffff880211f8c000 task.ti: ffff880211f8c000
mag 05 11:55:51 arch-laptop kernel: RIP: 0010:[<ffffffff81194f9f>]  
[<ffffffff81194f9f>] anon_vma_interval_tree_insert+0x3f/0x90
mag 05 11:55:51 arch-laptop kernel: RSP: 0018:ffff880211f8fd68  EFLAGS: 
00010206
mag 05 11:55:51 arch-laptop kernel: RAX: ffff8800da2f4820 RBX: 
ffff8800bb59ce40 RCX: ffff8800da2f4830
mag 05 11:55:51 arch-laptop kernel: RDX: ffff8800da2f4828 RSI: 
ffff8800374404a0 RDI: ffff8800c58dfa40
mag 05 11:55:51 arch-laptop kernel: RBP: ffff880211f8fdb8 R08: 
0000000000017c79 R09: 00000007f55e2059
mag 05 11:55:51 arch-laptop kernel: R10: 00000007f55e2053 R11: 
ffff8800c58dfa40 R12: ffff880037440460
mag 05 11:55:51 arch-laptop kernel: R13: ffff8800d9e27100 R14: 
ffff8800c58dfa40 R15: ffff880037440460
mag 05 11:55:51 arch-laptop kernel: FS:  00007f55e20537c0(0000) 
GS:ffff88021e400000(0000) knlGS:0000000000000000
mag 05 11:55:51 arch-laptop kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
mag 05 11:55:51 arch-laptop kernel: CR2: 0000000000017d11 CR3: 
0000000211cd5000 CR4: 00000000003406f0
mag 05 11:55:51 arch-laptop kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
mag 05 11:55:51 arch-laptop kernel: DR3: 0000000000000000 DR6: 
00000000fffe0ff0 DR7: 0000000000000400
mag 05 11:55:51 arch-laptop kernel: Stack:
mag 05 11:55:51 arch-laptop kernel:  ffffffff811a90c8 0000000000000246 
ffff880212d00900 ffff8800bb59ceb8
mag 05 11:55:51 arch-laptop kernel:  ffff880212d00978 ffff8800bb59ce40 
ffff880212d00900 0000000000000007
mag 05 11:55:51 arch-laptop kernel:  00007f55e2053a90 ffff8800d991e1c0 
ffff880211f8fdf0 ffffffff811a9232
mag 05 11:55:51 arch-laptop kernel: Call Trace:
mag 05 11:55:51 arch-laptop kernel:  [<ffffffff811a90c8>] ? 
anon_vma_clone+0xc8/0x200
mag 05 11:55:51 arch-laptop kernel:  [<ffffffff811a9232>] 
anon_vma_fork+0x32/0x140
mag 05 11:55:51 arch-laptop kernel:  [<ffffffff8107742d>] 
copy_process.part.8+0xcdd/0x1890
mag 05 11:55:51 arch-laptop kernel:  [<ffffffff8107819f>] 
_do_fork+0xcf/0x3c0
mag 05 11:55:51 arch-laptop kernel:  [<ffffffff81078539>] 
SyS_clone+0x19/0x20
mag 05 11:55:51 arch-laptop kernel:  [<ffffffff815ad6ae>] 
entry_SYSCALL_64_fastpath+0x12/0x6d
mag 05 11:55:51 arch-laptop kernel: Code: 01 4c 8b 91 98 00 00 00 31 c9 48 
c1 e8 0c 4d 8d 4c 02 ff eb 24 4c 3b 48 18 76 04 4c 89 48 18 4c 8b 40 e0 48 
8d 48 10 48 8d 50 08 <4d> 3b 90 98 00 00 00 48 0f 42 d1 48 89 c1 48 8b 02 
48 85 c0 75 
mag 05 11:55:51 arch-laptop kernel: RIP  [<ffffffff81194f9f>] 
anon_vma_interval_tree_insert+0x3f/0x90
mag 05 11:55:52 arch-laptop kernel:  RSP <ffff880211f8fd68>
mag 05 11:55:52 arch-laptop kernel: CR2: 0000000000017d11
mag 05 11:55:52 arch-laptop kernel: ---[ end trace 6a392d6afbffe7f5 ]---
[...]
mag 05 11:55:52 arch-laptop dbus[584]: [system] Activating via systemd: 
service name='org.freedesktop.ColorManager' unit='colord.service'
mag 05 11:55:52 arch-laptop kernel: BTRFS critical (device dm-0): unable to 
find logical 2330894282579755008 len 4096
mag 05 11:55:52 arch-laptop kernel: ------------[ cut here ]------------
mag 05 11:55:52 arch-laptop kernel: kernel BUG at fs/btrfs/inode.c:1828!
mag 05 11:55:52 arch-laptop kernel: invalid opcode: 0000 [#2] PREEMPT SMP 
mag 05 11:55:52 arch-laptop kernel: Modules linked in: rfcomm visor bnep 
uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core 
videodev media btusb btrtl btbcm btintel cdc_ether bluetooth usbnet r8152 
crc16 mii joydev mousedev nvram 
mag 05 11:55:52 arch-laptop kernel:  mei_me syscopyarea sysfillrect snd 
sysimgblt fb_sys_fops i2c_algo_bit shpchp soundcore mei wmi thermal fan 
intel_hid sparse_keymap int3403_thermal video processor_thermal_device 
dw_dmac snd_soc_sst_acpi snd_soc_sst_m
mag 05 11:55:52 arch-laptop kernel:  lrw gf128mul glue_helper ablk_helper 
cryptd ahci libahci libata scsi_mod xhci_pci rtsx_pci xhci_hcd i8042 serio 
sdhci_acpi sdhci led_class mmc_core pl2303 mos7720 usbserial parport 
hid_generic usbhid hid usbcore usb_
mag 05 11:55:52 arch-laptop kernel: CPU: 3 PID: 1028 Comm: plasmashell 
Tainted: G      D         4.5.1-1-ARCH #1
mag 05 11:55:52 arch-laptop kernel: Hardware name: Dell Inc. XPS 13 
9343/0F5KF3, BIOS A07 11/11/2015
mag 05 11:55:52 arch-laptop kernel: task: ffff8800d9e2aac0 ti: 
ffff8801f5900000 task.ti: ffff8801f5900000
mag 05 11:55:52 arch-laptop kernel: RIP: 0010:[<ffffffffa02ddabb>]  
[<ffffffffa02ddabb>] btrfs_merge_bio_hook+0x8b/0xa0 [btrfs]
mag 05 11:55:52 arch-laptop kernel: RSP: 0018:ffff8801f5903938  EFLAGS: 
00010282
mag 05 11:55:52 arch-laptop kernel: RAX: 00000000ffffffea RBX: 
0000000000001000 RCX: 0000000000000051
mag 05 11:55:52 arch-laptop kernel: RDX: 0000000000000000 RSI: 
ffff88021e58db38 RDI: 0000000000000000
mag 05 11:55:52 arch-laptop kernel: RBP: ffff8801f5903958 R08: 
0000000000070aad R09: 0000000000000368
mag 05 11:55:52 arch-laptop kernel: R10: 00102c80000d13e8 R11: 
0000000000000368 R12: 0000000000001000
mag 05 11:55:52 arch-laptop kernel: R13: ffff8801e205ee28 R14: 
0000000000000000 R15: ffffea000788d580
mag 05 11:55:52 arch-laptop kernel: FS:  00007fe8e688a800(0000) 
GS:ffff88021e580000(0000) knlGS:0000000000000000
mag 05 11:55:52 arch-laptop kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
mag 05 11:55:52 arch-laptop kernel: CR2: 00007fe8d14b5cbc CR3: 
00000000bf57f000 CR4: 00000000003406e0
mag 05 11:55:52 arch-laptop kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
mag 05 11:55:52 arch-laptop kernel: DR3: 0000000000000000 DR6: 
00000000fffe0ff0 DR7: 0000000000000400
mag 05 11:55:52 arch-laptop kernel: Stack:
mag 05 11:55:52 arch-laptop kernel:  0000000000001000 0000000095d6c394 
0000000000001000 ffff8801f5903bc0
mag 05 11:55:52 arch-laptop kernel:  ffff8801f59039b0 ffffffffa02fbd03 
0000000000000000 00102c80000d13e8
mag 05 11:55:52 arch-laptop kernel:  0000002000000000 ffff8800da874040 
0000000000000000 ffffea000788d580
mag 05 11:55:52 arch-laptop kernel: Call Trace:
mag 05 11:55:52 arch-laptop kernel:  [<ffffffffa02fbd03>] 
submit_extent_page+0xc3/0x230 [btrfs]
mag 05 11:55:52 arch-laptop kernel:  [<ffffffffa02fd02a>] 
__do_readpage+0x3aa/0x990 [btrfs]
mag 05 11:55:52 arch-laptop kernel:  [<ffffffffa02fb450>] ? 
btrfs_create_repair_bio+0x100/0x100 [btrfs]
mag 05 11:55:52 arch-laptop kernel:  [<ffffffffa02d0cf0>] ? 
free_root_pointers+0x70/0x70 [btrfs]
mag 05 11:55:52 arch-laptop kernel:  [<ffffffffa02fd6f6>] 
__extent_read_full_page+0xe6/0x100 [btrfs]
mag 05 11:55:52 arch-laptop kernel:  [<ffffffffa02d0cf0>] ? 
free_root_pointers+0x70/0x70 [btrfs]
mag 05 11:55:52 arch-laptop kernel:  [<ffffffffa02ff489>] 
read_extent_buffer_pages+0x179/0x330 [btrfs]
mag 05 11:55:52 arch-laptop kernel:  [<ffffffffa02d0cf0>] ? 
free_root_pointers+0x70/0x70 [btrfs]
mag 05 11:55:52 arch-laptop kernel:  [<ffffffffa02d26fc>] 
btree_read_extent_buffer_pages.constprop.19+0xac/0x110 [btrfs]
mag 05 11:55:52 arch-laptop kernel:  [<ffffffffa02d2cfd>] 
read_tree_block+0x3d/0x70 [btrfs]
mag 05 11:55:52 arch-laptop kernel:  [<ffffffffa02b1b49>] 
read_block_for_search.isra.14+0x139/0x330 [btrfs]
mag 05 11:55:52 arch-laptop kernel:  [<ffffffffa02b72e5>] 
btrfs_next_old_leaf+0x245/0x420 [btrfs]
mag 05 11:55:52 arch-laptop kernel:  [<ffffffffa02b74d0>] 
btrfs_next_leaf+0x10/0x20 [btrfs]
mag 05 11:55:52 arch-laptop kernel:  [<ffffffffa02dc564>] 
btrfs_real_readdir+0x144/0x5f0 [btrfs]
mag 05 11:55:52 arch-laptop kernel:  [<ffffffff81200492>] 
iterate_dir+0x92/0x120
mag 05 11:55:52 arch-laptop kernel:  [<ffffffff81200939>] 
SyS_getdents+0x99/0x110
mag 05 11:55:52 arch-laptop kernel:  [<ffffffff812005f0>] ? 
fillonedir+0xd0/0xd0
mag 05 11:55:52 arch-laptop kernel:  [<ffffffff815ad6ae>] 
entry_SYSCALL_64_fastpath+0x12/0x6d
mag 05 11:55:52 arch-laptop kernel: Code: 8b 80 38 fe ff ff 4c 89 65 e0 48 
8b 80 f0 01 00 00 48 89 c7 e8 77 ac 02 00 85 c0 78 0e 31 c0 4c 01 e3 48 3b 
5d e0 0f 97 c0 eb 9a <0f> 0b e8 5e b1 d9 e0 0f 1f 40 00 66 2e 0f 1f 84 00 
00 00 00 00 
mag 05 11:55:52 arch-laptop kernel: RIP  [<ffffffffa02ddabb>] 
btrfs_merge_bio_hook+0x8b/0xa0 [btrfs]
mag 05 11:55:52 arch-laptop kernel:  RSP <ffff8801f5903938>
mag 05 11:55:52 arch-laptop kernel: ---[ end trace 6a392d6afbffe7f6 ]---

On giovedì 5 maggio 2016 03:07:37 CEST, Chris Murphy wrote:
> Off topic, but at least gmail users see your posts go to spam
>        dmarc=fail (p=QUARANTINE dis=NONE) header.from=linuxsystems.it

Thanks for reporting, I changed my dmarc DNS entry from quarantine to none. 
I previously used reject and I hoped that quarantine was enough of a middle 
ground to survive spam filters, but it seems I will have to get rid of 
dmarc altogether.

Thanks,
Niccolò
