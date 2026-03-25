Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C412236F2
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 17:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774460029; cv=none; b=nK3HI/hlBYhIIdVm9uKuzBmxf9Uy59QnsHs4k00cg94tEUVfU03sChbN31u2yskKNlTEJ8hwiYtc6+hpNBvwLdLn9rkvESU4KJ6NoBca6DbCOebNPbdV8wY6YhcmXHkQgaLvpsx/Ymjdh+ld+OWnu1906Q9NwHTgswGHq/n93vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774460029; c=relaxed/simple;
	bh=Nr1+FqLlfhihTpmfnosHk6PJjABh468yj3UgoZWym8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BV04BQegMWOKI2k+PNYXQoaXb3XDmu1DhXeTHei8IKmk70lq2nufMaNA82dDbDRLsQjIq15nqGnbleXfXNtNpYcu+Zd0XBkKqGi6XFzPMuoaXd/3K2aA8JsSy9KYwbX0Gmj10QdB/O6Wl5iDdfOWUWLjipeSWxxT1J+Y4YznUpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=M0CvK/Wl; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=m16nEdC4; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="M0CvK/Wl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="m16nEdC4"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id AACF41D00224;
	Wed, 25 Mar 2026 13:33:45 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 25 Mar 2026 13:33:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1774460025; x=1774546425; bh=ls/yKPTnSZ
	HLfCdzoUrJXyGJsPnC91c2XKKPC6eoC0k=; b=M0CvK/WlvG2lk46yUbN7Ux8F34
	7vYlNQRt+9TiIMz8JPgLK7K0wYkQCSV0MEC6MJJrDlNJa8PC6/1Gjv5DlboOOR6u
	Ae4sYnqrMfWQZPn5qb7VC70IkFVsXwHnwXpZ+/AXdwTS+r7mlRxEKzEL9LoNec8e
	zZ9Ru6ct2y14R0DegN2KpbyKiLzRTDBITmCxO1zggjZRihynYFsH28VOcw4/i00o
	TDDdQoj75DqMDCU7umnTsOUc+9qNdKMEogDVIovLSLAou2vb1dyibCMYk8SvdOhg
	3xoPe15A+aMqNAJNU3dWz3t4qQ+nF8lOU9RYCmkwZKeTtUUgjcnyGGQiGSXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1774460025; x=1774546425; bh=ls/yKPTnSZHLfCdzoUrJXyGJsPnC91c2XKK
	PC6eoC0k=; b=m16nEdC4uk3XJYy2g/7VCcvql4TQn9R8w/IM7J5nEFrJVrNBxoS
	k6batJdVpu10jmbA9vZMHxP47qAnQ3Zg9DvSZlLmnC36XCP0OCdLeUVrQkJO/tHq
	0/T9RUu+bRFXelXAnJjyCtxlpl3N7hLUJkE0Sp4uclbvT0n1o9E+Tplo9Cw5WbXR
	K/RxxCDUNZdmdz7gOsZBqMeDydzkGP+gvfTSz82IScZyRkVPsXgDJrlhRX+JdLq5
	oEKCKms0wxDCfzeRbsRjEmpNgZzmkVpeDW+hlP4Ew5OkxVzllQ1cbzSrO3fpLsNu
	JyAfeZ0tZgzGp7NNar+r6/Yi4/T60DiwUug==
X-ME-Sender: <xms:eRzEaaS6TkOKhIE9-51jhe1TyFldnQGKZDN2z8TvSQA2LReFWdGBaA>
    <xme:eRzEaVxv-INWdjx8QbjBR2AEi3GFXE8dQWzI3K57IwyZWMSWIS01jGmsNG_pmCukj
    Yl0YHMY4q3pNuVI4i3xF0i8R3iOiQ8FhdGcY9vq6KPYWPDApCWdvA>
X-ME-Received: <xmr:eRzEaVcI7QmnzWUoLRTKC2GgIKmXiLnvikFf4Pb78SqnD2RkxCMTnDmOIG4WPDPbXzs11-4iQMAbI3vzzr1JUdAC7so>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdehtdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhephedthfevgffhtdevgffhlefhgfeuueegtdevudeihe
    eiheetleeghedvfeegfeegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepfhgumhgrnhgrnhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqd
    gsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:eRzEaRIAeXn0wLTpo7O-lmjghlx-TnE98xO7_Lk95mt_nNevSfHOoA>
    <xmx:eRzEaWGx8wRbrP50hvTcBsjT6wX14pEIUFFN29mjloGMOUXP6TRJuQ>
    <xmx:eRzEabqXI054yR63NcsVU_SsoyOquvcafabLMVkZBe9JjPEzKNBr8A>
    <xmx:eRzEafRohUbi2d-q0_cLc2C3RwY3bclXY96DfqD4D66Kwn2urEc21g>
    <xmx:eRzEaRFgTskUVAVvdcSJshcAZziP4ckrQnKKaFfDQt4_ThW1eHu923cK>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Mar 2026 13:33:44 -0400 (EDT)
Date: Wed, 25 Mar 2026 10:33:29 -0700
From: Boris Burkov <boris@bur.io>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix deadlock between reflink and transaction
 commit when using flushoncommit
Message-ID: <20260325173329.GA2908386@zen.localdomain>
References: <8ea80caca0a3ccbf2024d0851f1d099040d6c405.1774283088.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ea80caca0a3ccbf2024d0851f1d099040d6c405.1774283088.git.fdmanana@suse.com>

On Mon, Mar 23, 2026 at 05:01:58PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When using the flushoncommit mount option, we can have a deadlock between
> a transaction commit and a reflink operation that copied an inline extent
> to an offset beyond the current i_size of the destination node.
> 
> The deadlock happens like this:
> 
> 1) Task A clones an inline extent from inode X to an offset of inode Y
>    that is beyond Y's current i_size. This means we copied the inline
>    extent's data to a folio of inode Y that is beyond its EOF, using a
>    call to copy_inline_to_page();
> 
> 2) Task B starts a transaction commit and calls
>    btrfs_start_delalloc_flush() to flush delalloc;
> 
> 3) The delalloc flushing sees the new dirty folio of inode Y and when it
>    attempts to flush it, it ends up at extent_writepage() and sees that
>    the offset of the folio is beyond the i_size of inode Y, so it attempts
>    to invalidate the folio by calling folio_invalidate(), which ends up at
>    btrfs' folio invalidate callback - btrfs_invalidate_folio(). There it
>    tries to lock the folio's range in inode Y's extent io tree, but it
>    blocks since it's currently locked by task A - during a reflink we lock
>    the inodes and the source and destination ranges after flushing all
>    delalloc and waiting for ordered extent completion - after that we
>    don't expect to have dirty folios in the ranges, the exception is if
>    we have to copy an inline extent's data (because the destination offset
>    is not zero);

mentioning the first lock "where it happens" in the sequence would make
this easier to follow, IMO. With two files and two tasks, time
travelling backwards while reading is kind of a mental hurdle.

e.g. 1. Task A clones an inline extent ... in btrfs_clone_files we lock
the destination range ...

> 
> 4) Task A then attempts to start a transaction to update the inode item,
>    and then it's blocked since the current transaction is in the
>    TRANS_STATE_COMMIT_START state. Therefore task A has to wait for the
>    current transaction to become unblocked (its state >=
>    TRANS_STATE_UNBLOCKED).
> 
>    So task A is waiting for the transaction commit done by task B, and
>    the later waiting on the extent lock of inode Y that is currently
>    held by task A.

I believe your stack traces below show a slightly different picture with
three tasks: clone, commit, and writeback worker. The essential lock
cycle seems correct but that detail is different from your description.
Have you seen different forms of it where the commit task is directly
blocked?

> 
> Syzbot recently reported this with the following stack traces:
> 
>   INFO: task kworker/u8:7:1053 blocked for more than 143 seconds.
>         Not tainted syzkaller #0
>   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>   task:kworker/u8:7    state:D stack:23520 pid:1053  tgid:1053  ppid:2      task_flags:0x4208060 flags:0x00080000
>   Workqueue: writeback wb_workfn (flush-btrfs-46)
>   Call Trace:
>    <TASK>
>    context_switch kernel/sched/core.c:5298 [inline]
>    __schedule+0x1553/0x5240 kernel/sched/core.c:6911
>    __schedule_loop kernel/sched/core.c:6993 [inline]
>    schedule+0x164/0x360 kernel/sched/core.c:7008
>    wait_extent_bit fs/btrfs/extent-io-tree.c:811 [inline]
>    btrfs_lock_extent_bits+0x59c/0x700 fs/btrfs/extent-io-tree.c:1914
>    btrfs_lock_extent fs/btrfs/extent-io-tree.h:152 [inline]
>    btrfs_invalidate_folio+0x43d/0xc40 fs/btrfs/inode.c:7704
>    extent_writepage fs/btrfs/extent_io.c:1852 [inline]
>    extent_write_cache_pages fs/btrfs/extent_io.c:2580 [inline]
>    btrfs_writepages+0x12ff/0x2440 fs/btrfs/extent_io.c:2713
>    do_writepages+0x32e/0x550 mm/page-writeback.c:2554
>    __writeback_single_inode+0x133/0x11a0 fs/fs-writeback.c:1750
>    writeback_sb_inodes+0x995/0x19d0 fs/fs-writeback.c:2042
>    wb_writeback+0x456/0xb70 fs/fs-writeback.c:2227
>    wb_do_writeback fs/fs-writeback.c:2374 [inline]
>    wb_workfn+0x41a/0xf60 fs/fs-writeback.c:2414
>    process_one_work kernel/workqueue.c:3276 [inline]
>    process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
>    worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
>    kthread+0x388/0x470 kernel/kthread.c:436
>    ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
>    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>    </TASK>
>   INFO: task syz.4.64:6910 blocked for more than 143 seconds.
>         Not tainted syzkaller #0
>   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>   task:syz.4.64        state:D stack:22752 pid:6910  tgid:6905  ppid:5944   task_flags:0x400140 flags:0x00080002
>   Call Trace:
>    <TASK>
>    context_switch kernel/sched/core.c:5298 [inline]
>    __schedule+0x1553/0x5240 kernel/sched/core.c:6911
>    __schedule_loop kernel/sched/core.c:6993 [inline]
>    schedule+0x164/0x360 kernel/sched/core.c:7008
>    wait_current_trans+0x39f/0x590 fs/btrfs/transaction.c:535
>    start_transaction+0x6a7/0x1650 fs/btrfs/transaction.c:705
>    clone_copy_inline_extent fs/btrfs/reflink.c:299 [inline]
>    btrfs_clone+0x128a/0x24d0 fs/btrfs/reflink.c:529
>    btrfs_clone_files+0x271/0x3f0 fs/btrfs/reflink.c:750
>    btrfs_remap_file_range+0x76b/0x1320 fs/btrfs/reflink.c:903
>    vfs_copy_file_range+0xda7/0x1390 fs/read_write.c:1600
>    __do_sys_copy_file_range fs/read_write.c:1683 [inline]
>    __se_sys_copy_file_range+0x2fb/0x480 fs/read_write.c:1650
>    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>    do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   RIP: 0033:0x7f5f73afc799
>   RSP: 002b:00007f5f7315e028 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
>   RAX: ffffffffffffffda RBX: 00007f5f73d75fa0 RCX: 00007f5f73afc799
>   RDX: 0000000000000005 RSI: 0000000000000000 RDI: 0000000000000005
>   RBP: 00007f5f73b92c99 R08: 0000000000000863 R09: 0000000000000000
>   R10: 00002000000000c0 R11: 0000000000000246 R12: 0000000000000000
>   R13: 00007f5f73d76038 R14: 00007f5f73d75fa0 R15: 00007fff138a5068
>    </TASK>
>   INFO: task syz.4.64:6975 blocked for more than 143 seconds.
>         Not tainted syzkaller #0
>   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>   task:syz.4.64        state:D stack:24736 pid:6975  tgid:6905  ppid:5944   task_flags:0x400040 flags:0x00080002
>   Call Trace:
>    <TASK>
>    context_switch kernel/sched/core.c:5298 [inline]
>    __schedule+0x1553/0x5240 kernel/sched/core.c:6911
>    __schedule_loop kernel/sched/core.c:6993 [inline]
>    schedule+0x164/0x360 kernel/sched/core.c:7008
>    wb_wait_for_completion+0x3e8/0x790 fs/fs-writeback.c:227
>    __writeback_inodes_sb_nr+0x24c/0x2d0 fs/fs-writeback.c:2838
>    try_to_writeback_inodes_sb+0x9a/0xc0 fs/fs-writeback.c:2886
>    btrfs_start_delalloc_flush fs/btrfs/transaction.c:2175 [inline]
>    btrfs_commit_transaction+0x82e/0x31a0 fs/btrfs/transaction.c:2364
>    btrfs_ioctl+0xca7/0xd00 fs/btrfs/ioctl.c:5206
>    vfs_ioctl fs/ioctl.c:51 [inline]
>    __do_sys_ioctl fs/ioctl.c:597 [inline]
>    __se_sys_ioctl+0xff/0x170 fs/ioctl.c:583
>    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>    do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   RIP: 0033:0x7f5f73afc799
>   RSP: 002b:00007f5f7313d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>   RAX: ffffffffffffffda RBX: 00007f5f73d76090 RCX: 00007f5f73afc799
>   RDX: 0000000000000000 RSI: 0000000000009408 RDI: 0000000000000004
>   RBP: 00007f5f73b92c99 R08: 0000000000000000 R09: 0000000000000000
>   R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>   R13: 00007f5f73d76128 R14: 00007f5f73d76090 R15: 00007fff138a5068
>    </TASK>
> 
> Fix this by updating the i_size of the destination inode of a reflink
> operation after we copy an inline extent's data to an offset beyond the
> i_size and before attempting to start a transaction to update the inode's
> item.
> 
> Reported-by: syzbot+63056bf627663701bbbf@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/linux-btrfs/69bba3fe.050a0220.227207.002f.GAE@google.com/
> Fixes: 05a5a7621ce6 ("Btrfs: implement full reflink support for inline extents")

The fix LGTM, thank you.
Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/reflink.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index fca00c0f5387..49865a463780 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -322,6 +322,51 @@ static int clone_copy_inline_extent(struct btrfs_inode *inode,
>  
>  	ret = copy_inline_to_page(inode, new_key->offset,
>  				  inline_data, size, datal, comp_type);
> +
> +	/*
> +	 * If we copied the inline extent data to a page/folio beyond the i_size
> +	 * of the destination inode, then we need to increase the i_size before
> +	 * we start a transaction to update the inode item. This is to prevent a
> +	 * deadlock when the flushoncommit mount option is used, which happens
> +	 * like this:
> +	 *
> +	 * 1) Task A clones an inline extent from inode X to an offset of inode
> +	 *    Y that is beyond Y's current i_size. This means we copied the
> +	 *    inline extent's data to a folio of inode Y that is beyond its EOF,
> +	 *    using the call above to copy_inline_to_page();
> +	 *
> +	 * 2) Task B starts a transaction commit and calls
> +	 *    btrfs_start_delalloc_flush() to flush delalloc;
> +	 *
> +	 * 3) The delalloc flushing sees the new dirty folio of inode Y and when
> +	 *    it attempts to flush it, it ends up at extent_writepage() and sees
> +	 *    that the offset of the folio is beyond the i_size of inode Y, so
> +	 *    it attempts to invalidate the folio by calling folio_invalidate(),
> +	 *    which ends up at btrfs' folio invalidate callback -
> +	 *    btrfs_invalidate_folio(). There it tries to lock the folio's range
> +	 *    in inode Y's extent io tree, but it blocks since it's currently
> +	 *    locked by task A - during reflink we lock the inodes and the
> +	 *    source and destination ranges after flushing all delalloc and
> +	 *    waiting for ordered extent completion - after that we don't expect
> +	 *    to have dirty folios in the ranges, the exception is if we have to
> +	 *    copy an inline extent's data (because the destination offset is
> +	 *    not zero);
> +	 *
> +	 * 4) Task A then does the 'goto out' below and attempts to start a
> +	 *    transaction to update the inode item, and then it's blocked since
> +	 *    the current transaction is in the TRANS_STATE_COMMIT_START state.
> +	 *    Therefore task A has to wait for the current transaction to become
> +	 *    unblocked (its state >= TRANS_STATE_UNBLOCKED).
> +	 *
> +	 * This leads to a deadlock - the task committing the transaction
> +	 * waiting for the delalloc flushing which is blocked during folio
> +	 * invalidation on the inode's extent lock and the reflink task waiting
> +	 * for the current transaction to be unblocked so that it can start a
> +	 * a new one to update the inode item (while holding the extent lock).
> +	 */
> +	if (ret == 0 && new_key->offset + datal > i_size_read(&inode->vfs_inode))
> +		i_size_write(&inode->vfs_inode, new_key->offset + datal);
> +
>  	goto out;
>  }
>  
> -- 
> 2.47.2
> 
