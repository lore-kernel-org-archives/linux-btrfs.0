Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793177973;
	b=xD7r1fg4Vs83mAwCO0yiAlfdl7ihgD3p/+8sP1KlHz/XGq1cAeDdUfUeklAOXljncpPr
	 YTxWDkWAR6ekdikxQuZLGa2B2+BjrrVnDjslJBmGx78DPIlS5E+Il9Zsi/nz1J4dQR0Ku
	 9M5XzKPrcFWelHDJRoprfowwEZU5HNAP3CCvG8OsdsJiDwHj9zScGccNcByFO2y2g+pF8
	 bIDQCKKSOSQyN2b1KBXSHptwap1uUdAIFO1yV51Hk18+5gF3kWfwwENONTIBMFUEaVXIX
	 8rfR6uSquW0xC3ujxbv2yI36zy9F1f5M8S0YWP3cRPYHmhpzm2tU1qs3f1B4E5tQAIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793177973;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=RiNXpN9laP8Jfj7XRLDYlapATM5DZemLq0Y788hUrRg=;
	b=X6IZFZ9YQOdgCd++++UrRPAMVnfds+rksjUQ/BP1sc/wqnYJ/EEhxOKpqeFd8SawnB6F
	 Yn4+xjVW34iqflgc/8yPiFg9rAqh5CmyjGDwo1DjdGXSSTrpiZAVfVa9cY0jH0OjZo0lu
	 OaXhZb8kemKvAKZRH8oR6MhpNSjQEtcWZbKDBKfRQ1MmzOVEw44tjiVwNj/dYuWAd7Baz
	 epcQqXU0KczNhVv6tu2adNcfdxjzh9LpNJNOIshv/cc4P83YDXSXNhAAgrJkGWBSfpJP/
	 A4zinAbLIJlQ91NL/Vuhu0NPz640bfQJgVFD3spPmvx542Wl3s3rXim7p41cqT6yeMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.71
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08456606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 08:59:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08456606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-81b50ab16edso942695a34.3
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 01:59:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793177972; x=1793782772;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RiNXpN9laP8Jfj7XRLDYlapATM5DZemLq0Y788hUrRg=;
        b=LoLZIED2muQuNT3uHvZGbmn0sz5G0OV+ejbMEghAHvpbuEmPHhotOabl3gCSk1Yno7
         5/5Gk6AHcbax/op0qbVP4dPGqT5URHwEt2GIPm/BTrYeY1O4i107szZ5PDB611PNGv0u
         y6QVpwL3rnzW9bSS1MjdhxMKtTstXcZ9aIjdYmZmehxfGMYvQV+fiLYfCd6SLutlZwXW
         LnC047R4blBq0axCnzhWRv+yBPFfdjR9D4CA0w2E/V/Dz8TOp2UkNEj2yByxx7b50+Qu
         9ukNkW1dQW/F4kLLai4arFdP9lSrBeRkPeCaXP7JhnOjSbD8i1l4LPEczYA/goQ0vVvt
         6Rjw==
X-Forwarded-Encrypted: i=1; AKwUvByJN4O7uwG9KGS9HAtiFy+Wuf/qQNbVMwMCamI5INTsxciCEy8+dZzLrIFukvp6EnMcSMcbp8V/p+uoUw==@vger.kernel.org
X-Gm-Message-State: AFq9FYK+pz3lU6f7LAXZpwYO0JcHTzN3NXJK6ylsCqTg6ZIKkZlDlwkM
	/rmXbL+O6jI6yoOsJocCPeWMIkzzCTV9FQARylpF3nYjpI+Sy03F7S2qHaBEDtqPREoeZLxN0ho
	vy7DT8Xkzy1pftfF5pNqQ+xnPUfTMwEH8AlDDXJNhMjyHOa2wCZTeS1bpc1c=
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:5181:b0:53c:af69:84e2 with SMTP id
 5614622812f47-5637e8f9974mr1122691b6e.6.1793177971994; Wed, 28 Oct 2026
 01:59:31 -0700 (PDT)
Date: Wed, 28 Oct 2026 01:59:31 -0700
In-Reply-To: <6a8a83d2.91706f20.16b6e3.02c2.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae1b973.768774f5.3237ab.004f.GAE@google.com>
Subject: Re: [syzbot] [btrfs?] WARNING in btrfs_add_to_free_space_tree (2)
From: syzbot <syzbot+554a2e08e4abc56984a9@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    65ba8f34ec88 Merge tag 'xtensa-20261027' of https://github..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=13253ee1580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9050e63bb81bd52
dashboard link: https://syzkaller.appspot.com/bug?extid=554a2e08e4abc56984a9
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1116e469580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+554a2e08e4abc56984a9@syzkaller.appspotmail.com

BTRFS info (device loop0): turning on async discard
BTRFS info (device loop0): enabling free space tree
------------[ cut here ]------------
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/free-space-tree.c:1050 at btrfs_add_to_free_space_tree+0x4e1/0x5b0 fs/btrfs/free-space-tree.c:1050, CPU#0: syz-executor158/5666
Modules linked in:
CPU: 0 UID: 0 PID: 5666 Comm: syz-executor158 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:btrfs_add_to_free_space_tree+0x4e1/0x5b0 fs/btrfs/free-space-tree.c:1050
Code: e2 74 1a 41 83 fd fb 74 0d 41 83 fd f4 75 15 e8 d5 f7 7d fd eb 17 e8 ce f7 7d fd eb 10 e8 c7 f7 7d fd eb 09 e8 c0 f7 7d fd 90 <0f> 0b 90 44 89 e9 f7 d9 4c 8b 24 24 e9 95 fe ff ff 89 d9 80 e1 07
RSP: 0018:ffffc90001f5f410 EFLAGS: 00010293
RAX: ffffffff844b2d30 RBX: ffff88800c15c001 RCX: ffff88804022cb00
RDX: 0000000000000000 RSI: ffffffff90818f40 RDI: 00000000ffffffe4
RBP: ffff888013dc88d0 R08: ffff88804022cb00 R09: 0000000000000003
R10: 00000000fffffffb R11: 0000000000000000 R12: ffff88800fcb2790
R13: 00000000ffffffe4 R14: ffff888035d692c0 R15: 1ffff110027b9126
FS:  0000555563bef400(0000) GS:ffff88808aa11000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0b1e41a000 CR3: 0000000013f09000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 do_free_extent_accounting fs/btrfs/extent-tree.c:3187 [inline]
 __btrfs_free_extent+0x1422/0x38a0 fs/btrfs/extent-tree.c:3554
 run_delayed_tree_ref fs/btrfs/extent-tree.c:1824 [inline]
 run_one_delayed_ref fs/btrfs/extent-tree.c:1851 [inline]
 btrfs_run_delayed_refs_for_head fs/btrfs/extent-tree.c:2058 [inline]
 __btrfs_run_delayed_refs+0x1669/0x43a0 fs/btrfs/extent-tree.c:2134
 btrfs_run_delayed_refs+0xdc/0x2a0 fs/btrfs/extent-tree.c:2246
 btrfs_commit_transaction+0x287/0x3010 fs/btrfs/transaction.c:2283
 btrfs_quota_enable+0x1274/0x1f70 fs/btrfs/qgroup.c:1241
 btrfs_ioctl_quota_ctl+0x186/0x1f0 fs/btrfs/ioctl.c:3581
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f559f52b9fb
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007ffdce719570 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f559f52b9fb
RDX: 00007ffdce7197b0 RSI: 00000000c0109428 RDI: 0000000000000004
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdce719820
R13: 0000000000000004 R14: 00007ffdce719a70 R15: 00007ffdce7198c0
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
