Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0E8C64EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 17:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 910DB20652
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 17:02:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codepoets.co.uk header.i=@codepoets.co.uk header.b="pxAw+QHd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 910DB20652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=codepoets.co.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbeJDX4Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 19:56:24 -0400
Received: from mail.palepurple.co.uk ([89.16.169.139]:38760 "EHLO
        mail.palepurple.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbeJDX4Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2018 19:56:24 -0400
X-Greylist: delayed 1036 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2018 19:56:23 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.palepurple.co.uk (Postfix) with ESMTP id F2856807E
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Oct 2018 16:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codepoets.co.uk;
        s=codepoets; t=1538671502;
        bh=vBmXroCRCjn9JKXxmcEKJOrteXou4KUy6LK30qav7uU=;
        h=To:From:Subject:Date:From;
        b=pxAw+QHd+0A1yH3fM4mW2iNAXMbdm3JqJHHPmyt2osXoo+o2lvelW5qQx62MiwYQX
         XmGAlGsz6TBNUOvmNrCzKMXGcgATQLjFH4F4DrbYcO74dSiw7kEjwUBAFoBSE2pfRA
         BGgXb7K7oyHDivYVFSy0SplyYpEBmKhKJ70pMTOs=
X-Virus-Scanned: by Amavis+SpamAssassin+ClamAV and more at palepurple.co.uk
Received: from mail.palepurple.co.uk ([127.0.0.1])
        by localhost (mail.palepurple.co.uk [127.0.0.50]) (amavisd-new, port 10024)
        with ESMTP id 2AQcqE8wzG-g for <linux-btrfs@vger.kernel.org>;
        Thu,  4 Oct 2018 16:44:46 +0000 (UTC)
Received: from [192.168.86.200] (5ec3d783.skybroadband.com [94.195.215.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: david@palepurple.co.uk)
        by mail.palepurple.co.uk (Postfix) with ESMTPSA id E0E00804E
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Oct 2018 16:44:46 +0000 (UTC)
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
From:   David Goodwin <david@codepoets.co.uk>
Subject: Transaction aborted error -28 clone_finish_inode_update
Message-ID: <a4a4cf31-9cf4-e52c-1f86-c62d336c9cd1@codepoets.co.uk>
Date:   Thu, 4 Oct 2018 17:44:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

While trying to run/use bedup ( https://github.com/g2p/bedup ) .... I 
hit this :


[Thu Oct  4 15:34:51 2018] ------------[ cut here ]------------
[Thu Oct  4 15:34:51 2018] BTRFS: Transaction aborted (error -28)
[Thu Oct  4 15:34:51 2018] WARNING: CPU: 0 PID: 28832 at 
fs/btrfs/ioctl.c:3671 clone_finish_inode_update+0xf3/0x140
[Thu Oct  4 15:34:51 2018] Modules linked in: ipt_REJECT nf_reject_ipv4 
dm_mod dax xt_multiport iptable_filter ip_tables x_tables intel_rapl 
crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc 
evdev aesni_intel snd_pcsp aes_x86_64 crypto_simd snd_pcm snd_timer 
cryptd snd glue_helper soundcore xen_netfront xen_blkfront
[Thu Oct  4 15:34:51 2018] CPU: 0 PID: 28832 Comm: bedup Not tainted 
4.18.10-psi-dg1 #1
[Thu Oct  4 15:34:51 2018] RIP: e030:clone_finish_inode_update+0xf3/0x140
[Thu Oct  4 15:34:51 2018] Code: c7 e9 67 ff ff ff 49 8b 44 24 50 f0 48 
0f ba a8 08 17 00 00 02 72 15 83 fb fb 74 3b 89 de 48 c7 c7 00 70 da 81 
e8 0d c7 cf ff <0f> 0b 89 d9 4c 89 e7 ba 57 0e 00 00 48 c7 c6 d0 91 c3 
81 e8 61 b8
[Thu Oct  4 15:34:51 2018] RSP: e02b:ffffc90042b6fc38 EFLAGS: 00010282
[Thu Oct  4 15:34:51 2018] RAX: 0000000000000000 RBX: 00000000ffffffe4 
RCX: 0000000000000006
[Thu Oct  4 15:34:51 2018] RDX: 0000000000000007 RSI: 0000000000000001 
RDI: ffff8801c9016650
[Thu Oct  4 15:34:51 2018] RBP: ffffc90042b6fc68 R08: 0000000000000001 
R09: 00000000000001ed
[Thu Oct  4 15:34:51 2018] R10: ffff8801c3a527d0 R11: 00000000000001ed 
R12: ffff8801c391abc8
[Thu Oct  4 15:34:51 2018] R13: 0000000008000000 R14: ffff8801c3a52ae8 
R15: ffff88010cc8d380
[Thu Oct  4 15:34:51 2018] FS:  00007f51a15bd700(0000) 
GS:ffff8801c9000000(0000) knlGS:0000000000000000
[Thu Oct  4 15:34:51 2018] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[Thu Oct  4 15:34:51 2018] CR2: 00007f5199bf4024 CR3: 000000012101e000 
CR4: 0000000000000660
[Thu Oct  4 15:34:51 2018] Call Trace:
[Thu Oct  4 15:34:51 2018]  btrfs_clone+0x956/0x1100
[Thu Oct  4 15:34:51 2018]  btrfs_clone_files+0x16f/0x370
[Thu Oct  4 15:34:51 2018]  vfs_clone_file_range+0x120/0x200
[Thu Oct  4 15:34:51 2018]  ioctl_file_clone+0x9f/0x100
[Thu Oct  4 15:34:51 2018]  do_vfs_ioctl+0x348/0x630
[Thu Oct  4 15:34:51 2018]  ? handle_mm_fault+0xfc/0x1f0
[Thu Oct  4 15:34:51 2018]  ksys_ioctl+0x70/0x80
[Thu Oct  4 15:34:51 2018]  __x64_sys_ioctl+0x16/0x20
[Thu Oct  4 15:34:51 2018]  do_syscall_64+0x55/0x100
[Thu Oct  4 15:34:51 2018] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[Thu Oct  4 15:34:51 2018] RIP: 0033:0x7f51a01721c7
[Thu Oct  4 15:34:51 2018] Code: 44 00 00 48 8b 05 c1 3c 2c 00 64 c7 00 
26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 
00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 91 3c 2c 00 f7 d8 
64 89 01 48
[Thu Oct  4 15:34:51 2018] RSP: 002b:00007fffac0f5f18 EFLAGS: 00000246 
ORIG_RAX: 0000000000000010
[Thu Oct  4 15:34:51 2018] RAX: ffffffffffffffda RBX: 00007f519b33df30 
RCX: 00007f51a01721c7
[Thu Oct  4 15:34:51 2018] RDX: 0000000000000008 RSI: 0000000040049409 
RDI: 0000000000000009
[Thu Oct  4 15:34:51 2018] RBP: 00000000027bb4f0 R08: 0000000000000000 
R09: 0000000000000000
[Thu Oct  4 15:34:51 2018] R10: 000000000074c75d R11: 0000000000000246 
R12: 00007f519d3e0a95
[Thu Oct  4 15:34:51 2018] R13: 00000000027bb4f0 R14: 00007f519d3df848 
R15: 00000000027bb4f0
[Thu Oct  4 15:34:51 2018] ---[ end trace 55016eefa01d918e ]---
[Thu Oct  4 15:34:51 2018] BTRFS: error (device xvdg) in 
clone_finish_inode_update:3671: errno=-28 No space left
[Thu Oct  4 15:34:51 2018] BTRFS info (device xvdg): forced readonly
[Thu Oct  4 15:34:51 2018] BTRFS error (device xvdg): pending csums is 
278528



% btrfs fi us /filesystem/
Overall:
     Device size:           7.12TiB
     Device allocated:           6.80TiB
     Device unallocated:         330.93GiB
     Device missing:             0.00B
     Used:               6.51TiB
     Free (estimated):         629.87GiB    (min: 629.87GiB)
     Data ratio:                  1.00
     Metadata ratio:              1.00
     Global reserve:         512.00MiB    (used: 0.00B)

Data+Metadata,single: Size:6.80TiB, Used:6.51TiB
    /dev/xvdf       1.69TiB
    /dev/xvdg       3.12TiB
    /dev/xvdi       1.99TiB

System,single: Size:32.00MiB, Used:780.00KiB
    /dev/xvdf      32.00MiB

Unallocated:
    /dev/xvdf     320.97GiB
    /dev/xvdg     949.00MiB
    /dev/xvdi       9.03GiB


I kind of think there is sufficient free space..... at least globally 
within the filesystem.

Does it require balancing to redistribute the unallocated space better? 
Or is something misbehaving?



thanks

David.

