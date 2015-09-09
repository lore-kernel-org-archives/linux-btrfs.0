Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:32848 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbbIIPax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 11:30:53 -0400
Received: by qkdw123 with SMTP id w123so5999631qkd.0
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2015 08:30:53 -0700 (PDT)
MIME-Version: 1.0
From: Jon Keane <jkeane@gmail.com>
Date: Wed, 9 Sep 2015 10:30:33 -0500
Message-ID: <CAE+qdJbDCaBpiw2JQdOVPk0qmR4NE3NZV+mF8-cXk2y697a3Hg@mail.gmail.com>
Subject: Unmountable btrfs after power failure
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I recently had a power failure, and ever since I have been unable to
mount one of my btrfs drives (data is the one that is failing to
mount, store is fine). I’m running:

jkeane@bet:~$  uname -a

Linux bet 3.8.0-33-generic #48-Ubuntu SMP Wed Oct 23 09:16:58 UTC 2013
x86_64 x86_64 x86_64 GNU/Linux

jkeane@bet:~$   btrfs --version

Btrfs v3.12

jkeane@bet:~$ sudo btrfs fi show -d

Label: 'store'  uuid: 91f14b43-16d6-4411-9f0c-48b7959c6e48

Total devices 2 FS bytes used 684.82GiB

devid    1 size 1.82TiB used 688.03GiB path /dev/sdd

devid    2 size 1.82TiB used 688.01GiB path /dev/sde


Label: 'data'  uuid: f526f5d4-591a-4983-90e8-57ec5d991951

Total devices 2 FS bytes used 1.72TiB

devid    1 size 3.64TiB used 1.73TiB path /dev/sdb

devid    2 size 3.64TiB used 1.73TiB path /dev/sdc


Btrfs v3.12


When I try and mount the drive, I get the following errors:


Sep  9 10:11:38 bet kernel: [ 1487.751656] device label data devid 1
transid 42367 /dev/sdb

Sep  9 10:11:38 bet kernel: [ 1487.776604] btrfs: enabling auto recovery

Sep  9 10:11:38 bet kernel: [ 1487.776618] btrfs: disabling disk space caching

Sep  9 10:11:38 bet sec[1462]: Feeding event 'Wed Sep  9 10:11:38
2015: Sep  9 10:11:38 bet kernel: [ 1487.776604] btrfs: enabling auto
recovery' to shell command '/usr/bin/mail -s "sec: Btrfs unexpected
log" root'

Sep  9 10:11:38 bet sec[1462]: Child 5492 created for command
'/usr/bin/mail -s "sec: Btrfs unexpected log" root'

Sep  9 10:11:38 bet postfix/pickup[2127]: F36183606EF: uid=0 from=<root@bet>

Sep  9 10:11:39 bet postfix/cleanup[5498]: F36183606EF:
message-id=<20150909151138.F36183606EF@bet.localdomain>

Sep  9 10:11:39 bet postfix/qmgr[2128]: F36183606EF:
from=<root@bet.localdomain>, size=455, nrcpt=1 (queue active)

Sep  9 10:11:39 bet postfix/local[5500]: warning: dict_nis_init: NIS
domain name not set - NIS lookups disabled

Sep  9 10:11:39 bet postfix/local[5500]: F36183606EF:
to=<root@bet.localdomain>, orig_to=<root@bet>, relay=local,
delay=0.06, delays=0.03/0.02/0/0, dsn=2.0.0, status=sent (delivered to
mailbox)

Sep  9 10:11:39 bet postfix/qmgr[2128]: F36183606EF: removed

Sep  9 10:12:06 bet kernel: [ 1515.313696] ------------[ cut here ]------------

Sep  9 10:12:06 bet kernel: [ 1515.313708] Kernel BUG at
ffffffffa01472c7 [verbose debug info unavailable]

Sep  9 10:12:06 bet kernel: [ 1515.313714] invalid opcode: 0000 [#1] SMP

Sep  9 10:12:06 bet kernel: [ 1515.313721] Modules linked in: rfcomm
bnep binfmt_misc(F) snd_hda_codec_hdmi hid_generic kvm_amd(F) kvm(F)
microcode(F) serio_raw(F) k10temp edac_core edac_mce_amd usbhid hid
sp5100_tco i2c_piix4 snd_hda_codec_via btusb snd_hda_intel
snd_hda_codec bluetooth snd_hwdep(F) snd_pcm(F) snd_page_alloc(F)
snd_seq_midi(F) snd_seq_midi_event(F) snd_rawmidi(F) snd_seq(F)
snd_seq_device(F) snd_timer(F) snd(F) nvidia(POF) drm soundcore(F)
asus_atk0110 wmi mac_hid parport_pc(F) ppdev(F) shpchp lp(F)
parport(F) btrfs(F) zlib_deflate(F) libcrc32c(F) raid10(F) raid456(F)
async_raid6_recov(F) async_memcpy(F) async_pq(F) async_xor(F) xor(F)
async_tx(F) pata_acpi psmouse(F) pata_atiixp r8169 raid6_pq(F)
raid1(F) raid0(F) ahci(F) libahci(F) multipath(F) linear(F)

Sep  9 10:12:06 bet kernel: [ 1515.313808] CPU 1

Sep  9 10:12:06 bet kernel: [ 1515.313818] Pid: 5477, comm: mount
Tainted: PF          O 3.8.0-33-generic #48-Ubuntu System manufacturer
System Product Name/M4A77TD

Sep  9 10:12:06 bet kernel: [ 1515.313824] RIP:
0010:[<ffffffffa01472c7>]  [<ffffffffa01472c7>]
remove_from_bitmap+0x1b7/0x1c0 [btrfs]

Sep  9 10:12:06 bet kernel: [ 1515.313873] RSP: 0018:ffff88011b6df7a8
EFLAGS: 00010287

Sep  9 10:12:06 bet kernel: [ 1515.313878] RAX: 000001a061e3a000 RBX:
ffff880111d5fdc0 RCX: ffff880106c352e4

Sep  9 10:12:06 bet kernel: [ 1515.313883] RDX: 000000000000a000 RSI:
0000000000008000 RDI: 0000000000003dc0

Sep  9 10:12:06 bet kernel: [ 1515.313887] RBP: ffff88011b6df7f0 R08:
ffff8801190ad850 R09: 0000000000004240

Sep  9 10:12:06 bet kernel: [ 1515.313892] R10: ffffea0004c5d2c0 R11:
ffffffffa00f3044 R12: ffff880106c352c0

Sep  9 10:12:06 bet kernel: [ 1515.313896] R13: ffff88011b6df810 R14:
ffff88011b6df808 R15: 000001a065c00000

Sep  9 10:12:06 bet kernel: [ 1515.313902] FS:  00007f2bad846880(0000)
GS:ffff880137c40000(0000) knlGS:00000000f73a8700

Sep  9 10:12:06 bet kernel: [ 1515.313907] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b

Sep  9 10:12:06 bet kernel: [ 1515.313911] CR2: 00007f2ca5144000 CR3:
0000000119699000 CR4: 00000000000007e0

Sep  9 10:12:06 bet kernel: [ 1515.313916] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000

Sep  9 10:12:06 bet kernel: [ 1515.313921] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400

Sep  9 10:12:06 bet kernel: [ 1515.313926] Process mount (pid: 5477,
threadinfo ffff88011b6de000, task ffff88012dab45c0)

Sep  9 10:12:06 bet kernel: [ 1515.313929] Stack:

Sep  9 10:12:06 bet kernel: [ 1515.313933]  0000000000000000
ffff880106c352e4 000001a061e3c000 000000000000a000

Sep  9 10:12:06 bet kernel: [ 1515.313942]  ffff880106c352c0
ffff880106c352e4 0000000000000001 ffff880121da6200

Sep  9 10:12:06 bet kernel: [ 1515.313949]  ffff8801090a8000
ffff88011b6df840 ffffffffa0148c03 ffffffff8107df00

Sep  9 10:12:06 bet kernel: [ 1515.313957] Call Trace:

Sep  9 10:12:06 bet kernel: [ 1515.314000]  [<ffffffffa0148c03>]
btrfs_remove_free_space+0x53/0x280 [btrfs]

Sep  9 10:12:06 bet kernel: [ 1515.314010]  [<ffffffff8107df00>] ?
finish_wait+0x80/0x80

Sep  9 10:12:06 bet kernel: [ 1515.314043]  [<ffffffffa00faff7>]
btrfs_alloc_logged_file_extent+0x1b7/0x1d0 [btrfs]

Sep  9 10:12:06 bet kernel: [ 1515.314082]  [<ffffffffa01431a7>]
replay_one_extent+0x657/0x6c0 [btrfs]

Sep  9 10:12:06 bet kernel: [ 1515.314122]  [<ffffffffa0143efb>]
replay_one_buffer+0x2ab/0x350 [btrfs]

Sep  9 10:12:06 bet kernel: [ 1515.314161]  [<ffffffffa0129ff7>] ?
alloc_extent_buffer+0x97/0x400 [btrfs]

Sep  9 10:12:06 bet kernel: [ 1515.314200]  [<ffffffffa0124d8c>] ?
check_buffer_tree_ref+0x3c/0x50 [btrfs]

Sep  9 10:12:06 bet kernel: [ 1515.314239]  [<ffffffffa013f962>]
walk_down_log_tree+0x212/0x400 [btrfs]

Sep  9 10:12:06 bet kernel: [ 1515.314277]  [<ffffffffa013fbed>]
walk_log_tree+0x9d/0x1f0 [btrfs]

Sep  9 10:12:06 bet kernel: [ 1515.314313]  [<ffffffffa0108093>] ?
btrfs_read_fs_root_no_name+0x1d3/0x310 [btrfs]

Sep  9 10:12:06 bet kernel: [ 1515.314352]  [<ffffffffa0145d85>]
btrfs_recover_log_trees+0x215/0x390 [btrfs]

Sep  9 10:12:06 bet kernel: [ 1515.314391]  [<ffffffffa0143c50>] ?
fixup_inode_link_counts+0x150/0x150 [btrfs]

Sep  9 10:12:06 bet kernel: [ 1515.314427]  [<ffffffffa010aadc>]
open_ctree+0x171c/0x1da0 [btrfs]

Sep  9 10:12:06 bet kernel: [ 1515.314438]  [<ffffffff8133275a>] ?
disk_name+0xba/0xc0

Sep  9 10:12:06 bet kernel: [ 1515.314465]  [<ffffffffa00e3a83>]
btrfs_mount+0x613/0x750 [btrfs]

Sep  9 10:12:06 bet kernel: [ 1515.314476]  [<ffffffff81173e68>] ?
alloc_pages_current+0xb8/0x180

Sep  9 10:12:06 bet kernel: [ 1515.314488]  [<ffffffff811985e3>]
mount_fs+0x43/0x1b0

Sep  9 10:12:06 bet kernel: [ 1515.314498]  [<ffffffff811b2fb4>]
vfs_kern_mount+0x74/0x110

Sep  9 10:12:06 bet kernel: [ 1515.314506]  [<ffffffff811b5501>]
do_mount+0x211/0xa40

Sep  9 10:12:06 bet kernel: [ 1515.314516]  [<ffffffff811b5dbe>]
sys_mount+0x8e/0xe0

Sep  9 10:12:06 bet kernel: [ 1515.314525]  [<ffffffff816d5f5d>]
system_call_fastpath+0x1a/0x1f

Sep  9 10:12:06 bet kernel: [ 1515.314528] Code: 0f 1f 40 00 31 c0 48
83 7b 20 00 75 e4 48 89 de 4c 89 e7 89 45 b8 e8 39 fb ff ff 8b 45 b8
eb d1 0f 1f 40 00 b8 ea ff ff ff eb c6 <0f> 0b 0f 1f 80 00 00 00 00 66
66 66 66 90 55 48 89 e5 41 57 41

Sep  9 10:12:06 bet kernel: [ 1515.314599] RIP  [<ffffffffa01472c7>]
remove_from_bitmap+0x1b7/0x1c0 [btrfs]

Sep  9 10:12:06 bet kernel: [ 1515.314635]  RSP <ffff88011b6df7a8>

Sep  9 10:12:06 bet kernel: [ 1515.314641] ---[ end trace 4e44f84737630072 ]---


Many of these look similar to the ones described at
https://btrfs.wiki.kernel.org/index.php/Btrfs-zero-log I have not yet
tried zeroing the log, because I’m not seeing all of the messages that
are specific on the FAQ. I suspect that is what I need to do, but I
wanted to check here first.


Please let me know if there is any more information I can provide to
help track this down. Thanks!

-Jon
