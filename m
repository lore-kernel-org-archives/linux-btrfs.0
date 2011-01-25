From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: version
Date: 25 Jan 2011 15:37:00 +0100
Message-ID: <BeXoKKFD1uB@helmut.hullen.de>
References: <4D3E012E.4070208@csamuel.org>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D3E012E.4070208@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Chris,

Du meintest am 25.01.11:

>> Regard the difference between "df" and "btrfs filesystem df".

> I suspect this is fixed in 2.6.38 with the following commit.

> BE WARNED: there are some fairly hairy changes to the pathname
> lookup code to replace the BKL with RCU (not specific to btrfs)
> and so if you are tempted to try it (currently 2.6.38-rc2) only
> do so on a system that you don't care about data on and/or have
> very good incremental backups of which you trust...


> commit 6d07bcec969af335d4e35b3921131b7929bd634e
> Author: Miao Xie <miaox@cn.fujitsu.com>
> Date:   Wed Jan 5 10:07:31 2011 +0000

>     btrfs: fix wrong free space information of btrfs

I've tried 2.6.38-rc2 - new problems.

        mkfs.btrfs /dev/sdb
        mount /dev/sdb /mnt/btr
        btrfs device add /dev/sdc

        cp <dir_with_6_GByte> /mnt/btr

leads to

-----------

# btrfs filesystem show
Label: none  uuid: 4a8c2c48-6c0e-4a97-8286-d1f7d930f9a8
	Total devices 2 FS bytes used 6.53GB
	devid    1 size 7.51GB used 805.50MB path /dev/sdb
	devid    2 size 37.27GB used 7.00GB path /dev/sdc

Btrfs Btrfs v0.19

# btrfs filesystem df /mnt/btr
Data: total=3D7.01GB, used=3D6.52GB
System, DUP: total=3D8.00MB, used=3D4.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D384.75MB, used=3D9.84MB
Metadata: total=3D8.00MB, used=3D0.00

# df -t btrfs
Dateisystem   Typ    1K-Bl=F6cke   Benutzt Verf=FCgbar Ben% Eingeh=E4ng=
t auf
/dev/sdb     btrfs    46963224   6861804  39303836  15% /mnt/btr

-----------

And then:

        btrfs filesystem balance /mnt/btr

crashes with the "dmesg" lines

--------------------- dmesg -------------------

bio too big device sdc (256 > 240)
bio too big device sdc (256 > 240)
bio too big device sdc (256 > 240)
bio too big device sdc (256 > 240)
------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:2097!
invalid opcode: 0000 [#1]
last sysfs file: /sys/devices/pci0000:00/0000:00:07.1/host1/target1:0:0=
/1:0:0:0/block/sdb/dev
Modules linked in: sg nf_nat_ftp nf_conntrack_ftp ipt_MASQUERADE iptabl=
e_nat nf_nat xt_DSCP xt_multiport xt_recent nf_conntrack_ipv4 nf_defrag=
_ipv4 xt_state nf_conntrack xt_tcpudp ipt_REJECT iptable_filter iptable=
_mangle ip_tables xt_iprange x_tables nfsd exportfs 8139too 8139cp sava=
gefb fb_ddc i2c_algo_bit vgastate i2c_piix4 piix e100 mii intel_agp int=
el_gtt agpgart cmd64x video thermal_sys ac battery yenta_socket pcmcia_=
rsrc pcmcia pcmcia_core thinkpad_acpi hwmon rfkill nvram fuse

Pid: 16501, comm: btrfs Not tainted 2.6.38-rc2-ODS #1 26478EG/26478EG
EIP: 0060:[<c1235264>] EFLAGS: 00010282 CPU: 0
EIP is at btrfs_balance+0x2d4/0x2e0
EAX: fffffffb EBX: cd570000 ECX: d7cd4090 EDX: 00000000
ESI: d097c070 EDI: cf9f3c00 EBP: d37dde9c ESP: d37dde38
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
Process btrfs (pid: 16501, ti=3Dd37dc000 task=3Dcd5d6f00 task.ti=3Dd37d=
c000)
Stack:
 99cc0000 00000001 000000e4 00100000 00000000 00000100 cd56e000 cf9f67d=
8
 aea58000 00000001 00000000 99cc0000 00000001 0100a3c8 00000000 00e4000=
0
 0199cc00 00000000 00000001 e4000000 ffffffff ffffffff cfa50700 ffffffe=
a
Call Trace:
 [<c123bcf1>] btrfs_ioctl+0x2e1/0x9d0
 [<c123ba10>] ? btrfs_ioctl+0x0/0x9d0
 [<c10c3f65>] do_vfs_ioctl+0x85/0x590
 [<c10206db>] ? do_page_fault+0x17b/0x380
 [<c10b554b>] ? do_sys_open+0xdb/0x110
 [<c10c44f7>] sys_ioctl+0x87/0x90
 [<c1753d0c>] syscall_call+0x7/0xb
Code: 1b ff ff ff 89 f0 e8 cc 75 fb ff 8b 55 b4 8b 82 10 01 00 00 05 74=
 19 00 00 e8 09 dc 51 00 e9 70 fd ff ff 31 db eb dd 85 c0 74 9d <0f> 0b=
 0f 0b 0f 0b 0f 0b 0f 0b 66 90 55 89 e5 56 53 83 ec 34 3e
EIP: [<c1235264>] btrfs_balance+0x2d4/0x2e0 SS:ESP 0068:d37dde38
---[ end trace 8dcdbc0f75858a35 ]---

---------------------------------------


Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
