Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:52583 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3HDW6X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Aug 2013 18:58:23 -0400
Received: by mail-qc0-f175.google.com with SMTP id s11so1342298qcv.34
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Aug 2013 15:58:22 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 5 Aug 2013 00:58:22 +0200
Message-ID: <CAKZ=RP88hT4w5am-nU7ftEQdswxLvkw7dZ7dFasTKjn0vji8hQ@mail.gmail.com>
Subject: Unable to unmount filesystem (bug in kernel reported in kern.log)
From: Alfredo Esteban <aedelatorre@gmail.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I tried to unmount a btrfs filesystem located in a external usb hard
drive. This belonged to a raid1 data and metadata filesystem mounted
in degraded mode.

Unfortunately, I couldn't save the image of filesystem but I could see
this error in kern.log:

Aug  4 02:23:55 rohan kernel: [ 3747.840027] usb 1-3: new high-speed
USB device number 8 using ehci_hcd
Aug  4 02:23:55 rohan kernel: [ 3747.973554] usb-storage 1-3:1.0:
Quirks match for vid 14cd pid 6600: 20
Aug  4 02:23:55 rohan kernel: [ 3747.973584] scsi8 : usb-storage 1-3:1.0
Aug  4 02:23:56 rohan kernel: [ 3748.972895] scsi 8:0:0:0:
Direct-Access     ST316002 1A                    PQ: 0 ANSI: 0
Aug  4 02:23:56 rohan kernel: [ 3748.973642] sd 8:0:0:0: Attached scsi
generic sg9 type 0
Aug  4 02:23:56 rohan kernel: [ 3748.974408] sd 8:0:0:0: [sdi]
312581808 512-byte logical blocks: (160 GB/149 GiB)
Aug  4 02:23:56 rohan kernel: [ 3748.975660] sd 8:0:0:0: [sdi] Write
Protect is off
Aug  4 02:23:56 rohan kernel: [ 3748.975664] sd 8:0:0:0: [sdi] Mode
Sense: 03 00 00 00
Aug  4 02:23:56 rohan kernel: [ 3748.976262] sd 8:0:0:0: [sdi] No
Caching mode page present
Aug  4 02:23:56 rohan kernel: [ 3748.976266] sd 8:0:0:0: [sdi]
Assuming drive cache: write through
Aug  4 02:23:56 rohan kernel: [ 3748.978006] sd 8:0:0:0: [sdi] No
Caching mode page present
Aug  4 02:23:56 rohan kernel: [ 3748.978009] sd 8:0:0:0: [sdi]
Assuming drive cache: write through
Aug  4 02:23:56 rohan kernel: [ 3748.998148]  sdi: sdi1
Aug  4 02:23:56 rohan kernel: [ 3749.000138] sd 8:0:0:0: [sdi] No
Caching mode page present
Aug  4 02:23:56 rohan kernel: [ 3749.000142] sd 8:0:0:0: [sdi]
Assuming drive cache: write through
Aug  4 02:23:56 rohan kernel: [ 3749.000146] sd 8:0:0:0: [sdi]
Attached SCSI disk
Aug  4 02:24:26 rohan kernel: [ 3778.904274] device fsid
ab74ba21-3b11-42f1-b388-f3a7c059e7eb devid 1 transid 9 /dev/sdi1
Aug  4 02:24:26 rohan kernel: [ 3778.924259] btrfs: disk space caching
is enabled
Aug  4 02:25:36 rohan kernel: [ 3849.110130] btrfs: space cache
generation (8) does not match inode (12)
Aug  4 02:25:36 rohan kernel: [ 3849.110138] btrfs: failed to load
free space cache for block group 29360128
Aug  4 02:26:06 rohan kernel: [ 3878.947113] parent transid verify
failed on 30580736 wanted 12 found 8
Aug  4 02:26:06 rohan kernel: [ 3878.947120] parent transid verify
failed on 30580736 wanted 12 found 8
Aug  4 02:26:06 rohan kernel: [ 3878.947124] parent transid verify
failed on 30580736 wanted 12 found 8
Aug  4 02:26:06 rohan kernel: [ 3878.947129] parent transid verify
failed on 30580736 wanted 12 found 8
Aug  4 02:26:06 rohan kernel: [ 3878.947132] parent transid verify
failed on 30580736 wanted 12 found 8
Aug  4 02:26:06 rohan kernel: [ 3878.947156] ------------[ cut here
]------------
Aug  4 02:26:06 rohan kernel: [ 3878.947184] kernel BUG at
/build/buildd/linux-3.2.0/fs/btrfs/inode.c:806!
Aug  4 02:26:06 rohan kernel: [ 3878.947216] invalid opcode: 0000 [#1] SMP
Aug  4 02:26:06 rohan kernel: [ 3878.947238] CPU 1
Aug  4 02:26:06 rohan kernel: [ 3878.947248] Modules linked in: btrfs
zlib_deflate libcrc32c pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O)
vboxdrv(O) xt_recent xt_state xt_tcpudp iptable_nat nf_nat
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables
x_tables rfcomm bnep bluetooth parport_pc ppdev binfmt_misc dm_crypt
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
snd_seq_device snd asus_atk0110 psmouse soundcore snd_page_alloc
serio_raw lp parport mac_hid usbhid hid usb_storage i915 r8169
drm_kms_helper drm i2c_algo_bit video
Aug  4 02:26:06 rohan kernel: [ 3878.947556]
Aug  4 02:26:06 rohan kernel: [ 3878.947566] Pid: 4629, comm:
btrfs-transacti Tainted: G           O 3.2.0-51-generic #77-Ubuntu
System manufacturer System Product Name/P5KPL-AM SE
Aug  4 02:26:06 rohan kernel: [ 3878.947628] RIP:
0010:[<ffffffffa050c538>]  [<ffffffffa050c538>]
cow_file_range+0x388/0x3a0 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.947687] RSP:
0018:ffff880061bfd6a0  EFLAGS: 00010246
Aug  4 02:26:06 rohan kernel: [ 3878.947712] RAX: ffff8800d8ede000
RBX: 0000000000000000 RCX: 000000000000ffff
Aug  4 02:26:06 rohan kernel: [ 3878.947743] RDX: ffff8800d6fcf000
RSI: ffffea00044892c0 RDI: ffff88007aa08910
Aug  4 02:26:06 rohan kernel: [ 3878.947775] RBP: ffff880061bfd760
R08: ffff880061bfd94c R09: ffff880061bfd940
Aug  4 02:26:06 rohan kernel: [ 3878.947807] R10: 0000000000000002
R11: 0000000000000001 R12: ffff88007aa08910
Aug  4 02:26:06 rohan kernel: [ 3878.947839] R13: 0000000000001000
R14: 000000000000ffff R15: ffff88007aa08780
Aug  4 02:26:06 rohan kernel: [ 3878.947871] FS:
0000000000000000(0000) GS:ffff88011fc80000(0000)
knlGS:0000000000000000
Aug  4 02:26:06 rohan kernel: [ 3878.947907] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Aug  4 02:26:06 rohan kernel: [ 3878.947933] CR2: 00007ff051357019
CR3: 00000000d9913000 CR4: 00000000000406e0
Aug  4 02:26:06 rohan kernel: [ 3878.947965] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 02:26:06 rohan kernel: [ 3878.949197] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 02:26:06 rohan kernel: [ 3878.950413] Process btrfs-transacti
(pid: 4629, threadinfo ffff880061bfc000, task ffff8800d10fae00)
Aug  4 02:26:06 rohan kernel: [ 3878.951105] Stack:
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  ffff880061bfd6b0
ffff880075553948 0000000000000286 ffff880061bfd6d0
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  0000000000000286
ffff880075553948 ffff880061bfd710 ffffea00044892c0
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  0080ffffffffffff
ffff8800d6fcf000 ffff88006a53f2d0 ffff880061bfd94c
Aug  4 02:26:06 rohan kernel: [ 3878.951105] Call Trace:
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa0533120>] ?
btrfs_tree_read_unlock_blocking+0x40/0x60 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa050c8e7>]
run_delalloc_nocow+0x397/0x7a0 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa050cd47>]
run_delalloc_range+0x57/0x80 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa052303d>]
__extent_writepage+0x5bd/0x700 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffff8131443d>] ?
radix_tree_gang_lookup_tag_slot+0x8d/0xd0
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa0523442>]
extent_write_cache_pages.isra.21.constprop.31+0x2c2/0x3e0 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa05237a5>]
extent_writepages+0x45/0x60 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa05085d0>] ?
btrfs_read_locked_inode+0x390/0x390 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa051fade>] ?
clear_extent_bit+0x1ce/0x3f0 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa0506ff8>]
btrfs_writepages+0x28/0x30 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffff811245c1>]
do_writepages+0x21/0x40
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffff8111a8bb>]
__filemap_fdatawrite_range+0x5b/0x60
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffff8111b2af>]
filemap_fdatawrite+0x1f/0x30
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffff8111b2f5>]
filemap_write_and_wait+0x35/0x60
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa053ad2f>]
__btrfs_write_out_cache+0x6cf/0x950 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffff816606be>] ?
_raw_spin_lock+0xe/0x20
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa053b069>]
btrfs_write_out_cache+0xb9/0xf0 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa04f4424>]
btrfs_write_dirty_block_groups+0x224/0x280 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa0502b62>]
update_cowonly_root+0x42/0xd0 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa0502cac>]
commit_cowonly_roots+0xbc/0x100 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa050448f>]
btrfs_commit_transaction+0x3bf/0x840 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffff8108c230>] ?
add_wait_queue+0x60/0x60
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa04fd3b5>]
transaction_kthread+0x265/0x280 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffffa04fd150>] ?
btrfs_congested_fn+0xb0/0xb0 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffff8108b78c>]
kthread+0x8c/0xa0
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffff8166ae74>]
kernel_thread_helper+0x4/0x10
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffff8108b700>] ?
flush_kthread_worker+0xa0/0xa0
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  [<ffffffff8166ae70>] ?
gs_change+0x13/0x13
Aug  4 02:26:06 rohan kernel: [ 3878.951105] Code: 10 c7 02 01 00 00
00 e9 4a ff ff ff 48 8b 7d 80 4c 89 e6 4c 89 95 68 ff ff ff e8 d4 6f
00 00 4c 8b 95 68 ff ff ff e9 4c fd ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f
0b 0f 0b 66 66 66 2e 0f 1f 84 00 00
Aug  4 02:26:06 rohan kernel: [ 3878.951105] RIP  [<ffffffffa050c538>]
cow_file_range+0x388/0x3a0 [btrfs]
Aug  4 02:26:06 rohan kernel: [ 3878.951105]  RSP <ffff880061bfd6a0>
Aug  4 02:26:06 rohan kernel: [ 3879.008489] ---[ end trace
6751139acfeba416 ]---
