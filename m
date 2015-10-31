Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38379 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbbJaQlO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Oct 2015 12:41:14 -0400
Date: Sat, 31 Oct 2015 16:41:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Simon King <simon.king@uni-koeln.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to delete this snapshot, and how to succeed with balancing?
Message-ID: <20151031164112.GF21103@carfax.org.uk>
References: <5634DD93.9050605@uni-koeln.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xs+9IvWevLaxKUtW"
In-Reply-To: <5634DD93.9050605@uni-koeln.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xs+9IvWevLaxKUtW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 31, 2015 at 04:26:11PM +0100, Simon King wrote:
> Hi!
>=20
> From the messages I see in this forum, I got the impression that it is a
> developer forum and not a help forum. I seek help. So, please point me
> to the right place if I shouldn't ask my questions here.

   No, you're good here. We do support as well as development. :)

> Since I am new, first my data:
>=20
> linux-va3e:~ # uname -a
> Linux linux-va3e.site 3.16.7-29-desktop #1 SMP PREEMPT Fri Oct 23
> 00:46:04 UTC 2015 (6be6a97) x86_64 x86_64 x86_64 GNU/Linux

   OK, that's a bit old -- you would probably do well to upgrade this
anyway, regardless of the issues you're having. (I'd recommend 4.1 at
the moment; there's a bug in 4.2 at the moment that affects
balancing).

> linux-va3e:~ # btrfs --version
> btrfs-progs v4.0+20150429
>=20
> linux-va3e:~ # btrfs fi show
> Label: none  uuid: 656dc65f-240b-4137-a490-0175717dd7fa
>         Total devices 1 FS bytes used 13.49GiB
>         devid    1 size 20.00GiB used 16.19GiB path /dev/sda2
>=20
> btrfs-progs v4.0+20150429
>=20
> linux-va3e:~ # btrfs fi df /
> Data, single: total=3D12.62GiB, used=3D12.14GiB
> System, DUP: total=3D32.00MiB, used=3D16.00KiB
> Metadata, DUP: total=3D1.75GiB, used=3D1.35GiB
> GlobalReserve, single: total=3D304.00MiB, used=3D0.00B
>=20
> dmesg > dmesg.log is attached.
>=20
>=20
> When I installed openSuse 13.2 on my computer, I used the default:
> - btrfs is used for a root partition of 20GB
> - A program called "snapper" creates snapshots of the system whenever a
> change is done (i.e., whenever a new program is installed or an old
> program is upgraded).
>=20
> After a while, the root partition was full because of btrfs's metadata.
> In an openSuse forum, people told me I should regularly delete the
> snapshots, and should "btrfs balance" and "btrf fi defragment" in order
> to keep the metadata under control.
>=20
> It was effective in the sense that I could use my computer again. It is
> annoying that the user has to manually delete snapshots and has to
> remember to regularly do balancing, though.

   I thought snapper could automatically delete old snapshots. (I've
never used it, though, so I'm not sure). Worth looking at the snapper
config to see if you can tell it how many to keep.

> Now to my current problem: It seems that my root partition gradually
> fills up. So, I am afraid that in a few weeks my computer will be broken
> again. And that happens although I keep deleting old snapshots and try
> balancing.
>=20
> My questions:
> 1. There is one old snapshot that I can not delete:
>   # snapper -c root delete 318
>   Fehler beim L=C3=B6schen des Schnappschusses.
> The error message does not hint *why* the snapshot can not be deleted.
> Here is one observation that may indicate what goes wrong:
>   # find / -name 318
>   /.snapshots/318
>   find: File system loop detected; =E2=80=98/.snapshots/318/snapshot=E2=
=80=99 is part of
> the same file system loop as =E2=80=98/=E2=80=99.
>=20
> So, what can I do to delete the snapshot to hopefully free some memory?

   That one, I don't know what's happening, I'm afraid.

> 2. When I simply do "btrfs balance start /", then it says the device is
> full. So, I tried
>   linux-va3e:~ # btrfs balance start -mlimit=3D1 -dlimit=3D2  -dusage=3D1=
0 /
>   Done, had to relocate 2 out of 28 chunks
> Fine. But when I try it again, it still says that it had to relocate 2
> out of 28 chunks! Shouldn't it be the case that the work has already
> been done, so that no further relocation is needed with the same paramete=
rs?

   You're telling it to move the first two chunks with less than 10%
usage. If all the other chunks are full, and there are two chunks (one
data, one metadata) with less than 10% usage, then they'll be moved to
two new chunks... with less than 10% usage. So it's perfectly possible
that the same command will show the same output.

   Incidentally, I would suggest using -dlimit=3D2 on its own, rather
than both limit and usage. You shouldn't normally need to run it on
the metadata: The usual case of early ENOSPC is that all of the block
groups in the filesystem are allocated (i.e. the space is reserved for
either data or metadata, not necessarily used), and then the metadata
fills up, while there is still lots of space for data allocated but
unused.  The balance simply moves some data around so that one or more
of the data block groups can be freed up, giving the FS some more
space that it can allocate to metadata.

> 3. When I increase the parameters, I always come to the point that there
> is no space left on device. So, how can I achieve full balance of the
> system?

   "btrfs balance start /" should rebalance the whole filesystem --
not that you'd need to for purposes of dealing with space usage
issues.

> One last remark: On the openSuse forum, I was advised to re-install the
> system, and either reserve at least 50GB for the root partition, or drop
> btrfs and use ext4 for the root partition. I would like to avoid such
> trouble and hope that you can tell me how to sanitise my root partition,
> and *keep* it sane.

   You may have more success using mkfs.btrfs --mixed when you create
the FS, which puts data and metadata in the same chunks. It's more
space-efficient, but (I'm told) has a slight loss of performance. I
don't know if we've got any figures to quantify that. The usual
recommendation is to use --mixed if your FS is under 16 GiB, but
you're close enough that it may be worth trying anyway.

   Hugo.

> [    0.000000] CPU0 microcode updated early to revision 0x60f, date =3D 2=
010-09-29
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 3.16.7-29-desktop (geeko@buildhost) (gcc ver=
sion 4.8.3 20140627 [gcc-4_8-branch revision 212064] (SUSE Linux) ) #1 SMP =
PREEMPT Fri Oct 23 00:46:04 UTC 2015 (6be6a97)
> [    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-3.16.7-29-desktop=
 root=3DUUID=3D656dc65f-240b-4137-a490-0175717dd7fa resume=3D/dev/disk/by-u=
uid/4d8e38d7-cfb9-4101-965e-1a66d96bd37d splash=3Dsilent quiet showopts
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dfff] usa=
ble
> [    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] res=
erved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] res=
erved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bfd6afff] usa=
ble
> [    0.000000] BIOS-e820: [mem 0x00000000bfd6b000-0x00000000bfdbefff] res=
erved
> [    0.000000] BIOS-e820: [mem 0x00000000bfdbf000-0x00000000bfe82fff] usa=
ble
> [    0.000000] BIOS-e820: [mem 0x00000000bfe83000-0x00000000bfebefff] ACP=
I NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bfebf000-0x00000000bfedefff] usa=
ble
> [    0.000000] BIOS-e820: [mem 0x00000000bfedf000-0x00000000bfef5fff] ACP=
I data
> [    0.000000] BIOS-e820: [mem 0x00000000bfef6000-0x00000000bfefdfff] usa=
ble
> [    0.000000] BIOS-e820: [mem 0x00000000bfefe000-0x00000000bfefefff] ACP=
I data
> [    0.000000] BIOS-e820: [mem 0x00000000bfeff000-0x00000000bfefffff] usa=
ble
> [    0.000000] BIOS-e820: [mem 0x00000000bff00000-0x00000000bfffffff] res=
erved
> [    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] res=
erved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] res=
erved
> [    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] res=
erved
> [    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] res=
erved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] res=
erved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] res=
erved
> [    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] res=
erved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usa=
ble
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Hewlett-Packard HP Pavilion dv7 Notebook PC/30F4, BIO=
S F.23 12/04/2008
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] AGP: No AGP bridge found
> [    0.000000] e820: last_pfn =3D 0x140000 max_arch_pfn =3D 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-FFFFF uncachable
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask F80000000 write-back
> [    0.000000]   1 base 080000000 mask FC0000000 write-back
> [    0.000000]   2 base 0FFF00000 mask FFFF00000 write-protect
> [    0.000000]   3 base 0BFF00000 mask FFFF00000 uncachable
> [    0.000000]   4 base 100000000 mask FC0000000 write-back
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600=
070106
> [    0.000000] e820: last_pfn =3D 0xbff00 max_arch_pfn =3D 0x400000000
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24=
576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x0220b000, 0x0220bfff] PGTABLE
> [    0.000000] BRK [0x0220c000, 0x0220cfff] PGTABLE
> [    0.000000] BRK [0x0220d000, 0x0220dfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x13fe00000-0x13fffffff]
> [    0.000000]  [mem 0x13fe00000-0x13fffffff] page 2M
> [    0.000000] BRK [0x0220e000, 0x0220efff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x13c000000-0x13fdfffff]
> [    0.000000]  [mem 0x13c000000-0x13fdfffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x13bffffff]
> [    0.000000]  [mem 0x100000000-0x13bffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0xbfd6afff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0xbfbfffff] page 2M
> [    0.000000]  [mem 0xbfc00000-0xbfd6afff] page 4k
> [    0.000000] init_memory_mapping: [mem 0xbfdbf000-0xbfe82fff]
> [    0.000000]  [mem 0xbfdbf000-0xbfe82fff] page 4k
> [    0.000000] BRK [0x0220f000, 0x0220ffff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0xbfebf000-0xbfedefff]
> [    0.000000]  [mem 0xbfebf000-0xbfedefff] page 4k
> [    0.000000] init_memory_mapping: [mem 0xbfef6000-0xbfefdfff]
> [    0.000000]  [mem 0xbfef6000-0xbfefdfff] page 4k
> [    0.000000] init_memory_mapping: [mem 0xbfeff000-0xbfefffff]
> [    0.000000]  [mem 0xbfeff000-0xbfefffff] page 4k
> [    0.000000] RAMDISK: [mem 0x36716000-0x37382fff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x00000000000FE020 000024 (v02 HP    )
> [    0.000000] ACPI: XSDT 0x00000000BFEFE120 000074 (v01 HPQOEM SLIC-MPC =
00000001      01000013)
> [    0.000000] ACPI: FACP 0x00000000BFEF3000 0000F4 (v04 HP     VADER    =
00000001 MSFT 01000013)
> [    0.000000] ACPI: DSDT 0x00000000BFEE4000 00A652 (v01 HP     VADER    =
00000001 MSFT 01000013)
> [    0.000000] ACPI: FACS 0x00000000BFE8C000 000040
> [    0.000000] ACPI: DMAR 0x00000000BFEF5000 000098 (v01        ?        =
00000001      00000000)
> [    0.000000] ACPI: SSDT 0x00000000BFEF4000 000655 (v01 PmRef  CpuPm    =
00003000 INTL 20060912)
> [    0.000000] ACPI: HPET 0x00000000BFEF2000 000038 (v01 HPQOEM SLIC-MPC =
00000001 MSFT 01000013)
> [    0.000000] ACPI: APIC 0x00000000BFEF1000 00006C (v02 HPQOEM SLIC-MPC =
00000001 MSFT 01000013)
> [    0.000000] ACPI: MCFG 0x00000000BFEF0000 00003C (v01 HPQOEM SLIC-MPC =
00000001 MSFT 01000013)
> [    0.000000] ACPI: ASF! 0x00000000BFEEF000 0000A5 (v32 HPQOEM SLIC-MPC =
00000001 MSFT 01000013)
> [    0.000000] ACPI: SLIC 0x00000000BFEE3000 000176 (v01 HPQOEM SLIC-MPC =
00000001 LOHR 000F4240)
> [    0.000000] ACPI: BOOT 0x00000000BFEE2000 000028 (v01 HPQOEM SLIC-MPC =
00000001 MSFT 01000013)
> [    0.000000] ACPI: SSDT 0x00000000BFEE1000 000296 (v01 INTEL  SataAhci =
00001000 INTL 20060912)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000013ffffff=
f]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fffffff]
> [    0.000000]   NODE_DATA [mem 0x13ffe9000-0x13fffcfff]
> [    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff88013b600=
000-ffff88013edfffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x13fffffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
> [    0.000000]   node   0: [mem 0x00100000-0xbfd6afff]
> [    0.000000]   node   0: [mem 0xbfdbf000-0xbfe82fff]
> [    0.000000]   node   0: [mem 0xbfebf000-0xbfedefff]
> [    0.000000]   node   0: [mem 0xbfef6000-0xbfefdfff]
> [    0.000000]   node   0: [mem 0xbfeff000-0xbfefffff]
> [    0.000000]   node   0: [mem 0x100000000-0x13fffffff]
> [    0.000000] On node 0 totalpages: 1048053
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3997 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 10691 pages used for memmap
> [    0.000000]   DMA32 zone: 781912 pages, LIFO batch:31
> [    0.000000]   Normal zone: 3584 pages used for memmap
> [    0.000000]   Normal zone: 262144 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI =
0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbfd6b000-0xbfdbefff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbfe83000-0xbfebefff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbfedf000-0xbfef5fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbfefe000-0xbfefefff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbff00000-0xbfffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xf7ffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed0ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed13fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed14000-0xfed17fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed18000-0xfed19fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffefffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfff00000-0xffffffff]
> [    0.000000] e820: [mem 0xc0000000-0xf7ffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4=
 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88013fc00000 s79104 r81=
92 d23296 u524288
> [    0.000000] pcpu-alloc: s79104 r8192 d23296 u524288 alloc=3D1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3=20
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  To=
tal pages: 1033701
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-3.16.7-29-=
desktop root=3DUUID=3D656dc65f-240b-4137-a490-0175717dd7fa resume=3D/dev/di=
sk/by-uuid/4d8e38d7-cfb9-4101-965e-1a66d96bd37d splash=3Dsilent quiet showo=
pts
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] AGP: Checking aperture...
> [    0.000000] AGP: No AGP bridge found
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at ../drivers/iommu/dmar.c:760 warn=
_invalid_dmar+0x7a/0x8a()
> [    0.000000] Your BIOS is broken; DMAR reported at address 0!
> BIOS vendor: Hewlett-Packard; Ver: F.23; Product Version: F.23
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.16.7-29-desktop =
#1
> [    0.000000] Hardware name: Hewlett-Packard HP Pavilion dv7 Notebook PC=
/30F4, BIOS F.23 12/04/2008
> [    0.000000]  ffffffff81006c35 ffffffff8161c923 ffffffff81e03e80 ffffff=
ff8105caf7
> [    0.000000]  ffffffff8220a010 ffffffff81e03ed0 0000000000000000 ffffff=
ff81fb52c0
> [    0.000000]  ffffffff81e03fb0 ffffffff8105cba4 ffffffff81a95e38 ffffff=
ff00000030
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff810051ee>] dump_trace+0x8e/0x350
> [    0.000000]  [<ffffffff81005556>] show_stack_log_lvl+0xa6/0x190
> [    0.000000]  [<ffffffff81006c51>] show_stack+0x21/0x50
> [    0.000000]  [<ffffffff8161c923>] dump_stack+0x49/0x6a
> [    0.000000]  [<ffffffff8105caf7>] warn_slowpath_common+0x77/0x90
> [    0.000000]  [<ffffffff8105cba4>] warn_slowpath_fmt_taint+0x44/0x50
> [    0.000000]  [<ffffffff8161dc50>] warn_invalid_dmar+0x7a/0x8a
> [    0.000000]  [<ffffffff81f6144a>] detect_intel_iommu+0x79/0x16a
> [    0.000000]  [<ffffffff81f17c31>] pci_iommu_alloc+0x46/0x67
> [    0.000000]  [<ffffffff81f28be7>] mem_init+0x11/0x99
> [    0.000000]  [<ffffffff81f12de9>] start_kernel+0x22e/0x498
> [    0.000000]  [<ffffffff81f126fb>] x86_64_start_kernel+0x14d/0x15c
> [    0.000000] ---[ end trace a9058d2246002da8 ]---
> [    0.000000] Memory: 4036732K/4192212K available (6305K kernel code, 10=
09K rwdata, 4708K rodata, 1560K init, 1532K bss, 155480K reserved)
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] 	RCU restricting CPUs from NR_CPUS=3D512 to nr_cpu_ids=3D4.
> [    0.000000] 	Offload RCU callbacks from all CPUs
> [    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D4
> [    0.000000] NR_IRQS:33024 nr_irqs:712 16
> [    0.000000] Console: colour dummy device 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] allocated 16777216 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.000000] tsc: Detected 2127.905 MHz processor
> [    0.001015] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 4255.81 BogoMIPS (lpj=3D2127905)
> [    0.001019] pid_max: default: 32768 minimum: 301
> [    0.001033] ACPI: Core revision 20140424
> [    0.014918] ACPI: All ACPI Tables successfully acquired
> [    0.015048] Security Framework initialized
> [    0.015067] AppArmor: AppArmor initialized
> [    0.016185] Dentry cache hash table entries: 524288 (order: 10, 419430=
4 bytes)
> [    0.018254] Inode-cache hash table entries: 262144 (order: 9, 2097152 =
bytes)
> [    0.019283] Mount-cache hash table entries: 8192 (order: 4, 65536 byte=
s)
> [    0.019291] Mountpoint-cache hash table entries: 8192 (order: 4, 65536=
 bytes)
> [    0.019669] Initializing cgroup subsys memory
> [    0.019702] Initializing cgroup subsys devices
> [    0.019711] Initializing cgroup subsys freezer
> [    0.019715] Initializing cgroup subsys net_cls
> [    0.019723] Initializing cgroup subsys blkio
> [    0.019729] Initializing cgroup subsys perf_event
> [    0.019732] Initializing cgroup subsys net_prio
> [    0.019741] Initializing cgroup subsys hugetlb
> [    0.019770] CPU: Physical Processor ID: 0
> [    0.019771] CPU: Processor Core ID: 0
> [    0.019774] mce: CPU supports 6 MCE banks
> [    0.019783] CPU0: Thermal monitoring enabled (TM1)
> [    0.019791] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
> Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
> tlb_flushall_shift: -1
> [    0.019891] Freeing SMP alternatives memory: 24K (ffffffff82084000 - f=
fffffff8208a000)
> [    0.021183] ftrace: allocating 24414 entries in 96 pages
> [    0.027114] dmar: Host address width 36
> [    0.027118] dmar: DRHD base: 0x00000000000000 flags: 0x1
> [    0.027120] dmar: parse DMAR table failure.
> [    0.027543] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=
=3D-1
> [    0.037579] smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     P7450  @ 2.1=
3GHz (fam: 06, model: 17, stepping: 06)
> [    0.038000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, =
Intel PMU driver.
> [    0.038000] ... version:                2
> [    0.038000] ... bit width:              40
> [    0.038000] ... generic registers:      2
> [    0.038000] ... value mask:             000000ffffffffff
> [    0.038000] ... max period:             000000007fffffff
> [    0.038000] ... fixed-purpose events:   3
> [    0.038000] ... event mask:             0000000700000003
> [    0.048143] x86: Booting SMP configuration:
> [    0.048145] .... node  #0, CPUs:      #1
> [    0.002000] CPU1 microcode updated early to revision 0x60f, date =3D 2=
010-09-29
> [    0.061112] NMI watchdog: enabled on all CPUs, permanently consumes on=
e hw-PMU counter.
> [    0.061125] x86: Booted up 1 node, 2 CPUs
> [    0.061128] smpboot: Total of 2 processors activated (8511.62 BogoMIPS)
> [    0.062144] devtmpfs: initialized
> [    0.069072] PM: Registering ACPI NVS region [mem 0xbfe83000-0xbfebefff=
] (245760 bytes)
> [    0.070374] pinctrl core: initialized pinctrl subsystem
> [    0.070421] RTC time: 14:37:34, date: 10/31/15
> [    0.070491] NET: Registered protocol family 16
> [    0.070664] cpuidle: using governor ladder
> [    0.070667] cpuidle: using governor menu
> [    0.070724] ACPI: bus type PCI registered
> [    0.070727] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.070828] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf80000=
00-0xfbffffff] (base 0xf8000000)
> [    0.070831] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E=
820
> [    0.070943] PCI: Using configuration type 1 for base access
> [    0.071143] mtrr: your CPUs had inconsistent variable MTRR settings
> [    0.071144] mtrr: probably your BIOS does not setup all CPUs.
> [    0.071145] mtrr: corrected configuration.
> [    0.074086] ACPI: Added _OSI(Module Device)
> [    0.074086] ACPI: Added _OSI(Processor Device)
> [    0.074086] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.074086] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.077849] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.079509] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.086374] ACPI: Dynamic OEM Table Load:
> [    0.086382] ACPI: SSDT 0xFFFF8801399F5800 000223 (v01 PmRef  Cpu0Ist  =
00003000 INTL 20060912)
> [    0.087126] ACPI: Dynamic OEM Table Load:
> [    0.087134] ACPI: SSDT 0xFFFF88013F041800 0005B3 (v01 PmRef  Cpu0Cst  =
00003001 INTL 20060912)
> [    0.091438] ACPI: Dynamic OEM Table Load:
> [    0.091446] ACPI: SSDT 0xFFFF8801398D0000 0001CF (v01 PmRef  ApIst    =
00003000 INTL 20060912)
> [    0.094127] ACPI: Dynamic OEM Table Load:
> [    0.094133] ACPI: SSDT 0xFFFF880139A2FE80 00008D (v01 PmRef  ApCst    =
00003000 INTL 20060912)
> [    0.118022] ACPI : EC: GPE storm detected(10 GPEs), transactions will =
use polling mode
> [    0.118022] ACPI: Interpreter enabled
> [    0.118022] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S1_] (20140424/hwxface-580)
> [    0.118022] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S2_] (20140424/hwxface-580)
> [    0.118043] ACPI: (supports S0 S3 S4 S5)
> [    0.118045] ACPI: Using IOAPIC for interrupt routing
> [    0.118086] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
> [    0.358219] [Firmware Bug]: ACPI: No _BQC method, cannot determine ini=
tial brightness
> [    0.359282] [Firmware Bug]: ACPI: No _BQC method, cannot determine ini=
tial brightness
> [    0.383018] ACPI: Power Resource [FN00] (off)
> [    0.509613] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.509620] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM Cl=
ockPM Segments MSI]
> [    0.509627] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    0.510704] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000=
 [bus 00-3f] only partially covers this bridge
> [    0.510943] PCI host bridge to bus 0000:00
> [    0.510946] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.510949] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.510951] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.510954] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
> [    0.510956] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebff=
fff]
> [    0.510965] pci 0000:00:00.0: [8086:2a40] type 00 class 0x060000
> [    0.510986] DMAR: Forcing write-buffer flush capability
> [    0.510988] DMAR: Disabling IOMMU for graphics on this chipset
> [    0.511098] pci 0000:00:01.0: [8086:2a41] type 01 class 0x060400
> [    0.511142] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    0.511285] pci 0000:00:1a.0: [8086:2937] type 00 class 0x0c0300
> [    0.511355] pci 0000:00:1a.0: reg 0x20: [io  0x80e0-0x80ff]
> [    0.511502] pci 0000:00:1a.0: System wakeup disabled by ACPI
> [    0.511568] pci 0000:00:1a.1: [8086:2938] type 00 class 0x0c0300
> [    0.511642] pci 0000:00:1a.1: reg 0x20: [io  0x80c0-0x80df]
> [    0.511783] pci 0000:00:1a.1: System wakeup disabled by ACPI
> [    0.511856] pci 0000:00:1a.7: [8086:293c] type 00 class 0x0c0320
> [    0.511884] pci 0000:00:1a.7: reg 0x10: [mem 0xdf004c00-0xdf004fff]
> [    0.512012] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> [    0.512098] pci 0000:00:1a.7: System wakeup disabled by ACPI
> [    0.512165] pci 0000:00:1b.0: [8086:293e] type 00 class 0x040300
> [    0.512188] pci 0000:00:1b.0: reg 0x10: [mem 0xdf000000-0xdf003fff 64b=
it]
> [    0.512283] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.512401] pci 0000:00:1c.0: [8086:2940] type 01 class 0x060400
> [    0.512498] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.512564] pci 0000:00:1c.0: System wakeup disabled by ACPI
> [    0.512624] pci 0000:00:1c.1: [8086:2942] type 01 class 0x060400
> [    0.512722] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.512787] pci 0000:00:1c.1: System wakeup disabled by ACPI
> [    0.512847] pci 0000:00:1c.2: [8086:2944] type 01 class 0x060400
> [    0.512943] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    0.513014] pci 0000:00:1c.2: System wakeup disabled by ACPI
> [    0.513074] pci 0000:00:1c.3: [8086:2946] type 01 class 0x060400
> [    0.513174] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    0.513241] pci 0000:00:1c.3: System wakeup disabled by ACPI
> [    0.513302] pci 0000:00:1c.4: [8086:2948] type 01 class 0x060400
> [    0.513398] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    0.513463] pci 0000:00:1c.4: System wakeup disabled by ACPI
> [    0.513523] pci 0000:00:1c.5: [8086:294a] type 01 class 0x060400
> [    0.513630] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
> [    0.513697] pci 0000:00:1c.5: System wakeup disabled by ACPI
> [    0.513762] pci 0000:00:1d.0: [8086:2934] type 00 class 0x0c0300
> [    0.513833] pci 0000:00:1d.0: reg 0x20: [io  0x80a0-0x80bf]
> [    0.513980] pci 0000:00:1d.0: System wakeup disabled by ACPI
> [    0.514049] pci 0000:00:1d.1: [8086:2935] type 00 class 0x0c0300
> [    0.514123] pci 0000:00:1d.1: reg 0x20: [io  0x8080-0x809f]
> [    0.514264] pci 0000:00:1d.1: System wakeup disabled by ACPI
> [    0.514329] pci 0000:00:1d.2: [8086:2936] type 00 class 0x0c0300
> [    0.514401] pci 0000:00:1d.2: reg 0x20: [io  0x8060-0x807f]
> [    0.514539] pci 0000:00:1d.2: System wakeup disabled by ACPI
> [    0.514604] pci 0000:00:1d.3: [8086:2939] type 00 class 0x0c0300
> [    0.514676] pci 0000:00:1d.3: reg 0x20: [io  0x8040-0x805f]
> [    0.514850] pci 0000:00:1d.7: [8086:293a] type 00 class 0x0c0320
> [    0.514878] pci 0000:00:1d.7: reg 0x10: [mem 0xdf004800-0xdf004bff]
> [    0.515005] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.515089] pci 0000:00:1d.7: System wakeup disabled by ACPI
> [    0.515148] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
> [    0.515270] pci 0000:00:1e.0: System wakeup disabled by ACPI
> [    0.515331] pci 0000:00:1f.0: [8086:2919] type 00 class 0x060100
> [    0.515565] pci 0000:00:1f.2: [8086:2929] type 00 class 0x010601
> [    0.515593] pci 0000:00:1f.2: reg 0x10: [io  0x8108-0x810f]
> [    0.515604] pci 0000:00:1f.2: reg 0x14: [io  0x8114-0x8117]
> [    0.515615] pci 0000:00:1f.2: reg 0x18: [io  0x8100-0x8107]
> [    0.515626] pci 0000:00:1f.2: reg 0x1c: [io  0x8110-0x8113]
> [    0.515636] pci 0000:00:1f.2: reg 0x20: [io  0x8020-0x803f]
> [    0.515647] pci 0000:00:1f.2: reg 0x24: [mem 0xdf004000-0xdf0047ff]
> [    0.515707] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.515819] pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500
> [    0.515839] pci 0000:00:1f.3: reg 0x10: [mem 0xdf005000-0xdf0050ff 64b=
it]
> [    0.515865] pci 0000:00:1f.3: reg 0x20: [io  0x8000-0x801f]
> [    0.516115] pci 0000:01:00.0: [10de:0649] type 00 class 0x030000
> [    0.516173] pci 0000:01:00.0: reg 0x10: [mem 0xd2000000-0xd2ffffff]
> [    0.516202] pci 0000:01:00.0: reg 0x14: [mem 0xc0000000-0xcfffffff 64b=
it pref]
> [    0.516237] pci 0000:01:00.0: reg 0x1c: [mem 0xd0000000-0xd1ffffff 64b=
it]
> [    0.516267] pci 0000:01:00.0: reg 0x24: [io  0x7000-0x707f]
> [    0.516298] pci 0000:01:00.0: reg 0x30: [mem 0xfff80000-0xffffffff pre=
f]
> [    0.518039] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.518043] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
> [    0.518046] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xd2ffff=
ff]
> [    0.518050] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffff=
ff 64bit pref]
> [    0.518233] pci 0000:02:00.0: [8086:4237] type 00 class 0x028000
> [    0.518295] pci 0000:02:00.0: reg 0x10: [mem 0xde000000-0xde001fff 64b=
it]
> [    0.518515] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
> [    0.518568] pci 0000:02:00.0: System wakeup disabled by ACPI
> [    0.520043] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.520048] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
> [    0.520053] pci 0000:00:1c.0:   bridge window [mem 0xde000000-0xdeffff=
ff]
> [    0.520059] pci 0000:00:1c.0:   bridge window [mem 0xd3000000-0xd3ffff=
ff 64bit pref]
> [    0.520144] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.520148] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
> [    0.520153] pci 0000:00:1c.1:   bridge window [mem 0xdd000000-0xddffff=
ff]
> [    0.520160] pci 0000:00:1c.1:   bridge window [mem 0xd4000000-0xd4ffff=
ff 64bit pref]
> [    0.520249] pci 0000:00:1c.2: PCI bridge to [bus 04]
> [    0.520254] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
> [    0.520258] pci 0000:00:1c.2:   bridge window [mem 0xdc000000-0xdcffff=
ff]
> [    0.520265] pci 0000:00:1c.2:   bridge window [mem 0xd5000000-0xd5ffff=
ff 64bit pref]
> [    0.520437] pci 0000:05:00.0: [10ec:8168] type 00 class 0x020000
> [    0.520509] pci 0000:05:00.0: reg 0x10: [io  0x3000-0x30ff]
> [    0.520618] pci 0000:05:00.0: reg 0x18: [mem 0xd6010000-0xd6010fff 64b=
it pref]
> [    0.520687] pci 0000:05:00.0: reg 0x20: [mem 0xd6000000-0xd600ffff 64b=
it pref]
> [    0.520731] pci 0000:05:00.0: reg 0x30: [mem 0xffff0000-0xffffffff pre=
f]
> [    0.520996] pci 0000:05:00.0: supports D1 D2
> [    0.520998] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.521096] pci 0000:05:00.0: System wakeup disabled by ACPI
> [    0.521221] pci 0000:00:1c.3: PCI bridge to [bus 05]
> [    0.521226] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
> [    0.521230] pci 0000:00:1c.3:   bridge window [mem 0xdb000000-0xdbffff=
ff]
> [    0.521238] pci 0000:00:1c.3:   bridge window [mem 0xd6000000-0xd6ffff=
ff 64bit pref]
> [    0.521389] pci 0000:06:00.0: [197b:2380] type 00 class 0x0c0010
> [    0.521420] pci 0000:06:00.0: reg 0x10: [mem 0xda000000-0xda0007ff]
> [    0.521440] pci 0000:06:00.0: reg 0x14: [mem 0xda000d00-0xda000d7f]
> [    0.521495] pci 0000:06:00.0: reg 0x20: [mem 0xda000c80-0xda000cff]
> [    0.521514] pci 0000:06:00.0: reg 0x24: [mem 0xda000c00-0xda000c7f]
> [    0.521669] pci 0000:06:00.0: System wakeup disabled by ACPI
> [    0.521743] pci 0000:06:00.1: [197b:2382] type 00 class 0x088000
> [    0.521770] pci 0000:06:00.1: reg 0x10: [mem 0xda000b00-0xda000bff]
> [    0.522045] pci 0000:06:00.2: [197b:2381] type 00 class 0x080501
> [    0.522072] pci 0000:06:00.2: reg 0x10: [mem 0xda000a00-0xda000aff]
> [    0.522343] pci 0000:06:00.3: [197b:2383] type 00 class 0x088000
> [    0.522370] pci 0000:06:00.3: reg 0x10: [mem 0xda000900-0xda0009ff]
> [    0.522640] pci 0000:06:00.4: [197b:2384] type 00 class 0x088000
> [    0.522667] pci 0000:06:00.4: reg 0x10: [mem 0xda000800-0xda0008ff]
> [    0.525025] pci 0000:00:1c.4: PCI bridge to [bus 06]
> [    0.525030] pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
> [    0.525034] pci 0000:00:1c.4:   bridge window [mem 0xda000000-0xdaffff=
ff]
> [    0.525041] pci 0000:00:1c.4:   bridge window [mem 0xd7000000-0xd7ffff=
ff 64bit pref]
> [    0.525127] pci 0000:00:1c.5: PCI bridge to [bus 07-09]
> [    0.525132] pci 0000:00:1c.5:   bridge window [io  0x1000-0x1fff]
> [    0.525137] pci 0000:00:1c.5:   bridge window [mem 0xd9000000-0xd9ffff=
ff]
> [    0.525144] pci 0000:00:1c.5:   bridge window [mem 0xd8000000-0xd8ffff=
ff 64bit pref]
> [    0.525243] pci 0000:00:1e.0: PCI bridge to [bus 0a] (subtractive deco=
de)
> [    0.525255] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (sub=
tractive decode)
> [    0.525257] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (sub=
tractive decode)
> [    0.525259] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bff=
ff] (subtractive decode)
> [    0.525262] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfff=
ff] (subtractive decode)
> [    0.525504] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
> [    0.525618] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
> [    0.525731] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
> [    0.525843] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
> [    0.525955] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 *11 12)
> [    0.526070] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 *11 12)
> [    0.526183] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 *11 12)
> [    0.526295] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 11 12) =
*0, disabled.
> [    0.534109] ACPI: Enabled 5 GPEs in block 00 to 3F
> [    0.534179] ACPI : EC: GPE =3D 0x17, I/O: command/status =3D 0x66, dat=
a =3D 0x62
> [    0.534248] vgaarb: setting as boot device: PCI:0000:01:00.0
> [    0.534248] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
> [    0.534248] vgaarb: loaded
> [    0.534248] vgaarb: bridge control possible 0000:01:00.0
> [    0.534248] SCSI subsystem initialized
> [    0.534248] libata version 3.00 loaded.
> [    0.534248] ACPI: bus type USB registered
> [    0.534248] usbcore: registered new interface driver usbfs
> [    0.534248] usbcore: registered new interface driver hub
> [    0.534248] usbcore: registered new device driver usb
> [    0.534248] PCI: Using ACPI for IRQ routing
> [    0.536554] PCI: pci_cache_line_size set to 64 bytes
> [    0.536720] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
> [    0.536722] e820: reserve RAM buffer [mem 0xbfd6b000-0xbfffffff]
> [    0.536724] e820: reserve RAM buffer [mem 0xbfe83000-0xbfffffff]
> [    0.536726] e820: reserve RAM buffer [mem 0xbfedf000-0xbfffffff]
> [    0.536728] e820: reserve RAM buffer [mem 0xbfefe000-0xbfffffff]
> [    0.536730] e820: reserve RAM buffer [mem 0xbff00000-0xbfffffff]
> [    0.536878] NetLabel: Initializing
> [    0.536880] NetLabel:  domain hash size =3D 128
> [    0.536881] NetLabel:  protocols =3D UNLABELED CIPSOv4
> [    0.536900] NetLabel:  unlabeled traffic allowed by default
> [    0.536935] HPET: 4 timers in total, 0 timers will be used for per-cpu=
 timer
> [    0.536940] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
> [    0.536945] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
> [    0.539030] Switched to clocksource hpet
> [    0.548475] AppArmor: AppArmor Filesystem Enabled
> [    0.548528] pnp: PnP ACPI init
> [    0.548552] ACPI: bus type PNP registered
> [    0.667311] pnp 00:00: disabling [io  0x164e-0x164f] because it overla=
ps 0000:00:1c.5 BAR 13 [io  0x1000-0x1fff]
> [    0.667414] system 00:00: [io  0x0600-0x060f] has been reserved
> [    0.667417] system 00:00: [io  0x0610] has been reserved
> [    0.667420] system 00:00: [io  0x0800-0x080f] has been reserved
> [    0.667423] system 00:00: [io  0x0810-0x0817] has been reserved
> [    0.667425] system 00:00: [io  0x0820-0x0823] has been reserved
> [    0.667428] system 00:00: [io  0x0400-0x047f] could not be reserved
> [    0.667431] system 00:00: [io  0x0500-0x053f] has been reserved
> [    0.667434] system 00:00: [mem 0xf8000000-0xfbffffff] has been reserved
> [    0.667437] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.667439] system 00:00: [mem 0xfed10000-0xfed13fff] has been reserved
> [    0.667442] system 00:00: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.667445] system 00:00: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.667448] system 00:00: [mem 0xfec00000-0xfec00fff] could not be res=
erved
> [    0.667450] system 00:00: [mem 0xfed20000-0xfed8ffff] has been reserved
> [    0.667453] system 00:00: [mem 0xfee00000-0xfee00fff] has been reserved
> [    0.667457] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
> [    0.667524] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.667634] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.667691] pnp 00:03: Plug and Play ACPI device, IDs SYN0156 SYN0100 =
SYN0002 PNP0f13 (active)
> [    0.667857] pnp 00:04: Plug and Play ACPI device, IDs ENE0100 (active)
> [    0.667964] pnp: PnP ACPI: found 5 devices
> [    0.667965] ACPI: bus type PNP unregistered
> [    0.675471] pci 0000:01:00.0: can't claim BAR 6 [mem 0xfff80000-0xffff=
ffff pref]: no compatible bridge window
> [    0.675476] pci 0000:05:00.0: can't claim BAR 6 [mem 0xffff0000-0xffff=
ffff pref]: no compatible bridge window
> [    0.675546] pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x800=
00)
> [    0.675549] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.675552] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
> [    0.675556] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xd2ffff=
ff]
> [    0.675560] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffff=
ff 64bit pref]
> [    0.675564] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.675568] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
> [    0.675574] pci 0000:00:1c.0:   bridge window [mem 0xde000000-0xdeffff=
ff]
> [    0.675578] pci 0000:00:1c.0:   bridge window [mem 0xd3000000-0xd3ffff=
ff 64bit pref]
> [    0.675585] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.675589] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
> [    0.675594] pci 0000:00:1c.1:   bridge window [mem 0xdd000000-0xddffff=
ff]
> [    0.675599] pci 0000:00:1c.1:   bridge window [mem 0xd4000000-0xd4ffff=
ff 64bit pref]
> [    0.675605] pci 0000:00:1c.2: PCI bridge to [bus 04]
> [    0.675609] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
> [    0.675614] pci 0000:00:1c.2:   bridge window [mem 0xdc000000-0xdcffff=
ff]
> [    0.675619] pci 0000:00:1c.2:   bridge window [mem 0xd5000000-0xd5ffff=
ff 64bit pref]
> [    0.675628] pci 0000:05:00.0: BAR 6: assigned [mem 0xdb000000-0xdb00ff=
ff pref]
> [    0.675631] pci 0000:00:1c.3: PCI bridge to [bus 05]
> [    0.675634] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
> [    0.675640] pci 0000:00:1c.3:   bridge window [mem 0xdb000000-0xdbffff=
ff]
> [    0.675645] pci 0000:00:1c.3:   bridge window [mem 0xd6000000-0xd6ffff=
ff 64bit pref]
> [    0.675652] pci 0000:00:1c.4: PCI bridge to [bus 06]
> [    0.675656] pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
> [    0.675661] pci 0000:00:1c.4:   bridge window [mem 0xda000000-0xdaffff=
ff]
> [    0.675666] pci 0000:00:1c.4:   bridge window [mem 0xd7000000-0xd7ffff=
ff 64bit pref]
> [    0.675673] pci 0000:00:1c.5: PCI bridge to [bus 07-09]
> [    0.675676] pci 0000:00:1c.5:   bridge window [io  0x1000-0x1fff]
> [    0.675682] pci 0000:00:1c.5:   bridge window [mem 0xd9000000-0xd9ffff=
ff]
> [    0.675686] pci 0000:00:1c.5:   bridge window [mem 0xd8000000-0xd8ffff=
ff 64bit pref]
> [    0.675693] pci 0000:00:1e.0: PCI bridge to [bus 0a]
> [    0.675707] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.675709] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.675712] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.675714] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfebfffff]
> [    0.675717] pci_bus 0000:01: resource 0 [io  0x7000-0x7fff]
> [    0.675719] pci_bus 0000:01: resource 1 [mem 0xd0000000-0xd2ffffff]
> [    0.675721] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64b=
it pref]
> [    0.675724] pci_bus 0000:02: resource 0 [io  0x6000-0x6fff]
> [    0.675726] pci_bus 0000:02: resource 1 [mem 0xde000000-0xdeffffff]
> [    0.675728] pci_bus 0000:02: resource 2 [mem 0xd3000000-0xd3ffffff 64b=
it pref]
> [    0.675731] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
> [    0.675733] pci_bus 0000:03: resource 1 [mem 0xdd000000-0xddffffff]
> [    0.675735] pci_bus 0000:03: resource 2 [mem 0xd4000000-0xd4ffffff 64b=
it pref]
> [    0.675737] pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
> [    0.675740] pci_bus 0000:04: resource 1 [mem 0xdc000000-0xdcffffff]
> [    0.675742] pci_bus 0000:04: resource 2 [mem 0xd5000000-0xd5ffffff 64b=
it pref]
> [    0.675744] pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
> [    0.675746] pci_bus 0000:05: resource 1 [mem 0xdb000000-0xdbffffff]
> [    0.675749] pci_bus 0000:05: resource 2 [mem 0xd6000000-0xd6ffffff 64b=
it pref]
> [    0.675751] pci_bus 0000:06: resource 0 [io  0x2000-0x2fff]
> [    0.675753] pci_bus 0000:06: resource 1 [mem 0xda000000-0xdaffffff]
> [    0.675755] pci_bus 0000:06: resource 2 [mem 0xd7000000-0xd7ffffff 64b=
it pref]
> [    0.675758] pci_bus 0000:07: resource 0 [io  0x1000-0x1fff]
> [    0.675760] pci_bus 0000:07: resource 1 [mem 0xd9000000-0xd9ffffff]
> [    0.675762] pci_bus 0000:07: resource 2 [mem 0xd8000000-0xd8ffffff 64b=
it pref]
> [    0.675765] pci_bus 0000:0a: resource 4 [io  0x0000-0x0cf7]
> [    0.675767] pci_bus 0000:0a: resource 5 [io  0x0d00-0xffff]
> [    0.675769] pci_bus 0000:0a: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.675771] pci_bus 0000:0a: resource 7 [mem 0xc0000000-0xfebfffff]
> [    0.675821] NET: Registered protocol family 2
> [    0.676099] TCP established hash table entries: 32768 (order: 6, 26214=
4 bytes)
> [    0.676239] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
> [    0.676444] TCP: Hash tables configured (established 32768 bind 32768)
> [    0.676487] TCP: reno registered
> [    0.676496] UDP hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.676529] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.676619] NET: Registered protocol family 1
> [    1.777016] pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?) 01=
010001
> [    2.879017] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01=
010001
> [    2.879384] pci 0000:01:00.0: Video device with shadowed ROM
> [    2.879442] PCI: CLS 64 bytes, default 64
> [    2.879506] Unpacking initramfs...
> [    4.537889] Freeing initrd memory: 12724K (ffff880036716000 - ffff8800=
37383000)
> [    4.537906] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    4.537909] software IO TLB [mem 0xbbd6b000-0xbfd6b000] (64MB) mapped =
at [ffff8800bbd6b000-ffff8800bfd6afff]
> [    4.537963] Simple Boot Flag value 0x5 read from CMOS RAM was invalid
> [    4.537965] Simple Boot Flag at 0x44 set to 0x1
> [    4.538186] microcode: CPU0 sig=3D0x10676, pf=3D0x80, revision=3D0x60f
> [    4.538195] microcode: CPU1 sig=3D0x10676, pf=3D0x80, revision=3D0x60f
> [    4.538296] microcode: Microcode Update Driver: v2.00 <tigran@aivazian=
=2Efsnet.co.uk>, Peter Oruba
> [    4.538329] Scanning for low memory corruption every 60 seconds
> [    4.538726] futex hash table entries: 1024 (order: 4, 65536 bytes)
> [    4.538781] audit: initializing netlink subsys (disabled)
> [    4.538813] audit: type=3D2000 audit(1446302257.537:1): initialized
> [    4.539241] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    4.539293] zbud: loaded
> [    4.539505] VFS: Disk quotas dquot_6.5.2
> [    4.539525] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    4.539723] msgmni has been set to 7909
> [    4.539766] Key type big_key registered
> [    4.540105] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 252)
> [    4.540164] io scheduler noop registered
> [    4.540168] io scheduler deadline registered
> [    4.540209] io scheduler cfq registered (default)
> [    4.540608] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
> [    4.540896] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
> [    4.541230] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
> [    4.541549] pcieport 0000:00:1c.2: irq 43 for MSI/MSI-X
> [    4.541866] pcieport 0000:00:1c.3: irq 44 for MSI/MSI-X
> [    4.542194] pcieport 0000:00:1c.4: irq 45 for MSI/MSI-X
> [    4.542515] pcieport 0000:00:1c.5: irq 46 for MSI/MSI-X
> [    4.542647] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    4.542669] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    4.542731] vesafb: mode is 640x480x32, linelength=3D2560, pages=3D0
> [    4.542733] vesafb: scrolling: redraw
> [    4.542735] vesafb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
> [    4.542751] vesafb: framebuffer at 0xd1000000, mapped to 0xffffc900047=
80000, using 1216k, total 1216k
> [    4.557256] Console: switching to colour frame buffer device 80x30
> [    4.571571] fb0: VESA VGA frame buffer device
> [    4.571594] intel_idle: does not run on family 6 model 23
> [    4.571652] GHES: HEST is not enabled!
> [    4.571713] Serial: 8250/16550 driver, 32 ports, IRQ sharing disabled
> [    4.574026] Non-volatile memory driver v1.3
> [    4.574030] Linux agpgart interface v0.103
> [    4.574277] ahci 0000:00:1f.2: version 3.0
> [    4.574539] ahci 0000:00:1f.2: irq 47 for MSI/MSI-X
> [    4.574584] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
> [    4.574622] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps =
0x33 impl SATA mode
> [    4.574625] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led =
clo pmp pio slum part ccc ems=20
> [    4.580862] scsi0 : ahci
> [    4.581031] scsi1 : ahci
> [    4.581166] scsi2 : ahci
> [    4.581300] scsi3 : ahci
> [    4.581432] scsi4 : ahci
> [    4.581562] scsi5 : ahci
> [    4.581629] ata1: SATA max UDMA/133 abar m2048@0xdf004000 port 0xdf004=
100 irq 47
> [    4.581632] ata2: SATA max UDMA/133 abar m2048@0xdf004000 port 0xdf004=
180 irq 47
> [    4.581633] ata3: DUMMY
> [    4.581635] ata4: DUMMY
> [    4.581638] ata5: SATA max UDMA/133 abar m2048@0xdf004000 port 0xdf004=
300 irq 47
> [    4.581641] ata6: SATA max UDMA/133 abar m2048@0xdf004000 port 0xdf004=
380 irq 47
> [    4.581677] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    4.581687] ehci-pci: EHCI PCI platform driver
> [    4.581958] ehci-pci 0000:00:1a.7: EHCI Host Controller
> [    4.581968] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bu=
s number 1
> [    4.581984] ehci-pci 0000:00:1a.7: debug port 1
> [    4.585892] ehci-pci 0000:00:1a.7: cache line size of 64 is not suppor=
ted
> [    4.585909] ehci-pci 0000:00:1a.7: irq 18, io mem 0xdf004c00
> [    4.591020] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
> [    4.591131] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
> [    4.591135] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
> [    4.591137] usb usb1: Product: EHCI Host Controller
> [    4.591139] usb usb1: Manufacturer: Linux 3.16.7-29-desktop ehci_hcd
> [    4.591141] usb usb1: SerialNumber: 0000:00:1a.7
> [    4.591307] hub 1-0:1.0: USB hub found
> [    4.591325] hub 1-0:1.0: 4 ports detected
> [    4.591780] ehci-pci 0000:00:1d.7: EHCI Host Controller
> [    4.591787] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bu=
s number 2
> [    4.591803] ehci-pci 0000:00:1d.7: debug port 1
> [    4.595719] ehci-pci 0000:00:1d.7: cache line size of 64 is not suppor=
ted
> [    4.595736] ehci-pci 0000:00:1d.7: irq 20, io mem 0xdf004800
> [    4.601020] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    4.601089] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
> [    4.601092] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
> [    4.601094] usb usb2: Product: EHCI Host Controller
> [    4.601096] usb usb2: Manufacturer: Linux 3.16.7-29-desktop ehci_hcd
> [    4.601098] usb usb2: SerialNumber: 0000:00:1d.7
> [    4.601231] hub 2-0:1.0: USB hub found
> [    4.601241] hub 2-0:1.0: 8 ports detected
> [    4.601487] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    4.601492] uhci_hcd: USB Universal Host Controller Interface driver
> [    4.601735] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    4.601742] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bu=
s number 3
> [    4.601752] uhci_hcd 0000:00:1a.0: detected 2 ports
> [    4.601786] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000080e0
> [    4.601841] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
> [    4.601844] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
> [    4.601846] usb usb3: Product: UHCI Host Controller
> [    4.601848] usb usb3: Manufacturer: Linux 3.16.7-29-desktop uhci_hcd
> [    4.601850] usb usb3: SerialNumber: 0000:00:1a.0
> [    4.601985] hub 3-0:1.0: USB hub found
> [    4.601995] hub 3-0:1.0: 2 ports detected
> [    4.602350] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    4.602357] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bu=
s number 4
> [    4.602366] uhci_hcd 0000:00:1a.1: detected 2 ports
> [    4.602398] uhci_hcd 0000:00:1a.1: irq 17, io base 0x000080c0
> [    4.602452] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
> [    4.602455] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
> [    4.602457] usb usb4: Product: UHCI Host Controller
> [    4.602460] usb usb4: Manufacturer: Linux 3.16.7-29-desktop uhci_hcd
> [    4.602462] usb usb4: SerialNumber: 0000:00:1a.1
> [    4.602592] hub 4-0:1.0: USB hub found
> [    4.602600] hub 4-0:1.0: 2 ports detected
> [    4.602948] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    4.602955] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bu=
s number 5
> [    4.602964] uhci_hcd 0000:00:1d.0: detected 2 ports
> [    4.602986] uhci_hcd 0000:00:1d.0: irq 20, io base 0x000080a0
> [    4.603052] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
> [    4.603055] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
> [    4.603057] usb usb5: Product: UHCI Host Controller
> [    4.603059] usb usb5: Manufacturer: Linux 3.16.7-29-desktop uhci_hcd
> [    4.603061] usb usb5: SerialNumber: 0000:00:1d.0
> [    4.603191] hub 5-0:1.0: USB hub found
> [    4.603199] hub 5-0:1.0: 2 ports detected
> [    4.603538] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    4.603545] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bu=
s number 6
> [    4.603554] uhci_hcd 0000:00:1d.1: detected 2 ports
> [    4.603585] uhci_hcd 0000:00:1d.1: irq 22, io base 0x00008080
> [    4.603642] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
> [    4.603645] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
> [    4.603647] usb usb6: Product: UHCI Host Controller
> [    4.603649] usb usb6: Manufacturer: Linux 3.16.7-29-desktop uhci_hcd
> [    4.603651] usb usb6: SerialNumber: 0000:00:1d.1
> [    4.603783] hub 6-0:1.0: USB hub found
> [    4.603792] hub 6-0:1.0: 2 ports detected
> [    4.604148] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    4.604156] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bu=
s number 7
> [    4.604164] uhci_hcd 0000:00:1d.2: detected 2 ports
> [    4.604185] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00008060
> [    4.604239] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
> [    4.604242] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
> [    4.604244] usb usb7: Product: UHCI Host Controller
> [    4.604247] usb usb7: Manufacturer: Linux 3.16.7-29-desktop uhci_hcd
> [    4.604249] usb usb7: SerialNumber: 0000:00:1d.2
> [    4.604383] hub 7-0:1.0: USB hub found
> [    4.604393] hub 7-0:1.0: 2 ports detected
> [    4.604734] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> [    4.604741] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bu=
s number 8
> [    4.604750] uhci_hcd 0000:00:1d.3: detected 2 ports
> [    4.604782] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00008040
> [    4.604839] usb usb8: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
> [    4.604842] usb usb8: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
> [    4.604844] usb usb8: Product: UHCI Host Controller
> [    4.604846] usb usb8: Manufacturer: Linux 3.16.7-29-desktop uhci_hcd
> [    4.604848] usb usb8: SerialNumber: 0000:00:1d.3
> [    4.604980] hub 8-0:1.0: USB hub found
> [    4.604988] hub 8-0:1.0: 2 ports detected
> [    4.605169] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUE] at =
0x60,0x64 irq 1,12
> [    4.643883] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    4.643919] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    4.644068] mousedev: PS/2 mouse device common for all mice
> [    4.646840] rtc_cmos 00:01: RTC can wake from S4
> [    4.647013] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
> [    4.647045] rtc_cmos 00:01: alarms up to one month, 242 bytes nvram, h=
pet irqs
> [    4.647063] ledtrig-cpu: registered to indicate activity on CPUs
> [    4.647089] hidraw: raw HID events driver (C) Jiri Kosina
> [    4.647227] usbcore: registered new interface driver usbhid
> [    4.647229] usbhid: USB HID core driver
> [    4.647296] TCP: cubic registered
> [    4.647336] NET: Registered protocol family 10
> [    4.647918] registered taskstats version 1
> [    4.648023] AppArmor: AppArmor sha1 policy hashing enabled
> [    4.648797]   Magic number: 3:421:638
> [    4.648926] rtc_cmos 00:01: setting system clock to 2015-10-31 14:37:3=
8 UTC (1446302258)
> [    4.649050] PM: Checking hibernation image partition /dev/disk/by-uuid=
/4d8e38d7-cfb9-4101-965e-1a66d96bd37d
> [    4.690202] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input0
> [    4.903017] usb 2-1: new high-speed USB device number 2 using ehci-pci
> [    5.022784] usb 2-1: New USB device found, idVendor=3D12d1, idProduct=
=3D1436
> [    5.022787] usb 2-1: New USB device strings: Mfr=3D4, Product=3D3, Ser=
ialNumber=3D0
> [    5.022789] usb 2-1: Product: HUAWEI Mobile
> [    5.022791] usb 2-1: Manufacturer: HUAWEI Technology
> [    5.043027] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    5.044074] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by d=
evice (Stat=3D0x51 Err=3D0x04)
> [    5.044214] ata1.00: ACPI cmd ef/10:01:00:00:00:a0 (SET FEATURES) succ=
eeded
> [    5.044334] ata1.00: ACPI cmd ef/10:02:00:00:00:a0 (SET FEATURES) succ=
eeded
> [    5.044337] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filt=
ered out
> [    5.044446] ata1.00: ACPI cmd ef/10:04:00:00:00:a0 (SET FEATURES) succ=
eeded
> [    5.044532] ata1.00: ACPI cmd ef/10:05:00:00:00:a0 (SET FEATURES) reje=
cted by device (Stat=3D0x51 Err=3D0x04)
> [    5.045392] ata1.00: ATA-8: HGST HTS545050A7E380, GG2OAC90, max UDMA/1=
33
> [    5.045394] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/=
32), AA
> [    5.049087] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by d=
evice (Stat=3D0x51 Err=3D0x04)
> [    5.049090] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filt=
ered out
> [    5.049183] ata1.00: ACPI cmd ef/10:05:00:00:00:a0 (SET FEATURES) reje=
cted by device (Stat=3D0x51 Err=3D0x04)
> [    5.049438] ata1.00: configured for UDMA/133
> [    5.049568] scsi 0:0:0:0: Direct-Access     ATA      HGST HTS545050A7 =
AC90 PQ: 0 ANSI: 5
> [    5.049800] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 =
GB/465 GiB)
> [    5.049803] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [    5.049894] sd 0:0:0:0: [sda] Write Protect is off
> [    5.049897] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    5.049936] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
> [    5.180018] usb 2-5: new high-speed USB device number 4 using ehci-pci
> [    5.311535] usb 2-5: New USB device found, idVendor=3D064e, idProduct=
=3Dc107
> [    5.311539] usb 2-5: New USB device strings: Mfr=3D2, Product=3D1, Ser=
ialNumber=3D3
> [    5.311541] usb 2-5: Product: HP Webcam
> [    5.311543] usb 2-5: Manufacturer: SuYin
> [    5.311545] usb 2-5: SerialNumber: CN0314-MM00-MI06-VH-R53.90.01
> [    5.354026] ata2: SATA link down (SStatus 4 SControl 300)
> [    5.384433]  sda: sda1 sda2 sda3
> [    5.384855] sd 0:0:0:0: [sda] Attached SCSI disk
> [    5.518017] usb 5-2: new low-speed USB device number 2 using uhci_hcd
> [    5.540019] tsc: Refined TSC clocksource calibration: 2127.999 MHz
> [    5.686041] usb 5-2: New USB device found, idVendor=3D045e, idProduct=
=3D00cb
> [    5.686044] usb 5-2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
> [    5.686046] usb 5-2: Product: Microsoft Basic Optical Mouse v2.0=20
> [    5.686048] usb 5-2: Manufacturer: Microsoft=20
> [    5.714504] input: Microsoft  Microsoft Basic Optical Mouse v2.0  as /=
devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.0/0003:045E:00CB.0001/input/=
input3
> [    5.714611] hid-generic 0003:045E:00CB.0001: input,hidraw0: USB HID v1=
=2E11 Mouse [Microsoft  Microsoft Basic Optical Mouse v2.0 ] on usb-0000:00=
:1d.0-2/input0
> [    5.814029] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    5.831669] ata5.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by d=
evice (Stat=3D0x51 Err=3D0x04)
> [    5.832109] ata5.00: ACPI cmd ef/10:01:00:00:00:a0 (SET FEATURES) succ=
eeded
> [    5.832537] ata5.00: ACPI cmd ef/10:02:00:00:00:a0 (SET FEATURES) succ=
eeded
> [    5.832540] ata5.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filt=
ered out
> [    5.832965] ata5.00: ACPI cmd ef/10:04:00:00:00:a0 (SET FEATURES) succ=
eeded
> [    5.833469] ata5.00: ACPI cmd ef/10:05:00:00:00:a0 (SET FEATURES) succ=
eeded
> [    5.846605] ata5.00: ATAPI: TSSTcorp CDDVDW TS-L633L, 0400, max UDMA/1=
00
> [    5.865178] ata5.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by d=
evice (Stat=3D0x51 Err=3D0x04)
> [    5.865617] ata5.00: ACPI cmd ef/10:01:00:00:00:a0 (SET FEATURES) succ=
eeded
> [    5.866046] ata5.00: ACPI cmd ef/10:02:00:00:00:a0 (SET FEATURES) succ=
eeded
> [    5.866049] ata5.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filt=
ered out
> [    5.866476] ata5.00: ACPI cmd ef/10:04:00:00:00:a0 (SET FEATURES) succ=
eeded
> [    5.881331] ata5.00: configured for UDMA/100
> [    5.883888] scsi 4:0:0:0: CD-ROM            TSSTcorp CDDVDW TS-L633L  =
0400 PQ: 0 ANSI: 5
> [    6.200026] ata6: SATA link down (SStatus 0 SControl 300)
> [    6.478634] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id:=
 0x1a0b1, caps: 0xd04751/0xa00000/0x20000, board id: 3655, fw id: 509933
> [    6.540064] Switched to clocksource tsc
> [    6.599587] input: SynPS/2 Synaptics TouchPad as /devices/platform/i80=
42/serio1/input/input2
> [    6.607511] PM: Hibernation image not present or could not be loaded.
> [    6.609075] Freeing unused kernel memory: 1560K (ffffffff81efe000 - ff=
ffffff82084000)
> [    6.609077] Write protecting the kernel read-only data: 14336k
> [    6.614388] Freeing unused kernel memory: 1876K (ffff88000162b000 - ff=
ff880001800000)
> [    6.618271] Freeing unused kernel memory: 1436K (ffff880001c99000 - ff=
ff880001e00000)
> [    6.620665] random: systemd urandom read with 26 bits of entropy avail=
able
> [    6.687011] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    6.687054] scsi 4:0:0:0: Attached scsi generic sg1 type 5
> [    6.698392] systemd-journald[117]: Failed to set file attributes: Inap=
propriate ioctl for device
> [    6.803162] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PN=
P0C0C:00/input/input4
> [    6.803218] ACPI: Power Button [PWRB]
> [    6.803289] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0D:00/input/input5
> [    6.803402] ACPI: Lid Switch [LID0]
> [    6.803465] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PN=
P0C0E:00/input/input6
> [    6.803503] ACPI: Sleep Button [SLPB]
> [    6.803601] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input7
> [    6.803639] ACPI: Power Button [PWRF]
> [    6.807935] wmi: Mapper loaded
> [    6.811849] ACPI: Video Device [EVGA] (multi-head: yes  rom: no  post:=
 no)
> [    6.811878] [Firmware Bug]: ACPI: No _BQC method, cannot determine ini=
tial brightness
> [    6.824993] [drm] Initialized drm 1.1.0 20060810
> [    6.834201] acpi device:06: registered as cooling_device0
> [    6.834283] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A=
08:00/device:05/LNXVIDEO:01/input/input8
> [    6.863491] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form=
2 cdda tray
> [    6.863496] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    6.863682] sr 4:0:0:0: Attached scsi CD-ROM sr0
> [    6.887075] firewire_ohci 0000:06:00.0: added OHCI v1.10 device as car=
d 0, 4 IR + 0 IT contexts, quirks 0x10
> [    6.887913] nvidia: module license 'NVIDIA' taints kernel.
> [    6.887917] Disabling lock debugging due to kernel taint
> [    6.904626] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecode=
s=3Dio+mem,decodes=3Dnone:owns=3Dnone
> [    6.905157] [drm] Initialized nvidia-drm 0.0.0 20150116 for 0000:01:00=
=2E0 on minor 0
> [    6.905169] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  340.93  We=
d Aug 19 16:49:15 PDT 2015
> [    6.907397] nvidia_uvm: Loaded the UVM driver, major device number 249
> [    7.193022] raid6: sse2x1    3582 MB/s
> [    7.193084] random: nonblocking pool is initialized
> [    7.210021] raid6: sse2x2    3808 MB/s
> [    7.227026] raid6: sse2x4    6207 MB/s
> [    7.227028] raid6: using algorithm sse2x4 (6207 MB/s)
> [    7.227030] raid6: using ssse3x2 recovery algorithm
> [    7.227258] xor: measuring software checksum speed
> [    7.237003]    prefetch64-sse:  8700.000 MB/sec
> [    7.247008]    generic_sse:  7716.000 MB/sec
> [    7.247011] xor: using function: prefetch64-sse (8700.000 MB/sec)
> [    7.251651] Btrfs loaded, assert=3Don
> [    7.257937] BTRFS: device fsid 656dc65f-240b-4137-a490-0175717dd7fa de=
vid 1 transid 704933 /dev/sda2
> [    7.276150] PM: Marking nosave pages: [mem 0x0009e000-0x000fffff]
> [    7.276157] PM: Marking nosave pages: [mem 0xbfd6b000-0xbfdbefff]
> [    7.276161] PM: Marking nosave pages: [mem 0xbfe83000-0xbfebefff]
> [    7.276164] PM: Marking nosave pages: [mem 0xbfedf000-0xbfef5fff]
> [    7.276166] PM: Marking nosave pages: [mem 0xbfefe000-0xbfefefff]
> [    7.276168] PM: Marking nosave pages: [mem 0xbff00000-0xffffffff]
> [    7.276977] PM: Basic memory bitmaps created
> [    7.299718] PM: Basic memory bitmaps freed
> [    7.299725] video LNXVIDEO:01: Restoring backlight state
> [    7.309658] PM: Starting manual resume from disk
> [    7.309664] PM: Hibernation image partition 8:1 present
> [    7.309665] PM: Looking for hibernation image.
> [    7.316565] PM: Image not found (code -22)
> [    7.316568] PM: Hibernation image not present or could not be loaded.
> [    7.388105] firewire_core 0000:06:00.0: created device fw0: GUID 8c3f0=
2007bb540d9, S400
> [    7.458257] BTRFS info (device sda2): disk space caching is enabled
> [   10.233267] device-mapper: uevent: version 1.0.3
> [   10.233330] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialise=
d: dm-devel@redhat.com
> [   12.380353] BTRFS info (device sda2): disk space caching is enabled
> [   14.035779] shpchp: Standard Hot Plug PCI Controller Driver version: 0=
=2E4
> [   14.037324] Monitor-Mwait will be used to enter C-1 state
> [   14.037334] Monitor-Mwait will be used to enter C-2 state
> [   14.037338] Monitor-Mwait will be used to enter C-3 state
> [   14.037343] tsc: Marking TSC unstable due to TSC halts in idle
> [   14.037364] ACPI: acpi_idle registered with cpuidle
> [   14.040226] ACPI: Fan [FAN] (off)
> [   14.041141] Switched to clocksource hpet
> [   14.041498] input: PC Speaker as /devices/platform/pcspkr/input/input9
> [   14.042655] ACPI Warning: SystemIO range 0x0000000000000428-0x00000000=
0000042f conflicts with OpRegion 0x0000000000000400-0x000000000000047f (\PM=
BA) (20140424/utaddress-258)
> [   14.042663] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
> [   14.042668] ACPI Warning: SystemIO range 0x0000000000000530-0x00000000=
0000053f conflicts with OpRegion 0x0000000000000500-0x000000000000053b (\GP=
IO) (20140424/utaddress-258)
> [   14.042671] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
> [   14.042673] ACPI Warning: SystemIO range 0x0000000000000500-0x00000000=
0000052f conflicts with OpRegion 0x0000000000000500-0x000000000000053b (\GP=
IO) (20140424/utaddress-258)
> [   14.042677] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
> [   14.042678] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [   14.043457] ACPI Warning: SystemIO range 0x0000000000008000-0x00000000=
0000801f conflicts with OpRegion 0x0000000000008000-0x000000000000800f (\_S=
B_.PCI0.SBUS.SMBI) (20140424/utaddress-258)
> [   14.043463] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
> [   14.104094] thermal LNXTHERM:00: registered as thermal_zone0
> [   14.104102] ACPI: Thermal Zone [THRM] (62 C)
> [   14.521293] hp_accel: hardware type DV7 found
> [   14.525178] ACPI: Deprecated procfs I/F for battery is loaded, please =
retry with CONFIG_ACPI_PROCFS_POWER cleared
> [   14.525187] ACPI: Battery Slot [BAT0] (battery present)
> [   14.525966] lis3lv02d: 8 bits sensor found
> [   14.565860] input: ST LIS3LV02DL Accelerometer as /devices/platform/li=
s3lv02d/input/input10
> [   14.615979] cfg80211: Calling CRDA to update world regulatory domain
> [   14.646985] iTCO_vendor_support: vendor-support=3D0
> [   14.647785] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> [   14.647837] iTCO_wdt: Found a ICH9M TCO device (Version=3D2, TCOBASE=
=3D0x0460)
> [   14.648266] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
> [   14.661085] ACPI: Deprecated procfs I/F for AC is loaded, please retry=
 with CONFIG_ACPI_PROCFS_POWER cleared
> [   14.699901] Linux video capture interface: v2.00
> [   14.798099] ACPI: AC Adapter [AC] (on-line)
> [   15.053655] sdhci: Secure Digital Host Controller Interface driver
> [   15.053658] sdhci: Copyright(c) Pierre Ossman
> [   15.138677] ene_ir: chip is 0x3926 - kbver =3D 0x00, rev =3D 0xc0
> [   15.138680] ene_ir: PLL freq =3D 1406
> [   15.138681] ene_ir: KB3926C detected
> [   15.138695] ene_ir: Firmware regs: c1 01
> [   15.138696] ene_ir: Hardware features:
> [   15.138697] ene_ir: * Uses GPIO 40 for IR demodulated input
> [   15.206498] sdhci-pci 0000:06:00.1: SDHCI controller found [197b:2382]=
 (rev 0)
> [   15.206657] mmc0: no vqmmc regulator found
> [   15.206659] mmc0: no vmmc regulator found
> [   15.206974] mmc0: SDHCI controller on PCI [0000:06:00.1] using DMA
> [   15.206988] sdhci-pci 0000:06:00.2: SDHCI controller found [197b:2381]=
 (rev 0)
> [   15.207087] sdhci-pci 0000:06:00.2: Refusing to bind to secondary inte=
rface.
> [   15.383123] cdc_ether 2-1:1.1 wwan0: register 'cdc_ether' at usb-0000:=
00:1d.7-1, Mobile Broadband Network Device, 02:50:f3:00:00:00
> [   15.383155] usbcore: registered new interface driver cdc_ether
> [   15.453230] usb-storage 2-1:1.0: USB Mass Storage device detected
> [   15.453679] usb-storage 2-1:1.3: USB Mass Storage device detected
> [   15.453807] usb-storage 2-1:1.4: USB Mass Storage device detected
> [   15.453909] usb-storage 2-1:1.5: USB Mass Storage device detected
> [   15.454833] scsi9 : usb-storage 2-1:1.5
> [   15.454932] usb-storage 2-1:1.6: USB Mass Storage device detected
> [   15.455323] scsi10 : usb-storage 2-1:1.6
> [   15.455425] usbcore: registered new interface driver usb-storage
> [   15.465393] Intel(R) Wireless WiFi driver for Linux, in-tree:d
> [   15.465397] Copyright(c) 2003- 2014 Intel Corporation
> [   15.465626] iwlwifi 0000:02:00.0: can't disable ASPM; OS doesn't have =
ASPM control
> [   15.465764] iwlwifi 0000:02:00.0: irq 48 for MSI/MSI-X
> [   15.517265] input: HP WMI hotkeys as /devices/virtual/input/input12
> [   15.611020] Registered IR keymap rc-rc6-mce
> [   15.611122] input: ENE eHome Infrared Remote Receiver as /devices/virt=
ual/rc/rc0/input11
> [   15.611226] rc0: ENE eHome Infrared Remote Receiver as /devices/virtua=
l/rc/rc0
> [   15.612385] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [   15.612399] r8169 0000:05:00.0: can't disable ASPM; OS doesn't have AS=
PM control
> [   15.612758] r8169 0000:05:00.0: irq 49 for MSI/MSI-X
> [   15.612994] r8169 0000:05:00.0 eth0: RTL8168c/8111c at 0xffffc90004766=
000, 00:23:5a:1e:4f:36, XID 1c4000c0 IRQ 49
> [   15.612997] r8169 0000:05:00.0 eth0: jumbo features [frames: 6128 byte=
s, tx checksumming: ko]
> [   15.621156] ene_ir: driver has been successfully loaded
> [   15.659184] usbcore: registered new interface driver uas
> [   15.675511] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
> [   15.721385] iwlwifi 0000:02:00.0: loaded firmware version 8.83.5.1 bui=
ld 33692 op_mode iwldvm
> [   15.835955] uvcvideo: Found UVC 1.00 device HP Webcam (064e:c107)
> [   15.844924] input: HP Webcam as /devices/pci0000:00/0000:00:1d.7/usb2/=
2-5/2-5:1.0/input/input13
> [   15.845083] usbcore: registered new interface driver uvcvideo
> [   15.845085] USB Video Class driver (1.1.1)
> [   15.884356] IR RC5(x) protocol handler initialized
> [   15.884595] IR RC6 protocol handler initialized
> [   15.884665] IR Sharp protocol handler initialized
> [   15.884975] IR SANYO protocol handler initialized
> [   15.885025] IR Sony protocol handler initialized
> [   15.893391] IR JVC protocol handler initialized
> [   15.906677] IR NEC protocol handler initialized
> [   15.906777] input: MCE IR Keyboard/Mouse (ene_ir) as /devices/virtual/=
input/input14
> [   15.906872] IR MCE Keyboard/mouse protocol handler initialized
> [   15.921447] lirc_dev: IR Remote Control driver registered, major 248=
=20
> [   15.956833] sound hdaudioC0D0: autoconfig: line_outs=3D1 (0xd/0x0/0x0/=
0x0/0x0) type:speaker
> [   15.956838] sound hdaudioC0D0:    speaker_outs=3D0 (0x0/0x0/0x0/0x0/0x=
0)
> [   15.956841] sound hdaudioC0D0:    hp_outs=3D1 (0xa/0x0/0x0/0x0/0x0)
> [   15.956843] sound hdaudioC0D0:    mono: mono_out=3D0x0
> [   15.956845] sound hdaudioC0D0:    dig-out=3D0x1e/0x0
> [   15.956847] sound hdaudioC0D0:    inputs:
> [   15.956849] sound hdaudioC0D0:      Internal Mic=3D0x18
> [   15.956852] sound hdaudioC0D0:      Mic=3D0xb
> [   15.978067] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1=
b.0/sound/card0/hdaudioC0D0/input15
> [   15.978486] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/s=
ound/card0/input16
> [   15.978578] input: HDA Intel Front Headphone as /devices/pci0000:00/00=
00:00:1b.0/sound/card0/input17
> [   15.978709] input: HDA Intel HDMI/DP,pcm=3D3 Phantom as /devices/pci00=
00:00/0000:00:1b.0/sound/card0/input18
> [   16.104930] rc rc0: lirc_dev: driver ir-lirc-codec (ene_ir) registered=
 at minor =3D 0
> [   16.104933] IR LIRC bridge handler initialized
> [   16.225216] usbcore: registered new interface driver usbserial
> [   16.225236] usbcore: registered new interface driver usbserial_generic
> [   16.225251] usbserial: USB Serial support registered for generic
> [   16.270662] cfg80211: World regulatory domain updated:
> [   16.270666] cfg80211:  DFS Master region: unset
> [   16.270668] cfg80211:   (start_freq - end_freq @ bandwidth), (max_ante=
nna_gain, max_eirp), (dfs_cac_time)
> [   16.270671] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A,=
 2000 mBm), (N/A)
> [   16.270673] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A,=
 2000 mBm), (N/A)
> [   16.270675] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A,=
 2000 mBm), (N/A)
> [   16.270678] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000=
 KHz AUTO), (N/A, 2000 mBm), (N/A)
> [   16.270681] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000=
 KHz AUTO), (N/A, 2000 mBm), (0 s)
> [   16.270683] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A=
, 2000 mBm), (0 s)
> [   16.270685] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A,=
 2000 mBm), (N/A)
> [   16.270688] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (=
N/A, 0 mBm), (N/A)
> [   16.304239] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG enabled
> [   16.304243] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
> [   16.304246] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabl=
ed
> [   16.304248] iwlwifi 0000:02:00.0: Detected Intel(R) WiFi Link 5100 AGN=
, REV=3D0x54
> [   16.304347] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
> [   16.307233] usbcore: registered new interface driver option
> [   16.307252] usbserial: USB Serial support registered for GSM modem (1-=
port)
> [   16.307341] option 2-1:1.0: GSM modem (1-port) converter detected
> [   16.308446] usb 2-1: GSM modem (1-port) converter now attached to ttyU=
SB0
> [   16.308531] option 2-1:1.3: GSM modem (1-port) converter detected
> [   16.308637] usb 2-1: GSM modem (1-port) converter now attached to ttyU=
SB1
> [   16.308691] option 2-1:1.4: GSM modem (1-port) converter detected
> [   16.308797] usb 2-1: GSM modem (1-port) converter now attached to ttyU=
SB2
> [   16.333911] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-r=
s'
> [   16.457306] scsi 9:0:0:0: CD-ROM            HUAWEI   Mass Storage     =
2.31 PQ: 0 ANSI: 2
> [   16.458079] scsi 10:0:0:0: Direct-Access     HUAWEI   SD Storage      =
 2.31 PQ: 0 ANSI: 2
> [   16.459577] sd 10:0:0:0: Attached scsi generic sg2 type 0
> [   16.462549] sr1: scsi-1 drive
> [   16.463443] sr 9:0:0:0: Attached scsi CD-ROM sr1
> [   16.463587] sr 9:0:0:0: Attached scsi generic sg3 type 5
> [   16.465495] sd 10:0:0:0: [sdb] Attached SCSI removable disk
> [   19.064146] Adding 2103292k swap on /dev/sda1.  Priority:-1 extents:1 =
across:2103292k FS
> [   24.003277] EXT4-fs (sda3): mounted filesystem with ordered data mode.=
 Opts: (null)
> [   27.619141] audit: type=3D1400 audit(1446302281.470:2): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/{usr/,}bin/ping" pid=3D824 comm=
=3D"apparmor_parser"
> [   27.633621] audit: type=3D1400 audit(1446302281.484:3): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/sbin/klogd" pid=3D831 comm=3D"app=
armor_parser"
> [   27.643281] audit: type=3D1400 audit(1446302281.494:4): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/sbin/syslog-ng" pid=3D835 comm=3D=
"apparmor_parser"
> [   27.652458] audit: type=3D1400 audit(1446302281.503:5): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/sbin/syslogd" pid=3D839 comm=3D"a=
pparmor_parser"
> [   27.652967] audit: type=3D1305 audit(1446302281.503:6): audit_pid=3D80=
0 old=3D0 auid=3D4294967295 ses=3D4294967295 res=3D1
> [   29.564945] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [   29.573636] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [   29.577582] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   33.072308] r8169 0000:05:00.0 enp5s0: link down
> [   33.072357] IPv6: ADDRCONF(NETDEV_UP): enp5s0: link is not ready
> [   33.076465] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
> [   33.079464] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
> [   33.173187] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
> [   33.176152] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
> [   33.201448] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
> [   34.177199] NET: Registered protocol family 17
> [   37.785656] nvidia 0000:01:00.0: irq 51 for MSI/MSI-X
> [   39.518164] NVRM: Your system is not currently configured to drive a V=
GA console
> [   39.518169] NVRM: on the primary VGA device. The NVIDIA Linux graphics=
 driver
> [   39.518171] NVRM: requires the use of a text-mode VGA console. Use of =
other console
> [   39.518173] NVRM: drivers including, but not limited to, vesafb, may r=
esult in
> [   39.518174] NVRM: corruption and stability problems, and is not suppor=
ted.
> [   97.127312] Bluetooth: Core ver 2.19
> [   97.127339] NET: Registered protocol family 31
> [   97.127341] Bluetooth: HCI device and connection manager initialized
> [   97.127351] Bluetooth: HCI socket layer initialized
> [   97.127354] Bluetooth: L2CAP socket layer initialized
> [   97.127366] Bluetooth: SCO socket layer initialized
> [   97.168147] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   97.168152] Bluetooth: BNEP filters: protocol multicast
> [   97.168163] Bluetooth: BNEP socket layer initialized
> [  124.624338] PPP generic driver version 2.4.2
> [  124.719141] PPP BSD Compression module registered
> [  124.727453] PPP Deflate Compression module registered
> [  131.967262] fuse init (API version 7.23)


--=20
Hugo Mills             | I always felt that as a C programmer, I was becomi=
ng
hugo@... carfax.org.uk | typecast.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--xs+9IvWevLaxKUtW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWNO8oAAoJEFheFHXiqx3k46sP/2ElQc5+ckBQM1qEp48nypyI
6ddJzcBw06AtB6iGnRWEkCovYSmdA0yicf4yxuYrFQE0HltwyHQoYay14RggZ6PT
OSd4ISa4joO7r5GYaB8kOKHTU7Pz2/60zSOgg9KYpn6UgV1KVPwcwSXTQHrwwb7I
vfRHlbl/PtlTaGA+fR+fVJK3gohceoLbURRxellJE5D45FvpGi6mD3I/1rnfqTrr
XMZhu9d+o5yJkQauokfogRs85olPtIWVt9j9ZrFHCPloKkv4ZokzLSS4ZVkDuO+u
GWEpMLeAJVmzO2gr1UNhqbrej8HBDNp4f96sZjv95m4ROtHMcnknlb/96GlRla3p
wdPsMmzJLHiKHpeAhSN32NRovmzGIpHiPpJ1W+OfU25W7YzVdEaVXO+TIRngxdxb
BsPv5ugOrBw8PSMoUjlveoSy6aCusX6AKPiLx+bAmuOEE/mDD7Hif8lNymX8rl7N
x2zrF9zcYBDZnGZuKXiEgnaSX05aJXVZOKULeb/uUFH7AmJ6G60bA7V8qQak0igY
fHrSbLVsesx4v3k/+BvtBOdJ2OewX3bJ8+uyIKXURAzeDQc8Zq53PESQQb9/c2tV
Zor7OKU3G27oIPAB3gYROIk5MsEQAXdX+GZKrvB8ay+UEVfKaJTkBO/MbONBije8
Q5t9BGdCi7NY8TYfyZVF
=gG/q
-----END PGP SIGNATURE-----

--xs+9IvWevLaxKUtW--
