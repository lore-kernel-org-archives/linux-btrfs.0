Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.palepurple.co.uk ([89.16.169.139]:54710 "EHLO
        mail.palepurple.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbeDUHsZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Apr 2018 03:48:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.palepurple.co.uk (Postfix) with ESMTP id C911C8058
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Apr 2018 08:38:32 +0100 (BST)
Received: from mail.palepurple.co.uk ([127.0.0.1])
        by localhost (mail.palepurple.co.uk [127.0.0.50]) (amavisd-new, port 10024)
        with ESMTP id RrJkJ-CIvr4c for <linux-btrfs@vger.kernel.org>;
        Sat, 21 Apr 2018 08:38:24 +0100 (BST)
Received: from mabel.local (unknown [94.13.251.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: david@codepoets.co.uk)
        by mail.palepurple.co.uk (Postfix) with ESMTPSA id F272B806A
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Apr 2018 08:38:23 +0100 (BST)
To: linux-btrfs@vger.kernel.org
From: David Goodwin <david@codepoets.co.uk>
Subject: extent-tree.c no space left (4.9.77 + 4.16.2)
Message-ID: <74c299a0-913b-d6ed-466b-59d83103eead@codepoets.co.uk>
Date: Sat, 21 Apr 2018 08:38:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm running a 3TiB EBS based (2+1TiB devices) volume in EC2 which 
contains about 500 read-only snapshots.

btrfs-progs v4.7.3

There are two dmesg trace things below. The first one from a 4.9.77 kernel -

------------[ cut here ]------------
BTRFS: error (device xvdg) in btrfs_run_delayed_refs:2967: errno=-28 No 
space left
BTRFS info (device xvdg): forced readonlyApr 19 11:44:40 gateway1 
kernel: [7648104.300115] WARNING: CPU: 2 PID: 963 at 
fs/btrfs/extent-tree.c:2967 btrfs_run_delayed_refs+0x27e/0x2b0 
[btrfs]Apr 19 11:44:40 gateway1 kernel: [7648104.313268] BTRFS: 
Transaction aborted (error -28)
Modules linked in: dm_mod nfsv3 ipt_REJECT nf_reject_ipv4 ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack xt_mu
nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc 
evdev intel_rapl crct10dif_pclmul crc32_pclmul ghash_clmulni_intel 
snd_pcsp snd_pcm aesni_intel aes_x86_64 lrw gf128mul glue_helper 
snd_timer ablk_helper snd cryptd soundcore ext4 crc16 jbd2 mbcache btrfs 
xor raid6_pq xen_netfront xen_blkfront crc32c_intel
CPU: 2 PID: 963 Comm: btrfs-transacti Not tainted 4.9.77-dg1 #1Apr 19 
11:44:40 gateway1 kernel: [7648104.408561]  0000000000000000 
ffffffff812f17a4 ffffc90043203d08 0000000000000000
  ffffffff8107389e ffffffffa0157d5a ffffc90043203d58 ffff8802ccfd7170
  ffff880394684800 ffff880394684800 000000000007315c ffffffff8107390f
Call Trace:
  [<ffffffff812f17a4>] ? dump_stack+0x5c/0x78
  [<ffffffff8107389e>] ? __warn+0xbe/0xe0
  [<ffffffff8107390f>] ? warn_slowpath_fmt+0x4f/0x60
  [<ffffffffa00bd3fe>] ? btrfs_run_delayed_refs+0x27e/0x2b0 [btrfs]
  [<ffffffffa00a7523>] ? btrfs_release_path+0x13/0x80 [btrfs]
  [<ffffffffa00c1dc2>] ? btrfs_start_dirty_block_groups+0x2c2/0x450 [btrfs]
  [<ffffffffa00d36ac>] ? btrfs_commit_transaction+0x14c/0xa30 [btrfs]
  [<ffffffffa00d4026>] ? start_transaction+0x96/0x480 [btrfs]
  [<ffffffffa00ce54c>] ? transaction_kthread+0x1dc/0x200 [btrfs]
  [<ffffffffa00ce370>] ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
  [<ffffffff81091ef7>] ? kthread+0xc7/0xe0
  [<ffffffff81091e30>] ? kthread_park+0x60/0x60
  [<ffffffff815a3174>] ? ret_from_fork+0x54/0x60
---[ end trace 69ca1332d91b4310 ]---
BTRFS: error (device xvdg) in btrfs_run_delayed_refs:2967: errno=-28 No 
space left
BTRFS error (device xvdg): parent transid verify failed on 5400398217216 
wanted 1893543 found 1893366



On checking btrfs fi us there was plenty of unallocated space left.

% btrfs fi us /broken/

Overall:
     Device size:           3.06TiB
     Device allocated:           2.43TiB
     Device unallocated:         643.09GiB
     Device missing:             0.00B
     Used:               2.43TiB
     Free (estimated):         646.41GiB    (min: 646.41GiB)
     Data ratio:                  1.00
     Metadata ratio:              1.00
     Global reserve:         512.00MiB    (used: 0.00B)

....

The VM was then rebooted with a 4.16.2 kernel, which encountered what I 
assume is the same problem:


------------[ cut here ]------------
BTRFS: Transaction aborted (error -28)
WARNING: CPU: 2 PID: 981 at fs/btrfs/extent-tree.c:6990 
__btrfs_free_extent.isra.63+0x3d2/0xd20 [btrfs]
Modules linked in: nfsv3 ipt_REJECT nf_reject_ipv4 ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack libcrc32c 
crc32c_generic xt_multiport iptable_filter ip_tables x_tables autofs4 
nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc intel_rapl 
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel evdev pcbc snd_pcsp 
aesni_intel snd_pcm aes_x86_64 snd_timer crypto_simd glue_helper snd 
cryptd soundcore ext4 crc16 mbcache jbd2 btrfs xor zstd_decompress 
zstd_compress xxhash raid6_pq xen_netfront xen_blkfront crc32c_intel
CPU: 2 PID: 981 Comm: btrfs-transacti Not tainted 4.16.2-dg1 #1
RIP: e030:__btrfs_free_extent.isra.63+0x3d2/0xd20 [btrfs]
RSP: e02b:ffffc900428d7c68 EFLAGS: 00010292
RAX: 0000000000000026 RBX: 000001fb8031c000 RCX: 0000000000000006
RDX: 0000000000000007 RSI: 0000000000000001 RDI: ffff88039a916650
RBP: 00000000ffffffe4 R08: 0000000000000001 R09: 000000000000010a
R10: 0000000000000001 R11: 000000000000010a R12: ffff8803957e6000
R13: ffff88036f5a9e70 R14: 0000000000000000 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff88039a900000(0000) knlGS:ffff88039a900000
CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2168f8c274 CR3: 000000038fd88000 CR4: 0000000000000660
Call Trace:
  ? btrfs_merge_delayed_refs+0x23c/0x3c0 [btrfs]
  __btrfs_run_delayed_refs+0x320/0x1150 [btrfs]
  btrfs_run_delayed_refs+0x105/0x1c0 [btrfs]
  btrfs_commit_transaction+0x393/0x8a0 [btrfs]
  ? start_transaction+0x93/0x420 [btrfs]
  transaction_kthread+0x195/0x1b0 [btrfs]
  kthread+0xf8/0x130
  ? btrfs_cleanup_transaction+0x520/0x520 [btrfs]
  ? kthread_create_worker_on_cpu+0x50/0x50
  ret_from_fork+0x35/0x40
Code: 48 8b 04 24 48 8b 40 50 f0 48 0f ba a8 d0 16 00 00 02 72 19 83 fd 
fb 0f 84 07 03 00 00 89 ee 48 c7 c7 28 29 16 a0 e8 9e b2 fb e0 <0f> 0b 
48 8b 3c 24 89 e9 ba 4e 1b 00 00 48 c7 c6 80 b8 15 a0 e8
---[ end trace 7d4d4006f7a3a06e ]---

BTRFS: error (device xvdg) in __btrfs_free_extent:6990: errno=-28 No 
space left


The volume appears to be usable when mounted read-only.

Hopefully the above might help someone remove what I ignorantly assume 
is a bug.

David.
