Received: from mail-oi2-f1.google.com (mail-oi2-f1.google.com [74.125.231.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC7D481A92
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 15:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672501; cv=none; b=H1JD1kStieE2K0mYy2RQ5mJ8bGpxIV0bhb4Ol0fRq1diNljzFFWAB9BeKiR56CvdhZYT2d4jlYF00698T9N0yZkx5cKhNhGplu7STrco/Z8KXi6GR3aHCyKOGsNeqdAp59CnrCcP7w5ZCjHuI435VygPKux2LBt9DTTCdSSl+jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672501; c=relaxed/simple;
	bh=vN3QAIFtSIu/2my/ILcppHph3GsMyCRxw7A/aJvAKuI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=p9w4wBtTbZZsLzW8YW4hoZg5Q8LH2N7c9Im6GbNmqkriq7yeRoqTutR+B2EO672FyUHme264ass55Bo3HT2sDZ+/lRP/t4mn3CheXt+YUuLPxoCMru1uMcSinL76kDPMyy8rKHoBzBqu/G5irlMbl48llNFik3Urphql6ne8Y6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f1.google.com with SMTP id 5614622812f47-4960a23d5e1so1840309b6e.1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 08:41:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672498; x=1788277298;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GC0sT688CMPZIAFu0nGVPNVXVksF+ly+uwSWiBgBdgw=;
        b=XDG03FYGkod9PdkMPG/GMASQBSapaJVXQmN9prXUzfDqcl7apzmqszKZTmaDKnPd6a
         edunIrR4h5F3rtzgjGADh3oBuHWn/LmWPtzVhzu5v52EQdIHSxhOCRVqGPKJKH9BPBNY
         X62T7H+JOAOCdWnVe35oaUcavApPnHVvoMhL0/cc+4hqdTeaJRZzgIAq+M86BQD0+HoT
         mBrOZxsvnxAM4BG717z0XgeHsuyejdDc+sZsqfTrip7LHMGziizGsHRFOt/jFvvdk2P8
         3bSsmp4Edzpf5Uz9ZQsDj8gWbUhfCoJMq/omRwztEyvPEuu4R8Y8mxzajuGhNUrvnSAp
         BbTg==
X-Forwarded-Encrypted: i=1; AHgh+RoYnTwTxs+uSqz606k9Qq8yzV3XQdNO6EFqqt8bnRR4lZ4KywaUf/wH5+MtN3lcRwKvIOTDrC9C9UfyPA==@vger.kernel.org
X-Gm-Message-State: AFuF++nNkpcQHfpr+b9ydjFlmI2+ngMI18iGkha3+WGI4zn8O0WRbbt2
	QAcnLr5vvV2lqeNJP1JxAYl+y66MD+ajElPdtjpin60veb12HfFMWWKLPyuxGw1g/3COZ/Lb99u
	q6+fFXUyMoUndAFfpFRcku+1QSBxBv/62fTEc7n5Huiv5aDVzGviHU4Rdbew=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c40b:b0:4b2:8d7b:390b with SMTP id
 5614622812f47-4b309bb4709mr26186547b6e.19.1787672498170; Tue, 25 Aug 2026
 08:41:38 -0700 (PDT)
Date: Tue, 25 Aug 2026 08:41:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8db7b2.a5a502ce.31d34.006c.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in btrfs_quota_enable (2)
From: syzbot <syzbot+11ac036337245d7faf6d@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13da3e79580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c35c7e43de75adb
dashboard link: https://syzkaller.appspot.com/bug?extid=11ac036337245d7faf6d
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-818bebeb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9adea981957f/vmlinux-818bebeb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6676075cd03e/bzImage-818bebeb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+11ac036337245d7faf6d@syzkaller.appspotmail.com

------------[ cut here ]------------
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/qgroup.c:1077 at btrfs_quota_enable+0x1acf/0x1e20 fs/btrfs/qgroup.c:1077, CPU#0: syz.0.0/5316
Modules linked in:
CPU: 0 UID: 0 PID: 5316 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:btrfs_quota_enable+0x1acf/0x1e20 fs/btrfs/qgroup.c:1077
Code: 08 00 00 00 4c 89 e7 e8 4f fe 04 fe e9 3c e7 ff ff e8 65 53 aa 07 e8 90 b4 93 fd eb 10 e8 89 b4 93 fd eb 09 e8 82 b4 93 fd 90 <0f> 0b 90 4c 8b 64 24 20 44 89 e1 f7 d9 e9 eb f9 ff ff 44 89 f7 48
RSP: 0018:ffffc9000de77c80 EFLAGS: 00010283
RAX: ffffffff8433803e RBX: ffffffffffffffe4 RCX: 0000000000100000
RDX: ffffc9000f4b9000 RSI: 00000000000020b8 RDI: 00000000000020b9
RBP: ffffc9000de77e70 R08: ffff88800029cb00 R09: 0000000000000003
R10: 00000000fffffffb R11: 0000000000000002 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff888052295a00 R15: ffffc9000de77d90
FS:  00007f86714146c0(0000) GS:ffff88808c30a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f86713f2fe8 CR3: 0000000039d60000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_ioctl_quota_ctl+0x186/0x1f0 fs/btrfs/ioctl.c:3566
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f867059e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8671413fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f8670826090 RCX: 00007f867059e0d9
RDX: 00002000000000c0 RSI: 00000000c0109428 RDI: 0000000000000003
RBP: 00007f8670635024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8670826128 R14: 00007f8670826090 R15: 00007ffd6c070158
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
