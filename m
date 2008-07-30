From: Marcel Runte <marcel.runte@web.de>
Subject: Kernel oops after compile error
Date: Thu, 31 Jul 2008 00:44:51 +0200
Message-ID: <1905261913@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I fiddled around with btrfs this evening and need some further insight =
into this error.

During compilation this error occurs:

/home/runtema/btrfs_build/kernel-9da425337329/file.c: In Funktion =BBbt=
rfs_file_write=AB:
/home/runtema/btrfs_build/kernel-9da425337329/file.c:851: Warnung: =DCb=
ergabe des Arguments 1 von =BBremove_suid=AB von inkompatiblem Zeigerty=
p

As you see, I used a newer release from kernel.org to build btrfs. The =
german error message nearly translates into: "Warning: Handover of argu=
ment 1 of =BBremove_suid=AB is of incompatible pointertype."

Rest of compilation is OK. Compilation of brtfs-progs is OK.

After that, a write try on an loop mounted btrfs file(-system) leads to=
 a kernel oops:

#modprobe libcrc32c -> OK
#insmod /lib/modules/2.6.22-15-generic/extra/btrfs.ko -> OK

#diff /home/runtema/btrfs_build/kernel-9da425337329/btrfs.ko /lib/modul=
es/2.6.22-15-generic/extra/btrfs.ko -> $ret =3D 0

$dd if=3D/dev/urandom of=3D/home/runtema/test bs=3D1024 count=3D1000000
$/home/runtema/btrfs_build/kernel-9da425337329/mkfs.btrfs /home/runtema=
/test ->OK
$sudo mkdir /mnt/btrfs-test
$sudo mount -t btrfs -o loop /home/runtema/test /mnt/btrfs-test ->OK!
$sudo touch /mnt/btrfs-test -> still OK!
#date >> /mnt/btrfs-test/otto -> leads to oops:

[ 3977.384000] device fsid da43617984b1c492-9501950cbfd6d589 devid 1 tr=
ansid 22 /dev/loop0
[ 4001.664000] BUG: unable to handle kernel NULL pointer dereference at=
 virtual address 00000014
[ 4001.664000]  printing eip:
[ 4001.664000] c015e4d1
[ 4001.664000] *pde =3D 00000000
[ 4001.664000] Oops: 0000 [#2]
[ 4001.664000] SMP
[ 4001.664000] Modules linked in: btrfs libcrc32c loop xt_TCPMSS xt_tcp=
mss xt_tcpudp iptable_filter ip_tables x_tables pppoe pppox af_packet p=
pp_generic slhc rfcomm l2cap bluetooth vboxdrv ppdev powernow_k8 cpufre=
q_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table=
 cpufreq_conservative video sbs button dock container ac battery ext2 p=
arport_pc lp parport snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm sn=
d_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi fglrx(P) psmouse snd_s=
eq_midi_event agpgart serio_raw k8temp snd_seq snd_timer snd_seq_device=
 snd soundcore i2c_nforce2 pcspkr snd_page_alloc shpchp i2c_core pci_ho=
tplug ipv6 evdev ext3 jbd mbcache sg sr_mod sd_mod cdrom usbhid hid sat=
a_nv floppy ehci_hcd r8169 b44 mii ata_generic libata scsi_mod ohci_hcd=
 usbcore raid10 raid456 xor raid1 raid0 multipath linear md_mod dm_mirr=
or dm_snapshot dm_mod thermal processor fan capability commoncap fuse
[ 4001.664000] CPU:    1
[ 4001.664000] EIP:    0060:[<c015e4d1>]    Tainted: P       VLI
[ 4001.664000] EFLAGS: 00010206   (2.6.22-15-generic #1)
[ 4001.664000] EIP is at should_remove_suid+0x1/0x50
[ 4001.664000] eax: 00000008   ebx: f4d22bb0   ecx: ffffffff   edx: e0a=
ae480
[ 4001.664000] esi: db41e5d0   edi: 0000001e   ebp: 0000001e   esp: dce=
b9eac
[ 4001.664000] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[ 4001.664000] Process date (pid: 13142, ti=3Ddceb8000 task=3Df78d4f90 =
task.ti=3Ddceb8000)
[ 4001.664000] Stack: f4d22bb0 c015e52b db41e650 f9e5f55f 00000000 0000=
00b6 f4cb8000 c018a9c7
[ 4001.664000]        dcf6f244 00000287 dceb9ef0 c01ff210 b7c7c000 e0aa=
e480 dceb9f50 00000000
[ 4001.664000]        00000000 00000812 db41e650 f4228200 0098c01a 0000=
81a4 00000001 00000000
[ 4001.664000] Call Trace:
[ 4001.664000]  [<c015e52b>] remove_suid+0xb/0x20
[ 4001.664000]  [<f9e5f55f>] btrfs_file_write+0x1ef/0x9b0 [btrfs]
[ 4001.664000]  [<c018a9c7>] do_path_lookup+0x97/0x1d0
[ 4001.664000]  [<c01ff210>] copy_to_user+0x30/0x60
[ 4001.664000]  [<c0180d0e>] vfs_write+0xbe/0x170
[ 4001.664000]  [<f9e5f370>] btrfs_file_write+0x0/0x9b0 [btrfs]
[ 4001.664000]  [<c0181421>] sys_write+0x41/0x70
[ 4001.664000]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
[ 4001.664000]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 4001.664000] Code: 8d 76 00 8d bc 27 00 00 00 00 53 80 ce 02 83 ec 34=
 89 c3 89 14 24 8b 13 89 e1 8b 40 04 e8 d8 71 03 00 83 c4 34 5b c3 8d 7=
6 00 53 <8b> 40 0c 0f b7 50 6a 89 d0 25 00 08 00 00 83 f8 01 19 db 81 e=
2
[ 4001.664000] EIP: [<c015e4d1>] should_remove_suid+0x1/0x50 SS:ESP 006=
8:dceb9eac

My System:
cat /etc/lsb-release
DISTRIB_ID=3DUbuntu
DISTRIB_RELEASE=3D7.10
DISTRIB_CODENAME=3Dgutsy
DISTRIB_DESCRIPTION=3D"Ubuntu 7.10"

My Kernel: 2.6.22-15-generic #1 SMP Fri Jul 11 19:25:33 UTC 2008 i686, =
dpgk-list says this is 2.6.22-15.56

make and ggc version used during build process: GNU Make 3.81, gcc (GCC=
) 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)


Am I overlooking something?

Any help appreciated.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
