Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793453442;
	b=YTgcE9OpT6gFINeanW7uCh6f7V7UqD8nJ1L96a1CXjCuOgHmbqYQinEDJl9bKTzlUd5T
	 H+J4UpvRNsgcVtSApJjE72QxOKrXSJ80v4+uU3x1wjxGfpabLTyDvAGJdZPeZDXe5anlm
	 kbkmUyJ+U6+3ihaDiV4tAyOVe/EqAAr/jF4uVZy8VsALfSEMuktekDGyyxzA1VuojCNPx
	 D5Y57kvZMAyED2g8GBEiliFruK2r947fse/gWf1hVNv8P7QDEb7+Zk1SNiZeX3pD1W0Ry
	 ls96VBBN2baqPLW0A8vGDFIapParuvWyaE7hpDONk3Ok9is5thjEuJWOztD1OpHAApA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793453442;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=8pfUsnr9tdOmGaNwEWjLs1OKNwnTF5JIb3eCI5kWqIg=;
	b=UjI2Ghwcx9whxfzEYm7t1PVcXMp84U1RtQSe6cSg99AIi91DWRDDVdER/YjxYSaLk7CT
	 +YPyB34wFyw0VyiknJ1RQvl7Ijmqs3LeRxbAecfxfCkTxLEATe9fug1t1GOiqnJL5PAPw
	 mzxfIVReFaKMpV9/TzM8WbGDFH7cpBRaAsdBfpAHW6HiqD8aQqM+ImMXYu/nAyu25N53r
	 XoUGJFjvI38c8eQxEyVfkc37IA6+BYEx0eQbXMN2kYpXijB54TQJhlxs0CtCyK5chWyag
	 8qhIvLoR5FqkM4x3lkDK6gRXVp/fgzq6YWocKoTimqUfAv6Ifro3GAQF/tb236968PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448C5606A31D
	for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2026 13:30:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 448C5606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4cbf700ddccso1404961b6e.0
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2026 06:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793453441; x=1794058241;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8pfUsnr9tdOmGaNwEWjLs1OKNwnTF5JIb3eCI5kWqIg=;
        b=lNU4o7Lgu3IKiqpP/VxC5HWYIMsP5SuIjld88OFYUaCYqTnGz0hEZDbI1Jm2Mki/qb
         xOqiN5HrheY5uI8BRCAHcUl4bTyiSoK8KBDIrS8aSwx+B7GXG0Vjl1L+0TTAwmrMiXry
         NYYn1GwuDhDcutPldl76ZxNB3TyM04RMEeSQS2MTMUJrJ+lUNu7pTPlIldHQKH/q2bOT
         tdv8q62fTVnaSr7oSkUQyPXp1V4Ka6uRQ29aOPtGx4WfUNo/IgwAq3LADaPkZ4dkgw63
         VL0edbwOw/85qVL70qQJgXmsdH1CR5Pb0MzOqGAaycjGizmjl3Jj0bidn0tqmEAEZ/Pt
         EJAQ==
X-Forwarded-Encrypted: i=1; AKwUvBzRunSCkCoOSddzUZMamFZE4NVJBY0FD25p1rmvi7KKWIsQ4VmKSdSu721PS7voZ08T0WBmcyeizw9QxA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIbLp2dhLSJQslh/ZSoEJpHMqxdsjZDMek6i1FIV/9gaCR8zUb4
	N3jEvR05aMabnhgHJaV+2Uk7Kk2U/WqQejxaiN1K5/fDIhslfXEiufHnAtqxEK78w/NDR569Au7
	GyNuMyVDEz60eoJe+3HHlhRQ1ExLQ1EH/vxiSTLWu0Z8B8CCb2JBw4uhpZxk=
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:192a:b0:504:5fe1:c8d4 with SMTP id
 5614622812f47-5640de7456amr3804995b6e.59.1793453441120; Sat, 31 Oct 2026
 06:30:41 -0700 (PDT)
Date: Sat, 31 Oct 2026 06:30:41 -0700
In-Reply-To: <6a791c94.01d0871a.3a0d52.009a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae5ed81.041e992e.a2316.0006.GAE@google.com>
Subject: Re: [syzbot] [btrfs?] WARNING in __add_block_group_free_space
From: syzbot <syzbot+6931616d57696102d8aa@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    36aad21d50d1 Merge tag 'ksmbd-for-7.4-rc1-part2' of git://..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=113b8959580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=94cb1a71158c9027
dashboard link: https://syzkaller.appspot.com/bug?extid=6931616d57696102d8aa
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147bccb1580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6931616d57696102d8aa@syzkaller.appspotmail.com

------------[ cut here ]------------
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/free-space-tree.c:1446 at __add_block_group_free_space+0x5a3/0x5b0 fs/btrfs/free-space-tree.c:1446, CPU#0: kworker/u4:7/185
Modules linked in:
CPU: 0 UID: 0 PID: 185 Comm: kworker/u4:7 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: events_unbound btrfs_async_reclaim_data_space
RIP: 0010:__add_block_group_free_space+0x5a3/0x5b0 fs/btrfs/free-space-tree.c:1446
Code: 07 38 c1 0f 8c ce fc ff ff 4c 89 f7 e8 66 3c f5 fd e9 c1 fc ff ff e8 cc 98 7c fd eb 10 e8 c5 98 7c fd eb 09 e8 be 98 7c fd 90 <0f> 0b 90 44 89 e1 f7 d9 e9 51 fe ff ff 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90001a7f578 EFLAGS: 00010293
RAX: ffffffff844c8872 RBX: ffff888013790001 RCX: ffff888034dc0000
RDX: 0000000000000000 RSI: ffffffff9081ef80 RDI: 00000000ffffffe4
RBP: ffff888037aea758 R08: ffff888034dc0000 R09: 0000000000000003
R10: 00000000fffffffb R11: 0000000000000000 R12: 00000000ffffffe4
R13: ffff88801377d000 R14: ffff888037aea7b8 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88808aa01000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4b3d8dd080 CR3: 0000000041dd5000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_add_block_group_free_space+0xd0/0x130 fs/btrfs/free-space-tree.c:1471
 btrfs_create_pending_block_groups+0xcc6/0x15e0 fs/btrfs/block-group.c:2942
 __btrfs_end_transaction+0x140/0x640 fs/btrfs/transaction.c:1119
 flush_space+0x3e9/0xde0 fs/btrfs/space-info.c:912
 do_async_reclaim_data_space+0x137/0x550 fs/btrfs/space-info.c:1455
 btrfs_async_reclaim_data_space+0x41/0x90 fs/btrfs/space-info.c:1519
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
