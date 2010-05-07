From: jason chan <jascan88@gmail.com>
Subject: iscsi target cause kernel oops on btrfs
Date: Thu, 6 May 2010 22:30:31 -0700
Message-ID: <k2s1495a7251005062230pa88bdf76o91d9b8a48702e5c2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I have OpenSUSE and the following rpms:
iscsitarget-kmp-desktop-1.4.19_2.6.34.0_rc5_6-2.13.i586
iscsitarget-1.4.19-2.13.i586
kernel-desktop-2.6.34-6.1.i586
btrfsprogs-0.19-10.4.i586

here is the btrfs info:


aopen:~ # btrfs-show
failed to read /dev/sr0
Label: none =A0uuid: 375c82ae-1edf-4ffe-ab23-94a6b032ce7d
=A0=A0 =A0 =A0 =A0Total devices 4 FS bytes used 79.76GB
=A0=A0 =A0 =A0 =A0devid =A0 =A04 size 929.83GB used 43.01GB path /dev/s=
df3
=A0=A0 =A0 =A0 =A0devid =A0 =A01 size 929.83GB used 44.02GB path /dev/s=
dc3
=A0=A0 =A0 =A0 =A0devid =A0 =A02 size 929.83GB used 44.00GB path /dev/s=
dd3
=A0=A0 =A0 =A0 =A0devid =A0 =A03 size 929.83GB used 43.01GB path /dev/s=
de3

aopen:~ # btrfsck /dev/sdd3
failed to read /dev/sr0
found 85642956800 bytes used err is 0
total csum bytes: 83543828
total tree bytes: 94076928
total fs tree bytes: 253952
btree space waste bytes: 4535828
file data blocks allocated: 114860724224
=A0referenced 93803511808
Btrfs Btrfs v0.19
aopen:~ #


When i ran iscsi target on a (small 8GB) file in btrfs, I get this cons=
istently:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
May =A06 22:11:18 aopen kernel: [ 1201.903352] BUG: unable to handle
kernel NULL pointer dereference at (null)
May =A06 22:11:18 aopen kernel: [ 1201.903369] IP: [<(null)>] (null)
May =A06 22:11:18 aopen kernel: [ 1201.903377] *pdpt =3D 000000003438e0=
01
*pde =3D 0000000000000000
May =A06 22:11:18 aopen kernel: [ 1201.903386] Oops: 0000 [#1] PREEMPT =
SMP
May =A06 22:11:18 aopen kernel: [ 1201.903394] last sysfs file:
/sys/module/crc32c/initstate
May =A06 22:11:18 aopen kernel: [ 1201.903401] Modules linked in:
iscsi_trgt btrfs zlib_deflate crc32c libcrc32c bluetooth rfkill jfs
ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit snd_pcm_oss
snd_mixer_oss snd_seq_midi snd_seq_midi_event snd_seq edd af_packet
microcode ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK
ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle
nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
ip_tables ip6table_filter ip6_tables x_tables fuse loop raid10 dm_mod
snd_intel8x0 snd_ac97_codec snd_mpu401 ac97_bus snd_mpu401_uart
snd_rawmidi snd_pcm ppdev ohci1394 snd_timer iTCO_wdt
iTCO_vendor_support ns558 snd_seq_device sr_mod pcspkr parport_pc
snd_page_alloc e1000 i2c_i801 ieee1394 cdrom gameport sg snd soundcore
parport button shpchp intel_agp pci_hotplug fan thermal processor
thermal_sys ata_generic sata_sil [last unloaded: crc32c]
May =A06 22:11:18 aopen kernel: [ 1201.903541]
May =A06 22:11:18 aopen kernel: [ 1201.903547] Pid: 6304, comm: istiod1
Not tainted 2.6.34-rc5-6-desktop #1 AX4SG Max II/
May =A06 22:11:18 aopen kernel: [ 1201.903555] EIP: 0060:[<00000000>]
EFLAGS: 00010287 CPU: 0
May =A06 22:11:18 aopen kernel: [ 1201.903564] EIP is at 0x0
May =A06 22:11:18 aopen kernel: [ 1201.903569] EAX: f26a5e50 EBX:
f84622e0 ECX: 00000001 EDX: f26a5ec0
May =A06 22:11:18 aopen kernel: [ 1201.903575] ESI: f424ad00 EDI:
f26a5e50 EBP: f26a5ec0 ESP: f26a5e44
May =A06 22:11:18 aopen kernel: [ 1201.903581] =A0DS: 007b ES: 007b FS:
00d8 GS: 0000 SS: 0068
May =A06 22:11:18 aopen kernel: [ 1201.903589] Process istiod1 (pid:
6304, ti=3Df26a4000 task=3Df40de130 task.ti=3Df26a4000)
May =A06 22:11:18 aopen kernel: [ 1201.903596] Stack:
May =A06 22:11:18 aopen kernel: [ 1201.903600] =A0c02fcd05 017a9e00
00000001 017aa000 0000000f 00000000 00000001 ffffffff
May =A06 22:11:18 aopen kernel: [ 1201.903614] <0> f424ad00 00000000
00000000 00000000 00000000 f40de130 00000000 00000000
May =A06 22:11:18 aopen kernel: [ 1201.903629] <0> 017a9e00 00000001
00000117 5cf0894f 00000200 5cf0894f 00000200 5ca4ca59
May =A06 22:11:18 aopen kernel: [ 1201.903647] Call Trace:
May =A06 22:11:18 aopen kernel: [ 1201.903651] Inexact backtrace:
May =A06 22:11:18 aopen kernel: [ 1201.903652]
May =A06 22:11:18 aopen kernel: [ 1201.903664] =A0[<c02fcd05>] ?
do_sync_write+0xb5/0xf0
May =A06 22:11:18 aopen kernel: [ 1201.903675] =A0[<c023b688>] ?
dequeue_entity+0x38/0x1f0
May =A06 22:11:18 aopen kernel: [ 1201.903687] =A0[<f80dd71e>] ?
fileio_make_request+0x11e/0x200 [iscsi_trgt]
May =A06 22:11:18 aopen kernel: [ 1201.903699] =A0[<f80dd600>] ?
fileio_make_request+0x0/0x200 [iscsi_trgt]
May =A06 22:11:18 aopen kernel: [ 1201.903708] =A0[<f80d5278>] ?
tio_write+0x18/0x50 [iscsi_trgt]
May =A06 22:11:18 aopen kernel: [ 1201.903719] =A0[<f80e0857>] ?
ua_pending+0x47/0xc0 [iscsi_trgt]
May =A06 22:11:18 aopen kernel: [ 1201.903730] =A0[<f80de4e2>] ?
build_write_response+0x32/0xd0 [iscsi_trgt]
May =A06 22:11:18 aopen kernel: [ 1201.903740] =A0[<f80d694e>] ?
send_scsi_rsp+0xe/0x60 [iscsi_trgt]
May =A06 22:11:18 aopen kernel: [ 1201.903750] =A0[<f80de3af>] ?
disk_execute_cmnd+0x22f/0x240 [iscsi_trgt]
May =A06 22:11:18 aopen kernel: [ 1201.903761] =A0[<f80da459>] ?
worker_thread+0xb9/0x1b0 [iscsi_trgt]
May =A06 22:11:18 aopen kernel: [ 1201.903769] =A0[<c0239bd0>] ?
default_wake_function+0x0/0x10
May =A06 22:11:18 aopen kernel: [ 1201.903778] =A0[<f80da3a0>] ?
worker_thread+0x0/0x1b0 [iscsi_trgt]
May =A06 22:11:18 aopen kernel: [ 1201.903787] =A0[<c025faa4>] ? kthrea=
d+0x74/0x80
May =A06 22:11:18 aopen kernel: [ 1201.903793] =A0[<c025fa30>] ? kthrea=
d+0x0/0x80
May =A06 22:11:18 aopen kernel: [ 1201.903801] =A0[<c0203466>] ?
kernel_thread_helper+0x6/0x10
May =A06 22:11:18 aopen kernel: [ 1201.903806] Code: =A0Bad EIP value.
May =A06 22:11:18 aopen kernel: [ 1201.903815] EIP: [<00000000>] 0x0
SS:ESP 0068:f26a5e44
May =A06 22:11:18 aopen kernel: [ 1201.903827] CR2: 0000000000000000
May =A06 22:11:18 aopen kernel: [ 1201.903833] ---[ end trace
ffc4d779884d0c3f ]---
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D

This happens half way into iscsi booting the OS (windows xp).
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
