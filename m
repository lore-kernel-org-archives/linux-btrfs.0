Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx09lb.world4you.com ([81.19.149.119]:40978 "EHLO
        mx09lb.world4you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941092AbcIYIU3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Sep 2016 04:20:29 -0400
Received: from [80.109.206.244] (helo=localhost)
        by mx09lb.world4you.com with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.84_2)
        (envelope-from <jakob@xundeenergie.at>)
        id 1bo42H-0001lz-G7
        for linux-btrfs@vger.kernel.org; Sun, 25 Sep 2016 09:39:41 +0200
Received: from [::1]
        by localhost with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <jakob@xundeenergie.at>)
        id 1bo42H-0001IZ-3N
        for linux-btrfs@vger.kernel.org; Sun, 25 Sep 2016 09:39:41 +0200
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Jakobus_Sch=c3=bcrz?= <jakob@xundeenergie.at>
Subject: Kernel BUG^
Message-ID: <9ad26daf-5545-ec59-5368-b1b11b719f84@localhost>
Date: Sun, 25 Sep 2016 09:39:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there!

I ran into this bug

# uname -a
Linux aldebaran 4.6.0-1-rt-amd64 #1 SMP PREEMPT RT Debian 4.6.4-1 
(2016-07-18) x86_64 GNU/Linux

# dpkg -l|grep btrfs
ii  btrfs-progs 4.7.1-1 amd64 Checksumming Copy on Write Filesystem 
utilities

 From journald:

Sep 25 09:35:12 aldebaran kernel: ------------[ cut here ]------------
Sep 25 09:35:12 aldebaran kernel: kernel BUG at 
/build/linux-aOJbQa/linux-4.6.4/debian/build/source_rt/fs/btrfs/extent-tree.c:1872!
Sep 25 09:35:12 aldebaran kernel: invalid opcode: 0000 [#1] PREEMPT SMP
Sep 25 09:35:12 aldebaran kernel: Modules linked in: fuse(E) hmac(E) 
drbg(E) ansi_cprng(E) ctr(E) ccm(E) xt_multiport(E) rfcomm(E) uas(E) 
usb_storage(E) bnep(E) btusb(E) btrtl(E) btbcm(E) btintel(E)
Sep 25 09:35:12 aldebaran kernel:  tpm(E) hp_wireless(E) ac(E) 
processor(E) snd_hda_intel(E) shpchp(E) snd_hda_codec(E) mei_me(E) 
snd_hda_core(E) mei(E) snd_hwdep(E) snd_pcm(E) snd_timer(E) snd(E) so
Sep 25 09:35:12 aldebaran kernel:  ehci_pci(E) r8169(E) xhci_pci(E) 
mii(E) scsi_mod(E) mfd_core(E) ehci_hcd(E) xhci_hcd(E) drm(E) usbcore(E) 
usb_common(E) thermal(E) wmi(E) video(E) button(E) fjes(E)
Sep 25 09:35:12 aldebaran kernel: CPU: 0 PID: 4484 Comm: btrfs-cleaner 
Tainted: G     U      E   4.6.0-1-rt-amd64 #1 Debian 4.6.4-1
Sep 25 09:35:12 aldebaran kernel: Hardware name: Hewlett-Packard HP 
ProBook 450 G2/2248, BIOS M74 Ver. 01.41 05/19/2016
Sep 25 09:35:12 aldebaran kernel: task: ffff88004db30000 ti: 
ffff880024c90000 task.ti: ffff880024c90000
Sep 25 09:35:12 aldebaran kernel: RIP: 0010:[<ffffffffc0558543>] 
[<ffffffffc0558543>] update_inline_extent_backref+0x2a3/0x2b0 [btrfs]
Sep 25 09:35:12 aldebaran kernel: RSP: 0018:ffff880024c93b18  EFLAGS: 
00010297
Sep 25 09:35:12 aldebaran kernel: RAX: 0000000000000003 RBX: 
0000000000002d99 RCX: 0000000000000002
Sep 25 09:35:12 aldebaran kernel: RDX: ffff880000000000 RSI: 
0000000000002e21 RDI: 0000000000000000
Sep 25 09:35:12 aldebaran kernel: RBP: ffff88002e4ba4c0 R08: 
0000000000004000 R09: 0000000000000000
Sep 25 09:35:12 aldebaran kernel: R10: 0000000000002e09 R11: 
0000000000000002 R12: 00000000fffffffd
Sep 25 09:35:12 aldebaran kernel: R13: ffff88002e032700 R14: 
0000000000002e08 R15: 00000000000000b2
Sep 25 09:35:12 aldebaran kernel: FS:  0000000000000000(0000) 
GS:ffff88014ac00000(0000) knlGS:0000000000000000
Sep 25 09:35:12 aldebaran kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Sep 25 09:35:12 aldebaran kernel: CR2: 00007f9a4dc79000 CR3: 
0000000001a06000 CR4: 00000000001406f0
Sep 25 09:35:12 aldebaran kernel: Stack:
Sep 25 09:35:12 aldebaran kernel:  fffffffffffffffd ffff88012e9fd000 
ffff880024c93bec 0000000000002e09
Sep 25 09:35:12 aldebaran kernel:  0000000000000000 00000098b6a4b000 
0000000000000047 ffff88012e9fd000
Sep 25 09:35:12 aldebaran kernel:  0000000000000015 ffff88002e032700 
ffffffffc055a18a ffffffffc055c774
Sep 25 09:35:12 aldebaran kernel: Call Trace:
Sep 25 09:35:12 aldebaran kernel:  [<ffffffffc055a18a>] ? 
remove_extent_backref+0x3a/0x60 [btrfs]
Sep 25 09:35:12 aldebaran kernel:  [<ffffffffc055c774>] ? 
__btrfs_free_extent.isra.68+0x674/0xdd0 [btrfs]
Sep 25 09:35:12 aldebaran kernel:  [<ffffffffc0560a99>] ? 
__btrfs_run_delayed_refs+0x569/0x1390 [btrfs]
Sep 25 09:35:12 aldebaran kernel:  [<ffffffffc0561ecf>] ? 
btrfs_free_tree_block+0xdf/0x290 [btrfs]
Sep 25 09:35:12 aldebaran kernel:  [<ffffffff810802a8>] ? 
pin_current_cpu+0x88/0x1b0
Sep 25 09:35:12 aldebaran kernel:  [<ffffffffc056467f>] ? 
btrfs_run_delayed_refs+0x8f/0x2a0 [btrfs]
Sep 25 09:35:12 aldebaran kernel:  [<ffffffffc0562615>] ? 
walk_up_tree+0xc5/0x1c0 [btrfs]
Sep 25 09:35:12 aldebaran kernel:  [<ffffffffc057a01f>] ? 
btrfs_should_end_transaction+0x3f/0x60 [btrfs]
Sep 25 09:35:12 aldebaran kernel:  [<ffffffffc0562e61>] ? 
btrfs_drop_snapshot+0x461/0x860 [btrfs]
Sep 25 09:35:12 aldebaran kernel:  [<ffffffffc057a50e>] ? 
btrfs_clean_one_deleted_snapshot+0xae/0x100 [btrfs]
Sep 25 09:35:12 aldebaran kernel:  [<ffffffffc05710c1>] ? 
cleaner_kthread+0xc1/0x1b0 [btrfs]
Sep 25 09:35:12 aldebaran kernel:  [<ffffffffc0571000>] ? 
btrfs_destroy_pinned_extent+0xe0/0xe0 [btrfs]
Sep 25 09:35:12 aldebaran kernel:  [<ffffffff8109f0fd>] ? kthread+0xcd/0xf0
Sep 25 09:35:12 aldebaran kernel:  [<ffffffff815e2f72>] ? 
ret_from_fork+0x22/0x40
Sep 25 09:35:12 aldebaran kernel:  [<ffffffff8109f030>] ? 
kthread_worker_fn+0x150/0x150
Sep 25 09:35:12 aldebaran kernel: Code: ff ff ff 41 bf 0d 00 00 00 41 bc 
0d 00 00 00 e9 98 fe ff ff 0f 0b e8 14 eb 09 00 44 89 e0 f7 d8 48 98 48 
39 c1 0f 83 52 ff ff ff <0f> 0b 90 66 2e 0f 1f 84 00 0
Sep 25 09:35:12 aldebaran kernel: RIP  [<ffffffffc0558543>] 
update_inline_extent_backref+0x2a3/0x2b0 [btrfs]
Sep 25 09:35:12 aldebaran kernel:  RSP <ffff880024c93b18>
Sep 25 09:35:12 aldebaran kernel: ---[ end trace 0000000000000002 ]---
	
Best regards

Jakob

