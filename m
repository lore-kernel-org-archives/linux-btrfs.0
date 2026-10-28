Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793192466;
	b=G5iKJ25l+hd00LR+7ybzqUP5SenymwXy2TcCJssqpc93LQ2Es7YMA28KdmfKF2LQf50U
	 Sf8/hlnE24333qmrW6YPtBjOcNtdcnYQyO9qZvo86ZTYLQ9ciAZyOthCYdVg5MxJdC64b
	 ZJ6RTKj4rugR5iit5NrqN+pMCmCURnayit56bxxuSBPZnNWvEv5QMx6/16ot+g4buoJer
	 Mnisn1nnDs54iOw9A9lqdPYgtY1MpxFyt+UwH8X+O7SoQyvGM9TASEY8M/7XzyAhD67/j
	 rpVXTTEmgyIBAp92qr0Gm9KdAp2frAwoetz4aFQxwxSGhlkl+cCNqG6fITgtbdPl2Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793192466;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=91rCKziwLFQSVS2gxYta1ikY0/KdLARYjdQU5eqpkFs=;
	b=gSDUYHqt/N9H3RJ+HtMB9nvL1KoVcD2qD6JhtbDPchELfA6RkzTgi0sasmp34A6G4sdj
	 sRj8Y5gudQ2mORASk3MJi9CqX/JnyqQ3dGVfuI1/RVKR6ua8e3kxn1S6X+DEOFWSZwpnC
	 it2KZr1j55iHDhwBasmjoBzIYtJxHrBUTASCsm2mkFg5y2Hqor+lJSw4VZZJRYc/9T2TI
	 7u/92c1LVcMIccUKnm+KE9rndZzgh5oBVxC09Fln8yLtyEqiVcA9PzxSW7DSp9GGMXoE2
	 B8zhq8+y2gxVKMrojppoRYK7BfW152HliNuimnNNfdXsSvGIMif3QNz/plro+M1jg2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.71
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B39606A31F
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 13:01:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3B39606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-823d73ffca1so1435501a34.2
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:01:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793192465; x=1793797265;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=91rCKziwLFQSVS2gxYta1ikY0/KdLARYjdQU5eqpkFs=;
        b=cITISIjCoy2LN/ehYzR6Uzsd/oCkTZzwkJJ4+9L5pH+7FB+Vc0NRDksGSHSk1lqJ/Q
         Ci7ZMZBZ2SUz483KRMQgXNf3tmZuxh80MkEgse52hYAMGzGaQIauo3sfclXzoM1kukQd
         Xkx1Sna1W9DKRs69paWBhztN7uQBSD0tZ2utiuGTbADTjUD4Ei7g5xjdQfY/1cVQc6rY
         8hqaN3OxF1iS+oJ40VD5U1ahPdzkl7caoN67dY64bgGuoZw2oqfDr1olrGGhNWwuLY6I
         ftskJh7FcMKo63YdCpIsrRvliuGUnYaK1XpWjNbmfqJdZJRytir9wrx8rGJTwWbLuo/6
         Wl9A==
X-Forwarded-Encrypted: i=1; AKwUvBzso0mwS+Kk7M+g80SOvQ6diRlckoT40Ubzi3khO1nuk5LCpkhk/ReE+bsVO5an/eFBPOemzOpZbPDfmQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLEdpDhyjOaPvOSlMZ526sh2yJFlxgM2QgEEkvRuPeBMZyRZ/MU
	1NG+V+o+qHKc0PQK4a+K577RRD0X3+OIdFhtsq3+6OPAM+UZmMagiSNR28W2pnSd+7oayKxAU9X
	/IcanpecMxtxRxGJWVQciWDGVADLfglPSQCA2VG5l7pSp8x5qcKsQzu7AyfI=
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1804:b0:4a3:3108:866a with SMTP id
 5614622812f47-56383484421mr1347160b6e.17.1793192464894; Wed, 28 Oct 2026
 06:01:04 -0700 (PDT)
Date: Wed, 28 Oct 2026 06:01:04 -0700
In-Reply-To: <20261028121458.23499-1-diasyzhangqing@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae1f210.6200f071.51519.0f63.GAE@google.com>
Subject: Re: [syzbot] [btrfs?] possible deadlock in set_blocksize
From: syzbot <syzbot+5c01398781fb51df783a@syzkaller.appspotmail.com>
To: axboe@kernel.dk, diasyzhang@tencent.com, diasyzhangqing@gmail.com, 
	djwong@kernel.org, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mason@kernel.org, mcgrof@kernel.org, 
	syzkaller-bugs@googlegroups.com, wqu@suse.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in __btrfs_free_extent

------------[ cut here ]------------
ret == -E
ret == -ENOENT
WARNING: fs/btrfs/extent-tree.c:3418 at __btrfs_free_extent+0x1745/0x38a0 fs/btrfs/extent-tree.c:3418, CPU#1: btrfs-transacti/6038
Modules linked in:
CPU: 1 UID: 0 PID: 6038 Comm: btrfs-transacti Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/15/2026
RIP: 0010:__btrfs_free_extent+0x1745/0x38a0 fs/btrfs/extent-tree.c:3418
Code: 84 c0 0f 84 01 03 00 00 e8 d8 88 a8 fd e9 30 0b 00 00 e8 1e ef 8c fd 84 c0 0f 84 0c 03 00 00 e8 c1 88 a8 fd e9 9d 0c 00 00 90 <0f> 0b 90 48 8b 44 24 28 42 80 3c 20 00 4d 8d 75 60 74 08 4c 89 f7
RSP: 0018:ffffc900034d7580 EFLAGS: 00010246
RAX: 00000000fffffffe RBX: ffff88801faee720 RCX: 0000000000000005
RDX: ffffffff8420790e RSI: ffffffff905d9c00 RDI: 00000000fffffffe
RBP: ffffc900034d7730 R08: ffff888021381f40 R09: 0000000000000002
R10: 00000000fffffffe R11: 0000000000000000 R12: dffffc0000000000
R13: ffff88805ad54178 R14: ffff888053e7ddc0 R15: 00000000fffffffe
FS:  0000000000000000(0000) GS:ffff88812372b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000560567923d51 CR3: 000000007caed000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 run_delayed_tree_ref fs/btrfs/extent-tree.c:1824 [inline]
 run_one_delayed_ref fs/btrfs/extent-tree.c:1851 [inline]
 btrfs_run_delayed_refs_for_head fs/btrfs/extent-tree.c:2058 [inline]
 __btrfs_run_delayed_refs+0x1669/0x43a0 fs/btrfs/extent-tree.c:2134
 btrfs_run_delayed_refs+0xdc/0x2a0 fs/btrfs/extent-tree.c:2246
 btrfs_commit_transaction+0x287/0x3010 fs/btrfs/transaction.c:2283
 transaction_kthread+0x2c1/0x460 fs/btrfs/disk-io.c:1586
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


Tested on:

commit:         65ba8f34 Merge tag 'xtensa-20261027' of https://github..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1439e469580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fbcd9c8641bd149b
dashboard link: https://syzkaller.appspot.com/bug?extid=5c01398781fb51df783a
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11607721580000

