From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: Oops while attempting to mount degraded multi-device raid1
	data/metadata btrfs filesystem
Date: Fri, 26 Mar 2010 10:49:57 -0700
Message-ID: <93cdabd21003261049h4a468bf6ubd7bb8be1ac68d41@mail.gmail.com>
References: <93cdabd21003051219m6238b1b8nd88ca7fc3724d67a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21003051219m6238b1b8nd88ca7fc3724d67a@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I still get this oops with the latest btrfs kernel code from git (as
of  2010-03-21) compiled against 2.6.32.9-70.fc12.x86_64

btrfs: failed to read the system array on sda7
btrfs: open_ctree failed
device fsid 3546a1a7a4563c4b-2b1289f58c64988c devid 1 transid 974 /dev/=
sda7
btrfs: allowing degraded mounts
Error searching slot for orphan: -5
BUG: sleeping function called from invalid context at arch/x86/mm/fault=
=2Ec:1071
in_atomic(): 0, irqs_disabled(): 1, pid: 15434, name: mount
Pid: 15434, comm: mount Not tainted 2.6.32.9-70.fc12.x86_64 #1
Call Trace:
 [<ffffffff81045d41>] __might_sleep+0xed/0xef
 [<ffffffff81458075>] do_page_fault+0x172/0x2a0
 [<ffffffff81456075>] page_fault+0x25/0x30
 [<ffffffff81455b61>] ? _spin_lock_irq+0x15/0x2c
 [<ffffffff814559f3>] __down_read+0x17/0xaa
 [<ffffffffa0159dac>] ? block_group_cache_tree_search+0x24/0x95 [btrfs]
 [<ffffffff81455121>] down_read+0x31/0x35
 [<ffffffffa015cf5b>] find_free_extent+0x2bb/0x828 [btrfs]
 [<ffffffff81454a51>] ? __wait_on_bit+0x69/0x7b
 [<ffffffff810748dc>] ? wake_bit_function+0x0/0x33
 [<ffffffffa015d6e0>] btrfs_reserve_extent+0xc8/0x17d [btrfs]
 [<ffffffffa01832d4>] ? test_range_bit+0x59/0xeb [btrfs]
 [<ffffffffa0161fae>] btrfs_alloc_free_block+0x5e/0x198 [btrfs]
 [<ffffffffa01563b4>] __btrfs_cow_block+0x103/0x30d [btrfs]
 [<ffffffffa01990fb>] ? btrfs_find_ref_cluster+0x35/0x145 [btrfs]
 [<ffffffffa015319f>] ? btrfs_header_generation+0x17/0x2c [btrfs]
 [<ffffffffa0156b1b>] btrfs_cow_block+0x101/0x110 [btrfs]
 [<ffffffffa016a4f3>] commit_cowonly_roots+0x59/0x198 [btrfs]
 [<ffffffff8106549a>] ? process_timeout+0x0/0x10
 [<ffffffffa016b78f>] btrfs_commit_transaction+0x36a/0x603 [btrfs]
 [<ffffffff810748a3>] ? autoremove_wake_function+0x0/0x39
 [<ffffffffa016af43>] ? start_transaction+0x122/0x12e [btrfs]
 [<ffffffffa0152c7d>] btrfs_sync_fs+0x65/0x69 [btrfs]
 [<ffffffff811676a8>] sync_quota_sb+0x53/0x101
 [<ffffffff8113e53f>] __sync_filesystem+0x46/0x77
 [<ffffffff8113e71d>] sync_filesystem+0x4b/0x4f
 [<ffffffff8111d6d9>] generic_shutdown_super+0x27/0xc9
 [<ffffffff8111d7d0>] kill_anon_super+0x16/0x4f
 [<ffffffff8111ded7>] deactivate_super+0x56/0x6b
 [<ffffffff81134262>] mntput_no_expire+0xb4/0xec
 [<ffffffff81134d59>] do_add_mount+0x107/0x117
 [<ffffffff811359e4>] do_mount+0x755/0x793
 [<ffffffff81104d77>] ? alloc_pages_current+0x95/0x9e
 [<ffffffff81135aaa>] sys_mount+0x88/0xc2
 [<ffffffff81011d32>] system_call_fastpath+0x16/0x1b
BUG: unable to handle kernel NULL pointer dereference at 00000000000000=
c4
IP: [<ffffffff81455b61>] _spin_lock_irq+0x15/0x2c
PGD 0
Oops: 0002 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
CPU 0
Modules linked in: fuse nls_utf8 cifs sunrpc cpufreq_ondemand
powernow_k8 freq_table ip6t_REJECT nf_conntrack_ipv6 ip6table_filter
ip6_tables ipv6 uinput arc4 ecb ath5k snd_hda_codec_realtek mac80211
sky2 snd_hda_intel snd_hda_codec ath snd_hwdep snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq ppdev k8temp i2c_nforce2
snd_seq_device snd_pcm_oss snd_mixer_oss parport_pc edac_core snd_pcm
parport snd_timer wmi snd soundcore joydev edac_mce_amd cfg80211
snd_page_alloc rfkill btrfs zlib_deflate libcrc32c dm_multipath
pata_acpi pata_artop firewire_ohci firewire_core crc_itu_t usb_storage
ata_generic pata_amd sata_nv radeon ttm drm_kms_helper drm
i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
Pid: 15434, comm: mount Not tainted 2.6.32.9-70.fc12.x86_64 #1
ASE380/AST180/APM8
RIP: 0010:[<ffffffff81455b61>]  [<ffffffff81455b61>] _spin_lock_irq+0x1=
5/0x2c
RSP: 0018:ffff88002f579858  EFLAGS: 00010082
RAX: 0000000000010000 RBX: 00000000000000c0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000015 RDI: 00000000000000c4
RBP: ffff88002f579858 R08: 0000000000000000 R09: ffffffffffffffff
R10: ffff8800056157b0 R11: ffff88002f579c78 R12: 00000000000000c0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
=46S:  00007feb33a9d7e0(0000) GS:ffff880005600000(0000) knlGS:00000000f=
66f67a0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000000c4 CR3: 000000002f7a9000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 15434, threadinfo ffff88002f578000, task ffff88001a=
759760)
Stack:
 ffff88002f579898 ffffffff814559f3 0000000000000000 0000000000002a7f
<0> ffff88002f5798a8 ffffffffa0159dac 00000000000000c0 ffff88003244a118
<0> ffff88002f5798b8 ffffffff81455121 ffff88002f5798b8 0000000000000000
Call Trace:
 [<ffffffff814559f3>] __down_read+0x17/0xaa
 [<ffffffffa0159dac>] ? block_group_cache_tree_search+0x24/0x95 [btrfs]
 [<ffffffff81455121>] down_read+0x31/0x35
 [<ffffffffa015cf5b>] find_free_extent+0x2bb/0x828 [btrfs]
 [<ffffffff81454a51>] ? __wait_on_bit+0x69/0x7b
 [<ffffffff810748dc>] ? wake_bit_function+0x0/0x33
 [<ffffffffa015d6e0>] btrfs_reserve_extent+0xc8/0x17d [btrfs]
 [<ffffffffa01832d4>] ? test_range_bit+0x59/0xeb [btrfs]
 [<ffffffffa0161fae>] btrfs_alloc_free_block+0x5e/0x198 [btrfs]
 [<ffffffffa01563b4>] __btrfs_cow_block+0x103/0x30d [btrfs]
 [<ffffffffa01990fb>] ? btrfs_find_ref_cluster+0x35/0x145 [btrfs]
 [<ffffffffa015319f>] ? btrfs_header_generation+0x17/0x2c [btrfs]
 [<ffffffffa0156b1b>] btrfs_cow_block+0x101/0x110 [btrfs]
 [<ffffffffa016a4f3>] commit_cowonly_roots+0x59/0x198 [btrfs]
 [<ffffffff8106549a>] ? process_timeout+0x0/0x10
 [<ffffffffa016b78f>] btrfs_commit_transaction+0x36a/0x603 [btrfs]
 [<ffffffff810748a3>] ? autoremove_wake_function+0x0/0x39
 [<ffffffffa016af43>] ? start_transaction+0x122/0x12e [btrfs]
 [<ffffffffa0152c7d>] btrfs_sync_fs+0x65/0x69 [btrfs]
 [<ffffffff811676a8>] sync_quota_sb+0x53/0x101
 [<ffffffff8113e53f>] __sync_filesystem+0x46/0x77
 [<ffffffff8113e71d>] sync_filesystem+0x4b/0x4f
 [<ffffffff8111d6d9>] generic_shutdown_super+0x27/0xc9
 [<ffffffff8111d7d0>] kill_anon_super+0x16/0x4f
 [<ffffffff8111ded7>] deactivate_super+0x56/0x6b
 [<ffffffff81134262>] mntput_no_expire+0xb4/0xec
 [<ffffffff81134d59>] do_add_mount+0x107/0x117
 [<ffffffff811359e4>] do_mount+0x755/0x793
 [<ffffffff81104d77>] ? alloc_pages_current+0x95/0x9e
 [<ffffffff81135aaa>] sys_mount+0x88/0xc2
 [<ffffffff81011d32>] system_call_fastpath+0x16/0x1b
Code: 0f b7 c8 c1 e8 10 39 c1 74 07 f3 90 0f b7 0f eb f5 48 89 d0 c9
c3 55 48 89 e5 0f 1f 44 00 00 fa 66 66 90 66 66 90 b8 00 00 01 00 <f0>
0f c1 07 0f b7 d0 c1 e8 10 39 c2 74 07 f3 90 0f b7 17 eb f5
RIP  [<ffffffff81455b61>] _spin_lock_irq+0x15/0x2c
 RSP <ffff88002f579858>
CR2: 00000000000000c4
---[ end trace bd703f7acdf6e999 ]---




On Fri, Mar 5, 2010 at 1:19 PM, Mike Fedyk <mfedyk@mikefedyk.com> wrote=
:
> Hi,
>
> I get an oops with 2.6.33-0.46.rc8.git1.fc13.x86_64 while trying to
> mount a degraded raid1 btrfs filesystem.
>
> Here are the steps I performed to get to this stage.
>
> - Install fedora12 btrfs / on sda2
> - mkfs.btrfs -m raid1 -d raid1 /dev/sda7
> - cp -a from sda2 to sda7
> - reboot into sda7 as /
> - btrfs-vol -a /dev/sda2 /
> - btrfs-vol -b / =C2=A0(system hangs here)
> - reboot (boot fails with ctree error) [1]
> - boot into fedora 12 recovery cd (based on 2.6.31). =C2=A0after runn=
ing
> btrfsctl -a, the filesystem is mountable.
> - umount
> - dd bs=3D1M count=3D2000 < /dev/zero > /dev/sda2
> - mount /dev/sda7, get oops (on 2.6.31)
> - install fedora12 btrfs / on sda2
> - update to 2.6.33-0.46.rc8.git1.fc13.x86_64
> - btrfsctl -a
> - mount /dev/sda7 (get oops below)
>
>
> 1. Turns out that fedora12 doesn't have a call to btrfsctl -a in the
> boot process. =C2=A0Working on a patch for that...
>
>
>
>
>
>
>
> Initializing cgroup subsys cpuset
> Initializing cgroup subsys cpu
> Linux version 2.6.33-0.46.rc8.git1.fc13.x86_64
> (mockbuild@x86-04.phx2.fedoraproject.org) (gcc version 4.4.3 20100211
> (Red Hat 4.4.3-6) (GCC) ) #1 SMP Tue Feb 16 19:47:00 UTC 2010
> Command line: ro root=3DUUID=3D7d23c60c-c072-431d-971a-87bcf61ac6a2
> LANG=3Den_US.UTF-8 SYSFONT=3Dlatarcyrheb-sun16 KEYBOARDTYPE=3Dpc KEYT=
ABLE=3Dus
> rhgb quiet
> BIOS-provided physical RAM map:
> =C2=A0BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
> =C2=A0BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
> =C2=A0BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> =C2=A0BIOS-e820: 0000000000100000 - 00000000afff0000 (usable)
> =C2=A0BIOS-e820: 00000000afff0000 - 00000000afff3000 (ACPI NVS)
> =C2=A0BIOS-e820: 00000000afff3000 - 00000000b0000000 (ACPI data)
> =C2=A0BIOS-e820: 00000000b0000000 - 00000000c0000000 (reserved)
> =C2=A0BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
> =C2=A0BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> =C2=A0BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
> NX (Execute Disable) protection: active
> DMI 2.3 present.
> Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
> e820 update range: 0000000000000000 - 0000000000010000 (usable) =3D=3D=
> (reserved)
> No AGP bridge found
> last_pfn =3D 0x140000 max_arch_pfn =3D 0x400000000
> MTRR default type: uncachable
> MTRR fixed ranges enabled:
> =C2=A000000-9FFFF write-back
> =C2=A0A0000-BFFFF uncachable
> =C2=A0C0000-C7FFF write-protect
> =C2=A0C8000-FFFFF uncachable
> MTRR variable ranges enabled:
> =C2=A00 base 0000000000 mask FF80000000 write-back
> =C2=A01 base 0080000000 mask FFC0000000 write-back
> =C2=A02 base 0100000000 mask FFC0000000 write-back
> =C2=A03 disabled
> =C2=A04 disabled
> =C2=A05 disabled
> =C2=A06 disabled
> =C2=A07 disabled
> TOM2: 0000000140000000 aka 5120M
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> e820 update range: 00000000c0000000 - 0000000100000000 (usable) =3D=3D=
> (reserved)
> last_pfn =3D 0xafff0 max_arch_pfn =3D 0x400000000
> initial memory mapped : 0 - 20000000
> found SMP MP-table at [ffff8800000f3c90] f3c90
> init_memory_mapping: 0000000000000000-00000000afff0000
> =C2=A00000000000 - 00afe00000 page 2M
> =C2=A000afe00000 - 00afff0000 page 4k
> kernel direct mapping tables up to afff0000 @ 16000-1b000
> init_memory_mapping: 0000000100000000-0000000140000000
> =C2=A00100000000 - 0140000000 page 2M
> kernel direct mapping tables up to 140000000 @ 19000-1f000
> RAMDISK: 37435000 - 37fefbfc
> ACPI: RSDP 00000000000f8370 00014 (v00 Nvidia)
> ACPI: RSDT 00000000afff3040 00038 (v01 Nvidia AWRDACPI 42302E31 AWRD =
00000000)
> ACPI: FACP 00000000afff30c0 00074 (v01 Nvidia AWRDACPI 42302E31 AWRD =
00000000)
> ACPI: DSDT 00000000afff3180 0631A (v01 NVIDIA AWRDACPI 00001000 MSFT =
0100000E)
> ACPI: FACS 00000000afff0000 00040
> ACPI: SSDT 00000000afff95c0 00248 (v01 PTLTD =C2=A0POWERNOW 00000001 =
=C2=A0LTP 00000001)
> ACPI: HPET 00000000afff9880 00038 (v01 Nvidia AWRDACPI 42302E31 AWRD =
00000098)
> ACPI: MCFG 00000000afff9900 0003C (v01 Nvidia AWRDACPI 42302E31 AWRD =
00000000)
> ACPI: APIC 00000000afff9500 0007C (v01 Nvidia AWRDACPI 42302E31 AWRD =
00000000)
> ACPI: Local APIC address 0xfee00000
> Scanning NUMA topology in Northbridge 24
> No NUMA configuration found
> Faking a node at 0000000000000000-0000000140000000
> Bootmem setup node 0 0000000000000000-0000000140000000
> =C2=A0NODE_DATA [000000000001a000 - 0000000000032fff]
> =C2=A0bootmap [0000000000033000 - =C2=A0000000000005afff] pages 28
> (13 early reservations) =3D=3D> bootmem [0000000000 - 0140000000]
> =C2=A0#0 [0000000000 - 0000001000] =C2=A0 BIOS data page =3D=3D> [000=
0000000 - 0000001000]
> =C2=A0#1 [0001000000 - 00029b9138] =C2=A0 =C2=A0TEXT DATA BSS =3D=3D>=
 [0001000000 - 00029b9138]
> =C2=A0#2 [0037435000 - 0037fefbfc] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
RAMDISK =3D=3D> [0037435000 - 0037fefbfc]
> =C2=A0#3 [00029ba000 - 00029ba0b9] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0BRK =3D=3D> [00029ba000 - 00029ba0b9]
> =C2=A0#4 [00000f3ca0 - 0000100000] =C2=A0 =C2=A0BIOS reserved =3D=3D>=
 [00000f3ca0 - 0000100000]
> =C2=A0#5 [00000f3c90 - 00000f3ca0] =C2=A0 =C2=A0 MP-table mpf =3D=3D>=
 [00000f3c90 - 00000f3ca0]
> =C2=A0#6 [000009f000 - 00000f1fe4] =C2=A0 =C2=A0BIOS reserved =3D=3D>=
 [000009f000 - 00000f1fe4]
> =C2=A0#7 [00000f2140 - 00000f3c90] =C2=A0 =C2=A0BIOS reserved =3D=3D>=
 [00000f2140 - 00000f3c90]
> =C2=A0#8 [00000f1fe4 - 00000f2140] =C2=A0 =C2=A0 MP-table mpc =3D=3D>=
 [00000f1fe4 - 00000f2140]
> =C2=A0#9 [0000010000 - 0000012000] =C2=A0 =C2=A0 =C2=A0 TRAMPOLINE =3D=
=3D> [0000010000 - 0000012000]
> =C2=A0#10 [0000012000 - 0000016000] =C2=A0 =C2=A0 =C2=A0ACPI WAKEUP =3D=
=3D> [0000012000 - 0000016000]
> =C2=A0#11 [0000016000 - 0000019000] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
PGTABLE =3D=3D> [0000016000 - 0000019000]
> =C2=A0#12 [0000019000 - 000001a000] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
PGTABLE =3D=3D> [0000019000 - 000001a000]
> =C2=A0[ffffea0000000000-ffffea00045fffff] PMD ->
> [ffff880002a00000-ffff880005ffffff] on node 0
> Zone PFN ranges:
> =C2=A0DMA =C2=A0 =C2=A0 =C2=A00x00000010 -> 0x00001000
> =C2=A0DMA32 =C2=A0 =C2=A00x00001000 -> 0x00100000
> =C2=A0Normal =C2=A0 0x00100000 -> 0x00140000
> Movable zone start PFN for each node
> early_node_map[3] active PFN ranges
> =C2=A0 =C2=A00: 0x00000010 -> 0x0000009f
> =C2=A0 =C2=A00: 0x00000100 -> 0x000afff0
> =C2=A0 =C2=A00: 0x00100000 -> 0x00140000
> On node 0 totalpages: 982911
> =C2=A0DMA zone: 56 pages used for memmap
> =C2=A0DMA zone: 106 pages reserved
> =C2=A0DMA zone: 3821 pages, LIFO batch:0
> =C2=A0DMA32 zone: 14280 pages used for memmap
> =C2=A0DMA32 zone: 702504 pages, LIFO batch:31
> =C2=A0Normal zone: 3584 pages used for memmap
> =C2=A0Normal zone: 258560 pages, LIFO batch:31
> Detected use of extended apic ids on hypertransport bus
> ACPI: PM-Timer IO Port: 0x1008
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> ACPI: IRQ14 used by override.
> ACPI: IRQ15 used by override.
> Using ACPI (MADT) for SMP configuration information
> ACPI: HPET id: 0x10de8201 base: 0xfeff0000
> SMP: Allowing 2 CPUs, 0 hotplug CPUs
> nr_irqs_gsi: 24
> PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
> PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
> PM: Registered nosave memory: 00000000afff0000 - 00000000afff3000
> PM: Registered nosave memory: 00000000afff3000 - 00000000b0000000
> PM: Registered nosave memory: 00000000b0000000 - 00000000c0000000
> PM: Registered nosave memory: 00000000c0000000 - 00000000f0000000
> PM: Registered nosave memory: 00000000f0000000 - 00000000f4000000
> PM: Registered nosave memory: 00000000f4000000 - 00000000fec00000
> PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
> Allocating PCI resources starting at c0000000 (gap: c0000000:30000000=
)
> Booting paravirtualized kernel on bare hardware
> setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_id=
s:1
> PERCPU: Embedded 478 pages/cpu @ffff880006200000 s1927384 r8192 d2231=
2 u2097152
> pcpu-alloc: s1927384 r8192 d22312 u2097152 alloc=3D1*2097152
> pcpu-alloc: [0] 0 [0] 1
> Built 1 zonelists in Node order, mobility grouping on. =C2=A0Total pa=
ges: 964885
> Policy zone: Normal
> Kernel command line: ro root=3DUUID=3D7d23c60c-c072-431d-971a-87bcf61=
ac6a2
> =C2=A0LANG=3Den_US.UTF-8 SYSFONT=3Dlatarcyrheb-sun16 KEYBOARDTYPE=3Dp=
c
> KEYTABLE=3Dus rhgb quiet
> PID hash table entries: 4096 (order: 3, 32768 bytes)
> Checking aperture...
> No AGP bridge found
> Node 0: aperture @ 4000000 size 32 MB
> Aperture pointing to e820 RAM. Ignoring.
> Your BIOS doesn't leave a aperture memory hole
> Please enable the IOMMU option in the BIOS setup
> This costs you 64 MB of RAM
> Mapping aperture over 65536 KB of RAM @ 20000000
> PM: Registered nosave memory: 0000000020000000 - 0000000024000000
> Memory: 3701504k/5242880k available (4608k kernel code, 1311236k
> absent, 230140k reserved, 7333k data, 2752k init)
> SLUB: Genslabs=3D14, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D=
2, Nodes=3D1
> Hierarchical RCU implementation.
> NR_IRQS:4352 nr_irqs:424
> spurious 8259A interrupt: IRQ7.
> Console: colour VGA+ 80x25
> console [tty0] enabled
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Mol=
nar
> ... MAX_LOCKDEP_SUBCLASSES: =C2=A08
> ... MAX_LOCK_DEPTH: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A048
> ... MAX_LOCKDEP_KEYS: =C2=A0 =C2=A0 =C2=A0 =C2=A08191
> ... CLASSHASH_SIZE: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A04096
> ... MAX_LOCKDEP_ENTRIES: =C2=A0 =C2=A0 16384
> ... MAX_LOCKDEP_CHAINS: =C2=A0 =C2=A0 =C2=A032768
> ... CHAINHASH_SIZE: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A016384
> =C2=A0memory used by lock dependency info: 6367 kB
> =C2=A0per task-struct memory footprint: 2688 bytes
> allocated 39321600 bytes of page_cgroup
> please try 'cgroup_disable=3Dmemory' option if you don't want memory =
cgroups
> ODEBUG: 11 of 11 active objects replaced
> hpet clockevent registered
> Fast TSC calibration using PIT
> Detected 2310.370 MHz processor.
> Calibrating delay loop (skipped), value calculated using timer
> frequency.. 4620.74 BogoMIPS (lpj=3D2310370)
> Security Framework initialized
> SELinux: =C2=A0Initializing.
> SELinux: =C2=A0Starting in permissive mode
> Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> Mount-cache hash table entries: 256
> Initializing cgroup subsys ns
> Initializing cgroup subsys cpuacct
> Initializing cgroup subsys memory
> Initializing cgroup subsys devices
> Initializing cgroup subsys freezer
> Initializing cgroup subsys net_cls
> Initializing cgroup subsys blkio
> tseg: 0000000000
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> mce: CPU supports 5 MCE banks
> using C1E aware idle routine
> Performance Events: AMD PMU driver.
> ... version: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00
> ... bit width: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A048
> ... generic registers: =C2=A0 =C2=A0 =C2=A04
> ... value mask: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0000fffffff=
fffff
> ... max period: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 00007ffffff=
fffff
> ... fixed-purpose events: =C2=A0 0
> ... event mask: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 00000000000=
0000f
> ACPI: Core revision 20091214
> ftrace: converting mcount calls to 0f 1f 44 00 00
> ftrace: allocating 21578 entries in 85 pages
> Setting APIC routing to flat
> ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
> CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ stepping 01
> lockdep: fixing up alternatives.
> Booting Node =C2=A0 0, Processors =C2=A0#1 Ok.
> Brought up 2 CPUs
> Total of 2 processors activated (9241.05 BogoMIPS).
> sizeof(vma)=3D176 bytes
> sizeof(page)=3D56 bytes
> sizeof(inode)=3D1168 bytes
> sizeof(dentry)=3D256 bytes
> sizeof(ext3inode)=3D1592 bytes
> sizeof(buffer_head)=3D104 bytes
> sizeof(skbuff)=3D232 bytes
> sizeof(task_struct)=3D9272 bytes
> devtmpfs: initialized
> regulator: core version 0.5
> Time: 22:31:18 =C2=A0Date: 03/03/10
> NET: Registered protocol family 16
> node 0 link 0: io port [7000, ffff]
> TOM: 00000000c0000000 aka 3072M
> node 0 link 0: mmio [a0000, bffff]
> node 0 link 0: mmio [c0000000, efffffff]
> node 0 link 0: mmio [f4000000, fe02ffff]
> node 0 link 0: mmio [f0000000, f03fffff]
> TOM2: 0000000140000000 aka 5120M
> bus: [00, 04] on node 0 link 0
> bus: 00 index 0 io port: [0, ffff]
> bus: 00 index 1 mmio: [a0000, bffff]
> bus: 00 index 2 mmio: [c0000000, f3ffffff]
> bus: 00 index 3 mmio: [f4000000, ffffffff]
> bus: 00 index 4 mmio: [140000000, fcffffffff]
> ACPI: bus type pci registered
> PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
> 0xf0000000-0xf3ffffff] (base 0xf0000000)
> PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
> ACPI: EC: Look up EC in DSDT
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: No dock devices found.
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot wit=
h
> "pci=3Duse_crs" to use them
> pci_root PNP0A08:00: host bridge window [io =C2=A00x0000-0x03af] (ign=
ored)
> pci_root PNP0A08:00: host bridge window [io =C2=A00x03e0-0x0cf7] (ign=
ored)
> pci_root PNP0A08:00: host bridge window [io =C2=A00x7000-0xffff] (ign=
ored)
> pci_root PNP0A08:00: host bridge window [io =C2=A00x03b0-0x03df] (ign=
ored)
> pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (=
ignored)
> pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xefffffff] (=
ignored)
> pci_root PNP0A08:00: host bridge window [mem 0xf4000000-0xfe02ffff] (=
ignored)
> pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff] (=
ignored)
> pci_root PNP0A08:00: host bridge window [io =C2=A00x4700-0x470b] (ign=
ored)
> pci_root PNP0A08:00: host bridge window [io =C2=A00x1c00-0x1c7e] inva=
lid;
> aligning end to 4-byte boundary
> pci_root PNP0A08:00: host bridge window [io =C2=A00x1c00-0x1c7f] (ign=
ored)
> pci_root PNP0A08:00: host bridge window [mem 0xfec80000-0xfecbffff] (=
ignored)
> pci 0000:00:01.1: reg 10: [io =C2=A00xfc00-0xfc3f]
> pci 0000:00:01.1: reg 20: [io =C2=A00x1c00-0x1c3f]
> pci 0000:00:01.1: reg 24: [io =C2=A00xf400-0xf43f]
> pci 0000:00:01.1: PME# supported from D3hot D3cold
> pci 0000:00:01.1: PME# disabled
> pci 0000:00:02.0: reg 10: [mem 0xfe02f000-0xfe02ffff]
> pci 0000:00:02.0: supports D1 D2
> pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:02.0: PME# disabled
> pci 0000:00:02.1: reg 10: [mem 0xfe02e000-0xfe02e0ff]
> pci 0000:00:02.1: supports D1 D2
> pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:02.1: PME# disabled
> pci 0000:00:05.0: reg 10: [mem 0xfe028000-0xfe02bfff]
> pci 0000:00:05.0: PME# supported from D3hot D3cold
> pci 0000:00:05.0: PME# disabled
> pci 0000:00:06.0: reg 20: [io =C2=A00xf000-0xf00f]
> pci 0000:00:08.0: reg 10: [io =C2=A00x09f0-0x09f7]
> pci 0000:00:08.0: reg 14: [io =C2=A00x0bf0-0x0bf3]
> pci 0000:00:08.0: reg 18: [io =C2=A00x0970-0x0977]
> pci 0000:00:08.0: reg 1c: [io =C2=A00x0b70-0x0b73]
> pci 0000:00:08.0: reg 20: [io =C2=A00xdc00-0xdc0f]
> pci 0000:00:08.0: reg 24: [mem 0xfe02d000-0xfe02dfff]
> pci 0000:00:08.1: reg 10: [io =C2=A00x09e0-0x09e7]
> pci 0000:00:08.1: reg 14: [io =C2=A00x0be0-0x0be3]
> pci 0000:00:08.1: reg 18: [io =C2=A00x0960-0x0967]
> pci 0000:00:08.1: reg 1c: [io =C2=A00x0b60-0x0b63]
> pci 0000:00:08.1: reg 20: [io =C2=A00xc800-0xc80f]
> pci 0000:00:08.1: reg 24: [mem 0xfe02c000-0xfe02cfff]
> pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:09.0: PME# disabled
> pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:0b.0: PME# disabled
> pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:0c.0: PME# disabled
> pci 0000:00:0d.0: reg 10: [mem 0xfb000000-0xfbffffff]
> pci 0000:00:0d.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
> pci 0000:00:0d.0: reg 1c: [mem 0xfc000000-0xfcffffff 64bit]
> pci 0000:00:0d.0: reg 30: [mem 0x00000000-0x0001ffff pref]
> pci 0000:01:05.0: reg 10: [mem 0xfdfe0000-0xfdfeffff]
> pci 0000:01:06.0: reg 10: [io =C2=A00xbc00-0xbc07]
> pci 0000:01:06.0: reg 14: [io =C2=A00xb800-0xb803]
> pci 0000:01:06.0: reg 18: [io =C2=A00xb400-0xb407]
> pci 0000:01:06.0: reg 1c: [io =C2=A00xb000-0xb003]
> pci 0000:01:06.0: reg 20: [io =C2=A00xac00-0xac0f]
> pci 0000:01:06.0: reg 30: [mem 0x00000000-0x0000ffff pref]
> pci 0000:01:09.0: reg 10: [mem 0xfdfff000-0xfdfff7ff]
> pci 0000:01:09.0: reg 14: [mem 0xfdff8000-0xfdffbfff]
> pci 0000:01:09.0: supports D1 D2
> pci 0000:01:09.0: PME# supported from D0 D1 D2 D3hot
> pci 0000:01:09.0: PME# disabled
> pci 0000:00:04.0: PCI bridge to [bus 01-01] (subtractive decode)
> pci 0000:00:04.0: =C2=A0 bridge window [io =C2=A00xa000-0xbfff]
> pci 0000:00:04.0: =C2=A0 bridge window [mem 0xfdf00000-0xfdffffff]
> pci 0000:00:04.0: =C2=A0 bridge window [mem 0xfd800000-0xfd8fffff pre=
f]
> pci 0000:00:09.0: PCI bridge to [bus 02-02]
> pci 0000:00:09.0: =C2=A0 bridge window [io =C2=A00x9000-0x9fff]
> pci 0000:00:09.0: =C2=A0 bridge window [mem 0xfde00000-0xfdefffff]
> pci 0000:00:09.0: =C2=A0 bridge window [mem 0xfdd00000-0xfddfffff 64b=
it pref]
> pci 0000:03:00.0: reg 10: [mem 0xfdcfc000-0xfdcfffff 64bit]
> pci 0000:03:00.0: reg 18: [io =C2=A00x8c00-0x8cff]
> pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
> pci 0000:03:00.0: supports D1 D2
> pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:03:00.0: PME# disabled
> pci 0000:00:0b.0: PCI bridge to [bus 03-03]
> pci 0000:00:0b.0: =C2=A0 bridge window [io =C2=A00x8000-0x8fff]
> pci 0000:00:0b.0: =C2=A0 bridge window [mem 0xfdc00000-0xfdcfffff]
> pci 0000:00:0b.0: =C2=A0 bridge window [mem 0xfdb00000-0xfdbfffff 64b=
it pref]
> pci 0000:00:0c.0: PCI bridge to [bus 04-04]
> pci 0000:00:0c.0: =C2=A0 bridge window [io =C2=A00x7000-0x7fff]
> pci 0000:00:0c.0: =C2=A0 bridge window [mem 0xfda00000-0xfdafffff]
> pci 0000:00:0c.0: =C2=A0 bridge window [mem 0xfd900000-0xfd9fffff 64b=
it pref]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
> ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 *11 14 15)
> ACPI: PCI Interrupt Link [LNK2] (IRQs *5 7 9 10 11 14 15)
> ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled=
=2E
> ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 *10 11 14 15)
> ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled=
=2E
> ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 *10 11 14 15)
> ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 11 14 15) *0, disabled=
=2E
> ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled=
=2E
> ACPI: PCI Interrupt Link [LIGP] (IRQs *5 7 9 10 11 14 15)
> ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled=
=2E
> ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 10 *11 14 15)
> ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 10 11 14 15) *0, disabled=
=2E
> ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 10 *11 14 15)
> ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled=
=2E
> ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 *10 11 14 15)
> ACPI: PCI Interrupt Link [LUB2] (IRQs *5 7 9 10 11 14 15)
> ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled=
=2E
> ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 *10 11 14 15)
> ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 10 *11 14 15)
> ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
> ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
> ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
> ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
> ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0
> ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AIGP] (IRQs 20 21 22 23) *0
> ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
> ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
> ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
> ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
> ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
> ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
> vgaarb: device added: PCI:0000:00:0d.0,decodes=3Dio+mem,owns=3Dio+mem=
,locks=3Dnone
> vgaarb: loaded
> SCSI subsystem initialized
> libata version 3.00 loaded.
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> PCI: pci_cache_line_size set to 64 bytes
> NetLabel: Initializing
> NetLabel: =C2=A0domain hash size =3D 128
> NetLabel: =C2=A0protocols =3D UNLABELED CIPSOv4
> NetLabel: =C2=A0unlabeled traffic allowed by default
> HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> hpet0: at MMIO 0xfeff0000, IRQs 2, 8, 31
> hpet0: 3 comparators, 32-bit 25.000000 MHz counter
> Switching to clocksource hpet
> kstop/0 used greatest stack depth: 6424 bytes left
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp: PnP ACPI: found 15 devices
> ACPI: ACPI bus type pnp unregistered
> system 00:01: [io =C2=A00x1000-0x107f] has been reserved
> system 00:01: [io =C2=A00x1080-0x10ff] has been reserved
> system 00:01: [io =C2=A00x1400-0x147f] has been reserved
> system 00:01: [io =C2=A00x1480-0x14ff] has been reserved
> system 00:01: [io =C2=A00x1800-0x187f] has been reserved
> system 00:01: [io =C2=A00x1880-0x18ff] has been reserved
> system 00:01: [mem 0xfefe0000-0xfefe01ff] has been reserved
> system 00:01: [mem 0xfefe1000-0xfefe10ff] has been reserved
> system 00:01: [mem 0xb0000000-0xbfffffff] has been reserved
> system 00:02: [io =C2=A00x04d0-0x04d1] has been reserved
> system 00:02: [io =C2=A00x0800-0x087f] has been reserved
> system 00:02: [io =C2=A00x0290-0x0297] has been reserved
> system 00:0d: [mem 0xf0000000-0xf3ffffff] has been reserved
> system 00:0e: [mem 0x000d3000-0x000d3fff] has been reserved
> system 00:0e: [mem 0x000f0000-0x000f7fff] could not be reserved
> system 00:0e: [mem 0x000f8000-0x000fbfff] could not be reserved
> system 00:0e: [mem 0x000fc000-0x000fffff] could not be reserved
> system 00:0e: [mem 0xfeff0000-0xfeff00ff] has been reserved
> system 00:0e: [mem 0xafff0000-0xafffffff] could not be reserved
> system 00:0e: [mem 0xffff0000-0xffffffff] has been reserved
> system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
> system 00:0e: [mem 0x00100000-0xaffeffff] could not be reserved
> system 00:0e: [mem 0xb0000000-0xbfffffff] has been reserved
> system 00:0e: [mem 0xfec00000-0xfec00fff] could not be reserved
> system 00:0e: [mem 0xfee00000-0xfeefffff] has been reserved
> system 00:0e: [mem 0xfefff000-0xfeffffff] has been reserved
> system 00:0e: [mem 0xfff80000-0xfff80fff] has been reserved
> system 00:0e: [mem 0xfff90000-0xfffbffff] has been reserved
> system 00:0e: [mem 0xfffed000-0xfffeffff] has been reserved
> pci 0000:00:0d.0: BAR 6: assigned [mem 0xc0000000-0xc001ffff pref]
> pci 0000:01:06.0: BAR 6: assigned [mem 0xfd800000-0xfd80ffff pref]
> pci 0000:00:04.0: PCI bridge to [bus 01-01]
> pci 0000:00:04.0: =C2=A0 bridge window [io =C2=A00xa000-0xbfff]
> pci 0000:00:04.0: =C2=A0 bridge window [mem 0xfdf00000-0xfdffffff]
> pci 0000:00:04.0: =C2=A0 bridge window [mem 0xfd800000-0xfd8fffff pre=
f]
> pci 0000:00:09.0: PCI bridge to [bus 02-02]
> pci 0000:00:09.0: =C2=A0 bridge window [io =C2=A00x9000-0x9fff]
> pci 0000:00:09.0: =C2=A0 bridge window [mem 0xfde00000-0xfdefffff]
> pci 0000:00:09.0: =C2=A0 bridge window [mem 0xfdd00000-0xfddfffff 64b=
it pref]
> pci 0000:03:00.0: BAR 6: assigned [mem 0xfdb00000-0xfdb1ffff pref]
> pci 0000:00:0b.0: PCI bridge to [bus 03-03]
> pci 0000:00:0b.0: =C2=A0 bridge window [io =C2=A00x8000-0x8fff]
> pci 0000:00:0b.0: =C2=A0 bridge window [mem 0xfdc00000-0xfdcfffff]
> pci 0000:00:0b.0: =C2=A0 bridge window [mem 0xfdb00000-0xfdbfffff 64b=
it pref]
> pci 0000:00:0c.0: PCI bridge to [bus 04-04]
> pci 0000:00:0c.0: =C2=A0 bridge window [io =C2=A00x7000-0x7fff]
> pci 0000:00:0c.0: =C2=A0 bridge window [mem 0xfda00000-0xfdafffff]
> pci 0000:00:0c.0: =C2=A0 bridge window [mem 0xfd900000-0xfd9fffff 64b=
it pref]
> pci 0000:00:04.0: setting latency timer to 64
> pci 0000:00:09.0: setting latency timer to 64
> pci 0000:00:0b.0: setting latency timer to 64
> pci 0000:00:0c.0: setting latency timer to 64
> pci_bus 0000:00: resource 0 [io =C2=A00x0000-0xffff]
> pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
> pci_bus 0000:01: resource 0 [io =C2=A00xa000-0xbfff]
> pci_bus 0000:01: resource 1 [mem 0xfdf00000-0xfdffffff]
> pci_bus 0000:01: resource 2 [mem 0xfd800000-0xfd8fffff pref]
> pci_bus 0000:01: resource 3 [io =C2=A00x0000-0xffff]
> pci_bus 0000:01: resource 4 [mem 0x00000000-0xffffffffffffffff]
> pci_bus 0000:02: resource 0 [io =C2=A00x9000-0x9fff]
> pci_bus 0000:02: resource 1 [mem 0xfde00000-0xfdefffff]
> pci_bus 0000:02: resource 2 [mem 0xfdd00000-0xfddfffff 64bit pref]
> pci_bus 0000:03: resource 0 [io =C2=A00x8000-0x8fff]
> pci_bus 0000:03: resource 1 [mem 0xfdc00000-0xfdcfffff]
> pci_bus 0000:03: resource 2 [mem 0xfdb00000-0xfdbfffff 64bit pref]
> pci_bus 0000:04: resource 0 [io =C2=A00x7000-0x7fff]
> pci_bus 0000:04: resource 1 [mem 0xfda00000-0xfdafffff]
> pci_bus 0000:04: resource 2 [mem 0xfd900000-0xfd9fffff 64bit pref]
> NET: Registered protocol family 2
> IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
> TCP: Hash tables configured (established 524288 bind 65536)
> TCP reno registered
> UDP hash table entries: 2048 (order: 6, 327680 bytes)
> UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
> NET: Registered protocol family 1
> pci 0000:00:00.0: Found enabled HT MSI Mapping
> pci 0000:00:00.0: Found enabled HT MSI Mapping
> pci 0000:00:00.0: Found enabled HT MSI Mapping
> pci 0000:00:00.0: Found enabled HT MSI Mapping
> pci 0000:00:00.0: Found enabled HT MSI Mapping
> pci 0000:00:00.0: Found enabled HT MSI Mapping
> pci 0000:00:00.0: Found enabled HT MSI Mapping
> pci 0000:00:0d.0: Boot video device
> PCI: CLS 64 bytes, default 64
> Trying to unpack rootfs image as initramfs...
> Freeing initrd memory: 12010k freed
> DMA-API: preallocated 32768 debug entries
> DMA-API: debugging enabled by kernel config
> PCI-DMA: Disabling AGP.
> PCI-DMA: aperture base @ 20000000 size 65536 KB
> PCI-DMA: using GART IOMMU.
> PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
> Intel PCLMULQDQ-NI instructions are not detected.
> audit: initializing netlink socket (disabled)
> type=3D2000 audit(1267655479.576:1): initialized
> HugeTLB registered 2 MB page size, pre-allocated 0 pages
> VFS: Disk quotas dquot_6.5.2
> Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> msgmni has been set to 7381
> SELinux: =C2=A0Registering netfilter hooks
> cryptomgr_test used greatest stack depth: 5880 bytes left
> cryptomgr_test used greatest stack depth: 5688 bytes left
> alg: No test for stdrng (krng)
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> io scheduler noop registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> pcieport 0000:00:09.0: setting latency timer to 64
> =C2=A0alloc irq_desc for 24 on node 0
> =C2=A0alloc kstat_irqs on node 0
> pcieport 0000:00:09.0: irq 24 for MSI/MSI-X
> pcieport 0000:00:0b.0: setting latency timer to 64
> =C2=A0alloc irq_desc for 25 on node 0
> =C2=A0alloc kstat_irqs on node 0
> pcieport 0000:00:0b.0: irq 25 for MSI/MSI-X
> pcieport 0000:00:0c.0: setting latency timer to 64
> =C2=A0alloc irq_desc for 26 on node 0
> =C2=A0alloc kstat_irqs on node 0
> pcieport 0000:00:0c.0: irq 26 for MSI/MSI-X
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> pci-stub: invalid id string ""
> input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/in=
put/input0
> ACPI: Power Button [PWRB]
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> ACPI: Power Button [PWRF]
> ACPI: Fan [FAN] (on)
> thermal LNXTHERM:01: registered as thermal_zone0
> ACPI: Thermal Zone [THRM] (39 C)
> Non-volatile memory driver v1.3
> Linux agpgart interface v0.103
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
> serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
> 00:08: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
> 00:09: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
> brd: module loaded
> loop: module loaded
> input: Macintosh mouse button emulation as /devices/virtual/input/inp=
ut2
> Fixed MDIO Bus: probed
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> ACPI: PCI Interrupt Link [APCL] enabled at IRQ 23
> =C2=A0alloc irq_desc for 23 on node 0
> =C2=A0alloc kstat_irqs on node 0
> ehci_hcd 0000:00:02.1: PCI INT B -> Link[APCL] -> GSI 23 (level, low)=
 -> IRQ 23
> ehci_hcd 0000:00:02.1: setting latency timer to 64
> ehci_hcd 0000:00:02.1: EHCI Host Controller
> ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
> ehci_hcd 0000:00:02.1: debug port 1
> ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
> ehci_hcd 0000:00:02.1: irq 23, io mem 0xfe02e000
> ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
> usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
> usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D=
1
> usb usb1: Product: EHCI Host Controller
> usb usb1: Manufacturer: Linux 2.6.33-0.46.rc8.git1.fc13.x86_64 ehci_h=
cd
> usb usb1: SerialNumber: 0000:00:02.1
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 10 ports detected
> work_for_cpu used greatest stack depth: 4448 bytes left
> ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> ACPI: PCI Interrupt Link [APCF] enabled at IRQ 22
> =C2=A0alloc irq_desc for 22 on node 0
> =C2=A0alloc kstat_irqs on node 0
> ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 22 (level, low)=
 -> IRQ 22
> ohci_hcd 0000:00:02.0: setting latency timer to 64
> ohci_hcd 0000:00:02.0: OHCI Host Controller
> ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
> ohci_hcd 0000:00:02.0: irq 22, io mem 0xfe02f000
> usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0001
> usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D=
1
> usb usb2: Product: OHCI Host Controller
> usb usb2: Manufacturer: Linux 2.6.33-0.46.rc8.git1.fc13.x86_64 ohci_h=
cd
> usb usb2: SerialNumber: 0000:00:02.0
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 10 ports detected
> uhci_hcd: USB Universal Host Controller Interface driver
> PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,1=
2
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> rtc_cmos 00:05: RTC can wake from S4
> rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
> rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
> device-mapper: uevent: version 1.0.3
> device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel=
@redhat.com
> cpuidle: using governor ladder
> cpuidle: using governor menu
> usbcore: registered new interface driver hiddev
> usbcore: registered new interface driver usbhid
> usbhid: USB HID core driver
> nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
> nf_conntrack.acct=3D1 kernel parameter, acct=3D1 nf_conntrack module =
option or
> sysctl net.netfilter.nf_conntrack_acct=3D1 to enable it.
> ip_tables: (C) 2000-2006 Netfilter Core Team
> TCP cubic registered
> Initializing XFRM netlink socket
> NET: Registered protocol family 17
> PM: Resume from disk failed.
> registered taskstats version 1
> No TPM chip found, activating TPM-bypass!
> =C2=A0Magic number: 2:19:552
> pci_link PNP0C0F:03: hash matches
> rtc_cmos 00:05: setting system clock to 2010-03-03 22:31:20 UTC (1267=
655480)
> Initalizing network drop monitor service
> Freeing unused kernel memory: 2752k freed
> Write protecting the kernel read-only data: 10240k
> Freeing unused kernel memory: 1516k freed
> Freeing unused kernel memory: 1832k freed
> input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input3
> dracut: dracut-002-13.4.git8f397a9b.fc12
> udev: starting version 145
> [drm] Initialized drm 1.1.0 20060810
> ACPI: PCI Interrupt Link [AIGP] enabled at IRQ 21
> =C2=A0alloc irq_desc for 21 on node 0
> =C2=A0alloc kstat_irqs on node 0
> nouveau 0000:00:0d.0: PCI INT A -> Link[AIGP] -> GSI 21 (level, low) =
-> IRQ 21
> nouveau 0000:00:0d.0: setting latency timer to 64
> [drm] nouveau 0000:00:0d.0: failed to evaluate _DSM: 5
> [drm] nouveau 0000:00:0d.0: Detected an NV40 generation card (0x04c00=
0a2)
> [drm] nouveau 0000:00:0d.0: Attempting to load BIOS image from PROM
> [drm] nouveau 0000:00:0d.0: ... BIOS signature not found
> [drm] nouveau 0000:00:0d.0: Attempting to load BIOS image from PRAMIN
> [drm] nouveau 0000:00:0d.0: ... appears to be valid
> [drm] nouveau 0000:00:0d.0: BIT BIOS found
> [drm] nouveau 0000:00:0d.0: Bios version 05.61.32.20
> [drm] nouveau 0000:00:0d.0: BIT table 'd' not found
> [drm] nouveau 0000:00:0d.0: Found Display Configuration Block version=
 3.0
> [drm] nouveau 0000:00:0d.0: DCB connector table: VHER 0x30 5 10 2
> [drm] nouveau 0000:00:0d.0: =C2=A0 0: 0x00000000: type 0x00 idx 0 tag=
 0xff
> [drm] nouveau 0000:00:0d.0: Raw DCB entry 0: 01000310 00000023
> [drm] nouveau 0000:00:0d.0: Raw DCB entry 1: 00110204 97dd0000
> [drm] nouveau 0000:00:0d.0: Parsing VBIOS init table 0 at offset 0xDC=
AA
> [drm] nouveau 0000:00:0d.0: =3D=3D=3D=3D=3D=3D=3D misaligned reg 0x00=
60081D =3D=3D=3D=3D=3D=3D=3D
> [drm] nouveau 0000:00:0d.0: =3D=3D=3D=3D=3D=3D=3D misaligned reg 0x00=
60081D =3D=3D=3D=3D=3D=3D=3D
> [drm] nouveau 0000:00:0d.0: Parsing VBIOS init table 1 at offset 0xDE=
01
> [drm] nouveau 0000:00:0d.0: Parsing VBIOS init table 2 at offset 0xDE=
02
> [drm] nouveau 0000:00:0d.0: Parsing VBIOS init table 3 at offset 0xDF=
84
> [drm] nouveau 0000:00:0d.0: Parsing VBIOS init table 4 at offset 0xDF=
CD
> usb 1-8: new high speed USB device using ehci_hcd and address 5
> [TTM] Zone =C2=A0kernel: Available graphics memory: 1892784 kiB.
> [drm] nouveau 0000:00:0d.0: 256 MiB VRAM
> [drm] nouveau 0000:00:0d.0: 64 MiB GART (aperture)
> [drm] nouveau 0000:00:0d.0: Allocating FIFO number 0
> [drm] nouveau 0000:00:0d.0: nouveau_channel_alloc: initialised FIFO 0
> [drm] nouveau 0000:00:0d.0: Initial CRTC_OWNER is 0
> [drm] nouveau 0000:00:0d.0: Saving VGA fonts
> [drm] nouveau 0000:00:0d.0: DCB type 4 not known
> [drm] nouveau 0000:00:0d.0: Detected a VGA connector
> [drm] nouveau 0000:00:0d.0: Setting dpms mode 3 on vga encoder (outpu=
t 0)
> usb 1-8: New USB device found, idVendor=3D0bda, idProduct=3D0111
> usb 1-8: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D=
3
> usb 1-8: Product: USB2.0-CRW
> usb 1-8: Manufacturer: Generic
> usb 1-8: SerialNumber: 20021111153705700
> Initializing USB Mass Storage driver...
> scsi0 : usb-storage 1-8:1.0
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> [drm] nouveau 0000:00:0d.0: allocated 1024x768 fb: 0x49000, bo ffff88=
0135040448
> fbcon: nouveaufb (fb0) is primary device
> [drm] nouveau 0000:00:0d.0: Setting dpms mode 0 on vga encoder (outpu=
t 0)
> [drm] nouveau 0000:00:0d.0: Output VGA-1 is running on CRTC 0 using o=
utput A
> Console: switching to colour frame buffer device 128x48
> fb0: nouveaufb frame buffer device
> registered panic notifier
> [drm] Initialized nouveau 0.0.15 20090420 for 0000:00:0d.0 on minor 0
> work_for_cpu used greatest stack depth: 3952 bytes left
> dracut: Starting plymouth daemon
> usb 2-5: new full speed USB device using ohci_hcd and address 2
> input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/i=
nput/input4
> usb 2-5: New USB device found, idVendor=3D0fca, idProduct=3D0004
> usb 2-5: New USB device strings: Mfr=3D1, Product=3D5, SerialNumber=3D=
3
> usb 2-5: Product: RIM Composite Device
> usb 2-5: Manufacturer: Research In Motion
> usb 2-5: SerialNumber: 1879BE860E27CCE2ECBF21BD4E6ADA3C436A38CB
> scsi1 : usb-storage 2-5:1.1
> pata_artop 0000:01:06.0: version 0.4.5
> ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
> =C2=A0alloc irq_desc for 17 on node 0
> =C2=A0alloc kstat_irqs on node 0
> pata_artop 0000:01:06.0: PCI INT A -> Link[APC2] -> GSI 17 (level,
> low) -> IRQ 17
> pata_amd 0000:00:06.0: version 0.4.1
> pata_amd 0000:00:06.0: setting latency timer to 64
> scsi2 : pata_artop
> scsi3 : pata_amd
> scsi5 : pata_amd
> scsi4 : pata_artop
> ata1: PATA max UDMA/100 cmd 0xbc00 ctl 0xb800 bmdma 0xac00 irq 17
> ata2: PATA max UDMA/100 cmd 0xb400 ctl 0xb000 bmdma 0xac08 irq 17
> ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
> ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
> sata_nv 0000:00:08.0: version 3.5
> ACPI: PCI Interrupt Link [APSI] enabled at IRQ 20
> =C2=A0alloc irq_desc for 20 on node 0
> =C2=A0alloc kstat_irqs on node 0
> sata_nv 0000:00:08.0: PCI INT A -> Link[APSI] -> GSI 20 (level, low) =
-> IRQ 20
> sata_nv 0000:00:08.0: setting latency timer to 64
> scsi6 : sata_nv
> scsi7 : sata_nv
> ata5: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xdc00 irq 20
> ata6: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xdc08 irq 20
> ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 23
> sata_nv 0000:00:08.1: PCI INT B -> Link[APSJ] -> GSI 23 (level, low) =
-> IRQ 23
> sata_nv 0000:00:08.1: setting latency timer to 64
> scsi8 : sata_nv
> scsi9 : sata_nv
> ata7: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc800 irq 23
> ata8: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc808 irq 23
> usb 2-6: new low speed USB device using ohci_hcd and address 3
> ata1.00: ATA-7: Maxtor 6L200P0, BAJ41G20, max UDMA/133
> ata1.00: 398297088 sectors, multi 16: LBA48
> ata1.00: configured for UDMA/100
> scsi 2:0:0:0: Direct-Access =C2=A0 =C2=A0 ATA =C2=A0 =C2=A0 =C2=A0Max=
tor 6L200P0 =C2=A0 BAJ4 PQ: 0 ANSI: 5
> sd 2:0:0:0: [sda] 398297088 512-byte logical blocks: (203 GB/189 GiB)
> sd 2:0:0:0: [sda] Write Protect is off
> sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 2:0:0:0: Attached scsi generic sg0 type 0
> =C2=A0sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
> sd 2:0:0:0: [sda] Attached SCSI disk
> usb 2-6: New USB device found, idVendor=3D045e, idProduct=3D0040
> usb 2-6: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D=
0
> usb 2-6: Product: Microsoft Wheel Mouse Optical=C2=AE
> usb 2-6: Manufacturer: Microsoft
> ata4: port disabled. ignoring.
> input: Microsoft Microsoft Wheel Mouse Optical=C2=AE as
> /devices/pci0000:00/0000:00:02.0/usb2/2-6/2-6:1.0/input/input5
> generic-usb 0003:045E:0040.0001: input,hidraw0: USB HID v1.00 Mouse
> [Microsoft Microsoft Wheel Mouse Optical=C2=AE] on
> usb-0000:00:02.0-6/input0
> ata5: SATA link down (SStatus 0 SControl 300)
> ata7: SATA link down (SStatus 0 SControl 300)
> usb 2-7: new low speed USB device using ohci_hcd and address 4
> ata6: SATA link down (SStatus 0 SControl 300)
> usb 2-7: New USB device found, idVendor=3D147a, idProduct=3De00d
> usb 2-7: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D=
0
> usb 2-7: Product: IR =C2=A0Receiver
> usb 2-7: Manufacturer: Acer
> input: Acer IR =C2=A0Receiver as
> /devices/pci0000:00/0000:00:02.0/usb2/2-7/2-7:1.0/input/input6
> generic-usb 0003:147A:E00D.0002: input,hiddev96,hidraw1: USB HID v1.1=
0
> Keyboard [Acer IR =C2=A0Receiver] on usb-0000:00:02.0-7/input0
> ata8: SATA link down (SStatus 0 SControl 300)
> async/0 used greatest stack depth: 3912 bytes left
> Btrfs loaded
> device fsid 1d4372c00cc6237d-a2c61af6bc871a97 devid 1 transid 669 /de=
v/sda2
> dracut: Mounted root filesystem /dev/sda2
> dracut: Loading SELinux policy
> type=3D1404 audit(1267655483.974:2): enforcing=3D1 old_enforcing=3D0
> auid=3D4294967295 ses=3D4294967295
> SELinux: 8192 avtab hash slots, 144734 rules.
> SELinux: 8192 avtab hash slots, 144734 rules.
> SELinux: =C2=A08 users, 12 roles, 2941 types, 136 bools, 1 sens, 1024=
 cats
> SELinux: =C2=A075 classes, 144734 rules
> SELinux: =C2=A0Completing initialization.
> SELinux: =C2=A0Setting up existing superblocks.
> SELinux: initialized (dev sda2, type btrfs), uses xattr
> SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> SELinux: initialized (dev securityfs, type securityfs), uses genfs_co=
ntexts
> SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
> SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_cont=
exts
> SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
> SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition=
 SIDs
> SELinux: initialized (dev devpts, type devpts), uses transition SIDs
> SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_cont=
exts
> SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genf=
s_contexts
> SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
> SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
> SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
> SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition S=
IDs
> SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> SELinux: initialized (dev proc, type proc), uses genfs_contexts
> SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
> SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
> SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
> type=3D1403 audit(1267655484.977:3): policy loaded auid=3D4294967295 =
ses=3D4294967295
> load_policy used greatest stack depth: 2976 bytes left
> dracut: Switching root
> scsi 0:0:0:0: Direct-Access =C2=A0 =C2=A0 Generic- Compact Flash =C2=A0=
 =C2=A01.00 PQ: 0 ANSI: 0 CCS
> scsi 0:0:0:1: Direct-Access =C2=A0 =C2=A0 Generic- SM/xD-Picture =C2=A0=
 =C2=A01.00 PQ: 0 ANSI: 0 CCS
> scsi 0:0:0:2: Direct-Access =C2=A0 =C2=A0 Generic- SD/MMC =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 1.00 PQ: 0 ANSI: 0 CCS
> scsi 0:0:0:3: Direct-Access =C2=A0 =C2=A0 Generic- MS/MS-Pro =C2=A0 =C2=
=A0 =C2=A0 =C2=A01.00 PQ: 0 ANSI: 0 CCS
> sd 0:0:0:0: Attached scsi generic sg1 type 0
> sd 0:0:0:1: Attached scsi generic sg2 type 0
> sd 0:0:0:2: Attached scsi generic sg3 type 0
> sd 0:0:0:0: [sdb] Attached SCSI removable disk
> sd 0:0:0:3: Attached scsi generic sg4 type 0
> sd 0:0:0:1: [sdc] Attached SCSI removable disk
> sd 0:0:0:2: [sdd] Attached SCSI removable disk
> sd 0:0:0:3: [sde] Attached SCSI removable disk
> scsi 1:0:0:0: Direct-Access =C2=A0 =C2=A0 RIM =C2=A0 =C2=A0 =C2=A0Bla=
ckberry SD =C2=A0 =C2=A00001 PQ: 0 ANSI: 4 CCS
> sd 1:0:0:0: Attached scsi generic sg5 type 0
> sd 1:0:0:0: [sdf] 7864320 512-byte logical blocks: (4.02 GB/3.75 GiB)
> sd 1:0:0:0: [sdf] Write Protect is off
> sd 1:0:0:0: [sdf] Mode Sense: 43 00 00 53
> sd 1:0:0:0: [sdf] Assuming drive cache: write through
> sd 1:0:0:0: [sdf] Assuming drive cache: write through
> =C2=A0sdf: sdf1
> sd 1:0:0:0: [sdf] Assuming drive cache: write through
> sd 1:0:0:0: [sdf] Attached SCSI removable disk
> udev: starting version 145
> type=3D1400 audit(1267655489.723:4): avc: =C2=A0denied =C2=A0{ mmap_z=
ero } for
> pid=3D428 comm=3D"vbetool"
> scontext=3Dsystem_u:system_r:vbetool_t:s0-s0:c0.c1023
> tcontext=3Dsystem_u:system_r:vbetool_t:s0-s0:c0.c1023 tclass=3Dmempro=
tect
> i2c i2c-1: nForce2 SMBus adapter at 0x1c00
> i2c i2c-2: nForce2 SMBus adapter at 0xf400
> sky2 driver version 1.26
> ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
> =C2=A0alloc irq_desc for 16 on node 0
> =C2=A0alloc kstat_irqs on node 0
> sky2 0000:03:00.0: PCI INT A -> Link[APC6] -> GSI 16 (level, low) -> =
IRQ 16
> sky2 0000:03:00.0: setting latency timer to 64
> sky2 0000:03:00.0: Yukon-2 EC Ultra chip revision 2
> =C2=A0alloc irq_desc for 27 on node 0
> =C2=A0alloc kstat_irqs on node 0
> sky2 0000:03:00.0: irq 27 for MSI/MSI-X
> sky2 eth0: addr 00:19:21:57:98:36
> EDAC MC: Ver: 2.1.0 Feb 16 2010
> usbcore: registered new interface driver berry_charge
> cfg80211: Calling CRDA to update world regulatory domain
> parport_pc 00:0a: reported by Plug and Play ACPI
> parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
> EDAC amd64_edac: =C2=A0Ver: 3.3.0 Feb 16 2010
> EDAC amd64: This node reports that Memory ECC is currently disabled,
> set F3x44[22] (0000:00:18.3).
> EDAC amd64: ECC disabled in the BIOS or no ECC capability, module wil=
l not load.
> =C2=A0Either enable ECC checking or force module loading by setting
> 'ecc_enable_override'.
> =C2=A0(Note that use of the override may cause unknown side effects.)
> amd64_edac: probe of 0000:00:18.2 failed with error -22
> ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
> =C2=A0alloc irq_desc for 19 on node 0
> =C2=A0alloc kstat_irqs on node 0
> firewire_ohci 0000:01:09.0: PCI INT A -> Link[APC4] -> GSI 19 (level,
> low) -> IRQ 19
> firewire_ohci 0000:01:09.0: setting latency timer to 64
> firewire_ohci: Added fw-ohci device 0000:01:09.0, OHCI version 1.10
> k8temp 0000:00:18.3: Temperature readouts might be wrong - check erra=
tum #141
> ppdev: user-space parallel port driver
> firewire_core: created device fw0: GUID 00001921ff14c1cf, S400
> ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
> ath5k 0000:01:05.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low) ->=
 IRQ 16
> ath5k 0000:01:05.0: registered as 'phy0'
> cfg80211: World regulatory domain updated:
> =C2=A0 =C2=A0(start_freq - end_freq @ bandwidth), (max_antenna_gain, =
max_eirp)
> =C2=A0 =C2=A0(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 =
mBm)
> =C2=A0 =C2=A0(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 =
mBm)
> =C2=A0 =C2=A0(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 =
mBm)
> =C2=A0 =C2=A0(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 =
mBm)
> =C2=A0 =C2=A0(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 =
mBm)
> ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> HDA Intel 0000:00:05.0: PCI INT B -> Link[AAZA] -> GSI 22 (level, low=
) -> IRQ 22
> =C2=A0alloc irq_desc for 28 on node 0
> =C2=A0alloc kstat_irqs on node 0
> HDA Intel 0000:00:05.0: irq 28 for MSI/MSI-X
> HDA Intel 0000:00:05.0: setting latency timer to 64
> ath: EEPROM regdomain: 0x10
> ath: EEPROM indicates we should expect a direct regpair map
> ath: Country alpha2 being used: CO
> ath: Regpair used: 0x10
> hda_codec: ALC888: BIOS auto-probing.
> ALSA sound/pci/hda/hda_codec.c:4284: autoconfig: line_outs=3D4
> (0x14/0x15/0x16/0x17/0x0)
> ALSA sound/pci/hda/hda_codec.c:4288: =C2=A0 =C2=A0speaker_outs=3D0 (0=
x0/0x0/0x0/0x0/0x0)
> ALSA sound/pci/hda/hda_codec.c:4292: =C2=A0 =C2=A0hp_outs=3D1 (0x1b/0=
x0/0x0/0x0/0x0)
> ALSA sound/pci/hda/hda_codec.c:4293: =C2=A0 =C2=A0mono: mono_out=3D0x=
0
> ALSA sound/pci/hda/hda_codec.c:4296: =C2=A0 =C2=A0dig-out=3D0x1e/0x0
> ALSA sound/pci/hda/hda_codec.c:4304: =C2=A0 =C2=A0inputs: mic=3D0x18,=
 fmic=3D0x19,
> line=3D0x1a, fline=3D0x0, cd=3D0x0, aux=3D0x1c
> ALSA sound/pci/hda/patch_realtek.c:1309: realtek: Enabling init
> ASM_ID=3D0xe619 CODEC_ID=3D10ec0888
> phy0: Selected rate control algorithm 'minstrel'
> ath5k phy0: Atheros AR2413 chip found (MAC: 0x78, PHY: 0x45)
> cfg80211: Calling CRDA for country: CO
> cfg80211: Regulatory domain changed to country: CO
> =C2=A0 =C2=A0(start_freq - end_freq @ bandwidth), (max_antenna_gain, =
max_eirp)
> =C2=A0 =C2=A0(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 =
mBm)
> =C2=A0 =C2=A0(5170000 KHz - 5250000 KHz @ 20000 KHz), (300 mBi, 1700 =
mBm)
> =C2=A0 =C2=A0(5250000 KHz - 5330000 KHz @ 20000 KHz), (300 mBi, 2300 =
mBm)
> =C2=A0 =C2=A0(5735000 KHz - 5835000 KHz @ 20000 KHz), (300 mBi, 3000 =
mBm)
> cfg80211: Calling CRDA for country: US
> cfg80211: Regulatory domain changed to country: US
> =C2=A0 =C2=A0(start_freq - end_freq @ bandwidth), (max_antenna_gain, =
max_eirp)
> =C2=A0 =C2=A0(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 =
mBm)
> =C2=A0 =C2=A0(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 =
mBm)
> =C2=A0 =C2=A0(5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 =
mBm)
> =C2=A0 =C2=A0(5490000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 =
mBm)
> =C2=A0 =C2=A0(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 =
mBm)
> device-mapper: multipath: version 1.1.1 loaded
> EXT4-fs (sda6): mounted filesystem with ordered data mode
> SELinux: initialized (dev sda6, type ext4), uses xattr
> Adding 1052248k swap on /dev/sda3. =C2=A0Priority:-1 extents:1 across=
:1052248k
> SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_=
contexts
> powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+
> processors (2 cpu cores) (version 2.20.00)
> powernow-k8: =C2=A0 =C2=A00 : fid 0xf (2300 MHz), vid 0xa
> powernow-k8: =C2=A0 =C2=A01 : fid 0xe (2200 MHz), vid 0xb
> powernow-k8: =C2=A0 =C2=A02 : fid 0xc (2000 MHz), vid 0xd
> powernow-k8: =C2=A0 =C2=A03 : fid 0xa (1800 MHz), vid 0xf
> powernow-k8: =C2=A0 =C2=A04 : fid 0x2 (1000 MHz), vid 0x12
> Clocksource tsc unstable (delta =3D -88295025 ns)
> NET: Registered protocol family 10
> lo: Disabled Privacy Extensions
> ip6_tables: (C) 2000-2006 Netfilter Core Team
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> sky2 eth0: enabling interface
> ADDRCONF(NETDEV_UP): eth0: link is not ready
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> RPC: Registered tcp NFSv4.1 backchannel transport module.
> SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_co=
ntexts
> sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
> ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [drm] nouveau 0000:00:0d.0: unknown parameter -2401039834048102397
> [drm] nouveau 0000:00:0d.0: Allocating FIFO number 1
> [drm] nouveau 0000:00:0d.0: nouveau_channel_alloc: initialised FIFO 1
> eth0: no IPv6 routers present
> fuse init (API version 7.13)
> SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
> SELinux: initialized (dev sdf1, type vfat), uses genfs_contexts
> usb 2-9: new full speed USB device using ohci_hcd and address 5
> usb 2-9: New USB device found, idVendor=3D0d8c, idProduct=3D000c
> usb 2-9: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D=
0
> input: HID 0d8c:000c as
> /devices/pci0000:00/0000:00:02.0/usb2/2-9/2-9:1.3/input/input7
> generic-usb 0003:0D8C:000C.0003: input,hidraw2: USB HID v1.00 Device
> [HID 0d8c:000c] on usb-0000:00:02.0-9/input3
> usbcore: registered new interface driver snd-usb-audio
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> [ INFO: possible circular locking dependency detected ]
> 2.6.33-0.46.rc8.git1.fc13.x86_64 #1
> -------------------------------------------------------
> pulseaudio/1760 is trying to acquire lock:
> =C2=A0(sysfs_mutex){+.+.+.}, at: [<ffffffff81176709>] sysfs_get_diren=
t+0x20/0x4a
>
> but task is already holding lock:
> =C2=A0(&pcm->open_mutex){+.+.+.}, at: [<ffffffffa020c395>]
> snd_pcm_release+0x65/0xbd [snd_pcm]
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #2 (&pcm->open_mutex){+.+.+.}:
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff8107e7dd>] __lock_acquire+0xb87/0xd36
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff8107ea68>] lock_acquire+0xdc/0x102
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff81476fa5>] __mutex_lock_common+0x4b/0x=
392
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff814773b0>] mutex_lock_nested+0x3e/0x43
> =C2=A0 =C2=A0 =C2=A0 [<ffffffffa020c395>] snd_pcm_release+0x65/0xbd [=
snd_pcm]
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff8111fdb6>] __fput+0x12a/0x1df
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff8111fe85>] fput+0x1a/0x1c
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff810f7f62>] remove_vma+0x56/0x8c
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff810f93a6>] do_munmap+0x310/0x332
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff810f940e>] sys_munmap+0x46/0x5d
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff81009c72>] system_call_fastpath+0x16/0=
x1b
>
> -> #1 (&mm->mmap_sem){++++++}:
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff8107e7dd>] __lock_acquire+0xb87/0xd36
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff8107ea68>] lock_acquire+0xdc/0x102
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff810f19c1>] might_fault+0x89/0xac
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff8112c7aa>] filldir+0x75/0xd0
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff81176542>] sysfs_readdir+0x10f/0x149
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff8112c93d>] vfs_readdir+0x79/0xb6
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff8112cac3>] sys_getdents+0x81/0xd1
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff81009c72>] system_call_fastpath+0x16/0=
x1b
>
> -> #0 (sysfs_mutex){+.+.+.}:
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff8107e687>] __lock_acquire+0xa31/0xd36
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff8107ea68>] lock_acquire+0xdc/0x102
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff81476fa5>] __mutex_lock_common+0x4b/0x=
392
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff814773b0>] mutex_lock_nested+0x3e/0x43
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff81176709>] sysfs_get_dirent+0x20/0x4a
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff8117828e>] sysfs_remove_group+0x2a/0xc=
a
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff812f1169>] dpm_sysfs_remove+0x19/0x1b
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff812ea26d>] device_del+0x4c/0x1ab
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff812ea400>] device_unregister+0x34/0x5b
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff813504eb>] usb_remove_ep_devs+0x23/0x2=
f
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff813491e5>] remove_intf_ep_devs+0x37/0x=
4d
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff8134a2cc>] usb_set_interface+0x1cd/0x2=
dc
> =C2=A0 =C2=A0 =C2=A0 [<ffffffffa03ddf18>] snd_usb_capture_close+0x33/=
0x4f [snd_usb_audio]
> =C2=A0 =C2=A0 =C2=A0 [<ffffffffa020c301>] snd_pcm_release_substream+0=
x53/0x82 [snd_pcm]
> =C2=A0 =C2=A0 =C2=A0 [<ffffffffa020c39d>] snd_pcm_release+0x6d/0xbd [=
snd_pcm]
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff8111fdb6>] __fput+0x12a/0x1df
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff8111fe85>] fput+0x1a/0x1c
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff810f7f62>] remove_vma+0x56/0x8c
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff810f93a6>] do_munmap+0x310/0x332
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff810f940e>] sys_munmap+0x46/0x5d
> =C2=A0 =C2=A0 =C2=A0 [<ffffffff81009c72>] system_call_fastpath+0x16/0=
x1b
>
> other info that might help us debug this:
>
> 2 locks held by pulseaudio/1760:
> =C2=A0#0: =C2=A0(&mm->mmap_sem){++++++}, at: [<ffffffff810f9400>] sys=
_munmap+0x38/0x5d
> =C2=A0#1: =C2=A0(&pcm->open_mutex){+.+.+.}, at: [<ffffffffa020c395>]
> snd_pcm_release+0x65/0xbd [snd_pcm]
>
> stack backtrace:
> Pid: 1760, comm: pulseaudio Not tainted 2.6.33-0.46.rc8.git1.fc13.x86=
_64 #1
> Call Trace:
> =C2=A0[<ffffffff8107d82d>] print_circular_bug+0xaf/0xbd
> =C2=A0[<ffffffff8107e687>] __lock_acquire+0xa31/0xd36
> =C2=A0[<ffffffff8107ea68>] lock_acquire+0xdc/0x102
> =C2=A0[<ffffffff81176709>] ? sysfs_get_dirent+0x20/0x4a
> =C2=A0[<ffffffff81010329>] ? sched_clock+0x9/0xd
> =C2=A0[<ffffffff8107109d>] ? sched_clock_local+0x1c/0x82
> =C2=A0[<ffffffff81176709>] ? sysfs_get_dirent+0x20/0x4a
> =C2=A0[<ffffffff81476fa5>] __mutex_lock_common+0x4b/0x392
> =C2=A0[<ffffffff81176709>] ? sysfs_get_dirent+0x20/0x4a
> =C2=A0[<ffffffff8107cf04>] ? mark_held_locks+0x52/0x70
> =C2=A0[<ffffffff81478ce6>] ? _raw_spin_unlock_irq+0x30/0x3c
> =C2=A0[<ffffffff8107d184>] ? trace_hardirqs_on_caller+0x111/0x135
> =C2=A0[<ffffffff814773b0>] mutex_lock_nested+0x3e/0x43
> =C2=A0[<ffffffff81176709>] sysfs_get_dirent+0x20/0x4a
> =C2=A0[<ffffffff8117828e>] sysfs_remove_group+0x2a/0xca
> =C2=A0[<ffffffff812f1169>] dpm_sysfs_remove+0x19/0x1b
> =C2=A0[<ffffffff812ea26d>] device_del+0x4c/0x1ab
> =C2=A0[<ffffffff812ea400>] device_unregister+0x34/0x5b
> =C2=A0[<ffffffff813504eb>] usb_remove_ep_devs+0x23/0x2f
> =C2=A0[<ffffffff813491e5>] remove_intf_ep_devs+0x37/0x4d
> =C2=A0[<ffffffff8134a2cc>] usb_set_interface+0x1cd/0x2dc
> =C2=A0[<ffffffffa03ddf18>] snd_usb_capture_close+0x33/0x4f [snd_usb_a=
udio]
> =C2=A0[<ffffffffa020c301>] snd_pcm_release_substream+0x53/0x82 [snd_p=
cm]
> =C2=A0[<ffffffffa020c39d>] snd_pcm_release+0x6d/0xbd [snd_pcm]
> =C2=A0[<ffffffff8111fdb6>] __fput+0x12a/0x1df
> =C2=A0[<ffffffff8111fe85>] fput+0x1a/0x1c
> =C2=A0[<ffffffff810f7f62>] remove_vma+0x56/0x8c
> =C2=A0[<ffffffff810f93a6>] do_munmap+0x310/0x332
> =C2=A0[<ffffffff810f940e>] sys_munmap+0x46/0x5d
> =C2=A0[<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
> device fsid 3546a1a7a4563c4b-2b1289f58c64988c devid 1 transid 974 /de=
v/sda7
> btrfs: failed to read the system array on sda7
> btrfs: open_ctree failed
> device fsid 3546a1a7a4563c4b-2b1289f58c64988c devid 1 transid 974 /de=
v/sda7
> device fsid 1d4372c00cc6237d-a2c61af6bc871a97 devid 1 transid 679 /de=
v/sda2
> device fsid 3546a1a7a4563c4b-2b1289f58c64988c devid 1 transid 974 /de=
v/sda7
> btrfs: failed to read the system array on sda7
> btrfs: open_ctree failed
> device fsid 3546a1a7a4563c4b-2b1289f58c64988c devid 1 transid 974 /de=
v/sda7
> btrfs: allowing degraded mounts
> Error searching slot for orphan: -5
> SELinux: (dev sda7, type btrfs) getxattr errno 5
> BUG: unable to handle kernel NULL pointer dereference at 000000000000=
0170
> IP: [<ffffffff812346a0>] do_raw_spin_trylock+0x4/0x3d
> PGD 0
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_fre=
q
> CPU 1
> Pid: 2172, comm: mount Not tainted 2.6.33-0.46.rc8.git1.fc13.x86_64 #=
1
> EM61SM/EM61PM =C2=A0 =C2=A0 =C2=A0 =C2=A0 /ASE380/AST180/APM8
> RIP: 0010:[<ffffffff812346a0>] =C2=A0[<ffffffff812346a0>]
> do_raw_spin_trylock+0x4/0x3d
> RSP: 0018:ffff88011bf35808 =C2=A0EFLAGS: 00010092
> RAX: 0000000000000000 RBX: 0000000000000170 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000170
> RBP: ffff88011bf35808 R08: 0000000000000002 R09: 0000000000000001
> R10: 0000000000000188 R11: 0000000000000000 R12: 0000000000000188
> R13: 0000000000000296 R14: 0000000000000000 R15: 0000000000000000
> FS: =C2=A000007f559f17e7e0(0000) GS:ffff880006400000(0000) knlGS:0000=
000000000000
> CS: =C2=A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000170 CR3: 000000011b159000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process mount (pid: 2172, threadinfo ffff88011bf34000, task ffff88011=
b198000)
> Stack:
> =C2=A0ffff88011bf35848 ffffffff81478537 ffffffff8122cf5b 00000009c000=
0000
> <0> ffff88011b1bc0a8 0000000000000170 0000000000000168 ffff880126e6a0=
90
> <0> ffff88011bf35868 ffffffff8122cf5b 0000000000000168 00000000000001=
c0
> Call Trace:
> =C2=A0[<ffffffff81478537>] _raw_spin_lock_irqsave+0x56/0x88
> =C2=A0[<ffffffff8122cf5b>] ? __down_read_trylock+0x16/0x4e
> =C2=A0[<ffffffff8122cf5b>] __down_read_trylock+0x16/0x4e
> =C2=A0[<ffffffff8147773f>] down_read+0x59/0x84
> =C2=A0[<ffffffffa00f8f91>] ? find_free_extent+0x2aa/0x872 [btrfs]
> =C2=A0[<ffffffffa00f8f91>] find_free_extent+0x2aa/0x872 [btrfs]
> =C2=A0[<ffffffff8107d1b5>] ? trace_hardirqs_on+0xd/0xf
> =C2=A0[<ffffffff81232dea>] ? __bitmap_weight+0x40/0x8f
> =C2=A0[<ffffffffa00f9781>] btrfs_reserve_extent+0xc8/0x156 [btrfs]
> =C2=A0[<ffffffffa00fe106>] btrfs_alloc_free_block+0x5e/0x1a0 [btrfs]
> =C2=A0[<ffffffffa00f1efe>] __btrfs_cow_block+0x103/0x34a [btrfs]
> =C2=A0[<ffffffff8107eb02>] ? print_lock_contention_bug+0x1b/0xe0
> =C2=A0[<ffffffffa00f26aa>] btrfs_cow_block+0x101/0x110 [btrfs]
> =C2=A0[<ffffffffa0106866>] commit_cowonly_roots+0x59/0x198 [btrfs]
> =C2=A0[<ffffffffa0107b76>] btrfs_commit_transaction+0x391/0x633 [btrf=
s]
> =C2=A0[<ffffffff8106ba2e>] ? autoremove_wake_function+0x0/0x39
> =C2=A0[<ffffffffa0107304>] ? start_transaction+0x124/0x130 [btrfs]
> =C2=A0[<ffffffffa00ee9c2>] btrfs_sync_fs+0x65/0x69 [btrfs]
> =C2=A0[<ffffffff81165eb9>] sync_quota_sb+0x53/0x108
> =C2=A0[<ffffffff8113ea51>] __sync_filesystem+0x46/0x77
> =C2=A0[<ffffffff8113ec45>] sync_filesystem+0x52/0x56
> =C2=A0[<ffffffff81227dcd>] ? _atomic_dec_and_lock+0x41/0x64
> =C2=A0[<ffffffff81120acd>] generic_shutdown_super+0x27/0xce
> =C2=A0[<ffffffff81120bc9>] kill_anon_super+0x16/0x55
> =C2=A0[<ffffffff81120c98>] deactivate_locked_super+0x64/0x84
> =C2=A0[<ffffffff81120dea>] vfs_kern_mount+0x132/0x168
> =C2=A0[<ffffffff81120e88>] do_kern_mount+0x4d/0xed
> =C2=A0[<ffffffff81137062>] do_mount+0x787/0x7fe
> =C2=A0[<ffffffff8110926e>] ? alloc_pages_current+0x95/0x9e
> =C2=A0[<ffffffff81137161>] sys_mount+0x88/0xc2
> =C2=A0[<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
> Code: 5f c9 c3 55 48 89 e5 eb 12 8a 07 ff ca 3a 06 74 04 31 c0 eb 0f
> 48 ff c7 48 ff c6 85 d2 75 ea b8 01 00 00 00 c9 c3 90 55 48 89 e5 <8b=
>
> 07 89 c2 c1 c0 10 39 c2 8d 90 00 00 01 00 75 04 f0 0f b1 17
> RIP =C2=A0[<ffffffff812346a0>] do_raw_spin_trylock+0x4/0x3d
> =C2=A0RSP <ffff88011bf35808>
> CR2: 0000000000000170
> ---[ end trace 78570ae6fbb00237 ]---
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
