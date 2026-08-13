Received: from mail-oa1-f77.google.com (mail-oa1-f77.google.com [209.85.160.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997B43ED3CC
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2026 05:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786599932; cv=none; b=Vni0Rh8mCUdRr3IGBgbzYt5OV4DhemeWLjvR9fqb5g/CG7z3oOY9hhp6ukfpMky5Q4UJP0TQDUqCLubUX2R/HaBBSrXMqhbGTNXN3wb5hXnzAupEfpS2uqlpSESKfU3doQQMVJ8tiuie5T30GnotLiD8N7tAwcXCpiVoG7h3kVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786599932; c=relaxed/simple;
	bh=HpTTL3rOf9yvhCSIHWliI+QL5CAt+FoJ/7+c2YK0gwA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Gq9g7Bf5iWxTVk1Ttv9uWQoRcJw5CwQzhvYHYPOFq24TFAPkNcrKl/t8ohLtXAmb5q34Boht0gxs5owsru6s8pCvv7Png8kda2LEE9b11xMM8wi31Oi8/hhs9HkptPfW0g7Y+ZejAK/l2H/3bs4opfTLXZrxqA+6X7EAqruPiFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f77.google.com with SMTP id 586e51a60fabf-44899f99756so1998185fac.2
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 22:45:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786599929; x=1787204729;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xmU6wu+YFonCLhKD+jsSBLKeD63BNRA8pC2RenAhjNI=;
        b=OI3dwT67WedNm7J/x7J2nt4ZmzDzE7pQtW/AXhJPnDS6BP69+0QaB0QfTgIX62rCbF
         4Nb0aNf4W5sxGDGMiolfEYNk1fuQTAh3AICxltwWr08G1HZej6mwuK8ICP8UCO5PsGGB
         mxpmexPw+h0K1cBESIbTZLgFVW9aZypqiRopWnCBlB4jbOSS0j2lnrM+/KdBldWEUF5w
         +w8vm+sPDSJ0aOntCC9wUwkOGGJA4BhhiY1CYA3t2fnMPhH7z71K5erhyOmGD26rT4jU
         BBviPEvRxNX8soBBFXW3A5XpyvECVSJQrzVikS+GjhxA35UEMvQzb04QhUlolvqb642b
         yhUw==
X-Forwarded-Encrypted: i=1; AHgh+Rr7PWBwaoEGKNI3n0dcsX0nR/U3Hp+HWS5OxNu09EuU2a590bhHAbcH64xVGKlhYPBInLoX3QFDpfKyug==@vger.kernel.org
X-Gm-Message-State: AOJu0Yye3ignuwPELxvYJXXnBKg9r6KuwfEDcofBZmSBdBJnjTQiR5Q+
	RVGm68ArrJ7rrOHxzn4VLcbiVKyWIJVM2GeinLhQULrp6Yx+4ZdU77d8GOapU5kxqnbzHZsOdAd
	AM9DO6hR79UpC0kLbRlWRzNC/k+Co5TCPd41T+jIPphjJvgnWl9LbgNKUlKM=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1889:b0:6b0:40f8:4c82 with SMTP id
 006d021491bc7-6b0c45e05e8mr3436515eaf.29.1786599929443; Wed, 12 Aug 2026
 22:45:29 -0700 (PDT)
Date: Wed, 12 Aug 2026 22:45:29 -0700
In-Reply-To: <6a791c94.01d0871a.3a0d52.0099.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7d59f9.c5ad36c8.12f49d.002a.GAE@google.com>
Subject: Re: [syzbot] [btrfs?] WARNING in btrfs_init_new_device
From: syzbot <syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    3d6d817622b0 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13705149580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=158601bb8cb292dd
dashboard link: https://syzkaller.appspot.com/bug?extid=3bf3e110b2d406b8166c
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13d3ec79580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=100c8ac6580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fc778852603e/disk-3d6d8176.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/05372451f9a9/vmlinux-3d6d8176.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0620f51f7bde/bzImage-3d6d8176.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/99b4705403e2/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=17f48ac6580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com

------------[ cut here ]------------
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/volumes.c:3013 at btrfs_init_new_device+0x1913/0x19e0 fs/btrfs/volumes.c:3013, CPU#1: syz.0.17/5924
Modules linked in:
CPU: 1 UID: 0 PID: 5924 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:btrfs_init_new_device+0x1913/0x19e0 fs/btrfs/volumes.c:3013
Code: 00 00 41 83 fe f4 0f 85 d8 00 00 00 e8 d6 c3 b4 fd e9 d7 00 00 00 e8 cc c3 b4 fd eb 10 e8 c5 c3 b4 fd eb 09 e8 be c3 b4 fd 90 <0f> 0b 90 44 89 f1 f7 d9 e9 7b fc ff ff 89 d9 80 e1 07 38 c1 0f 8c
RSP: 0018:ffffc90003f07da8 EFLAGS: 00010293
RAX: ffffffff84110472 RBX: ffff8880357dc001 RCX: ffff8880381a5d00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffff8880381a5d00 R09: 0000000000000003
R10: 0000000000000100 R11: 00000000fffffffb R12: ffff8880357dce40
R13: 0000000000000001 R14: 00000000ffffffef R15: ffff8880357dc000
FS:  00007fc65910e6c0(0000) GS:ffff888125d46000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc659afb7c0 CR3: 00000000472b8000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 btrfs_ioctl_add_dev+0x1ad/0x640 fs/btrfs/ioctl.c:2558
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xff/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc659aae0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc65910e028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fc659d35fa0 RCX: 00007fc659aae0d9
RDX: 0000200000001000 RSI: 000000005000940a RDI: 0000000000000004
RBP: 00007fc659b45024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc659d36038 R14: 00007fc659d35fa0 R15: 00007fff92859458
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
