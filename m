Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF586C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 12:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7371D2085B
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 12:32:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codepoets.co.uk header.i=@codepoets.co.uk header.b="Wbk+Bv3D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7371D2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=codepoets.co.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbeJJTyI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 15:54:08 -0400
Received: from mail.palepurple.co.uk ([89.16.169.139]:49652 "EHLO
        mail.palepurple.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbeJJTyI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 15:54:08 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2018 15:54:07 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.palepurple.co.uk (Postfix) with ESMTP id 04D87806C
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Oct 2018 12:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codepoets.co.uk;
        s=codepoets; t=1539174318;
        bh=oOwHIhRYawl2PsNYgwT6VQz1SJnQOR+EPrrFTBuOEYY=;
        h=To:From:Subject:Date:From;
        b=Wbk+Bv3D0TR7UA2w+MtN/2yh8latDctaM6dn+OOSeEUaH5efm53V5N/jFw7r0/42R
         7PZgPBtdwSUCN4fwjiPThDX+kB3BsX+c7CMDckojJvNekwIV5WDx3U5lHyE9XNvSE0
         rAeHlKm/VwXNXxnLxleGYJyam1jctcSit9gR+sf0=
X-Virus-Scanned: by Amavis+SpamAssassin+ClamAV and more at palepurple.co.uk
Received: from mail.palepurple.co.uk ([127.0.0.1])
        by localhost (mail.palepurple.co.uk [127.0.0.50]) (amavisd-new, port 10024)
        with ESMTP id kTfAA9KeuEV8 for <linux-btrfs@vger.kernel.org>;
        Wed, 10 Oct 2018 12:25:09 +0000 (UTC)
Received: from [192.168.86.200] (5ec3d783.skybroadband.com [94.195.215.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: david@palepurple.co.uk)
        by mail.palepurple.co.uk (Postfix) with ESMTPSA id D04FD804E
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Oct 2018 12:25:09 +0000 (UTC)
To:     linux-btrfs@vger.kernel.org
From:   David Goodwin <david@codepoets.co.uk>
Subject: Transaction aborted (error -28) - at fs/btrfs/extent-tree.c:6953
Message-ID: <340c1e88-2f65-e8fc-4fed-3657c15200b7@codepoets.co.uk>
Date:   Wed, 10 Oct 2018 13:25:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I've just hit this on a backup server. I suspect something would have 
been trying to remove/create a snapshot at the time.

I'll ignorantly assume it's similar to the last one I posted ( 
https://www.spinics.net/lists/linux-btrfs/msg82636.html ) although the 
trace is different.

David.


------------[ cut here ]------------
BTRFS: Transaction aborted (error -28)
WARNING: CPU: 3 PID: 996 at fs/btrfs/extent-tree.c:6953 
__btrfs_free_extent.isra.67+0x3ec/0xd60
Modules linked in: ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 
nf_defrag_ipv4 nf_nat_ipv4 nf_nat_ftp nf_conntrack_ftp nf_nat 
nf_conntrack ipt_REJECT nf_reject_ipv4 nfsv3 xt_multiport iptable_filter 
ip_tables x_tables autofs4 nfsd auth_rpcgss nfs_acl nfs lockd grace 
fscache sunrpc intel_rapl crct10dif_pclmul crc32_pclmul crc32c_intel 
ghash_clmulni_intel pcbc evdev snd_pcsp snd_pcm aesni_intel snd_timer 
snd aes_x86_64 crypto_simd soundcore cryptd glue_helper xen_netfront 
xen_blkfront
CPU: 3 PID: 996 Comm: btrfs-transacti Not tainted 4.18.11-psi-dg1 #1
RIP: e030:__btrfs_free_extent.isra.67+0x3ec/0xd60
Code: 8b 04 24 48 8b 40 50 f0 48 0f ba a8 08 17 00 00 02 72 19 83 fd fb 
0f 84 15 03 00 00 89 ee 48 c7 c7 38 70 da 81 e8 b4 eb d4 ff <0f> 0b 48 
8b 3c 24 89 e9 ba 29 1b 00 00 48 c7 c6 00 7b c3 81 e8 77
RSP: e02b:ffffc90041e03c78 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 000001f656680000 RCX: 0000000000000006
RDX: 0000000000000007 RSI: 0000000000000001 RDI: ffff88039a996650
RBP: 00000000ffffffe4 R08: 0000000000000001 R09: 0000000000000319
R10: 0000000000000001 R11: 0000000000000319 R12: ffff880395744000
R13: ffff88024d93b7e0 R14: 0000000000000000 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff88039a980000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f75a076f000 CR3: 000000038ae34000 CR4: 0000000000000660
Call Trace:
  ? btrfs_merge_delayed_refs+0xa7/0x360
  __btrfs_run_delayed_refs+0x32f/0x1140
  btrfs_run_delayed_refs+0xfb/0x1b0
  btrfs_commit_transaction+0x343/0x880
  ? wait_woken+0x80/0x80
  transaction_kthread+0x157/0x180
  kthread+0xf8/0x130
  ? btrfs_cleanup_transaction+0x570/0x570
  ? kthread_create_worker_on_cpu+0x70/0x70
  ret_from_fork+0x35/0x40
---[ end trace 415fa2ecbacc2881 ]---
BTRFS: error (device xvdh) in __btrfs_free_extent:6953: errno=-28 No 
space left
BTRFS: error (device xvdh) in btrfs_drop_snapshot:9250: errno=-28 No 
space left
BTRFS info (device xvdh): forced readonly
BTRFS: error (device xvdh) in btrfs_run_delayed_refs:3057: errno=-28 No 
space left
BTRFS warning (device xvdh): Skipping commit of aborted transaction.

BTRFS: error (device xvdh) in cleanup_transaction:1847: errno=-28 No 
space left




% btrfs fi us /backups/
Overall:
     Device size:           4.00TiB
     Device allocated:           2.40TiB
     Device unallocated:           1.60TiB
     Device missing:             0.00B
     Used:               2.39TiB
     Free (estimated):           1.61TiB    (min: 1.61TiB)
     Data ratio:                  1.00
     Metadata ratio:              1.00
     Global reserve:         512.00MiB    (used: 510.00MiB)

Data,single: Size:2.29TiB, Used:2.29TiB
    /dev/xvdh       1.73TiB
    /dev/xvdj     574.00GiB

Metadata,single: Size:112.01GiB, Used:106.19GiB
    /dev/xvdh      48.01GiB
    /dev/xvdj      64.00GiB

System,single: Size:32.00MiB, Used:288.00KiB
    /dev/xvdj      32.00MiB

Unallocated:
    /dev/xvdh     231.98GiB
    /dev/xvdj       1.38TiB

