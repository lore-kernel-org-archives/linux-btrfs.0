Received: from mail-oi2-f1.google.com (mail-oi2-f1.google.com [74.125.231.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB714A21
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Aug 2026 05:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787462612; cv=none; b=lkrvjVD+E2r7qRyiDVQjxuN8kV47wW9h2iXSP28SNWXME8rCdwBiErNDu46yrT27Wqi/SvHxDZujPtdDlG1/JiwQ4B9bRco+dVuDYDj2v88wx94iEPyw0hpZc8nAFk6SoPTlYrgBDNS1mxz5MAvFGkYahUjWQeTI7sgV9/9TBDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787462612; c=relaxed/simple;
	bh=YHRnf9N26pttZfdeHpvP/B0+j3MQ2IAFUOOaEA4cQU4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ugqEZbg+t+nDdsB7+rZpEJBapR6DPCzOJK6BZ0OE6eYwEOFamAYJ6IPuBX6SFN1b8r7QMbFr28f5huF15eX+8BgfKTpJgrKqcCEYcWUq8We6F0KzYV8y+q+U8qdvdkMMlrdiVfnFr4IvPpA+8haf0NW0/z8dXjTPoY025SfsS4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f1.google.com with SMTP id 5614622812f47-4960a23d5e1so964252b6e.1
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Aug 2026 22:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787462610; x=1788067410;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vAPenxi4wmQCjfRI0xg0HuDHF03meWzTuhX7+m93wuo=;
        b=lmRbxsbfnmnCCRxCZ3DqTdTsKXVGYEytW7Q0idLbRIXM++c1pHlx1fBebod0RJlYHx
         BNZPnhx9Bnv5VjbLi8XF5svv2GXbOCHBbTGJh8aaJEq+mAfUqV8In/quhty++CD95nyi
         3M2jNgUkkTcdNnkG+0fNaM4SbM/4HqWFQnGsJ3JJupIECQxEdPVbPtpodnJtXLDnEE2M
         DHRl78nS+HYIDNsPBkovu/vueXL+eybBZElKauke89dufrCMY/wGF0WS+eVU/R1rOyr8
         m4mKjE1M+lKeZwyKqYLNR/SAvI6vTYLI5ACDk5PQoEZsV/ixLYE3XwijYarmsmrm7S0X
         SIFg==
X-Forwarded-Encrypted: i=1; AHgh+RrD6eTEAGLD+TSBr0EGXC4HOdOF7qL7Pz5GULQP0/gQc28SzkLaIDJ7lqrEy4SkyhhaUp8zEnV4wRTBdw==@vger.kernel.org
X-Gm-Message-State: AFuF++mUiDDl9b2rQgafFrIfIkhRem2atUBlIh6UtbP7Q9HX56dFCDgg
	olPd+7am1EqPSFHdyelaOF87nsPy4pEw8SUnXaN1O3heRNXmXO+EF0xWd7MmTz1Eo6GH5FcIVBl
	lVe3UnG3S+LBIZZNQBcnIdkhCyAAlH+2lxVoy6iNOAHYd6KzUvZ0ofgPUP6g=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4fe6:b0:490:af61:8830 with SMTP id
 5614622812f47-4b3099d262fmr11612658b6e.3.1787462610382; Sat, 22 Aug 2026
 22:23:30 -0700 (PDT)
Date: Sat, 22 Aug 2026 22:23:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8a83d2.91706f20.16b6e3.02c2.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in btrfs_add_to_free_space_tree (2)
From: syzbot <syzbot+554a2e08e4abc56984a9@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14f18415580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c35c7e43de75adb
dashboard link: https://syzkaller.appspot.com/bug?extid=554a2e08e4abc56984a9
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-818bebeb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9adea981957f/vmlinux-818bebeb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6676075cd03e/bzImage-818bebeb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+554a2e08e4abc56984a9@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
BTRFS: device fsid 395ef67a-297e-477c-816d-cd80a5b93e5d devid 1 transid 8 /dev/loop0 (7:0) scanned by syz.0.0 (5311)
BTRFS info (device loop0): first mount of filesystem 395ef67a-297e-477c-816d-cd80a5b93e5d
BTRFS info (device loop0): using sha256 checksum algorithm
BTRFS info (device loop0): rebuilding free space tree
BTRFS info (device loop0): enabling ssd optimizations
BTRFS info (device loop0): using spread ssd allocation scheme
BTRFS info (device loop0): turning on async discard
BTRFS info (device loop0): enabling free space tree
BTRFS info (device loop0): force clearing of disk cache
loop0: detected capacity change from 32768 to 32767
------------[ cut here ]------------
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/free-space-tree.c:1050 at btrfs_add_to_free_space_tree+0x4e1/0x5b0 fs/btrfs/free-space-tree.c:1050, CPU#0: syz.0.0/5311
Modules linked in:
CPU: 0 UID: 0 PID: 5311 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:btrfs_add_to_free_space_tree+0x4e1/0x5b0 fs/btrfs/free-space-tree.c:1050
Code: e2 74 1a 41 83 fd fb 74 0d 41 83 fd f4 75 15 e8 65 ba 8c fd eb 17 e8 5e ba 8c fd eb 10 e8 57 ba 8c fd eb 09 e8 50 ba 8c fd 90 <0f> 0b 90 44 89 e9 f7 d9 4c 8b 24 24 e9 95 fe ff ff 89 d9 80 e1 07
RSP: 0018:ffffc9000f29f3f0 EFLAGS: 00010287
RAX: ffffffff843a7a70 RBX: ffff888051a74001 RCX: 0000000000100000
RDX: ffffc9000e901000 RSI: 00000000000038d7 RDI: 00000000000038d8
RBP: ffff88801276a5e0 R08: ffff88801f99cb00 R09: 0000000000000003
R10: 00000000fffffffb R11: 0000000000000002 R12: ffff8880138e2db8
R13: 00000000ffffffe4 R14: ffff88801fc77630 R15: 1ffff110024ed4c8
FS:  00007f00ab5f36c0(0000) GS:ffff88808c30a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f00ab5b0fe8 CR3: 0000000043b27000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 do_free_extent_accounting fs/btrfs/extent-tree.c:3191 [inline]
 __btrfs_free_extent+0x1461/0x39c0 fs/btrfs/extent-tree.c:3558
 run_delayed_tree_ref fs/btrfs/extent-tree.c:1824 [inline]
 run_one_delayed_ref fs/btrfs/extent-tree.c:1851 [inline]
 btrfs_run_delayed_refs_for_head fs/btrfs/extent-tree.c:2058 [inline]
 __btrfs_run_delayed_refs+0x166c/0x43b0 fs/btrfs/extent-tree.c:2134
 btrfs_run_delayed_refs+0xdc/0x2a0 fs/btrfs/extent-tree.c:2246
 btrfs_commit_transaction+0x28a/0x30b0 fs/btrfs/transaction.c:2256
 btrfs_quota_enable+0x10ff/0x1e20 fs/btrfs/qgroup.c:1237
 btrfs_ioctl_quota_ctl+0x186/0x1f0 fs/btrfs/ioctl.c:3566
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f00aa79e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f00ab5f2fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f00aaa25fa0 RCX: 00007f00aa79e0d9
RDX: 00002000000000c0 RSI: 00000000c0109428 RDI: 0000000000000003
RBP: 00007f00aa835024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f00aaa26038 R14: 00007f00aaa25fa0 R15: 00007ffd0ce801f8
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
