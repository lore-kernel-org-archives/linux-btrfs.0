Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37654 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933292AbcJZVxS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 17:53:18 -0400
Subject: Re: bio linked list corruption.
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        "Andy Lutomirski" <luto@kernel.org>, Jens Axboe <axboe@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
References: <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
 <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
 <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com>
 <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk>
 <77d9983d-a00a-1dc1-a9a1-631de1d0c146@fb.com>
 <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk>
 <CA+55aFyv0k9e6bBqGm-LL3CUwimS4+rSu341P7SOV5ezYrrW_g@mail.gmail.com>
 <CA+55aFydo5oxo+ihUfGffMK6cAZnbZ8WyEiF7xgEx1Bh_aOMww@mail.gmail.com>
 <20161026163018.wx57yy554576s6e2@codemonkey.org.uk>
 <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
 <20161026184201.6ofblkd3j5uxystq@codemonkey.org.uk>
 <CA+55aFwD9McVapb0svQrrvP1k6iSkqz5ENNGXY6b+Yo-k7wOsg@mail.gmail.com>
 <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com>
From: Chris Mason <clm@fb.com>
Message-ID: <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com>
Date: Wed, 26 Oct 2016 17:52:52 -0400
MIME-Version: 1.0
In-Reply-To: <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/26/2016 04:00 PM, Chris Mason wrote:
> 
> 
> On 10/26/2016 03:06 PM, Linus Torvalds wrote:
>> On Wed, Oct 26, 2016 at 11:42 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
>>>
>>> The stacks show nearly all of them are stuck in sync_inodes_sb
>>
>> That's just wb_wait_for_completion(), and it means that some IO isn't
>> completing.
>>
>> There's also a lot of processes waiting for inode_lock(), and a few
>> waiting for mnt_want_write()
>>
>> Ignoring those, we have
>>
>>> [<ffffffffa009554f>] btrfs_wait_ordered_roots+0x3f/0x200 [btrfs]
>>> [<ffffffffa00470d1>] btrfs_sync_fs+0x31/0xc0 [btrfs]
>>> [<ffffffff811fbd4e>] sync_filesystem+0x6e/0xa0
>>> [<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
>>> [<ffffffff8100255c>] do_syscall_64+0x5c/0x170
>>> [<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> Don't know this one. There's a couple of them. Could there be some
>> ABBA deadlock on the ordered roots waiting?
> 
> It's always possible, but we haven't changed anything here.
> 
> I've tried a long list of things to reproduce this on my test boxes,
> including days of trinity runs and a kernel module to exercise vmalloc,
> and thread creation.
> 
> Today I turned off every CONFIG_DEBUG_* except for list debugging, and
> ran dbench 2048:
> 

This one is special because CONFIG_VMAP_STACK is not set.  Btrfs triggers in < 10 minutes.
I've done 30 minutes each with XFS and Ext4 without luck.

This is all in a virtual machine that I can copy on to a bunch of hosts.  So I'll get some
parallel tests going tonight to narrow it down.

------------[ cut here ]------------
WARNING: CPU: 6 PID: 4481 at lib/list_debug.c:33 __list_add+0xbe/0xd0
list_add corruption. prev->next should be next (ffffe8ffffd80b08), but was ffff88012b65fb88. (prev=ffff880128c8d500).
Modules linked in: crc32c_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper i2c_piix4 cryptd i2c_core virtio_net serio_raw floppy button pcspkr sch_fq_codel autofs4 virtio_blk
CPU: 6 PID: 4481 Comm: dbench Not tainted 4.9.0-rc2-15419-g811d54d #319
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.0-1.fc24 04/01/2014
 ffff880104eff868 ffffffff814fde0f ffffffff8151c46e ffff880104eff8c8
 ffff880104eff8c8 0000000000000000 ffff880104eff8b8 ffffffff810648cf
 ffff880128cab2c0 000000213fc57c68 ffff8801384e8928 ffff880128cab180
Call Trace:
 [<ffffffff814fde0f>] dump_stack+0x53/0x74
 [<ffffffff8151c46e>] ? __list_add+0xbe/0xd0
 [<ffffffff810648cf>] __warn+0xff/0x120
 [<ffffffff810649a9>] warn_slowpath_fmt+0x49/0x50
 [<ffffffff8151c46e>] __list_add+0xbe/0xd0
 [<ffffffff814dec38>] blk_sq_make_request+0x388/0x580
 [<ffffffff814d5444>] generic_make_request+0x104/0x200
 [<ffffffff814d55a5>] submit_bio+0x65/0x130
 [<ffffffff8152a256>] ? __percpu_counter_add+0x96/0xd0
 [<ffffffff81425c7c>] btrfs_map_bio+0x23c/0x310
 [<ffffffff813f3e73>] btrfs_submit_bio_hook+0xd3/0x190
 [<ffffffff8141136d>] submit_one_bio+0x6d/0xa0
 [<ffffffff814113ee>] flush_epd_write_bio+0x4e/0x70
 [<ffffffff8141894d>] extent_writepages+0x5d/0x70
 [<ffffffff813f80a0>] ? btrfs_releasepage+0x50/0x50
 [<ffffffff81220d0e>] ? wbc_attach_and_unlock_inode+0x6e/0x170
 [<ffffffff813f4c07>] btrfs_writepages+0x27/0x30
 [<ffffffff811783a0>] do_writepages+0x20/0x30
 [<ffffffff81167a95>] __filemap_fdatawrite_range+0xb5/0x100
 [<ffffffff81167f73>] filemap_fdatawrite_range+0x13/0x20
 [<ffffffff8140563b>] btrfs_fdatawrite_range+0x2b/0x70
 [<ffffffff81405768>] btrfs_sync_file+0x88/0x490
 [<ffffffff81074ef2>] ? group_send_sig_info+0x42/0x80
 [<ffffffff81074f8d>] ? kill_pid_info+0x5d/0x90
 [<ffffffff8107535a>] ? SYSC_kill+0xba/0x1d0
 [<ffffffff811f2348>] ? __sb_end_write+0x58/0x80
 [<ffffffff812258ac>] vfs_fsync_range+0x4c/0xb0
 [<ffffffff81002501>] ? syscall_trace_enter+0x201/0x2e0
 [<ffffffff8122592c>] vfs_fsync+0x1c/0x20
 [<ffffffff8122596d>] do_fsync+0x3d/0x70
 [<ffffffff810029cb>] ? syscall_slow_exit_work+0xfb/0x100
 [<ffffffff812259d0>] SyS_fsync+0x10/0x20
 [<ffffffff81002b65>] do_syscall_64+0x55/0xd0
 [<ffffffff810026d7>] ? prepare_exit_to_usermode+0x37/0x40
 [<ffffffff819ad246>] entry_SYSCALL64_slow_path+0x25/0x25
---[ end trace efe6b17c6dba2a6e ]---
