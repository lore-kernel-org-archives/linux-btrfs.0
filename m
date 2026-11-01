Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793532345;
	b=i+L8VT1XYvlcFW5AHxUGL9E1XW1zx7gvHnpuO2JreiPXXCU0j++XEOh/IsTyvTX3VNkC
	 s/HakUb6/EpAwMa3MoLQD/iom1mInMHyZRYWmbOP63faIbbHluYQi1UoVbWfjFPUC8I27
	 tBTYfh7Jk8/2aXGy8dQ4Y/oE8HHOhbz3A7OPcpB0MoX178j5pfeqQ9nxHfCWpUZx883On
	 eHQO4zwtzlfVoGnASekxdSA7iKrCuUtflJcXEhiw3r/HihhrhzBj7odykIsIS6CgOGKal
	 GpTd6bK8VkdTpQJ9WPwsG/06puzVpjWXHfX5Pxown0HtjA16kIfQFKK2+7VOe11j6Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793532345;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=PtlmKttIEZyjqDGizifEB/DA6eI/q7Wtn+SZ9DB6E1E=;
	b=e2h37ozcY/1HRibqN9bBJzSUdRQSrdfYvQPw89gGLsfrkmQ8y0c5VPo0I8IIjJVKLjV9
	 9zg/cPUKyXYJwROUyyzc1MWr4r6D9OV1eoDzlTsNOLWDE7SBANIwsYKIq9HqI1B+bTQ/7
	 PHeB2apsF3GRV0NZco2risDADJDdpKEYNPB/gSDjzt4XXdL1e23yCC8csA3W8WndG9gfG
	 u/LnCqutVslkqHsK04Lwjr/3ZTTzfJuc8duWggZ8tz4vYMpHvtNokDCx304b5kXKVUkHN
	 ErPjz9ppgK8WCv8XQnVXXLBM7jsFXJFK4R/teiMKG7cvPAWrh1FHCceePLna43e8o1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=QWGAD3rx;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF24606A324;
	Sun,  1 Nov 2026 11:25:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CF24606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=QWGAD3rx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Message-ID:MIME-Version:
	Content-Type; bh=PtlmKttIEZyjqDGizifEB/DA6eI/q7Wtn+SZ9DB6E1E=;
	b=QWGAD3rx9Li+uZ2/OTh7VtVZn6HewsnryfRBVI11T+ykx2GxlA8Ipl9KGyA43f
	3WFMbA8wREkBYGhXbF5+0nEj2r1XnId24994oBpHI1+lYbHqqpyGNbGwu1r+HShe
	4OWJHLBmgj2lZJ7O26wLEC901ZgyHOq/WApCieZsWcQsY=
Received: from localhost (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgD3UXWMIedqJdPwCw--.26854S2;
	Sun, 01 Nov 2026 19:25:02 +0800 (CST)
Date: Sun, 1 Nov 2026 19:25:00 +0800
From: Melon Liu <melon1335@163.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: clm@fb.com, dsterba@suse.com, fdmanana@suse.com, wqu@suse.com, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix deadlocks with transaction commit when
 cloning inline extents
Message-ID: <dowyj4vvgpcybrtfki4sjvsdkpoahkjep2ndcmi2psmlhgftbl@x2eu4aslphtq>
References: <wndmkt6m2ccakcefhqatxacusi5wypmz6rb2tvtmya4zgl6cms@ckd3pks5ikrl>
 <CAL3q7H79Wi7GKbJaz+KcB7+rgbeWP13qGvN5-rN0VfygKy+Bkg@mail.gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H79Wi7GKbJaz+KcB7+rgbeWP13qGvN5-rN0VfygKy+Bkg@mail.gmail.com>
X-CM-TRANSID:PCgvCgD3UXWMIedqJdPwCw--.26854S2
X-Coremail-Antispam: 1Uf129KBjvAXoWfAr48tF48tr1fWrWDtr4rAFb_yoW8KrW5Xo
	W3ZF48Ar18Jr15JF4rCaykt3y5u392g34kJrWYvrZ29Fn2q3Wqkw4fZ3WkW3y5X3WFgF1r
	GFyxJayUtFZFqFn5n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUnnYwDUUUU
X-CM-SenderInfo: ppho00irttkqqrwthudrp/xtbC4w8AIWrnIY-kYQAA3r

On Thu, Oct 29, 2026 at 05:35:03PM +0000, Filipe Manana wrote:
> On Thu, Oct 29, 2026 at 4:25 PM Melon Liu <melon1335@163.com> wrote:
> >
> > Commits b48c980b6a7e ("btrfs: fix deadlock between reflink and transaction
> > commit when using flushoncommit") and 532085d00eb5 ("btrfs: fix deadlock
> > cloning inline extent when using flushoncommit") moved the destination
> > i_size update before btrfs_start_transaction() to prevent
> > extent_writepage() from invalidating a folio beyond EOF. However, two
> > deadlock windows remain.
> >
> > The first one happens after the folio is dirtied and before i_size is
> > updated. The writeback task sees the folio beyond EOF and calls
> > folio_invalidate(), then btrfs_invalidate_folio() waits for the destination
> > extent range locked by the clone task. This was reproduced with the
> > following blocked stacks:
> >
> >   clone task             writeback task        transaction commit task
> >   ----------             --------------        -----------------------
> >   btrfs_clone()
> >    lock destination range
> >    copy_inline_to_page()
> >     dirty folio
> >                                                btrfs_commit_transaction()
> >                                               try_to_writeback_inodes_sb()
> >                          btrfs_writepages()
> >                           extent_write_cache_pages()
> >                            btrfs_invalidate_folio()
> >                             btrfs_lock_extent_bits()
> >                              wait for destination range
> >                                               wb_wait_for_completion()
> >                                                wait for writeback
> >    clone_copy_inline_extent()
> >     btrfs_start_transaction()
> >      wait_current_trans()
> >       wait for transaction commit
> >
> > The relevant excerpts from the hung task log were:
> >
> >   [  121.060811] INFO: task kworker/u4:3:40 blocked for more than 30 seconds.
> >   [  121.068556] Workqueue: writeback wb_workfn (flush-btrfs-1)
> >   [  121.084873] Call Trace:
> >   [  121.085596]  <TASK>
> >   [  121.086165]  __schedule+0x516/0xf60
> >   [  121.088076]  schedule+0x28/0xa0
> >   [  121.090823]  btrfs_lock_extent_bits+0x272/0x2d0
> >   [  121.094416]  ? __pfx_autoremove_wake_function+0x10/0x10
> >   [  121.098370]  btrfs_invalidate_folio+0x387/0x3c0
> >   [  121.101345]  extent_write_cache_pages+0x595/0x890
> >   [  121.101365]  btrfs_writepages+0x5f/0xb0
> >   [  121.101374]  do_writepages+0xbb/0x150
> >   [  121.101381]  ? pick_eevdf+0x17a/0x210
> >   [  121.101392]  __writeback_single_inode+0x3e/0x360
> >   [  121.114680]  writeback_sb_inodes+0x230/0x560
> >   [  121.114696]  wb_writeback+0x99/0x310
> >   [  121.114703]  wb_workfn+0xb2/0x420
> >   [  121.114708]  ? finish_task_switch.isra.0+0xb6/0x340
> >   [  121.114714]  process_one_work+0x1a3/0x3e0
> >   [  121.114720]  worker_thread+0x177/0x2e0
> >   [  121.114724]  ? __pfx_worker_thread+0x10/0x10
> >   [  121.114728]  kthread+0xe4/0x120
> >   [  121.114734]  ? __pfx_kthread+0x10/0x10
> >   [  121.114739]  ret_from_fork+0x18b/0x240
> >   [  121.114743]  ? __pfx_kthread+0x10/0x10
> >   [  121.114748]  ret_from_fork_asm+0x1a/0x30
> >   [  121.114755]  </TASK>
> >   [  121.114851] INFO: task trigger_copy_in:551 blocked for more than 30 seconds.
> >   [  121.114864] Call Trace:
> >   [  121.114865]  <TASK>
> >   [  121.114867]  __schedule+0x516/0xf60
> >   [  121.114872]  schedule+0x28/0xa0
> >   [  121.114876]  wait_current_trans+0x12f/0x190
> >   [  121.114880]  ? __pfx_autoremove_wake_function+0x10/0x10
> >   [  121.114886]  start_transaction+0x2ba/0x840
> >   [  121.114892]  clone_copy_inline_extent+0x1d6/0x510
> >   [  121.114898]  ? __kmalloc_large_node_noprof+0x1f/0xb0
> >   [  121.114905]  btrfs_clone+0x566/0x870
> >   [  121.114911]  ? btrfs_lookup_first_ordered_extent+0xa2/0x140
> >   [  121.114917]  btrfs_clone_files.isra.0+0x168/0x1e0
> >   [  121.114922]  btrfs_remap_file_range+0x4cb/0x640
> >   [  121.114928]  vfs_clone_file_range+0x10b/0x330
> >   [  121.114934]  ioctl_file_clone+0x4c/0xc0
> >   [  121.114938]  do_vfs_ioctl+0x64b/0x9c0
> >   [  121.114942]  __x64_sys_ioctl+0x75/0xe0
> >   [  121.114946]  do_syscall_64+0xdd/0x4a0
> >   [  121.114951]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >   [  121.114992]  </TASK>
> >   [  121.114993] INFO: task trigger_commit_:552 blocked for more than 30 seconds.
> >   [  121.115005] Call Trace:
> >   [  121.115006]  <TASK>
> >   [  121.115008]  __schedule+0x516/0xf60
> >   [  121.115013]  schedule+0x28/0xa0
> >   [  121.115017]  wb_wait_for_completion+0x97/0xe0
> >   [  121.115023]  ? __pfx_autoremove_wake_function+0x10/0x10
> >   [  121.115028]  __writeback_inodes_sb_nr+0xc4/0xf0
> >   [  121.115034]  try_to_writeback_inodes_sb+0x5c/0x70
> >   [  121.115039]  btrfs_commit_transaction+0xa3b/0x1060
> >   [  121.115044]  ? start_transaction+0xb9/0x840
> >   [  121.115050]  btrfs_ioctl_set_fslabel+0x11d/0x180
> >   [  121.115058]  btrfs_ioctl+0x22f/0x2f80
> >   [  121.115063]  ? ioctl_has_perm.constprop.0.isra.0+0xea/0x160
> >   [  121.115068]  __x64_sys_ioctl+0x96/0xe0
> >   [  121.115072]  do_syscall_64+0xdd/0x4a0
> >   [  121.115075]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >   [  121.115095]  </TASK>
> >
> > The second window happens when writeback sees the folio within EOF. It
> > continues into writepage_delalloc(), which also waits for the destination
> > extent range:
> >
> >   clone task             writeback task        transaction commit task
> >   ----------             --------------        -----------------------
> >   btrfs_clone()
> >    lock destination range
> >    copy_inline_to_page()
> >     dirty folio
> >                                                btrfs_commit_transaction()
> >                                               try_to_writeback_inodes_sb()
> >                          btrfs_writepages()
> >                           extent_write_cache_pages()
> >                            writepage_delalloc()
> >                             find_lock_delalloc_range()
> >                              btrfs_lock_extent_bits()
> >                               wait for destination range
> >                                               wb_wait_for_completion()
> >                                                wait for writeback
> >    clone_copy_inline_extent()
> >     btrfs_start_transaction()
> >      wait_current_trans()
> >       wait for transaction commit
> >
> > The relevant excerpts from the hung task log were:
> >
> >   [   91.338833] INFO: task kworker/u4:3:39 blocked for more than 30 seconds.
> >   [   91.343820] Workqueue: writeback wb_workfn (flush-btrfs-1)
> >   [   91.343857] Call Trace:
> >   [   91.343866]  <TASK>
> >   [   91.343901]  __schedule+0x516/0xf60
> >   [   91.343947]  schedule+0x28/0xa0
> >   [   91.343956]  btrfs_lock_extent_bits+0x272/0x2d0
> >   [   91.343979]  ? __pfx_autoremove_wake_function+0x10/0x10
> >   [   91.343994]  find_lock_delalloc_range+0x10e/0x210
> >   [   91.344015]  writepage_delalloc+0x1e1/0x630
> >   [   91.344027]  ? filemap_get_folios_tag+0x1b1/0x1e0
> >   [   91.344041]  extent_write_cache_pages+0x2bf/0x890
> >   [   91.344056]  btrfs_writepages+0x5f/0xb0
> >   [   91.344064]  do_writepages+0xbb/0x150
> >   [   91.344079]  __writeback_single_inode+0x3e/0x360
> >   [   91.344097]  writeback_sb_inodes+0x230/0x560
> >   [   91.344114]  wb_writeback+0x99/0x310
> >   [   91.344126]  wb_workfn+0xb2/0x420
> >   [   91.344158]  ? finish_task_switch.isra.0+0xb6/0x340
> >   [   91.344169]  process_one_work+0x1a3/0x3e0
> >   [   91.344187]  worker_thread+0x177/0x2e0
> >   [   91.344195]  ? __pfx_worker_thread+0x10/0x10
> >   [   91.344202]  kthread+0xe4/0x120
> >   [   91.344221]  ? __pfx_kthread+0x10/0x10
> >   [   91.344231]  ret_from_fork+0x18b/0x240
> >   [   91.344244]  ? __pfx_kthread+0x10/0x10
> >   [   91.344253]  ret_from_fork_asm+0x1a/0x30
> >   [   91.344273]  </TASK>
> >   [   91.344295] INFO: task trigger_copy_in:541 blocked for more than 30 seconds.
> >   [   91.344318] Call Trace:
> >   [   91.344320]  <TASK>
> >   [   91.344323]  __schedule+0x516/0xf60
> >   [   91.344333]  schedule+0x28/0xa0
> >   [   91.344340]  wait_current_trans+0x12f/0x190
> >   [   91.344359]  ? __pfx_autoremove_wake_function+0x10/0x10
> >   [   91.344371]  start_transaction+0x2ba/0x840
> >   [   91.415273]  clone_copy_inline_extent+0x1d6/0x510
> >   [   91.415282]  ? __kmalloc_large_node_noprof+0x1f/0xb0
> >   [   91.415288]  btrfs_clone+0x566/0x870
> >   [   91.415293]  ? btrfs_lookup_first_ordered_extent+0xa2/0x140
> >   [   91.415298]  btrfs_clone_files.isra.0+0x168/0x1e0
> >   [   91.415302]  btrfs_remap_file_range+0x4cb/0x640
> >   [   91.415306]  vfs_clone_file_range+0x10b/0x330
> >   [   91.415312]  ioctl_file_clone+0x4c/0xc0
> >   [   91.415325]  do_vfs_ioctl+0x64b/0x9c0
> >   [   91.415328]  __x64_sys_ioctl+0x75/0xe0
> >   [   91.415331]  do_syscall_64+0xdd/0x4a0
> >   [   91.415338]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >   [   91.415367]  </TASK>
> >   [   91.415369] INFO: task trigger_commit_:542 blocked for more than 30 seconds.
> >   [   91.415381] Call Trace:
> >   [   91.415382]  <TASK>
> >   [   91.415383]  __schedule+0x516/0xf60
> >   [   91.415388]  schedule+0x28/0xa0
> >   [   91.415391]  wb_wait_for_completion+0x97/0xe0
> >   [   91.415396]  ? __pfx_autoremove_wake_function+0x10/0x10
> >   [   91.415401]  __writeback_inodes_sb_nr+0xc4/0xf0
> >   [   91.415405]  try_to_writeback_inodes_sb+0x5c/0x70
> >   [   91.415409]  btrfs_commit_transaction+0xa3b/0x1060
> >   [   91.415414]  ? start_transaction+0xb9/0x840
> >   [   91.415418]  btrfs_ioctl_set_fslabel+0x11d/0x180
> >   [   91.415424]  btrfs_ioctl+0x22f/0x2f80
> >   [   91.415428]  ? ioctl_has_perm.constprop.0.isra.0+0xea/0x160
> >   [   91.415432]  __x64_sys_ioctl+0x96/0xe0
> >   [   91.415435]  do_syscall_64+0xdd/0x4a0
> >   [   91.415437]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >   [   91.415451]  </TASK>
> >
> > Fix both windows by ensuring that no transaction needs to be started
> > after the inline folio has been dirtied while the destination range is
> > locked. Start the transaction after reserving delalloc space, but before
> > creating and dirtying the folio. If the clone range continues past the
> > inline extent, process the remainder, including holes, first and defer
> > the inline extent to a second and final pass.
> >
> > A transaction commit may start writeback before all extwriters have left
> > the transaction, so starting the transaction first does not by itself
> > prevent writeback from seeing the folio. Therefore, update i_size while
> > the folio is locked and before marking it dirty. This prevents writeback
> > from treating the folio as being beyond EOF and invalidating it.
> >
> > Fixes: 05a5a7621ce6 ("Btrfs: implement full reflink support for inline extents")
> > Cc: stable@vger.kernel.org
> > Suggested-by: Qu Wenruo <wqu@suse.com>
> > Suggested-by: Filipe Manana <fdmanana@kernel.org>
> 
> Please use fdmanana@suse.com in the future.
> 
> > Assisted-by: Codex:gpt-5.6-sol
> > Signed-off-by: Melon Liu <melon1335@163.com>
> > ---
> > Changes since v1:
> > - Added hung-task call traces and task interaction diagrams for both
> >   deadlock scenarios.
> > - Kept BTRFS_INODE_NO_DELALLOC_FLUSH and its related reclaim handling.
> > - Deferred the inline extent to a final pass after processing the rest of
> >   the clone range, including holes, to avoid starting a transaction after
> >   dirtying its folio.
> > - Fixed the error path when transaction start fails before folio allocation.
> > - Clarified the transaction ordering comment and documented the transaction
> >   reservation unit.
> > - Added the AI assistance disclosure.
> >
> > v1: https://lore.kernel.org/linux-btrfs/a74ov5nvs5u4nkqhrs5lp2jaj664wewkqqsjxzhuemzazzmzvx@eeof6sjb3xdc/
> >
> >  fs/btrfs/btrfs_inode.h |   8 +-
> >  fs/btrfs/reflink.c     | 166 ++++++++++++++++++++---------------------
> >  2 files changed, 85 insertions(+), 89 deletions(-)
> >
> > diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> > index 1082fa92c..88215d533 100644
> > --- a/fs/btrfs/btrfs_inode.h
> > +++ b/fs/btrfs/btrfs_inode.h
> > @@ -69,12 +69,8 @@ enum {
> >          */
> >         BTRFS_INODE_NO_XATTRS,
> >         /*
> > -        * Set when we are in a context where we need to start a transaction and
> > -        * have dirty pages with the respective file range locked. This is to
> > -        * ensure that when reserving space for the transaction, if we are low
> > -        * on available space and need to flush delalloc, we will not flush
> > -        * delalloc for this inode, because that could result in a deadlock (on
> > -        * the file range, inode's io_tree).
> > +        * When set, skip delalloc flushing for this inode when flushing is
> > +        * triggered from space reclaim context.
> >          */
> >         BTRFS_INODE_NO_DELALLOC_FLUSH,
> >         /*
> > diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> > index d2a410191..13cf23bd9 100644
> > --- a/fs/btrfs/reflink.c
> > +++ b/fs/btrfs/reflink.c
> > @@ -58,7 +58,8 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
> >                                char *inline_data,
> >                                const u64 size,
> >                                const u64 datal,
> > -                              const u8 comp_type)
> > +                              const u8 comp_type,
> > +                              struct btrfs_trans_handle **trans_out)
> >  {
> >         struct btrfs_fs_info *fs_info = inode->root->fs_info;
> >         const u32 block_size = fs_info->sectorsize;
> > @@ -84,6 +85,26 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
> >         if (ret)
> >                 goto out;
> >
> > +       /*
> > +        * Start the transaction before creating and dirtying the folio. Otherwise,
> > +        * btrfs_start_transaction() could wait for a transaction commit while
> > +        * flushoncommit writeback waits for the destination range locked by the
> > +        * caller.
> > +        *
> > +        * This ordering also prevents transaction space reservation from triggering
> > +        * data async reclaim after the folio has been dirtied. btrfs_clone()
> > +        * processes the remainder of the clone range before this inline extent,
> > +        * ensuring that no transaction is started after the folio is dirtied.
> > +        *
> > +        * 1 unit to update the inode item.
> > +        */
> > +       *trans_out = btrfs_start_transaction(inode->root, 1);
> > +       if (IS_ERR(*trans_out)) {
> > +               ret = PTR_ERR(*trans_out);
> > +               *trans_out = NULL;
> > +               goto out_unlock;
> > +       }
> > +
> >         folio = __filemap_get_folio(mapping, file_offset >> PAGE_SHIFT,
> >                                         FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
> >                                         btrfs_alloc_write_mask(mapping));
> > @@ -101,15 +122,8 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
> >                 goto out_unlock;
> >
> >         /*
> > -        * After dirtying the page our caller will need to start a transaction,
> > -        * and if we are low on metadata free space, that can cause flushing of
> > -        * delalloc for all inodes in order to get metadata space released.
> > -        * However we are holding the range locked for the whole duration of
> > -        * the clone/dedupe operation, so we may deadlock if that happens and no
> > -        * other task releases enough space. So mark this inode as not being
> > -        * possible to flush to avoid such deadlock. We will clear that flag
> > -        * when we finish cloning all extents, since a transaction is started
> > -        * after finding each extent to clone.
> > +        * Prevent data async reclaim from flushing this inode while the destination
> > +        * range is locked. The flag is cleared after all extents have been cloned.
> >          */
> >         set_bit(BTRFS_INODE_NO_DELALLOC_FLUSH, &inode->runtime_flags);
> >
> > @@ -140,16 +154,29 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
> >         if (datal < block_size)
> >                 folio_zero_range(folio, datal, block_size - datal);
> >
> > +       /*
> > +        * A transaction commit may start writeback before all extwriters have
> > +        * left the transaction. Update i_size while the folio is still locked
> > +        * and before marking it dirty, so that writeback cannot treat it as
> > +        * being beyond EOF.
> > +        */
> > +       if (file_offset + datal > i_size_read(&inode->vfs_inode))
> > +               i_size_write(&inode->vfs_inode, file_offset + datal);
> > +
> >         btrfs_folio_set_uptodate(fs_info, folio, file_offset, block_size);
> >         btrfs_folio_set_dirty(fs_info, folio, file_offset, block_size);
> >  out_unlock:
> > -       if (!IS_ERR(folio)) {
> > +       if (!IS_ERR_OR_NULL(folio)) {
> >                 folio_unlock(folio);
> >                 folio_put(folio);
> >         }
> >         if (ret)
> >                 btrfs_delalloc_release_space(inode, data_reserved, file_offset,
> >                                              block_size, true);
> > +       if (ret && *trans_out) {
> > +               btrfs_end_transaction(*trans_out);
> > +               *trans_out = NULL;
> > +       }
> >         btrfs_delalloc_release_extents(inode, block_size);
> >  out:
> >         extent_changeset_free(data_reserved);
> > @@ -180,12 +207,11 @@ static int clone_copy_inline_extent(struct btrfs_inode *inode,
> >         struct btrfs_drop_extents_args drop_args = { 0 };
> >         int ret;
> >         struct btrfs_key key;
> > -       bool copied_inline_to_page = false;
> >
> >         if (new_key->offset > 0) {
> >                 ret = copy_inline_to_page(inode, new_key->offset,
> > -                                         inline_data, size, datal, comp_type);
> > -               copied_inline_to_page = (ret == 0);
> > +                                         inline_data, size, datal, comp_type,
> > +                                         &trans);
> >                 goto out;
> >         }
> >
> > @@ -290,73 +316,6 @@ static int clone_copy_inline_extent(struct btrfs_inode *inode,
> >         if (unlikely(ret))
> >                 btrfs_abort_transaction(trans, ret);
> >  out:
> > -       if (!ret && !trans) {
> > -               if (copied_inline_to_page &&
> > -                   new_key->offset + datal > i_size_read(&inode->vfs_inode)) {
> > -                       /*
> > -                        * If we copied the inline extent data to a page/folio
> > -                        * beyond the i_size of the destination inode, then we
> > -                        * need to increase the i_size before we start a
> > -                        * transaction to update the inode item. This is to
> > -                        * prevent a deadlock when the flushoncommit mount
> > -                        * option is used, which happens like this:
> > -                        *
> > -                        * 1) Task A clones an inline extent from inode X to an
> > -                        *    offset of inode Y that is beyond Y's current
> > -                        *    i_size. This means we copied the inline extent's
> > -                        *    data to a folio of inode Y that is beyond its EOF,
> > -                        *    using the call above to copy_inline_to_page();
> > -                        *
> > -                        * 2) Task B starts a transaction commit and calls
> > -                        *    btrfs_start_delalloc_flush() to flush delalloc;
> > -                        *
> > -                        * 3) The delalloc flushing sees the new dirty folio of
> > -                        *    inode Y and when it attempts to flush it, it ends
> > -                        *    up at extent_writepage() and sees that the offset
> > -                        *    of the folio is beyond the i_size of inode Y, so
> > -                        *    it attempts to invalidate the folio by calling
> > -                        *    folio_invalidate(), which ends up at btrfs' folio
> > -                        *    invalidate callback - btrfs_invalidate_folio().
> > -                        *    There it tries to lock the folio's range in inode
> > -                        *    Y's extent io tree, but it blocks since it's
> > -                        *    currently locked by task A - during reflink we
> > -                        *    lock the inodes and the source and destination
> > -                        *    ranges after flushing all delalloc and waiting for
> > -                        *    ordered extent completion - after that we don't
> > -                        *    expect to have dirty folios in the ranges, the
> > -                        *    exception is if we have to copy an inline extent's
> > -                        *    data (because the destination offset is not zero);
> > -                        *
> > -                        * 4) Task A then does the 'goto out' below and attempts
> > -                        *    to start a transaction to update the inode item,
> > -                        *    and then it's blocked since the current
> > -                        *    transaction is in the TRANS_STATE_COMMIT_START
> > -                        *    state. Therefore task A has to wait for the
> > -                        *    current transaction to become unblocked (its
> > -                        *    state >= TRANS_STATE_UNBLOCKED).
> > -                        *
> > -                        * This leads to a deadlock - the task committing the
> > -                        * transaction waiting for the delalloc flushing which
> > -                        * is blocked during folio invalidation on the inode's
> > -                        * extent lock and the reflink task waiting for the
> > -                        * current transaction to be unblocked so that it can
> > -                        * start a new one to update the inode item (while
> > -                        * holding the extent lock).
> > -                        */
> > -                       i_size_write(&inode->vfs_inode, new_key->offset + datal);
> > -               }
> > -               /*
> > -                * No transaction here means we copied the inline extent into a
> > -                * page of the destination inode.
> > -                *
> > -                * 1 unit to update inode item
> > -                */
> > -               trans = btrfs_start_transaction(root, 1);
> > -               if (IS_ERR(trans)) {
> > -                       ret = PTR_ERR(trans);
> > -                       trans = NULL;
> > -               }
> > -       }
> >         if (ret && trans)
> >                 btrfs_end_transaction(trans);
> >         if (!ret)
> > @@ -376,8 +335,7 @@ static int clone_copy_inline_extent(struct btrfs_inode *inode,
> >         btrfs_release_path(path);
> >
> >         ret = copy_inline_to_page(inode, new_key->offset,
> > -                                 inline_data, size, datal, comp_type);
> > -       copied_inline_to_page = (ret == 0);
> > +                                 inline_data, size, datal, comp_type, &trans);
> >
> >         goto out;
> >  }
> > @@ -409,6 +367,22 @@ static int btrfs_clone(struct btrfs_inode *src, struct btrfs_inode *inode,
> >         const u64 len = olen_aligned;
> >         u64 last_dest_end = destoff;
> >         u64 prev_extent_end = off;
> > +       /*
> > +        * copy_inline_to_page() may leave a dirty folio in the destination range.
> > +        * Once that happens, starting another transaction while the range remains
> > +        * locked can deadlock with writeback triggered by either flushoncommit or
> > +        * data async reclaim.
> > +        *
> > +        * Therefore, if the clone range extends beyond an inline extent, process
> > +        * everything after it, including holes, in the first pass. Process the
> > +        * inline extent in a second and final pass, so no transaction is started
> > +        * after its folio has been dirtied.
> > +        */
> > +       enum {
> > +               CLONE_INLINE_NONE,
> > +               CLONE_INLINE_DEFERRED,
> > +               CLONE_INLINE_LAST,
> > +       } inline_state = CLONE_INLINE_NONE;
> >
> >         ret = -ENOMEM;
> >         buf = kvmalloc(fs_info->nodesize, GFP_KERNEL);
> > @@ -420,6 +394,8 @@ static int btrfs_clone(struct btrfs_inode *src, struct btrfs_inode *inode,
> >                 return ret;
> >
> >         path->reada = READA_FORWARD;
> > +
> > +clone_extents:
> >         /* Clone data */
> >         key.objectid = btrfs_ino(src);
> >         key.type = BTRFS_EXTENT_DATA_KEY;
> > @@ -581,6 +557,17 @@ static int btrfs_clone(struct btrfs_inode *src, struct btrfs_inode *inode,
> >                                 goto out;
> >                         }
> >
> > +                       if (inline_state == CLONE_INLINE_NONE) {
> > +                               const u64 inline_end = ALIGN(new_key.offset + datal,
> > +                                                            fs_info->sectorsize);
> > +
> > +                               if (inline_end < destoff + len) {
> > +                                       inline_state = CLONE_INLINE_DEFERRED;
> > +                                       last_dest_end = inline_end;
> > +                                       goto next_extent;
> > +                               }
> > +                       }
> 
> So this is fine as long as we are using NO_HOLES, otherwise only if
> the destination range already has file extent items in there.
> It may be the case the destination range range is beyond i_size and we
> are not using NO_HOLES, in which case we will temporarly leave a range
> without file extent items:
> 
> 1) We had an error before processing the inline extent on the second
> pass, so the transaction used to clone the following extent items gets
> committed, leaving a range without file extent items.
> 
> 2) Before we get to process the inline extent again, a transaction
> used to clone the following extent items gets committed and a power
> failure happens - same happens, a file range without file extent
> items.
> 
> This is what sashiko seems to be complaining about from a quick glance:
> 
> https://sashiko.dev/#/patchset/wndmkt6m2ccakcefhqatxacusi5wypmz6rb2tvtmya4zgl6cms%40ckd3pks5ikrl
> 
> 
> 
> > +
> >                         ret = clone_copy_inline_extent(inode, path, &new_key,
> >                                                        drop_start, datal, size,
> >                                                        comp, buf, &trans);
> > @@ -614,6 +601,9 @@ static int btrfs_clone(struct btrfs_inode *src, struct btrfs_inode *inode,
> >                                                 destoff, olen, no_time_update);
> >                 if (ret)
> >                         goto out;
> > +               if (inline_state == CLONE_INLINE_LAST)
> > +                       goto out;
> > +next_extent:
> >                 if (new_key.offset + datal >= destoff + len)
> >                         break;
> >
> > @@ -663,6 +653,16 @@ static int btrfs_clone(struct btrfs_inode *src, struct btrfs_inode *inode,
> >                 ret = clone_finish_inode_update(trans, inode, destoff + len,
> >                                                 destoff, olen, no_time_update);
> >         }
> > +       if (ret)
> > +               goto out;
> 
> We can shorten the code by combining both if statements:
> 
> if (ret == 0 && inline_state == CLONE_INLINE_DEFERRED) {
> (...)
> 
> Otherwise, it looks great, thanks!
> 
> > +
> > +       if (inline_state == CLONE_INLINE_DEFERRED) {
> > +               inline_state = CLONE_INLINE_LAST;
> > +               btrfs_release_path(path);
> > +               last_dest_end = destoff;
> > +               prev_extent_end = off;
> > +               goto clone_extents;
> > +       }
> >
> >  out:
> >         clear_bit(BTRFS_INODE_NO_DELALLOC_FLUSH, &inode->runtime_flags);
> >
> > base-commit: 45c13f3f9e3bb15fd89ff2864c6f627a3b4b4229
> > --
> > 2.43.0
> >
> >

Thanks for your patience and thorough review. I'll address these comments in v3.

