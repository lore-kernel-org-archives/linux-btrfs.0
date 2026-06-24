Received: from mail-ot1-f79.google.com (mail-ot1-f79.google.com [209.85.210.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEA0248893
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 18:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782325053; cv=none; b=IAZ34TsMIqHur5jjXJo5N1PFyHusyii05RKoYX1i3crS5iuQKHGq2qsRk1sw6V4BNYgnvSgzZ9tAE4s2SBmlJaLHjhfmHLjUkKjXzMu2/prHJLPQPHP1zX5Cwg2j2kS6cn0KqHMZuQNIWgW8WpkKVMuBUPshbLMwcChw+tx9T9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782325053; c=relaxed/simple;
	bh=dg2BAuQcrMYr2XnPTD9YQo533jQ9UdQQQH2jo0dOy7U=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=o0Hdnf1In24bX6ZeeXDt90Ky4oe11B9E+o1pKCoB0BYzrq6PvyNaKYBP6GWDalOCv/3yBmALzxD9cS0U6qC0qKiMc2wFnEarMPbRkndf3jzzETNc3KeAIgegSA92QTjVbLAL02B5DCqs6ErtKKPJ6CP7Mf83v5S69MysUlREaFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f79.google.com with SMTP id 46e09a7af769-7e93d89a044so112032a34.1
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 11:17:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782325051; x=1782929851;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SSD9I68lTNAcfnkWqHg8KTjWMrVVVp42A4beC/sscgo=;
        b=gixYdiXFfrs9yklS7EN05YGLKx7rINiu/ztLMEEBPS7yait9HFEUAOqvq0pWOGYbGH
         uWbojtLJDgB5ZXI0oBZWKnZ2YdpShb1iF2v/aFzi36UMHdV83xjkD5lAuv1FKLvHuhSU
         gQ8o226Z0egvyMtLr4BeCLPeMr++7ulfvczUeSWm8KhZrzU9bO/udv4UQSj6gdW1P8rv
         F5mBJYRg7KRjy5OFkujTspfGX6FAothmYW+MJYKue12z6C1c1ym/YwCmwX4f5mkyT6V5
         zp9MNhZ51yPCwW7mJ1EQA0VuDr5OOxi7QiVUPqzv+R9yZy0HIEx7TepmqBOonW/cQUnH
         IP7w==
X-Forwarded-Encrypted: i=1; AFNElJ/xMBYD2iyJjomNYd3drxgCDlDQ+AVVJnAjp/UdHnGsaOaNzHPfjV6N7WP6HLh3NcPnPYmuBt08U89NPg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzZ76eRUp4rxFhTM2J9NGJw4STN9ZawfIizhpiWClptcvlQ1jp3
	LjgUgrhkkEzkmSiK3jnuTYS3EvB39bE2VtOOCo35SiXnPjf2HMY4wJQoMrrbb7X+ue7j9Ui0ZjO
	74xg8TjuBLdwuKjefXSOuoqZRlTYNMSF7qRA8al7xRqidPfJcBBo8HPM5Mo8=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2d02:b0:6a1:275d:f585 with SMTP id
 006d021491bc7-6a1275dff88mr1863281eaf.9.1782325051241; Wed, 24 Jun 2026
 11:17:31 -0700 (PDT)
Date: Wed, 24 Jun 2026 11:17:31 -0700
In-Reply-To: <6a39275b.5031c61f.34f2da.0001.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3c1f3b.4cbe3da0.2204f7.0162.GAE@google.com>
Subject: Re: [syzbot] [btrfs?] kernel BUG in btrfs_alloc_ordered_extent
From: syzbot <syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    840ef6c78e6a Merge tag 'nfs-for-7.2-1' of git://git.linux-..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=154b6591580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b70f7c595323ba2
dashboard link: https://syzkaller.appspot.com/bug?extid=ba2afde329fc27e3f22e
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1005b21c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e168dc580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/21afc0da735a/disk-840ef6c7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c89b2edbb4f6/vmlinux-840ef6c7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bef6a8464d41/bzImage-840ef6c7.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/33eb3874c00f/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=11009d0e580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/btrfs/ordered-data.c:264!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 6897 Comm: syz.4.79 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
RIP: 0010:insert_ordered_extent fs/btrfs/ordered-data.c:261 [inline]
RIP: 0010:btrfs_alloc_ordered_extent+0x943/0xad0 fs/btrfs/ordered-data.c:336
Code: 62 8d ba 08 01 00 00 b9 ef ff ff ff 49 c7 c0 20 15 97 8b 4d 89 f9 ff 75 00 41 54 41 55 41 56 53 e8 a2 54 37 fd 48 83 c4 28 90 <0f> 0b e8 c6 1d d2 fd 48 c7 c7 80 0c 97 8b 48 c7 c6 e0 0c 97 8b 48
RSP: 0018:ffffc90006e0e890 EFLAGS: 00010296
RAX: 45aae1616d386000 RBX: 0000000000069000 RCX: 1ffff92000dc1cf0
RDX: 0000000000000003 RSI: ffffffff8d89f46f RDI: ffff888028618000
RBP: ffff88806168cfe0 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffff52000dc1c61 R12: 0000000000069000
R13: 0000000000004000 R14: 0000000000001089 R15: 0000000000004000
FS:  00007f50b1dee6c0(0000) GS:ffff88812621d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007efc8ea98d50 CR3: 0000000045856000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 cow_one_range fs/btrfs/inode.c:1241 [inline]
 cow_file_range+0x744/0x12a0 fs/btrfs/inode.c:1403
 fallback_to_cow+0x5ea/0xa00 fs/btrfs/inode.c:1751
 run_delalloc_nocow+0x110c/0x17a0 fs/btrfs/inode.c:2181
 btrfs_run_delalloc_range+0xbe4/0x1c20 fs/btrfs/inode.c:2419
 writepage_delalloc+0x104d/0x1ba0 fs/btrfs/extent_io.c:1558
 extent_writepage fs/btrfs/extent_io.c:1930 [inline]
 extent_write_cache_pages fs/btrfs/extent_io.c:2593 [inline]
 btrfs_writepages+0x1667/0x28b0 fs/btrfs/extent_io.c:2725
 do_writepages+0x338/0x560 mm/page-writeback.c:2571
 filemap_writeback mm/filemap.c:387 [inline]
 filemap_fdatawrite_range+0x1f2/0x300 mm/filemap.c:412
 btrfs_fdatawrite_range+0x54/0xf0 fs/btrfs/file.c:3884
 btrfs_direct_write+0x6a0/0xc30 fs/btrfs/direct-io.c:1038
 btrfs_do_write_iter+0x329/0x790 fs/btrfs/file.c:1449
 do_iter_readv_writev+0x624/0x8d0 fs/read_write.c:-1
 vfs_writev+0x34c/0x990 fs/read_write.c:1058
 do_pwritev fs/read_write.c:1154 [inline]
 __do_sys_pwritev2 fs/read_write.c:1212 [inline]
 __se_sys_pwritev2+0x17a/0x2a0 fs/read_write.c:1203
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f50b278ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f50b1dee028 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007f50b2a05fa0 RCX: 00007f50b278ce59
RDX: 0000000000000020 RSI: 0000200000000240 RDI: 0000000000000004
RBP: 00007f50b2822e6f R08: 0000000000000000 R09: 0000000000000003
R10: 0000000000003000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f50b2a06038 R14: 00007f50b2a05fa0 R15: 00007ffce174b008
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:insert_ordered_extent fs/btrfs/ordered-data.c:261 [inline]
RIP: 0010:btrfs_alloc_ordered_extent+0x943/0xad0 fs/btrfs/ordered-data.c:336
Code: 62 8d ba 08 01 00 00 b9 ef ff ff ff 49 c7 c0 20 15 97 8b 4d 89 f9 ff 75 00 41 54 41 55 41 56 53 e8 a2 54 37 fd 48 83 c4 28 90 <0f> 0b e8 c6 1d d2 fd 48 c7 c7 80 0c 97 8b 48 c7 c6 e0 0c 97 8b 48
RSP: 0018:ffffc90006e0e890 EFLAGS: 00010296
RAX: 45aae1616d386000 RBX: 0000000000069000 RCX: 1ffff92000dc1cf0
RDX: 0000000000000003 RSI: ffffffff8d89f46f RDI: ffff888028618000
RBP: ffff88806168cfe0 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffff52000dc1c61 R12: 0000000000069000
R13: 0000000000004000 R14: 0000000000001089 R15: 0000000000004000
FS:  00007f50b1dee6c0(0000) GS:ffff88812621d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007efc8ea98d50 CR3: 0000000045856000 CR4: 00000000003526f0


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
