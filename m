Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793624992;
	b=Qu3vD52PfHYs2JlvtobcZD8TRs9UGniGbkrfL57MlK4YbymuldDdhh6sd3/WhKviZ3o6
	 zmLTGbMEYEo6YU2SZ4+CX0HKbHHVilJa7yKG32c3bFo1Dtc0TnOEvxT30Tuq5qbpOfOjT
	 1vDrteq0E+PHi7/eha9q2dBcffIDGAuLkJ5k989CsJOOtbLFhflgUWmdEvEczZTduuecC
	 iktOOPU+9puuCoG3cCp8z5jqaz92WEYxFGUOZBFIw0qeUAkk1MUOJB1dH8Y66RbI0ZEDr
	 sD0VVC1Q461q252yOY3DokywBr9PM+oURUkog1PpY9I128NYKlJ+sxfC83B17b8d0ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793624992;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=jqBUz6nIoIfKS3gUvjdI9+AWIpUhKAXXkzURXSQOsdU=;
	b=4nlAu1OJVrBHmTJ/Ff0hcgGQSxO3APTOKWniLBKpH7+qQdtLuvvXDIWaZ1nD5mY5JcEe
	 Dwy3I5xcW54GT6pvscovEOD59C91FCMAHnA6DR/hK2xxVDzHLnrqQmxnPwnOIyi4VFros
	 1oec0iFKhODYFfWBs1AE6tjHTAhBmNWRAggD5hFA/alBmc1cjcDb7eFCJg/Zk8zF/EQld
	 LB7SjNGLcOjZkUJ8j5c9XDjipWMPuc/pe7vLbIRkY3wXqjWtIFFYu218mEQmhrYuBudx4
	 ozi59mwe9MsOAXPl5ANEiGfGBZZF3djAkd/XIiuUbIQWxBV3D6LrMcvELzQw89sszzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00607606A327
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 13:09:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00607606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4e937c5bd4fso2335570b6e.2
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 05:09:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793624991; x=1794229791;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jqBUz6nIoIfKS3gUvjdI9+AWIpUhKAXXkzURXSQOsdU=;
        b=i2Oe36jj4HCChKAla/HQvzwu/8vBhT50YwAUSz1oEFuEQ7PZ+f7qVIQO66AX8tDacO
         wybcEUVlsgVPn22jDk64FjP0JK4je+mX+WinJsxXDQ2DZM0q6bibUrBotaciuy2pCaej
         qtB606ELQGWmrAYW7kdLxvZUkGJ0xoFWQ3lUQIVMTqFxJs5O/ILOUPCQwnO9GAh3vznp
         ibSG2p6wwiC411Fdu98udOB3f4ANqr8y/xZ1zZOekq3AuLHmdJwl3JE+AiuVYTYU4wpz
         eLadM0jHAgX+wqkDTaH5BiIGycZWL//U77dBwFpbMqTFgjE0UxF0DXa2zugBINL5wFgV
         S8Cg==
X-Forwarded-Encrypted: i=1; AKwUvByG/982vqcHcuSg/d9C3mUlBBbftRoSHIP0zejHlPGni6Dcbri6Dfh2WFKPBtcwIbQdWTMUXBeJB72DmQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYILaRsHYVrv/9/D9ryBcB97Qn97iImOwU6chlQV2CkFqqDgYYXv
	qlWrMnKcgtQTDtiur6N3P+tslW6Z1hrXPavYXevUhBIyqum2qfK4Sm5puXTi4WKkfJHsLd+Wk5d
	2sVH7T669m+E+m56zeP1jueZcmQNiTkGIyewmllxYg0Yzzg0Eb6ATI6HoAg0=
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1310:b0:4f4:2b4c:d66a with SMTP id
 5614622812f47-5640dcea140mr6263705b6e.12.1793624990946; Mon, 02 Nov 2026
 05:09:50 -0800 (PST)
Date: Mon, 02 Nov 2026 05:09:50 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae88b9e.64e51036.15cf6a.0027.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in btrfs_release_global_block_rsv (3)
From: syzbot <syzbot+7ec60f4482abeecb0fd8@syzkaller.appspotmail.com>
To: dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mason@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    36aad21d50d1 Merge tag 'ksmbd-for-7.4-rc1-part2' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13724959580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dc4462df6d1062fe
dashboard link: https://syzkaller.appspot.com/bug?extid=7ec60f4482abeecb0fd8
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/96a3448f37dc/disk-36aad21d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0b79495726f5/vmlinux-36aad21d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4480be87f78d/bzImage-36aad21d.xz

AI-generated root cause summary:
In Btrfs, when an extent is freed and reallocated with a smaller size before its
delayed refs are processed, update_existing_head_ref() overwrites
existing->num_bytes with the new size before adjusting checksum deletion
accounting. When existing->total_ref_mod transitions from negative to
non-negative, btrfs_delayed_refs_rsv_release() calculates and releases fewer
csum leaves than were originally accounted in add_delayed_ref_head(). This
permanently leaks delayed_refs_rsv size and reserved space, leading to metadata
space exhaustion (premature -ENOSPC) during runtime and triggering a WARNING on
unmount in btrfs_release_global_block_rsv().

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=7ec60f4482abeecb0fd8

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7ec60f4482abeecb0fd8@syzkaller.appspotmail.com

BTRFS info (device loop6): last unmount of filesystem db05bf05-c4f4-4d41-ba1f-eb57295b561b
------------[ cut here ]------------
fs_info->delayed_refs_rsv.reserved > 0
WARNING: fs/btrfs/block-rsv.c:481 at btrfs_release_global_block_rsv+0x2e4/0x300 fs/btrfs/block-rsv.c:481, CPU#1: syz-executor/6147
Modules linked in:
CPU: 1 UID: 0 PID: 6147 Comm: syz-executor Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/07/2026
RIP: 0010:btrfs_release_global_block_rsv+0x2e4/0x300 fs/btrfs/block-rsv.c:481
Code: 0f 0b 90 e9 c1 fe ff ff e8 69 cd 84 fd 90 0f 0b 90 e9 eb fe ff ff e8 5b cd 84 fd 90 0f 0b 90 e9 15 ff ff ff e8 4d cd 84 fd 90 <0f> 0b 90 e9 46 ff ff ff e8 3f cd 84 fd 90 0f 0b 90 e9 69 ff ff ff
RSP: 0018:ffffc90006717ad0 EFLAGS: 00010293
RAX: ffffffff84430bd3 RBX: ffff8880636e4768 RCX: ffff888031809f40
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff8880636e42b0 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff21ab138 R12: ffff8880636e4000
R13: 0000000000000000 R14: 0000000000008000 R15: dffffc0000000000
FS:  000055557537f500(0000) GS:ffff888124816000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2f2de04e00 CR3: 000000003d9c0000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 btrfs_free_block_groups+0xdc2/0x1040 fs/btrfs/block-group.c:4444
 close_ctree+0x7d1/0x1200 fs/btrfs/disk-io.c:4575
 generic_shutdown_super+0x140/0x2d0 fs/super.c:723
 kill_anon_super+0x3b/0x70 fs/super.c:1315
 btrfs_kill_super+0x41/0x50 fs/btrfs/super.c:2139
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
RIP: 0033:0x7f43e2c70797
Code: a2 c7 05 5c 9f 25 00 00 00 00 00 eb 96 e8 e1 12 00 00 90 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffe17fa6818 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00007f43e2d05f93 RCX: 00007f43e2c70797
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffe17fa68d0
RBP: 00007ffe17fa68d0 R08: 00007ffe17fa78d0 R09: 00000000ffffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe17fa7960
R13: 00007f43e2d05f93 R14: 000000000003637c R15: 00007ffe17fa79a0
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
