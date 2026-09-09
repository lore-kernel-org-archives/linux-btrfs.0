Received: from mail-oa2-f11.google.com (mail-oa2-f11.google.com [74.125.231.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D00B57F72E
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2026 16:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788971011; cv=none; b=ljCwK8kecKf0WIt+p38TbBgz0Ihm9ScXGJxSvPZpt97pVNMVnPdIckoVBBxQIyQL7nS41YCO7fqGyQrtLcZlu2iOOGE+bUcVVugKaRpC28GHOdlPzEAJoaQUgi0eQAQbMc8dHpNwTsv1yxB0+oOpmsjIwdDuTKFsBtbp7K4vkI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788971011; c=relaxed/simple;
	bh=oaGo8KM3tzT1v4KW6W0TwDjAO2KG2eStbpOP1rhD5d4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dyvfBmGem6Iu+HlDXQyBNnUZHpWNPoXwRJcA4Gokij9bbjvKkocTpneabYey580o/DlhdkSm57Q/nrVkX/zvELPZadN4sFBHQwSHV2IPg6BArDVQpJPujX8yoWIRRHaIKWtYRmzHwZuHP4BZX0csNwrxAXI//QqFlL5SsEw5jcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa2-f11.google.com with SMTP id 586e51a60fabf-46a6530ebd4so2440871fac.0
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2026 09:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788971008; x=1789575808;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lREkKVmhvhqI0pDdd9RfpS/MYmM7XqN/j1JTFiPMYP4=;
        b=e+zjaWzJoqf3qBOK1Xtx8PmuSEcfCPEMZl7V/KgqN3iVydPF+fGo2NqvYxJcmDo7Pb
         b3X0su0gZTZ4tZ1OtPG5xJoKrh3SB+/kFe/9dR6xVIWE4ds3uetKiZU+ApqWmZCgWaxw
         NU8qv9Om3guNlv9UWepM/XENdC7SYv6RCBOZiN0nn9eQ3IpAF/IwGVT08F9D3edHSP1l
         BPxE8KIMQV2Tx+DHzI4UEM0jj9vGKQWoYS2YdxhezxVVaiZou/9QRcbnoyDHjwONdHuy
         /sqCK22KPk+j8T+IOTEs8wEIuyJBimsALAZYa3sej+jksCS+AS2Y3TCWe4us/fZSnn3z
         BQGg==
X-Forwarded-Encrypted: i=1; AKwUvBx0BGRWoYpoR6sRM3/vsMFqR7kGmlYZeS7GSEcXDeLTPcZFKADSI3/GvkJtUz/1TNv3bMw4TLnPQebF9A==@vger.kernel.org
X-Gm-Message-State: AFuF++mhANkLOXuD/2EGJX4ZyejOQgCR7J6lRVQEGWhPnJ1mrouqyXkc
	/Da/Y2cB9MmWEwH43QGy3LsnKxl0YXMq0r6w8Nfnd/Bss/YqVLbfvtK3jx16U3wMEhMV0POTQWo
	4B3+vNYwGuolGi4GV1nDK1s/ifR56EYmjlyPV8/7vxhyBKnkZJcfnhdgURV4=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c8f:b0:6b3:4494:cf2a with SMTP id
 006d021491bc7-6b6f99d5985mr23417979eaf.4.1788971008119; Wed, 09 Sep 2026
 09:23:28 -0700 (PDT)
Date: Wed, 09 Sep 2026 09:23:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa18800.f2639fcc.29487d.000c.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in btree_csum_one_bio (2)
From: syzbot <syzbot+5fd974495fd56ec60faf@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4d7d9486c04d Merge tag 'integrity-v7.3-rc2' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11151125580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e909ffe6b35dddb7
dashboard link: https://syzkaller.appspot.com/bug?extid=5fd974495fd56ec60faf
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-4d7d9486.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/917d10b186d9/vmlinux-4d7d9486.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1b81d8989e9e/bzImage-4d7d9486.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5fd974495fd56ec60faf@syzkaller.appspotmail.com

	item 7 key (263 EXTENT_DATA 17633280) itemoff 3504 itemsize 53
		generation 9 type 1
		extent data disk bytenr 6729728 nr 65536
		extent data offset 0 nr 65536 ram 65536
		extent compression 0
	item 8 key (263 EXTENT_DATA 17698816) itemoff 3451 itemsize 53
		generation 9 type 1
		extent data disk bytenr 6795264 nr 4096
		extent data offset 0 nr 4096 ram 4096
		extent compression 0
	item 9 key (263 EXTENT_DATA 17702912) itemoff 3398 itemsize 53
		generation 9 type 1
		extent data disk bytenr 6799360 nr 36864
		extent data offset 0 nr 36864 ram 36864
		extent compression 0
	item 10 key (263 EXTENT_DATA 17739776) itemoff 3345 itemsize 53
		generation 9 type 1
		extent data disk bytenr 6840320 nr 12288
		extent data offset 0 nr 12288 ram 12288
		extent compression 0
	item 11 key (263 EXTENT_DATA 17752064) itemoff 3292 itemsize 53
		generation 9 type 1
		extent data disk bytenr 6852608 nr 16384
		extent data offset 0 nr 16384 ram 16384
		extent compression 0
	item 12 key (263 EXTENT_DATA 17768448) itemoff 3239 itemsize 53
		generation 9 type 1
		extent data disk bytenr 6868992 nr 8192
		extent data offset 0 nr 8192 ram 8192
		extent compression 0
	item 13 key (263 EXTENT_DATA 17776640) itemoff 3186 itemsize 53
		generation 9 type 1
		extent data disk bytenr 6885376 nr 49152
		extent data offset 0 nr 49152 ram 49152
		extent compression 0
	item 14 key (263 EXTENT_DATA 17780736) itemoff 3133 itemsize 53
		generation 9 type 1
		extent data disk bytenr 6885376 nr 49152
		extent data offset 4096 nr 45056 ram 49152
		extent compression 0
	item 15 key (263 EXTENT_DATA 17825792) itemoff 3080 itemsize 53
		generation 9 type 1
		extent data disk bytenr 0 nr 0
		extent data offset 0 nr 15765504 ram 15765504
		extent compression 0
	item 16 key (18446744073709551606 EXTENT_CSUM 5279744) itemoff 3016 itemsize 64
		range start 5279744 end 5287936 length 8192
BTRFS error (device loop0): block=5324800 write time tree block corruption detected
------------[ cut here ]------------
IS_ENABLED(CONFIG_BTRFS_DEBUG) || btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID
WARNING: fs/btrfs/disk-io.c:328 at btree_csum_one_bio+0x9d6/0xd10 fs/btrfs/disk-io.c:327, CPU#0: kworker/u4:13/1059
Modules linked in:
CPU: 0 UID: 0 PID: 1059 Comm: kworker/u4:13 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: btrfs-worker btrfs_work_helper
RIP: 0010:btree_csum_one_bio+0x9d6/0xd10 fs/btrfs/disk-io.c:327
Code: ff 89 c6 e8 bc ef b0 fd 45 85 f6 75 07 e8 b2 ea b0 fd eb 42 80 3d bc c1 4c 0c 01 75 15 e8 a2 ea b0 fd eb 32 e8 9b ea b0 fd 90 <0f> 0b 90 e9 35 fc ff ff e8 8d ea b0 fd c6 05 99 c1 4c 0c 01 48 c7
RSP: 0018:ffffc90005337920 EFLAGS: 00010293
RAX: ffffffff8416e195 RBX: fffffffffffffffa RCX: ffff88803668a580
RDX: 0000000000000000 RSI: fffffffffffffffa RDI: fffffffffffffffa
RBP: ffffc900053379f8 R08: 5400000000000000 R09: 0000000000000000
R10: 0000000000008000 R11: ffffffff8ec362b8 R12: ffffffff8416de4b
R13: 00000000ffffff8b R14: ffff888011f5505f R15: ffff88801fcc3560
FS:  0000000000000000(0000) GS:ffff88808c2cd000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc45c458d20 CR3: 0000000050cdc000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_bio_csum fs/btrfs/bio.c:601 [inline]
 run_one_async_start+0x91/0x130 fs/btrfs/bio.c:635
 btrfs_work_helper+0x3a2/0xc50 fs/btrfs/async-thread.c:312
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
