Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBD342668B
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 15:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779896720; cv=none; b=HpdVsdUKt3rpGAGpIE+L50tZd/VYOz3sqwFZSsWhZIMfBK2KX7sn+451cwhYZF1x5WKfS/zDRSwAPkhAJzGQrqMm+R/STqYfGrf9tf3R+P47wGMwbK7Q3LqurL3e6s2O//q2tgsA18SbxoRYWANfxLk7xt2tKLyydylSymn85aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779896720; c=relaxed/simple;
	bh=4Q2LsTsELfzq21hINa81TbHZsQ2e1nc/A5i2MfrbPKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mGQNjfblLbt6/jAS0ih++2us5PJuoG5mNomskWrkXk/md52TMg51YB7EOqtiF19kfxZgo7yQKonevS2UjhLtY1p4Hd78Fkjcf0BVMl1fn8huhsxbTsZQ4CslumMisyrGIOdg44aVBw7VMIfoO8lbxhWuP1VRrCrrpUy5gPHSqvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=OCRvTN1y; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Dcnlf3fX; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="OCRvTN1y";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Dcnlf3fX"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 8F945EC007A;
	Wed, 27 May 2026 11:45:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 27 May 2026 11:45:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779896717; x=1779983117; bh=YyU+0ou/+s
	Bo0JrSNl16YA0A5LEGHiL8YCAZuIeVLXE=; b=OCRvTN1yZMAgmVTb0y4AcBScse
	2kdjz7kPrILNZoREHPwVv6gygQHfVWql9opws+rld1qqyBhhq6pLbmtaNzDUyBum
	tO0LM8LhPZYwO4HIBr1EB0NAwTFcmO2Tmt9enFVWlVaJYt2737RL9G3KSAVVkPy9
	tZecv7BN5NG72ZuuLhsxN3UlPAIkN79OG3iYBvwDXo8iUdR1/BxrPFSPXWKIHNUg
	cPBasf8VMxZc6adnxfmKC89brlD99+X0GexEpVvSpS791OOBvDNCQtuk1LLwrt3A
	alUUqoD2GMDzeMyuFiWPVDNoREus7SIi62XH7O1BhxJxZR2ihL6E3k6bxrKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779896717; x=1779983117; bh=YyU+0ou/+sBo0JrSNl16YA0A5LEGHiL8YCA
	ZuIeVLXE=; b=Dcnlf3fXjbAEd38YpJiXlIQ+ylaf8oWQL7JZB5UR1FS2HNLwd46
	PrrwepgSncTurANAqDwjeVdFr9kVkbRpfxF6XxuzwzivZe+KoDHhdYnWx8X0n8TP
	D0CqpDDR39nrVDamU8MNbyT7fHh3NABiHnMBRpd3YKYlxg5YwHvtgjeo87oXI6M8
	3fj+AF0DFPtjnc+P6NdY7PqWcDsZ6NaRFplweiwzL6nvVPUZZZ5qDo1LH9sR/9z2
	/LfqomcFCK+DmD+ynBr4P8HloodmsLKZbK4eeWSdLtjG4cDRo7XLyJDq9lmKJH+H
	04mUgf1exklaeW28/ZWtol6H8SUO8cnGadg==
X-ME-Sender: <xms:jREXakYg_DPqXsHPBj233yUkVAiDt52NbyG5vnP1PPs7evBc0Jsuig>
    <xme:jREXalZBdPRoOMYt3nkiNWz3svjj1dSi4Um9x8kjf2L8VXdFiXhj-RKsl4rHyLOCH
    ZLvUnN5pyfP8buXVtCX5T__hHmAArYlxt0Cx1QQhy0WDhcrkMVqhOU>
X-ME-Received: <xmr:jREXaskLxIux1I-kaBTG14AjpOgRAt5F6k-r_r_XKmis6U-fU3jNrpW2Uotg4ZYE7JflMXGxi_AkOATUcZnxvhR7Oic>
X-ME-Proxy-Cause: dmFkZTFPqIcuwO+LsW2ruO8uoEJ/hzUXMPnv1/BSTWsq6a2a3plin0eZpryMcXizxgc6hG
    Y+fHNjK26WsMSdZ/lZj79S6/MYZCvcaMiWVYD0By1Td1Sbt0WxLom5xuRTjYGjiifNq6aZ
    JE7jTZ0rVtH7CzXRfa+4/5HEnnj/uZcIV3Qarjs+lw4qe2LT3AIyQKuLxQ7QyYagnhi+Sf
    tJXMqSGxim4mQiXxC7jR7ZG6UQLk4HE+J4j8ZeWm4ucD4zK/7L9I9pWuRln7mu1tRBuTbb
    c/TUmDccOOl7Kg73XA7ENz6Mnb9CrG39PpXwNgogPgvtZIzitMC5oismkO5awLKBGq5DVZ
    oW8T8fCFhI4RePBmPhjCLo7uYtemn+PiXKOyQWWG+2gf2sKVj/TaSgM3XFLVUa0AGC39i6
    BCAomcMW9H1juwSRyjCk87NxzIG5HSeN3UNcJIftkCf9HYl/jOWEMlIjrvSOInEfzHVk+T
    kBLNJ2GTDnW2ZYzJJ6zxBbwanNSGkpD4zjVBvDEGtnMA5TLtcxS2pVihV6uCW3IqW0z5HX
    cs04lX0+dP2XZjo2eMZeaSkjYAUtiR/Ud5vrcPNBR1x0nQmbTOdCAbayL3oPyhCw+u43Sk
    GLCp+GQvhbE3B7Y6egci5C8LOIizBAu6gUeM907zROLzC65EbciLWAsARhGQ
X-ME-Proxy: <xmx:jREXapzjNfgDn2ObdjXwwgrSR3McUXcTMK8mPN7HqoAD-kTvBkc0EQ>
    <xmx:jREXaiOPBh9bZ2nmIhQisXCi4NTD1XQjNe05vbpYorNMaFe8jGAYNg>
    <xmx:jREXalRPQAZZ3GV6mIDYsoW7C87W5_7ClKL4JEWsKAaIk3C9tgFk-Q>
    <xmx:jREXaobxq0Wd9oiMFVpB7mAJV53KvyR3l_AeopQKxEkhAV8KqRRiZg>
    <xmx:jREXaqOZjgFQGG6OUGTYOgnOhmNR-ZBt3lirZqq5VRmieRbiy_OFbBa3>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 May 2026 11:45:16 -0400 (EDT)
Date: Wed, 27 May 2026 08:45:03 -0700
From: Boris Burkov <boris@bur.io>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix deadlock cloning inline extent when using
 flushoncommit
Message-ID: <20260527154503.GA1981571@zen.localdomain>
References: <cbaede508d12a0bd0ef9ec1b49f8338fc46a07fb.1779803705.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbaede508d12a0bd0ef9ec1b49f8338fc46a07fb.1779803705.git.fdmanana@suse.com>

On Tue, May 26, 2026 at 02:59:40PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> In commit b48c980b6a7e ("btrfs: fix deadlock between reflink and
> transaction commit when using flushoncommit") a deadlock was fixed
> between reflinks and transaction commits when the fs is mounted with the
> flushoncommit option. This happened when we had to copy an inline extent's
> data to the destination file. However the issue was fixed only for the
> case where the destination offset is 0, it missed the case when the offset
> is greater than zero.
> 
> Fix this by ensuring we get i_size update whenever we copied an inline
> extent's data into the destination file.
> 
> Syzbot reported this with the following trace:
> 
>    INFO: task kworker/u8:3:57 blocked for more than 143 seconds.
>          Not tainted syzkaller #0
>    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>    task:kworker/u8:3    state:D stack:21600 pid:57    tgid:57    ppid:2      task_flags:0x4208160 flags:0x00080000
>    Workqueue: writeback wb_workfn (flush-btrfs-129)
>    Call Trace:
>     <TASK>
>     context_switch kernel/sched/core.c:5402 [inline]
>     __schedule+0x16f9/0x5500 kernel/sched/core.c:7204
>     __schedule_loop kernel/sched/core.c:7283 [inline]
>     schedule+0x164/0x360 kernel/sched/core.c:7298
>     wait_extent_bit fs/btrfs/extent-io-tree.c:905 [inline]
>     btrfs_lock_extent_bits+0x59c/0x700 fs/btrfs/extent-io-tree.c:2008
>     btrfs_lock_extent fs/btrfs/extent-io-tree.h:152 [inline]
>     btrfs_invalidate_folio+0x440/0xc00 fs/btrfs/inode.c:7718
>     extent_writepage fs/btrfs/extent_io.c:1848 [inline]
>     extent_write_cache_pages fs/btrfs/extent_io.c:2552 [inline]
>     btrfs_writepages+0x12f3/0x2410 fs/btrfs/extent_io.c:2684
>     do_writepages+0x32e/0x550 mm/page-writeback.c:2571
>     __writeback_single_inode+0x133/0x10e0 fs/fs-writeback.c:1764
>     writeback_sb_inodes+0x97f/0x1980 fs/fs-writeback.c:2056
>     wb_writeback+0x445/0xb00 fs/fs-writeback.c:2241
>     wb_do_writeback fs/fs-writeback.c:2388 [inline]
>     wb_workfn+0x3fd/0xf20 fs/fs-writeback.c:2428
>     process_one_work+0x98b/0x1630 kernel/workqueue.c:3318
>     process_scheduled_works kernel/workqueue.c:3401 [inline]
>     worker_thread+0xb49/0x1140 kernel/workqueue.c:3482
>     kthread+0x388/0x470 kernel/kthread.c:436
>     ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>     ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>     </TASK>
>    INFO: task syz.0.145:8523 blocked for more than 143 seconds.
>          Not tainted syzkaller #0
>    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>    task:syz.0.145       state:D stack:22752 pid:8523  tgid:8522  ppid:5850   task_flags:0x400140 flags:0x00080002
>    Call Trace:
>     <TASK>
>     context_switch kernel/sched/core.c:5402 [inline]
>     __schedule+0x16f9/0x5500 kernel/sched/core.c:7204
>     __schedule_loop kernel/sched/core.c:7283 [inline]
>     schedule+0x164/0x360 kernel/sched/core.c:7298
>     wb_wait_for_completion+0x3e8/0x790 fs/fs-writeback.c:227
>     __writeback_inodes_sb_nr+0x24c/0x2d0 fs/fs-writeback.c:2847
>     try_to_writeback_inodes_sb+0x9a/0xc0 fs/fs-writeback.c:2895
>     btrfs_start_delalloc_flush fs/btrfs/transaction.c:2182 [inline]
>     btrfs_commit_transaction+0x813/0x2fc0 fs/btrfs/transaction.c:2371
>     btrfs_sync_file+0xdf4/0x1230 fs/btrfs/file.c:1822
>     generic_write_sync include/linux/fs.h:2663 [inline]
>     btrfs_do_write_iter+0x6a9/0x840 fs/btrfs/file.c:1473
>     new_sync_write fs/read_write.c:595 [inline]
>     vfs_write+0x629/0xba0 fs/read_write.c:688
>     ksys_write+0x156/0x270 fs/read_write.c:740
>     do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>     do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
>    RIP: 0033:0x7f5a0bdece59
>    RSP: 002b:00007f5a0b446028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
>    RAX: ffffffffffffffda RBX: 00007f5a0c065fa0 RCX: 00007f5a0bdece59
>    RDX: 000000000000029f RSI: 0000200000000200 RDI: 0000000000000004
>    RBP: 00007f5a0be82d6f R08: 0000000000000000 R09: 0000000000000000
>    R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>    R13: 00007f5a0c066038 R14: 00007f5a0c065fa0 R15: 00007ffe149206b8
>     </TASK>
>    INFO: task syz.0.145:8539 blocked for more than 143 seconds.
>          Not tainted syzkaller #0
>    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>    task:syz.0.145       state:D stack:23704 pid:8539  tgid:8522  ppid:5850   task_flags:0x400140 flags:0x00080002
>    Call Trace:
>     <TASK>
>     context_switch kernel/sched/core.c:5402 [inline]
>     __schedule+0x16f9/0x5500 kernel/sched/core.c:7204
>     __schedule_loop kernel/sched/core.c:7283 [inline]
>     schedule+0x164/0x360 kernel/sched/core.c:7298
>     wait_current_trans+0x39f/0x590 fs/btrfs/transaction.c:536
>     start_transaction+0xbd8/0x1820 fs/btrfs/transaction.c:716
>     clone_copy_inline_extent fs/btrfs/reflink.c:299 [inline]
>     btrfs_clone+0x1316/0x2540 fs/btrfs/reflink.c:574
>     btrfs_clone_files+0x271/0x3f0 fs/btrfs/reflink.c:795
>     btrfs_remap_file_range+0x76b/0x1320 fs/btrfs/reflink.c:948
>     vfs_clone_file_range+0x435/0x7b0 fs/remap_range.c:403
>     ioctl_file_clone fs/ioctl.c:239 [inline]
>     ioctl_file_clone_range fs/ioctl.c:257 [inline]
>     do_vfs_ioctl+0xe15/0x1540 fs/ioctl.c:544
>     __do_sys_ioctl fs/ioctl.c:595 [inline]
>     __se_sys_ioctl+0x82/0x170 fs/ioctl.c:583
>     do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>     do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
>    RIP: 0033:0x7f5a0bdece59
>    RSP: 002b:00007f5a0b425028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>    RAX: ffffffffffffffda RBX: 00007f5a0c066090 RCX: 00007f5a0bdece59
>    RDX: 00002000000000c0 RSI: 000000004020940d RDI: 0000000000000004
>    RBP: 00007f5a0be82d6f R08: 0000000000000000 R09: 0000000000000000
>    R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>    R13: 00007f5a0c066128 R14: 00007f5a0c066090 R15: 00007ffe149206b8
>     </TASK>
> 
> Reported-by: syzbot+c7443384724bb0f9e913@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/linux-btrfs/6a150a09.820a0220.e7972.0006.GAE@google.com/
> Fixes: 05a5a7621ce6 ("Btrfs: implement full reflink support for inline extents")

Tricky with the two ways to hit copy_inline_to_page and goto out from
above and below..

Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/reflink.c | 101 +++++++++++++++++++++++++--------------------
>  1 file changed, 57 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index 0a4628b3007d..9a49d2ecb949 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -179,10 +179,12 @@ static int clone_copy_inline_extent(struct btrfs_inode *inode,
>  	struct btrfs_drop_extents_args drop_args = { 0 };
>  	int ret;
>  	struct btrfs_key key;
> +	bool copied_inline_to_page = false;
>  
>  	if (new_key->offset > 0) {
>  		ret = copy_inline_to_page(inode, new_key->offset,
>  					  inline_data, size, datal, comp_type);
> +		copied_inline_to_page = (ret == 0);
>  		goto out;
>  	}
>  
> @@ -288,6 +290,60 @@ static int clone_copy_inline_extent(struct btrfs_inode *inode,
>  		btrfs_abort_transaction(trans, ret);
>  out:
>  	if (!ret && !trans) {
> +		if (copied_inline_to_page &&
> +		    new_key->offset + datal > i_size_read(&inode->vfs_inode)) {
> +			/*
> +			 * If we copied the inline extent data to a page/folio
> +			 * beyond the i_size of the destination inode, then we
> +			 * need to increase the i_size before we start a
> +			 * transaction to update the inode item. This is to
> +			 * prevent a deadlock when the flushoncommit mount
> +			 * option is used, which happens like this:
> +			 *
> +			 * 1) Task A clones an inline extent from inode X to an
> +			 *    offset of inode Y that is beyond Y's current
> +			 *    i_size. This means we copied the inline extent's
> +			 *    data to a folio of inode Y that is beyond its EOF,
> +			 *    using the call above to copy_inline_to_page();
> +			 *
> +			 * 2) Task B starts a transaction commit and calls
> +			 *    btrfs_start_delalloc_flush() to flush delalloc;
> +			 *
> +			 * 3) The delalloc flushing sees the new dirty folio of
> +			 *    inode Y and when it attempts to flush it, it ends
> +			 *    up at extent_writepage() and sees that the offset
> +			 *    of the folio is beyond the i_size of inode Y, so
> +			 *    it attempts to invalidate the folio by calling
> +			 *    folio_invalidate(), which ends up at btrfs' folio
> +			 *    invalidate callback - btrfs_invalidate_folio().
> +			 *    There it tries to lock the folio's range in inode
> +			 *    Y's extent io tree, but it blocks since it's
> +			 *    currently locked by task A - during reflink we
> +			 *    lock the inodes and the source and destination
> +			 *    ranges after flushing all delalloc and waiting for
> +			 *    ordered extent completion - after that we don't
> +			 *    expect to have dirty folios in the ranges, the
> +			 *    exception is if we have to copy an inline extent's
> +			 *    data (because the destination offset is not zero);
> +			 *
> +			 * 4) Task A then does the 'goto out' below and attempts
> +			 *    to start a transaction to update the inode item,
> +			 *    and then it's blocked since the current
> +			 *    transaction is in the TRANS_STATE_COMMIT_START
> +			 *    state. Therefore task A has to wait for the
> +			 *    current transaction to become unblocked (its
> +			 *    state >= TRANS_STATE_UNBLOCKED).
> +			 *
> +			 * This leads to a deadlock - the task committing the
> +			 * transaction waiting for the delalloc flushing which
> +			 * is blocked during folio invalidation on the inode's
> +			 * extent lock and the reflink task waiting for the
> +			 * current transaction to be unblocked so that it can
> +			 * start a new one to update the inode item (while
> +			 * holding the extent lock).
> +			 */
> +			i_size_write(&inode->vfs_inode, new_key->offset + datal);
> +		}
>  		/*
>  		 * No transaction here means we copied the inline extent into a
>  		 * page of the destination inode.
> @@ -320,50 +376,7 @@ static int clone_copy_inline_extent(struct btrfs_inode *inode,
>  
>  	ret = copy_inline_to_page(inode, new_key->offset,
>  				  inline_data, size, datal, comp_type);
> -
> -	/*
> -	 * If we copied the inline extent data to a page/folio beyond the i_size
> -	 * of the destination inode, then we need to increase the i_size before
> -	 * we start a transaction to update the inode item. This is to prevent a
> -	 * deadlock when the flushoncommit mount option is used, which happens
> -	 * like this:
> -	 *
> -	 * 1) Task A clones an inline extent from inode X to an offset of inode
> -	 *    Y that is beyond Y's current i_size. This means we copied the
> -	 *    inline extent's data to a folio of inode Y that is beyond its EOF,
> -	 *    using the call above to copy_inline_to_page();
> -	 *
> -	 * 2) Task B starts a transaction commit and calls
> -	 *    btrfs_start_delalloc_flush() to flush delalloc;
> -	 *
> -	 * 3) The delalloc flushing sees the new dirty folio of inode Y and when
> -	 *    it attempts to flush it, it ends up at extent_writepage() and sees
> -	 *    that the offset of the folio is beyond the i_size of inode Y, so
> -	 *    it attempts to invalidate the folio by calling folio_invalidate(),
> -	 *    which ends up at btrfs' folio invalidate callback -
> -	 *    btrfs_invalidate_folio(). There it tries to lock the folio's range
> -	 *    in inode Y's extent io tree, but it blocks since it's currently
> -	 *    locked by task A - during reflink we lock the inodes and the
> -	 *    source and destination ranges after flushing all delalloc and
> -	 *    waiting for ordered extent completion - after that we don't expect
> -	 *    to have dirty folios in the ranges, the exception is if we have to
> -	 *    copy an inline extent's data (because the destination offset is
> -	 *    not zero);
> -	 *
> -	 * 4) Task A then does the 'goto out' below and attempts to start a
> -	 *    transaction to update the inode item, and then it's blocked since
> -	 *    the current transaction is in the TRANS_STATE_COMMIT_START state.
> -	 *    Therefore task A has to wait for the current transaction to become
> -	 *    unblocked (its state >= TRANS_STATE_UNBLOCKED).
> -	 *
> -	 * This leads to a deadlock - the task committing the transaction
> -	 * waiting for the delalloc flushing which is blocked during folio
> -	 * invalidation on the inode's extent lock and the reflink task waiting
> -	 * for the current transaction to be unblocked so that it can start a
> -	 * a new one to update the inode item (while holding the extent lock).
> -	 */
> -	if (ret == 0 && new_key->offset + datal > i_size_read(&inode->vfs_inode))
> -		i_size_write(&inode->vfs_inode, new_key->offset + datal);
> +	copied_inline_to_page = (ret == 0);
>  
>  	goto out;
>  }
> -- 
> 2.47.2
> 
