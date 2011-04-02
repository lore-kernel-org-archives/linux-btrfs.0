From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: 2.6.39-rc1: kernel BUG at fs/btrfs/extent-tree.c:5479!
Date: Sat, 2 Apr 2011 15:55:45 +0300
Message-ID: <20110402155545.2159043a@sf.home>
References: <20110402121946.6bf27f80@sf.home>
	<4D96EE76.5040208@cn.fujitsu.com>
	<20110402134132.0391f4fd@sf.home>
	<4D9708E0.6030206@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/n1NNmNZ7cUhmug9+Sl3aXqT"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
	Arne Jansen <sensille@gmx.net>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D9708E0.6030206@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/n1NNmNZ7cUhmug9+Sl3aXqT
Content-Type: multipart/mixed; boundary="MP_/+gCw4NQP6CN_U9bWM5_yRBF"

--MP_/+gCw4NQP6CN_U9bWM5_yRBF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sat, 02 Apr 2011 19:30:40 +0800
liubo <liubo2009@cn.fujitsu.com> wrote:

> On 04/02/2011 06:41 PM, Sergei Trofimovich wrote:
> > On Sat, 02 Apr 2011 17:37:58 +0800
> > liubo <liubo2009@cn.fujitsu.com> wrote:
> >=20
> >> On 04/02/2011 05:19 PM, Sergei Trofimovich wrote:
> >>> The partition is a physical ~5GB --mixed lzo compressed partition.
> >>>
> >>> The kernel 2.6.39-rc1 + reverted commit c59021f846881a957ac5afe456d0f=
59d6a517b61.
> >>> (see http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg09083=
.html)
> >>>
> >> Hi, Sergei,
> >>
> >> I'm digging this...
> >>
> >> Can u show me steps to reproduce this?
> >=20
> > I use the filesystem as a storage of large CVS tree and
> > as temp storage for large compilations, so I can roughly
> > describe what I did and when it failed.
> >=20
> > I've formatter btrfs 5G partition as --mixed and mounter it with lzo co=
mpression
> > on the kernel of version 'v2.6.38-4148-g054cfaa', then checked out there
> > large CVS tree (~170K files, weights 177MB), copied there linux source =
(not built)
> > and copied my '/var/'. I ran compiles there and started to get -ENOSPC
> > OOpses when 'df -h' reported 3.5G free.
> >=20
> > As Linus pulled josef's changes, so I've updated to v2.6.38-6555-ga44f9=
9c
> > and kernel started to OOps right after mount (added assert started to t=
rigger earlier).
> > I've reported it to this ML (link above). josef and sensille helped me =
to debug what's
> > going wrong [both CCed]. sensille pointed to the commit, which is guilt=
y to miscomputing
> > available space. As I understood they know what exactly screwed up.
> >=20
>=20
> Great thanks for these details.
>=20
> I did not consider the "mix" case when making the guilty patch, sorry.
> Frankly, I'm still trying to reproduce your first bug, and on my box "mix=
 + lzo" does not cause bug...
>=20
> Seems that you are using opensuse's kernel.

I use only Linus's mainline kernels. I'll try to cook-up some deterministic=
 script
to torture filesystem and reproduce that OOps.

> > The second case (this one):
> > I still use the same filesystem (didn't reformat, so it might carry som=
e corruption
> > after debugging patches).
> > I've reverted your change c59021f846881a957ac5afe456d0f59d6a517b61
> > and made sure it stops OOpsing for me, then updated to 2.6.39-rc1
> > and reverted only this commit. Filesystem became usable until I've deci=
ded
> > to run large compile on it (clang debug source).
> >=20
> > I think at the time of OOps the following things did happen simultaneou=
sly:
> >=20
> > 1. one process was splitting debug symbols of some binary:
> >   - opened original binary for read
> >   - write to new file (stripped binary)
> >   - write debug symbols to separate file
> >=20
> > 2. another process logged that action to log file
> >=20
> > 3. the filesystem filled-up and OOpsed. At the time of OOps
> >    'df -h' showed 200M free.
> >=20
> > I'm trying to reproduce this second case ATM (build takes
> > more, that an hour).

Right after reboot I've decided to fill that partition even more
and see what happens (didn't remove temporary clang build).

I have tried to copy to the partition (there was ~500M free reported by df)
a bunch of small object files until 'cp' will report out-of-space,=20
hen attempted to copy a bit more of small files until I get bored.
Nothing bad did happen.

Then I've decided to delete files I copied and temporray clang-built files
on FS and kernel OOpsed:

[69392.216454] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000030
[69392.216493] IP: [<ffffffffa02352c7>] btrfs_print_leaf+0x27/0x890 [btrfs]
[69392.216537] PGD 0=20
[69392.216547] Oops: 0000 [#1] PREEMPT SMP=20
[69392.216562] last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent
[69392.216575] CPU 0=20
[69392.216581] Modules linked in: bridge stp llc btrfs zlib_deflate lzo_dec=
ompress lzo_compress crc32c libcrc32c tun kvm_amd kvm fuse nouveau ttm drm_=
kms_helpe
r 8139cp drm i2c_algo_bit i2c_core 8139too cfbcopyarea cfbimgblt cfbfillrec=
t forcedeth
[69392.216668]=20
[69392.216675] Pid: 22974, comm: rm Not tainted 2.6.39-rc1+ #2 To Be Filled=
 By O.E.M. To Be Filled By O.E.M./ALiveNF6G-VSTA
[69392.216699] RIP: 0010:[<ffffffffa02352c7>]  [<ffffffffa02352c7>] btrfs_p=
rint_leaf+0x27/0x890 [btrfs]
[69392.216724] RSP: 0018:ffff880060111aa8  EFLAGS: 00010283
[69392.216734] RAX: 00000000ffffffe4 RBX: 0000000000000000 RCX: 00000000fff=
fffe4
[69392.216746] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00001
[69392.216757] RBP: ffff880060111b28 R08: 0000000000000000 R09: 00000000000=
00000
[69392.216769] R10: ffffffffffffffe4 R11: 0000000000000002 R12: 00000000000=
00005
[69392.216781] R13: ffff880077397800 R14: 0000000000000000 R15: 0000000000a=
64000
[69392.216794] FS:  00007f4b0cb06700(0000) GS:ffff88007bc00000(0000) knlGS:=
00000000f68c1b20
[69392.216807] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[69392.216817] CR2: 0000000000000030 CR3: 000000000f2e6000 CR4: 00000000000=
006f0
[69392.216829] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[69392.216840] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[69392.216853] Process rm (pid: 22974, threadinfo ffff880060110000, task ff=
ff88002994d840)
[69392.216865] Stack:
[69392.216871]  00000000d3750000 ffffffffa0261114 ffff880077397800 00000000=
d3693000
[69392.216890]  ffff880060111b28 ffff880072158ab0 00000000d3750000 00000000=
003000a8
[69392.216910]  ffff880060111b00 ffffffff810d2937 ffff88001a5c9ea0 ffff8800=
72158ab0
[69392.216929] Call Trace:
[69392.216953]  [<ffffffffa0261114>] ? set_extent_dirty+0x24/0x30 [btrfs]
[69392.216968]  [<ffffffff810d2937>] ? kmem_cache_alloc+0x97/0xb0
[69392.216985]  [<ffffffffa022d777>] __btrfs_free_extent+0x647/0x700 [btrfs]
[69392.216999]  [<ffffffff8103b351>] ? get_parent_ip+0x11/0x50
[69392.217006]  [<ffffffff8103b351>] ? get_parent_ip+0x11/0x50
[69392.217006]  [<ffffffffa023007b>] run_clustered_refs+0x21b/0x860 [btrfs]
[69392.217006]  [<ffffffffa022f73e>] ? btrfs_free_extent+0x4e/0xd0 [btrfs]
[69392.217006]  [<ffffffffa0280b00>] ? btrfs_find_ref_cluster+0xe0/0x180 [b=
trfs]
[69392.217006]  [<ffffffffa0230780>] btrfs_run_delayed_refs+0xc0/0x210 [btr=
fs]
[69392.217006]  [<ffffffffa0241ca8>] __btrfs_end_transaction+0x68/0x220 [bt=
rfs]
[69392.217006]  [<ffffffffa0241ea0>] btrfs_end_transaction+0x10/0x20 [btrfs]
[69392.217006]  [<ffffffffa024b75f>] btrfs_evict_inode+0x19f/0x1f0 [btrfs]
[69392.217006]  [<ffffffff810fa2d0>] evict+0x80/0x160
[69392.217006]  [<ffffffff810fa4e2>] iput+0xe2/0x1b0
[69392.217006]  [<ffffffff810ef68b>] do_unlinkat+0x10b/0x1b0
[69392.217006]  [<ffffffff8111727b>] ? fsnotify_find_inode_mark+0x3b/0x50
[69392.217006]  [<ffffffff810dff91>] ? filp_close+0x61/0x90
[69392.217006]  [<ffffffff810f0c0d>] sys_unlinkat+0x1d/0x40
[69392.217006]  [<ffffffff81574c3b>] system_call_fastpath+0x16/0x1b
[69392.217006] Code: 00 00 00 00 55 48 89 e5 48 83 c4 80 4c 89 6d e8 49 89 =
fd bf 01 00 00 00 48 89 5d d8 4c 89 65 e0 48 89 f3 4c 89 75 f0 4c 89 7d f8 =
<4c> 8b 6
6 30 e8 90 61 e0 e0 48 b8 00 00 00 00 00 16 00 00 49 01=20
[69392.217006] RIP  [<ffffffffa02352c7>] btrfs_print_leaf+0x27/0x890 [btrfs]
[69392.217006]  RSP <ffff880060111aa8>
[69392.217006] CR2: 0000000000000030
[69392.220992] ---[ end trace 3cfc7af696ff077b ]---

Full dmesg is in attach. Same kernel, same partition.

--=20

  Sergei

--MP_/+gCw4NQP6CN_U9bWM5_yRBF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=ooops-2011-04-02-2.6.39-rc1-revert-c5902-attempt-to-rm.txt

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.39-rc1+ (st@st) (gcc version 4.5.2 (Gentoo=
 Hardened 4.5.2 p1.0, pie-0.4.5) ) #2 SMP PREEMPT Wed Mar 30 11:43:32 EEST =
2011
[    0.000000] Command line: BOOT_IMAGE=3D(hd0,5)/vmlinuz root=3D/dev/sda7 =
ro
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007bfb0000 (usable)
[    0.000000]  BIOS-e820: 000000007bfb0000 - 000000007bfc0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007bfc0000 - 000000007bff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007bff0000 - 000000007c000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: To Be Filled By O.E.M. To Be Filled By O.E.M./ALiveNF6G=
-VSTA, BIOS P1.50 05/04/2007
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x7bfb0 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-000000007bfb0000
[    0.000000]  0000000000 - 007be00000 page 2M
[    0.000000]  007be00000 - 007bfb0000 page 4k
[    0.000000] kernel direct mapping tables up to 7bfb0000 @ 7bfac000-7bfb0=
000
[    0.000000] ACPI: RSDP 00000000000fa860 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 000000007bfb0000 0003C (v01 A_M_I  OEMRSDT  05000=
704 MSFT 00000097)
[    0.000000] ACPI: FACP 000000007bfb0200 00084 (v02 A M I  OEMFACP  12000=
601 MSFT 00000097)
[    0.000000] ACPI: DSDT 000000007bfb0440 04C5F (v01  ALV6V ALV6V141 00000=
141 INTL 20051117)
[    0.000000] ACPI: FACS 000000007bfc0000 00040
[    0.000000] ACPI: APIC 000000007bfb0390 00070 (v01 A_M_I  OEMAPIC  05000=
704 MSFT 00000097)
[    0.000000] ACPI: MCFG 000000007bfb0400 0003C (v01 A_M_I  OEMMCFG  05000=
704 MSFT 00000097)
[    0.000000] ACPI: OEMB 000000007bfc0040 00060 (v01 A_M_I  AMI_OEM  05000=
704 MSFT 00000097)
[    0.000000] ACPI: HPET 000000007bfb50a0 00038 (v01 A_M_I  OEMHPET0 05000=
704 MSFT 00000097)
[    0.000000] ACPI: SSDT 000000007bfb50e0 00206 (v01 A M I  POWERNOW 00000=
001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff88007960000=
0-ffff88007b1fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007bfb0
[    0.000000] On node 0 totalpages: 507711
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6887 pages used for memmap
[    0.000000]   DMA32 zone: 496841 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] Allocating PCI resources starting at 7c000000 (gap: 7c000000=
:82c00000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88007bc00000 s74432 r8192=
 d23872 u1048576
[    0.000000] pcpu-alloc: s74432 r8192 d23872 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 500763
[    0.000000] Kernel command line: BOOT_IMAGE=3D(hd0,5)/vmlinuz root=3D/de=
v/sda7 ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 b=
ytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 by=
tes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 394000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Memory: 1986716k/2031296k available (5600k kernel code, 452k=
 absent, 44128k reserved, 5279k data, 464k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2109.784 MHz processor.
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.002164] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4219.56 BogoMIPS (lpj=3D2109784)
[    0.002463] pid_max: default: 32768 minimum: 301
[    0.002671] Mount-cache hash table entries: 256
[    0.002999] Initializing cgroup subsys ns
[    0.003004] ns_cgroup deprecated: consider using the 'clone_children' fl=
ag without the ns_cgroup.
[    0.003293] Initializing cgroup subsys cpuacct
[    0.003459] Initializing cgroup subsys memory
[    0.003618] Initializing cgroup subsys devices
[    0.003766] Initializing cgroup subsys freezer
[    0.003934] tseg: 0000000000
[    0.003948] CPU: Physical Processor ID: 0
[    0.004002] CPU: Processor Core ID: 0
[    0.004149] mce: CPU supports 5 MCE banks
[    0.004306] using C1E aware idle routine
[    0.004480] ACPI: Core revision 20110316
[    0.007549] Setting APIC routing to flat
[    0.008179] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.018336] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4000+ steppin=
g 01
[    0.018998] Performance Events: AMD PMU driver.
[    0.018998] ... version:                0
[    0.018998] ... bit width:              48
[    0.018998] ... generic registers:      4
[    0.018998] ... value mask:             0000ffffffffffff
[    0.018998] ... max period:             00007fffffffffff
[    0.018998] ... fixed-purpose events:   0
[    0.019000] ... event mask:             000000000000000f
[    0.031016] Booting Node   0, Processors  #1 Ok.
[    0.031188] smpboot cpu 1: start_ip =3D 9a000
[    0.102071] Brought up 2 CPUs
[    0.102217] Total of 2 processors activated (8438.80 BogoMIPS).
[    0.103144] NET: Registered protocol family 16
[    0.103322] node 0 link 0: io port [1000, ffffff]
[    0.103322] TOM: 0000000080000000 aka 2048M
[    0.103322] node 0 link 0: mmio [e0000000, efffffff]
[    0.103322] node 0 link 0: mmio [a0000, bffff]
[    0.103322] node 0 link 0: mmio [80000000, fe0bffff]
[    0.103322] bus: [00, ff] on node 0 link 0
[    0.103322] bus: 00 index 0 [io  0x0000-0xffff]
[    0.103322] bus: 00 index 1 [mem 0x80000000-0xfcffffffff]
[    0.103322] bus: 00 index 2 [mem 0x000a0000-0x000bffff]
[    0.103322] ACPI: bus type pci registered
[    0.104044] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000=
-0xefffffff] (base 0xe0000000)
[    0.104322] PCI: not using MMCONFIG
[    0.104471] PCI: Using configuration type 1 for base access
[    0.112061] bio: create slab <bio-0> at 0
[    0.113889] ACPI: EC: Look up EC in DSDT
[    0.115572] ACPI: Executed 1 blocks of module-level executable AML code
[    0.118279] ACPI: Interpreter enabled
[    0.118443] ACPI: (supports S0 S1 S3 S5)
[    0.118710] ACPI: Using IOAPIC for interrupt routing
[    0.118888] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000=
-0xefffffff] (base 0xe0000000)
[    0.120268] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACP=
I motherboard resources
[    0.151168] ACPI: No dock devices found.
[    0.152035] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    0.152506] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.152829] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    0.152833] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    0.152836] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    0.152839] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x00=
0dffff] (ignored)
[    0.152841] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xff=
37ffff] (ignored)
[    0.152868] pci 0000:00:00.0: [10de:03ea] type 0 class 0x000500
[    0.153044] pci 0000:00:01.0: [10de:03e0] type 0 class 0x000601
[    0.153086] pci 0000:00:01.1: [10de:03eb] type 0 class 0x000c05
[    0.153099] pci 0000:00:01.1: reg 10: [io  0xdc00-0xdc3f]
[    0.153116] pci 0000:00:01.1: reg 20: [io  0x5000-0x503f]
[    0.153122] pci 0000:00:01.1: reg 24: [io  0x6000-0x603f]
[    0.153144] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.153150] pci 0000:00:01.1: PME# disabled
[    0.153161] pci 0000:00:01.2: [10de:03f5] type 0 class 0x000500
[    0.153206] pci 0000:00:02.0: [10de:03f1] type 0 class 0x000c03
[    0.153216] pci 0000:00:02.0: reg 10: [mem 0xdfeff000-0xdfefffff]
[    0.153249] pci 0000:00:02.0: supports D1 D2
[    0.153251] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.153255] pci 0000:00:02.0: PME# disabled
[    0.153270] pci 0000:00:02.1: [10de:03f2] type 0 class 0x000c03
[    0.153282] pci 0000:00:02.1: reg 10: [mem 0xdfefec00-0xdfefecff]
[    0.153319] pci 0000:00:02.1: supports D1 D2
[    0.153321] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.153325] pci 0000:00:02.1: PME# disabled
[    0.153345] pci 0000:00:04.0: [10de:03f3] type 1 class 0x000604
[    0.153384] pci 0000:00:05.0: [10de:03f0] type 0 class 0x000403
[    0.153396] pci 0000:00:05.0: reg 10: [mem 0xdfef8000-0xdfefbfff]
[    0.153434] pci 0000:00:05.0: PME# supported from D3hot D3cold
[    0.153437] pci 0000:00:05.0: PME# disabled
[    0.153457] pci 0000:00:06.0: [10de:03ec] type 0 class 0x000101
[    0.153481] pci 0000:00:06.0: reg 20: [io  0xffa0-0xffaf]
[    0.153510] pci 0000:00:07.0: [10de:03ef] type 0 class 0x000680
[    0.153522] pci 0000:00:07.0: reg 10: [mem 0xdfefd000-0xdfefdfff]
[    0.153527] pci 0000:00:07.0: reg 14: [io  0xd480-0xd487]
[    0.153557] pci 0000:00:07.0: supports D1 D2
[    0.153560] pci 0000:00:07.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.153564] pci 0000:00:07.0: PME# disabled
[    0.153578] pci 0000:00:08.0: [10de:03f6] type 0 class 0x000101
[    0.153588] pci 0000:00:08.0: reg 10: [io  0x0e00-0x0e07]
[    0.153594] pci 0000:00:08.0: reg 14: [io  0x0e20-0x0e23]
[    0.153599] pci 0000:00:08.0: reg 18: [io  0x0e40-0x0e47]
[    0.153605] pci 0000:00:08.0: reg 1c: [io  0x0e60-0x0e63]
[    0.153610] pci 0000:00:08.0: reg 20: [io  0xc880-0xc88f]
[    0.153616] pci 0000:00:08.0: reg 24: [mem 0xdfefc000-0xdfefcfff]
[    0.153642] pci 0000:00:08.1: [10de:03f6] type 0 class 0x000101
[    0.153652] pci 0000:00:08.1: reg 10: [io  0x0e80-0x0e87]
[    0.153657] pci 0000:00:08.1: reg 14: [io  0x0ea0-0x0ea3]
[    0.153663] pci 0000:00:08.1: reg 18: [io  0x0ec0-0x0ec7]
[    0.153668] pci 0000:00:08.1: reg 1c: [io  0x0ee0-0x0ee3]
[    0.153674] pci 0000:00:08.1: reg 20: [io  0xc000-0xc00f]
[    0.153679] pci 0000:00:08.1: reg 24: [mem 0xdfef7000-0xdfef7fff]
[    0.153711] pci 0000:00:09.0: [10de:03e8] type 1 class 0x000604
[    0.153736] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.153739] pci 0000:00:09.0: PME# disabled
[    0.153754] pci 0000:00:0b.0: [10de:03e9] type 1 class 0x000604
[    0.153778] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.153781] pci 0000:00:0b.0: PME# disabled
[    0.153795] pci 0000:00:0c.0: [10de:03e9] type 1 class 0x000604
[    0.153819] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.153822] pci 0000:00:0c.0: PME# disabled
[    0.153835] pci 0000:00:0d.0: [10de:03d0] type 0 class 0x000300
[    0.153843] pci 0000:00:0d.0: reg 10: [mem 0xde000000-0xdeffffff]
[    0.153850] pci 0000:00:0d.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit p=
ref]
[    0.153857] pci 0000:00:0d.0: reg 1c: [mem 0xdd000000-0xddffffff 64bit]
[    0.153864] pci 0000:00:0d.0: reg 30: [mem 0xdfec0000-0xdfedffff pref]
[    0.153890] pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
[    0.153910] pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
[    0.153926] pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
[    0.153943] pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
[    0.153966] PCI: peer root bus 00 res updated from pci conf
[    0.154062] pci 0000:01:08.0: [10ec:8139] type 0 class 0x000200
[    0.154077] pci 0000:01:08.0: reg 10: [io  0xe800-0xe8ff]
[    0.154085] pci 0000:01:08.0: reg 14: [mem 0xdffffc00-0xdffffcff]
[    0.154129] pci 0000:01:08.0: supports D1 D2
[    0.154132] pci 0000:01:08.0: PME# supported from D1 D2 D3hot
[    0.154137] pci 0000:01:08.0: PME# disabled
[    0.154164] pci 0000:00:04.0: PCI bridge to [bus 01-01] (subtractive dec=
ode)
[    0.154322] pci 0000:00:04.0:   bridge window [io  0xe000-0xefff]
[    0.154326] pci 0000:00:04.0:   bridge window [mem 0xdff00000-0xdfffffff]
[    0.154330] pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.154333] pci 0000:00:04.0:   bridge window [io  0x0000-0xffff] (subtr=
active decode)
[    0.154336] pci 0000:00:04.0:   bridge window [mem 0x80000000-0xfcffffff=
ff] (subtractive decode)
[    0.154339] pci 0000:00:04.0:   bridge window [mem 0x000a0000-0x000bffff=
] (subtractive decode)
[    0.154364] pci 0000:00:09.0: PCI bridge to [bus 02-02]
[    0.154518] pci 0000:00:09.0:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.154522] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.154526] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.154549] pci 0000:00:0b.0: PCI bridge to [bus 03-03]
[    0.154703] pci 0000:00:0b.0:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.154707] pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.154711] pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.154735] pci 0000:00:0c.0: PCI bridge to [bus 04-04]
[    0.154891] pci 0000:00:0c.0:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.154894] pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.154898] pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.154908] pci_bus 0000:00: on NUMA node 0
[    0.154912] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.155062] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.155122] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.155160] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.155284]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.155578]  pci0000:00: ACPI _OSC control (0x1d) granted
[    0.161252] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *10
[    0.162066] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disab=
led.
[    0.162492] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disab=
led.
[    0.163007] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disab=
led.
[    0.163426] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disab=
led.
[    0.163838] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *0, disab=
led.
[    0.164251] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disab=
led.
[    0.164662] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0, disab=
led.
[    0.165086] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[    0.165474] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[    0.165869] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *11
[    0.166276] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *10
[    0.166665] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disab=
led.
[    0.167062] ACPI: PCI Interrupt Link [LMC9] (IRQs 20 21 22 23) *10
[    0.167453] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.167858] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disab=
led.
[    0.168310] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *5
[    0.168705] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *10
[    0.169079] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disab=
led.
[    0.169436] vgaarb: device added: PCI:0000:00:0d.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.169436] vgaarb: loaded
[    0.170067] SCSI subsystem initialized
[    0.170166] libata version 3.00 loaded.
[    0.170166] usbcore: registered new interface driver usbfs
[    0.171009] usbcore: registered new interface driver hub
[    0.171162] usbcore: registered new device driver usb
[    0.171169] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.171175] PCI: Using ACPI for IRQ routing
[    0.171999] PCI: pci_cache_line_size set to 64 bytes
[    0.172068] reserve RAM buffer: 000000000009fc00 - 000000000009ffff=20
[    0.172072] reserve RAM buffer: 000000007bfb0000 - 000000007bffffff=20
[    0.172093] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.172205] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.172453] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.178036] Switching to clocksource hpet
[    0.178266] pnp: PnP ACPI init
[    0.178266] ACPI: bus type pnp registered
[    0.178535] pnp 00:00: [bus 00-ff]
[    0.178538] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.178541] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.178543] pnp 00:00: [io  0x0d00-0xffff window]
[    0.178546] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.178552] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.178554] pnp 00:00: [mem 0x80000000-0xff37ffff window]
[    0.178680] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.178702] pnp 00:01: [dma 4]
[    0.178704] pnp 00:01: [io  0x0000-0x000f]
[    0.178707] pnp 00:01: [io  0x0081-0x0083]
[    0.178709] pnp 00:01: [io  0x0087]
[    0.178711] pnp 00:01: [io  0x0089-0x008b]
[    0.178713] pnp 00:01: [io  0x008f]
[    0.178716] pnp 00:01: [io  0x00c0-0x00df]
[    0.178741] Switched to NOHz mode on CPU #0
[    0.178791] Switched to NOHz mode on CPU #1
[    0.179121] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.179134] pnp 00:02: [io  0x0070-0x0071]
[    0.179150] pnp 00:02: [irq 8]
[    0.179214] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.179225] pnp 00:03: [io  0x0061]
[    0.179292] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.179303] pnp 00:04: [io  0x00f0-0x00ff]
[    0.179312] pnp 00:04: [irq 13]
[    0.179377] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.180205] pnp 00:05: [mem 0x000d0000-0x000d3fff window]
[    0.180208] pnp 00:05: [mem 0x000d4000-0x000d7fff window]
[    0.180211] pnp 00:05: [mem 0x000de000-0x000dffff window]
[    0.180213] pnp 00:05: [io  0x0010-0x001f]
[    0.180215] pnp 00:05: [io  0x0022-0x003f]
[    0.180218] pnp 00:05: [io  0x0044-0x005f]
[    0.180220] pnp 00:05: [io  0x0062-0x0063]
[    0.180222] pnp 00:05: [io  0x0065-0x006f]
[    0.180225] pnp 00:05: [io  0x0072-0x007f]
[    0.180227] pnp 00:05: [io  0x0080]
[    0.180229] pnp 00:05: [io  0x0084-0x0086]
[    0.180232] pnp 00:05: [io  0x0088]
[    0.180234] pnp 00:05: [io  0x008c-0x008e]
[    0.180236] pnp 00:05: [io  0x0090-0x009f]
[    0.180239] pnp 00:05: [io  0x00a2-0x00bf]
[    0.180241] pnp 00:05: [io  0x00e0-0x00ef]
[    0.180243] pnp 00:05: [io  0x04d0-0x04d1]
[    0.180245] pnp 00:05: [io  0x0800-0x080f]
[    0.180248] pnp 00:05: [io  0x4000-0x407f]
[    0.180250] pnp 00:05: [io  0x4080-0x40ff]
[    0.180253] pnp 00:05: [io  0x4400-0x447f]
[    0.180255] pnp 00:05: [io  0x4480-0x44ff]
[    0.180258] pnp 00:05: [io  0x4800-0x487f]
[    0.180260] pnp 00:05: [io  0x4880-0x48ff]
[    0.180262] pnp 00:05: [io  0x2000-0x207f]
[    0.180264] pnp 00:05: [io  0x2080-0x20ff]
[    0.180267] pnp 00:05: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.180270] pnp 00:05: [mem 0xfefe0000-0xfefe01ff]
[    0.180276] pnp 00:05: [mem 0xfefe1000-0xfefe1fff]
[    0.180278] pnp 00:05: [mem 0xfee01000-0xfeefffff]
[    0.180421] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.180576] system 00:05: [io  0x0800-0x080f] has been reserved
[    0.180730] system 00:05: [io  0x4000-0x407f] has been reserved
[    0.180884] system 00:05: [io  0x4080-0x40ff] has been reserved
[    0.181076] system 00:05: [io  0x4400-0x447f] has been reserved
[    0.181241] system 00:05: [io  0x4480-0x44ff] has been reserved
[    0.181406] system 00:05: [io  0x4800-0x487f] has been reserved
[    0.181558] system 00:05: [io  0x4880-0x48ff] has been reserved
[    0.181714] system 00:05: [io  0x2000-0x207f] has been reserved
[    0.181868] system 00:05: [io  0x2080-0x20ff] has been reserved
[    0.182034] system 00:05: [mem 0x000d0000-0x000d3fff window] has been re=
served
[    0.182310] system 00:05: [mem 0x000d4000-0x000d7fff window] has been re=
served
[    0.182585] system 00:05: [mem 0x000de000-0x000dffff window] has been re=
served
[    0.182861] system 00:05: [mem 0xfefe0000-0xfefe01ff] has been reserved
[    0.186527] system 00:05: [mem 0xfefe1000-0xfefe1fff] has been reserved
[    0.186681] system 00:05: [mem 0xfee01000-0xfeefffff] has been reserved
[    0.186835] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.186901] pnp 00:06: [mem 0xfed00000-0xfed00fff]
[    0.186972] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.187035] pnp 00:07: [mem 0xfec00000-0xfec00fff]
[    0.187038] pnp 00:07: [mem 0xfee00000-0xfee00fff]
[    0.187130] system 00:07: [mem 0xfec00000-0xfec00fff] could not be reser=
ved
[    0.187284] system 00:07: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.187436] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.187468] pnp 00:08: [io  0x0060]
[    0.187470] pnp 00:08: [io  0x0064]
[    0.187480] pnp 00:08: [irq 1]
[    0.187547] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (a=
ctive)
[    0.187742] pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
[    0.187745] pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
[    0.187748] pnp 00:09: [io  0x0290-0x029f]
[    0.187842] system 00:09: [io  0x0290-0x029f] has been reserved
[    0.187994] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.188056] pnp 00:0a: [mem 0xe0000000-0xefffffff]
[    0.188149] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.188304] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.188488] pnp 00:0b: [mem 0x00000000-0x0009ffff]
[    0.188491] pnp 00:0b: [mem 0x000c0000-0x000cffff]
[    0.188493] pnp 00:0b: [mem 0x000e0000-0x000fffff]
[    0.188496] pnp 00:0b: [mem 0x00100000-0x7fffffff]
[    0.188498] pnp 00:0b: [mem 0xff380000-0xffffffff]
[    0.188612] system 00:0b: [mem 0x00000000-0x0009ffff] could not be reser=
ved
[    0.188765] system 00:0b: [mem 0x000c0000-0x000cffff] has been reserved
[    0.188917] system 00:0b: [mem 0x000e0000-0x000fffff] could not be reser=
ved
[    0.189084] system 00:0b: [mem 0x00100000-0x7fffffff] could not be reser=
ved
[    0.189236] system 00:0b: [mem 0xff380000-0xffffffff] has been reserved
[    0.189389] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.189688] pnp: PnP ACPI: found 12 devices
[    0.189836] ACPI: ACPI bus type pnp unregistered
[    0.199394] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.199568] pci 0000:00:04.0:   bridge window [io  0xe000-0xefff]
[    0.199733] pci 0000:00:04.0:   bridge window [mem 0xdff00000-0xdfffffff]
[    0.199894] pci 0000:00:04.0:   bridge window [mem pref disabled]
[    0.200058] pci 0000:00:09.0: PCI bridge to [bus 02-02]
[    0.200206] pci 0000:00:09.0:   bridge window [io  disabled]
[    0.200357] pci 0000:00:09.0:   bridge window [mem disabled]
[    0.200509] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    0.200661] pci 0000:00:0b.0: PCI bridge to [bus 03-03]
[    0.200810] pci 0000:00:0b.0:   bridge window [io  disabled]
[    0.200960] pci 0000:00:0b.0:   bridge window [mem disabled]
[    0.201117] pci 0000:00:0b.0:   bridge window [mem pref disabled]
[    0.201269] pci 0000:00:0c.0: PCI bridge to [bus 04-04]
[    0.201424] pci 0000:00:0c.0:   bridge window [io  disabled]
[    0.201591] pci 0000:00:0c.0:   bridge window [mem disabled]
[    0.201751] pci 0000:00:0c.0:   bridge window [mem pref disabled]
[    0.201912] pci 0000:00:04.0: setting latency timer to 64
[    0.201918] pci 0000:00:09.0: setting latency timer to 64
[    0.201923] pci 0000:00:0b.0: setting latency timer to 64
[    0.201929] pci 0000:00:0c.0: setting latency timer to 64
[    0.201933] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.201936] pci_bus 0000:00: resource 5 [mem 0x80000000-0xfcffffffff]
[    0.201939] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.201942] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.201944] pci_bus 0000:01: resource 1 [mem 0xdff00000-0xdfffffff]
[    0.201947] pci_bus 0000:01: resource 4 [io  0x0000-0xffff]
[    0.201950] pci_bus 0000:01: resource 5 [mem 0x80000000-0xfcffffffff]
[    0.201952] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    0.202017] NET: Registered protocol family 2
[    0.202253] IP route cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.202964] IPv4 FIB: Using LC-trie version 0.409
[    0.203272] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.206041] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.206853] TCP: Hash tables configured (established 262144 bind 65536)
[    0.207065] TCP reno registered
[    0.207226] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.207400] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.207703] NET: Registered protocol family 1
[    0.208017] RPC: Registered udp transport module.
[    0.208183] RPC: Registered tcp transport module.
[    0.208339] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.732903] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.733112] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.733322] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.733531] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.733741] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.733954] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.734181] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.734404] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.734559] pci 0000:00:0d.0: Boot video device
[    0.734571] PCI: CLS 64 bytes, default 64
[    0.736822] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.743985] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.744640] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.749201] SGI XFS with ACLs, security attributes, large block/inode nu=
mbers, no debug enabled
[    0.750545] SGI XFS Quota Management subsystem
[    0.750717] msgmni has been set to 3880
[    0.751377] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.751676] io scheduler noop registered
[    0.751919] io scheduler cfq registered (default)
[    0.752242] pcieport 0000:00:09.0: setting latency timer to 64
[    0.752270] pcieport 0000:00:09.0: irq 40 for MSI/MSI-X
[    0.752409] pcieport 0000:00:0b.0: setting latency timer to 64
[    0.752429] pcieport 0000:00:0b.0: irq 41 for MSI/MSI-X
[    0.752565] pcieport 0000:00:0c.0: setting latency timer to 64
[    0.752584] pcieport 0000:00:0c.0: irq 42 for MSI/MSI-X
[    0.753188] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
C:00/input/input0
[    0.753492] ACPI: Power Button [PWRB]
[    0.753738] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input1
[    0.754063] ACPI: Power Button [PWRF]
[    0.754335] ACPI: acpi_idle registered with cpuidle
[    0.757338] Linux agpgart interface v0.103
[    3.776268] floppy0: no floppy controllers found
[    3.777914] loop: module loaded
[    3.778895] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    3.779265] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    3.779481] megasas: 00.00.05.34-rc1 Thu. Feb. 24 17:00:00 PDT 2011
[    3.779837] sata_nv 0000:00:08.0: version 3.5
[    3.780041] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    3.780214] sata_nv 0000:00:08.0: PCI INT A -> Link[LSA0] -> GSI 23 (lev=
el, low) -> IRQ 23
[    3.780561] sata_nv 0000:00:08.0: setting latency timer to 64
[    3.781087] scsi0 : sata_nv
[    3.781514] scsi1 : sata_nv
[    3.781929] ata1: SATA max UDMA/133 cmd 0xe00 ctl 0xe20 bmdma 0xc880 irq=
 23
[    3.782113] ata2: SATA max UDMA/133 cmd 0xe40 ctl 0xe60 bmdma 0xc888 irq=
 23
[    3.782426] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
[    3.782596] sata_nv 0000:00:08.1: PCI INT B -> Link[LSA1] -> GSI 22 (lev=
el, low) -> IRQ 22
[    3.782906] sata_nv 0000:00:08.1: setting latency timer to 64
[    3.783574] scsi2 : sata_nv
[    3.783899] scsi3 : sata_nv
[    3.784409] ata3: SATA max UDMA/133 cmd 0xe80 ctl 0xea0 bmdma 0xc000 irq=
 22
[    3.784568] ata4: SATA max UDMA/133 cmd 0xec0 ctl 0xee0 bmdma 0xc008 irq=
 22
[    3.784843] pata_amd 0000:00:06.0: version 0.4.1
[    3.784887] pata_amd 0000:00:06.0: setting latency timer to 64
[    3.785504] scsi4 : pata_amd
[    3.785835] scsi5 : pata_amd
[    3.786942] ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq=
 14
[    3.787160] ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq=
 15
[    3.787576] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.787879] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 21
[    3.788055] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 21 (le=
vel, low) -> IRQ 21
[    3.788346] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    3.788350] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    3.788572] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus =
number 1
[    3.794042] ehci_hcd 0000:00:02.1: debug port 1
[    3.794196] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    3.794222] ehci_hcd 0000:00:02.1: irq 21, io mem 0xdfefec00
[    3.800014] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    3.800214] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    3.800382] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    3.800667] usb usb1: Product: EHCI Host Controller
[    3.800818] usb usb1: Manufacturer: Linux 2.6.39-rc1+ ehci_hcd
[    3.800971] usb usb1: SerialNumber: 0000:00:02.1
[    3.801304] hub 1-0:1.0: USB hub found
[    3.801458] hub 1-0:1.0: 10 ports detected
[    3.801794] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.802115] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 20
[    3.802275] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 20 (le=
vel, low) -> IRQ 20
[    3.802562] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    3.802565] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    3.802800] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus =
number 2
[    3.809049] ohci_hcd 0000:00:02.0: irq 20, io mem 0xdfeff000
[    3.862052] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    3.862208] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    3.862482] usb usb2: Product: OHCI Host Controller
[    3.862633] usb usb2: Manufacturer: Linux 2.6.39-rc1+ ohci_hcd
[    3.862787] usb usb2: SerialNumber: 0000:00:02.0
[    3.863098] hub 2-0:1.0: USB hub found
[    3.863253] hub 2-0:1.0: 10 ports detected
[    3.863580] uhci_hcd: USB Universal Host Controller Interface driver
[    3.863827] Initializing USB Mass Storage driver...
[    3.864073] usbcore: registered new interface driver usb-storage
[    3.864239] USB Mass Storage support registered.
[    3.864534] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    3.864688] i8042: PNP: PS/2 appears to have AUX port disabled, if this =
is incorrect please boot with i8042.nopnp
[    3.865690] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.866044] mousedev: PS/2 mouse device common for all mice
[    3.866491] rtc_cmos 00:02: RTC can wake from S4
[    3.870194] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    3.870387] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    3.870709] Software Watchdog Timer: 0.07 initialized. soft_noboot=3D0 s=
oft_margin=3D60 sec soft_panic=3D0 (nowayout=3D 0)
[    3.870998] cpuidle: using governor ladder
[    3.871174] cpuidle: using governor menu
[    3.872126] usbcore: registered new interface driver usbhid
[    3.872283] usbhid: USB HID core driver
[    3.873072] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 23
[    3.873235] HDA Intel 0000:00:05.0: PCI INT B -> Link[LAZA] -> GSI 23 (l=
evel, low) -> IRQ 23
[    3.873514] hda_intel: msi for device 1849:0888 set to 0
[    3.873665] hda_intel: position_fix set to 1 for device 1849:0888
[    3.873845] HDA Intel 0000:00:05.0: setting latency timer to 64
[    4.095398] ata1: SATA link down (SStatus 0 SControl 300)
[    4.105811] ata3: SATA link down (SStatus 0 SControl 300)
[    4.116016] hda_codec: ALC888: BIOS auto-probing.
[    4.320020] usb 2-4: new full speed USB device number 2 using ohci_hcd
[    4.323194] ALSA device list:
[    4.323354]   #0: HDA NVidia at 0xdfef8000 irq 23
[    4.323755] TCP cubic registered
[    4.324274] NET: Registered protocol family 10
[    4.325020] NET: Registered protocol family 17
[    4.325817] rtc_cmos 00:02: setting system clock to 2011-04-01 17:34:46 =
UTC (1301679286)
[    4.419391] ata2: SATA link down (SStatus 0 SControl 300)
[    4.465105] usb 2-4: New USB device found, idVendor=3D413c, idProduct=3D=
1003
[    4.465261] usb 2-4: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    4.465416] usb 2-4: Product: Dell USB Keyboard Hub
[    4.465568] usb 2-4: Manufacturer: Dell
[    4.474159] hub 2-4:1.0: USB hub found
[    4.477100] hub 2-4:1.0: 3 ports detected
[    4.773103] usb 2-4.1: new full speed USB device number 3 using ohci_hcd
[    4.871103] usb 2-4.1: New USB device found, idVendor=3D413c, idProduct=
=3D2010
[    4.871258] usb 2-4.1: New USB device strings: Mfr=3D1, Product=3D3, Ser=
ialNumber=3D0
[    4.871533] usb 2-4.1: Product: Dell USB Keyboard
[    4.871684] usb 2-4.1: Manufacturer: Dell
[    4.873035] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.892134] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00=
:02.0/usb2/2-4/2-4.1/2-4.1:1.0/input/input2
[    4.892501] generic-usb 0003:413C:2010.0001: input: USB HID v1.10 Keyboa=
rd [Dell Dell USB Keyboard] on usb-0000:00:02.0-4.1/input0
[    4.893613] ata4.00: ATA-7: WDC WD2500JS-63MHB5, 10.02E02, max UDMA/133
[    4.897267] ata4.00: 488397168 sectors, multi 16: LBA48=20
[    4.900258] ata4.00: configured for UDMA/133
[    4.900540] scsi 3:0:0:0: Direct-Access     ATA      WDC WD2500JS-63M 10=
.0 PQ: 0 ANSI: 5
[    4.901124] sd 3:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB=
/232 GiB)
[    4.901268] ata6: port disabled. ignoring.
[    4.901534] sd 3:0:0:0: [sda] Write Protect is off
[    4.901686] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.901730] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.905226] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00=
:02.0/usb2/2-4/2-4.1/2-4.1:1.1/input/input3
[    4.905577] generic-usb 0003:413C:2010.0002: input: USB HID v1.10 Device=
 [Dell Dell USB Keyboard] on usb-0000:00:02.0-4.1/input1
[    4.973103] usb 2-4.2: new low speed USB device number 4 using ohci_hcd
[    5.012364]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 >
[    5.013434] sd 3:0:0:0: [sda] Attached SCSI disk
[    5.050364] EXT3-fs (sda7): recovery required on readonly filesystem
[    5.050517] EXT3-fs (sda7): write access will be enabled during recovery
[    5.052198] EXT3-fs: barriers not enabled
[    5.072105] usb 2-4.2: New USB device found, idVendor=3D045e, idProduct=
=3D0040
[    5.072257] usb 2-4.2: New USB device strings: Mfr=3D1, Product=3D3, Ser=
ialNumber=3D0
[    5.072527] usb 2-4.2: Product: Microsoft 3-Button Mouse with IntelliEye=
(TM)
[    5.072680] usb 2-4.2: Manufacturer: Microsoft
[    5.082511] input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM=
) as /devices/pci0000:00/0000:00:02.0/usb2/2-4/2-4.2/2-4.2:1.0/input/input4
[    5.082950] generic-usb 0003:045E:0040.0003: input: USB HID v1.10 Mouse =
[Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:00:02.=
0-4.2/input0
[    9.666199] kjournald starting.  Commit interval 5 seconds
[    9.666234] EXT3-fs (sda7): orphan cleanup on readonly fs
[    9.666242] ext3_orphan_cleanup: deleting unreferenced inode 802229
[    9.666305] ext3_orphan_cleanup: deleting unreferenced inode 802246
[    9.666319] ext3_orphan_cleanup: deleting unreferenced inode 802194
[    9.666333] ext3_orphan_cleanup: deleting unreferenced inode 802211
[    9.666347] ext3_orphan_cleanup: deleting unreferenced inode 507418
[    9.666368] ext3_orphan_cleanup: deleting unreferenced inode 507475
[    9.666383] ext3_orphan_cleanup: deleting unreferenced inode 458582
[    9.666405] ext3_orphan_cleanup: deleting unreferenced inode 458602
[    9.666419] ext3_orphan_cleanup: deleting unreferenced inode 539648
[    9.699110] ext3_orphan_cleanup: deleting unreferenced inode 1079754
[    9.707449] ext3_orphan_cleanup: deleting unreferenced inode 982692
[    9.726274] ext3_orphan_cleanup: deleting unreferenced inode 674279
[    9.731523] ext3_orphan_cleanup: deleting unreferenced inode 674289
[    9.751831] ext3_orphan_cleanup: deleting unreferenced inode 704476
[    9.767861] ext3_orphan_cleanup: deleting unreferenced inode 704479
[    9.792397] ext3_orphan_cleanup: deleting unreferenced inode 917845
[    9.805964] ext3_orphan_cleanup: deleting unreferenced inode 623047
[    9.808473] ext3_orphan_cleanup: deleting unreferenced inode 621769
[    9.825340] ext3_orphan_cleanup: deleting unreferenced inode 605034
[    9.836170] ext3_orphan_cleanup: deleting unreferenced inode 706734
[    9.842045] ext3_orphan_cleanup: deleting unreferenced inode 706701
[    9.863724] ext3_orphan_cleanup: deleting unreferenced inode 1047596
[    9.878709] ext3_orphan_cleanup: deleting unreferenced inode 1390726
[    9.944973] ext3_orphan_cleanup: deleting unreferenced inode 1424250
[    9.944996] ext3_orphan_cleanup: deleting unreferenced inode 1390724
[    9.953441] ext3_orphan_cleanup: deleting unreferenced inode 1390722
[    9.968511] ext3_orphan_cleanup: deleting unreferenced inode 884346
[    9.970562] ext3_orphan_cleanup: deleting unreferenced inode 884342
[    9.974725] ext3_orphan_cleanup: deleting unreferenced inode 884368
[    9.976115] ext3_orphan_cleanup: deleting unreferenced inode 884376
[    9.989866] ext3_orphan_cleanup: deleting unreferenced inode 1276180
[   10.001273] ext3_orphan_cleanup: deleting unreferenced inode 1276179
[   10.019160] ext3_orphan_cleanup: deleting unreferenced inode 1767625
[   10.029090] ext3_orphan_cleanup: deleting unreferenced inode 100856
[   10.039754] ext3_orphan_cleanup: deleting unreferenced inode 164054
[   10.052382] ext3_orphan_cleanup: deleting unreferenced inode 17593
[   10.061686] ext3_orphan_cleanup: deleting unreferenced inode 17652
[   10.067764] ext3_orphan_cleanup: deleting unreferenced inode 163992
[   10.067905] ext3_orphan_cleanup: deleting unreferenced inode 163974
[   10.089545] ext3_orphan_cleanup: deleting unreferenced inode 574978
[   10.108475] ext3_orphan_cleanup: deleting unreferenced inode 558470
[   10.114824] ext3_orphan_cleanup: deleting unreferenced inode 558469
[   10.114837] ext3_orphan_cleanup: deleting unreferenced inode 558468
[   10.114850] ext3_orphan_cleanup: deleting unreferenced inode 558466
[   10.114998] ext3_orphan_cleanup: deleting unreferenced inode 558464
[   10.115023] ext3_orphan_cleanup: deleting unreferenced inode 558462
[   10.115035] ext3_orphan_cleanup: deleting unreferenced inode 558460
[   10.115049] ext3_orphan_cleanup: deleting unreferenced inode 558459
[   10.115062] ext3_orphan_cleanup: deleting unreferenced inode 558458
[   10.115078] ext3_orphan_cleanup: deleting unreferenced inode 558457
[   10.121571] ext3_orphan_cleanup: deleting unreferenced inode 558456
[   10.121585] ext3_orphan_cleanup: deleting unreferenced inode 558455
[   10.121600] ext3_orphan_cleanup: deleting unreferenced inode 558454
[   10.121613] ext3_orphan_cleanup: deleting unreferenced inode 558453
[   10.121626] ext3_orphan_cleanup: deleting unreferenced inode 558450
[   10.129313] ext3_orphan_cleanup: deleting unreferenced inode 558449
[   10.129328] ext3_orphan_cleanup: deleting unreferenced inode 558447
[   10.135749] ext3_orphan_cleanup: deleting unreferenced inode 558446
[   10.135762] ext3_orphan_cleanup: deleting unreferenced inode 558445
[   10.135775] ext3_orphan_cleanup: deleting unreferenced inode 558444
[   10.135788] ext3_orphan_cleanup: deleting unreferenced inode 558443
[   10.135800] ext3_orphan_cleanup: deleting unreferenced inode 558441
[   10.135813] ext3_orphan_cleanup: deleting unreferenced inode 558440
[   10.135833] ext3_orphan_cleanup: deleting unreferenced inode 558439
[   10.135848] ext3_orphan_cleanup: deleting unreferenced inode 558438
[   10.135863] ext3_orphan_cleanup: deleting unreferenced inode 558437
[   10.145876] ext3_orphan_cleanup: deleting unreferenced inode 654644
[   10.145900] ext3_orphan_cleanup: deleting unreferenced inode 558436
[   10.145915] ext3_orphan_cleanup: deleting unreferenced inode 558435
[   10.145931] ext3_orphan_cleanup: deleting unreferenced inode 558434
[   10.149932] ext3_orphan_cleanup: deleting unreferenced inode 558429
[   10.149954] ext3_orphan_cleanup: deleting unreferenced inode 558428
[   10.149969] ext3_orphan_cleanup: deleting unreferenced inode 558427
[   10.149981] ext3_orphan_cleanup: deleting unreferenced inode 558426
[   10.149994] ext3_orphan_cleanup: deleting unreferenced inode 558425
[   10.150014] ext3_orphan_cleanup: deleting unreferenced inode 558424
[   10.150030] ext3_orphan_cleanup: deleting unreferenced inode 558423
[   10.150045] ext3_orphan_cleanup: deleting unreferenced inode 558422
[   10.150058] ext3_orphan_cleanup: deleting unreferenced inode 558421
[   10.150073] ext3_orphan_cleanup: deleting unreferenced inode 558420
[   10.150086] ext3_orphan_cleanup: deleting unreferenced inode 558419
[   10.150099] ext3_orphan_cleanup: deleting unreferenced inode 558417
[   10.150120] ext3_orphan_cleanup: deleting unreferenced inode 655850
[   10.165218] ext3_orphan_cleanup: deleting unreferenced inode 1751707
[   10.172883] ext3_orphan_cleanup: deleting unreferenced inode 1787118
[   10.173045] ext3_orphan_cleanup: deleting unreferenced inode 1787152
[   10.176901] ext3_orphan_cleanup: deleting unreferenced inode 1788188
[   10.185770] ext3_orphan_cleanup: deleting unreferenced inode 1788329
[   10.185786] ext3_orphan_cleanup: deleting unreferenced inode 1788330
[   10.197458] ext3_orphan_cleanup: deleting unreferenced inode 1210099
[   10.216423] ext3_orphan_cleanup: deleting unreferenced inode 1783672
[   10.216575] ext3_orphan_cleanup: deleting unreferenced inode 1787129
[   10.224317] ext3_orphan_cleanup: deleting unreferenced inode 608793
[   10.224333] ext3_orphan_cleanup: deleting unreferenced inode 608794
[   10.224560] ext3_orphan_cleanup: deleting unreferenced inode 608850
[   10.224748] ext3_orphan_cleanup: deleting unreferenced inode 608892
[   10.234463] ext3_orphan_cleanup: deleting unreferenced inode 362995
[   10.242625] ext3_orphan_cleanup: deleting unreferenced inode 363004
[   10.260596] ext3_orphan_cleanup: deleting unreferenced inode 1750484
[   10.260614] ext3_orphan_cleanup: deleting unreferenced inode 1787126
[   10.268935] ext3_orphan_cleanup: deleting unreferenced inode 1788290
[   10.275209] ext3_orphan_cleanup: deleting unreferenced inode 1788295
[   10.275223] ext3_orphan_cleanup: deleting unreferenced inode 1788296
[   10.291413] ext3_orphan_cleanup: deleting unreferenced inode 65745
[   10.295559] ext3_orphan_cleanup: deleting unreferenced inode 83789
[   10.305083] ext3_orphan_cleanup: deleting unreferenced inode 83770
[   10.305095] EXT3-fs (sda7): 106 orphan inodes deleted
[   10.305249] EXT3-fs (sda7): recovery complete
[   10.590696] EXT3-fs (sda7): mounted filesystem with writeback data mode
[   10.590870] VFS: Mounted root (ext3 filesystem) readonly on device 8:7.
[   10.592065] Freeing unused kernel memory: 464k freed
[   10.592506] Write protecting the kernel read-only data: 10240k
[   10.594903] Freeing unused kernel memory: 524k freed
[   10.601655] Freeing unused kernel memory: 1576k freed
[   16.925227] udev[1160]: starting version 167
[   17.120342] forcedeth: Reverse Engineered nForce ethernet driver. Versio=
n 0.64.
[   17.120572] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 22
[   17.120579] forcedeth 0000:00:07.0: PCI INT A -> Link[LMAC] -> GSI 22 (l=
evel, low) -> IRQ 22
[   17.120585] forcedeth 0000:00:07.0: setting latency timer to 64
[   17.209715] 8139too: 8139too Fast Ethernet driver 0.9.28
[   17.209951] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 19
[   17.209967] 8139too 0000:01:08.0: PCI INT A -> Link[LNKA] -> GSI 19 (lev=
el, low) -> IRQ 19
[   17.210977] 8139too 0000:01:08.0: eth0: RealTek RTL8139 at 0xe800, 00:c0=
:df:14:8c:c2, IRQ 19
[   17.298429] [drm] Initialized drm 1.1.0 20060810
[   17.452200] 8139cp: 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 200=
4)
[   17.643070] forcedeth 0000:00:07.0: ifname eth1, PHY OUI 0x732 @ 1, addr=
 00:19:66:25:74:3c
[   17.643075] forcedeth 0000:00:07.0: highdma pwrctl mgmt lnktim msi desc-=
v3
[   17.851546] ACPI: PCI Interrupt Link [LMC9] enabled at IRQ 21
[   17.851556] nouveau 0000:00:0d.0: PCI INT A -> Link[LMC9] -> GSI 21 (lev=
el, low) -> IRQ 21
[   17.851561] nouveau 0000:00:0d.0: setting latency timer to 64
[   17.853046] [drm] nouveau 0000:00:0d.0: Detected an NV40 generation card=
 (0x04c000a2)
[   17.855217] [drm] nouveau 0000:00:0d.0: Attempting to load BIOS image fr=
om PRAMIN
[   17.903554] [drm] nouveau 0000:00:0d.0: ... appears to be valid
[   17.903559] [drm] nouveau 0000:00:0d.0: BIT BIOS found
[   17.903563] [drm] nouveau 0000:00:0d.0: Bios version 05.61.32.22
[   17.903567] [drm] nouveau 0000:00:0d.0: TMDS table version 1.1
[   17.903570] [drm] nouveau 0000:00:0d.0: BIT table 'd' not found
[   17.903572] [drm] nouveau 0000:00:0d.0: Found Display Configuration Bloc=
k version 3.0
[   17.903576] [drm] nouveau 0000:00:0d.0: Raw DCB entry 0: 01000310 000000=
23
[   17.903580] [drm] nouveau 0000:00:0d.0: Raw DCB entry 1: 00110204 97e500=
00
[   17.903584] [drm] nouveau 0000:00:0d.0: DCB connector table: VHER 0x30 5=
 10 2
[   17.903587] [drm] nouveau 0000:00:0d.0:   0: 0x00000000: type 0x00 idx 0=
 tag 0xff
[   17.903594] [drm] nouveau 0000:00:0d.0: Parsing VBIOS init table 0 at of=
fset 0xDBF3
[   17.903599] [drm] nouveau 0000:00:0d.0: =3D=3D=3D=3D=3D=3D=3D misaligned=
 reg 0x0060081D =3D=3D=3D=3D=3D=3D=3D
[   17.903602] [drm] nouveau 0000:00:0d.0: =3D=3D=3D=3D=3D=3D=3D misaligned=
 reg 0x0060081D =3D=3D=3D=3D=3D=3D=3D
[   17.903656] [drm] nouveau 0000:00:0d.0: Parsing VBIOS init table 1 at of=
fset 0xDD4A
[   17.903659] [drm] nouveau 0000:00:0d.0: Parsing VBIOS init table 2 at of=
fset 0xDD4B
[   17.903722] [drm] nouveau 0000:00:0d.0: Parsing VBIOS init table 3 at of=
fset 0xDECD
[   17.903728] [drm] nouveau 0000:00:0d.0: Parsing VBIOS init table 4 at of=
fset 0xDF16
[   18.151062] [drm] nouveau 0000:00:0d.0: 1 available performance level(s)
[   18.151069] [drm] nouveau 0000:00:0d.0: 0: memory 0MHz core 425MHz fansp=
eed 100%
[   18.151079] [drm] nouveau 0000:00:0d.0: c: memory 0MHz
[   18.151208] [TTM] Zone  kernel: Available graphics memory: 994640 kiB.
[   18.151210] [TTM] Initializing pool allocator.
[   18.151228] [drm] nouveau 0000:00:0d.0: Detected 64MiB VRAM
[   18.151872] [drm] nouveau 0000:00:0d.0: 64 MiB GART (aperture)
[   18.151944] [drm] nouveau 0000:00:0d.0: Saving VGA fonts
[   18.195545] [drm] nouveau 0000:00:0d.0: unknown connector type: 0xff!!
[   18.196475] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   18.196477] [drm] No driver support for vblank timestamp query.
[   18.196783] [drm] nouveau 0000:00:0d.0: Setting dpms mode 3 on vga encod=
er (output 0)
[   18.212582] udev[1167]: renamed network interface eth1 to eth1-eth0
[   18.326512] [drm] nouveau 0000:00:0d.0: allocated 1280x1024 fb: 0x4a000,=
 bo ffff88007109fc00
[   18.391462] [drm] nouveau 0000:00:0d.0: Setting dpms mode 0 on vga encod=
er (output 0)
[   18.391467] [drm] nouveau 0000:00:0d.0: Output VGA-1 is running on CRTC =
0 using output A
[   18.393401] Console: switching to colour frame buffer device 160x64
[   18.395513] fb0: nouveaufb frame buffer device
[   18.395516] drm: registered panic notifier
[   18.395531] [drm] Initialized nouveau 0.0.16 20090420 for 0000:00:0d.0 o=
n minor 0
[   18.736540] udev[1166]: renamed network interface eth0 to eth1
[   18.770554] udev[1167]: renamed network interface eth1-eth0 to eth0
[   19.475228] fuse init (API version 7.16)
[   19.573657] kvm: Nested Virtualization enabled
[   19.622307] tun: Universal TUN/TAP device driver, 1.6
[   19.622311] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   28.757462] EXT3-fs (sda7): using internal journal
[   29.408112] EXT4-fs (sda8): mounted filesystem with ordered data mode. O=
pts: (null)
[   29.475172] EXT4-fs (sda10): mounted filesystem with ordered data mode. =
Opts: (null)
[   29.664567] EXT4-fs (sda11): mounted filesystem with ordered data mode. =
Opts: (null)
[   29.884584] Btrfs loaded
[   29.885176] device label PORTAGE devid 1 transid 16701 /dev/sda9
[   29.885474] btrfs: use lzo compression
[   44.721375] btrfs: unlinked 1 orphans
[   47.090960] Adding 4096536k swap on /dev/sda6.  Priority:-1 extents:1 ac=
ross:4096536k=20
[   47.427953] Bridge firewalling registered
[   47.451815] device eth0 entered promiscuous mode
[   47.454321] forcedeth 0000:00:07.0: irq 43 for MSI/MSI-X
[   47.457726] br0: Dropping NETIF_F_GSO since no SG feature.
[   47.465092] br0: Dropping NETIF_F_GSO since no SG feature.
[   47.465104] br0: port 1(eth0) entering forwarding state
[   47.465107] br0: port 1(eth0) entering forwarding state
[   57.546016] eth0: no IPv6 routers present
[   58.354032] br0: no IPv6 routers present
[  468.567245] [drm] nouveau 0000:00:0d.0: Setting dpms mode 1 on vga encod=
er (output 0)
[  469.567874] [drm] nouveau 0000:00:0d.0: Setting dpms mode 0 on vga encod=
er (output 0)
[ 1300.288140] [drm] nouveau 0000:00:0d.0: Setting dpms mode 1 on vga encod=
er (output 0)
[ 1300.298183] [drm] nouveau 0000:00:0d.0: Setting dpms mode 2 on vga encod=
er (output 0)
[ 1371.121229] [drm] nouveau 0000:00:0d.0: Setting dpms mode 0 on vga encod=
er (output 0)
[ 1409.432065] [drm] nouveau 0000:00:0d.0: Setting dpms mode 1 on vga encod=
er (output 0)
[ 1409.442103] [drm] nouveau 0000:00:0d.0: Setting dpms mode 2 on vga encod=
er (output 0)
[ 3209.407426] [drm] nouveau 0000:00:0d.0: Setting dpms mode 0 on vga encod=
er (output 0)
[ 3209.407462] [drm] nouveau 0000:00:0d.0: Setting dpms mode 1 on vga encod=
er (output 0)
[ 5009.427347] [drm] nouveau 0000:00:0d.0: Setting dpms mode 0 on vga encod=
er (output 0)
[ 5009.427382] [drm] nouveau 0000:00:0d.0: Setting dpms mode 3 on vga encod=
er (output 0)
[69392.216454] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000030
[69392.216493] IP: [<ffffffffa02352c7>] btrfs_print_leaf+0x27/0x890 [btrfs]
[69392.216537] PGD 0=20
[69392.216547] Oops: 0000 [#1] PREEMPT SMP=20
[69392.216562] last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent
[69392.216575] CPU 0=20
[69392.216581] Modules linked in: bridge stp llc btrfs zlib_deflate lzo_dec=
ompress lzo_compress crc32c libcrc32c tun kvm_amd kvm fuse nouveau ttm drm_=
kms_helper 8139cp drm i2c_algo_bit i2c_core 8139too cfbcopyarea cfbimgblt c=
fbfillrect forcedeth
[69392.216668]=20
[69392.216675] Pid: 22974, comm: rm Not tainted 2.6.39-rc1+ #2 To Be Filled=
 By O.E.M. To Be Filled By O.E.M./ALiveNF6G-VSTA
[69392.216699] RIP: 0010:[<ffffffffa02352c7>]  [<ffffffffa02352c7>] btrfs_p=
rint_leaf+0x27/0x890 [btrfs]
[69392.216724] RSP: 0018:ffff880060111aa8  EFLAGS: 00010283
[69392.216734] RAX: 00000000ffffffe4 RBX: 0000000000000000 RCX: 00000000fff=
fffe4
[69392.216746] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00001
[69392.216757] RBP: ffff880060111b28 R08: 0000000000000000 R09: 00000000000=
00000
[69392.216769] R10: ffffffffffffffe4 R11: 0000000000000002 R12: 00000000000=
00005
[69392.216781] R13: ffff880077397800 R14: 0000000000000000 R15: 0000000000a=
64000
[69392.216794] FS:  00007f4b0cb06700(0000) GS:ffff88007bc00000(0000) knlGS:=
00000000f68c1b20
[69392.216807] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[69392.216817] CR2: 0000000000000030 CR3: 000000000f2e6000 CR4: 00000000000=
006f0
[69392.216829] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[69392.216840] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[69392.216853] Process rm (pid: 22974, threadinfo ffff880060110000, task ff=
ff88002994d840)
[69392.216865] Stack:
[69392.216871]  00000000d3750000 ffffffffa0261114 ffff880077397800 00000000=
d3693000
[69392.216890]  ffff880060111b28 ffff880072158ab0 00000000d3750000 00000000=
003000a8
[69392.216910]  ffff880060111b00 ffffffff810d2937 ffff88001a5c9ea0 ffff8800=
72158ab0
[69392.216929] Call Trace:
[69392.216953]  [<ffffffffa0261114>] ? set_extent_dirty+0x24/0x30 [btrfs]
[69392.216968]  [<ffffffff810d2937>] ? kmem_cache_alloc+0x97/0xb0
[69392.216985]  [<ffffffffa022d777>] __btrfs_free_extent+0x647/0x700 [btrfs]
[69392.216999]  [<ffffffff8103b351>] ? get_parent_ip+0x11/0x50
[69392.217006]  [<ffffffff8103b351>] ? get_parent_ip+0x11/0x50
[69392.217006]  [<ffffffffa023007b>] run_clustered_refs+0x21b/0x860 [btrfs]
[69392.217006]  [<ffffffffa022f73e>] ? btrfs_free_extent+0x4e/0xd0 [btrfs]
[69392.217006]  [<ffffffffa0280b00>] ? btrfs_find_ref_cluster+0xe0/0x180 [b=
trfs]
[69392.217006]  [<ffffffffa0230780>] btrfs_run_delayed_refs+0xc0/0x210 [btr=
fs]
[69392.217006]  [<ffffffffa0241ca8>] __btrfs_end_transaction+0x68/0x220 [bt=
rfs]
[69392.217006]  [<ffffffffa0241ea0>] btrfs_end_transaction+0x10/0x20 [btrfs]
[69392.217006]  [<ffffffffa024b75f>] btrfs_evict_inode+0x19f/0x1f0 [btrfs]
[69392.217006]  [<ffffffff810fa2d0>] evict+0x80/0x160
[69392.217006]  [<ffffffff810fa4e2>] iput+0xe2/0x1b0
[69392.217006]  [<ffffffff810ef68b>] do_unlinkat+0x10b/0x1b0
[69392.217006]  [<ffffffff8111727b>] ? fsnotify_find_inode_mark+0x3b/0x50
[69392.217006]  [<ffffffff810dff91>] ? filp_close+0x61/0x90
[69392.217006]  [<ffffffff810f0c0d>] sys_unlinkat+0x1d/0x40
[69392.217006]  [<ffffffff81574c3b>] system_call_fastpath+0x16/0x1b
[69392.217006] Code: 00 00 00 00 55 48 89 e5 48 83 c4 80 4c 89 6d e8 49 89 =
fd bf 01 00 00 00 48 89 5d d8 4c 89 65 e0 48 89 f3 4c 89 75 f0 4c 89 7d f8 =
<4c> 8b 66 30 e8 90 61 e0 e0 48 b8 00 00 00 00 00 16 00 00 49 01=20
[69392.217006] RIP  [<ffffffffa02352c7>] btrfs_print_leaf+0x27/0x890 [btrfs]
[69392.217006]  RSP <ffff880060111aa8>
[69392.217006] CR2: 0000000000000030
[69392.220992] ---[ end trace 3cfc7af696ff077b ]---
[69423.203129] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000030
[69423.203162] IP: [<ffffffffa02352c7>] btrfs_print_leaf+0x27/0x890 [btrfs]
[69423.203202] PGD 0=20
[69423.203212] Oops: 0000 [#2] PREEMPT SMP=20
[69423.203227] last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent
[69423.203239] CPU 1=20
[69423.203245] Modules linked in: bridge stp llc btrfs zlib_deflate lzo_dec=
ompress lzo_compress crc32c libcrc32c tun kvm_amd kvm fuse nouveau ttm drm_=
kms_helper 8139cp drm i2c_algo_bit i2c_core 8139too cfbcopyarea cfbimgblt c=
fbfillrect forcedeth
[69423.203331]=20
[69423.203337] Pid: 1559, comm: btrfs-transacti Tainted: G      D     2.6.3=
9-rc1+ #2 To Be Filled By O.E.M. To Be Filled By O.E.M./ALiveNF6G-VSTA
[69423.203362] RIP: 0010:[<ffffffffa02352c7>]  [<ffffffffa02352c7>] btrfs_p=
rint_leaf+0x27/0x890 [btrfs]
[69423.203385] RSP: 0018:ffff8800711d7ad0  EFLAGS: 00010283
[69423.203845] RAX: 00000000ffffffe4 RBX: 0000000000000000 RCX: 00000000fff=
fffe4
[69423.204011] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00001
[69423.204011] RBP: ffff8800711d7b50 R08: 0000000000000000 R09: 00000000000=
00000
[69423.204011] R10: ffffffffffffffe4 R11: 0000000000000002 R12: 00000000000=
00005
[69423.204011] R13: ffff880077397800 R14: 0000000000000000 R15: 0000000000a=
84000
[69423.204011] FS:  00007f6da8846700(0000) GS:ffff88007bd00000(0000) knlGS:=
00000000f68c1b20
[69423.204011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[69423.204011] CR2: 0000000000000030 CR3: 000000005ba98000 CR4: 00000000000=
006e0
[69423.204011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[69423.204011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[69423.204011] Process btrfs-transacti (pid: 1559, threadinfo ffff8800711d6=
000, task ffff880071d9ac20)
[69423.204011] Stack:
[69423.204011]  00000000ee3d8000 ffffffffa0261114 ffff880077397800 00000000=
ea393000
[69423.216038]  ffff8800711d7b50 ffff880072180cf0 00000000ee3d8000 00000000=
003000a8
[69423.216038]  ffff8800711d7b00 ffffffff810d2937 ffff88001a5c9360 ffff8800=
72180cf0
[69423.216038] Call Trace:
[69423.216038]  [<ffffffffa0261114>] ? set_extent_dirty+0x24/0x30 [btrfs]
[69423.216038]  [<ffffffff810d2937>] ? kmem_cache_alloc+0x97/0xb0
[69423.216038]  [<ffffffffa022d777>] __btrfs_free_extent+0x647/0x700 [btrfs]
[69423.216038]  [<ffffffff8103b351>] ? get_parent_ip+0x11/0x50
[69423.216038]  [<ffffffff8103b351>] ? get_parent_ip+0x11/0x50
[69423.216038]  [<ffffffffa023007b>] run_clustered_refs+0x21b/0x860 [btrfs]
[69423.216038]  [<ffffffffa0280b00>] ? btrfs_find_ref_cluster+0xe0/0x180 [b=
trfs]
[69423.216038]  [<ffffffffa0230780>] btrfs_run_delayed_refs+0xc0/0x210 [btr=
fs]
[69423.216038]  [<ffffffff81573fa0>] ? _raw_spin_unlock+0x10/0x40
[69423.216038]  [<ffffffffa0241538>] btrfs_commit_transaction+0x78/0x750 [b=
trfs]
[69423.216038]  [<ffffffff8105c5c0>] ? wake_up_bit+0x40/0x40
[69423.216038]  [<ffffffffa023ae7b>] transaction_kthread+0x27b/0x290 [btrfs]
[69423.216038]  [<ffffffff8103b425>] ? sub_preempt_count+0x95/0xd0
[69423.216038]  [<ffffffffa023ac00>] ? btrfs_congested_fn+0x90/0x90 [btrfs]
[69423.216038]  [<ffffffff8105c0e6>] kthread+0x96/0xa0
[69423.216038]  [<ffffffff815758d4>] kernel_thread_helper+0x4/0x10
[69423.216038]  [<ffffffff8105c050>] ? kthread_worker_fn+0x190/0x190
[69423.216038]  [<ffffffff815758d0>] ? gs_change+0xb/0xb
[69423.216038] Code: 00 00 00 00 55 48 89 e5 48 83 c4 80 4c 89 6d e8 49 89 =
fd bf 01 00 00 00 48 89 5d d8 4c 89 65 e0 48 89 f3 4c 89 75 f0 4c 89 7d f8 =
<4c> 8b 66 30 e8 90 61 e0 e0 48 b8 00 00 00 00 00 16 00 00 49 01=20
[69423.216038] RIP  [<ffffffffa02352c7>] btrfs_print_leaf+0x27/0x890 [btrfs]
[69423.216038]  RSP <ffff8800711d7ad0>
[69423.216038] CR2: 0000000000000030
[69423.217050] ---[ end trace 3cfc7af696ff077c ]---
[74900.012824] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000030
[74900.013006] IP: [<ffffffffa02352c7>] btrfs_print_leaf+0x27/0x890 [btrfs]
[74900.013006] PGD 0=20
[74900.013006] Oops: 0000 [#3] PREEMPT SMP=20
[74900.013006] last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent
[74900.013006] CPU 0=20
[74900.013006] Modules linked in: bridge stp llc btrfs zlib_deflate lzo_dec=
ompress lzo_compress crc32c libcrc32c tun kvm_amd kvm fuse nouveau ttm drm_=
kms_helper 8139cp drm i2c_algo_bit i2c_core 8139too cfbcopyarea cfbimgblt c=
fbfillrect forcedeth
[74900.016967]=20
[74900.016967] Pid: 20172, comm: rm Tainted: G      D     2.6.39-rc1+ #2 To=
 Be Filled By O.E.M. To Be Filled By O.E.M./ALiveNF6G-VSTA
[74900.016967] RIP: 0010:[<ffffffffa02352c7>]  [<ffffffffa02352c7>] btrfs_p=
rint_leaf+0x27/0x890 [btrfs]
[74900.016967] RSP: 0018:ffff88000a575aa8  EFLAGS: 00010283
[74900.016967] RAX: 00000000ffffffe4 RBX: 0000000000000000 RCX: 00000000fff=
fffe4
[74900.016967] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00001
[74900.016967] RBP: ffff88000a575b28 R08: 0000000000000000 R09: 00000000000=
00000
[74900.016967] R10: ffffffffffffffe4 R11: 0000000000000002 R12: 00000000000=
00005
[74900.016967] R13: ffff880077397800 R14: 0000000000000000 R15: 0000000000a=
9e000
[74900.016967] FS:  00007f1fa99c6700(0000) GS:ffff88007bc00000(0000) knlGS:=
00000000f68c1b20
[74900.016967] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[74900.016967] CR2: 0000000000000030 CR3: 00000000341b9000 CR4: 00000000000=
006f0
[74900.016967] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[74900.016967] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[74900.016967] Process rm (pid: 20172, threadinfo ffff88000a574000, task ff=
ff880078142c20)
[74900.016967] Stack:
[74900.016967]  00000001031ed000 ffffffffa0261114 ffff880077397800 00000001=
02edd000
[74900.016967]  ffff88000a575b28 ffff880072158000 00000001031ed000 00000000=
002000a8
[74900.016967]  ffff88000a575b00 ffffffff810d2937 ffff88001a57fd20 ffff8800=
72158000
[74900.016967] Call Trace:
[74900.016967]  [<ffffffffa0261114>] ? set_extent_dirty+0x24/0x30 [btrfs]
[74900.016967]  [<ffffffff810d2937>] ? kmem_cache_alloc+0x97/0xb0
[74900.016967]  [<ffffffffa022d777>] __btrfs_free_extent+0x647/0x700 [btrfs]
[74900.016967]  [<ffffffff8103b351>] ? get_parent_ip+0x11/0x50
[74900.016967]  [<ffffffff8103b351>] ? get_parent_ip+0x11/0x50
[74900.016967]  [<ffffffffa023007b>] run_clustered_refs+0x21b/0x860 [btrfs]
[74900.016967]  [<ffffffffa022f73e>] ? btrfs_free_extent+0x4e/0xd0 [btrfs]
[74900.016967]  [<ffffffffa0280b00>] ? btrfs_find_ref_cluster+0xe0/0x180 [b=
trfs]
[74900.016967]  [<ffffffffa0230780>] btrfs_run_delayed_refs+0xc0/0x210 [btr=
fs]
[74900.016967]  [<ffffffffa0241ca8>] __btrfs_end_transaction+0x68/0x220 [bt=
rfs]
[74900.016967]  [<ffffffffa0241ea0>] btrfs_end_transaction+0x10/0x20 [btrfs]
[74900.016967]  [<ffffffffa024b75f>] btrfs_evict_inode+0x19f/0x1f0 [btrfs]
[74900.016967]  [<ffffffff810fa2d0>] evict+0x80/0x160
[74900.016967]  [<ffffffff810fa4e2>] iput+0xe2/0x1b0
[74900.016967]  [<ffffffff810ef68b>] do_unlinkat+0x10b/0x1b0
[74900.016967]  [<ffffffff8111727b>] ? fsnotify_find_inode_mark+0x3b/0x50
[74900.016967]  [<ffffffff810dff91>] ? filp_close+0x61/0x90
[74900.016967]  [<ffffffff810f0c0d>] sys_unlinkat+0x1d/0x40
[74900.016967]  [<ffffffff81574c3b>] system_call_fastpath+0x16/0x1b
[74900.016967] Code: 00 00 00 00 55 48 89 e5 48 83 c4 80 4c 89 6d e8 49 89 =
fd bf 01 00 00 00 48 89 5d d8 4c 89 65 e0 48 89 f3 4c 89 75 f0 4c 89 7d f8 =
<4c> 8b 66 30 e8 90 61 e0 e0 48 b8 00 00 00 00 00 16 00 00 49 01=20
[74900.016967] RIP  [<ffffffffa02352c7>] btrfs_print_leaf+0x27/0x890 [btrfs]
[74900.016967]  RSP <ffff88000a575aa8>
[74900.016967] CR2: 0000000000000030
[74900.067571] ---[ end trace 3cfc7af696ff077d ]---
[74902.522927] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000030
[74902.523005] IP: [<ffffffffa02352c7>] btrfs_print_leaf+0x27/0x890 [btrfs]
[74902.523005] PGD 0=20
[74902.523005] Oops: 0000 [#4] PREEMPT SMP=20
[74902.523005] last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent
[74902.523005] CPU 0=20
[74902.523005] Modules linked in: bridge stp llc btrfs zlib_deflate lzo_dec=
ompress lzo_compress crc32c libcrc32c tun kvm_amd kvm fuse nouveau ttm drm_=
kms_helper 8139cp drm i2c_algo_bit i2c_core 8139too cfbcopyarea cfbimgblt c=
fbfillrect forcedeth
[74902.528467]=20
[74902.528467] Pid: 20261, comm: rm Tainted: G      D     2.6.39-rc1+ #2 To=
 Be Filled By O.E.M. To Be Filled By O.E.M./ALiveNF6G-VSTA
[74902.528467] RIP: 0010:[<ffffffffa02352c7>]  [<ffffffffa02352c7>] btrfs_p=
rint_leaf+0x27/0x890 [btrfs]
[74902.528467] RSP: 0018:ffff880029921aa8  EFLAGS: 00010283
[74902.528467] RAX: 00000000ffffffe4 RBX: 0000000000000000 RCX: 00000000fff=
fffe4
[74902.528467] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00001
[74902.528467] RBP: ffff880029921b28 R08: 0000000000000000 R09: 00000000000=
00000
[74902.528467] R10: ffffffffffffffe4 R11: 0000000000000002 R12: 00000000000=
00005
[74902.528467] R13: ffff880077397800 R14: 0000000000000000 R15: 00000000000=
00000
[74902.528467] FS:  00007f545efa0700(0000) GS:ffff88007bc00000(0000) knlGS:=
00000000f68c1b20
[74902.528467] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[74902.528467] CR2: 0000000000000030 CR3: 00000000176af000 CR4: 00000000000=
006f0
[74902.528467] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[74902.528467] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[74902.528467] Process rm (pid: 20261, threadinfo ffff880029920000, task ff=
ff88002fb8c230)
[74902.528467] Stack:
[74902.528467]  000000005b3f3000 ffffffffa0261114 ffff880077397800 00000000=
5b3d5000
[74902.528467]  ffff880029921b28 ffff880072158750 000000005b3f3000 00000000=
001000a8
[74902.528467]  ffff880029921b00 ffffffff810d2937 ffff88000d906840 ffff8800=
72158750
[74902.528467] Call Trace:
[74902.528467]  [<ffffffffa0261114>] ? set_extent_dirty+0x24/0x30 [btrfs]
[74902.528467]  [<ffffffff810d2937>] ? kmem_cache_alloc+0x97/0xb0
[74902.528467]  [<ffffffffa022d777>] __btrfs_free_extent+0x647/0x700 [btrfs]
[74902.528467]  [<ffffffff8103b351>] ? get_parent_ip+0x11/0x50
[74902.528467]  [<ffffffff8103b351>] ? get_parent_ip+0x11/0x50
[74902.528467]  [<ffffffff8103b351>] ? get_parent_ip+0x11/0x50
[74902.528467]  [<ffffffffa02301e1>] run_clustered_refs+0x381/0x860 [btrfs]
[74902.528467]  [<ffffffffa0230780>] btrfs_run_delayed_refs+0xc0/0x210 [btr=
fs]
[74902.528467]  [<ffffffffa0241ca8>] __btrfs_end_transaction+0x68/0x220 [bt=
rfs]
[74902.528467]  [<ffffffffa0241ea0>] btrfs_end_transaction+0x10/0x20 [btrfs]
[74902.528467]  [<ffffffffa024b75f>] btrfs_evict_inode+0x19f/0x1f0 [btrfs]
[74902.528467]  [<ffffffff810fa2d0>] evict+0x80/0x160
[74902.528467]  [<ffffffff810fa4e2>] iput+0xe2/0x1b0
[74902.528467]  [<ffffffff810ef68b>] do_unlinkat+0x10b/0x1b0
[74902.528467]  [<ffffffff810fe9ca>] ? mntput+0x1a/0x30
[74902.528467]  [<ffffffff810dff91>] ? filp_close+0x61/0x90
[74902.528467]  [<ffffffff810f0c0d>] sys_unlinkat+0x1d/0x40
[74902.528467]  [<ffffffff81574c3b>] system_call_fastpath+0x16/0x1b
[74902.528467] Code: 00 00 00 00 55 48 89 e5 48 83 c4 80 4c 89 6d e8 49 89 =
fd bf 01 00 00 00 48 89 5d d8 4c 89 65 e0 48 89 f3 4c 89 75 f0 4c 89 7d f8 =
<4c> 8b 66 30 e8 90 61 e0 e0 48 b8 00 00 00 00 00 16 00 00 49 01=20
[74902.528467] RIP  [<ffffffffa02352c7>] btrfs_print_leaf+0x27/0x890 [btrfs]
[74902.528467]  RSP <ffff880029921aa8>
[74902.528467] CR2: 0000000000000030
[74902.568753] ---[ end trace 3cfc7af696ff077e ]---
[74914.174734] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000030
[74914.175221] IP: [<ffffffffa02352c7>] btrfs_print_leaf+0x27/0x890 [btrfs]
[74914.175464] PGD 0=20
[74914.175464] Oops: 0000 [#5] PREEMPT SMP=20
[74914.175464] last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent
[74914.175464] CPU 1=20
[74914.175464] Modules linked in: bridge stp llc btrfs zlib_deflate lzo_dec=
ompress lzo_compress crc32c libcrc32c tun kvm_amd kvm fuse nouveau ttm drm_=
kms_helper 8139cp drm i2c_algo_bit i2c_core 8139too cfbcopyarea cfbimgblt c=
fbfillrect forcedeth
[74914.175464]=20
[74914.175464] Pid: 1556, comm: btrfs-endio-wri Tainted: G      D     2.6.3=
9-rc1+ #2 To Be Filled By O.E.M. To Be Filled By O.E.M./ALiveNF6G-VSTA
[74914.175464] RIP: 0010:[<ffffffffa02352c7>]  [<ffffffffa02352c7>] btrfs_p=
rint_leaf+0x27/0x890 [btrfs]
[74914.175464] RSP: 0018:ffff88006faf59e0  EFLAGS: 00010283
[74914.175464] RAX: 00000000ffffffe4 RBX: 0000000000000000 RCX: 00000000fff=
fffe4
[74914.175464] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00001
[74914.175464] RBP: ffff88006faf5a60 R08: 0000000000000000 R09: 00000000000=
00000
[74914.175464] R10: ffffffffffffffe4 R11: 0000000000000002 R12: 00000000000=
00005
[74914.175464] R13: ffff880077397800 R14: 0000000000000000 R15: 00000000000=
00000
[74914.175464] FS:  00007f98bf72f700(0000) GS:ffff88007bd00000(0000) knlGS:=
00000000f68c1b20
[74914.175464] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[74914.175464] CR2: 0000000000000030 CR3: 000000006ec07000 CR4: 00000000000=
006e0
[74914.175464] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[74914.175464] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[74914.175464] Process btrfs-endio-wri (pid: 1556, threadinfo ffff88006faf4=
000, task ffff88006fa1ac20)
[74914.175464] Stack:
[74914.175464]  000000005c849000 ffffffff6faf5af8 ffff880077397800 ffffffff=
a0265755
[74914.175464]  ffff88006faf5ac0 ffff8800721801b0 000000005c849000 00000000=
002000a8
[74914.175464]  ffff88006faf5a00 ffffffff810d2937 ffff88006fab10c0 ffff8800=
721801b0
[74914.175464] Call Trace:
[74914.175464]  [<ffffffffa0265755>] ? map_private_extent_buffer+0xd5/0x1c0=
 [btrfs]
[74914.175464]  [<ffffffff810d2937>] ? kmem_cache_alloc+0x97/0xb0
[74914.175464]  [<ffffffffa022d777>] __btrfs_free_extent+0x647/0x700 [btrfs]
[74914.175464]  [<ffffffffa023a1fa>] ? verify_parent_transid+0x9a/0x260 [bt=
rfs]
[74914.175464]  [<ffffffffa026584e>] ? unmap_extent_buffer+0xe/0x40 [btrfs]
[74914.175464]  [<ffffffff8103b351>] ? get_parent_ip+0x11/0x50
[74914.175464]  [<ffffffffa023007b>] run_clustered_refs+0x21b/0x860 [btrfs]
[74914.175464]  [<ffffffffa0265755>] ? map_private_extent_buffer+0xd5/0x1c0=
 [btrfs]
[74914.175464]  [<ffffffffa0280b00>] ? btrfs_find_ref_cluster+0xe0/0x180 [b=
trfs]
[74914.175464]  [<ffffffffa0230780>] btrfs_run_delayed_refs+0xc0/0x210 [btr=
fs]
[74914.175464]  [<ffffffffa0241ca8>] __btrfs_end_transaction+0x68/0x220 [bt=
rfs]
[74914.175464]  [<ffffffffa0241ea0>] btrfs_end_transaction+0x10/0x20 [btrfs]
[74914.175464]  [<ffffffffa0247a0c>] btrfs_finish_ordered_io+0x28c/0x330 [b=
trfs]
[74914.175464]  [<ffffffff8103b351>] ? get_parent_ip+0x11/0x50
[74914.175464]  [<ffffffffa0247ac5>] btrfs_writepage_end_io_hook+0x15/0x20 =
[btrfs]
[74914.175464]  [<ffffffffa027f19d>] end_compressed_bio_write+0x7d/0xf0 [bt=
rfs]
[74914.175464]  [<ffffffff8110f528>] bio_endio+0x18/0x30
[74914.175464]  [<ffffffffa023b1ac>] end_workqueue_fn+0xec/0x120 [btrfs]
[74914.175464]  [<ffffffffa026ddfc>] worker_loop+0xac/0x510 [btrfs]
[74914.175464]  [<ffffffffa026dd50>] ? btrfs_queue_worker+0x300/0x300 [btrf=
s]
[74914.175464]  [<ffffffff8105c0e6>] kthread+0x96/0xa0
[74914.175464]  [<ffffffff815758d4>] kernel_thread_helper+0x4/0x10
[74914.175464]  [<ffffffff8105c050>] ? kthread_worker_fn+0x190/0x190
[74914.175464]  [<ffffffff815758d0>] ? gs_change+0xb/0xb
[74914.175464] Code: 00 00 00 00 55 48 89 e5 48 83 c4 80 4c 89 6d e8 49 89 =
fd bf 01 00 00 00 48 89 5d d8 4c 89 65 e0 48 89 f3 4c 89 75 f0 4c 89 7d f8 =
<4c> 8b 66 30 e8 90 61 e0 e0 48 b8 00 00 00 00 00 16 00 00 49 01=20
[74914.175464] RIP  [<ffffffffa02352c7>] btrfs_print_leaf+0x27/0x890 [btrfs]
[74914.175464]  RSP <ffff88006faf59e0>
[74914.175464] CR2: 0000000000000030
[74914.233570] ---[ end trace 3cfc7af696ff077f ]---

--MP_/+gCw4NQP6CN_U9bWM5_yRBF--

--Sig_/n1NNmNZ7cUhmug9+Sl3aXqT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2XHNYACgkQcaHudmEf86rBQQCcD5iVNBLYsZdDWsKs7BCQCd6o
oRIAnjXZ6zPwEuwfnPZ96PZmom0I1NgJ
=wiNB
-----END PGP SIGNATURE-----

--Sig_/n1NNmNZ7cUhmug9+Sl3aXqT--
