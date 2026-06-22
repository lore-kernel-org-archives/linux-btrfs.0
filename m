Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7401C2324
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 17:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782147688; cv=none; b=lTm1oL/PovbG8ZGiCPr+TXXo3qtQ1sUT1jeHW1yZ//7tmWlxBqgqhNhCzdrwTCXOaCtgSJS2jflJUvUAmMPOgjbeW4MU0b/4ka4Sxi3JGu8ACXQ+bDTDTglNnu+aSNmQIVa8cWfFEZfVUWYGQTP+UZdpBpWku3YRFB+UQlEGIDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782147688; c=relaxed/simple;
	bh=+4BL8mNe2GpceLMa+B1YZt8aHMj9287TCyLUK2gE5do=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=MQTA1vYYD//dIxc7tDryMG0BpTlLC5XHQDvSLITlRca6muDeVjffXo6MzZNOUgMnQJTnb2lw8KfugwfW1l32NLCA/tZlEJqqyLxOAWJxn4zTGeGUhVYLH18cjEV1z5sQ1NzfP+2szx7SH/LTWgDwtOiP+c5IeZOPVSs1fwgAmQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7e93d7611beso5285684a34.0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 10:01:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782147686; x=1782752486;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9tCt6cV25/HObsnQZBNmdsWShs7zz4P+Smlgan5RGhg=;
        b=ojvS7lKqngFifEBoPLVNMuc9xugWtjo1awUUXINM9qRf29p5841Vp0lboLhZrzM2Vd
         SoSSMInepkqAFjdOJ3v6gyFuek9ix68H+eqxNnJLWk+wlG/Sfg3c8G0FEdhN519/jBRu
         RslW21jWu6Fq2gakOIqnESwGhVFVKRZEsxXVxJFVNzE9yqHAE+WI/7jTyiZlhFKbNnhJ
         HtOvC7ufLJpSj1MMATqKga+627KdOjN0vsHlIocLl3Vj8KFYTLhyFKQFNZ8H7ULICmyF
         JoN0Aw+hSuAfBnXQeqjK2c7cDf02uFUWpRDo/bsHKeFjh4MbMRNdxqFm8+FeexgZ07Bv
         nIMQ==
X-Forwarded-Encrypted: i=1; AFNElJ+nWTI9z35utLcOeetyVnj/vz1gFH01YUfCFHG1UnB0nVji+gZtGwCJtaP84bDo00KHRgeVaA96vzJKFw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbSimd6Ma6fPZy9N7kcIUkfFj5J5KXifIqIS8AHYSETto+IJH3
	nIGkwpv9S+6U3DOD8mID3twZXdNu2NRR0ISUhSyG3UnxBkIj3ukr3HmMWIn4WJecfvscaKpG9z2
	/Pl57+GD+ZbERo2CiSL38M9cudqQZo2cT81LQzad5gVR7uw09Z7wILVM1JSc=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6830:3749:b0:7de:84b5:88e3 with SMTP id
 46e09a7af769-7e92d879fdfmr13601632a34.8.1782147685799; Mon, 22 Jun 2026
 10:01:25 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a396a65.52ae72c2.136ac7.0001.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in can_finish_ordered_extent
From: syzbot <syzbot+085adc3f91549d11066a@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1a3746ccbb0a Merge tag 'strncpy-removal-v7.2-rc1' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=113256ae580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5fece1a9477c321
dashboard link: https://syzkaller.appspot.com/bug?extid=085adc3f91549d11066a
compiler:       Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b66ba1580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=108f07f2580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-1a3746cc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/376997b632fc/vmlinux-1a3746cc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0920309c4838/bzImage-1a3746cc.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d394e1f93e2a/mount_2.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=10adbeae580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+085adc3f91549d11066a@syzkaller.appspotmail.com

------------[ cut here ]------------
len > ordered->bytes_left
WARNING: fs/btrfs/ordered-data.c:390 at can_finish_ordered_extent+0x409/0x830 fs/btrfs/ordered-data.c:390, CPU#0: kworker/u4:9/1149
Modules linked in:
CPU: 0 UID: 0 PID: 1149 Comm: kworker/u4:9 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: btrfs-endio simple_end_io_work
RIP: 0010:can_finish_ordered_extent+0x409/0x830 fs/btrfs/ordered-data.c:390
Code: 00 00 00 e8 09 81 c8 fd eb 05 e8 02 81 c8 fd 4d 85 ed 0f 94 c0 48 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f 5d e9 09 92 b5 07 cc 90 <0f> 0b 90 e8 2f fd ad fd 48 8d 05 00 00 00 00 48 c7 c7 a0 9b 95 8e
RSP: 0018:ffffc900015bf968 EFLAGS: 00010287
RAX: ffffffff83fdc133 RBX: 1ffff11007f3479e RCX: ffff888032faa540
RDX: 0000000000000000 RSI: 0000000000006000 RDI: 0000000000071000
RBP: 1ffff11007f347a3 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff520002b7f2c R12: ffff88803f9a3cf0
R13: fffffffffff95000 R14: 1ffff110084b063c R15: 0000000000071000
FS:  0000000000000000(0000) GS:ffff88808c848000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb7eda7a000 CR3: 00000000439b1000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_finish_ordered_extent+0xed/0x420 fs/btrfs/ordered-data.c:438
 end_bbio_data_write+0xad3/0xc80 fs/btrfs/extent_io.c:538
 btrfs_bio_end_io+0x3ea/0x4d0 fs/btrfs/bio.c:147
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
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

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
