Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:54636 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab2F0RYf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 13:24:35 -0400
Message-ID: <4FEB41CE.8070205@telenet.be>
Date: Wed, 27 Jun 2012 19:24:30 +0200
From: Frederik Himpe <fhimpe@telenet.be>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 3.5.0-rc4: kernel BUG at fs/btrfs/inode.c:3758!
Content-Type: multipart/mixed;
 boundary="------------090304020309040106020503"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090304020309040106020503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

After an unclean shutdown, Linux 3.5-rc4 fails to mount one of my btrfs 
file systems. This backtrace can be found in the logs:

[    7.765748] ------------[ cut here ]------------
[    7.768309] kernel BUG at fs/btrfs/inode.c:3758!
[    7.770865] invalid opcode: 0000 [#1] SMP
[    7.773432] CPU 1
[    7.776036] Modules linked in: ext4 crc16 jbd2 mbcache vhost_net tun 
macvtap macvlan netconsole configfs loop snd_hda_codec_hdmi 
snd_hda_codec_realtek coretemp kvm_intel kvm snd_usb_audio crc32c_intel 
snd_usbmidi_lib snd_seq_midi ghash_clmulni_intel snd_seq_midi_event 
snd_rawmidi aesni_intel joydev evdev aes_x86_64 aes_generic 
snd_hda_intel uvcvideo cryptd acpi_cpufreq usb_storage snd_hda_codec uas 
videobuf2_vmalloc snd_hwdep snd_pcm videobuf2_memops videobuf2_core 
snd_page_alloc videodev snd_seq snd_seq_device media snd_timer 
hid_generic mperf psmouse video microcode snd radeon ttm drm_kms_helper 
drm i2c_i801 pcspkr i2c_algo_bit button i2c_core serio_raw soundcore 
lpc_ich mei mfd_core processor thermal_sys btrfs crc32c libcrc32c 
zlib_deflate dm_mod usbhid hid sr_mod sd_mod cdrom crc_t10dif xhci_hcd 
r8169 ahci libahci mii ehci_hcd libata scsi_mod usbcore usb_common [last 
unloaded: scsi_wait_scan]
[    7.787771]
[    7.790804] Pid: 1864, comm: mount Not tainted 3.5.0-rc4-custom-1 #2 
To Be Filled By O.E.M. To Be Filled By O.E.M./H77 Pro4/MVP
[    7.793943] RIP: 0010:[<ffffffffa017c720>]  [<ffffffffa017c720>] 
btrfs_evict_inode+0xc0/0x266 [btrfs]
[    7.797105] RSP: 0018:ffff880417ca1a58  EFLAGS: 00010246
[    7.800249] RAX: 0000000000000000 RBX: ffff880417d92000 RCX: 
000000000000001a
[    7.803405] RDX: 000000000000001a RSI: ffffffffffffffff RDI: 
ffff8804151588f0
[    7.806545] RBP: ffff8804151589b0 R08: ffff880417ca1978 R09: 
0000000000000002
[    7.809681] R10: ffff880417ca1880 R11: 0000000000000001 R12: 
ffffffffa01bc230
[    7.812813] R13: 0000000000001000 R14: 0000000000001000 R15: 
ffff88041770a000
[    7.815915] FS:  00007fc41ab767e0(0000) GS:ffff88042f280000(0000) 
knlGS:0000000000000000
[    7.819037] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.822155] CR2: 00007ff2902e8670 CR3: 0000000417cd9000 CR4: 
00000000001407e0
[    7.825274] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[    7.828375] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[    7.831427] Process mount (pid: 1864, threadinfo ffff880417ca0000, 
task ffff880417d1f510)
[    7.834526] Stack:
[    7.837591]  ffff8804153f4fa0 ffff880415158a38 ffff8804151589b0 
ffff8804151589b0
[    7.840733]  ffff880415158ab0 ffffffffa01bc230 ffff8804151589b0 
ffff880417d92400
[    7.843886]  ffff88041770a000 ffffffff811143d0 ffff8804152f0e20 
ffff880417d92000
[    7.847052] Call Trace:
[    7.850167]  [<ffffffff811143d0>] ? evict+0xa3/0x153
[    7.853311]  [<ffffffffa01a29f9>] ? fixup_inode_link_counts+0xd2/0xfb 
[btrfs]
[    7.856474]  [<ffffffffa0170b7d>] ? 
btrfs_read_fs_root_no_radix+0x170/0x1af [btrfs]
[    7.859647]  [<ffffffffa01a3b0b>] ? 
btrfs_recover_log_trees+0x207/0x2dd [btrfs]
[    7.862829]  [<ffffffffa01a253e>] ? replay_one_extent+0x439/0x439 [btrfs]
[    7.866009]  [<ffffffffa0172dd6>] ? open_ctree+0x137d/0x16cb [btrfs]
[    7.869162]  [<ffffffff811b458c>] ? ida_get_new_above+0x16c/0x17d
[    7.872298]  [<ffffffffa0156d83>] ? btrfs_mount+0x383/0x4b3 [btrfs]
[    7.875401]  [<ffffffff810d3f51>] ? pcpu_next_pop+0x36/0x43
[    7.878514]  [<ffffffff810f37bc>] ? __kmalloc_track_caller+0xd8/0xea
[    7.881632]  [<ffffffff811044d3>] ? mount_fs+0x61/0x146
[    7.884748]  [<ffffffff81116f7d>] ? vfs_kern_mount+0x62/0xe3
[    7.887868]  [<ffffffff81117484>] ? do_kern_mount+0x49/0xdd
[    7.890979]  [<ffffffff81118c69>] ? do_mount+0x68a/0x710
[    7.894091]  [<ffffffff810d0ffe>] ? memdup_user+0x36/0x5b
[    7.897208]  [<ffffffff81118e0f>] ? sys_mount+0x80/0xba
[    7.900330]  [<ffffffff813683fd>] ? system_call_fastpath+0x1a/0x1f
[    7.903498] Code: 00 48 83 ca ff 31 f6 48 89 ef e8 3d 05 01 00 48 8b 
83 20 01 00 00 83 b8 50 0e 00 00 00 74 0e 48 8b 45 98 a8 20 0f 85 7b 01 
00 00 <0f> 0b 83 7d 48 00 74 0f 83 bb f8 00 00 00 00 0f 84 66 01 00 00
[    7.906842] RIP  [<ffffffffa017c720>] btrfs_evict_inode+0xc0/0x266 
[btrfs]
[    7.910186]  RSP <ffff880417ca1a58>
[    7.913561] ---[ end trace 86ad814028ba0f01 ]---

Full dmesg attached.

-- 
Frederik Himpe

--------------090304020309040106020503
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.0-rc4-custom-1 (root@piranha) (gcc versi=
on 4.7.0 (Debian 4.7.1-1) ) #2 SMP Mon Jun 25 20:32:43 CEST 2012
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-3.5.0-rc4-custom-1 roo=
t=3D/dev/mapper/debian-root ro debug ignore_loglevel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000c9904fff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000c9905000-0x00000000c9e7cfff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000c9e7d000-0x00000000ca0fcfff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000ca0fd000-0x00000000ca101fff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000ca102000-0x00000000ca144fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000ca145000-0x00000000caba6fff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000caba7000-0x00000000caff1fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000caff2000-0x00000000caffffff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000cb800000-0x00000000cf9fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000042f5fffff] usa=
ble
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: To Be Filled By O.E.M. To Be Filled By O.E.M./H77 Pro=
4/MVP, BIOS P1.30 05/10/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x42f600 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask C00000000 write-back
[    0.000000]   1 base 400000000 mask FE0000000 write-back
[    0.000000]   2 base 420000000 mask FF0000000 write-back
[    0.000000]   3 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   4 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   5 base 0CC000000 mask FFC000000 uncachable
[    0.000000]   6 base 0CB800000 mask FFF800000 uncachable
[    0.000000]   7 base 42F800000 mask FFF800000 uncachable
[    0.000000]   8 base 42F600000 mask FFFE00000 uncachable
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600=
070106
[    0.000000] e820: update [mem 0xcb800000-0xffffffff] usable =3D=3D> re=
served
[    0.000000] e820: last_pfn =3D 0xcb000 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fcd30-0x000fcd3f] mapped a=
t [ffff8800000fcd30]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24=
576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xcaffffff]
[    0.000000]  [mem 0x00000000-0xcaffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0xcaffffff @ [mem 0x1f9=
a3000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x42f5fffff]
[    0.000000]  [mem 0x100000000-0x42f5fffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x42f5fffff @ [mem 0xca=
b95000-0xcaba6fff]
[    0.000000] RAMDISK: [mem 0x3691e000-0x37486fff]
[    0.000000] ACPI: RSDP 00000000000f0450 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000ca0e4080 0007C (v01 ALASKA    A M I 010=
72009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000ca0edaa8 000F4 (v04 ALASKA    A M I 010=
72009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000ca0e4190 09916 (v02 ALASKA    A M I 000=
00014 INTL 20051117)
[    0.000000] ACPI: FACS 00000000ca0fbf80 00040
[    0.000000] ACPI: APIC 00000000ca0edba0 00072 (v03 ALASKA    A M I 010=
72009 AMI  00010013)
[    0.000000] ACPI: ASF! 00000000ca0edc18 000A5 (v32 INTEL       HCG 000=
00001 TFSM 000F4240)
[    0.000000] ACPI: MCFG 00000000ca0edcc0 0003C (v01 ALASKA    A M I 010=
72009 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000ca0edd00 004A6 (v01 Intel_ AoacTabl 000=
01000 INTL 20091112)
[    0.000000] ACPI: AAFT 00000000ca0ee1a8 000C2 (v01 ALASKA OEMAAFT  010=
72009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000ca0ee270 00038 (v01 ALASKA    A M I 010=
72009 AMI. 00000005)
[    0.000000] ACPI: SSDT 00000000ca0ee2a8 0036D (v01 SataRe SataTabl 000=
01000 INTL 20091112)
[    0.000000] ACPI: SSDT 00000000ca0ee618 009AA (v01  PmRef  Cpu0Ist 000=
03000 INTL 20051117)
[    0.000000] ACPI: SSDT 00000000ca0eefc8 00A92 (v01  PmRef    CpuPm 000=
03000 INTL 20051117)
[    0.000000] ACPI: BGRT 00000000ca0efa60 0003C (v00 ALASKA    A M I 010=
72009 AMI  00010013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000042f5ffff=
f]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x42f5fffff]
[    0.000000]   NODE_DATA [mem 0x42f5fc000-0x42f5fffff]
[    0.000000]  [ffffea0000000000-ffffea000ebfffff] PMD -> [ffff88041ec00=
000-ffff88042cdfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x42f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xc9904fff]
[    0.000000]   node   0: [mem 0xca145000-0xcaba6fff]
[    0.000000]   node   0: [mem 0xcaff2000-0xcaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x42f5fffff]
[    0.000000] On node 0 totalpages: 4167425
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3919 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 809388 pages, LIFO batch:31
[    0.000000]   Normal zone: 45661 pages used for memmap
[    0.000000]   Normal zone: 3294115 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000=
009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000=
00a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 000000000=
00e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 000000000=
0100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 000000002=
0200000
[    0.000000] PM: Registered nosave memory: 0000000040004000 - 000000004=
0005000
[    0.000000] PM: Registered nosave memory: 00000000c9905000 - 00000000c=
9e7d000
[    0.000000] PM: Registered nosave memory: 00000000c9e7d000 - 00000000c=
a0fd000
[    0.000000] PM: Registered nosave memory: 00000000ca0fd000 - 00000000c=
a102000
[    0.000000] PM: Registered nosave memory: 00000000ca102000 - 00000000c=
a145000
[    0.000000] PM: Registered nosave memory: 00000000caba7000 - 00000000c=
aff2000
[    0.000000] PM: Registered nosave memory: 00000000cb000000 - 00000000c=
b800000
[    0.000000] PM: Registered nosave memory: 00000000cb800000 - 00000000c=
fa00000
[    0.000000] PM: Registered nosave memory: 00000000cfa00000 - 00000000f=
8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000f=
c000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000f=
ec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000f=
ec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000f=
ed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000f=
ed04000
[    0.000000] PM: Registered nosave memory: 00000000fed04000 - 00000000f=
ed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000f=
ed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000f=
ee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000f=
ee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000f=
f000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 000000010=
0000000
[    0.000000] e820: [mem 0xcfa00000-0xf7ffffff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4=
 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88042f200000 s82688 r81=
92 d23808 u524288
[    0.000000] pcpu-alloc: s82688 r8192 d23808 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 4107422
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3.5.0-rc4-custo=
m-1 root=3D/dev/mapper/debian-root ro debug ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - baili=
ng!
[    0.000000] Memory: 16351484k/17553408k available (3503k kernel code, =
883708k absent, 318216k reserved, 3208k data, 580k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 3392.120 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 6784.24 BogoMIPS (lpj=3D13568480)
[    0.000067] pid_max: default: 32768 minimum: 301
[    0.000148] Security Framework initialized
[    0.000205] AppArmor: AppArmor disabled by boot time parameter
[    0.000946] Dentry cache hash table entries: 2097152 (order: 12, 16777=
216 bytes)
[    0.003883] Inode-cache hash table entries: 1048576 (order: 11, 838860=
8 bytes)
[    0.005236] Mount-cache hash table entries: 256
[    0.005411] Initializing cgroup subsys cpuacct
[    0.005469] Initializing cgroup subsys memory
[    0.005532] Initializing cgroup subsys devices
[    0.005587] Initializing cgroup subsys freezer
[    0.005643] Initializing cgroup subsys net_cls
[    0.005698] Initializing cgroup subsys blkio
[    0.005755] Initializing cgroup subsys perf_event
[    0.005828] CPU: Physical Processor ID: 0
[    0.005885] CPU: Processor Core ID: 0
[    0.005942] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.005942] ENERGY_PERF_BIAS: View and update with x86_energy_perf_pol=
icy(8)
[    0.006266] mce: CPU supports 9 MCE banks
[    0.006333] CPU0: Thermal monitoring enabled (TM1)
[    0.006397] using mwait in idle threads.
[    0.006753] ACPI: Core revision 20120320
[    0.019002] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.058625] CPU0: Intel(R) Core(TM) i5-3570K CPU @ 3.40GHz stepping 09=

[    0.164377] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge e=
vents, Intel PMU driver.
[    0.164438] ... version:                3
[    0.164493] ... bit width:              48
[    0.164549] ... generic registers:      8
[    0.164603] ... value mask:             0000ffffffffffff
[    0.164657] ... max period:             000000007fffffff
[    0.164714] ... fixed-purpose events:   3
[    0.164770] ... event mask:             00000007000000ff
[    0.164910] NMI watchdog: enabled on all CPUs, permanently consumes on=
e hw-PMU counter.
[    0.191952] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.205434] Brought up 4 CPUs
[    0.205491] Total of 4 processors activated (27136.96 BogoMIPS).
[    0.207862] devtmpfs: initialized
[    0.210630] PM: Registering ACPI NVS region [mem 0xc9e7d000-0xca0fcfff=
] (2621440 bytes)
[    0.210744] PM: Registering ACPI NVS region [mem 0xca102000-0xca144fff=
] (274432 bytes)
[    0.210865] dummy:=20
[    0.210959] NET: Registered protocol family 16
[    0.211100] ACPI FADT declares the system doesn't support PCIe ASPM, s=
o disable it
[    0.211164] ACPI: bus type pci registered
[    0.211259] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf80000=
00-0xfbffffff] (base 0xf8000000)
[    0.211326] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E=
820
[    0.214090] PCI: Using configuration type 1 for base access
[    0.214653] bio: create slab <bio-0> at 0
[    0.214760] ACPI: Added _OSI(Module Device)
[    0.214817] ACPI: Added _OSI(Processor Device)
[    0.214871] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.214926] ACPI: Added _OSI(Processor Aggregator Device)
[    0.215860] ACPI: EC: Look up EC in DSDT
[    0.216884] ACPI: Executed 1 blocks of module-level executable AML cod=
e
[    0.219335] ACPI: SSDT 00000000c9e2a018 0083B (v01  PmRef  Cpu0Cst 000=
03001 INTL 20051117)
[    0.219624] ACPI: Dynamic OEM Table Load:
[    0.219678] ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst 000=
03001 INTL 20051117)
[    0.219946] ACPI: SSDT 00000000c9e2ba98 00303 (v01  PmRef    ApIst 000=
03000 INTL 20051117)
[    0.220258] ACPI: Dynamic OEM Table Load:
[    0.220317] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 000=
03000 INTL 20051117)
[    0.220484] ACPI: SSDT 00000000c9e2cc18 00119 (v01  PmRef    ApCst 000=
03000 INTL 20051117)
[    0.220775] ACPI: Dynamic OEM Table Load:
[    0.220834] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 000=
03000 INTL 20051117)
[    0.221319] ACPI: Interpreter enabled
[    0.221393] ACPI: (supports S0 S1 S3 S4 S5)
[    0.221453] ACPI: Using IOAPIC for interrupt routing
[    0.225746] ACPI: No dock devices found.
[    0.225804] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.226091] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.226461] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7=
]
[    0.226518] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff=
]
[    0.226578] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x=
000bffff]
[    0.226640] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x=
000d3fff]
[    0.226702] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x=
000d7fff]
[    0.226763] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x=
000dbfff]
[    0.226828] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x=
000dffff]
[    0.226891] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x=
000e3fff]
[    0.226956] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x=
000e7fff]
[    0.227017] pci_root PNP0A08:00: host bridge window [mem 0xcfa00000-0x=
feafffff]
[    0.227098] PCI host bridge to bus 0000:00
[    0.227154] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.227211] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.227269] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.227326] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3=
fff]
[    0.227381] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7=
fff]
[    0.227436] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000db=
fff]
[    0.227497] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000df=
fff]
[    0.227552] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3=
fff]
[    0.227611] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7=
fff]
[    0.227670] pci_bus 0000:00: root bus resource [mem 0xcfa00000-0xfeaff=
fff]
[    0.227733] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.227813] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
[    0.227889] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.227958] pci 0000:00:02.0: [8086:0162] type 00 class 0x038000
[    0.228022] pci 0000:00:02.0: reg 10: [mem 0xf7800000-0xf7bfffff 64bit=
]
[    0.228084] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit=
 pref]
[    0.228144] pci 0000:00:02.0: reg 20: [io  0xf000-0xf03f]
[    0.228244] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.228319] pci 0000:00:14.0: reg 10: [mem 0xf7e00000-0xf7e0ffff 64bit=
]
[    0.228442] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.228516] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.228594] pci 0000:00:16.0: reg 10: [mem 0xf7e1a000-0xf7e1a00f 64bit=
]
[    0.228721] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.228806] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.228878] pci 0000:00:1a.0: reg 10: [mem 0xf7e18000-0xf7e183ff]
[    0.229016] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.229094] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.229170] pci 0000:00:1b.0: reg 10: [mem 0xf7e10000-0xf7e13fff 64bit=
]
[    0.229292] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.229375] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.229560] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.229656] pci 0000:00:1c.4: [8086:244e] type 01 class 0x060401
[    0.229786] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.229864] pci 0000:00:1c.5: [8086:1e1a] type 01 class 0x060400
[    0.229992] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.230071] pci 0000:00:1c.7: [8086:1e1e] type 01 class 0x060400
[    0.230199] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.230281] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.230354] pci 0000:00:1d.0: reg 10: [mem 0xf7e17000-0xf7e173ff]
[    0.230495] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.230572] pci 0000:00:1f.0: [8086:1e4a] type 00 class 0x060100
[    0.230743] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
[    0.230814] pci 0000:00:1f.2: reg 10: [io  0xf0b0-0xf0b7]
[    0.230873] pci 0000:00:1f.2: reg 14: [io  0xf0a0-0xf0a3]
[    0.230934] pci 0000:00:1f.2: reg 18: [io  0xf090-0xf097]
[    0.230995] pci 0000:00:1f.2: reg 1c: [io  0xf080-0xf083]
[    0.231057] pci 0000:00:1f.2: reg 20: [io  0xf060-0xf07f]
[    0.231117] pci 0000:00:1f.2: reg 24: [mem 0xf7e16000-0xf7e167ff]
[    0.231214] pci 0000:00:1f.2: PME# supported from D3hot
[    0.231284] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.231353] pci 0000:00:1f.3: reg 10: [mem 0xf7e15000-0xf7e150ff 64bit=
]
[    0.231429] pci 0000:00:1f.3: reg 20: [io  0xf040-0xf05f]
[    0.231529] pci 0000:01:00.0: [1002:6819] type 00 class 0x030000
[    0.231594] pci 0000:01:00.0: reg 10: [mem 0xe0000000-0xefffffff 64bit=
 pref]
[    0.231657] pci 0000:01:00.0: reg 18: [mem 0xf7d00000-0xf7d3ffff 64bit=
]
[    0.231715] pci 0000:01:00.0: reg 20: [io  0xe000-0xe0ff]
[    0.231779] pci 0000:01:00.0: reg 30: [mem 0xf7d40000-0xf7d5ffff pref]=

[    0.231854] pci 0000:01:00.0: supports D1 D2
[    0.231910] pci 0000:01:00.0: PME# supported from D1 D2 D3hot
[    0.231983] pci 0000:01:00.1: [1002:aab0] type 00 class 0x040300
[    0.232046] pci 0000:01:00.1: reg 10: [mem 0xf7d60000-0xf7d63fff 64bit=
]
[    0.232132] pci 0000:01:00.1: supports D1 D2
[    0.240168] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.240250] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.240311] pci 0000:00:01.0:   bridge window [mem 0xf7d00000-0xf7dfff=
ff]
[    0.240368] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffff=
ff 64bit pref]
[    0.240504] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.240630] pci 0000:03:00.0: [1b21:1080] type 01 class 0x060401
[    0.240834] pci 0000:00:1c.4: PCI bridge to [bus 03-04] (subtractive d=
ecode)
[    0.240901] pci 0000:00:1c.4:   bridge window [io  0x0000-0x0cf7] (sub=
tractive decode)
[    0.244136] pci 0000:00:1c.4:   bridge window [io  0x0d00-0xffff] (sub=
tractive decode)
[    0.244198] pci 0000:00:1c.4:   bridge window [mem 0x000a0000-0x000bff=
ff] (subtractive decode)
[    0.244260] pci 0000:00:1c.4:   bridge window [mem 0x000d0000-0x000d3f=
ff] (subtractive decode)
[    0.244322] pci 0000:00:1c.4:   bridge window [mem 0x000d4000-0x000d7f=
ff] (subtractive decode)
[    0.244387] pci 0000:00:1c.4:   bridge window [mem 0x000d8000-0x000dbf=
ff] (subtractive decode)
[    0.244452] pci 0000:00:1c.4:   bridge window [mem 0x000dc000-0x000dff=
ff] (subtractive decode)
[    0.244514] pci 0000:00:1c.4:   bridge window [mem 0x000e0000-0x000e3f=
ff] (subtractive decode)
[    0.244576] pci 0000:00:1c.4:   bridge window [mem 0x000e4000-0x000e7f=
ff] (subtractive decode)
[    0.244637] pci 0000:00:1c.4:   bridge window [mem 0xcfa00000-0xfeafff=
ff] (subtractive decode)
[    0.244836] pci 0000:03:00.0: PCI bridge to [bus 04-04] (subtractive d=
ecode)
[    0.244920] pci 0000:03:00.0:   bridge window [??? 0x00000000 flags 0x=
0] (subtractive decode)
[    0.244984] pci 0000:03:00.0:   bridge window [??? 0x00000000 flags 0x=
0] (subtractive decode)
[    0.245047] pci 0000:03:00.0:   bridge window [??? 0x00000000 flags 0x=
0] (subtractive decode)
[    0.245110] pci 0000:03:00.0:   bridge window [??? 0x00000000 flags 0x=
0] (subtractive decode)
[    0.245177] pci 0000:03:00.0:   bridge window [io  0x0000-0x0cf7] (sub=
tractive decode)
[    0.245237] pci 0000:03:00.0:   bridge window [io  0x0d00-0xffff] (sub=
tractive decode)
[    0.245298] pci 0000:03:00.0:   bridge window [mem 0x000a0000-0x000bff=
ff] (subtractive decode)
[    0.245365] pci 0000:03:00.0:   bridge window [mem 0x000d0000-0x000d3f=
ff] (subtractive decode)
[    0.245429] pci 0000:03:00.0:   bridge window [mem 0x000d4000-0x000d7f=
ff] (subtractive decode)
[    0.245491] pci 0000:03:00.0:   bridge window [mem 0x000d8000-0x000dbf=
ff] (subtractive decode)
[    0.245556] pci 0000:03:00.0:   bridge window [mem 0x000dc000-0x000dff=
ff] (subtractive decode)
[    0.245617] pci 0000:03:00.0:   bridge window [mem 0x000e0000-0x000e3f=
ff] (subtractive decode)
[    0.245681] pci 0000:03:00.0:   bridge window [mem 0x000e4000-0x000e7f=
ff] (subtractive decode)
[    0.245745] pci 0000:03:00.0:   bridge window [mem 0xcfa00000-0xfeafff=
ff] (subtractive decode)
[    0.245881] pci 0000:05:00.0: [10ec:8168] type 00 class 0x020000
[    0.245957] pci 0000:05:00.0: reg 10: [io  0xd000-0xd0ff]
[    0.246048] pci 0000:05:00.0: reg 18: [mem 0xf0004000-0xf0004fff 64bit=
 pref]
[    0.246121] pci 0000:05:00.0: reg 20: [mem 0xf0000000-0xf0003fff 64bit=
 pref]
[    0.246266] pci 0000:05:00.0: supports D1 D2
[    0.246321] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.252142] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    0.252221] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.252286] pci 0000:00:1c.5:   bridge window [mem 0xf0000000-0xf00fff=
ff 64bit pref]
[    0.252408] pci 0000:06:00.0: [1b21:0612] type 00 class 0x010601
[    0.252485] pci 0000:06:00.0: reg 10: [io  0xc050-0xc057]
[    0.252551] pci 0000:06:00.0: reg 14: [io  0xc040-0xc043]
[    0.252623] pci 0000:06:00.0: reg 18: [io  0xc030-0xc037]
[    0.252692] pci 0000:06:00.0: reg 1c: [io  0xc020-0xc023]
[    0.252758] pci 0000:06:00.0: reg 20: [io  0xc000-0xc01f]
[    0.252825] pci 0000:06:00.0: reg 24: [mem 0xf7c00000-0xf7c001ff]
[    0.260116] pci 0000:00:1c.7: PCI bridge to [bus 06-06]
[    0.260195] pci 0000:00:1c.7:   bridge window [io  0xc000-0xcfff]
[    0.260256] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfff=
ff]
[    0.260339] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.260511] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.260594] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.260673] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05.BR40._P=
RT]
[    0.260767] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.260846] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
[    0.260928] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    0.261077]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.261274]  pci0000:00: ACPI _OSC control (0x1c) granted
[    0.264754] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14=
 15)
[    0.264844] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14=
 15)
[    0.264931] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14=
 15)
[    0.265015] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14=
 15)
[    0.265100] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 =
15) *0, disabled.
[    0.265197] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 =
15) *0, disabled.
[    0.265288] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14=
 15)
[    0.265377] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14=
 15)
[    0.265490] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.265550] vgaarb: loaded
[    0.265607] vgaarb: bridge control possible 0000:01:00.0
[    0.265679] PCI: Using ACPI for IRQ routing
[    0.267090] PCI: pci_cache_line_size set to 64 bytes
[    0.267206] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.267263] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.267320] e820: reserve RAM buffer [mem 0xc9905000-0xcbffffff]
[    0.267383] e820: reserve RAM buffer [mem 0xcaba7000-0xcbffffff]
[    0.267440] e820: reserve RAM buffer [mem 0xcb000000-0xcbffffff]
[    0.267496] e820: reserve RAM buffer [mem 0x42f600000-0x42fffffff]
[    0.267629] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.267686] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.269748] Switching to clocksource hpet
[    0.270842] pnp: PnP ACPI init
[    0.270904] ACPI: bus type pnp registered
[    0.271130] pnp 00:00: [bus 00-3e]
[    0.271188] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.271244] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.271298] pnp 00:00: [io  0x0d00-0xffff window]
[    0.271356] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.271415] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.271474] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.271534] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.271594] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.271652] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.271715] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.271773] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.271830] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.271888] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.271942] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.271999] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.272056] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.272117] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.272177] pnp 00:00: [mem 0xcfa00000-0xfeafffff window]
[    0.272232] pnp 00:00: [mem 0x00010000-0x0001ffff window]
[    0.272313] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 =
(active)
[    0.272388] pnp 00:01: [mem 0xfed40000-0xfed44fff]
[    0.272463] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserve=
d
[    0.272520] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    0.272583] pnp 00:02: [io  0x0000-0x001f]
[    0.272638] pnp 00:02: [io  0x0081-0x0091]
[    0.272696] pnp 00:02: [io  0x0093-0x009f]
[    0.272750] pnp 00:02: [io  0x00c0-0x00df]
[    0.272807] pnp 00:02: [dma 4]
[    0.272872] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)=

[    0.272937] pnp 00:03: [mem 0xff000000-0xffffffff]
[    0.273006] pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)=

[    0.273114] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.273180] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)=

[    0.273248] pnp 00:05: [io  0x002e-0x002f]
[    0.273305] pnp 00:05: [io  0x004e-0x004f]
[    0.273359] pnp 00:05: [io  0x0061]
[    0.273416] pnp 00:05: [io  0x0063]
[    0.273471] pnp 00:05: [io  0x0065]
[    0.273529] pnp 00:05: [io  0x0067]
[    0.273584] pnp 00:05: [io  0x0070]
[    0.273638] pnp 00:05: [io  0x0080]
[    0.273694] pnp 00:05: [io  0x0092]
[    0.273747] pnp 00:05: [io  0x00b2-0x00b3]
[    0.273810] pnp 00:05: [io  0x0680-0x069f]
[    0.273869] pnp 00:05: [io  0x0200-0x020f]
[    0.273929] pnp 00:05: [io  0xffff]
[    0.273989] pnp 00:05: [io  0xffff]
[    0.274046] pnp 00:05: [io  0x0400-0x0453]
[    0.274100] pnp 00:05: [io  0x0458-0x047f]
[    0.274154] pnp 00:05: [io  0x0500-0x057f]
[    0.274210] pnp 00:05: [io  0x164e-0x164f]
[    0.274295] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.274354] system 00:05: [io  0x0200-0x020f] has been reserved
[    0.274411] system 00:05: [io  0xffff] has been reserved
[    0.274467] system 00:05: [io  0xffff] has been reserved
[    0.274525] system 00:05: [io  0x0400-0x0453] has been reserved
[    0.274588] system 00:05: [io  0x0458-0x047f] has been reserved
[    0.274645] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.274701] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.274760] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.274820] pnp 00:06: [io  0x0070-0x0077]
[    0.274882] pnp 00:06: [irq 8]
[    0.274951] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.275024] pnp 00:07: [io  0x0454-0x0457]
[    0.275098] system 00:07: [io  0x0454-0x0457] has been reserved
[    0.275155] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c=
02 (active)
[    0.275250] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.275307] pnp 00:08: [io  0x0290-0x029f]
[    0.275367] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.275445] system 00:08: [io  0x0290-0x029f] has been reserved
[    0.275502] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.275705] pnp 00:09: [io  0x0010-0x001f]
[    0.275762] pnp 00:09: [io  0x0022-0x003f]
[    0.278998] pnp 00:09: [io  0x0044-0x005f]
[    0.279055] pnp 00:09: [io  0x0062-0x0063]
[    0.279110] pnp 00:09: [io  0x0065-0x006f]
[    0.279165] pnp 00:09: [io  0x0072-0x007f]
[    0.279227] pnp 00:09: [io  0x0080]
[    0.279282] pnp 00:09: [io  0x0084-0x0086]
[    0.279343] pnp 00:09: [io  0x0088]
[    0.279399] pnp 00:09: [io  0x008c-0x008e]
[    0.279454] pnp 00:09: [io  0x0090-0x009f]
[    0.279512] pnp 00:09: [io  0x00a2-0x00bf]
[    0.279567] pnp 00:09: [io  0x00e0-0x00ef]
[    0.279621] pnp 00:09: [io  0x04d0-0x04d1]
[    0.279700] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.279761] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.279824] pnp 00:0a: [io  0x00f0-0x00ff]
[    0.279881] pnp 00:0a: [irq 13]
[    0.279949] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)=

[    0.280125] pnp 00:0b: [io  0x03f8-0x03ff]
[    0.280183] pnp 00:0b: [irq 4]
[    0.280236] pnp 00:0b: [dma 0 disabled]
[    0.280330] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.280526] pnp 00:0c: [mem 0xfed1c000-0xfed1ffff]
[    0.280583] pnp 00:0c: [mem 0xfed10000-0xfed17fff]
[    0.280639] pnp 00:0c: [mem 0xfed18000-0xfed18fff]
[    0.280696] pnp 00:0c: [mem 0xfed19000-0xfed19fff]
[    0.280752] pnp 00:0c: [mem 0xf8000000-0xfbffffff]
[    0.280808] pnp 00:0c: [mem 0xfed20000-0xfed3ffff]
[    0.280862] pnp 00:0c: [mem 0xfed90000-0xfed93fff]
[    0.280918] pnp 00:0c: [mem 0xfed45000-0xfed8ffff]
[    0.280975] pnp 00:0c: [mem 0xff000000-0xffffffff]
[    0.281035] pnp 00:0c: [mem 0xfee00000-0xfeefffff]
[    0.281091] pnp 00:0c: [mem 0xcfa00000-0xcfa00fff]
[    0.281179] system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserve=
d
[    0.281236] system 00:0c: [mem 0xfed10000-0xfed17fff] has been reserve=
d
[    0.281295] system 00:0c: [mem 0xfed18000-0xfed18fff] has been reserve=
d
[    0.281354] system 00:0c: [mem 0xfed19000-0xfed19fff] has been reserve=
d
[    0.281413] system 00:0c: [mem 0xf8000000-0xfbffffff] has been reserve=
d
[    0.281468] system 00:0c: [mem 0xfed20000-0xfed3ffff] has been reserve=
d
[    0.281523] system 00:0c: [mem 0xfed90000-0xfed93fff] has been reserve=
d
[    0.281580] system 00:0c: [mem 0xfed45000-0xfed8ffff] has been reserve=
d
[    0.281638] system 00:0c: [mem 0xff000000-0xffffffff] has been reserve=
d
[    0.281696] system 00:0c: [mem 0xfee00000-0xfeefffff] could not be res=
erved
[    0.281752] system 00:0c: [mem 0xcfa00000-0xcfa00fff] has been reserve=
d
[    0.281817] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.281981] pnp 00:0d: [mem 0x20000000-0x201fffff]
[    0.282036] pnp 00:0d: [mem 0x40004000-0x40004fff]
[    0.282125] system 00:0d: [mem 0x20000000-0x201fffff] has been reserve=
d
[    0.282182] system 00:0d: [mem 0x40004000-0x40004fff] has been reserve=
d
[    0.282242] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    0.282320] pnp: PnP ACPI: found 14 devices
[    0.282376] ACPI: ACPI bus type pnp unregistered
[    0.288226] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bu=
s 02-02] add_size 1000
[    0.288293] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff=
 64bit pref] to [bus 02-02] add_size 200000
[    0.288355] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff=
] to [bus 02-02] add_size 200000
[    0.288453] pci 0000:00:1c.0: res[14]=3D[mem 0x00100000-0x000fffff] ge=
t_res_add_size add_size 200000
[    0.288516] pci 0000:00:1c.0: res[15]=3D[mem 0x00100000-0x000fffff 64b=
it pref] get_res_add_size add_size 200000
[    0.288581] pci 0000:00:1c.0: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
[    0.288648] pci 0000:00:1c.0: BAR 14: assigned [mem 0xcfb00000-0xcfcff=
fff]
[    0.288706] pci 0000:00:1c.0: BAR 15: assigned [mem 0xcfd00000-0xcfeff=
fff 64bit pref]
[    0.288771] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.288826] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.288885] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.288945] pci 0000:00:01.0:   bridge window [mem 0xf7d00000-0xf7dfff=
ff]
[    0.289001] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffff=
ff 64bit pref]
[    0.289063] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.289119] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.289183] pci 0000:00:1c.0:   bridge window [mem 0xcfb00000-0xcfcfff=
ff]
[    0.289244] pci 0000:00:1c.0:   bridge window [mem 0xcfd00000-0xcfefff=
ff 64bit pref]
[    0.289318] pci 0000:03:00.0: PCI bridge to [bus 04-04]
[    0.289397] pci 0000:00:1c.4: PCI bridge to [bus 03-04]
[    0.289460] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    0.289515] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.289579] pci 0000:00:1c.5:   bridge window [mem 0xf0000000-0xf00fff=
ff 64bit pref]
[    0.289649] pci 0000:00:1c.7: PCI bridge to [bus 06-06]
[    0.289705] pci 0000:00:1c.7:   bridge window [io  0xc000-0xcfff]
[    0.289767] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfff=
ff]
[    0.289852] pci 0000:03:00.0: setting latency timer to 64
[    0.289919] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.289976] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.290031] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.290086] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.290145] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.290200] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.290255] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.290310] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.290370] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.290428] pci_bus 0000:00: resource 13 [mem 0xcfa00000-0xfeafffff]
[    0.290486] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.290545] pci_bus 0000:01: resource 1 [mem 0xf7d00000-0xf7dfffff]
[    0.290604] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64b=
it pref]
[    0.290668] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.290722] pci_bus 0000:02: resource 1 [mem 0xcfb00000-0xcfcfffff]
[    0.290782] pci_bus 0000:02: resource 2 [mem 0xcfd00000-0xcfefffff 64b=
it pref]
[    0.290848] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.290905] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.290964] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.291021] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.291079] pci_bus 0000:03: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.291133] pci_bus 0000:03: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.291195] pci_bus 0000:03: resource 10 [mem 0x000dc000-0x000dffff]
[    0.291253] pci_bus 0000:03: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.291310] pci_bus 0000:03: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.291368] pci_bus 0000:03: resource 13 [mem 0xcfa00000-0xfeafffff]
[    0.291422] pci_bus 0000:04: resource 8 [io  0x0000-0x0cf7]
[    0.291476] pci_bus 0000:04: resource 9 [io  0x0d00-0xffff]
[    0.291537] pci_bus 0000:04: resource 10 [mem 0x000a0000-0x000bffff]
[    0.291597] pci_bus 0000:04: resource 11 [mem 0x000d0000-0x000d3fff]
[    0.291654] pci_bus 0000:04: resource 12 [mem 0x000d4000-0x000d7fff]
[    0.291710] pci_bus 0000:04: resource 13 [mem 0x000d8000-0x000dbfff]
[    0.291765] pci_bus 0000:04: resource 14 [mem 0x000dc000-0x000dffff]
[    0.291819] pci_bus 0000:04: resource 15 [mem 0x000e0000-0x000e3fff]
[    0.291874] pci_bus 0000:04: resource 16 [mem 0x000e4000-0x000e7fff]
[    0.291931] pci_bus 0000:04: resource 17 [mem 0xcfa00000-0xfeafffff]
[    0.291985] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.292041] pci_bus 0000:05: resource 2 [mem 0xf0000000-0xf00fffff 64b=
it pref]
[    0.292101] pci_bus 0000:06: resource 0 [io  0xc000-0xcfff]
[    0.292159] pci_bus 0000:06: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.292266] NET: Registered protocol family 2
[    0.292513] IP route cache hash table entries: 524288 (order: 10, 4194=
304 bytes)
[    0.293149] TCP established hash table entries: 524288 (order: 11, 838=
8608 bytes)
[    0.294054] TCP bind hash table entries: 65536 (order: 8, 1048576 byte=
s)
[    0.294214] TCP: Hash tables configured (established 524288 bind 65536=
)
[    0.294273] TCP: reno registered
[    0.294345] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.294438] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)=

[    0.294582] NET: Registered protocol family 1
[    0.333660] pci 0000:01:00.0: Boot video device
[    0.333745] PCI: CLS 64 bytes, default 64
[    0.333826] Unpacking initramfs...
[    0.484882] Freeing initrd memory: 11684k freed
[    0.485805] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.485865] software IO TLB [mem 0xc5905000-0xc9904fff] (64MB) mapped =
at [ffff8800c5905000-ffff8800c9904fff]
[    0.486271] audit: initializing netlink socket (disabled)
[    0.486332] type=3D2000 audit(1340823869.376:1): initialized
[    0.496633] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.497612] VFS: Disk quotas dquot_6.5.2
[    0.497681] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.497783] msgmni has been set to 31959
[    0.497996] alg: No test for stdrng (krng)
[    0.498066] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 252)
[    0.498130] io scheduler noop registered
[    0.498184] io scheduler deadline registered
[    0.498257] io scheduler cfq registered (default)
[    0.498381] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.498538] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.498711] pcieport 0000:00:1c.5: irq 42 for MSI/MSI-X
[    0.498855] pcieport 0000:00:1c.7: irq 43 for MSI/MSI-X
[    0.498975] pcieport 0000:00:01.0: Signaling PME through PCIe PME inte=
rrupt
[    0.499033] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt=

[    0.499089] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt=

[    0.499152] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme load=
ed
[    0.499231] pcieport 0000:00:1c.0: Signaling PME through PCIe PME inte=
rrupt
[    0.499297] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme load=
ed
[    0.499365] pcieport 0000:00:1c.5: Signaling PME through PCIe PME inte=
rrupt
[    0.499423] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt=

[    0.499485] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme load=
ed
[    0.499561] pcieport 0000:00:1c.7: Signaling PME through PCIe PME inte=
rrupt
[    0.499616] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt=

[    0.499680] pcie_pme 0000:00:1c.7:pcie01: service driver pcie_pme load=
ed
[    0.499740] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.499804] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    0.499863] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.500147] intel_idle: does not run on family 6 model 58
[    0.503350] GHES: HEST is not enabled!
[    0.503435] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.523823] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.544432] 00:0b: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.544666] Linux agpgart interface v0.103
[    0.544780] agpgart-intel 0000:00:00.0: Intel Ivybridge Chipset
[    0.544874] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K to=
tal, 262144K mappable
[    0.545552] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    0.545694] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000=
000
[    0.545833] i8042: PNP: No PS/2 controller found. Probing ports direct=
ly.
[    0.548596] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.548657] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.548789] mousedev: PS/2 mouse device common for all mice
[    0.548878] rtc_cmos 00:06: RTC can wake from S4
[    0.549066] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.549146] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet i=
rqs
[    0.549205] cpuidle: using governor ladder
[    0.549258] cpuidle: using governor menu
[    0.549376] drop_monitor: Initializing network drop monitor service
[    0.549472] TCP: cubic registered
[    0.549577] NET: Registered protocol family 10
[    0.549748] mip6: Mobile IPv6
[    0.549805] NET: Registered protocol family 17
[    0.549863] Key type dns_resolver registered
[    0.549998] PM: Hibernation image not present or could not be loaded.
[    0.550058] registered taskstats version 1
[    0.550794] rtc_cmos 00:06: setting system clock to 2012-06-27 19:04:3=
0 UTC (1340823870)
[    0.551632] Freeing unused kernel memory: 580k freed
[    0.551733] Write protecting the kernel read-only data: 6144k
[    0.553159] Freeing unused kernel memory: 584k freed
[    0.554702] Freeing unused kernel memory: 656k freed
[    0.561225] udevd[59]: starting version 175
[    0.569742] ACPI: bus type usb registered
[    0.569821] usbcore: registered new interface driver usbfs
[    0.569888] usbcore: registered new interface driver hub
[    0.571794] SCSI subsystem initialized
[    0.573491] usbcore: registered new device driver usb
[    0.573782] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    0.573854] libata version 3.00 loaded.
[    0.573923] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.573988] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.574047] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bu=
s number 1
[    0.574126] ehci_hcd 0000:00:1a.0: debug port 2
[    0.574984] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.575191] r8169 0000:05:00.0: irq 44 for MSI/MSI-X
[    0.575920] r8169 0000:05:00.0: eth0: RTL8168evl/8111evl at 0xffffc900=
065d8000, bc:5f:f4:38:be:84, XID 0c900800 IRQ 44
[    0.576003] r8169 0000:05:00.0: eth0: jumbo features [frames: 9200 byt=
es, tx checksumming: ko]
[    0.578050] ehci_hcd 0000:00:1a.0: cache line size of 64 is not suppor=
ted
[    0.580811] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf7e18000
[    0.588908] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.588985] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    0.589051] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    0.589122] usb usb1: Product: EHCI Host Controller
[    0.589189] usb usb1: Manufacturer: Linux 3.5.0-rc4-custom-1 ehci_hcd
[    0.589253] usb usb1: SerialNumber: 0000:00:1a.0
[    0.589646] hub 1-0:1.0: USB hub found
[    0.589710] hub 1-0:1.0: 2 ports detected
[    0.589840] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.589906] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.589970] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bu=
s number 2
[    0.590059] ehci_hcd 0000:00:1d.0: debug port 2
[    0.593991] ehci_hcd 0000:00:1d.0: cache line size of 64 is not suppor=
ted
[    0.594067] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf7e17000
[    0.604856] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.604947] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    0.605016] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    0.605076] usb usb2: Product: EHCI Host Controller
[    0.605133] usb usb2: Manufacturer: Linux 3.5.0-rc4-custom-1 ehci_hcd
[    0.605190] usb usb2: SerialNumber: 0000:00:1d.0
[    0.605313] hub 2-0:1.0: USB hub found
[    0.605378] hub 2-0:1.0: 2 ports detected
[    0.605474] ahci 0000:00:1f.2: version 3.0
[    0.605582] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    0.620851] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps =
0x3f impl SATA mode
[    0.620929] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum pa=
rt ems apst=20
[    0.620993] ahci 0000:00:1f.2: setting latency timer to 64
[    0.661088] scsi0 : ahci
[    0.661218] scsi1 : ahci
[    0.661326] scsi2 : ahci
[    0.661502] scsi3 : ahci
[    0.661636] scsi4 : ahci
[    0.661739] scsi5 : ahci
[    0.661977] ata1: SATA max UDMA/133 abar m2048@0xf7e16000 port 0xf7e16=
100 irq 45
[    0.662040] ata2: SATA max UDMA/133 abar m2048@0xf7e16000 port 0xf7e16=
180 irq 45
[    0.662104] ata3: SATA max UDMA/133 abar m2048@0xf7e16000 port 0xf7e16=
200 irq 45
[    0.662172] ata4: SATA max UDMA/133 abar m2048@0xf7e16000 port 0xf7e16=
280 irq 45
[    0.662235] ata5: SATA max UDMA/133 abar m2048@0xf7e16000 port 0xf7e16=
300 irq 45
[    0.662298] ata6: SATA max UDMA/133 abar m2048@0xf7e16000 port 0xf7e16=
380 irq 45
[    0.662398] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    0.662453] ahci 0000:06:00.0: irq 46 for MSI/MSI-X
[    0.662494] ahci: SSS flag set, parallel bus scan disabled
[    0.662569] ahci 0000:06:00.0: AHCI 0001.0200 32 slots 2 ports 6 Gbps =
0x3 impl SATA mode
[    0.662571] ahci 0000:06:00.0: flags: 64bit ncq sntf stag led clo pmp =
pio slum part ccc sxs=20
[    0.662752] scsi6 : ahci
[    0.662809] scsi7 : ahci
[    0.662839] ata7: SATA max UDMA/133 abar m512@0xf7c00000 port 0xf7c001=
00 irq 46
[    0.662843] ata8: SATA max UDMA/133 abar m512@0xf7c00000 port 0xf7c001=
80 irq 46
[    0.663113] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.663172] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bu=
s number 3
[    0.663315] xhci_hcd 0000:00:14.0: cache line size of 64 is not suppor=
ted
[    0.663374] xhci_hcd 0000:00:14.0: irq 16, io mem 0xf7e00000
[    0.663467] xhci_hcd 0000:00:14.0: irq 47 for MSI/MSI-X
[    0.663561] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    0.663621] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    0.663684] usb usb3: Product: xHCI Host Controller
[    0.663742] usb usb3: Manufacturer: Linux 3.5.0-rc4-custom-1 xhci_hcd
[    0.663805] usb usb3: SerialNumber: 0000:00:14.0
[    0.663912] xHCI xhci_add_endpoint called for root hub
[    0.663972] xHCI xhci_check_bandwidth called for root hub
[    0.664045] hub 3-0:1.0: USB hub found
[    0.664113] hub 3-0:1.0: 4 ports detected
[    0.664207] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.664267] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bu=
s number 4
[    0.664343] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[    0.664402] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    0.664466] usb usb4: Product: xHCI Host Controller
[    0.664522] usb usb4: Manufacturer: Linux 3.5.0-rc4-custom-1 xhci_hcd
[    0.664580] usb usb4: SerialNumber: 0000:00:14.0
[    0.664694] xHCI xhci_add_endpoint called for root hub
[    0.664759] xHCI xhci_check_bandwidth called for root hub
[    0.664834] hub 4-0:1.0: USB hub found
[    0.664895] hub 4-0:1.0: 4 ports detected
[    0.900013] usb 1-1: new high-speed USB device number 2 using ehci_hcd=

[    0.979801] ata4: SATA link down (SStatus 0 SControl 300)
[    0.979902] ata6: SATA link down (SStatus 0 SControl 300)
[    0.979979] ata5: SATA link down (SStatus 0 SControl 300)
[    0.980054] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.980131] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.980209] ata1: SATA link down (SStatus 0 SControl 300)
[    0.983178] ata3.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succ=
eeded
[    0.983261] ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LO=
CK) filtered out
[    0.983327] ata3.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATI=
ON OVERLAY) filtered out
[    0.983746] ata3.00: ATAPI: ATAPI   iHAS124   C, LL05, max UDMA/100
[    0.985109] ata3.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succ=
eeded
[    0.985190] ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LO=
CK) filtered out
[    0.985251] ata3.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATI=
ON OVERLAY) filtered out
[    0.985578] ata3.00: configured for UDMA/100
[    1.031997] usb 1-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[    1.032077] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    1.032262] hub 1-1:1.0: USB hub found
[    1.032366] hub 1-1:1.0: 6 ports detected
[    1.129906] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) reje=
cted by device (Stat=3D0x51 Err=3D0x04)
[    1.129995] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LO=
CK) filtered out
[    1.130057] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATI=
ON OVERLAY) filtered out
[    1.130254] ata2.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
[    1.130327] ata2.00: 390721968 sectors, multi 16: LBA48=20
[    1.143329] usb 2-1: new high-speed USB device number 2 using ehci_hcd=

[    1.151310] ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.155029] ata7.00: ATA-9: SAMSUNG SSD 830 Series, CXM03B1Q, max UDMA=
/133
[    1.155098] ata7.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/=
32), AA
[    1.155442] ata7.00: configured for UDMA/133
[    1.275299] usb 2-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[    1.275379] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    1.275561] hub 2-1:1.0: USB hub found
[    1.275669] hub 2-1:1.0: 8 ports detected
[    1.280344] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) reje=
cted by device (Stat=3D0x51 Err=3D0x04)
[    1.280431] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LO=
CK) filtered out
[    1.280496] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATI=
ON OVERLAY) filtered out
[    1.280681] ata2.00: configured for UDMA/133
[    1.280834] scsi 1:0:0:0: Direct-Access     ATA      ST3200822AS      =
3.01 PQ: 0 ANSI: 5
[    1.284379] scsi 2:0:0:0: CD-ROM            ATAPI    iHAS124   C      =
LL05 PQ: 0 ANSI: 5
[    1.284590] scsi 6:0:0:0: Direct-Access     ATA      SAMSUNG SSD 830  =
CXM0 PQ: 0 ANSI: 5
[    1.442466] usb 3-2: new high-speed USB device number 2 using xhci_hcd=

[    1.482347] Refined TSC clocksource calibration: 3392.293 MHz.
[    1.482426] Switching to clocksource tsc
[    1.731055] usb 3-2: New USB device found, idVendor=3D046d, idProduct=3D=
0826
[    1.731137] usb 3-2: New USB device strings: Mfr=3D0, Product=3D2, Ser=
ialNumber=3D1
[    1.731194] usb 3-2: Product: HD Webcam C525
[    1.731255] usb 3-2: SerialNumber: 1E83E9D0
[    1.773522] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.781063] ata8.00: ATA-8: WDC WD20EARX-00PASB0, 51.0AB51, max UDMA/1=
33
[    1.781144] ata8.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31=
/32), AA
[    1.789030] ata8.00: configured for UDMA/133
[    1.789152] scsi 7:0:0:0: Direct-Access     ATA      WDC WD20EARX-00P =
51.0 PQ: 0 ANSI: 5
[    1.789597] sd 1:0:0:0: [sda] 390721968 512-byte logical blocks: (200 =
GB/186 GiB)
[    1.789665] sd 6:0:0:0: [sdb] 500118192 512-byte logical blocks: (256 =
GB/238 GiB)
[    1.789671] sd 7:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.0=
0 TB/1.81 TiB)
[    1.789671] sd 7:0:0:0: [sdc] 4096-byte physical blocks
[    1.789687] sd 1:0:0:0: [sda] Write Protect is off
[    1.789688] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.789694] sd 7:0:0:0: [sdc] Write Protect is off
[    1.789695] sd 7:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.789697] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    1.789704] sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    1.790242] sd 6:0:0:0: [sdb] Write Protect is off
[    1.790303] sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.790370] sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    1.791877]  sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 >
[    1.792134] sd 6:0:0:0: [sdb] Attached SCSI disk
[    1.796656] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form=
2 cdda tray
[    1.796756] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.796872] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    1.801541] usb 2-1.6: new high-speed USB device number 3 using ehci_h=
cd
[    1.843795]  sdc: sdc1 sdc2
[    1.844024] sd 7:0:0:0: [sdc] Attached SCSI disk
[    1.846330]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 > sda3
[    1.846648] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.893529] usb 2-1.6: New USB device found, idVendor=3D0424, idProduc=
t=3D2514
[    1.893613] usb 2-1.6: New USB device strings: Mfr=3D0, Product=3D0, S=
erialNumber=3D0
[    1.893915] hub 2-1.6:1.0: USB hub found
[    1.894020] hub 2-1.6:1.0: 3 ports detected
[    1.965076] usb 2-1.7: new low-speed USB device number 4 using ehci_hc=
d
[    2.061920] usb 2-1.7: New USB device found, idVendor=3D046d, idProduc=
t=3Dc01d
[    2.062002] usb 2-1.7: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D0
[    2.062066] usb 2-1.7: Product: USB-PS/2 Optical Mouse
[    2.062122] usb 2-1.7: Manufacturer: Logitech
[    2.067218] usbcore: registered new interface driver usbhid
[    2.067284] usbhid: USB HID core driver
[    2.132595] usb 2-1.8: new low-speed USB device number 5 using ehci_hc=
d
[    2.229689] usb 2-1.8: New USB device found, idVendor=3D046d, idProduc=
t=3Dc31d
[    2.229769] usb 2-1.8: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D0
[    2.229829] usb 2-1.8: Product: USB Keyboard
[    2.229884] usb 2-1.8: Manufacturer: Logitech
[    2.312082] usb 2-1.6.1: new high-speed USB device number 6 using ehci=
_hcd
[    2.404060] usb 2-1.6.1: New USB device found, idVendor=3D0424, idProd=
uct=3D2640
[    2.404119] usb 2-1.6.1: New USB device strings: Mfr=3D0, Product=3D0,=
 SerialNumber=3D0
[    2.404338] hub 2-1.6.1:1.0: USB hub found
[    2.404434] hub 2-1.6.1:1.0: 3 ports detected
[    2.408258] device-mapper: uevent: version 1.0.3
[    2.408342] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialise=
d: dm-devel@redhat.com
[    2.541479] Btrfs loaded
[    2.629374] device fsid 5c6276a1-4ed4-440b-a88c-ef31ff30b9db devid 1 t=
ransid 763 /dev/sdc2
[    2.675042] usb 2-1.6.1.1: new high-speed USB device number 7 using eh=
ci_hcd
[    2.760863] device fsid c73f5cf7-d9f8-49e6-a734-218222a1b737 devid 1 t=
ransid 22818 /dev/dm-0
[    2.762114] PM: Starting manual resume from disk
[    2.762177] PM: Hibernation image partition 8:8 present
[    2.762232] PM: Looking for hibernation image.
[    2.762496] PM: Image not found (code -22)
[    2.762571] PM: Hibernation image not present or could not be loaded.
[    2.763700] device fsid c73f5cf7-d9f8-49e6-a734-218222a1b737 devid 1 t=
ransid 22818 /dev/mapper/debian-root
[    2.763997] btrfs: disk space caching is enabled
[    2.765532] btrfs: bdev /dev/mapper/debian-root errs: wr 0, rd 0, flus=
h 0, corrupt 0, gen 0
[    2.770637] Btrfs detected SSD devices, enabling SSD mode
[    2.825483] usb 2-1.6.1.1: New USB device found, idVendor=3D0424, idPr=
oduct=3D4060
[    2.825562] usb 2-1.6.1.1: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D3
[    2.825621] usb 2-1.6.1.1: Product: Ultra Fast Media Reader
[    2.825668] usb 2-1.6.1.1: Manufacturer: Generic
[    2.825715] usb 2-1.6.1.1: SerialNumber: F120A6009E13
[    2.925816] udevd[419]: starting version 175
[    2.978303] ACPI: Requesting acpi_cpufreq
[    2.979768] mei 0000:00:16.0: setting latency timer to 64
[    2.979874] mei 0000:00:16.0: irq 48 for MSI/MSI-X
[    2.983736] ACPI Warning: 0x0000000000000460-0x000000000000047f System=
IO conflicts with Region \PMIO 1 (20120320/utaddress-251)
[    2.983795] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[    2.983875] lpc_ich: Resource conflict(s) found affecting iTCO_wdt
[    2.984016] ACPI Warning: 0x0000000000000428-0x000000000000042f System=
IO conflicts with Region \PMIO 1 (20120320/utaddress-251)
[    2.984100] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[    2.984169] ACPI Warning: 0x0000000000000500-0x000000000000053f System=
IO conflicts with Region \GPR2 1 (20120320/utaddress-251)
[    2.984251] ACPI Warning: 0x0000000000000500-0x000000000000053f System=
IO conflicts with Region \GPIO 2 (20120320/utaddress-251)
[    2.984334] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[    2.984399] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    2.988617] mei 0000:00:16.0: wd: failed to find the client
[    2.989471] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0=
C0C:00/input/input0
[    2.989537] ACPI: Power Button [PWRB]
[    2.990434] input: PC Speaker as /devices/platform/pcspkr/input/input1=

[    2.990572] ACPI Warning: 0x000000000000f040-0x000000000000f05f System=
IO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120320/utaddress-251)
[    2.990637] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[    2.994986] [drm] Initialized drm 1.1.0 20060810
[    3.005507] [drm] radeon kernel modesetting enabled.
[    3.005680] [drm] initializing kernel modesetting (PITCAIRN 0x1002:0x6=
819 0x174B:0xE218).
[    3.005769] [drm] register mmio base: 0xF7D00000
[    3.005823] [drm] register mmio size: 262144
[    3.005950] ATOM BIOS: C40304
[    3.006772] radeon 0000:01:00.0: VRAM: 2048M 0x0000000000000000 - 0x00=
0000007FFFFFFF (2048M used)
[    3.006841] radeon 0000:01:00.0: GTT: 512M 0x0000000080000000 - 0x0000=
00009FFFFFFF
[    3.006905] mtrr: type mismatch for e0000000,10000000 old: write-back =
new: write-combining
[    3.006969] [drm] Detected VRAM RAM=3D2048M, BAR=3D256M
[    3.007019] [drm] RAM width 256bits DDR
[    3.007720] [TTM] Zone  kernel: Available graphics memory: 8182494 kiB=

[    3.007778] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB=

[    3.007835] [TTM] Initializing pool allocator
[    3.007908] [TTM] Initializing DMA pool allocator
[    3.007980] [drm] radeon: 2048M of VRAM memory ready
[    3.008037] [drm] radeon: 512M of GTT memory ready.
[    3.008074] Monitor-Mwait will be used to enter C-1 state
[    3.008172] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010)=
=2E
[    3.008227] [drm] Driver supports precise vblank timestamp query.
[    3.008306] radeon 0000:01:00.0: irq 49 for MSI/MSI-X
[    3.008372] radeon 0000:01:00.0: radeon: using MSI.
[    3.008454] [drm] radeon: irq initialized.
[    3.008510] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    3.008771] [drm] Loading PITCAIRN Microcode
[    3.008989] Monitor-Mwait will be used to enter C-2 state
[    3.009821] Monitor-Mwait will be used to enter C-3 state
[    3.009833] ACPI: acpi_idle registered with cpuidle
[    3.012184] microcode: CPU0 sig=3D0x306a9, pf=3D0x2, revision=3D0x12
[    3.014869] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000=
:00/0000:00:1d.0/usb2/2-1/2-1.7/2-1.7:1.0/input/input2
[    3.015099] hid-generic 0003:046D:C01D.0001: input,hidraw0: USB HID v1=
=2E10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1.7/inp=
ut0
[    3.015384] input: Logitech USB Keyboard as /devices/pci0000:00/0000:0=
0:1d.0/usb2/2-1/2-1.8/2-1.8:1.0/input/input3
[    3.015478] hid-generic 0003:046D:C31D.0002: input,hidraw1: USB HID v1=
=2E10 Keyboard [Logitech USB Keyboard] on usb-0000:00:1d.0-1.8/input0
[    3.017214] input: Logitech USB Keyboard as /devices/pci0000:00/0000:0=
0:1d.0/usb2/2-1/2-1.8/2-1.8:1.1/input/input4
[    3.017351] hid-generic 0003:046D:C31D.0003: input,hidraw2: USB HID v1=
=2E10 Device [Logitech USB Keyboard] on usb-0000:00:1d.0-1.8/input1
[    3.019597] Linux media interface: v0.10
[    3.021993] Linux video capture interface: v2.00
[    3.022997] acpi device:43: registered as cooling_device3
[    3.023147] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post:=
 no)
[    3.023232] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08=
:00/LNXVIDEO:00/input/input5
[    3.025056] usbcore: registered new interface driver uas
[    3.027487] Initializing USB Mass Storage driver...
[    3.028199] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input6
[    3.028263] ACPI: Power Button [PWRF]
[    3.028356] uvcvideo: Found UVC 1.00 device HD Webcam C525 (046d:0826)=

[    3.028487] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
[    3.028732] scsi8 : usb-storage 2-1.6.1.1:1.0
[    3.028850] usbcore: registered new interface driver usb-storage
[    3.028905] USB Mass Storage support registered.
[    3.035135] microcode: CPU1 sig=3D0x306a9, pf=3D0x2, revision=3D0x12
[    3.038197] microcode: CPU2 sig=3D0x306a9, pf=3D0x2, revision=3D0x12
[    3.040199] input: HD Webcam C525 as /devices/pci0000:00/0000:00:14.0/=
usb3/3-2/3-2:1.2/input/input7
[    3.040336] microcode: CPU3 sig=3D0x306a9, pf=3D0x2, revision=3D0x12
[    3.040370] usbcore: registered new interface driver uvcvideo
[    3.040371] USB Video Class driver (1.1.1)
[    3.041035] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    3.041867] microcode: Microcode Update Driver: v2.00 <tigran@aivazian=
=2Efsnet.co.uk>, Peter Oruba
[    3.068937] usbcore: registered new interface driver snd-usb-audio
[    3.432198] [drm] PCIE GART of 512M enabled (table at 0x00000000000400=
00).
[    3.432353] radeon 0000:01:00.0: WB enabled
[    3.432419] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0=
x0000000080000c00 and cpu addr 0xffff8804160eac00
[    3.432492] radeon 0000:01:00.0: fence driver on ring 1 use gpu addr 0=
x0000000080000c04 and cpu addr 0xffff8804160eac04
[    3.432582] radeon 0000:01:00.0: fence driver on ring 2 use gpu addr 0=
x0000000080000c08 and cpu addr 0xffff8804160eac08
[    3.451440] [drm] ring test on 0 succeeded in 4 usecs
[    3.451500] [drm] ring test on 1 succeeded in 1 usecs
[    3.451562] [drm] ring test on 2 succeeded in 1 usecs
[    3.451782] [drm] ib test on ring 0 succeeded in 0 usecs
[    3.451878] [drm] ib test on ring 1 succeeded in 0 usecs
[    3.451975] [drm] ib test on ring 2 succeeded in 0 usecs
[    3.456843] [drm] Radeon Display Connectors
[    3.456906] [drm] Connector 0:
[    3.456961] [drm]   DP-1
[    3.457014] [drm]   HPD4
[    3.457071] [drm]   DDC: 0x6530 0x6530 0x6534 0x6534 0x6538 0x6538 0x6=
53c 0x653c
[    3.457133] [drm]   Encoders:
[    3.457193] [drm]     DFP1: INTERNAL_UNIPHY2
[    3.457253] [drm] Connector 1:
[    3.457311] [drm]   DP-2
[    3.457364] [drm]   HPD5
[    3.457416] [drm]   DDC: 0x6540 0x6540 0x6544 0x6544 0x6548 0x6548 0x6=
54c 0x654c
[    3.457490] [drm]   Encoders:
[    3.457546] [drm]     DFP2: INTERNAL_UNIPHY2
[    3.457600] [drm] Connector 2:
[    3.457663] [drm]   HDMI-A-1
[    3.457718] [drm]   HPD1
[    3.457771] [drm]   DDC: 0x6550 0x6550 0x6554 0x6554 0x6558 0x6558 0x6=
55c 0x655c
[    3.457831] [drm]   Encoders:
[    3.457890] [drm]     DFP3: INTERNAL_UNIPHY1
[    3.457944] [drm] Connector 3:
[    3.457997] [drm]   DVI-I-1
[    3.458052] [drm]   HPD6
[    3.458113] [drm]   DDC: 0x6580 0x6580 0x6584 0x6584 0x6588 0x6588 0x6=
58c 0x658c
[    3.458177] [drm]   Encoders:
[    3.458232] [drm]     DFP4: INTERNAL_UNIPHY
[    3.458288] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    3.458720] [drm] Internal thermal controller with fan control
[    3.459944] [drm] radeon: power management initialized
[    3.513665] [drm] fb mappable at 0xE0943000
[    3.513730] [drm] vram apper at 0xE0000000
[    3.513792] [drm] size 9216000
[    3.513853] [drm] fb depth is 24
[    3.513914] [drm]    pitch is 7680
[    3.514109] fbcon: radeondrmfb (fb0) is primary device
[    3.555243] Console: switching to colour frame buffer device 240x75
[    3.559752] fb0: radeondrmfb frame buffer device
[    3.559767] drm: registered panic notifier
[    3.559783] [drm] Initialized radeon 2.17.0 20080528 for 0000:01:00.0 =
on minor 0
[    3.586730] input: HDA Intel PCH HDMI/DP,pcm=3D7 as /devices/pci0000:0=
0/0000:00:1b.0/sound/card0/input8
[    3.586842] input: HDA Intel PCH HDMI/DP,pcm=3D3 as /devices/pci0000:0=
0/0000:00:1b.0/sound/card0/input9
[    3.586993] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1=
b.0/sound/card0/input10
[    3.587150] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:=
00:1b.0/sound/card0/input11
[    3.587306] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input12
[    3.587465] input: HDA Intel PCH Line Out Surround as /devices/pci0000=
:00/0000:00:1b.0/sound/card0/input13
[    3.587617] input: HDA Intel PCH Line Out Front as /devices/pci0000:00=
/0000:00:1b.0/sound/card0/input14
[    3.588037] hda-intel: 0000:01:00.1: Handle VGA-switcheroo audio clien=
t
[    3.588069] hda-intel: Force to non-snoop mode
[    3.588135] snd_hda_intel 0000:01:00.1: irq 51 for MSI/MSI-X
[    4.034319] scsi 8:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  =
1.82 PQ: 0 ANSI: 0
[    4.050885] sd 8:0:0:0: [sdd] Attached SCSI removable disk
[    4.103889] input: HDA ATI HDMI HDMI/DP,pcm=3D11 as /devices/pci0000:0=
0/0000:00:01.0/0000:01:00.1/sound/card2/input15
[    4.103974] input: HDA ATI HDMI HDMI/DP,pcm=3D10 as /devices/pci0000:0=
0/0000:00:01.0/0000:01:00.1/sound/card2/input16
[    4.104112] input: HDA ATI HDMI HDMI/DP,pcm=3D9 as /devices/pci0000:00=
/0000:00:01.0/0000:01:00.1/sound/card2/input17
[    4.104660] input: HDA ATI HDMI HDMI/DP,pcm=3D8 as /devices/pci0000:00=
/0000:00:01.0/0000:01:00.1/sound/card2/input18
[    4.104740] input: HDA ATI HDMI HDMI/DP,pcm=3D7 as /devices/pci0000:00=
/0000:00:01.0/0000:01:00.1/sound/card2/input19
[    4.104830] input: HDA ATI HDMI HDMI/DP,pcm=3D3 as /devices/pci0000:00=
/0000:00:01.0/0000:01:00.1/sound/card2/input20
[    5.045700] btrfs: disk space caching is enabled
[    5.060167] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 1 ep 0 with=
 no TDs queued?
[    5.242586] btrfs: disk space caching is enabled
[    5.275049] btrfs: unlinked 18 orphans
[    5.290400] loop: module loaded
[    5.297903] netpoll: netconsole: local port 6666
[    5.297925] netpoll: netconsole: local IP 192.168.100.102
[    5.297943] netpoll: netconsole: interface 'eth0'
[    5.297959] netpoll: netconsole: remote port 6666
[    5.297975] netpoll: netconsole: remote IP 192.168.100.1
[    5.297994] netpoll: netconsole: remote ethernet address 00:00:e8:3f:3=
3:5d
[    5.298017] netpoll: netconsole: device eth0 not up yet, forcing it
[    5.400085] r8169 0000:05:00.0: eth0: link down
[    5.400916] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    5.401513] r8169 0000:05:00.0: eth0: link down
[    7.392668] r8169 0000:05:00.0: eth0: link up
[    7.394447] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    7.401640] console [netcon0] enabled
[    7.403820] netconsole: network logging started
[    7.415867] tun: Universal TUN/TAP device driver, 1.6
[    7.418112] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    7.434261] Adding 3903484k swap on /dev/mapper/debian-swap.  Priority=
:-1 extents:1 across:3903484k SS
[    7.481805] Adding 4883724k swap on /dev/sda8.  Priority:-2 extents:1 =
across:4883724k=20
[    7.727848] EXT4-fs (sdb5): mounted filesystem with ordered data mode.=
 Opts: (null)
[    7.730763] device fsid d5a66763-5c4f-4431-8126-5860a618d576 devid 1 t=
ransid 6895 /dev/mapper/debian-home
[    7.733708] btrfs: disk space caching is enabled
[    7.737959] btrfs: bdev /dev/mapper/debian-home errs: wr 0, rd 0, flus=
h 0, corrupt 0, gen 0
[    7.748558] Btrfs detected SSD devices, enabling SSD mode
[    7.765748] ------------[ cut here ]------------
[    7.768309] kernel BUG at fs/btrfs/inode.c:3758!
[    7.770865] invalid opcode: 0000 [#1] SMP=20
[    7.773432] CPU 1=20
[    7.776036] Modules linked in: ext4 crc16 jbd2 mbcache vhost_net tun m=
acvtap macvlan netconsole configfs loop snd_hda_codec_hdmi snd_hda_codec_=
realtek coretemp kvm_intel kvm snd_usb_audio crc32c_intel snd_usbmidi_lib=
 snd_seq_midi ghash_clmulni_intel snd_seq_midi_event snd_rawmidi aesni_in=
tel joydev evdev aes_x86_64 aes_generic snd_hda_intel uvcvideo cryptd acp=
i_cpufreq usb_storage snd_hda_codec uas videobuf2_vmalloc snd_hwdep snd_p=
cm videobuf2_memops videobuf2_core snd_page_alloc videodev snd_seq snd_se=
q_device media snd_timer hid_generic mperf psmouse video microcode snd ra=
deon ttm drm_kms_helper drm i2c_i801 pcspkr i2c_algo_bit button i2c_core =
serio_raw soundcore lpc_ich mei mfd_core processor thermal_sys btrfs crc3=
2c libcrc32c zlib_deflate dm_mod usbhid hid sr_mod sd_mod cdrom crc_t10di=
f xhci_hcd r8169 ahci libahci mii ehci_hcd libata scsi_mod usbcore usb_co=
mmon [last unloaded: scsi_wait_scan]
[    7.787771]=20
[    7.790804] Pid: 1864, comm: mount Not tainted 3.5.0-rc4-custom-1 #2 T=
o Be Filled By O.E.M. To Be Filled By O.E.M./H77 Pro4/MVP
[    7.793943] RIP: 0010:[<ffffffffa017c720>]  [<ffffffffa017c720>] btrfs=
_evict_inode+0xc0/0x266 [btrfs]
[    7.797105] RSP: 0018:ffff880417ca1a58  EFLAGS: 00010246
[    7.800249] RAX: 0000000000000000 RBX: ffff880417d92000 RCX: 000000000=
000001a
[    7.803405] RDX: 000000000000001a RSI: ffffffffffffffff RDI: ffff88041=
51588f0
[    7.806545] RBP: ffff8804151589b0 R08: ffff880417ca1978 R09: 000000000=
0000002
[    7.809681] R10: ffff880417ca1880 R11: 0000000000000001 R12: ffffffffa=
01bc230
[    7.812813] R13: 0000000000001000 R14: 0000000000001000 R15: ffff88041=
770a000
[    7.815915] FS:  00007fc41ab767e0(0000) GS:ffff88042f280000(0000) knlG=
S:0000000000000000
[    7.819037] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.822155] CR2: 00007ff2902e8670 CR3: 0000000417cd9000 CR4: 000000000=
01407e0
[    7.825274] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
[    7.828375] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
[    7.831427] Process mount (pid: 1864, threadinfo ffff880417ca0000, tas=
k ffff880417d1f510)
[    7.834526] Stack:
[    7.837591]  ffff8804153f4fa0 ffff880415158a38 ffff8804151589b0 ffff88=
04151589b0
[    7.840733]  ffff880415158ab0 ffffffffa01bc230 ffff8804151589b0 ffff88=
0417d92400
[    7.843886]  ffff88041770a000 ffffffff811143d0 ffff8804152f0e20 ffff88=
0417d92000
[    7.847052] Call Trace:
[    7.850167]  [<ffffffff811143d0>] ? evict+0xa3/0x153
[    7.853311]  [<ffffffffa01a29f9>] ? fixup_inode_link_counts+0xd2/0xfb =
[btrfs]
[    7.856474]  [<ffffffffa0170b7d>] ? btrfs_read_fs_root_no_radix+0x170/=
0x1af [btrfs]
[    7.859647]  [<ffffffffa01a3b0b>] ? btrfs_recover_log_trees+0x207/0x2d=
d [btrfs]
[    7.862829]  [<ffffffffa01a253e>] ? replay_one_extent+0x439/0x439 [btr=
fs]
[    7.866009]  [<ffffffffa0172dd6>] ? open_ctree+0x137d/0x16cb [btrfs]
[    7.869162]  [<ffffffff811b458c>] ? ida_get_new_above+0x16c/0x17d
[    7.872298]  [<ffffffffa0156d83>] ? btrfs_mount+0x383/0x4b3 [btrfs]
[    7.875401]  [<ffffffff810d3f51>] ? pcpu_next_pop+0x36/0x43
[    7.878514]  [<ffffffff810f37bc>] ? __kmalloc_track_caller+0xd8/0xea
[    7.881632]  [<ffffffff811044d3>] ? mount_fs+0x61/0x146
[    7.884748]  [<ffffffff81116f7d>] ? vfs_kern_mount+0x62/0xe3
[    7.887868]  [<ffffffff81117484>] ? do_kern_mount+0x49/0xdd
[    7.890979]  [<ffffffff81118c69>] ? do_mount+0x68a/0x710
[    7.894091]  [<ffffffff810d0ffe>] ? memdup_user+0x36/0x5b
[    7.897208]  [<ffffffff81118e0f>] ? sys_mount+0x80/0xba
[    7.900330]  [<ffffffff813683fd>] ? system_call_fastpath+0x1a/0x1f
[    7.903498] Code: 00 48 83 ca ff 31 f6 48 89 ef e8 3d 05 01 00 48 8b 8=
3 20 01 00 00 83 b8 50 0e 00 00 00 74 0e 48 8b 45 98 a8 20 0f 85 7b 01 00=
 00 <0f> 0b 83 7d 48 00 74 0f 83 bb f8 00 00 00 00 0f 84 66 01 00 00=20
[    7.906842] RIP  [<ffffffffa017c720>] btrfs_evict_inode+0xc0/0x266 [bt=
rfs]
[    7.910186]  RSP <ffff880417ca1a58>
[    7.913561] ---[ end trace 86ad814028ba0f01 ]---
[    8.198413] RPC: Registered named UNIX socket transport module.
[    8.201762] RPC: Registered udp transport module.
[    8.205122] RPC: Registered tcp transport module.
[    8.208454] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    8.216518] FS-Cache: Loaded
[    8.228280] NFS: Registering the id_resolver key type
[    8.231512] Key type id_resolver registered
[    8.234708] FS-Cache: Netfs 'nfs' registered for caching
[    8.243616] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    8.921310] Bluetooth: Core ver 2.16
[    8.922581] NET: Registered protocol family 31
[    8.923812] Bluetooth: HCI device and connection manager initialized
[    8.925160] Bluetooth: HCI socket layer initialized
[    8.925160] Bluetooth: L2CAP socket layer initialized
[    8.925163] Bluetooth: SCO socket layer initialized
[    8.929695] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    8.929695] Bluetooth: BNEP filters: protocol multicast
[    8.933240] Bluetooth: RFCOMM TTY layer initialized
[    8.934560] Bluetooth: RFCOMM socket layer initialized
[    8.935733] Bluetooth: RFCOMM ver 1.11
[    8.950078] lp: driver loaded but no devices found
[    8.957775] ppdev: user-space parallel port driver
[    9.066073] Bridge firewalling registered
[    9.100639] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.142348] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    9.162829] IPv6: ADDRCONF(NETDEV_UP): virbr0: link is not ready
[    9.415353] Ebtables v2.0 registered
[    9.427516] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   18.836740] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 1 ep 14 wit=
h no TDs queued?
[   18.836752] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 1 ep 0 with=
 no TDs queued?
[  102.958760] usb 2-1.6: USB disconnect, device number 3
[  102.958771] usb 2-1.6.1: USB disconnect, device number 6
[  102.958775] usb 2-1.6.1.1: USB disconnect, device number 7
[  109.601403] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 1 ep 14 wit=
h no TDs queued?
[  109.601415] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 1 ep 0 with=
 no TDs queued?
[  110.303460] usb 2-1.6: new high-speed USB device number 8 using ehci_h=
cd
[  110.395444] usb 2-1.6: New USB device found, idVendor=3D0424, idProduc=
t=3D2514
[  110.395453] usb 2-1.6: New USB device strings: Mfr=3D0, Product=3D0, S=
erialNumber=3D0
[  110.395864] hub 2-1.6:1.0: USB hub found
[  110.396057] hub 2-1.6:1.0: 3 ports detected
[  110.666419] usb 2-1.6.1: new high-speed USB device number 9 using ehci=
_hcd
[  110.758404] usb 2-1.6.1: New USB device found, idVendor=3D0424, idProd=
uct=3D2640
[  110.758413] usb 2-1.6.1: New USB device strings: Mfr=3D0, Product=3D0,=
 SerialNumber=3D0
[  110.758696] hub 2-1.6.1:1.0: USB hub found
[  110.758891] hub 2-1.6.1:1.0: 3 ports detected
[  111.029380] usb 2-1.6.1.1: new high-speed USB device number 10 using e=
hci_hcd
[  111.179821] usb 2-1.6.1.1: New USB device found, idVendor=3D0424, idPr=
oduct=3D4060
[  111.179830] usb 2-1.6.1.1: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D3
[  111.179834] usb 2-1.6.1.1: Product: Ultra Fast Media Reader
[  111.179837] usb 2-1.6.1.1: Manufacturer: Generic
[  111.179840] usb 2-1.6.1.1: SerialNumber: F120A6009E13
[  111.180472] scsi9 : usb-storage 2-1.6.1.1:1.0
[  112.185365] scsi 9:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  =
1.82 PQ: 0 ANSI: 0
[  112.202431] sd 9:0:0:0: [sdd] Attached SCSI removable disk
[  118.587700] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 1 ep 14 wit=
h no TDs queued?
[  118.587714] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 1 ep 0 with=
 no TDs queued?
[  146.470750] device fsid d5a66763-5c4f-4431-8126-5860a618d576 devid 1 t=
ransid 6895 /dev/mapper/debian-home

--------------090304020309040106020503--
