Received: from mail-oi2-f11.google.com (mail-oi2-f11.google.com [74.125.231.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5438649F137
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 19:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790103932; cv=none; b=QLcU0oslJACJVC604/wjKS/8fJyvxQV/vAjtDs4et/t2jE6FBHpKEe9kg8NSz19VL7BeMHaprqa9rb1uKRVLhobvtzRxg+Pep/FaqiOnhSsD5/a3QMYRS8b2G8zX2hgK5Qg6n46oEs2R4GtYracqBnfT7pa22soFVPVyGFqZDe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790103932; c=relaxed/simple;
	bh=B86huMO8Kjl1fU2kdxmDnEkEFV7i+6V+CdDYug9B1i4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=n9j0RWI9nxWru460T55UTRqlIZ1gU22qjQs+8m2ye3IcV1nidIaRo1C9Rw7crApQzyGpPzVFzEobIpUhpWgqk3s24tx/pzn6TSoR+2NQjcIX/DxTxix3b6MKHQj1MpvO5n7NSAi/hq252qNy+hCDdWD2MjZxZLAiM4FkCfUNasY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f11.google.com with SMTP id 5614622812f47-4c650fea78aso93747b6e.0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 12:05:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790103929; x=1790708729;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O5ItLp/M4g9LkhaBxpPpARYoRzVNAes7m0iSglAZyeU=;
        b=Z4hUfk5nob7dNyPMQgVbTEx3zzhTF5beGoppxY5OADqCEKdspLejorLSv1xIfCZUeo
         UOWtUHD8pE0vN5Cd/fJHSFokuTX2WSmc7f7GUk3Oy4st/ozMk7J88pFkFIPOOqDu8q/A
         3YNyoc1m+TeleErCD4gGbXxZjRlnTm9hJoaWkcGu0kHpPBbxesWLV1BoIspwf8KpTqYy
         jUf8pEld2Y3XWHFlRHNKM+DPf/KFOSiYcgIozAKVPLGpqjWdOaUowyuk5wJTVuLkzr6L
         kb/GXdPBGRzxrz05lWrFKMQ8upXE6tgZ6Yc+qGcePSW4ggKSJSMSaYGP3uCZg6yn4n2D
         BMoA==
X-Forwarded-Encrypted: i=1; AKwUvBxL0+xZ5vjmi+Mlj76ldfeb3c7vgKzR5yJAKGlxX7/kzeTfkx0qKR3DXO4AfI8AwUID4idnaD/MF6my1A==@vger.kernel.org
X-Gm-Message-State: AFuF++kRrlS89tAYJsCn6GTcsTXD51q+FpYmRJUymsQIlDl2nVAEYPHI
	w/VaPQ6Lynga583pf0K68nuPenOhKa4yemxiPp/ev5msjxljXyb1kRbTu74a9nZJJaBT2Q5qI9W
	xpDlUgoaHS3AFkzk0gDGBKNODLjBO1vOkewDIbAEmpyIIY1j9QdRtcdfv4kI=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:81cb:b0:6b3:6bc7:2ea7 with SMTP id
 006d021491bc7-6d2cfd45015mr323140eaf.7.1790103929133; Tue, 22 Sep 2026
 12:05:29 -0700 (PDT)
Date: Tue, 22 Sep 2026 12:05:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab2d179.e8212013.2d060.0001.GAE@google.com>
Subject: [syzbot] [btrfs?] kernel BUG in wait_subpage_spinlock
From: syzbot <syzbot+d6f123d4060990f0f3ff@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mason@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5dd1818b15d9 Merge tag 'for-next-keys-v7.3-rc4' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1694d7f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c3bddd52b22c2498
dashboard link: https://syzkaller.appspot.com/bug?extid=d6f123d4060990f0f3ff
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-5dd1818b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fa126b13cb66/vmlinux-5dd1818b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e10c187acaf6/bzImage-5dd1818b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d6f123d4060990f0f3ff@syzkaller.appspotmail.com

BTRFS info (device loop0): space_info DATA+METADATA (sub-group id 0) has 24576 free, is not full
BTRFS info (device loop0): space_info total=3276800, used=49152, pinned=16384, reserved=0, may_use=3186688, readonly=0 zone_unusable=0
BTRFS info (device loop0): global_block_rsv: size 1048576 reserved 1048576
BTRFS info (device loop0): trans_block_rsv: size 0 reserved 0
BTRFS info (device loop0): chunk_block_rsv: size 0 reserved 0
BTRFS info (device loop0): remap_block_rsv: size 0 reserved 0
BTRFS info (device loop0): delayed_block_rsv: size 0 reserved 0
BTRFS info (device loop0): delayed_refs_rsv: size 32768 reserved 32768
assertion failed: folio_test_private(folio) && folio_get_private(folio), in fs/btrfs/inode.c:7616
------------[ cut here ]------------
kernel BUG at fs/btrfs/inode.c:7616!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5325 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:wait_subpage_spinlock+0x380/0x390 fs/btrfs/inode.c:7616
Code: 17 aa fd eb 05 e8 40 17 aa fd 48 c7 c7 00 d2 59 8c 48 c7 c6 c0 06 5a 8c 48 c7 c2 e0 d2 59 8c b9 c0 1d 00 00 e8 a1 f3 09 fd 90 <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90
RSP: 0018:ffffc9000f15e048 EFLAGS: 00010246
RAX: 0000000000000061 RBX: ffffea0001508f00 RCX: 5c8637085c6b4a00
RDX: 0000000000000000 RSI: 8000000000000000 RDI: 0000000000000000
RBP: 1ffffd40002a11e0 R08: ffffc9000f15ddc7 R09: 1ffff92001e2bbb8
R10: dffffc0000000000 R11: fffff52001e2bbb9 R12: 0000000000000002
R13: 0000000000004000 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007fd4260436c0(0000) GS:ffff88808c2c3000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd426062f68 CR3: 000000004387c000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_invalidate_folio+0x26e/0xc50 fs/btrfs/inode.c:7698
 extent_writepage fs/btrfs/extent_io.c:2058 [inline]
 extent_write_cache_pages fs/btrfs/extent_io.c:2843 [inline]
 btrfs_writepages+0x129f/0x28c0 fs/btrfs/extent_io.c:2975
 do_writepages+0x338/0x560 mm/page-writeback.c:2560
 filemap_writeback mm/filemap.c:387 [inline]
 filemap_fdatawrite_range+0x1ef/0x2f0 mm/filemap.c:412
 btrfs_start_ordered_extent_nowriteback+0x305/0x6e0 fs/btrfs/ordered-data.c:-1
 btrfs_start_ordered_extent fs/btrfs/ordered-data.h:203 [inline]
 btrfs_page_mkwrite+0x856/0x1a40 fs/btrfs/file.c:1909
 do_page_mkwrite+0x147/0x310 mm/memory.c:3816
 wp_page_shared mm/memory.c:4217 [inline]
 do_wp_page+0x1a9c/0x4b80 mm/memory.c:4440
 handle_pte_fault mm/memory.c:6582 [inline]
 __handle_mm_fault mm/memory.c:6707 [inline]
 handle_mm_fault+0x15d7/0x3750 mm/memory.c:6876
 faultin_page mm/gup.c:1126 [inline]
 __get_user_pages+0x1675/0x2750 mm/gup.c:1428
 __get_user_pages_locked mm/gup.c:1752 [inline]
 __gup_longterm_locked+0x1032/0x15c0 mm/gup.c:2471
 gup_fast_fallback+0x1d92/0x20e0 mm/gup.c:3209
 iov_iter_extract_user_pages lib/iov_iter.c:1776 [inline]
 iov_iter_extract_pages+0x3a1/0x690 lib/iov_iter.c:1845
 iov_iter_extract_bvecs+0x272/0xb40 lib/iov_iter.c:1957
 bio_iov_iter_get_pages+0x5ae/0xee0 block/bio.c:1309
 blkdev_iov_iter_get_pages block/fops.c:49 [inline]
 __blkdev_direct_IO+0x661/0xf60 block/fops.c:219
 blkdev_direct_IO+0x121d/0x17b0 block/fops.c:435
 blkdev_read_iter+0x223/0x420 block/fops.c:816
 aio_read+0x33a/0x4d0 fs/aio.c:1656
 __io_submit_one fs/aio.c:-1 [inline]
 io_submit_one+0x774/0x13d0 fs/aio.c:2106
 __do_sys_io_submit fs/aio.c:2165 [inline]
 __se_sys_io_submit+0x195/0x340 fs/aio.c:2135
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd42519e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd426042fe8 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 00007fd425426090 RCX: 00007fd42519e159
RDX: 00002000000000c0 RSI: 00000000000000ca RDI: 00007fd426022000
RBP: 00007fd42523506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd425426128 R14: 00007fd425426090 R15: 00007ffec6e38c28
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:wait_subpage_spinlock+0x380/0x390 fs/btrfs/inode.c:7616
Code: 17 aa fd eb 05 e8 40 17 aa fd 48 c7 c7 00 d2 59 8c 48 c7 c6 c0 06 5a 8c 48 c7 c2 e0 d2 59 8c b9 c0 1d 00 00 e8 a1 f3 09 fd 90 <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90
RSP: 0018:ffffc9000f15e048 EFLAGS: 00010246
RAX: 0000000000000061 RBX: ffffea0001508f00 RCX: 5c8637085c6b4a00
RDX: 0000000000000000 RSI: 8000000000000000 RDI: 0000000000000000
RBP: 1ffffd40002a11e0 R08: ffffc9000f15ddc7 R09: 1ffff92001e2bbb8
R10: dffffc0000000000 R11: fffff52001e2bbb9 R12: 0000000000000002
R13: 0000000000004000 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007fd4260436c0(0000) GS:ffff88808c2c3000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2823e512c0 CR3: 000000004387c000 CR4: 0000000000352ef0


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
