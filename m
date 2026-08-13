Received: from mail-ot1-f77.google.com (mail-ot1-f77.google.com [209.85.210.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C8D18A6A8
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2026 00:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786579778; cv=none; b=K7akhfwr1Nb3aZyli/SiQ7i9RFkJeL3VwPPsIkLoPRQDiIaFIKVB3MHYDrxG3f+D9niWOcWyTtje3cpPs0mjAzot3Y6jbeckehsfwDm2AVxPn4yDUi24vJ1uMjFzQBnSpzKefFavRD0zQaljnICzlPHJNvypR8WJ5LbE6yCNdjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786579778; c=relaxed/simple;
	bh=rhbPH4U6bhvoQzSF8tJM7aeDYtj9AhoIWDhg9O0iU10=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=g9zRRmVgzpSX/TGZjRMNcJ1ZPfynh4clGWX6fTS8HqdRNbbT9ZWSIHb/S+Hwcnu+sbG8DaOOavd+l0fIqp1MpHOUgYIoIdnH72Hb+e6g7T6N3TRQzRbSXDzhl0DarP3hEr3VjLLevGm99py5JMbmlM0y1fkFkqn01Dd60k+e6fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f77.google.com with SMTP id 46e09a7af769-7ee50225cc7so1928480a34.1
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 17:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786579776; x=1787184576;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=19VMDZTjk0Pq9kHEvCgcs7IHJnrCT2MrgQTF+3ntfmM=;
        b=qboPFuFtJjE6n+JiQtWOfA/hLOvo25Z9FKiMDHy2hRca53wbNrGYLMJvrYUPXEgWfh
         iadYuFZROAjhp2MyhWQN6vycvY3ZCvIEMdS0w2z42LsTFzYS17jkHvJ/WTR9WtzDUy5h
         VwP33EeNlYvgQKsgvm1zOh5CxV3UVjDWyJkk0GQNrnftRJv13bwUlo4IdFKS8FTFOo3h
         2IH+9R/5sXwG7JLJYeSLThjL8n8HfvXi2O2BKH2sfwQe5NGK+dRp0+DGW+hgMG492Qza
         Nx+Laf2lYGyB6SjNiBIM3pbwRBE34pb/JUn0dms0AQ4Iw/VCrjBvDcQ7a5iQQzTQv0i0
         O/6Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro3KDJYfVo8QF79J6DzUFM0P9sjD2EcLnLtNMxBti0nWmVinJuA5kkM0CfCtO+mLyketgz3+ybSE4Bk1A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxdYg6s+oZS60gvfNqo1W3Z+gSfYIry3/UWvZuuwTsFp8UlTd2H
	QUPXhH5/6XQyC2ddxR7shVMzdD/BC/U/JtQOIW292QF64ekfJKFVV6z1hSaHvKw/2rK2Ay3DooJ
	NSQTRrVRGPFv7lN9lTNT9friFKLdL9wBlxw5wihVNBOUya8E3r+Z9GNqEeds=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:ee84:0:b0:6ae:42c7:ef83 with SMTP id
 006d021491bc7-6b0c3cd77a8mr2611683eaf.0.1786579776023; Wed, 12 Aug 2026
 17:09:36 -0700 (PDT)
Date: Wed, 12 Aug 2026 17:09:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7d0b40.ac361c09.22ff0a.004e.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in __cow_file_range_inline (2)
From: syzbot <syzbot+90ab2ca74c4ca62b395f@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a59f57e2aa12 Merge tag 'watchdog-for-v7.2-rc7' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11370079580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a59830cba91a1981
dashboard link: https://syzkaller.appspot.com/bug?extid=90ab2ca74c4ca62b395f
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-a59f57e2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3b0b58b842b2/vmlinux-a59f57e2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/48759b65e153/bzImage-a59f57e2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+90ab2ca74c4ca62b395f@syzkaller.appspotmail.com

x_tables: ip_tables: owner match: used from hooks PREROUTING, but only valid from OUTPUT/POSTROUTING
------------[ cut here ]------------
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/inode.c:641 at __cow_file_range_inline+0xef0/0x1000 fs/btrfs/inode.c:641, CPU#0: syz.0.0/5319
Modules linked in:
CPU: 0 UID: 0 PID: 5319 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__cow_file_range_inline+0xef0/0x1000 fs/btrfs/inode.c:641
Code: e2 74 39 41 83 fd fb 74 3a 41 83 fd f4 75 3b e8 86 04 b3 fd eb 3d e8 7f 04 b3 fd eb 10 e8 78 04 b3 fd eb 09 e8 71 04 b3 fd 90 <0f> 0b 90 44 89 e9 f7 d9 4c 8b 7c 24 18 e9 d4 fd ff ff e8 59 04 b3
RSP: 0018:ffffc9000eb5ec80 EFLAGS: 00010283
RAX: ffffffff84140e6f RBX: 1ffff92001d6bda0 RCX: 0000000000100000
RDX: ffffc90020001000 RSI: 00000000000010b8 RDI: 00000000000010b9
RBP: ffffc9000eb5ee70 R08: ffff888000ef4a80 R09: 0000000000000003
R10: 00000000fffffffb R11: 0000000000000002 R12: dffffc0000000000
R13: 00000000ffffffe4 R14: ffff888052a24001 R15: ffff888013211d10
FS:  00007fed310f66c0(0000) GS:ffff88808c549000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000000c2c0 CR3: 0000000012e06000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 run_delalloc_inline fs/btrfs/inode.c:2351 [inline]
 btrfs_run_delalloc_range+0x1a84/0x1fd0 fs/btrfs/inode.c:2407
 writepage_delalloc+0x10a4/0x1c60 fs/btrfs/extent_io.c:1671
 extent_writepage fs/btrfs/extent_io.c:2043 [inline]
 extent_write_cache_pages fs/btrfs/extent_io.c:2706 [inline]
 btrfs_writepages+0x1667/0x28b0 fs/btrfs/extent_io.c:2838
 do_writepages+0x338/0x560 mm/page-writeback.c:2571
 filemap_writeback mm/filemap.c:387 [inline]
 filemap_fdatawrite_range+0x1ef/0x2f0 mm/filemap.c:412
 btrfs_fdatawrite_range+0x54/0xf0 fs/btrfs/file.c:3884
 btrfs_direct_write+0x69d/0xc20 fs/btrfs/direct-io.c:1038
 btrfs_do_write_iter+0x325/0x790 fs/btrfs/file.c:1449
 do_iter_readv_writev+0x612/0x8c0 fs/read_write.c:-1
 vfs_writev+0x343/0x990 fs/read_write.c:1058
 do_writev+0x154/0x2e0 fs/read_write.c:1104
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fed3019e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fed310f5fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 00007fed30426090 RCX: 00007fed3019e0d9
RDX: 0000000000000001 RSI: 0000200000000040 RDI: 0000000000000005
RBP: 00007fed30235024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fed30426128 R14: 00007fed30426090 R15: 00007ffcf827f4e8
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
