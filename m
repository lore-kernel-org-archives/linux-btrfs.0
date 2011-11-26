From: "Roland Kletzing" <devzero@web.de>
Subject: Oops when moving data to subvolume
Date: Sat, 26 Nov 2011 18:16:20 +0100 (CET)
Message-ID: <123314450.29561.1322327780160.JavaMail.fmail@mwmweb019>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
i was fiddling around with btrfs yesterday to implement backup with
readonly snapshots, but i got the kernel-oops below.

I`m using zlib compression with btrfs and rsync`ed a whole linux system
(~2GB) into /backup/servername-subdir

=46or better snapshot handling i decided to create a dedicated subdir
for each server to be backed up, so i renamed that dir to
/backup/servername-subdir-tmp, created /backup/servername-subvol
and tried moving the data from the subdir to the subvol.

After half of the data being transferred, i hit the oops.

The system is an older, via ezra based mini-pc with 512MB RAM , debian
6.0.3 and the kernel from the testing repo. The btrfs tools are the lat=
est
version from git.

uname -a:
Linux dingbackup 3.1.0-1-486 #1 Mon Nov 14 07:36:41 UTC 2011 i686 GNU/L=
inux

The system is slow, but it should be a tiny backup box for another,
similar machine, so the backup-runtime does not matter and i favour
diskspace over speed.

I`m actually trying to reproduce the issue on another system, but did
not yet succeed, so i`m not perfectly sure if this is not related to ha=
rdware
issue. But the system was stable so far and i did a very in depth-test =
of
the harddisk before re-install and formatting with btrfs -=C2=A0 includ=
ing md5
checksumming and had no defects before and did not see any block-level
errors before the oops.

regards
Roland


[ 3246.471638] ------------[ cut here ]------------
[ 3246.471729] kernel BUG at /build/buildd-linux-2.6_3.1.1-1-i386-6vi5g=
Y/linux-2.6-3.1.1/debian/build/source_i386_none/fs/btrfs/transaction.c:=
1244!
[ 3246.471824] invalid opcode: 0000 [#1]
[ 3246.471911] Modules linked in: loop snd_via82xx gameport snd_ac97_co=
dec ac97_bus snd_mpu401_uart via686a snd_rawmidi tpm_tis tpm tpm_bios e=
vdev snd_seq_device snd_pcm snd_timer i2c_viapro processor parport_pc s=
nd_page_alloc snd i2c_core thermal_sys soundcore button parport pcspkr =
shpchp pci_hotplug ext3 jbd mbcache btrfs zlib_deflate crc32c libcrc32c=
 sd_mod crc_t10dif ata_generic pata_via libata uhci_hcd scsi_mod ehci_h=
cd usbcore 8139too 8139cp mii [last unloaded: scsi_wait_scan]
[ 3246.472017]
[ 3246.472017] Pid: 517, comm: btrfs-transacti Not tainted 3.1.0-1-486 =
#1 VIA Technologies, Inc. VT8605/8605-686
[ 3246.472017] EIP: 0060:[<e019acad>] EFLAGS: 00010282 CPU: 0
[ 3246.472017] EIP is at btrfs_commit_transaction+0x188/0x5c5 [btrfs]
[ 3246.472017] EAX: fffffffe EBX: 00000000 ECX: fffffffe EDX: 00000022
[ 3246.472017] ESI: d4b158b8 EDI: dc595c00 EBP: ddf043f8 ESP: ddb61f4c
[ 3246.472017]=C2=A0 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 3246.472017] Process btrfs-transacti (pid: 517, ti=3Dddb60000 task=3D=
dc4ee810 task.ti=3Dddb60000)
[ 3246.472017] Stack:
[ 3246.472017]=C2=A0 00000246 d4b15904 00000000 00000000 00070194 00000=
000 dc4ee810 c1035f22
[ 3246.472017]=C2=A0 ddb61f6c ddb61f6c 00000000 00000000 dc595d10 dc595=
c00 dc4ee810 dc595c00
[ 3246.472017]=C2=A0 dc4ee810 0000036c 00000000 e0196516 dc4ee810 00000=
282 dc7cddb4 e0196419
[ 3246.472017] Call Trace:
[ 3246.472017]=C2=A0 [<c1035f22>] ? finish_wait+0x3e/0x3e
[ 3246.472017]=C2=A0 [<e0196516>] ? transaction_kthread+0xfd/0x189 [btr=
fs]
[ 3246.472017]=C2=A0 [<e0196419>] ? btrfs_congested_fn+0x5f/0x5f [btrfs=
]
[ 3246.472017]=C2=A0 [<c101bc7d>] ? complete+0x23/0x2b
[ 3246.472017]=C2=A0 [<e0196419>] ? btrfs_congested_fn+0x5f/0x5f [btrfs=
]
[ 3246.472017]=C2=A0 [<c1035a4a>] ? kthread+0x62/0x67
[ 3246.472017]=C2=A0 [<c10359e8>] ? flush_kthread_worker+0x73/0x73
[ 3246.472017]=C2=A0 [<c1275306>] ? kernel_thread_helper+0x6/0xd
[ 3246.472017] Code: 00 00 00 89 f8 e8 ad ae 00 00 31 d2 b9 01 00 00 00=
 89 f8 e8 c5 3d 01 00 85 c0 74 02 0f 0b 89 fa 89 e8 e8 38 3d 03 00 85 c=
0 74 02 <0f> 0b ba 01 00 00 00 89 f8 e8 4e 41 01 00 b9 02 00 00 00 8b 4=
4
[ 3246.472017] EIP: [<e019acad>] btrfs_commit_transaction+0x188/0x5c5 [=
btrfs] SS:ESP 0068:ddb61f4c
[ 3246.479172] ---[ end trace 489019f343161a4d ]---




___________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=3D021192
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
