Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53777 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbaGAQSX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 12:18:23 -0400
Received: by mail-we0-f174.google.com with SMTP id u57so10121869wes.33
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Jul 2014 09:18:21 -0700 (PDT)
Received: from [10.0.102.2] (pd907f7af.dip0.t-ipconnect.de. [217.7.247.175])
        by mx.google.com with ESMTPSA id 19sm49082715wjz.3.2014.07.01.09.18.19
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 01 Jul 2014 09:18:20 -0700 (PDT)
Message-ID: <53B2DF4B.4080708@fos4x.de>
Date: Tue, 01 Jul 2014 18:18:19 +0200
From: =?UTF-8?B?UGhpbGlwcCBUw7Zsa2U=?= <philipp.toelke@fos4x.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Corrupt filesystem after hardware failure: Scrub causes kernel GPF
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

Since a hiccup with our raid-system last week we are seeing "strange"
behaviour of our btrfs:

#v+
root@filer:~# btrfs --version
Btrfs v3.14.1
root@filer:~# btrfs fi show
Label: none  uuid: 2cf34cce-d569-4f79-ab92-267f72c615c4
        Total devices 1 FS bytes used 9.34TiB
        devid    2 size 24.56TiB used 9.62TiB path /dev/xvdb

Btrfs v3.14.1
root@filer:~# btrfs fi df /home
Data, single: total=9.61TiB, used=9.32TiB
System, single: total=32.00MiB, used=1.04MiB
Metadata, single: total=19.00GiB, used=17.37GiB
unknown, single: total=512.00MiB, used=0.00
root@filer:~# uname -a
Linux filer 3.15-trunk-amd64 #1 SMP Debian 3.15.1-1~exp1 (2014-06-20)
x86_64 GNU/Linux
#v-

There is one directory that cannot be accessed; we moved if from its
original location to remove it from view of our users:

#v+
root@filer:~# stat /home/corrupt
  File: `/home/corrupt'
  Size: 66012           Blocks: 0          IO Block: 4096   directory
Device: 14h/20d Inode: 8132439     Links: 1
Access: (0755/drwxr-xr-x)  Uid: ( 1001/wecuploader)   Gid: (
1001/wecuploader)
Access: 2014-06-25 04:40:17.510363999 +0200
Modify: 2013-08-10 01:59:00.000000000 +0200
Change: 2014-07-01 08:24:27.502363999 +0200
 Birth: -
root@filer:~# ls /home/corrupt
ls: reading directory /home/corrupt: Input/output error
#v-

The 'ls' causes the following errors in the kernel-log:

#v+
Jul  1 17:48:12 filer kernel: [ 6165.560867] BTRFS: bad tree block start
13161821503488 13161810423808
Jul  1 17:48:12 filer kernel: [ 6165.562663] BTRFS: bad tree block start
13161821503488 13161810423808
Jul  1 17:48:12 filer kernel: [ 6165.562974] BTRFS: bad tree block start
13161821503488 13161810423808
#v-

Doing a scrub scrubs over the first TiB of the filesystem and then
caused this OOPS:

#v+
Jul  1 15:19:04 filer kernel: [ 8209.304980] BTRFS: bad tree block start
13161800974336 13161810374656
Jul  1 15:19:06 filer kernel: [ 8211.156463] BTRFS: bad tree block start
13161800974336 13161810374656
Jul  1 15:19:06 filer kernel: [ 8211.156490] general protection fault:
0000 [#1] SMP
Jul  1 15:19:06 filer kernel: [ 8211.156850] Modules linked in: ppdev lp
crc32c_generic xenfs xen_privcmd nfsd auth_rpcgss oid_registry nfs_acl
nfs lockd f scache sunrpc dm_multipath scsi_dh loop intel_rapl
crct10dif_pclmul crct10dif_common crc32_pclmul ghash_clmulni_intel
aesni_intel aes_x86_64 lrw gf128mul g lue_helper ablk_helper cryptd
parport_pc i2c_piix4 evdev psmouse parport pcspkr i2c_core joydev
serio_raw processor thermal_sys button ext4 crc16 mbcache j bd2
hid_generic btrfs usbhid hid xor raid6_pq dm_mod sg sr_mod cdrom
ata_generic xen_netfront xen_blkfront floppy uhci_hcd ehci_hcd
crc32c_intel usbcore us b_common ata_piix libata scsi_mod
Jul  1 15:19:06 filer kernel: [ 8211.160454] CPU: 2 PID: 10852 Comm:
btrfs Not tainted 3.15-trunk-amd64 #1 Debian 3.15.1-1~exp1
Jul  1 15:19:06 filer kernel: [ 8211.160454] Hardware name: Xen HVM
domU, BIOS 4.1.5 11/28/2013
Jul  1 15:19:06 filer kernel: [ 8211.160454] task: ffff8807929093b0 ti:
ffff8800dd01c000 task.ti: ffff8800dd01c000
Jul  1 15:19:06 filer kernel: [ 8211.160454] RIP:
0010:[<ffffffff811683a1>]  [<ffffffff811683a1>] kfree+0xf1/0x200
Jul  1 15:19:06 filer kernel: [ 8211.160454] RSP: 0018:ffff8800dd01f948
EFLAGS: 00010046
Jul  1 15:19:06 filer kernel: [ 8211.160454] RAX: 0000000000000002 RBX:
dead000000100100 RCX: ffff88015d01f9a0
Jul  1 15:19:06 filer kernel: [ 8211.160454] RDX: ffffea00030586c8 RSI:
0000000000000000 RDI: ffff8800dd01f9a0
Jul  1 15:19:06 filer kernel: [ 8211.160454] RBP: ffff8800dd01f9a0 R08:
0000000000000000 R09: 00000bf87fc00000
Jul  1 15:19:06 filer kernel: [ 8211.160454] R10: 000000000000003c R11:
ffff880055f76d14 R12: 0000000000000286
Jul  1 15:19:06 filer kernel: [ 8211.160454] R13: ffff8800dd01f9b0 R14:
ffffea0003058540 R15: 0000070252c29000
Jul  1 15:19:06 filer kernel: [ 8211.160454] FS:  00007ffe3a9c1700(0000)
GS:ffff88080f840000(0000) knlGS:0000000000000000
Jul  1 15:19:06 filer kernel: [ 8211.160454] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
Jul  1 15:19:06 filer kernel: [ 8211.160454] CR2: 00000000013a9440 CR3:
00000000df38e000 CR4: 00000000000006e0
Jul  1 15:19:06 filer kernel: [ 8211.160454] Stack: Jul  1 15:19:06
filer kernel: [ 8211.160454]  ffff880055f76d10 ffff880055f76d10
ffff8807ed801800 0000000000000004
Jul  1 15:19:06 filer kernel: [ 8211.160454]  ffff8800dd01f9b0
00000000fffffffb ffffffffa019c064 0000070252c29000
Jul  1 15:19:06 filer kernel: [ 8211.160454]  ffff880055f76d10
0000000000000140 0000070252c2ffff ffff8807dbb40240
Jul  1 15:19:06 filer kernel: [ 8211.160454] Call Trace:
Jul  1 15:19:06 filer kernel: [ 8211.160454]  [<ffffffffa019c064>] ?
btrfs_lookup_csums_range+0x284/0x470 [btrfs]
Jul  1 15:19:06 filer kernel: [ 8211.160454]  [<ffffffffa01fb3b4>] ?
scrub_stripe+0x874/0x10a0 [btrfs]
Jul  1 15:19:06 filer kernel: [ 8211.160454]  [<ffffffffa01fbcec>] ?
scrub_chunk.isra.13+0x10c/0x130 [btrfs]
Jul  1 15:19:06 filer kernel: [ 8211.160454]  [<ffffffffa01fbf4a>] ?
scrub_enumerate_chunks+0x23a/0x480 [btrfs]
Jul  1 15:19:06 filer kernel: [ 8211.160454]  [<ffffffff8109b000>] ?
prepare_to_wait_event+0x10/0xf0
Jul  1 15:19:06 filer kernel: [ 8211.160454]  [<ffffffffa01fd4a2>] ?
btrfs_scrub_dev+0x1a2/0x530 [btrfs]
Jul  1 15:19:06 filer kernel: [ 8211.160454]  [<ffffffffa01daeb7>] ?
btrfs_ioctl+0x13c7/0x2a50 [btrfs]
Jul  1 15:19:06 filer kernel: [ 8211.160454]  [<ffffffff8114473f>] ?
handle_mm_fault+0x82f/0x11b0
Jul  1 15:19:06 filer kernel: [ 8211.160454]  [<ffffffff81167c62>] ?
kmem_cache_alloc_node+0x482/0x4a0
Jul  1 15:19:06 filer kernel: [ 8211.160454]  [<ffffffff814c1719>] ?
__do_page_fault+0x1c9/0x4e0
Jul  1 15:19:06 filer kernel: [ 8211.160454]  [<ffffffff81254fa7>] ?
create_task_io_context+0x17/0xf0
Jul  1 15:19:06 filer kernel: [ 8211.160454]  [<ffffffff81192b3f>] ?
do_vfs_ioctl+0x2cf/0x4b0
Jul  1 15:19:06 filer kernel: [ 8211.160454]  [<ffffffff811bb6bc>] ?
set_task_ioprio+0x7c/0x90
Jul  1 15:19:06 filer kernel: [ 8211.160454]  [<ffffffff81192d99>] ?
SyS_ioctl+0x79/0x90
Jul  1 15:19:06 filer kernel: [ 8211.160454]  [<ffffffff814c60f9>] ?
system_call_fastpath+0x16/0x1b
Jul  1 15:19:06 filer kernel: [ 8211.160454] Code: 00 48 c1 e1 06 48 29
c1 48 b8 00 00 00 00 00 ea ff ff 4c 8b 2c 01 65 8b 04 25 a8 00 01 00 49
c1 ed 3a 41 39 c5 0f 85 8f 00 00 00 <8b> 43 04 39 03 73 65 66 66 66 66
90 8b 03 8d 50 01 89 13 48 89
Jul  1 15:19:06 filer kernel: [ 8211.160454] RIP  [<ffffffff811683a1>]
kfree+0xf1/0x200
Jul  1 15:19:06 filer kernel: [ 8211.160454]  RSP <ffff8800dd01f948>
Jul  1 15:19:06 filer kernel: [ 8211.160454] ---[ end trace
7728b9417c5909ae ]---
#v-

After this the filesystem is still readable but not writeable (writes
block indefinitely).

As a complication, we once moved the data of this filesystem from one
disk-array to another by adding both to the filesystem and then deleting
the "old" array; now the size of the filesystem is shown as the maximum
size it ever had (33Ti, where it now is backed by 24Ti of disks):

#v+
root@filer:~# df -h | grep home
/dev/xvdb                     33T  9.4T   16T 39% /home
#v-

Is this normal behaviour?


How can we fix the filesystem so that it does not contain a corrupt
directory that cannot be deleted? How can we fix the scrub-issue?

If you need further details, I am happy to provide them.

Please Cc me on replies as I am currently not subscribed to the
mailing-list.

Thank you!

Regards,
Philipp

-- 
Philipp Tölke, M.Sc. - Software-Developer - fos4X GmbH - www.fos4x.de
Thalkirchner Str. 210, Geb. 6 - D-81371 München; AG München HRB 189 218
T +49 89 999 542 58 - F +49 89 999 542 01
Managing Directors: Dr. Lars Hoffmann, Dr. Mathias Müller
