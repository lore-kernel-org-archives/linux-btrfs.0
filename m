Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE12C04EBF
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 17:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45E55223CB
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 17:30:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 45E55223CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388787AbeKPDi7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 22:38:59 -0500
Received: from mail-it1-f198.google.com ([209.85.166.198]:51067 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388265AbeKPDir (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 22:38:47 -0500
Received: by mail-it1-f198.google.com with SMTP id p66so11298652itc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 09:30:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eU7IONmejJ2AuTpIlLqzSUMPPWH62GEzwh/fmQ+pFiQ=;
        b=NucFbJdVbi5LyDfBak+3UC3j6UgLxFxy7S/MdwKvS/kLwVCim0pE94tOkDxxzQ02La
         BiH6uSjr/LkRC5p1V50P988Tw7jGO4Rw774wRTGwd8q8Mk6d3+iPRI/h5/Y2Ahs5dhfl
         fRaUOGxFYR0maaTtCH+N5OQPefYH+0op1a80aVgLjdWw5fgpOqoJIwnaCcO8KdfJSE/l
         dQha9fY69Ny4emG7Xuqoy2IEWRVOWHY3ZdhbSgMoOxDjQ8PTTzdUsXENDMnNNKSzYvmu
         h5wfwf68uhdcHJAsn1kEhAf0rsh71FhiYeHsQmoscV2Yu7/1aa15tCvIMVSFtrV7SQt6
         ktaQ==
X-Gm-Message-State: AGRZ1gIZ5RGxCxDbmwKrakvypcUXGYcvtas8tHWP6bLCq+NxNYrNo4pw
        x0WUjeEl7RG5wlWpykS8LIm8qBOcuuPn2r9Ll/Y0lkuQyy9G
X-Google-Smtp-Source: AJdET5dodno51+GlbokLNAmDLr2eESC0HY8TNoFbU87zUtEDHitOoaNs3eF8VZORszEDgnqb0K6lVcPwnJX1t5nyvd3zP5XErUIX
MIME-Version: 1.0
X-Received: by 2002:a24:55:: with SMTP id 82-v6mr906532ita.31.1542303003779;
 Thu, 15 Nov 2018 09:30:03 -0800 (PST)
Date:   Thu, 15 Nov 2018 09:30:03 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ad2edc057ab76675@google.com>
Subject: general protection fault in btrfs_scan_one_device
From:   syzbot <syzbot+46048b9c7ec2fe0d4885@syzkaller.appspotmail.com>
To:     clm@fb.com, dsterba@suse.com, josef@toxicpanda.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    442b8cea2477 Add linux-next specific files for 20181109
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=173046a3400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2f72bdb11df9fbe8
dashboard link: https://syzkaller.appspot.com/bug?extid=46048b9c7ec2fe0d4885
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+46048b9c7ec2fe0d4885@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 13175 Comm: syz-executor4 Not tainted 4.20.0-rc1-next-20181109+  
#110
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
kobject: 'kvm' (000000001e39937e): kobject_uevent_env
RIP: 0010:device_list_add+0x436/0x1460 fs/btrfs/volumes.c:899
Code: e8 6f d3 8a fe 31 ff 4c 89 f6 e8 95 d4 8a fe 49 8d 7d 20 4d 85 f6 48  
b8 00 00 00 00 00 fc ff df 48 89 fa 0f 95 c3 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 06 0f 8e 32 0d 00 00 41 88 5d 20 4c 89 ee 48
RSP: 0018:ffff8801cbe46f30 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: ffffffff8982db01 RCX: ffffffff82f4d54b
RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000014
RBP: ffff8801cbe47148 R08: ffff88017aa6e600 R09: ffffed003b5e5b67
kobject: 'kvm' (000000001e39937e): fill_kobj_path: path  
= '/devices/virtual/misc/kvm'
R10: ffffed003b5e5b67 R11: ffff8801daf2db3b R12: ffff8801cca11000
R13: fffffffffffffff4 R14: 0000001000000000 R15: 00000000ffffff14
FS:  00007f250ed2a700(0000) GS:ffff8801daf00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe28d69f88 CR3: 00000001bf7b1000 CR4: 00000000001426e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  btrfs_scan_one_device+0x4bc/0x1470 fs/btrfs/volumes.c:1422
kobject: 'kvm' (000000001e39937e): kobject_uevent_env
kobject: 'ip_vti0' (000000006f23136f): kobject_add_internal: parent: 'net',  
set: 'devices'
kobject: 'kvm' (000000001e39937e): fill_kobj_path: path  
= '/devices/virtual/misc/kvm'
kobject: 'ip_vti0' (000000006f23136f): kobject_uevent_env
kobject: 'ip_vti0' (000000006f23136f): fill_kobj_path: path  
= '/devices/virtual/net/ip_vti0'
kobject: 'queues' (00000000975f6f6c): kobject_add_internal:  
parent: 'ip_vti0', set: '<NULL>'
  btrfs_mount_root+0xc86/0x1d80 fs/btrfs/super.c:1568
kobject: 'queues' (00000000975f6f6c): kobject_uevent_env
  legacy_get_tree+0x12f/0x260 fs/fs_context.c:714
  vfs_get_tree+0x1cb/0x5c0 fs/super.c:1795
kobject: 'queues' (00000000975f6f6c): kobject_uevent_env: filter function  
caused the event to drop!
  vfs_kern_mount.part.57+0x122/0x1a0 fs/namespace.c:3345
  vfs_kern_mount+0x4a/0x70 fs/namespace.c:3324
  btrfs_mount+0x4b4/0x2165 fs/btrfs/super.c:1672
kobject: 'rx-0' (00000000b0416e92): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'rx-0' (00000000b0416e92): kobject_uevent_env
kobject: 'rx-0' (00000000b0416e92): fill_kobj_path: path  
= '/devices/virtual/net/ip_vti0/queues/rx-0'
kobject: 'tx-0' (00000000c8feb95b): kobject_add_internal: parent: 'queues',  
set: 'queues'
kobject: 'tx-0' (00000000c8feb95b): kobject_uevent_env
kobject: 'tx-0' (00000000c8feb95b): fill_kobj_path: path  
= '/devices/virtual/net/ip_vti0/queues/tx-0'
  legacy_get_tree+0x12f/0x260 fs/fs_context.c:714
kobject: 'ip6_vti0' (000000008583c444): kobject_add_internal:  
parent: 'net', set: 'devices'
  vfs_get_tree+0x1cb/0x5c0 fs/super.c:1795
  do_new_mount fs/namespace.c:2716 [inline]
  do_mount+0x82a/0x1ff0 fs/namespace.c:3042
kobject: 'ip6_vti0' (000000008583c444): kobject_uevent_env
kobject: 'ip6_vti0' (000000008583c444): fill_kobj_path: path  
= '/devices/virtual/net/ip6_vti0'
  ksys_mount+0x12d/0x140 fs/namespace.c:3258
  __do_sys_mount fs/namespace.c:3272 [inline]
  __se_sys_mount fs/namespace.c:3269 [inline]
  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3269
kobject: 'queues' (00000000ed64f9a7): kobject_add_internal:  
parent: 'ip6_vti0', set: '<NULL>'
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
kobject: 'queues' (00000000ed64f9a7): kobject_uevent_env
kobject: 'queues' (00000000ed64f9a7): kobject_uevent_env: filter function  
caused the event to drop!
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459fda
Code: b8 a6 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 7d 89 fb ff c3 66 2e 0f  
1f 84 00 00 00 00 00 66 90 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 5a 89 fb ff c3 66 0f 1f 84 00 00 00 00 00
RSP: 002b:00007f250ed29a88 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
kobject: 'rx-0' (00000000c0c5ba02): kobject_add_internal: parent: 'queues',  
set: 'queues'
RAX: ffffffffffffffda RBX: 00007f250ed29b30 RCX: 0000000000459fda
RDX: 00007f250ed29ad0 RSI: 0000000020000100 RDI: 00007f250ed29af0
RBP: 0000000020000100 R08: 00007f250ed29b30 R09: 00007f250ed29ad0
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000004
R13: 0000000000000000 R14: 00000000004d83e8 R15: 0000000000000003
Modules linked in:
kobject: 'loop5' (000000004b229921): kobject_uevent_env
kobject: 'loop5' (000000004b229921): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
---[ end trace 6d0d7474702a14d9 ]---
kobject: 'loop4' (0000000090ac9b5a): kobject_uevent_env
RIP: 0010:device_list_add+0x436/0x1460 fs/btrfs/volumes.c:899
kobject: 'loop4' (0000000090ac9b5a): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
Code: e8 6f d3 8a fe 31 ff 4c 89 f6 e8 95 d4 8a fe 49 8d 7d 20 4d 85 f6 48  
b8 00 00 00 00 00 fc ff df 48 89 fa 0f 95 c3 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 06 0f 8e 32 0d 00 00 41 88 5d 20 4c 89 ee 48
kobject: 'loop1' (0000000002c6f40b): kobject_uevent_env
kobject: 'kvm' (000000001e39937e): kobject_uevent_env
kobject: 'loop1' (0000000002c6f40b): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
RSP: 0018:ffff8801cbe46f30 EFLAGS: 00010203
kobject: 'rx-0' (00000000c0c5ba02): kobject_uevent_env
RAX: dffffc0000000000 RBX: ffffffff8982db01 RCX: ffffffff82f4d54b
kobject: 'kvm' (000000001e39937e): fill_kobj_path: path  
= '/devices/virtual/misc/kvm'
RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000014
kobject: 'rx-0' (00000000c0c5ba02): fill_kobj_path: path  
= '/devices/virtual/net/ip6_vti0/queues/rx-0'
RBP: ffff8801cbe47148 R08: ffff88017aa6e600 R09: ffffed003b5e5b67
kobject: 'loop5' (000000004b229921): kobject_uevent_env
kobject: 'loop5' (000000004b229921): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
R10: ffffed003b5e5b67 R11: ffff8801daf2db3b R12: ffff8801cca11000
kobject: 'tx-0' (00000000dad0d615): kobject_add_internal: parent: 'queues',  
set: 'queues'
R13: fffffffffffffff4 R14: 0000001000000000 R15: 00000000ffffff14
kobject: 'tx-0' (00000000dad0d615): kobject_uevent_env
FS:  00007f250ed2a700(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kobject: 'tx-0' (00000000dad0d615): fill_kobj_path: path  
= '/devices/virtual/net/ip6_vti0/queues/tx-0'
kobject: 'loop5' (000000004b229921): kobject_uevent_env
CR2: 0000000000728000 CR3: 00000001bf7b1000 CR4: 00000000001406f0
kobject: 'loop5' (000000004b229921): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
IPVS: ftp: loaded support on port[0] = 21
kobject: 'loop1' (0000000002c6f40b): kobject_uevent_env
kobject: 'loop1' (0000000002c6f40b): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
