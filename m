Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34361 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754246AbcJZTGd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 15:06:33 -0400
MIME-Version: 1.0
In-Reply-To: <20161026184201.6ofblkd3j5uxystq@codemonkey.org.uk>
References: <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
 <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk> <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com>
 <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk> <77d9983d-a00a-1dc1-a9a1-631de1d0c146@fb.com>
 <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk> <CA+55aFyv0k9e6bBqGm-LL3CUwimS4+rSu341P7SOV5ezYrrW_g@mail.gmail.com>
 <CA+55aFydo5oxo+ihUfGffMK6cAZnbZ8WyEiF7xgEx1Bh_aOMww@mail.gmail.com>
 <20161026163018.wx57yy554576s6e2@codemonkey.org.uk> <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
 <20161026184201.6ofblkd3j5uxystq@codemonkey.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Oct 2016 12:06:21 -0700
Message-ID: <CA+55aFwD9McVapb0svQrrvP1k6iSkqz5ENNGXY6b+Yo-k7wOsg@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 11:42 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
>
> The stacks show nearly all of them are stuck in sync_inodes_sb

That's just wb_wait_for_completion(), and it means that some IO isn't
completing.

There's also a lot of processes waiting for inode_lock(), and a few
waiting for mnt_want_write()

Ignoring those, we have

> [<ffffffffa009554f>] btrfs_wait_ordered_roots+0x3f/0x200 [btrfs]
> [<ffffffffa00470d1>] btrfs_sync_fs+0x31/0xc0 [btrfs]
> [<ffffffff811fbd4e>] sync_filesystem+0x6e/0xa0
> [<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
> [<ffffffff8100255c>] do_syscall_64+0x5c/0x170
> [<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
> [<ffffffffffffffff>] 0xffffffffffffffff

Don't know this one. There's a couple of them. Could there be some
ABBA deadlock on the ordered roots waiting?

> [<ffffffff8131ae87>] call_rwsem_down_write_failed+0x17/0x30
> [<ffffffffa008ed32>] btrfs_fallocate+0xb2/0xfd0 [btrfs]
> [<ffffffff811c6c3e>] vfs_fallocate+0x13e/0x220
> [<ffffffff811c79f3>] SyS_fallocate+0x43/0x80
> [<ffffffff8100255c>] do_syscall_64+0x5c/0x170
> [<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
> [<ffffffffffffffff>] 0xffffffffffffffff

This one is also inode_lock(), and is interesting only because it's
fallocate(), which has shown up so many times before..

But there are other threads blocked on do_truncate, or
btrfs_file_write_iter instead, or on lseek, so this is not different
for any other reason.

> [<ffffffff81149fbf>] wait_on_page_bit+0xaf/0xc0
> [<ffffffff8114a121>] __filemap_fdatawait_range+0x151/0x170
> [<ffffffff8114d79c>] filemap_fdatawait_keep_errors+0x1c/0x20
> [<ffffffff811f59b3>] sync_inodes_sb+0x273/0x300
> [<ffffffff811fbd37>] sync_filesystem+0x57/0xa0
> [<ffffffff811fbebc>] SyS_syncfs+0x3c/0x70
> [<ffffffff8100255c>] do_syscall_64+0x5c/0x170
> [<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25
> [<ffffffffffffffff>] 0xffffffffffffffff

This is actually waiting on the page. Possibly this is the IO that is
never completing, and keeps the inode lock.

> [<ffffffffa009576b>] btrfs_start_ordered_extent+0x5b/0xb0 [btrfs]
> [<ffffffffa008bf5d>] lock_and_cleanup_extent_if_need+0x22d/0x290 [btrfs]
> [<ffffffffa008d1e8>] __btrfs_buffered_write+0x1b8/0x6e0 [btrfs]
> [<ffffffffa0090e60>] btrfs_file_write_iter+0x170/0x550 [btrfs]
> [<ffffffff811c97d8>] do_iter_readv_writev+0xa8/0x100
> [<ffffffff811ca162>] do_readv_writev+0x172/0x210
> [<ffffffff811ca42a>] vfs_writev+0x3a/0x50
> [<ffffffff811ca5c0>] do_pwritev+0xb0/0xd0
> [<ffffffff811cb57c>] SyS_pwritev+0xc/0x10
> [<ffffffff8100255c>] do_syscall_64+0x5c/0x170
> [<ffffffff817908cb>] entry_SYSCALL64_slow_path+0x25/0x25

Hmm. This is the one that *started* the ordered extents (as opposed to
the ones waiting for it)

I dunno. There might be a lost IO. More likely it's the same
corruption that causes it, it just didn't result in an oops this time.

             Linus
