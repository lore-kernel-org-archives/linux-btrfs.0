Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794191859;
	b=4c7rQ1/GaGFHlt0XmOhJA8/9i9WiGlboS/F75CF1Y7+eSkcNHl9LMHqDRKL/umA85v76
	 sK7IzZQX/nAOozE0R1ShgwOGeId+Uop+Za2qVUIZBUZDl49428MQ8PWKCbtkSh1gMsy4+
	 7xrhsqUjO+w9lDfSi1yAGf2vu1bju+B8lXPs83FVeVQSDymKgFPLnjBDqcJoRjb8BqC8x
	 j2QPmPMcr4Uv/Kl3eXXmOQmCO2bw7s5cKePjh6EsukbkCs9iKr4bT/wDIRr6l5jV4DVgc
	 gwhEXNYL020IKpaLIrWGfEIpuUhfJ2kaJzLobj73O4i5lSbX3GrqgBwZ3F5uCBAbCbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794191859;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=9rXEcNZzcZAe4iE0p0XDHsc0VjCCW/UujjQm/s4ivWE=;
	b=ZPKH3yNrvQglZOECZeldGn5UxzCEaM7HwWiwUjkNZ0XtiPipc3Jw7jFXcUvhFKZVdBa6
	 7cA6z6hnOHfNn5Ianeu9y/k8LZu9lAOrmfzUUx6LXUslRTLR4yqYhgguse7o5kwUlsoeZ
	 om/f3YFaiTtJslBCoVeTLxHo2sCDp3pIqOexGH0gA9jrLW+EgaQX3ngi53llJ5TdR6DRJ
	 OJC7XkpNbOzuiztLB4HszcI7h4u9rG1uR7m3iM3YEpJOz8F3F6dwlOAldqPhNL1B96Bw+
	 a6XZ8K9BnNZYMANabwv2hx0bAWpj4YjtFEya4I6ik9TjVUxscY6h5Ka8ywb4SBHgcfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC49606A320
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 02:37:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EC49606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4eb0b989f0eso555832b6e.0
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Nov 2026 18:37:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794191858; x=1794796658;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9rXEcNZzcZAe4iE0p0XDHsc0VjCCW/UujjQm/s4ivWE=;
        b=VO7oIUCAclYa4VtVDmcojFDjd8uE4jQSeVX5euU2xD3uBf5bJkXuvbIb2LqWGl6zW3
         I6uar4lripjNfQUvUy5H05G1Au/FIhSyuAppFGV0I2GccRQ+G7HqArS1twXTYhZKQGQW
         oCDz0wlDQVpq/60wZAbN25G+IJTUuvNfVJRdjlaBL903F1eD7FYzSE/jvmxjRcz92OWQ
         GO0vuiPZNJduOugInpV5taOHfr6A8S1ZTNeL8ovtx4orWGVwt2WiMayUBoQpm+X7V6Up
         +QcO7nVSjakSjk7Z9XuvECTK2zf+acFFmULvPAygsy85wLmth1yztrNEwCux8xqaYWSb
         szhA==
X-Forwarded-Encrypted: i=1; AL+hErG7plDF2x/jP+hktlwzBt/2+orM6Ld+1sLzvzWnmwpaKoqiDvX0mJpv6QIxjViDufprTBbMaIIYgq4SFw==@vger.kernel.org
X-Gm-Message-State: APuU4Z+Ty3ZLg7kgQBcECRnZLr33laypt/bP9njN+/SsgWDP1bAG7tEc
	MdtPUl5RKHoZo3NwU/UHkc0WkFqF7xk+WmS6qP9tiJcvNIQPxLMgw8yfjGvZRJcVe6jVmxkhdog
	RWFTvJB5ZDAV4c43c3v8s+5634rHBiAcJwGkHWH6ItzwCvy4js8BSxRP+Hak=
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:518b:b0:495:f8a5:8797 with SMTP id
 5614622812f47-567fcf350damr2647509b6e.0.1794191858336; Sun, 08 Nov 2026
 18:37:38 -0800 (PST)
Date: Sun, 08 Nov 2026 18:37:38 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af131f2.44d55313.247daf.0001.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in btrfs_put_root
From: syzbot <syzbot+55d1814e49f1fc0ba542@syzkaller.appspotmail.com>
To: dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mason@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    fa4ad798f6f6 Merge tag 'for-7.4-rc1-tag' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16f5af35580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d44b06612b68f56
dashboard link: https://syzkaller.appspot.com/bug?extid=55d1814e49f1fc0ba542
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7a262c93f0a1/disk-fa4ad798.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/670f0137c169/vmlinux-fa4ad798.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7b5f342645af/bzImage-fa4ad798.xz

AI-generated root cause summary:
When a Btrfs filesystem encounters a transaction abort (reported in state EA),
inodes being evicted during unmount (particularly via delayed iputs in
close_ctree(), which runs after btrfs_error_commit_super()) fail to persist
their delayed inode updates in btrfs_commit_inode_delayed_inode() because
transaction joining fails. In btrfs_evict_inode(), this error causes execution
to jump directly to the out label, bypassing btrfs_kill_delayed_inode_items().
Because the delayed items remain uncleaned, __btrfs_release_delayed_node()
re-queues the delayed node into delayed_root->node_list and retains a reference,
preventing refcount_dec_and_test() from hitting zero and skipping
xa_erase(&root->delayed_nodes, ...). When the root is finally freed in
btrfs_put_root(), root->delayed_nodes is still non-empty, triggering
WARN_ON(!xa_empty(&root->delayed_nodes)).

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=55d1814e49f1fc0ba542

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+55d1814e49f1fc0ba542@syzkaller.appspotmail.com

BTRFS info (device loop6 state EA): last unmount of filesystem 395ef67a-297e-477c-816d-cd80a5b93e5d
------------[ cut here ]------------
!xa_empty(&root->delayed_nodes)
WARNING: fs/btrfs/disk-io.c:1844 at btrfs_put_root+0x1f9/0x250 fs/btrfs/disk-io.c:1844, CPU#1: syz-executor/6160
Modules linked in:
CPU: 1 UID: 0 PID: 6160 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
RIP: 0010:btrfs_put_root+0x1f9/0x250 fs/btrfs/disk-io.c:1844
Code: c5 0e fe e8 b9 81 a3 fd 48 8d bb 40 05 00 00 90 0f 0b 90 e8 69 98 de 07 e9 9b fe ff ff e8 9f 81 a3 fd 48 8d bb 90 05 00 00 90 <0f> 0b 90 e8 4f 98 de 07 e9 ad fe ff ff e8 85 81 a3 fd 90 0f 0b 90
RSP: 0018:ffffc90006287d18 EFLAGS: 00010293
RAX: ffffffff84258d21 RBX: ffff888079a62000 RCX: ffff8880233e8000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff888079a62590
RBP: 0000000000000001 R08: ffff888079a6262b R09: 1ffff1100f34c4c5
R10: dffffc0000000000 R11: ffffed100f34c4c6 R12: dffffc0000000000
R13: ffff888069f06218 R14: ffff888079a625d8 R15: dffffc0000000000
FS:  000055556295c500(0000) GS:ffff888123509000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007faacae5e000 CR3: 000000001ef0b000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 btrfs_free_fs_info+0x252/0x360 fs/btrfs/disk-io.c:1257
 deactivate_locked_super+0xbe/0x110 fs/super.c:558
 cleanup_mnt+0x204/0x2a0 fs/namespace.c:1396
 task_work_run+0x1d9/0x260 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:70 [inline]
 exit_to_user_mode_loop+0x204/0x770 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:343 [inline]
 do_syscall_64+0x328/0x520 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb8687a0d57
Code: a2 c7 05 9c a9 25 00 00 00 00 00 eb 96 e8 e1 12 00 00 90 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffc6dae6688 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fb8687a0d57
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffc6dae6740
RBP: 00007ffc6dae6740 R08: 00007ffc6dae7740 R09: 00000000ffffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc6dae77d0
R13: 00007fb868836fb3 R14: 0000000000041ae3 R15: 00007ffc6dae7810
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
