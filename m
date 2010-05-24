From: Mike Burrell <mburrel@uwo.ca>
Subject: 2.6.34 btrfs kernel bug on Itanium 2
Date: Mon, 24 May 2010 13:23:37 -0400
Message-ID: <F00CCAE6-10AB-405F-ABB7-4B2C1E76013D@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; format=flowed; delsp=yes
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello all!

I tried to get btrfs working on my IA-64 workstation but failed. I did  
a "mkfs.btrfs /dev/sda9", which succeeded, but it failed to mount  
properly. What follows is the relevant bits from dmesg. Let me know if  
you need any information or if I'm doing something stupid.

Cheers,
Mike

[   22.893131] Btrfs loaded
[   22.903905] device fsid d141c33664966af5-39076ba3c1e404ba devid 1  
transid 7 /dev/sda9
[   22.904667] ------------[ cut here ]------------
[   22.904760] WARNING: at fs/btrfs/extent_io.c:3624  
write_extent_buffer+0x340/0x380 [btrfs]()
[   22.904811] Hardware name: workstation zx6000
[   22.904848] Modules linked in: btrfs zlib_deflate crc32c libcrc32c  
loop tpm_tis tpm tpm_bios evdev ext3 jbd mbcache sd_mod usbhid hid  
ide_cd_mod cdrom ata_generic libata ehci_hcd mptspi mptscsih mptbase  
scsi_transport_spi ohci_hcd cmd64x ide_pci_generic tg3 usbcore libphy  
scsi_mod nls_base e100 mii ide_core [last unloaded: scsi_wait_scan]
[   22.905641]
[   22.905643] Call Trace:
[   22.905713]  [<a0000001000143f0>] show_stack+0x50/0xa0
[   22.905716]                                 sp=e00000408192fb70  
bsp=e0000040819291b0
[   22.905810]  [<a000000100667190>] dump_stack+0x30/0x50
[   22.905813]                                 sp=e00000408192fd40  
bsp=e000004081929198
[   22.905911]  [<a000000100083180>] warn_slowpath_common+0xc0/0x120
[   22.905914]                                 sp=e00000408192fd40  
bsp=e000004081929160
[   22.906004]  [<a000000100083210>] warn_slowpath_null+0x30/0x60
[   22.906007]                                 sp=e00000408192fd40  
bsp=e000004081929138
[   22.906121]  [<a000000201efee60>] write_extent_buffer+0x340/0x380  
[btrfs]
[   22.906125]                                 sp=e00000408192fd40  
bsp=e0000040819290c8
[   22.906242]  [<a000000201f11150>] btrfs_read_sys_array+0xb0/0x5c0  
[btrfs]
[   22.906245]                                 sp=e00000408192fd40  
bsp=e000004081929050
[   22.906357]  [<a000000201eb58d0>] open_ctree+0x13d0/0x2520 [btrfs]
[   22.906360]                                 sp=e00000408192fd60  
bsp=e000004081928f48
[   22.906467]  [<a000000201e61170>] btrfs_get_sb+0x570/0xfa0 [btrfs]
[   22.906470]                                 sp=e00000408192fd80  
bsp=e000004081928ec8
[   22.906564]  [<a0000001001bd320>] vfs_kern_mount+0x160/0x380
[   22.906567]                                 sp=e00000408192fde0  
bsp=e000004081928e78
[   22.906656]  [<a0000001001bd600>] do_kern_mount+0x60/0x240
[   22.906659]                                 sp=e00000408192fde0  
bsp=e000004081928e38
[   22.906753]  [<a0000001001f5580>] do_mount+0x1300/0x1420
[   22.906755]                                 sp=e00000408192fde0  
bsp=e000004081928db8
[   22.906844]  [<a0000001001f5790>] sys_mount+0xf0/0x1a0
[   22.906846]                                 sp=e00000408192fe10  
bsp=e000004081928d28
[   22.906963]  [<a00000010000b600>] ia64_ret_from_syscall+0x0/0x20
[   22.906966]                                 sp=e00000408192fe30  
bsp=e000004081928d28
[   22.907063]  [<a000000000010720>] ia64_ivt+0xffffffff00010720/0x400
[   22.907066]                                 sp=e000004081930000  
bsp=e000004081928d28
[   22.907149] ---[ end trace 89cfbe06194b63e4 ]---
*snip*
[   24.141159] kernel BUG at fs/btrfs/extent-tree.c:4766!
[   24.141209] sm-notify[1856]: bugcheck! 0 [1]
[   24.141244] Modules linked in: btrfs zlib_deflate crc32c libcrc32c  
loop tpm_tis tpm tpm_bios evdev ext3 jbd mbcache sd_mod usbhid hid  
ide_cd_mod cdrom ata_generic libata ehci_hcd mptspi mptscsih mptbase  
scsi_transport_spi ohci_hcd cmd64x ide_pci_generic tg3 usbcore libphy  
scsi_mod nls_base e100 mii ide_core [last unloaded: scsi_wait_scan]
[   24.142006]
[   24.142008] Pid: 1856, CPU 0, comm:            sm-notify
[   24.142075] psr : 00001010085a6010 ifs : 8000000000000797 ip  :  
[<a000000201e95d30>]    Tainted: G        W  (2.6.34)
[   24.142174] ip is at run_one_delayed_ref+0x210/0xdc0 [btrfs]
[   24.142212] unat: 0000000000000000 pfs : 0000000000000797 rsc :  
0000000000000003
[   24.142261] rnat: 0000000000000000 bsps: 0000000000000000 pr  :  
0000005692695955
[   24.142311] ldrs: 0000000000000000 ccv : 00000000035201a9 fpsr:  
0009804c8a70033f
[   24.142360] csd : 0000000000000000 ssd : 0000000000000000
[   24.142397] b0  : a000000201e95d30 b6  : a000000100359660 b7  :  
a000000100359660
[   24.142446] f6  : 1003e00000000000000a0 f7  : 1003e00000000000000a0
[   24.142485] f8  : 1003e0000000000000001 f9  : 1003e000000000000c121
[   24.142523] f10 : 1003e0000000002cf766e f11 : 1003e0044b82fa09b5a53
[   24.142561] r1  : a000000100bbe5d0 r2  : 0000000000000ef4 r3  :  
000000000000fffe
[   24.142611] r8  : 000000000000003d r9  : 0000000000000fff r10 :  
ffffffffffff9508
[   24.142660] r11 : 0000000000000000 r12 : e000004082117d90 r13 :  
e000004082110000
[   24.142709] r14 : 0000000000000ef4 r15 : 0000000000004000 r16 :  
a0000001009826ec
[   24.142758] r17 : a0000001009d52e0 r18 : a0000001009dd750 r19 :  
0000000000000000
[   24.142808] r20 : a0000001009dd750 r21 : 0000000000ffffff r22 :  
a000000100359420
[   24.142858] r23 : a0000001007ccde8 r24 : a000000100359660 r25 :  
a000000100a8a3d8
[   24.142908] r26 : e000004082117d10 r27 : a0000001009d6262 r28 :  
0000000000000354
[   24.142957] r29 : 0000000000000354 r30 : 000000000000fffe r31 :  
a0000001007ccde8
[   24.143011]
[   24.143012] Call Trace:
[   24.143082]  [<a0000001000143f0>] show_stack+0x50/0xa0
[   24.143085]                                 sp=e000004082117960  
bsp=e0000040821112d0
[   24.143184]  [<a000000100014c60>] show_regs+0x820/0x860
[   24.143187]                                 sp=e000004082117b30  
bsp=e000004082111278
[   24.143279]  [<a0000001000395e0>] die+0x1a0/0x300
[   24.143281]                                 sp=e000004082117b30  
bsp=e000004082111238
[   24.143370]  [<a000000100039790>] die_if_kernel+0x50/0x80
[   24.143373]                                 sp=e000004082117b30  
bsp=e000004082111208
[   24.143465]  [<a00000010003ae20>] ia64_bad_break+0x220/0x440
[   24.143467]                                 sp=e000004082117b30  
bsp=e0000040821111d8
[   24.143560]  [<a00000010000b780>] ia64_native_leave_kernel+0x0/0x270
[   24.143562]                                 sp=e000004082117bc0  
bsp=e0000040821111d8
[   24.143672]  [<a000000201e95d30>] run_one_delayed_ref+0x210/0xdc0  
[btrfs]
[   24.143675]                                 sp=e000004082117d90  
bsp=e000004082111120
[   24.143785]  [<a000000201e9d400>] run_clustered_refs+0x680/0x8a0  
[btrfs]
[   24.143788]                                 sp=e000004082117dc0  
bsp=e000004082111050
[   24.143898]  [<a000000201e9d7a0>] btrfs_run_delayed_refs 
+0x180/0x4e0 [btrfs]
[   24.143901]                                 sp=e000004082117de0  
bsp=e000004082110fb0
[   24.144014]  [<a000000201eb9270>] commit_cowonly_roots+0x130/0x480  
[btrfs]
[   24.144017]                                 sp=e000004082117df0  
bsp=e000004082110f40
[   24.144129]  [<a000000201ebae20>] btrfs_commit_transaction 
+0x920/0x1120 [btrfs]
[   24.144132]                                 sp=e000004082117e00  
bsp=e000004082110eb0
[   24.144250]  [<a000000201e61e50>] btrfs_sync_fs+0xf0/0x120 [btrfs]
[   24.144252]                                 sp=e000004082117e30  
bsp=e000004082110e88
[   24.144349]  [<a0000001002511c0>] vfs_quota_sync+0x600/0x780
[   24.144351]                                 sp=e000004082117e30  
bsp=e000004082110dd8
[   24.144446]  [<a000000100208820>] __sync_filesystem+0xc0/0x1e0
[   24.144449]                                 sp=e000004082117e30  
bsp=e000004082110db0
[   24.144539]  [<a000000100208b30>] sync_filesystems+0x1f0/0x300
[   24.144542]                                 sp=e000004082117e30  
bsp=e000004082110d68
[   24.144871]  [<a000000100208d00>] sys_sync+0x40/0xa0
[   24.144871]                                 sp=e000004082117e30  
bsp=e000004082110d10
[   24.144871]  [<a00000010000b600>] ia64_ret_from_syscall+0x0/0x20
[   24.144871]                                 sp=e000004082117e30  
bsp=e000004082110d10
[   24.144871]  [<a000000000010720>] ia64_ivt+0xffffffff00010720/0x400
[   24.144871]                                 sp=e000004082118000  
bsp=e000004082110d10
[   24.144871] Disabling lock debugging due to kernel taint

