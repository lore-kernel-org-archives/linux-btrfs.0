Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:43513 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbeANUR4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 15:17:56 -0500
Received: by mail-pf0-f196.google.com with SMTP id e3so7125380pfi.10
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jan 2018 12:17:56 -0800 (PST)
Received: from sharpeth.aviatis.com (107-215-1-140.lightspeed.sntcca.sbcglobal.net. [107.215.1.140])
        by smtp.gmail.com with ESMTPSA id x4sm16836136pgc.92.2018.01.14.12.17.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 14 Jan 2018 12:17:54 -0800 (PST)
From: Johannes Ernst <johannes.ernst@gmail.com>
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: Hanging after frequent use of systemd-nspawn --ephemeral
In-Reply-To: <8c9933e1-f694-a513-83ca-33fcb503b7e8@gmx.com>
Date: Sun, 14 Jan 2018 12:17:53 -0800
Message-Id: <AA437C7B-EB91-46F7-BE01-2254A20DB75E@gmail.com>
References: <6B7B9360-41EA-4190-8C7D-9E001D186B23@gmail.com> <8c9933e1-f694-a513-83ca-33fcb503b7e8@gmx.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Jan 13, 2018, at 18:27, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> On 2018年01月14日 09:36, Johannes Ernst wrote:
>> Summary: frequent “hangs” of the system with dmesg saying:
>> 
>> task systemd:22229 blocked for more than 120 seconds.
>> [ 2948.928653]       Tainted: G         C O    4.14.9-1-ARCH #1
>> [ 2948.928658] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [ 2948.928665] systemd         D    0 22229  22226 0x00000100
>> [ 2948.928671] Call Trace:
>> [ 2948.928684]  ? __schedule+0x290/0x890
>> [ 2948.928690]  schedule+0x2f/0x90
>> [ 2948.928744]  btrfs_tree_read_lock+0xb6/0x100 [btrfs]
>> [ 2948.928752]  ? wait_woken+0x80/0x80
>> [ 2948.928799]  find_parent_nodes+0x341/0xfd0 [btrfs]
>> [ 2948.928827]  ? btrfs_search_slot+0x84c/0x9f0 [btrfs]
>> [ 2948.928873]  ? btrfs_find_all_roots_safe+0x9e/0x110 [btrfs]
>> [ 2948.928912]  btrfs_find_all_roots_safe+0x9e/0x110 [btrfs]
>> [ 2948.928950]  btrfs_find_all_roots+0x45/0x60 [btrfs]
>> [ 2948.928987]  btrfs_qgroup_trace_extent_post+0x30/0x60 [btrfs]
> 
> You're using qgroup, and the timing is to find the old_roots of one
> extent, which will only search commit roots.
> 
> Normally this shouldn't cause any problem, especially for commit roots.
> 
> Is there any special operation happening?

Nope. It appears it happens right when systemd-nspawn begins to run and I am not executing any other commands.

I did not realize qgroups are involved … all I did is mkfs.btrfs and running systemd-nspawn :-) Perhaps the defaults should be qgroups off? (But I digress)

>> That works well … but not for long. Often we don’t make it through the test suite and the starting of new containers hangs. Other filesystem operations also hang. The above stacktrace, or something rather similar shows up in dmesg (not in the journal, because that hangs, too!) This is repeated, but I don’t see any other relevant messages. Only a reboot seems to allows to recover.
> 
> So Qgroup is used to limit disk usage of each container?
> 
> Maybe it's related to subvolume deletion?
> 
> Anyway, if qgroup is not necessary, disabling qgroup should fix your
> problem.
> 
> Despite of that, did that really hangs?
> Qgroup dramatically increase overhead to delete a subvolume or balance
> the fs.
> Maybe it's just a little slow?

I have waited for several hours and the system has not recovered (me walking away from the running tests, returning hours later).

Update: so I executed "btrfs quota disable” on all relevant file systems. (right?) Running tests again, this morning I’m getting:

INFO: task systemd-journal:20876 blocked for more than 120 seconds.
[ 5037.962603]       Tainted: G         C O    4.14.9-1-ARCH #1
[ 5037.962609] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5037.962616] systemd-journal D    0 20876  20860 0x00000100
[ 5037.962622] Call Trace:
[ 5037.962635]  ? __schedule+0x290/0x890
[ 5037.962640]  ? __slab_free+0x14e/0x300
[ 5037.962645]  ? _copy_to_iter+0x8f/0x3d0
[ 5037.962651]  schedule+0x2f/0x90
[ 5037.962704]  btrfs_tree_read_lock+0xb6/0x100 [btrfs]
[ 5037.962713]  ? wait_woken+0x80/0x80
[ 5037.962739]  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
[ 5037.962767]  btrfs_search_slot+0x703/0x9f0 [btrfs]
[ 5037.962796]  btrfs_insert_empty_items+0x66/0xb0 [btrfs]
[ 5037.962841]  btrfs_insert_orphan_item+0x66/0xa0 [btrfs]
[ 5037.962880]  btrfs_orphan_add+0xa1/0x200 [btrfs]
[ 5037.962919]  btrfs_setattr+0x123/0x3b0 [btrfs]
[ 5037.962926]  notify_change+0x2fd/0x420
[ 5037.962933]  do_truncate+0x75/0xc0
[ 5037.962940]  do_sys_ftruncate.constprop.19+0xe7/0x100
[ 5037.962947]  do_syscall_64+0x55/0x110
[ 5037.962952]  entry_SYSCALL64_slow_path+0x25/0x25
[ 5037.962956] RIP: 0033:0x7fd9423697ba
[ 5037.962958] RSP: 002b:00007fff1179cc18 EFLAGS: 00000206 ORIG_RAX: 000000000000004d
[ 5037.962962] RAX: ffffffffffffffda RBX: 000055bd48cbe9f0 RCX: 00007fd9423697ba
[ 5037.962965] RDX: 000055bd48cbe660 RSI: 0000000000640000 RDI: 000000000000000f
[ 5037.962966] RBP: 00007fff1179cc50 R08: 000055bd48cbc62c R09: 000055bd48cbea6c
[ 5037.962968] R10: 000055bd48cbe9f0 R11: 0000000000000206 R12: 00007fff1179cc48
[ 5037.962970] R13: 0000000000000003 R14: 000562b7234e71a9 R15: 000055bd47749ca0

and doing a simple “touch /build/tmp/foo” never returns. 10+ hours have passed since the previous command was issued.


