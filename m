Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48235317165
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 18:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774462801; cv=none; b=UPhoS8sJpTaLH3df1Thgxj6CqmccKkYcESQXK7oPiLMz+zTmv72lCmHq0edXWfusC1NYuQZpWwK4jb0CJCQObP0elASpZ7DVFOLTG1vy98ez1GbDtKqxnUX/sKDfogspZJB3RX1XXYXjwUTA0MJjv5V55cq4e9/oETjlljIAuE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774462801; c=relaxed/simple;
	bh=k1j2E7ene0vpuE0sK7wSL0VgLcXQdgW1yqJ37CiQQYw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kQtIPf2lYF/Yg092mw9H3xh2ZFrWHBN7UCBoJtemUWGUwTlh3sNDG+PtAWccjIA9aEIqSpnpV47F36atXnRFnE5QCavjnK/C78SMWel3qSPpXxWUBeI4+yzkRvJFG79/Sw4x6EH4b796vZbXHDcYXYAdq3H6RSpVnPpsXmG4tB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qF4m97A4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qF4m97A4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F994C4CEF7
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 18:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774462800;
	bh=k1j2E7ene0vpuE0sK7wSL0VgLcXQdgW1yqJ37CiQQYw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qF4m97A4MkiANQh1i/MCPa3Ph9JUVio6TZpqgyC3+u8+oyviqIpWhAvwtie/62hpi
	 fkUV+nUeZP4nIlRLJjsMIiJNvg2ywlDp7n5RYQPq/+2M+e5dOoepR4FokpYYeXYEZd
	 ETqOK3inLpusQTnJjuQlDSAG70lZZdvatUpljnHs9rxKfy0jtmrS120EGXPYgseJUD
	 m8sk5TazNGDFW6VjlOoeprETtCKBmP71K5BOKbFW8aEJHqVLJBbZgEv7uqnD1UCteL
	 bQty/oQ0MZICEpI3pGqI4lLdsZHlWkQUQgHZoY5xGsWqAHwI9cWYuOxCaJMhSyiwWn
	 uxHC/dt+9JT6A==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-666f646f5cfso1952490a12.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 11:20:00 -0700 (PDT)
X-Gm-Message-State: AOJu0YyGpkGO8ABQhuAPu8d2o9cSs2EGIWlaUo1vHkk7YCjKNL5TJIzZ
	nc4ePSZbD0TWo/ithHbZHvvPiPwRXEQhraMDqX0Htkcqy7wQJFykDD3lW7mEu0Zpu+KWajD5afb
	I4sT+cbY+ezzDOMpMGp67AxPZjmNRQS0=
X-Received: by 2002:a17:906:7947:b0:b97:9a7a:9d21 with SMTP id
 a640c23a62f3a-b988630be52mr644572366b.4.1774462798715; Wed, 25 Mar 2026
 11:19:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <8ea80caca0a3ccbf2024d0851f1d099040d6c405.1774283088.git.fdmanana@suse.com>
 <20260325173329.GA2908386@zen.localdomain>
In-Reply-To: <20260325173329.GA2908386@zen.localdomain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 25 Mar 2026 18:19:21 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5kyrGkkGgyLcUnOCesTQeziNv=WpfcLT7wLYHZoB7Faw@mail.gmail.com>
X-Gm-Features: AQROBzCnpmwbHYqe9rimRhdTUqdLeqnAC-sI_jXl__z12kI7jFidaQl9POEBdC0
Message-ID: <CAL3q7H5kyrGkkGgyLcUnOCesTQeziNv=WpfcLT7wLYHZoB7Faw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix deadlock between reflink and transaction
 commit when using flushoncommit
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 25, 2026 at 5:33=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> On Mon, Mar 23, 2026 at 05:01:58PM +0000, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > When using the flushoncommit mount option, we can have a deadlock betwe=
en
> > a transaction commit and a reflink operation that copied an inline exte=
nt
> > to an offset beyond the current i_size of the destination node.
> >
> > The deadlock happens like this:
> >
> > 1) Task A clones an inline extent from inode X to an offset of inode Y
> >    that is beyond Y's current i_size. This means we copied the inline
> >    extent's data to a folio of inode Y that is beyond its EOF, using a
> >    call to copy_inline_to_page();
> >
> > 2) Task B starts a transaction commit and calls
> >    btrfs_start_delalloc_flush() to flush delalloc;
> >
> > 3) The delalloc flushing sees the new dirty folio of inode Y and when i=
t
> >    attempts to flush it, it ends up at extent_writepage() and sees that
> >    the offset of the folio is beyond the i_size of inode Y, so it attem=
pts
> >    to invalidate the folio by calling folio_invalidate(), which ends up=
 at
> >    btrfs' folio invalidate callback - btrfs_invalidate_folio(). There i=
t
> >    tries to lock the folio's range in inode Y's extent io tree, but it
> >    blocks since it's currently locked by task A - during a reflink we l=
ock
> >    the inodes and the source and destination ranges after flushing all
> >    delalloc and waiting for ordered extent completion - after that we
> >    don't expect to have dirty folios in the ranges, the exception is if
> >    we have to copy an inline extent's data (because the destination off=
set
> >    is not zero);
>
> mentioning the first lock "where it happens" in the sequence would make
> this easier to follow, IMO. With two files and two tasks, time
> travelling backwards while reading is kind of a mental hurdle.
>
> e.g. 1. Task A clones an inline extent ... in btrfs_clone_files we lock
> the destination range ...

Well it's mentioned in step 1, and extent locking is obvious since we
have to do it for any operation that changes extents in a range, it's
not exclusive to reflinks, we do this everywhere in btrfs. I mentioned
it here in step 2 as a remainder.

>
> >
> > 4) Task A then attempts to start a transaction to update the inode item=
,
> >    and then it's blocked since the current transaction is in the
> >    TRANS_STATE_COMMIT_START state. Therefore task A has to wait for the
> >    current transaction to become unblocked (its state >=3D
> >    TRANS_STATE_UNBLOCKED).
> >
> >    So task A is waiting for the transaction commit done by task B, and
> >    the later waiting on the extent lock of inode Y that is currently
> >    held by task A.
>
> I believe your stack traces below show a slightly different picture with
> three tasks: clone, commit, and writeback worker. The essential lock
> cycle seems correct but that detail is different from your description.
> Have you seen different forms of it where the commit task is directly
> blocked?

I didn't mention the commit task waiting for the writeback worker to
simplify things.
I think anyone is able to realize the commit task blocks waiting for
the writeback worker to complete - the stack traces make that obvious.

And no, I haven't seen any case where the commit task is directly
blocked - I don't see how that could happen unless the implementation
of try_to_writeback_inodes_sb() changes and it directly does the
writeback instead of using a worker.

>
> >
> > Syzbot recently reported this with the following stack traces:
> >
> >   INFO: task kworker/u8:7:1053 blocked for more than 143 seconds.
> >         Not tainted syzkaller #0
> >   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this mess=
age.
> >   task:kworker/u8:7    state:D stack:23520 pid:1053  tgid:1053  ppid:2 =
     task_flags:0x4208060 flags:0x00080000
> >   Workqueue: writeback wb_workfn (flush-btrfs-46)
> >   Call Trace:
> >    <TASK>
> >    context_switch kernel/sched/core.c:5298 [inline]
> >    __schedule+0x1553/0x5240 kernel/sched/core.c:6911
> >    __schedule_loop kernel/sched/core.c:6993 [inline]
> >    schedule+0x164/0x360 kernel/sched/core.c:7008
> >    wait_extent_bit fs/btrfs/extent-io-tree.c:811 [inline]
> >    btrfs_lock_extent_bits+0x59c/0x700 fs/btrfs/extent-io-tree.c:1914
> >    btrfs_lock_extent fs/btrfs/extent-io-tree.h:152 [inline]
> >    btrfs_invalidate_folio+0x43d/0xc40 fs/btrfs/inode.c:7704
> >    extent_writepage fs/btrfs/extent_io.c:1852 [inline]
> >    extent_write_cache_pages fs/btrfs/extent_io.c:2580 [inline]
> >    btrfs_writepages+0x12ff/0x2440 fs/btrfs/extent_io.c:2713
> >    do_writepages+0x32e/0x550 mm/page-writeback.c:2554
> >    __writeback_single_inode+0x133/0x11a0 fs/fs-writeback.c:1750
> >    writeback_sb_inodes+0x995/0x19d0 fs/fs-writeback.c:2042
> >    wb_writeback+0x456/0xb70 fs/fs-writeback.c:2227
> >    wb_do_writeback fs/fs-writeback.c:2374 [inline]
> >    wb_workfn+0x41a/0xf60 fs/fs-writeback.c:2414
> >    process_one_work kernel/workqueue.c:3276 [inline]
> >    process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
> >    worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
> >    kthread+0x388/0x470 kernel/kthread.c:436
> >    ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
> >    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >    </TASK>
> >   INFO: task syz.4.64:6910 blocked for more than 143 seconds.
> >         Not tainted syzkaller #0
> >   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this mess=
age.
> >   task:syz.4.64        state:D stack:22752 pid:6910  tgid:6905  ppid:59=
44   task_flags:0x400140 flags:0x00080002
> >   Call Trace:
> >    <TASK>
> >    context_switch kernel/sched/core.c:5298 [inline]
> >    __schedule+0x1553/0x5240 kernel/sched/core.c:6911
> >    __schedule_loop kernel/sched/core.c:6993 [inline]
> >    schedule+0x164/0x360 kernel/sched/core.c:7008
> >    wait_current_trans+0x39f/0x590 fs/btrfs/transaction.c:535
> >    start_transaction+0x6a7/0x1650 fs/btrfs/transaction.c:705
> >    clone_copy_inline_extent fs/btrfs/reflink.c:299 [inline]
> >    btrfs_clone+0x128a/0x24d0 fs/btrfs/reflink.c:529
> >    btrfs_clone_files+0x271/0x3f0 fs/btrfs/reflink.c:750
> >    btrfs_remap_file_range+0x76b/0x1320 fs/btrfs/reflink.c:903
> >    vfs_copy_file_range+0xda7/0x1390 fs/read_write.c:1600
> >    __do_sys_copy_file_range fs/read_write.c:1683 [inline]
> >    __se_sys_copy_file_range+0x2fb/0x480 fs/read_write.c:1650
> >    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >    do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
> >    entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >   RIP: 0033:0x7f5f73afc799
> >   RSP: 002b:00007f5f7315e028 EFLAGS: 00000246 ORIG_RAX: 000000000000014=
6
> >   RAX: ffffffffffffffda RBX: 00007f5f73d75fa0 RCX: 00007f5f73afc799
> >   RDX: 0000000000000005 RSI: 0000000000000000 RDI: 0000000000000005
> >   RBP: 00007f5f73b92c99 R08: 0000000000000863 R09: 0000000000000000
> >   R10: 00002000000000c0 R11: 0000000000000246 R12: 0000000000000000
> >   R13: 00007f5f73d76038 R14: 00007f5f73d75fa0 R15: 00007fff138a5068
> >    </TASK>
> >   INFO: task syz.4.64:6975 blocked for more than 143 seconds.
> >         Not tainted syzkaller #0
> >   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this mess=
age.
> >   task:syz.4.64        state:D stack:24736 pid:6975  tgid:6905  ppid:59=
44   task_flags:0x400040 flags:0x00080002
> >   Call Trace:
> >    <TASK>
> >    context_switch kernel/sched/core.c:5298 [inline]
> >    __schedule+0x1553/0x5240 kernel/sched/core.c:6911
> >    __schedule_loop kernel/sched/core.c:6993 [inline]
> >    schedule+0x164/0x360 kernel/sched/core.c:7008
> >    wb_wait_for_completion+0x3e8/0x790 fs/fs-writeback.c:227
> >    __writeback_inodes_sb_nr+0x24c/0x2d0 fs/fs-writeback.c:2838
> >    try_to_writeback_inodes_sb+0x9a/0xc0 fs/fs-writeback.c:2886
> >    btrfs_start_delalloc_flush fs/btrfs/transaction.c:2175 [inline]
> >    btrfs_commit_transaction+0x82e/0x31a0 fs/btrfs/transaction.c:2364
> >    btrfs_ioctl+0xca7/0xd00 fs/btrfs/ioctl.c:5206
> >    vfs_ioctl fs/ioctl.c:51 [inline]
> >    __do_sys_ioctl fs/ioctl.c:597 [inline]
> >    __se_sys_ioctl+0xff/0x170 fs/ioctl.c:583
> >    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >    do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
> >    entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >   RIP: 0033:0x7f5f73afc799
> >   RSP: 002b:00007f5f7313d028 EFLAGS: 00000246 ORIG_RAX: 000000000000001=
0
> >   RAX: ffffffffffffffda RBX: 00007f5f73d76090 RCX: 00007f5f73afc799
> >   RDX: 0000000000000000 RSI: 0000000000009408 RDI: 0000000000000004
> >   RBP: 00007f5f73b92c99 R08: 0000000000000000 R09: 0000000000000000
> >   R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> >   R13: 00007f5f73d76128 R14: 00007f5f73d76090 R15: 00007fff138a5068
> >    </TASK>
> >
> > Fix this by updating the i_size of the destination inode of a reflink
> > operation after we copy an inline extent's data to an offset beyond the
> > i_size and before attempting to start a transaction to update the inode=
's
> > item.
> >
> > Reported-by: syzbot+63056bf627663701bbbf@syzkaller.appspotmail.com
> > Link: https://lore.kernel.org/linux-btrfs/69bba3fe.050a0220.227207.002f=
.GAE@google.com/
> > Fixes: 05a5a7621ce6 ("Btrfs: implement full reflink support for inline =
extents")
>
> The fix LGTM, thank you.
> Reviewed-by: Boris Burkov <boris@bur.io>

Thanks!

>
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  fs/btrfs/reflink.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 45 insertions(+)
> >
> > diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> > index fca00c0f5387..49865a463780 100644
> > --- a/fs/btrfs/reflink.c
> > +++ b/fs/btrfs/reflink.c
> > @@ -322,6 +322,51 @@ static int clone_copy_inline_extent(struct btrfs_i=
node *inode,
> >
> >       ret =3D copy_inline_to_page(inode, new_key->offset,
> >                                 inline_data, size, datal, comp_type);
> > +
> > +     /*
> > +      * If we copied the inline extent data to a page/folio beyond the=
 i_size
> > +      * of the destination inode, then we need to increase the i_size =
before
> > +      * we start a transaction to update the inode item. This is to pr=
event a
> > +      * deadlock when the flushoncommit mount option is used, which ha=
ppens
> > +      * like this:
> > +      *
> > +      * 1) Task A clones an inline extent from inode X to an offset of=
 inode
> > +      *    Y that is beyond Y's current i_size. This means we copied t=
he
> > +      *    inline extent's data to a folio of inode Y that is beyond i=
ts EOF,
> > +      *    using the call above to copy_inline_to_page();
> > +      *
> > +      * 2) Task B starts a transaction commit and calls
> > +      *    btrfs_start_delalloc_flush() to flush delalloc;
> > +      *
> > +      * 3) The delalloc flushing sees the new dirty folio of inode Y a=
nd when
> > +      *    it attempts to flush it, it ends up at extent_writepage() a=
nd sees
> > +      *    that the offset of the folio is beyond the i_size of inode =
Y, so
> > +      *    it attempts to invalidate the folio by calling folio_invali=
date(),
> > +      *    which ends up at btrfs' folio invalidate callback -
> > +      *    btrfs_invalidate_folio(). There it tries to lock the folio'=
s range
> > +      *    in inode Y's extent io tree, but it blocks since it's curre=
ntly
> > +      *    locked by task A - during reflink we lock the inodes and th=
e
> > +      *    source and destination ranges after flushing all delalloc a=
nd
> > +      *    waiting for ordered extent completion - after that we don't=
 expect
> > +      *    to have dirty folios in the ranges, the exception is if we =
have to
> > +      *    copy an inline extent's data (because the destination offse=
t is
> > +      *    not zero);
> > +      *
> > +      * 4) Task A then does the 'goto out' below and attempts to start=
 a
> > +      *    transaction to update the inode item, and then it's blocked=
 since
> > +      *    the current transaction is in the TRANS_STATE_COMMIT_START =
state.
> > +      *    Therefore task A has to wait for the current transaction to=
 become
> > +      *    unblocked (its state >=3D TRANS_STATE_UNBLOCKED).
> > +      *
> > +      * This leads to a deadlock - the task committing the transaction
> > +      * waiting for the delalloc flushing which is blocked during foli=
o
> > +      * invalidation on the inode's extent lock and the reflink task w=
aiting
> > +      * for the current transaction to be unblocked so that it can sta=
rt a
> > +      * a new one to update the inode item (while holding the extent l=
ock).
> > +      */
> > +     if (ret =3D=3D 0 && new_key->offset + datal > i_size_read(&inode-=
>vfs_inode))
> > +             i_size_write(&inode->vfs_inode, new_key->offset + datal);
> > +
> >       goto out;
> >  }
> >
> > --
> > 2.47.2
> >
