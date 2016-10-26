Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:39340 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbcJZSmL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 14:42:11 -0400
Date: Wed, 26 Oct 2016 14:42:01 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: bio linked list corruption.
Message-ID: <20161026184201.6ofblkd3j5uxystq@codemonkey.org.uk>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 09:48:39AM -0700, Linus Torvalds wrote:

 > I know you already had this in some email, but I lost it. I think you
 > narrowed it down to a specific set of system calls that seems to
 > trigger this best. fallocate and xattrs or something?

So I was about to give that a shot again. That this has been running
doing for 24hrs was bugging me.  I ctrl-c'd the current run, and trinity
just sat there, because all of its child processes are stuck in D state.

The stacks show nearly all of them are stuck in sync_inodes_sb

iotop & vmstat shows there is _zero_ io actually happening.
So it's spent most the night doing next to nothing useful afaict.

Chris ?

Here's the /proc/pid/stack's of those children..


[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffffa009554f>] btrfs_wait_ordered_roots+0x3f/0x200 [btrfs]
[<ffffffffa00470d1>] btrfs_sync_fs+0x31/0xc0 [btrfs]
[<ffffffff811fbd4e>] sync_filesystem+0x6e/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff8131ae87>] call_rwsem_down_write_failed+0x17/0x30
[<ffffffff811fc294>] utimes_common+0xd4/0x190
[<ffffffff811fc457>] do_utimes+0x107/0x120
[<ffffffff811fc641>] SyS_futimesat+0xa1/0xd0
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff8131ae87>] call_rwsem_down_write_failed+0x17/0x30
[<ffffffffa008ed32>] btrfs_fallocate+0xb2/0xfd0 [btrfs]
[<ffffffff811c6c3e>] vfs_fallocate+0x13e/0x220
[<ffffffff811c79f3>] SyS_fallocate+0x43/0x80
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffffa009554f>] btrfs_wait_ordered_roots+0x3f/0x200 [btrfs]
[<ffffffffa00470d1>] btrfs_sync_fs+0x31/0xc0 [btrfs]
[<ffffffff811fbcdb>] sync_fs_one_sb+0x1b/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdd0>] sys_sync+0x50/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff8131ae87>] call_rwsem_down_write_failed+0x17/0x30
[<ffffffffa008c0f4>] btrfs_file_llseek+0x34/0x290 [btrfs]
[<ffffffff811c9ab5>] SyS_lseek+0x85/0xa0
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff8131ae87>] call_rwsem_down_write_failed+0x17/0x30
[<ffffffffa0090a0e>] btrfs_sync_file+0x7e/0x360 [btrfs]
[<ffffffff811fbbe6>] vfs_fsync_range+0x46/0xa0
[<ffffffffa00910e0>] btrfs_file_write_iter+0x3f0/0x550 [btrfs]
[<ffffffff811c97d8>] do_iter_readv_writev+0xa8/0x100
[<ffffffff811ca162>] do_readv_writev+0x172/0x210
[<ffffffff811ca42a>] vfs_writev+0x3a/0x50
[<ffffffff811ca5c0>] do_pwritev+0xb0/0xd0
[<ffffffff811cb592>] SyS_pwritev2+0x12/0x20
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811ea2d4>] __fdget_pos+0x44/0x50
[<ffffffff811de8ec>] SyS_getdents+0x6c/0x110
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff8131ae87>] call_rwsem_down_write_failed+0x17/0x30
[<ffffffff811c752a>] do_truncate+0x4a/0x90
[<ffffffff811c790c>] do_sys_ftruncate.constprop.19+0x10c/0x170
[<ffffffff811c7999>] SyS_ftruncate+0x9/0x10
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffffa0095413>] btrfs_wait_ordered_extents+0x1e3/0x2e0 [btrfs]
[<ffffffffa0095647>] btrfs_wait_ordered_roots+0x137/0x200 [btrfs]
[<ffffffffa00470d1>] btrfs_sync_fs+0x31/0xc0 [btrfs]
[<ffffffff811fbcdb>] sync_fs_one_sb+0x1b/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdd0>] sys_sync+0x50/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff81149fbf>] wait_on_page_bit+0xaf/0xc0
[<ffffffff8114a121>] __filemap_fdatawait_range+0x151/0x170
[<ffffffff8114d79c>] filemap_fdatawait_keep_errors+0x1c/0x20
[<ffffffff811f59b3>] sync_inodes_sb+0x273/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff8131ae87>] call_rwsem_down_write_failed+0x17/0x30
[<ffffffffa0090d50>] btrfs_file_write_iter+0x60/0x550 [btrfs]
[<ffffffff811c97d8>] do_iter_readv_writev+0xa8/0x100
[<ffffffff811ca162>] do_readv_writev+0x172/0x210
[<ffffffff811ca42a>] vfs_writev+0x3a/0x50
[<ffffffff811ca5c0>] do_pwritev+0xb0/0xd0
[<ffffffff811cb57c>] SyS_pwritev+0xc/0x10
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811ea2d4>] __fdget_pos+0x44/0x50
[<ffffffff811c9a48>] SyS_lseek+0x18/0xa0
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff8131ae87>] call_rwsem_down_write_failed+0x17/0x30
[<ffffffffa0090d50>] btrfs_file_write_iter+0x60/0x550 [btrfs]
[<ffffffff811c8e64>] __vfs_write+0xc4/0x120
[<ffffffff811c9f03>] vfs_write+0xb3/0x1a0
[<ffffffff811cb3d4>] SyS_pwrite64+0x74/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
[<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffffa009576b>] btrfs_start_ordered_extent+0x5b/0xb0 [btrfs]
[<ffffffffa008bf5d>] lock_and_cleanup_extent_if_need+0x22d/0x290 [btrfs]
[<ffffffffa008d1e8>] __btrfs_buffered_write+0x1b8/0x6e0 [btrfs]
[<ffffffffa0090e60>] btrfs_file_write_iter+0x170/0x550 [btrfs]
[<ffffffff811c97d8>] do_iter_readv_writev+0xa8/0x100
[<ffffffff811ca162>] do_readv_writev+0x172/0x210
[<ffffffff811ca42a>] vfs_writev+0x3a/0x50
[<ffffffff811ca5c0>] do_pwritev+0xb0/0xd0
[<ffffffff811cb57c>] SyS_pwritev+0xc/0x10
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff8131ae87>] call_rwsem_down_write_failed+0x17/0x30
[<ffffffffa0090d50>] btrfs_file_write_iter+0x60/0x550 [btrfs]
[<ffffffff811c8e64>] __vfs_write+0xc4/0x120
[<ffffffff811c998d>] __kernel_write+0x4d/0xf0
[<ffffffff811f995d>] write_pipe_buf+0x6d/0x80
[<ffffffff811f9cdf>] __splice_from_pipe+0x12f/0x1b0
[<ffffffff811fabdc>] splice_from_pipe+0x4c/0x70
[<ffffffff811fac34>] default_file_splice_write+0x14/0x20
[<ffffffff811f9081>] direct_splice_actor+0x31/0x40
[<ffffffff811f972c>] splice_direct_to_actor+0xcc/0x1e0
[<ffffffff811f98d0>] do_splice_direct+0x90/0xb0
[<ffffffff811cad30>] do_sendfile+0x1b0/0x390
[<ffffffff811cb7cf>] SyS_sendfile64+0x5f/0xd0
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff811f5806>] sync_inodes_sb+0xc6/0x300
[<ffffffff811fbac0>] sync_inodes_one_sb+0x10/0x20
[<ffffffff811cdd3f>] iterate_supers+0xaf/0x100
[<ffffffff811fbdb0>] sys_sync+0x30/0x90
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffff81086eee>] do_sigtimedwait+0x16e/0x260
[<ffffffff81087084>] SYSC_rt_sigtimedwait+0xa4/0x100
[<ffffffff810870e9>] SyS_rt_sigtimedwait+0x9/0x10
[<ffffffff8100255c>] do_syscall_64+0x5c/0x170
[<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff


