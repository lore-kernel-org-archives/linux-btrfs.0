Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.palepurple.co.uk ([89.16.169.139]:57954 "EHLO
        mail.palepurple.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751476AbeDUQPV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Apr 2018 12:15:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.palepurple.co.uk (Postfix) with ESMTP id 7ED2B8085
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Apr 2018 17:15:19 +0100 (BST)
Received: from mail.palepurple.co.uk ([127.0.0.1])
        by localhost (mail.palepurple.co.uk [127.0.0.50]) (amavisd-new, port 10024)
        with ESMTP id AoSpZU5_o67h for <linux-btrfs@vger.kernel.org>;
        Sat, 21 Apr 2018 17:15:08 +0100 (BST)
Received: from mabel.local (05471ca6.skybroadband.com [5.71.28.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: david@codepoets.co.uk)
        by mail.palepurple.co.uk (Postfix) with ESMTPSA id 92A65806A
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Apr 2018 17:15:08 +0100 (BST)
To: linux-btrfs@vger.kernel.org
From: David Goodwin <david@codepoets.co.uk>
Subject: 4.9.83 - btrfs_truncate_inode_items - nospace left -> transid / csum
 issues.
Message-ID: <56b7a054-9b83-6976-80af-833091d35019@codepoets.co.uk>
Date: Sat, 21 Apr 2018 17:15:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

My volume ran out of space, and that seems to have triggered csum errors.

Kernel 4.9.83

% btrfs fi us /backup/
Overall:
     Device size:           4.12TiB
     Device allocated:           4.12TiB
     Device unallocated:           2.00MiB
     Device missing:             0.00B
     Used:               4.12TiB
     Free (estimated):           1.09MiB    (min: 1.09MiB)
     Data ratio:                  1.00
     Metadata ratio:              1.00
     Global reserve:         512.00MiB    (used: 0.00B)

Data+Metadata,single: Size:4.12TiB, Used:4.12TiB
    /dev/xvdf    1023.97GiB
    /dev/xvdg       3.12TiB

System,single: Size:32.00MiB, Used:460.00KiB
    /dev/xvdf      32.00MiB

Unallocated:
    /dev/xvdf       1.00MiB
    /dev/xvdg       1.00MiB


dmesg output :

------------[ cut here ]------------
WARNING: CPU: 0 PID: 8076 at fs/btrfs/inode.c:4587 
btrfs_truncate_inode_items+0xcd0/0xdd0 [btrfs]
BTRFS: Transaction aborted (error -28)
Modules linked in: dm_mod ipt_REJECT nf_reject_ipv4 xt_multiport 
iptable_filter ip_tables x_tables evdev intel_rapl crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel snd_pcsp aesni_intel snd_pcm aes_x86_64 
lrw snd_timer gf128mul glue_helper snd ablk_helper cryptd soundcore ext4 
crc16 jbd2 mbcache btrfs xor raid6_pq xen_netfront xen_blkfront crc32c_intel
CPU: 0 PID: 8076 Comm: rsync Not tainted 4.9.83-dg1 #1
  0000000000000000 ffffffff812ced74 ffffc900417f3c70 0000000000000000
  ffffffff810759ce 0000000000000a16 ffffc900417f3cc0 ffff88018fe1a9a0
  ffff8801c5672800 0000000000000000 0000000000000000 ffffffff81075a3f
Call Trace:
  [<ffffffff812ced74>] ? dump_stack+0x5c/0x78
  [<ffffffff810759ce>] ? __warn+0xbe/0xe0
  [<ffffffff81075a3f>] ? warn_slowpath_fmt+0x4f/0x60
  [<ffffffffa00b6420>] ? btrfs_truncate_inode_items+0xcd0/0xdd0 [btrfs]
  [<ffffffffa00b6601>] ? btrfs_truncate+0xe1/0x2b0 [btrfs]
  [<ffffffffa00b6f54>] ? btrfs_setattr+0x264/0x370 [btrfs]
  [<ffffffff812004c2>] ? notify_change+0x2f2/0x440
  [<ffffffff811e04ee>] ? do_truncate+0x5e/0x90
  [<ffffffff811e08d7>] ? do_sys_ftruncate.constprop.13+0x117/0x180
  [<ffffffff811e40f2>] ? SyS_write+0x42/0x90
  [<ffffffff81003a3a>] ? do_syscall_64+0x6a/0xd0
  [<ffffffff815860b8>] ? entry_SYSCALL_64_after_swapgs+0x42/0xb0
---[ end trace 856a9b15eaffabc5 ]---
BTRFS: error (device xvdg) in btrfs_truncate_inode_items:4587: errno=-28 
No space left
BTRFS info (device xvdg): forced readonly
BTRFS error (device xvdg): pending csums is 344064
BTRFS error (device xvdg): parent transid verify failed on 3463283875840 
wanted 715777 found 715775
BTRFS error (device xvdg): parent transid verify failed on 2650035322880 
wanted 715777 found 715775
BTRFS info (device xvdg): no csum found for inode 39551584 start 0
...


Hopefully of help to someone fixing bugs....


Thanks

David.

