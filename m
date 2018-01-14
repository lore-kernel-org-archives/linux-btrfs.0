Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:45551 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751848AbeANBgt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Jan 2018 20:36:49 -0500
Received: by mail-yw0-f171.google.com with SMTP id m19so4086031ywh.12
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jan 2018 17:36:49 -0800 (PST)
Received: from sharpeth.aviatis.com (107-215-1-140.lightspeed.sntcca.sbcglobal.net. [107.215.1.140])
        by smtp.gmail.com with ESMTPSA id q9sm5883133ywq.29.2018.01.13.17.36.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 13 Jan 2018 17:36:47 -0800 (PST)
From: Johannes Ernst <johannes.ernst@gmail.com>
Content-Type: text/plain; charset=utf-8
Subject: Hanging after frequent use of systemd-nspawn --ephemeral
Message-Id: <6B7B9360-41EA-4190-8C7D-9E001D186B23@gmail.com>
Date: Sat, 13 Jan 2018 17:36:46 -0800
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Summary: frequent “hangs” of the system with dmesg saying:

task systemd:22229 blocked for more than 120 seconds.
[ 2948.928653]       Tainted: G         C O    4.14.9-1-ARCH #1
[ 2948.928658] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2948.928665] systemd         D    0 22229  22226 0x00000100
[ 2948.928671] Call Trace:
[ 2948.928684]  ? __schedule+0x290/0x890
[ 2948.928690]  schedule+0x2f/0x90
[ 2948.928744]  btrfs_tree_read_lock+0xb6/0x100 [btrfs]
[ 2948.928752]  ? wait_woken+0x80/0x80
[ 2948.928799]  find_parent_nodes+0x341/0xfd0 [btrfs]
[ 2948.928827]  ? btrfs_search_slot+0x84c/0x9f0 [btrfs]
[ 2948.928873]  ? btrfs_find_all_roots_safe+0x9e/0x110 [btrfs]
[ 2948.928912]  btrfs_find_all_roots_safe+0x9e/0x110 [btrfs]
[ 2948.928950]  btrfs_find_all_roots+0x45/0x60 [btrfs]
[ 2948.928987]  btrfs_qgroup_trace_extent_post+0x30/0x60 [btrfs]
[ 2948.929026]  btrfs_add_delayed_tree_ref+0x1db/0x200 [btrfs]
[ 2948.929055]  btrfs_inc_extent_ref+0xa6/0xe0 [btrfs]
[ 2948.929084]  __btrfs_mod_ref+0x144/0x230 [btrfs]
[ 2948.929110]  ? add_pinned_bytes+0x40/0x40 [btrfs]
[ 2948.929136]  update_ref_for_cow+0xd2/0x320 [btrfs]
[ 2948.929161]  __btrfs_cow_block+0x1f9/0x5b0 [btrfs]
[ 2948.929187]  btrfs_cow_block+0xca/0x1c0 [btrfs]
[ 2948.929212]  btrfs_search_slot+0x321/0x9f0 [btrfs]
[ 2948.929239]  btrfs_insert_empty_items+0x66/0xb0 [btrfs]
[ 2948.929271]  insert_with_overflow+0x44/0x110 [btrfs]
[ 2948.929303]  btrfs_insert_dir_item+0xcd/0x280 [btrfs]
[ 2948.929342]  btrfs_add_link+0xe8/0x430 [btrfs]
[ 2948.929349]  ? getnstimeofday64+0xa/0x20
[ 2948.929384]  btrfs_mkdir+0x1d3/0x210 [btrfs]
[ 2948.929392]  vfs_mkdir+0xd7/0x140
[ 2948.929397]  SyS_mkdir+0x7a/0xf0
[ 2948.929404]  do_syscall_64+0x55/0x110
[ 2948.929409]  entry_SYSCALL64_slow_path+0x25/0x25
[ 2948.929413] RIP: 0033:0x7f8735697687
[ 2948.929415] RSP: 002b:00007ffc8e72d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
[ 2948.929419] RAX: ffffffffffffffda RBX: 000000000003a2f8 RCX: 00007f8735697687
[ 2948.929421] RDX: 0000000000000156 RSI: 00000000000001c0 RDI: 0000561976693a80
[ 2948.929423] RBP: 0000000000000001 R08: 000056197666b880 R09: 0000561974c0f734
[ 2948.929425] R10: 00007ffc8e72d030 R11: 0000000000000246 R12: 0000561976693a80
[ 2948.929427] R13: 0000561976693ad3 R14: 00007f8735732f80 R15: 8421084210842109


Detail:

I build a Linux distro called UBOS [1]. For testing purposes, we boot UBOS in a systemd-nspawn container, do some automated tests, and poweroff the container. A few dozen of those tests can happen in rapid succession (but not in parallel). 

We run systemd-nspawn with the —ephemeral flag in some directory on a btrfs filesystem, which causes systemd to allocate a temporary subvolume that goes away again when the container quits, leaving the filesystem unchanged (this is very handy for testing purposes).

That works well … but not for long. Often we don’t make it through the test suite and the starting of new containers hangs. Other filesystem operations also hang. The above stacktrace, or something rather similar shows up in dmesg (not in the journal, because that hangs, too!) This is repeated, but I don’t see any other relevant messages. Only a reboot seems to allows to recover.

This happens on two-disk RAID1 as well as one-disk systems, and it happens on x86_64, armv6, armv7 and aarch64. So it does not seem to have anything to do with any particular disk or filesystem. The disks have plenty of space. aIt has been the same behavior for some time, so it’s not a recent problem. UBOS is a derivative of Arch, so it’s fairly current in terms of code. Current kernel versions are 4.14.x on all platforms.

Any idea what this might be or how to debug this? 

Thanks,



Johannes.


[1] https://ubos.net/

