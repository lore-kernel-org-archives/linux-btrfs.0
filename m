Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81250C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 07:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E21C20834
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 07:33:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E21C20834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbeK2Sh2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 13:37:28 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:37339 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbeK2Sh2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 13:37:28 -0500
Received: by mail-io1-f70.google.com with SMTP id d63so1108257iog.4
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 23:33:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=fQMvDfQiwRtQ7uTrWTt1+SPSV5dr2RS2vLMekVVYf44=;
        b=Bb8n7VdkOh0J39r3uY44ZhltGSdtGJb7KPQpE7cfuxfRPTehvvAwB43L7s4FQDqteC
         gRbuF/J0gzSOD4+5Ffxgo2CUIbkOYG9yX47r1aETTp1gEV2U/JfP7QlIauNWSfKP4od2
         RJ6FUDB1v4hLHl524+MEFrn/Zq/piXBxm/cGqMdJwS3aE5Bntv9ySzVrgB7lXhsR1Izi
         9Z9KOPnR7i6JFqQyWSu5gjmvaCUSvjgUQ7i6NhKu12FjvWOiMLD3bblSwMxetMccie2U
         eO3F4dtEEBB5iBEa+8KMC5d7m+9Y8kZ+/5m13+594ctG6jCR/fT0YPa/arCTdliHpNsa
         QbwQ==
X-Gm-Message-State: AA+aEWagz7Jiko05kbSmcsSpu9SRpgVSw5K+gOlhP1tlZB4MtZoQVYRM
        O3sJnbGOxold1j+SvFPGyHKjb/idQVFaZD12a8GU9iogdTGF
X-Google-Smtp-Source: AFSGD/Vd9qquhrFvgkTnfCIhWMZmtZJ3YaExIgth0i+yu6Jgw/lo9gIAAZt2Qx2TQGMw5UVWwr0BkfTigvHKRF3lKRpV/Figyw8m
MIME-Version: 1.0
X-Received: by 2002:a5d:9801:: with SMTP id a1mr276616iol.31.1543476782582;
 Wed, 28 Nov 2018 23:33:02 -0800 (PST)
Date:   Wed, 28 Nov 2018 23:33:02 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005852b8057bc8b123@google.com>
Subject: invalid opcode in close_fs_devices
From:   syzbot <syzbot+cabf977d00d3db1fdc37@syzkaller.appspotmail.com>
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

HEAD commit:    ef78e5ec9214 ia64: export node_distance function
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1514f733400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c94f9f0c0363db4b
dashboard link: https://syzkaller.appspot.com/bug?extid=cabf977d00d3db1fdc37
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+cabf977d00d3db1fdc37@syzkaller.appspotmail.com

invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 6312 Comm: syz-executor4 Not tainted 4.20.0-rc4+ #132
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:btrfs_close_one_device fs/btrfs/volumes.c:1039 [inline]
RIP: 0010:close_fs_devices.part.44+0x7be/0xa20 fs/btrfs/volumes.c:1063
Code: 48 8d 7b 30 49 89 44 24 18 48 89 f8 48 c1 e8 03 42 80 3c 28 00 0f 85  
bd 01 00 00 48 83 6b 30 01 e9 7a fa ff ff e8 82 85 8c fe <0f> 0b e8 7b 85  
8c fe 0f 0b e8 74 85 8c fe 0f 0b e9 6f fd ff ff e8
RSP: 0018:ffff8881b7b771d8 EFLAGS: 00010212
RAX: 0000000000040000 RBX: ffff8881cdebb300 RCX: ffffc9000dea2000
RDX: 0000000000022db4 RSI: ffffffff82f3057e RDI: 0000000000000007
RBP: ffff8881b7b77380 R08: ffff8881b50d0000 R09: 0000000000000006
R10: 0000000000000000 R11: ffff8881b50d0000 R12: ffff8881bad2b200
R13: dffffc0000000000 R14: fffffffffffffff4 R15: 0000000000000000
FS:  00007fc6d31a2700(0000) GS:ffff8881dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000400200 CR3: 00000001d3b95000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  close_fs_devices fs/btrfs/volumes.c:1095 [inline]
  btrfs_close_devices+0xa1/0x210 fs/btrfs/volumes.c:1081
  btrfs_mount_root+0x13d2/0x1d70 fs/btrfs/super.c:1619
  mount_fs+0xae/0x31d fs/super.c:1261
  vfs_kern_mount.part.35+0xdc/0x4f0 fs/namespace.c:961
  vfs_kern_mount+0x40/0x60 fs/namespace.c:951
  btrfs_mount+0x4a3/0x2136 fs/btrfs/super.c:1670
  mount_fs+0xae/0x31d fs/super.c:1261
  vfs_kern_mount.part.35+0xdc/0x4f0 fs/namespace.c:961
  vfs_kern_mount fs/namespace.c:951 [inline]
  do_new_mount fs/namespace.c:2469 [inline]
  do_mount+0x581/0x31f0 fs/namespace.c:2801
  ksys_mount+0x12d/0x140 fs/namespace.c:3017
  __do_sys_mount fs/namespace.c:3031 [inline]
  __se_sys_mount fs/namespace.c:3028 [inline]
  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3028
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459fda
Code: b8 a6 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 7d 89 fb ff c3 66 2e 0f  
1f 84 00 00 00 00 00 66 90 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 5a 89 fb ff c3 66 0f 1f 84 00 00 00 00 00
RSP: 002b:00007fc6d31a1a88 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fc6d31a1b30 RCX: 0000000000459fda
RDX: 00007fc6d31a1ad0 RSI: 0000000020000740 RDI: 00007fc6d31a1af0
RBP: 0000000020000740 R08: 00007fc6d31a1b30 R09: 00007fc6d31a1ad0
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000004
R13: 0000000000000000 R14: 00000000004d8ef0 R15: 0000000000000003
Modules linked in:
kobject: 'loop1' (0000000014e46057): kobject_uevent_env
kobject: 'loop1' (0000000014e46057): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop1' (0000000014e46057): kobject_uevent_env
kobject: 'loop1' (0000000014e46057): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop1' (0000000014e46057): kobject_uevent_env
kobject: 'loop1' (0000000014e46057): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop1' (0000000014e46057): kobject_uevent_env
kobject: 'loop1' (0000000014e46057): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
---[ end trace 260d74aed8afc1e0 ]---
RIP: 0010:btrfs_close_one_device fs/btrfs/volumes.c:1039 [inline]
RIP: 0010:close_fs_devices.part.44+0x7be/0xa20 fs/btrfs/volumes.c:1063
Code: 48 8d 7b 30 49 89 44 24 18 48 89 f8 48 c1 e8 03 42 80 3c 28 00 0f 85  
bd 01 00 00 48 83 6b 30 01 e9 7a fa ff ff e8 82 85 8c fe <0f> 0b e8 7b 85  
8c fe 0f 0b e8 74 85 8c fe 0f 0b e9 6f fd ff ff e8
RSP: 0018:ffff8881b7b771d8 EFLAGS: 00010212
RAX: 0000000000040000 RBX: ffff8881cdebb300 RCX: ffffc9000dea2000
RDX: 0000000000022db4 RSI: ffffffff82f3057e RDI: 0000000000000007
RBP: ffff8881b7b77380 R08: ffff8881b50d0000 R09: 0000000000000006
R10: 0000000000000000 R11: ffff8881b50d0000 R12: ffff8881bad2b200
R13: dffffc0000000000 R14: fffffffffffffff4 R15: 0000000000000000
FS:  00007fc6d31a2700(0000) GS:ffff8881daf00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004dc418 CR3: 00000001d3b95000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
