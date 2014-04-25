Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from SD88.btc-net.bg ([212.39.90.88]:48248 "HELO sd88.btc-net.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750801AbaDYFDj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 01:03:39 -0400
From: =?koi8-r?B?8MzBzcXOIPDF1NLP1w==?= <plamen@petrovi.no-ip.info>
To: "'Chris Murphy'" <lists@colorremedies.com>,
        "'Marc MERLIN'" <marc@merlins.org>
Cc: <linux-btrfs@vger.kernel.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <000501cf5fe1$55198590$ff4c90b0$@petrovi.no-ip.info> <20140424173317.GI7884@merlins.org> <002301cf5fee$346fefc0$9d4fcf40$@petrovi.no-ip.info> <8953EAE6-E8DD-40DC-B485-128BE7CB4BA1@colorremedies.com> <000c01cf600b$b01f6cf0$105e46d0$@petrovi.no-ip.info> <20140424230704.GK7884@merlins.org> <F6EDB160-FCC5-4D1C-A5A8-AAADE5C803F6@colorremedies.com>
In-Reply-To: <F6EDB160-FCC5-4D1C-A5A8-AAADE5C803F6@colorremedies.com>
Subject: RE: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Date: Fri, 25 Apr 2014 08:03:08 +0300
Message-ID: <000a01cf6043$a6867a20$f3936e60$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_000B_01CF605C.CBD5FC10"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_000B_01CF605C.CBD5FC10
Content-Type: text/plain;
	charset="koi8-r"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Chris Murphy [mailto:lists@colorremedies.com]
> Sent: Friday, April 25, 2014 3:04 AM
> To: Marc MERLIN
> Cc: =F0=CC=C1=CD=C5=CE =F0=C5=D4=D2=CF=D7; linux-btrfs@vger.kernel.org
> Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 =
or
> newer?
>=20
>=20
> On Apr 24, 2014, at 5:07 PM, Marc MERLIN <marc@merlins.org> wrote:
> >
> >
> > In 3.14 the device shows up before btrfs is loaded:
> > sd 2:0:0:0: [sda] Cache data unavailable sd 2:0:0:0: [sda] Assuming
> > drive cache: write through sd 2:0:0:0: [sda] Attached SCSI disk
> > (...)
> > Btrfs loaded
>=20
> Same for me though, and I can boot.
>=20
> [    0.693215] ata1.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
> [    0.693799] ata1.00: 167772160 sectors, multi 128: LBA48 NCQ (depth
31/32)
> [    0.694153] ata1.00: configured for UDMA/133
> [    0.695475] scsi 0:0:0:0: Direct-Access     ATA      VBOX HARDDISK
1.0  PQ: 0
> ANSI: 5
> [    0.699386] sd 0:0:0:0: [sda] 167772160 512-byte logical blocks: =
(85.8
GB/80.0
> GiB)
> [    0.699443] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    0.700604] sd 0:0:0:0: [sda] Write Protect is off
> [    0.701151] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    0.701187] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled,
> doesn't support DPO or FUA
> [    0.707841]  sda: sda1 sda2 sda3
> [    0.709846] sd 0:0:0:0: [sda] Attached SCSI disk
> (:)
> [    2.380090] bio: create slab <bio-1> at 1
> [    2.384645] Btrfs loaded
>=20
> So I don't think the order is it. The biggest difference I'm seeing
between the
> 3.13.11 and 3.14.1 dmesg's provided:
>=20
> 3.13.11:
> [    1.861740] bio: create slab <bio-1> at 1
> [    1.863389] Btrfs loaded
>=20
> 3.14.1:
> [    3.949312] bio: create slab <bio-1> at 1
> [    3.950942] Btrfs loaded
>=20
> It's happening much later, and it's right at this point VFS complains:
> [    4.182603] VFS: Cannot open root device "sda2" or =
unknown-block(8,2):
> error -38
>=20
> The 8,2 message is consistent with the kernel not knowing what file =
system
> sda2 is. Seems like it's saying "I see sda2, I know you want to use it =
as
root,
> but I don't know what's there - *poof*" and it panics.
>=20
> If rootwait alone doesn't work, I wonder if =
root=3Duuid=3D2ba08fbc-4b95-46cc-
> b638-299f16462620 instead of root=3D/dev/sda2 will work along with =
rootwait.
> It should then wait for that fs uuid to become available, rather than
waiting
> for sda2 to become available.
>=20


It does indeed wait, but I did not wait for it - just booted, saw it =
ended
in

"Waiting for root device uuid=3D..." and pasted the serial output.

Is it supposed to somehow find its rootfs later?

See the attached file.
---------------------------------
Plamen Petrov

------=_NextPart_000_000B_01CF605C.CBD5FC10
Content-Type: text/plain;
	name="dmesg-3.14.1-mix64-serial-rootwait-uuid.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg-3.14.1-mix64-serial-rootwait-uuid.txt"

[    0.000000] Initializing cgroup subsys cpuset=0A=
[    0.000000] Initializing cgroup subsys cpu=0A=
[    0.000000] Initializing cgroup subsys cpuacct=0A=
[    0.000000] Linux version 3.14.1-mix64 (root@crux) (gcc version 4.7.3 =
(CRUX-x86_64-multilib) ) #1 SMP Fri Apr 25 00:31:28 EEST 2014=0A=
[    0.000000] Command line: rw =
root=3Duuid=3D2ba08fbc-4b95-46cc-b638-299f16462620 vga=3D6 =
raid=3Dnoautodetect console=3DttyS0,9600n8 console=3Dtty0 rootwait=0A=
[    0.000000] e820: BIOS-provided physical RAM map:=0A=
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] =
usable=0A=
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] =
reserved=0A=
[    0.000000] BIOS-e820: [mem 0x00000000000ca000-0x00000000000cbfff] =
reserved=0A=
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] =
reserved=0A=
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003fedffff] =
usable=0A=
[    0.000000] BIOS-e820: [mem 0x000000003fee0000-0x000000003fefefff] =
ACPI data=0A=
[    0.000000] BIOS-e820: [mem 0x000000003feff000-0x000000003fefffff] =
ACPI NVS=0A=
[    0.000000] BIOS-e820: [mem 0x000000003ff00000-0x000000003fffffff] =
usable=0A=
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f7ffffff] =
reserved=0A=
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] =
reserved=0A=
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] =
reserved=0A=
[    0.000000] BIOS-e820: [mem 0x00000000fffe0000-0x00000000ffffffff] =
reserved=0A=
[    0.000000] NX (Execute Disable) protection: active=0A=
[    0.000000] SMBIOS 2.4 present.=0A=
[    0.000000] Hypervisor detected: VMware=0A=
[    0.000000] No AGP bridge found=0A=
[    0.000000] e820: last_pfn =3D 0x40000 max_arch_pfn =3D 0x400000000=0A=
[    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106=0A=
[    0.000000] found SMP MP-table at [mem 0x000f6bf0-0x000f6bff] mapped =
at [ffff8800000f6bf0]=0A=
[    0.000000] Using GB pages for direct mapping=0A=
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]=0A=
[    0.000000] init_memory_mapping: [mem 0x3fc00000-0x3fdfffff]=0A=
[    0.000000] init_memory_mapping: [mem 0x3c000000-0x3fbfffff]=0A=
[    0.000000] init_memory_mapping: [mem 0x00100000-0x3bffffff]=0A=
[    0.000000] init_memory_mapping: [mem 0x3fe00000-0x3fedffff]=0A=
[    0.000000] init_memory_mapping: [mem 0x3ff00000-0x3fffffff]=0A=
[    0.000000] ACPI: RSDP 00000000000f6b80 000024 (v02 PTLTD )=0A=
[    0.000000] ACPI: XSDT 000000003feeda33 00005C (v01 INTEL  440BX    =
06040000 VMW  01324272)=0A=
[    0.000000] ACPI: FACP 000000003fefee73 0000F4 (v04 INTEL  440BX    =
06040000 PTL  000F4240)=0A=
[    0.000000] ACPI: DSDT 000000003feee8eb 010588 (v01 PTLTD  Custom   =
06040000 MSFT 03000001)=0A=
[    0.000000] ACPI: FACS 000000003fefffc0 000040=0A=
[    0.000000] ACPI: BOOT 000000003feee8c3 000028 (v01 PTLTD  $SBFTBL$ =
06040000  LTP 00000001)=0A=
[    0.000000] ACPI: APIC 000000003feee501 0003C2 (v01 PTLTD  ? APIC   =
06040000  LTP 00000000)=0A=
[    0.000000] ACPI: MCFG 000000003feee4c5 00003C (v01 PTLTD  $PCITBL$ =
06040000  LTP 00000001)=0A=
[    0.000000] ACPI: SRAT 000000003feedb2f 0004D0 (v02 VMWARE MEMPLUG  =
06040000 VMW  00000001)=0A=
[    0.000000] ACPI: HPET 000000003feedaf7 000038 (v01 VMWARE VMW HPET =
06040000 VMW  00000001)=0A=
[    0.000000] ACPI: WAET 000000003feedacf 000028 (v01 VMWARE VMW WAET =
06040000 VMW  00000001)=0A=
[    0.000000] Setting APIC routing to physical flat.=0A=
[    0.000000] Zone ranges:=0A=
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]=0A=
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]=0A=
[    0.000000]   Normal   empty=0A=
[    0.000000] Movable zone start for each node=0A=
[    0.000000] Early memory node ranges=0A=
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]=0A=
[    0.000000]   node   0: [mem 0x00100000-0x3fedffff]=0A=
[    0.000000]   node   0: [mem 0x3ff00000-0x3fffffff]=0A=
[    0.000000] ACPI: PM-Timer IO Port: 0x1008=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x08] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x0a] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0c] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0e] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x12] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x14] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x16] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x18] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x1a] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x1c] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x1e] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x22] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x24] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x26] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x28] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x2a] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x2c] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x2e] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x32] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x34] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x36] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x38] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x3a] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x3c] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x3e] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x40] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x42] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x44] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x46] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x48] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x4a] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x4c] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x4e] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x50] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x52] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x54] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x56] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x58] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x5a] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x5c] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x5e] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x60] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x62] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x64] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x66] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x68] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x6a] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x6c] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x6e] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x70] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x72] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x74] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x76] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x78] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x7a] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0x7c] disabled)=0A=
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0x7e] disabled)=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x20] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x21] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x22] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x23] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x24] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x25] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x26] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x27] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x28] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x29] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2a] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2b] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2c] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2d] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2e] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2f] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x30] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x31] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x32] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x33] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x34] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x35] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x36] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x37] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x38] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x39] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3a] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3b] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3c] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3d] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3e] high edge lint[0x1])=0A=
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3f] high edge lint[0x1])=0A=
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])=0A=
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI =
0-23=0A=
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)=0A=
[    0.000000] Using ACPI (MADT) for SMP configuration information=0A=
[    0.000000] ACPI: HPET id: 0x8086af01 base: 0xfed00000=0A=
[    0.000000] smpboot: 64 Processors exceeds NR_CPUS limit of 8=0A=
[    0.000000] smpboot: Allowing 8 CPUs, 7 hotplug CPUs=0A=
[    0.000000] e820: [mem 0x40000000-0xefffffff] available for PCI =
devices=0A=
[    0.000000] Booting paravirtualized kernel on bare hardware=0A=
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 =
nr_node_ids:1=0A=
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88003fc00000 s80192 r0 =
d22208 u262144=0A=
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  =
Total pages: 257897=0A=
[    0.000000] Kernel command line: rw =
root=3Duuid=3D2ba08fbc-4b95-46cc-b638-299f16462620 vga=3D6 =
raid=3Dnoautodetect console=3DttyS0,9600n8 console=3Dtty0 rootwait=0A=
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)=0A=
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, =
1048576 bytes)=0A=
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 =
bytes)=0A=
[    0.000000] Checking aperture...=0A=
[    0.000000] No AGP bridge found=0A=
[    0.000000] Memory: 1012780K/1048056K available (7943K kernel code, =
527K rwdata, 2628K rodata, 932K init, 2580K bss, 35276K reserved)=0A=
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, =
CPUs=3D8, Nodes=3D1=0A=
[    0.000000] Hierarchical RCU implementation.=0A=
[    0.000000] 	CONFIG_RCU_FANOUT set to non-default value of 32=0A=
[    0.000000] NR_IRQS:4352 nr_irqs:744 16=0A=
[    0.000000] Console: colour VGA+ 80x60=0A=
[    0.000000] console [tty0] enabled=0A=
[    0.000000] console [ttyS0] enabled=0A=
[    0.000000] TSC freq read from hypervisor : 3000.079 MHz=0A=
[    0.000000] tsc: Detected 3000.079 MHz processor=0A=
[    0.000008] Calibrating delay loop (skipped) preset value.. 6000.15 =
BogoMIPS (lpj=3D30000790)=0A=
[    0.002246] pid_max: default: 32768 minimum: 301=0A=
[    0.003470] ACPI: Core revision 20131218=0A=
[    0.010935] ACPI: All ACPI Tables successfully acquired=0A=
[    0.016551] Security Framework initialized=0A=
[    0.017804] Mount-cache hash table entries: 2048 (order: 2, 16384 =
bytes)=0A=
[    0.019533] Mountpoint-cache hash table entries: 2048 (order: 2, =
16384 bytes)=0A=
[    0.021913] Initializing cgroup subsys freezer=0A=
[    0.023201] mce: CPU supports 0 MCE banks=0A=
[    0.024343] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8=0A=
[    0.024343] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0=0A=
[    0.024343] tlb_flushall_shift: 6=0A=
[    0.067819] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 =
pin2=3D-1=0A=
[    0.169353] smpboot: CPU0: AMD Athlon(tm) II X4 640 Processor (fam: =
10, model: 05, stepping: 03)=0A=
[    0.288714] Performance Events: AMD PMU driver.=0A=
[    0.290031] ... version:                0=0A=
[    0.291120] ... bit width:              48=0A=
[    0.292203] ... generic registers:      4=0A=
[    0.293262] ... value mask:             0000ffffffffffff=0A=
[    0.294650] ... max period:             00007fffffffffff=0A=
[    0.296053] ... fixed-purpose events:   0=0A=
[    0.297134] ... event mask:             000000000000000f=0A=
[    0.298759] x86: Booted up 1 node, 1 CPUs=0A=
[    0.299873] smpboot: Total of 1 processors activated (6000.15 =
BogoMIPS)=0A=
[    0.301887] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106=0A=
[    0.303669] devtmpfs: initialized=0A=
[    0.304806] kworker/u16:0 (14) used greatest stack depth: 6248 bytes =
left=0A=
[    0.306658] xor: measuring software checksum speed=0A=
[    0.408477]    prefetch64-sse: 12224.800 MB/sec=0A=
[    0.508385]    generic_sse: 11643.600 MB/sec=0A=
[    0.509567] xor: using function: prefetch64-sse (12224.800 MB/sec)=0A=
[    0.511333] NET: Registered protocol family 16=0A=
[    0.512815] cpuidle: using governor ladder=0A=
[    0.514033] cpuidle: using governor menu=0A=
[    0.515907] ACPI: bus type PCI registered=0A=
[    0.517246] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem =
0xf0000000-0xf7ffffff] (base 0xf0000000)=0A=
[    0.519737] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in =
E820=0A=
[    0.525415] PCI: Using configuration type 1 for base access=0A=
[    0.527337] kworker/u16:0 (41) used greatest stack depth: 5832 bytes =
left=0A=
[    0.540571] bio: create slab <bio-0> at 0=0A=
[    0.708240] raid6: sse2x1    3985 MB/s=0A=
[    0.878012] raid6: sse2x2    6637 MB/s=0A=
[    1.047854] raid6: sse2x4    7519 MB/s=0A=
[    1.048878] raid6: using algorithm sse2x4 (7519 MB/s)=0A=
[    1.050200] raid6: using intx1 recovery algorithm=0A=
[    1.051802] ACPI: Added _OSI(Module Device)=0A=
[    1.052986] ACPI: Added _OSI(Processor Device)=0A=
[    1.054153] ACPI: Added _OSI(3.0 _SCP Extensions)=0A=
[    1.055434] ACPI: Added _OSI(Processor Aggregator Device)=0A=
[    1.064341] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored=0A=
[    1.072476] ACPI: Interpreter enabled=0A=
[    1.073519] ACPI: (supports S0 S5)=0A=
[    1.074446] ACPI: Using IOAPIC for interrupt routing=0A=
[    1.075932] PCI: Using host bridge windows from ACPI; if necessary, =
use "pci=3Dnocrs" and report a bug=0A=
[    1.097944] ACPI: No dock devices found.=0A=
[    1.176769] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])=0A=
[    1.178495] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM =
ClockPM Segments MSI]=0A=
[    1.180923] acpi PNP0A03:00: _OSC: platform does not support [AER]=0A=
[    1.182761] acpi PNP0A03:00: _OSC: OS now controls [PCIeHotplug PME =
PCIeCapability]=0A=
[    1.186223] PCI host bridge to bus 0000:00=0A=
[    1.187398] pci_bus 0000:00: root bus resource [bus 00-7f]=0A=
[    1.188859] pci_bus 0000:00: root bus resource [mem =
0x000a0000-0x000bffff]=0A=
[    1.190662] pci_bus 0000:00: root bus resource [mem =
0x000cc000-0x000cffff]=0A=
[    1.192451] pci_bus 0000:00: root bus resource [mem =
0x000d0000-0x000d3fff]=0A=
[    1.194273] pci_bus 0000:00: root bus resource [mem =
0x000d4000-0x000d7fff]=0A=
[    1.196177] pci_bus 0000:00: root bus resource [mem =
0x000d8000-0x000dbfff]=0A=
[    1.198040] pci_bus 0000:00: root bus resource [mem =
0xc0000000-0xfebfffff]=0A=
[    1.199819] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]=0A=
[    1.201457] pci_bus 0000:00: root bus resource [io  0x0d00-0xfeff]=0A=
[    1.209041] pci 0000:00:07.3: quirk: [io  0x1000-0x103f] claimed by =
PIIX4 ACPI=0A=
[    1.211084] pci 0000:00:07.3: quirk: [io  0x1040-0x104f] claimed by =
PIIX4 SMB=0A=
[    1.228702] pci 0000:00:11.0: System wakeup disabled by ACPI=0A=
[    1.231605] pci 0000:00:15.0: System wakeup disabled by ACPI=0A=
[    1.234254] pci 0000:00:15.1: System wakeup disabled by ACPI=0A=
[    1.236925] pci 0000:00:15.2: System wakeup disabled by ACPI=0A=
[    1.239568] pci 0000:00:15.3: System wakeup disabled by ACPI=0A=
[    1.242444] pci 0000:00:15.4: System wakeup disabled by ACPI=0A=
[    1.245204] pci 0000:00:15.5: System wakeup disabled by ACPI=0A=
[    1.248120] pci 0000:00:15.6: System wakeup disabled by ACPI=0A=
[    1.250863] pci 0000:00:15.7: System wakeup disabled by ACPI=0A=
[    1.253509] pci 0000:00:16.0: System wakeup disabled by ACPI=0A=
[    1.256163] pci 0000:00:16.1: System wakeup disabled by ACPI=0A=
[    1.258845] pci 0000:00:16.2: System wakeup disabled by ACPI=0A=
[    1.261597] pci 0000:00:16.3: System wakeup disabled by ACPI=0A=
[    1.264279] pci 0000:00:16.4: System wakeup disabled by ACPI=0A=
[    1.266982] pci 0000:00:16.5: System wakeup disabled by ACPI=0A=
[    1.269623] pci 0000:00:16.6: System wakeup disabled by ACPI=0A=
[    1.272304] pci 0000:00:16.7: System wakeup disabled by ACPI=0A=
[    1.274930] pci 0000:00:17.0: System wakeup disabled by ACPI=0A=
[    1.277705] pci 0000:00:17.1: System wakeup disabled by ACPI=0A=
[    1.280458] pci 0000:00:17.2: System wakeup disabled by ACPI=0A=
[    1.283102] pci 0000:00:17.3: System wakeup disabled by ACPI=0A=
[    1.285762] pci 0000:00:17.4: System wakeup disabled by ACPI=0A=
[    1.288441] pci 0000:00:17.5: System wakeup disabled by ACPI=0A=
[    1.291122] pci 0000:00:17.6: System wakeup disabled by ACPI=0A=
[    1.293771] pci 0000:00:17.7: System wakeup disabled by ACPI=0A=
[    1.296593] pci 0000:00:18.0: System wakeup disabled by ACPI=0A=
[    1.299285] pci 0000:00:18.1: System wakeup disabled by ACPI=0A=
[    1.301995] pci 0000:00:18.2: System wakeup disabled by ACPI=0A=
[    1.304622] pci 0000:00:18.3: System wakeup disabled by ACPI=0A=
[    1.307340] pci 0000:00:18.4: System wakeup disabled by ACPI=0A=
[    1.309974] pci 0000:00:18.5: System wakeup disabled by ACPI=0A=
[    1.312751] pci 0000:00:18.6: System wakeup disabled by ACPI=0A=
[    1.316227] pci 0000:00:18.7: System wakeup disabled by ACPI=0A=
[    1.318325] pci 0000:00:01.0: PCI bridge to [bus 01]=0A=
[    1.323991] pci 0000:02:00.0: System wakeup disabled by ACPI=0A=
[    1.325985] pci 0000:00:11.0: PCI bridge to [bus 02] (subtractive =
decode)=0A=
[    1.328465] pci 0000:00:15.0: PCI bridge to [bus 03]=0A=
[    1.330447] pci 0000:00:15.1: PCI bridge to [bus 04]=0A=
[    1.332282] pci 0000:00:15.2: PCI bridge to [bus 05]=0A=
[    1.334126] pci 0000:00:15.3: PCI bridge to [bus 06]=0A=
[    1.336035] pci 0000:00:15.4: PCI bridge to [bus 07]=0A=
[    1.337936] pci 0000:00:15.5: PCI bridge to [bus 08]=0A=
[    1.339772] pci 0000:00:15.6: PCI bridge to [bus 09]=0A=
[    1.341703] pci 0000:00:15.7: PCI bridge to [bus 0a]=0A=
[    1.343550] pci 0000:00:16.0: PCI bridge to [bus 0b]=0A=
[    1.345501] pci 0000:00:16.1: PCI bridge to [bus 0c]=0A=
[    1.347450] pci 0000:00:16.2: PCI bridge to [bus 0d]=0A=
[    1.349321] pci 0000:00:16.3: PCI bridge to [bus 0e]=0A=
[    1.351228] pci 0000:00:16.4: PCI bridge to [bus 0f]=0A=
[    1.353100] pci 0000:00:16.5: PCI bridge to [bus 10]=0A=
[    1.354933] pci 0000:00:16.6: PCI bridge to [bus 11]=0A=
[    1.356885] pci 0000:00:16.7: PCI bridge to [bus 12]=0A=
[    1.358748] pci 0000:00:17.0: PCI bridge to [bus 13]=0A=
[    1.360680] pci 0000:00:17.1: PCI bridge to [bus 14]=0A=
[    1.362580] pci 0000:00:17.2: PCI bridge to [bus 15]=0A=
[    1.364458] pci 0000:00:17.3: PCI bridge to [bus 16]=0A=
[    1.366381] pci 0000:00:17.4: PCI bridge to [bus 17]=0A=
[    1.368286] pci 0000:00:17.5: PCI bridge to [bus 18]=0A=
[    1.370187] pci 0000:00:17.6: PCI bridge to [bus 19]=0A=
[    1.372027] pci 0000:00:17.7: PCI bridge to [bus 1a]=0A=
[    1.373879] pci 0000:00:18.0: PCI bridge to [bus 1b]=0A=
[    1.375813] pci 0000:00:18.1: PCI bridge to [bus 1c]=0A=
[    1.377736] pci 0000:00:18.2: PCI bridge to [bus 1d]=0A=
[    1.379633] pci 0000:00:18.3: PCI bridge to [bus 1e]=0A=
[    1.381962] pci 0000:00:18.4: PCI bridge to [bus 1f]=0A=
[    1.383847] pci 0000:00:18.5: PCI bridge to [bus 20]=0A=
[    1.385761] pci 0000:00:18.6: PCI bridge to [bus 21]=0A=
[    1.387677] pci 0000:00:18.7: PCI bridge to [bus 22]=0A=
[    1.391377] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 =
14 15)=0A=
[    1.394030] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 =
14 15)=0A=
[    1.396905] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 =
14 15)=0A=
[    1.399661] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 =
14 15) *0, disabled.=0A=
[    1.413372] ACPI: Enabled 2 GPEs in block 00 to 0F=0A=
[    1.415332] vgaarb: device added: =
PCI:0000:00:0f.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone=0A=
[    1.417535] vgaarb: loaded=0A=
[    1.418293] vgaarb: bridge control possible 0000:00:0f.0=0A=
[    1.419818] SCSI subsystem initialized=0A=
[    1.421042] ACPI: bus type USB registered=0A=
[    1.422182] usbcore: registered new interface driver usbfs=0A=
[    1.423674] usbcore: registered new interface driver hub=0A=
[    1.425126] usbcore: registered new device driver usb=0A=
[    1.426536] pps_core: LinuxPPS API ver. 1 registered=0A=
[    1.427922] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 =
Rodolfo Giometti <giometti@linux.it>=0A=
[    1.430560] PTP clock support registered=0A=
[    1.431796] PCI: Using ACPI for IRQ routing=0A=
[    1.464415] NetLabel: Initializing=0A=
[    1.465410] NetLabel:  domain hash size =3D 128=0A=
[    1.466554] NetLabel:  protocols =3D UNLABELED CIPSOv4=0A=
[    1.467923] NetLabel:  unlabeled traffic allowed by default=0A=
[    1.469533] HPET: 16 timers in total, 0 timers will be used for =
per-cpu timer=0A=
[    1.471481] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0, =
0, 0, 0, 0, 0, 0, 0, 0=0A=
[    1.474689] hpet0: 16 comparators, 64-bit 14.318180 MHz counter=0A=
[    1.478425] Switched to clocksource hpet=0A=
[    1.479588] FS-Cache: Loaded=0A=
[    1.480864] pnp: PnP ACPI init=0A=
[    1.481772] ACPI: bus type PNP registered=0A=
[    1.483130] system 00:00: [io  0x1000-0x103f] could not be reserved=0A=
[    1.484783] system 00:00: [io  0x1040-0x104f] has been reserved=0A=
[    1.486361] system 00:00: [io  0x0cf0-0x0cf1] has been reserved=0A=
[    1.488568] system 00:07: [mem 0xfed00000-0xfed003ff] has been =
reserved=0A=
[    1.493015] system 00:0c: [io  0xfce0-0xfcff] has been reserved=0A=
[    1.494594] system 00:0c: [mem 0xf0000000-0xf7ffffff] has been =
reserved=0A=
[    1.496367] system 00:0c: [mem 0xfe800000-0xfe9fffff] has been =
reserved=0A=
[    1.504558] pnp: PnP ACPI: found 14 devices=0A=
[    1.505778] ACPI: bus type PNP unregistered=0A=
[    1.516299] pci 0000:00:0f.0: BAR 6: assigned [mem =
0xc0000000-0xc0007fff pref]=0A=
[    1.518231] pci 0000:00:10.0: BAR 6: assigned [mem =
0xc0008000-0xc000bfff pref]=0A=
[    1.520196] pci 0000:00:15.3: BAR 7: can't assign io (size 0x1000)=0A=
[    1.521805] pci 0000:00:15.4: BAR 7: can't assign io (size 0x1000)=0A=
[    1.523422] pci 0000:00:15.5: BAR 7: can't assign io (size 0x1000)=0A=
[    1.525193] pci 0000:00:15.6: BAR 7: can't assign io (size 0x1000)=0A=
[    1.526814] pci 0000:00:15.7: BAR 7: can't assign io (size 0x1000)=0A=
[    1.528460] pci 0000:00:16.3: BAR 7: can't assign io (size 0x1000)=0A=
[    1.530122] pci 0000:00:16.4: BAR 7: can't assign io (size 0x1000)=0A=
[    1.531785] pci 0000:00:16.5: BAR 7: can't assign io (size 0x1000)=0A=
[    1.533421] pci 0000:00:16.6: BAR 7: can't assign io (size 0x1000)=0A=
[    1.535058] pci 0000:00:16.7: BAR 7: can't assign io (size 0x1000)=0A=
[    1.536659] pci 0000:00:17.3: BAR 7: can't assign io (size 0x1000)=0A=
[    1.538269] pci 0000:00:17.4: BAR 7: can't assign io (size 0x1000)=0A=
[    1.539915] pci 0000:00:17.5: BAR 7: can't assign io (size 0x1000)=0A=
[    1.541519] pci 0000:00:17.6: BAR 7: can't assign io (size 0x1000)=0A=
[    1.543133] pci 0000:00:17.7: BAR 7: can't assign io (size 0x1000)=0A=
[    1.544732] pci 0000:00:18.2: BAR 7: can't assign io (size 0x1000)=0A=
[    1.546383] pci 0000:00:18.3: BAR 7: can't assign io (size 0x1000)=0A=
[    1.548069] pci 0000:00:18.4: BAR 7: can't assign io (size 0x1000)=0A=
[    1.549728] pci 0000:00:18.5: BAR 7: can't assign io (size 0x1000)=0A=
[    1.551350] pci 0000:00:18.6: BAR 7: can't assign io (size 0x1000)=0A=
[    1.552964] pci 0000:00:18.7: BAR 7: can't assign io (size 0x1000)=0A=
[    1.554567] pci 0000:00:18.7: BAR 7: can't assign io (size 0x1000)=0A=
[    1.556186] pci 0000:00:18.6: BAR 7: can't assign io (size 0x1000)=0A=
[    1.557794] pci 0000:00:18.5: BAR 7: can't assign io (size 0x1000)=0A=
[    1.559419] pci 0000:00:18.4: BAR 7: can't assign io (size 0x1000)=0A=
[    1.561047] pci 0000:00:18.3: BAR 7: can't assign io (size 0x1000)=0A=
[    1.562667] pci 0000:00:18.2: BAR 7: can't assign io (size 0x1000)=0A=
[    1.564326] pci 0000:00:17.7: BAR 7: can't assign io (size 0x1000)=0A=
[    1.566004] pci 0000:00:17.6: BAR 7: can't assign io (size 0x1000)=0A=
[    1.567611] pci 0000:00:17.5: BAR 7: can't assign io (size 0x1000)=0A=
[    1.569236] pci 0000:00:17.4: BAR 7: can't assign io (size 0x1000)=0A=
[    1.570864] pci 0000:00:17.3: BAR 7: can't assign io (size 0x1000)=0A=
[    1.572474] pci 0000:00:16.7: BAR 7: can't assign io (size 0x1000)=0A=
[    1.574083] pci 0000:00:16.6: BAR 7: can't assign io (size 0x1000)=0A=
[    1.575699] pci 0000:00:16.5: BAR 7: can't assign io (size 0x1000)=0A=
[    1.577318] pci 0000:00:16.4: BAR 7: can't assign io (size 0x1000)=0A=
[    1.578942] pci 0000:00:16.3: BAR 7: can't assign io (size 0x1000)=0A=
[    1.580627] pci 0000:00:15.7: BAR 7: can't assign io (size 0x1000)=0A=
[    1.582276] pci 0000:00:15.6: BAR 7: can't assign io (size 0x1000)=0A=
[    1.583916] pci 0000:00:15.5: BAR 7: can't assign io (size 0x1000)=0A=
[    1.585538] pci 0000:00:15.4: BAR 7: can't assign io (size 0x1000)=0A=
[    1.587139] pci 0000:00:15.3: BAR 7: can't assign io (size 0x1000)=0A=
[    1.588769] pci 0000:00:01.0: PCI bridge to [bus 01]=0A=
[    1.590210] pci 0000:02:00.0: BAR 6: assigned [mem =
0xe7b00000-0xe7b0ffff pref]=0A=
[    1.592092] pci 0000:00:11.0: PCI bridge to [bus 02]=0A=
[    1.593423] pci 0000:00:11.0:   bridge window [io  0x2000-0x3fff]=0A=
[    1.595052] pci 0000:00:11.0:   bridge window [mem =
0xfd500000-0xfdffffff]=0A=
[    1.596853] pci 0000:00:11.0:   bridge window [mem =
0xe7b00000-0xe7ffffff 64bit pref]=0A=
[    1.599018] pci 0000:00:15.0: PCI bridge to [bus 03]=0A=
[    1.600395] pci 0000:00:15.0:   bridge window [io  0x4000-0x4fff]=0A=
[    1.602003] pci 0000:00:15.0:   bridge window [mem =
0xfd400000-0xfd4fffff]=0A=
[    1.603789] pci 0000:00:15.0:   bridge window [mem =
0xe7a00000-0xe7afffff 64bit pref]=0A=
[    1.605895] pci 0000:00:15.1: PCI bridge to [bus 04]=0A=
[    1.607216] pci 0000:00:15.1:   bridge window [io  0x8000-0x8fff]=0A=
[    1.608880] pci 0000:00:15.1:   bridge window [mem =
0xfd000000-0xfd0fffff]=0A=
[    1.610694] pci 0000:00:15.1:   bridge window [mem =
0xe7600000-0xe76fffff 64bit pref]=0A=
[    1.612800] pci 0000:00:15.2: PCI bridge to [bus 05]=0A=
[    1.614156] pci 0000:00:15.2:   bridge window [io  0xc000-0xcfff]=0A=
[    1.615851] pci 0000:00:15.2:   bridge window [mem =
0xfcc00000-0xfccfffff]=0A=
[    1.617658] pci 0000:00:15.2:   bridge window [mem =
0xe7200000-0xe72fffff 64bit pref]=0A=
[    1.620513] pci 0000:00:15.3: PCI bridge to [bus 06]=0A=
[    1.621857] pci 0000:00:15.3:   bridge window [mem =
0xfc800000-0xfc8fffff]=0A=
[    1.623653] pci 0000:00:15.3:   bridge window [mem =
0xe6e00000-0xe6efffff 64bit pref]=0A=
[    1.625748] pci 0000:00:15.4: PCI bridge to [bus 07]=0A=
[    1.627087] pci 0000:00:15.4:   bridge window [mem =
0xfc400000-0xfc4fffff]=0A=
[    1.628893] pci 0000:00:15.4:   bridge window [mem =
0xe6a00000-0xe6afffff 64bit pref]=0A=
[    1.631208] pci 0000:00:15.5: PCI bridge to [bus 08]=0A=
[    1.632633] pci 0000:00:15.5:   bridge window [mem =
0xfc000000-0xfc0fffff]=0A=
[    1.634426] pci 0000:00:15.5:   bridge window [mem =
0xe6600000-0xe66fffff 64bit pref]=0A=
[    1.636569] pci 0000:00:15.6: PCI bridge to [bus 09]=0A=
[    1.637917] pci 0000:00:15.6:   bridge window [mem =
0xfbc00000-0xfbcfffff]=0A=
[    1.639796] pci 0000:00:15.6:   bridge window [mem =
0xe6200000-0xe62fffff 64bit pref]=0A=
[    1.641866] pci 0000:00:15.7: PCI bridge to [bus 0a]=0A=
[    1.643217] pci 0000:00:15.7:   bridge window [mem =
0xfb800000-0xfb8fffff]=0A=
[    1.645054] pci 0000:00:15.7:   bridge window [mem =
0xe5e00000-0xe5efffff 64bit pref]=0A=
[    1.647148] pci 0000:00:16.0: PCI bridge to [bus 0b]=0A=
[    1.648544] pci 0000:00:16.0:   bridge window [io  0x5000-0x5fff]=0A=
[    1.650265] pci 0000:00:16.0:   bridge window [mem =
0xfd300000-0xfd3fffff]=0A=
[    1.652039] pci 0000:00:16.0:   bridge window [mem =
0xe7900000-0xe79fffff 64bit pref]=0A=
[    1.654112] pci 0000:00:16.1: PCI bridge to [bus 0c]=0A=
[    1.655482] pci 0000:00:16.1:   bridge window [io  0x9000-0x9fff]=0A=
[    1.657098] pci 0000:00:16.1:   bridge window [mem =
0xfcf00000-0xfcffffff]=0A=
[    1.658914] pci 0000:00:16.1:   bridge window [mem =
0xe7500000-0xe75fffff 64bit pref]=0A=
[    1.661057] pci 0000:00:16.2: PCI bridge to [bus 0d]=0A=
[    1.662375] pci 0000:00:16.2:   bridge window [io  0xd000-0xdfff]=0A=
[    1.664024] pci 0000:00:16.2:   bridge window [mem =
0xfcb00000-0xfcbfffff]=0A=
[    1.665908] pci 0000:00:16.2:   bridge window [mem =
0xe7100000-0xe71fffff 64bit pref]=0A=
[    1.668011] pci 0000:00:16.3: PCI bridge to [bus 0e]=0A=
[    1.669370] pci 0000:00:16.3:   bridge window [mem =
0xfc700000-0xfc7fffff]=0A=
[    1.671201] pci 0000:00:16.3:   bridge window [mem =
0xe6d00000-0xe6dfffff 64bit pref]=0A=
[    1.673274] pci 0000:00:16.4: PCI bridge to [bus 0f]=0A=
[    1.674614] pci 0000:00:16.4:   bridge window [mem =
0xfc300000-0xfc3fffff]=0A=
[    1.676441] pci 0000:00:16.4:   bridge window [mem =
0xe6900000-0xe69fffff 64bit pref]=0A=
[    1.678537] pci 0000:00:16.5: PCI bridge to [bus 10]=0A=
[    1.679943] pci 0000:00:16.5:   bridge window [mem =
0xfbf00000-0xfbffffff]=0A=
[    1.681784] pci 0000:00:16.5:   bridge window [mem =
0xe6500000-0xe65fffff 64bit pref]=0A=
[    1.684045] pci 0000:00:16.6: PCI bridge to [bus 11]=0A=
[    1.685433] pci 0000:00:16.6:   bridge window [mem =
0xfbb00000-0xfbbfffff]=0A=
[    1.687219] pci 0000:00:16.6:   bridge window [mem =
0xe6100000-0xe61fffff 64bit pref]=0A=
[    1.689335] pci 0000:00:16.7: PCI bridge to [bus 12]=0A=
[    1.690775] pci 0000:00:16.7:   bridge window [mem =
0xfb700000-0xfb7fffff]=0A=
[    1.692572] pci 0000:00:16.7:   bridge window [mem =
0xe5d00000-0xe5dfffff 64bit pref]=0A=
[    1.694640] pci 0000:00:17.0: PCI bridge to [bus 13]=0A=
[    1.695985] pci 0000:00:17.0:   bridge window [io  0x6000-0x6fff]=0A=
[    1.697660] pci 0000:00:17.0:   bridge window [mem =
0xfd200000-0xfd2fffff]=0A=
[    1.699511] pci 0000:00:17.0:   bridge window [mem =
0xe7800000-0xe78fffff 64bit pref]=0A=
[    1.701661] pci 0000:00:17.1: PCI bridge to [bus 14]=0A=
[    1.702996] pci 0000:00:17.1:   bridge window [io  0xa000-0xafff]=0A=
[    1.704612] pci 0000:00:17.1:   bridge window [mem =
0xfce00000-0xfcefffff]=0A=
[    1.706421] pci 0000:00:17.1:   bridge window [mem =
0xe7400000-0xe74fffff 64bit pref]=0A=
[    1.708515] pci 0000:00:17.2: PCI bridge to [bus 15]=0A=
[    1.709856] pci 0000:00:17.2:   bridge window [io  0xe000-0xefff]=0A=
[    1.711474] pci 0000:00:17.2:   bridge window [mem =
0xfca00000-0xfcafffff]=0A=
[    1.713263] pci 0000:00:17.2:   bridge window [mem =
0xe7000000-0xe70fffff 64bit pref]=0A=
[    1.715437] pci 0000:00:17.3: PCI bridge to [bus 16]=0A=
[    1.716812] pci 0000:00:17.3:   bridge window [mem =
0xfc600000-0xfc6fffff]=0A=
[    1.718622] pci 0000:00:17.3:   bridge window [mem =
0xe6c00000-0xe6cfffff 64bit pref]=0A=
[    1.720727] pci 0000:00:17.4: PCI bridge to [bus 17]=0A=
[    1.722063] pci 0000:00:17.4:   bridge window [mem =
0xfc200000-0xfc2fffff]=0A=
[    1.723863] pci 0000:00:17.4:   bridge window [mem =
0xe6800000-0xe68fffff 64bit pref]=0A=
[    1.725948] pci 0000:00:17.5: PCI bridge to [bus 18]=0A=
[    1.727305] pci 0000:00:17.5:   bridge window [mem =
0xfbe00000-0xfbefffff]=0A=
[    1.729102] pci 0000:00:17.5:   bridge window [mem =
0xe6400000-0xe64fffff 64bit pref]=0A=
[    1.731233] pci 0000:00:17.6: PCI bridge to [bus 19]=0A=
[    1.732608] pci 0000:00:17.6:   bridge window [mem =
0xfba00000-0xfbafffff]=0A=
[    1.734413] pci 0000:00:17.6:   bridge window [mem =
0xe6000000-0xe60fffff 64bit pref]=0A=
[    1.736510] pci 0000:00:17.7: PCI bridge to [bus 1a]=0A=
[    1.737858] pci 0000:00:17.7:   bridge window [mem =
0xfb600000-0xfb6fffff]=0A=
[    1.739685] pci 0000:00:17.7:   bridge window [mem =
0xe5c00000-0xe5cfffff 64bit pref]=0A=
[    1.741760] pci 0000:00:18.0: PCI bridge to [bus 1b]=0A=
[    1.743091] pci 0000:00:18.0:   bridge window [io  0x7000-0x7fff]=0A=
[    1.744720] pci 0000:00:18.0:   bridge window [mem =
0xfd100000-0xfd1fffff]=0A=
[    1.746504] pci 0000:00:18.0:   bridge window [mem =
0xe7700000-0xe77fffff 64bit pref]=0A=
[    1.748658] pci 0000:00:18.1: PCI bridge to [bus 1c]=0A=
[    1.750089] pci 0000:00:18.1:   bridge window [io  0xb000-0xbfff]=0A=
[    1.751742] pci 0000:00:18.1:   bridge window [mem =
0xfcd00000-0xfcdfffff]=0A=
[    1.753534] pci 0000:00:18.1:   bridge window [mem =
0xe7300000-0xe73fffff 64bit pref]=0A=
[    1.755627] pci 0000:00:18.2: PCI bridge to [bus 1d]=0A=
[    1.756966] pci 0000:00:18.2:   bridge window [mem =
0xfc900000-0xfc9fffff]=0A=
[    1.758780] pci 0000:00:18.2:   bridge window [mem =
0xe6f00000-0xe6ffffff 64bit pref]=0A=
[    1.760870] pci 0000:00:18.3: PCI bridge to [bus 1e]=0A=
[    1.762230] pci 0000:00:18.3:   bridge window [mem =
0xfc500000-0xfc5fffff]=0A=
[    1.764033] pci 0000:00:18.3:   bridge window [mem =
0xe6b00000-0xe6bfffff 64bit pref]=0A=
[    1.766164] pci 0000:00:18.4: PCI bridge to [bus 1f]=0A=
[    1.767549] pci 0000:00:18.4:   bridge window [mem =
0xfc100000-0xfc1fffff]=0A=
[    1.769351] pci 0000:00:18.4:   bridge window [mem =
0xe6700000-0xe67fffff 64bit pref]=0A=
[    1.771444] pci 0000:00:18.5: PCI bridge to [bus 20]=0A=
[    1.772797] pci 0000:00:18.5:   bridge window [mem =
0xfbd00000-0xfbdfffff]=0A=
[    1.774579] pci 0000:00:18.5:   bridge window [mem =
0xe6300000-0xe63fffff 64bit pref]=0A=
[    1.776680] pci 0000:00:18.6: PCI bridge to [bus 21]=0A=
[    1.778024] pci 0000:00:18.6:   bridge window [mem =
0xfb900000-0xfb9fffff]=0A=
[    1.779857] pci 0000:00:18.6:   bridge window [mem =
0xe5f00000-0xe5ffffff 64bit pref]=0A=
[    1.781972] pci 0000:00:18.7: PCI bridge to [bus 22]=0A=
[    1.783354] pci 0000:00:18.7:   bridge window [mem =
0xfb500000-0xfb5fffff]=0A=
[    1.785176] pci 0000:00:18.7:   bridge window [mem =
0xe5b00000-0xe5bfffff 64bit pref]=0A=
[    1.787455] NET: Registered protocol family 2=0A=
[    1.788759] TCP established hash table entries: 8192 (order: 4, 65536 =
bytes)=0A=
[    1.790676] TCP bind hash table entries: 8192 (order: 5, 131072 bytes)=0A=
[    1.792421] TCP: Hash tables configured (established 8192 bind 8192)=0A=
[    1.794112] TCP: reno registered=0A=
[    1.795031] UDP hash table entries: 512 (order: 2, 16384 bytes)=0A=
[    1.796581] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)=0A=
[    1.798442] NET: Registered protocol family 1=0A=
[    1.799715] pci 0000:00:00.0: Limiting direct PCI/PCI transfers=0A=
[    1.801903] Simple Boot Flag at 0x36 set to 0x80=0A=
[    1.803194] Switched to clocksource tsc=0A=
[    1.804341] microcode: CPU0: patch_level=3D0x010000b6=0A=
[    1.805770] microcode: Microcode Update Driver: v2.00 =
<tigran@aivazian.fsnet.co.uk>, Peter Oruba=0A=
[    1.808222] PCLMULQDQ-NI instructions are not detected.=0A=
[    1.809685] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.=0A=
[    1.811352] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.=0A=
[    1.813569] futex hash table entries: 2048 (order: 5, 131072 bytes)=0A=
[    1.816123] HugeTLB registered 2 MB page size, pre-allocated 0 pages=0A=
[    1.821511] fuse init (API version 7.22)=0A=
[    1.823563] SGI XFS with security attributes, large block/inode =
numbers, no debug enabled=0A=
[    1.826856] msgmni has been set to 1978=0A=
[    1.829708] Block layer SCSI generic (bsg) driver version 0.4 loaded =
(major 251)=0A=
[    1.831721] io scheduler noop registered (default)=0A=
[    1.833004] io scheduler deadline registered=0A=
[    1.834447] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64=0A=
[    1.835819] crc32: self tests passed, processed 225944 bytes in =
131098 nsec=0A=
[    1.837751] crc32c: CRC_LE_BITS =3D 64=0A=
[    1.838749] crc32c: self tests passed, processed 225944 bytes in =
65511 nsec=0A=
[    2.056426] crc32_combine: 8373 self tests passed=0A=
[    2.275509] crc32c_combine: 8373 self tests passed=0A=
[    2.300041] ACPI: AC Adapter [ACAD] (on-line)=0A=
[    2.301520] input: Power Button as =
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0=0A=
[    2.303536] ACPI: Power Button [PWRF]=0A=
[    2.305823] xenfs: not registering filesystem on non-xen platform=0A=
[    2.307832] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled=0A=
[    2.335413] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D =
115200) is a 16550A=0A=
[    2.363411] 00:0a: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D =
115200) is a 16550A=0A=
[    2.366192] Non-volatile memory driver v1.3=0A=
[    2.367404] Linux agpgart interface v0.103=0A=
[    2.368726] agpgart-intel 0000:00:00.0: Intel 440BX Chipset=0A=
[    2.372581] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x0=0A=
[    2.374407] [drm] Initialized drm 1.1.0 20060810=0A=
[    2.377148] brd: module loaded=0A=
[    2.378821] loop: module loaded=0A=
[    2.379787] HP CISS Driver (v 3.6.26)=0A=
[    2.381288] vmw_vmci 0000:00:07.7: Found VMCI PCI device at 0x11080, =
irq 16=0A=
[    2.383209] vmw_vmci 0000:00:07.7: Using capabilities 0xc=0A=
[    2.385464] Guest personality initialized and is active=0A=
[    2.387009] VMCI host device registered (name=3Dvmci, major=3D10, =
minor=3D62)=0A=
[    2.388817] Initialized host personality=0A=
[    2.390445] mpt2sas version 16.100.00.00 loaded=0A=
[    2.391822] VMware PVSCSI driver - version 1.0.2.0-k=0A=
[    2.393878] scsi0 : ata_piix=0A=
[    2.394878] scsi1 : ata_piix=0A=
[    2.395744] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x1060 =
irq 14=0A=
[    2.397605] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x1068 =
irq 15=0A=
[    2.400167] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April =
27, 2011)=0A=
[    2.406121] pcnet32: pcnet32.c:v1.35 21.Apr.2008 =
tsbogend@alpha.franken.de=0A=
[    2.408201] e1000: Intel(R) PRO/1000 Network Driver - version =
7.3.21-k8-NAPI=0A=
[    2.410084] e1000: Copyright (c) 1999-2006 Intel Corporation.=0A=
[    2.788881] ata2.00: ATAPI: VMware Virtual IDE CDROM Drive, 00000001, =
max UDMA/33=0A=
[    2.814823] e1000 0000:02:00.0 eth0: (PCI:66MHz:32-bit) =
00:0c:29:55:5f:81=0A=
[    2.816679] e1000 0000:02:00.0 eth0: Intel(R) PRO/1000 Network =
Connection=0A=
[    2.818534] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k=0A=
[    2.820092] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.=0A=
[    2.821705] igb: Intel(R) Gigabit Ethernet Network Driver - version =
5.0.5-k=0A=
[    2.823504] igb: Copyright (c) 2007-2013 Intel Corporation.=0A=
[    2.825167] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI=0A=
[    2.826976] Fusion MPT base driver 3.04.20=0A=
[    2.828114] Copyright (c) 1999-2008 LSI Corporation=0A=
[    2.829435] Fusion MPT SPI Host driver 3.04.20=0A=
[    2.831137] ata2.00: configured for UDMA/33=0A=
[    2.832523] mptbase: ioc0: Initiating bringup=0A=
[    2.834148] scsi 1:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 =
1.00 PQ: 0 ANSI: 5=0A=
[    2.836817] sr0: scsi3-mmc drive: 1x/1x writer dvd-ram cd/rw xa/form2 =
cdda tray=0A=
[    2.838827] cdrom: Uniform CD-ROM driver Revision: 3.20=0A=
[    2.840704] sr 1:0:0:0: Attached scsi generic sg0 type 5=0A=
[    3.009600] ioc0: LSI53C1030 B0: Capabilities=3D{Initiator}=0A=
[    3.421176] scsi2 : ioc0: LSI53C1030 B0, FwRev=3D01032920h, =
Ports=3D1, MaxQ=3D128, IRQ=3D17=0A=
[    3.708611] scsi 2:0:0:0: Direct-Access     VMware,  VMware Virtual S =
1.0  PQ: 0 ANSI: 2=0A=
[    3.716530] scsi target2:0:0: Beginning Domain Validation=0A=
[    3.724599] scsi target2:0:0: Domain Validation skipping write tests=0A=
[    3.730941] scsi target2:0:0: Ending Domain Validation=0A=
[    3.736253] scsi target2:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, =
offset 127)=0A=
[    3.744688] sd 2:0:0:0: [sda] 25165824 512-byte logical blocks: (12.8 =
GB/12.0 GiB)=0A=
[    3.752658] sd 2:0:0:0: [sda] Write Protect is off=0A=
[    3.757832] sd 2:0:0:0: [sda] Cache data unavailable=0A=
[    3.759650] sd 2:0:0:0: [sda] Assuming drive cache: write through=0A=
[    3.762307] sd 2:0:0:0: [sda] Cache data unavailable=0A=
[    3.764020] sd 2:0:0:0: [sda] Assuming drive cache: write through=0A=
[    3.766858] sd 2:0:0:0: Attached scsi generic sg1 type 0=0A=
[    3.770432] Fusion MPT FC Host driver 3.04.20=0A=
[    3.772014] Fusion MPT SAS Host driver 3.04.20=0A=
[    3.773597] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=0A=
[    3.775812] ehci-pci: EHCI PCI platform driver=0A=
[    3.777423] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver=0A=
[    3.779786] ohci-pci: OHCI PCI platform driver=0A=
[    3.781432]  sda: sda1 sda2 sda3 sda4=0A=
[    3.783001] uhci_hcd: USB Universal Host Controller Interface driver=0A=
[    3.785415] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at =
0x60,0x64 irq 1,12=0A=
[    3.789311] serio: i8042 KBD port at 0x60,0x64 irq 1=0A=
[    3.790656] serio: i8042 AUX port at 0x60,0x64 irq 12=0A=
[    3.792305] sd 2:0:0:0: [sda] Cache data unavailable=0A=
[    3.793666] sd 2:0:0:0: [sda] Assuming drive cache: write through=0A=
[    3.795290] sd 2:0:0:0: [sda] Attached SCSI disk=0A=
[    3.796781] mousedev: PS/2 mouse device common for all mice=0A=
[    3.819487] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0=0A=
[    3.821298] rtc_cmos 00:03: alarms up to one month, y3k, 114 bytes =
nvram, hpet irqs=0A=
[    3.823516] md: linear personality registered for level -1=0A=
[    3.825009] md: raid0 personality registered for level 0=0A=
[    3.826460] md: raid1 personality registered for level 1=0A=
[    3.827859] md: raid10 personality registered for level 10=0A=
[    3.829431] md: raid6 personality registered for level 6=0A=
[    3.830889] md: raid5 personality registered for level 5=0A=
[    3.832312] md: raid4 personality registered for level 4=0A=
[    3.833881] input: AT Translated Set 2 keyboard as =
/devices/platform/i8042/serio0/input/input1=0A=
[    3.836312] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) =
initialised: dm-devel@redhat.com=0A=
[    3.840511] device-mapper: raid: Loading target version 1.5.2=0A=
[    3.842381] usbcore: registered new interface driver usbhid=0A=
[    3.843885] usbhid: USB HID core driver=0A=
[    3.844941] Netfilter messages via NETLINK v0.30.=0A=
[    3.846245] nf_conntrack version 0.5.0 (7912 buckets, 31648 max)=0A=
[    3.848046] ctnetlink v0.93: registering with nfnetlink.=0A=
[    3.849550] ip_tables: (C) 2000-2006 Netfilter Core Team=0A=
[    3.851051] TCP: cubic registered=0A=
[    3.851972] TCP: vegas registered=0A=
[    3.852898] TCP: veno registered=0A=
[    3.853791] TCP: yeah registered=0A=
[    3.854664] Initializing XFRM netlink socket=0A=
[    3.855837] NET: Registered protocol family 17=0A=
[    3.857065] Key type dns_resolver registered=0A=
[    3.859251] bio: create slab <bio-1> at 1=0A=
[    3.860859] Btrfs loaded=0A=
[    3.866693] rtc_cmos 00:03: setting system clock to 2014-04-25 =
07:58:15 UTC (1398412695)=0A=
[    4.046211] input: ImPS/2 Generic Wheel Mouse as =
/devices/platform/i8042/serio1/input/input3=0A=
[    4.055141] md: Skipping autodetection of RAID arrays. =
(raid=3Dautodetect will force)=0A=
[    4.062867] Waiting for root device =
uuid=3D2ba08fbc-4b95-46cc-b638-299f16462620...=0A=

------=_NextPart_000_000B_01CF605C.CBD5FC10--

