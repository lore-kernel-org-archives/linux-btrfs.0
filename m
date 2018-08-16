Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.palepurple.co.uk ([89.16.169.139]:47458 "EHLO
        mail.palepurple.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728832AbeHPKyQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 06:54:16 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.palepurple.co.uk (Postfix) with ESMTP id 44F88806C
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2018 07:51:26 +0000 (UTC)
Received: from mail.palepurple.co.uk ([127.0.0.1])
        by localhost (mail.palepurple.co.uk [127.0.0.50]) (amavisd-new, port 10024)
        with ESMTP id GN0OYCqAPIBE for <linux-btrfs@vger.kernel.org>;
        Thu, 16 Aug 2018 07:51:17 +0000 (UTC)
Received: from mabel.local (054339a9.skybroadband.com [5.67.57.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: david@codepoets.co.uk)
        by mail.palepurple.co.uk (Postfix) with ESMTPSA id 2FDD6804E
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2018 07:51:17 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: David Goodwin <david@codepoets.co.uk>
Subject: Transaction aborted - 4.16.17 kernel
Message-ID: <8226e7cc-3831-de01-0682-cf57e7aa3adb@codepoets.co.uk>
Date: Thu, 16 Aug 2018 08:51:16 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've just spotted this on one server.

Running : umount /backups && mount /backups

seems to allow it to become r/w again, but it does write :

BTRFS error (device xvdj): cleaner transaction attach returned -30

to 'dmesg'.


David.

------------[ cut here ]------------

BTRFS: Transaction aborted (error -28)
WARNING: CPU: 3 PID: 992 at fs/btrfs/extent-tree.c:7004 
__btrfs_free_extent.isra.63+0x3d2/0xd20
Modules linked in: dm_mod dax ipt_REJECT nf_reject_ipv4 nfsv3 
ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 
nf_defrag_ipv4 nf_nat_ipv4 nf_nat_ftp nf_conntrack_ftp nf_nat 
nf_conntrack libcrc32c xt_multiport iptable_filter ip_tables x_tables 
autofs4 nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc 
intel_rapl crct10dif_pclmul crc32_pclmul ghash_clmulni_intel evdev pcbc 
snd_pcsp snd_pcm aesni_intel snd_timer aes_x86_64 crypto_simd snd 
glue_helper cryptd soundcore xen_netfront xen_blkfront crc32c_intel
CPU: 3 PID: 992 Comm: btrfs-transacti Not tainted 4.16.17-dg1 #1
RIP: e030:__btrfs_free_extent.isra.63+0x3d2/0xd20
RSP: e02b:ffffc9004290bc68 EFLAGS: 00010292
RAX: 0000000000000026 RBX: 00000180c5538000 RCX: 0000000000000006
RDX: 0000000000000007 RSI: 0000000000000001 RDI: ffff88039a996650
RBP: 00000000ffffffe4 R08: 0000000000000001 R09: 0000000000001d80
R10: 0000000000000001 R11: 0000000000001d80 R12: ffff880392d64000
R13: ffff880251fedcb0 R14: 0000000000000000 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff88039a980000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdee11425c0 CR3: 00000002d3700000 CR4: 0000000000000660
Call Trace:
  ? btrfs_merge_delayed_refs+0x23c/0x3c0
  __btrfs_run_delayed_refs+0x320/0x1180
  btrfs_run_delayed_refs+0x105/0x1c0
  btrfs_commit_transaction+0x393/0x8a0
  ? wait_woken+0x80/0x80
  transaction_kthread+0x195/0x1b0
  kthread+0xf8/0x130
  ? btrfs_cleanup_transaction+0x540/0x540
  ? kthread_create_worker_on_cpu+0x50/0x50
  ret_from_fork+0x35/0x40
Code: 48 8b 04 24 48 8b 40 50 f0 48 0f ba a8 d0 16 00 00 02 72 19 83 fd 
fb 0f 84 07 03 00 00 89 ee 48 c7 c7 30 f3 d9 81 e8 2e a6 d7 ff <0f> 0b 
48 8b 3c 24 89 e9 ba 5c 1b 00 00 48 c7 c6 80 86 c3 81 e8
---[ end trace c83740faa277d833 ]---
