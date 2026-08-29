Received: from mail-oa2-f0.google.com (mail-oa2-f0.google.com [74.125.231.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F7C34C815
	for <linux-btrfs@vger.kernel.org>; Sat, 29 Aug 2026 06:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787986294; cv=none; b=bC2DUdYsNd7Lrhx6ccAztpp5wXf8Ku+kTcSeU6vqU8B+Uud3luhw3XdliXmjf9GHXEm/iyJsnBwSUE72FG9xB6vOpeSedSRiAiLxShrqqrf924Lnl9FRAKLAx1SNuxRWcYZPk+jdwgc3ZUi2I7JBNoILEdZwJZYVYQboPizEKpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787986294; c=relaxed/simple;
	bh=RaG3cCxTk1Pxp5UejTh0ZnKVT2Q9kObEuMNXjkmP814=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=cnj8bdEvvNV6f62zJmRyg8IKJbzFPM5ukFfGGDkR+x6rMjCLV5LoqGuJR2uJx6JyaDUFxTKi3f749mhrxsT7OrPzr1F3ay3ZMW9glNafZRHDoksILuedL+sU2+DWpo32x21fA7I17keWN314E1hbhxRDbymSxOnxqaslOKDUkeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa2-f0.google.com with SMTP id 586e51a60fabf-451e8472960so1720443fac.1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2026 23:51:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787986290; x=1788591090;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I1RJh4NMxz256/NN5ztw1Xuztwfbo+VoNZc1DzyQyRA=;
        b=GrxkHphpMwiDmjkm33k6ULFV1MWftmuQt/+Oh0WkrYe7XFV93NpO/9FX8CaL7b8hUs
         YkAb7WTOgnx45opYmM9SPwudN59PiSSyA6O+9H+9DbreJy6SlBYs8YYFSVabYX6+rNLk
         PHHTwVUA9VQCeUP0r52wGbXgzpZbUn2HuKGiFoRI6IFfC8JQ8PohKJHdEP1DaKUJ+Xs9
         Osul6xsmDWEXniaVqOjL5w+mM6LNWYpHLRtDB26XN9oLnutHkp/lZMXYb/a4w0rbE++H
         ZyCUC5RAUYW01CedIH8r2EKbjimC5D83SG0rlSWlSg8SEA98WhJrCSetqEemOcAoLStt
         kC+w==
X-Forwarded-Encrypted: i=1; AHgh+RrydgvSFcBxZelcBgkyfHZSE4nZAEF5IB1CiSOJK0TIcdLNHUnRfSB0LRY4Y4wQRxA5CWE3B+T59yAGCQ==@vger.kernel.org
X-Gm-Message-State: AFuF++n9GSdumYZupEYGABC77YmNKgqfjLUvFYMlb+HXPcn+xomFGwtf
	kyTB31hCdyq/cfifJI5spsE2iLZh+jUcVrq9sVy93fzL9t0AukUroxFo8LbuGNarQJW+rS1Zthx
	sZ61jWWVAmCCb8NzLiYMLD6IFtdMS52Ymkw7U/UMqyWkt7LWxACwzonYTB5U=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:14d1:b0:4b1:b83a:5878 with SMTP id
 5614622812f47-4b39824f060mr14631945b6e.14.1787986290534; Fri, 28 Aug 2026
 23:51:30 -0700 (PDT)
Date: Fri, 28 Aug 2026 23:51:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a928172.1d9ded08.62e62.0104.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in btrfs_add_link (3)
From: syzbot <syzbot+3ae22e13d0d01e5de43c@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1345d625580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c35c7e43de75adb
dashboard link: https://syzkaller.appspot.com/bug?extid=3ae22e13d0d01e5de43c
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-818bebeb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9adea981957f/vmlinux-818bebeb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6676075cd03e/bzImage-818bebeb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3ae22e13d0d01e5de43c@syzkaller.appspotmail.com

------------[ cut here ]------------
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/inode.c:6931 at btrfs_add_link+0x932/0xa50 fs/btrfs/inode.c:6931, CPU#0: syz.0.0/5326
Modules linked in:
CPU: 0 UID: 0 PID: 5326 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:btrfs_add_link+0x932/0xa50 fs/btrfs/inode.c:6931
Code: e2 74 13 41 83 fe fb 74 14 41 83 fe f4 75 15 e8 84 ca ae fd eb 17 e8 7d ca ae fd eb 10 e8 76 ca ae fd eb 09 e8 6f ca ae fd 90 <0f> 0b 90 44 89 f1 f7 d9 e9 10 fe ff ff 89 df 48 c7 c6 c0 22 3d 8f
RSP: 0018:ffffc900060f74e0 EFLAGS: 00010293
RAX: ffffffff84186a51 RBX: ffff8880517d0001 RCX: ffff88803f6a0000
RDX: 0000000000000000 RSI: ffffffff8f3d2260 RDI: 00000000ffffffe4
RBP: ffffc900060f7610 R08: ffff88803f6a0000 R09: 0000000000000003
R10: 00000000fffffffb R11: 0000000000000000 R12: 1ffff110026d8a64
R13: 00000000ffffffe4 R14: 00000000ffffffe4 R15: ffff8880136c5320
FS:  00007f42d43c66c0(0000) GS:ffff88808c30a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005619effb5348 CR3: 000000001287b000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_create_new_inode+0x14a1/0x1ee0 fs/btrfs/inode.c:6864
 btrfs_create_common+0x189/0x310 fs/btrfs/inode.c:6990
 lookup_open+0xc0d/0x1a40 fs/namei.c:4567
 open_last_lookups fs/namei.c:4767 [inline]
 path_openat+0x677/0x1d60 fs/namei.c:4997
 do_file_open+0x23e/0x4a0 fs/namei.c:5029
 do_sys_openat2+0x115/0x200 fs/open.c:1417
 do_sys_open fs/open.c:1423 [inline]
 __do_sys_openat fs/open.c:1439 [inline]
 __se_sys_openat fs/open.c:1434 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f42d359e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f42d43c5fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f42d3826090 RCX: 00007f42d359e0d9
RDX: 000000000000275a RSI: 0000200000000040 RDI: ffffffffffffff9c
RBP: 00007f42d3635024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f42d3826128 R14: 00007f42d3826090 R15: 00007ffc09ee04b8
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
