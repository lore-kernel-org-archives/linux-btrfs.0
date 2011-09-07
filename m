From: =?ISO-8859-1?Q?Bj=F6rn_Kalkbrenner?= <terminar@cyberphoria.org>
Subject: Re: Problems with set-default, home subvolume and snapshot
Date: Wed, 07 Sep 2011 08:47:43 +0200
Message-ID: <4E67138F.9010706@cyberphoria.org>
References: <4E64A0C5.2060409@cyberphoria.org> <20110905103033.GL9907@carfax.org.uk> <4E64BE74.7040000@cyberphoria.org> <20110905124544.GN9907@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080809030600070507010605"
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110905124544.GN9907@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080809030600070507010605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi,

Am 05.09.2011 14:45, schrieb Hugo Mills:

>    It'd be good if you have the time to try to reproduce this,
> particularly with the latest kernels (3.0 or 3.1-rcX)

My recovery is done. Here are some infos...

-
Linux-3.0.0-gentoo-x86_64-Intel-R-_Core-TM-_i7_CPU_965_@_3.20GHz-with-gentoo-2.0.3
- Btrfs v0.19-35-g1b444cd-dirty

First, i did a mount, then i got the btrfs-bug kernel msg (see
attachment). When i tried to mount a second time, mount hung, maybe due
to the first btrfs bug kernel message stuff.

The btrfsck.txt is the output of the btrfsck i tried, i know that
doesn't fix anything yet.

Bye
Björn

--------------080809030600070507010605
Content-Type: text/plain;
 name="btrfs-bug.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="btrfs-bug.txt"

device fsid b8ff0678-6466-4b4c-ab32-31108423ecfb devid 1 transid 32199 /d=
ev/mapper/sdh2
------------[ cut here ]------------
kernel BUG at fs/btrfs/inode.c:4586!
invalid opcode: 0000 [#1] SMP=20
CPU 6=20
Modules linked in: hidp usbip_host(C) usbip_core(C) nfsd ipv6 bnep rfcomm=
 hid_magicmouse cpufreq_ondemand acpi_cpufreq freq_table mperf tun vboxne=
tflt vboxdrv nvidia(P) snd_hda_codec_realtek snd_hda_intel btusb snd_hda_=
codec joydev bluetooth rfkill snd_hwdep snd_pcm snd_timer snd snd_page_al=
loc processor i2c_i801 e1000e i2c_core thermal_sys button pcspkr iscsi_tc=
p libiscsi_tcp libiscsi scsi_transport_iscsi tg3 libphy e1000 fuse nfs lo=
ckd sunrpc raid10 raid456 async_raid6_recov async_memcpy async_pq async_x=
or xor async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_re=
gion_hash dm_log dm_mod scsi_wait_scan hid_sunplus hid_sony hid_samsung h=
id_pl hid_petalynx hid_monterey hid_microsoft hid_logitech hid_gyration h=
id_ezkey hid_cypress hid_chicony hid_cherry hid_belkin hid_apple hid_a4te=
ch sl811_hcd usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hcd usbcore lp=
fc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid sx8 DAC960 cci=
ss mptsas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870=
u dc395x qla1280 imm parport dmx3191d sym53c8xx gdth advansys initio BusL=
ogic arcmsr sg pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_=
qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_=
sil24 sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_vi=
a pata_jmicron pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202=
xx_old pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 p=
ata_pcmcia pcmcia pcmcia_core pata_ns87415 pata_ns87410 pata_serverworks =
pata_platform pata_artop pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x=
3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 pata_sil680 p=
ata_radisys pata_pdc2027x pata_mpiix libata

Pid: 23202, comm: mount Tainted: P         C  3.0.0-gentoo #1            =
      /DX58SO
RIP: 0010:[<ffffffff812f313e>]  [<ffffffff812f313e>] 0xffffffff812f313e
RSP: 0018:ffff8802ea5397c8  EFLAGS: 00010282
RAX: 00000000ffffffef RBX: ffff8802a9830a88 RCX: ffff880322236dd8
RDX: 000000000000000c RSI: ffff88013874b760 RDI: ffff880320c1c500
RBP: ffff8802ea539838 R08: ffff8802a9830a88 R09: ffff8800cecc7000
R10: ffff8802ea539600 R11: ffff8802ea5396a8 R12: ffff8802a9830678
R13: ffff8800cecc7000 R14: 000000000000000f R15: ffff88022666c700
FS:  00007f3dbf849740(0000) GS:ffff88032fcc0000(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f3dbf1b0600 CR3: 00000002ea73a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 23202, threadinfo ffff8802ea538000, task ffff88032e0b=
2c70)
Stack:
 ffff880200000001 00000000000058c9 ffff8802ea5397f8 ffff8802a982a540
 00000000000751d8 0000000000000001 0000000000001000 0000000000000000
 ffff880281e52000 ffff8802a9830678 ffff88013874b7f0 ffff8802ea539988
Call Trace:
 [<ffffffff81316e02>] 0xffffffff81316e02
 [<ffffffff813178dc>] 0xffffffff813178dc
 [<ffffffff81315242>] 0xffffffff81315242
 [<ffffffff813154e4>] 0xffffffff813154e4
 [<ffffffff81316660>] 0xffffffff81316660
 [<ffffffff8131769e>] ? 0xffffffff8131769e
 [<ffffffff812e951a>] 0xffffffff812e951a
 [<ffffffff812cbfc2>] 0xffffffff812cbfc2
 [<ffffffff810a1a1b>] ? 0xffffffff810a1a1b
 [<ffffffff8139e57c>] ? 0xffffffff8139e57c
 [<ffffffff810b9c02>] 0xffffffff810b9c02
 [<ffffffff810d0cf4>] 0xffffffff810d0cf4
 [<ffffffff810d0d8a>] 0xffffffff810d0d8a
 [<ffffffff810d14e2>] 0xffffffff810d14e2
 [<ffffffff8109e193>] ? 0xffffffff8109e193
 [<ffffffff8109e1eb>] ? 0xffffffff8109e1eb
 [<ffffffff810d15c9>] 0xffffffff810d15c9
 [<ffffffff8158697b>] 0xffffffff8158697b
Code: 41 8b 04 24 44 89 f1 66 c1 e8 0c 4c 89 fa 0f b7 c0 4c 89 ee 0f b6 8=
0 f0 fa 5b 81 48 8b 7d a8 89 04 24 e8 a1 e8 fe ff 85 c0 74 04 <0f> 0b eb =
fe 45 01 f6 4d 63 f6 4c 03 b3 d8 00 00 00 4c 89 b3 d8=20
RIP  [<ffffffff812f313e>] 0xffffffff812f313e
 RSP <ffff8802ea5397c8>
---[ end trace 8fa5393ebe82965d ]---

--------------080809030600070507010605
Content-Type: text/plain;
 name="btrfsck.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="btrfsck.txt"

btrfsck /dev/mapper/sdh2 
root 256 inode 433544 errors 400
root 256 inode 433651 errors 400
root 256 inode 433652 errors 400
root 256 inode 433653 errors 400
root 256 inode 433657 errors 400
root 256 inode 433658 errors 400
root 256 inode 433659 errors 400
root 256 inode 433660 errors 400
root 256 inode 433661 errors 400
root 256 inode 433662 errors 400
root 256 inode 433663 errors 400
root 256 inode 433664 errors 400
root 256 inode 433665 errors 400
root 256 inode 433666 errors 400
root 256 inode 433667 errors 400
root 256 inode 433668 errors 400
root 256 inode 433669 errors 400
root 256 inode 433670 errors 400
root 256 inode 433671 errors 400
root 256 inode 433672 errors 400
root 256 inode 433673 errors 400
root 256 inode 433674 errors 400
root 256 inode 433675 errors 400
root 256 inode 433676 errors 400
root 256 inode 433677 errors 400
root 256 inode 433678 errors 400
root 256 inode 433679 errors 400
root 256 inode 433680 errors 400
root 256 inode 433681 errors 400
root 256 inode 433682 errors 400
root 256 inode 433683 errors 400
root 256 inode 433684 errors 400
root 256 inode 433685 errors 400
root 256 inode 433686 errors 400
root 256 inode 433687 errors 400
root 256 inode 433688 errors 400
root 256 inode 433689 errors 400
root 256 inode 433690 errors 400
root 256 inode 433789 errors 400
root 256 inode 479558 errors 400
found 434559426560 bytes used err is 1
total csum bytes: 421578512
total tree bytes: 2862436352
total fs tree bytes: 2200010752
btree space waste bytes: 725511512
file data blocks allocated: 5089338077184
 referenced 428338118656
Btrfs v0.19-35-g1b444cd-dirty


--------------080809030600070507010605--
