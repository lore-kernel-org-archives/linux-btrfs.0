Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795432722;
	b=wAXINiyF++oC04P0hEJ4XTqromuWwDZAbnh1w7YGcSUcytVnBk5WY8l7f8SJHkRIQA0+
	 E4ST8l9ccd86Cg9dd65gYTePd7ARsH3ZvzxmHO7ahC/JPnAHt4A/zyWcbBIEmkq3vBA+/
	 A7O2krl7ahDELfBMhBIpgb7Xfff0cRhCtQyz8JCYpXkAmkun2dDo+Hz8Fbm6YWdUcFkh2
	 9IU7BhH7qa1f6xc+Hgas8qnSGaGZYqCIQF+rmFD8/EWtHG2iuZPhIsb793Pgr92zYuk4Q
	 +UYobYQ91oZCX6kMUGqSIONYXg15BePa5aDXCJIdRYjP/YNwOSN3JBTUBtIUbbmSKwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795432722;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ZSUj6uUkwqo4fmKbS9neZKsw+SkHf76k8DO6f2yuaJs=;
	b=2sCDzHm6dXIFSIhdmBjn9zubhvsVDfuy4KpKfomNdwBo8Sbd+WWUzyWJCcGgNusa34DT
	 69SUN/A6mneokhbKuROTTTi3M5Dd5wt4nM+8/janXaQeL2yQUTs/kgSIGGhnERbQH3gIX
	 SUGG0snM0OM5M8dRPkMsA3LjEggHOGDF91Z8xOGygE0sQoUHi79UuJlnPjAtQmv3CiHNs
	 x7ot9hMM5CFzQN6fN8q9MHMDHyCpFcsrRAehww8ppuj4IVPbqWLx5yX7HYaurtLFcSJD7
	 zspICSdrK8ay/ERIUmDBprsR691bUASZ0E0pWAjeCFFUAlt/umtPe0EZ5CIePPI5N1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4427606A31E
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A62B1F000CA
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795432712;
	bh=ZSUj6uUkwqo4fmKbS9neZKsw+SkHf76k8DO6f2yuaJs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TwFp8grP7VtXfsnr0NdRLpBuHbTY4pQS0YCCx1rh33Gfiqoja+hrre97JfzlUFudm
	 i+hKVMxYJ0YJKzYfrWqYVLB/Dufe3cbUlSpvGpqO7ssXRwu70HyA7VY22lsefXmlUC
	 nOwZ90D6rZ+s0/OFmBIZ4YZYbH90RAsaGbVBR+W91sCzldrIyBNB1Y4DK0YYO9FMi3
	 wi6OQCZcJG3hW0MWRUq71lt7mqi0mf8JcLhVqQEPPKerlp5uofc1PadTP2NAsPZHEm
	 huMzg0njDEJKbRubFx758SBJgrKgBXu6aSojRtbHa2ajOmcNKQujj4nbp5BnhGldE6
	 OfrjUItofbUUg==
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-99e740a7131so1286141241.2
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 03:18:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHst9znCpu3uEOV0si53z04Dw/NJho0qTm2STTyEnAQGG4liGCAGSbNykjhssw/rVGf9O8iYVzt9PtRjA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+IEZluZtJlm/sEAy2S/m6WZ1OyCv7tImusx+kmPAObwypsOykV
	srJHu+MEJ7JbZcIhtUxklcqX1IzzO2HmVtUlHh5Zg5rpKCWLOBFfyl7aioOm7eDgjOHBvKJXWPD
	YVd6ZeIUDv1X2UrAzfiz3oUYmO7y+/3E=
X-Received: by 2002:a05:6102:3f45:b0:7c3:2f13:d905 with SMTP id
 ada2fe7eead31-7d72b3731efmr5072193137.3.1795432711256; Mon, 23 Nov 2026
 03:18:31 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <4ufzifklby6vql67tefvsqwpjnpo6s6sihmoaybrtajo7vbv7u@ai5dcficw5ph>
In-Reply-To: <4ufzifklby6vql67tefvsqwpjnpo6s6sihmoaybrtajo7vbv7u@ai5dcficw5ph>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 23 Nov 2026 11:17:54 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6=KByGHL9mrCCWVzfhi9YAdmZr5QUNGgc4WFZVX-TZTQ@mail.gmail.com>
X-Gm-Features: Aa3M54qJ4N7m4quPyUT0d9AqjYff9y_iteu2n9NCsJ878qrM2-zrgsBLpaigmZo
Message-ID: <CAL3q7H6=KByGHL9mrCCWVzfhi9YAdmZr5QUNGgc4WFZVX-TZTQ@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: fix deadlocks with transaction commit when
 cloning inline extents
To: Melon Liu <melon1335@163.com>
Cc: clm@fb.com, dsterba@suse.com, fdmanana@suse.com, wqu@suse.com, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 22, 2026 at 3:30=E2=80=AFPM Melon Liu <melon1335@163.com> wrote=
:
>
> Commits b48c980b6a7e ("btrfs: fix deadlock between reflink and transactio=
n
> commit when using flushoncommit") and 532085d00eb5 ("btrfs: fix deadlock
> cloning inline extent when using flushoncommit") moved the destination
> i_size update before btrfs_start_transaction() to prevent
> extent_writepage() from invalidating a folio beyond EOF. However, two
> deadlock windows remain.
>
> The first one happens after the folio is dirtied and before i_size is
> updated. The writeback task sees the folio beyond EOF and calls
> folio_invalidate(), then btrfs_invalidate_folio() waits for the destinati=
on
> extent range locked by the clone task. This was reproduced with the
> following blocked stacks:
>
>   clone task             writeback task        transaction commit task
>   ----------             --------------        -----------------------
>   btrfs_clone()
>    lock destination range
>    copy_inline_to_page()
>     dirty folio
>                                                btrfs_commit_transaction()
>                                               try_to_writeback_inodes_sb(=
)
>                          btrfs_writepages()
>                           extent_write_cache_pages()
>                            btrfs_invalidate_folio()
>                             btrfs_lock_extent_bits()
>                              wait for destination range
>                                               wb_wait_for_completion()
>                                                wait for writeback
>    clone_copy_inline_extent()
>     btrfs_start_transaction()
>      wait_current_trans()
>       wait for transaction commit
>
> The relevant excerpts from the hung task log were:
>
>   [  121.060811] INFO: task kworker/u4:3:40 blocked for more than 30 seco=
nds.
>   [  121.068556] Workqueue: writeback wb_workfn (flush-btrfs-1)
>   [  121.084873] Call Trace:
>   [  121.085596]  <TASK>
>   [  121.086165]  __schedule+0x516/0xf60
>   [  121.088076]  schedule+0x28/0xa0
>   [  121.090823]  btrfs_lock_extent_bits+0x272/0x2d0
>   [  121.094416]  ? __pfx_autoremove_wake_function+0x10/0x10
>   [  121.098370]  btrfs_invalidate_folio+0x387/0x3c0
>   [  121.101345]  extent_write_cache_pages+0x595/0x890
>   [  121.101365]  btrfs_writepages+0x5f/0xb0
>   [  121.101374]  do_writepages+0xbb/0x150
>   [  121.101381]  ? pick_eevdf+0x17a/0x210
>   [  121.101392]  __writeback_single_inode+0x3e/0x360
>   [  121.114680]  writeback_sb_inodes+0x230/0x560
>   [  121.114696]  wb_writeback+0x99/0x310
>   [  121.114703]  wb_workfn+0xb2/0x420
>   [  121.114708]  ? finish_task_switch.isra.0+0xb6/0x340
>   [  121.114714]  process_one_work+0x1a3/0x3e0
>   [  121.114720]  worker_thread+0x177/0x2e0
>   [  121.114724]  ? __pfx_worker_thread+0x10/0x10
>   [  121.114728]  kthread+0xe4/0x120
>   [  121.114734]  ? __pfx_kthread+0x10/0x10
>   [  121.114739]  ret_from_fork+0x18b/0x240
>   [  121.114743]  ? __pfx_kthread+0x10/0x10
>   [  121.114748]  ret_from_fork_asm+0x1a/0x30
>   [  121.114755]  </TASK>
>   [  121.114851] INFO: task trigger_copy_in:551 blocked for more than 30 =
seconds.
>   [  121.114864] Call Trace:
>   [  121.114865]  <TASK>
>   [  121.114867]  __schedule+0x516/0xf60
>   [  121.114872]  schedule+0x28/0xa0
>   [  121.114876]  wait_current_trans+0x12f/0x190
>   [  121.114880]  ? __pfx_autoremove_wake_function+0x10/0x10
>   [  121.114886]  start_transaction+0x2ba/0x840
>   [  121.114892]  clone_copy_inline_extent+0x1d6/0x510
>   [  121.114898]  ? __kmalloc_large_node_noprof+0x1f/0xb0
>   [  121.114905]  btrfs_clone+0x566/0x870
>   [  121.114911]  ? btrfs_lookup_first_ordered_extent+0xa2/0x140
>   [  121.114917]  btrfs_clone_files.isra.0+0x168/0x1e0
>   [  121.114922]  btrfs_remap_file_range+0x4cb/0x640
>   [  121.114928]  vfs_clone_file_range+0x10b/0x330
>   [  121.114934]  ioctl_file_clone+0x4c/0xc0
>   [  121.114938]  do_vfs_ioctl+0x64b/0x9c0
>   [  121.114942]  __x64_sys_ioctl+0x75/0xe0
>   [  121.114946]  do_syscall_64+0xdd/0x4a0
>   [  121.114951]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   [  121.114992]  </TASK>
>   [  121.114993] INFO: task trigger_commit_:552 blocked for more than 30 =
seconds.
>   [  121.115005] Call Trace:
>   [  121.115006]  <TASK>
>   [  121.115008]  __schedule+0x516/0xf60
>   [  121.115013]  schedule+0x28/0xa0
>   [  121.115017]  wb_wait_for_completion+0x97/0xe0
>   [  121.115023]  ? __pfx_autoremove_wake_function+0x10/0x10
>   [  121.115028]  __writeback_inodes_sb_nr+0xc4/0xf0
>   [  121.115034]  try_to_writeback_inodes_sb+0x5c/0x70
>   [  121.115039]  btrfs_commit_transaction+0xa3b/0x1060
>   [  121.115044]  ? start_transaction+0xb9/0x840
>   [  121.115050]  btrfs_ioctl_set_fslabel+0x11d/0x180
>   [  121.115058]  btrfs_ioctl+0x22f/0x2f80
>   [  121.115063]  ? ioctl_has_perm.constprop.0.isra.0+0xea/0x160
>   [  121.115068]  __x64_sys_ioctl+0x96/0xe0
>   [  121.115072]  do_syscall_64+0xdd/0x4a0
>   [  121.115075]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   [  121.115095]  </TASK>
>
> The second window happens when writeback sees the folio within EOF. It
> continues into writepage_delalloc(), which also waits for the destination
> extent range:
>
>   clone task             writeback task        transaction commit task
>   ----------             --------------        -----------------------
>   btrfs_clone()
>    lock destination range
>    copy_inline_to_page()
>     dirty folio
>                                                btrfs_commit_transaction()
>                                               try_to_writeback_inodes_sb(=
)
>                          btrfs_writepages()
>                           extent_write_cache_pages()
>                            writepage_delalloc()
>                             find_lock_delalloc_range()
>                              btrfs_lock_extent_bits()
>                               wait for destination range
>                                               wb_wait_for_completion()
>                                                wait for writeback
>    clone_copy_inline_extent()
>     btrfs_start_transaction()
>      wait_current_trans()
>       wait for transaction commit
>
> The relevant excerpts from the hung task log were:
>
>   [   91.338833] INFO: task kworker/u4:3:39 blocked for more than 30 seco=
nds.
>   [   91.343820] Workqueue: writeback wb_workfn (flush-btrfs-1)
>   [   91.343857] Call Trace:
>   [   91.343866]  <TASK>
>   [   91.343901]  __schedule+0x516/0xf60
>   [   91.343947]  schedule+0x28/0xa0
>   [   91.343956]  btrfs_lock_extent_bits+0x272/0x2d0
>   [   91.343979]  ? __pfx_autoremove_wake_function+0x10/0x10
>   [   91.343994]  find_lock_delalloc_range+0x10e/0x210
>   [   91.344015]  writepage_delalloc+0x1e1/0x630
>   [   91.344027]  ? filemap_get_folios_tag+0x1b1/0x1e0
>   [   91.344041]  extent_write_cache_pages+0x2bf/0x890
>   [   91.344056]  btrfs_writepages+0x5f/0xb0
>   [   91.344064]  do_writepages+0xbb/0x150
>   [   91.344079]  __writeback_single_inode+0x3e/0x360
>   [   91.344097]  writeback_sb_inodes+0x230/0x560
>   [   91.344114]  wb_writeback+0x99/0x310
>   [   91.344126]  wb_workfn+0xb2/0x420
>   [   91.344158]  ? finish_task_switch.isra.0+0xb6/0x340
>   [   91.344169]  process_one_work+0x1a3/0x3e0
>   [   91.344187]  worker_thread+0x177/0x2e0
>   [   91.344195]  ? __pfx_worker_thread+0x10/0x10
>   [   91.344202]  kthread+0xe4/0x120
>   [   91.344221]  ? __pfx_kthread+0x10/0x10
>   [   91.344231]  ret_from_fork+0x18b/0x240
>   [   91.344244]  ? __pfx_kthread+0x10/0x10
>   [   91.344253]  ret_from_fork_asm+0x1a/0x30
>   [   91.344273]  </TASK>
>   [   91.344295] INFO: task trigger_copy_in:541 blocked for more than 30 =
seconds.
>   [   91.344318] Call Trace:
>   [   91.344320]  <TASK>
>   [   91.344323]  __schedule+0x516/0xf60
>   [   91.344333]  schedule+0x28/0xa0
>   [   91.344340]  wait_current_trans+0x12f/0x190
>   [   91.344359]  ? __pfx_autoremove_wake_function+0x10/0x10
>   [   91.344371]  start_transaction+0x2ba/0x840
>   [   91.415273]  clone_copy_inline_extent+0x1d6/0x510
>   [   91.415282]  ? __kmalloc_large_node_noprof+0x1f/0xb0
>   [   91.415288]  btrfs_clone+0x566/0x870
>   [   91.415293]  ? btrfs_lookup_first_ordered_extent+0xa2/0x140
>   [   91.415298]  btrfs_clone_files.isra.0+0x168/0x1e0
>   [   91.415302]  btrfs_remap_file_range+0x4cb/0x640
>   [   91.415306]  vfs_clone_file_range+0x10b/0x330
>   [   91.415312]  ioctl_file_clone+0x4c/0xc0
>   [   91.415325]  do_vfs_ioctl+0x64b/0x9c0
>   [   91.415328]  __x64_sys_ioctl+0x75/0xe0
>   [   91.415331]  do_syscall_64+0xdd/0x4a0
>   [   91.415338]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   [   91.415367]  </TASK>
>   [   91.415369] INFO: task trigger_commit_:542 blocked for more than 30 =
seconds.
>   [   91.415381] Call Trace:
>   [   91.415382]  <TASK>
>   [   91.415383]  __schedule+0x516/0xf60
>   [   91.415388]  schedule+0x28/0xa0
>   [   91.415391]  wb_wait_for_completion+0x97/0xe0
>   [   91.415396]  ? __pfx_autoremove_wake_function+0x10/0x10
>   [   91.415401]  __writeback_inodes_sb_nr+0xc4/0xf0
>   [   91.415405]  try_to_writeback_inodes_sb+0x5c/0x70
>   [   91.415409]  btrfs_commit_transaction+0xa3b/0x1060
>   [   91.415414]  ? start_transaction+0xb9/0x840
>   [   91.415418]  btrfs_ioctl_set_fslabel+0x11d/0x180
>   [   91.415424]  btrfs_ioctl+0x22f/0x2f80
>   [   91.415428]  ? ioctl_has_perm.constprop.0.isra.0+0xea/0x160
>   [   91.415432]  __x64_sys_ioctl+0x96/0xe0
>   [   91.415435]  do_syscall_64+0xdd/0x4a0
>   [   91.415437]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   [   91.415451]  </TASK>
>
> Fix both windows by ensuring that no transaction needs to be started
> after the inline folio has been dirtied while the destination range is
> locked. Start the transaction after reserving delalloc space, but before
> creating and dirtying the folio. If inline data is copied to a folio and
> the clone range continues past it, finish the inode update and end the
> transaction, then release the destination range lock and wait for the
> inline data's ordered extent to complete. Relock the remaining range and
> continue cloning, keeping the inode and i_mmap locks held across the wait=
.
>
> A transaction commit may start writeback before all extwriters have left
> the transaction, so starting the transaction first does not by itself
> prevent writeback from seeing the folio. Therefore, update i_size while
> the folio is locked and before marking it dirty. This prevents writeback
> from treating the folio as being beyond EOF and invalidating it.
>
> Fixes: 05a5a7621ce6 ("Btrfs: implement full reflink support for inline ex=
tents")
> Cc: stable@vger.kernel.org
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Suggested-by: Filipe Manana <fdmanana@suse.com>
> Assisted-by: Codex:gpt-5.6-sol Codex:gpt-6.1-sol
> Signed-off-by: Melon Liu <melon1335@163.com>
> ---
> Changes since v2:
> - Replace deferring the inline extent to a second pass with cloning in
>   file offset order, waiting for inline writeback before processing any
>   remaining range. This avoids a gap in file extent coverage that could
>   prevent disk_i_size from advancing when NO_HOLES is disabled.
>
> v2: https://lore.kernel.org/linux-btrfs/wndmkt6m2ccakcefhqatxacusi5wypmz6=
rb2tvtmya4zgl6cms@ckd3pks5ikrl/
>
>  fs/btrfs/btrfs_inode.h |   8 +-
>  fs/btrfs/reflink.c     | 227 +++++++++++++++++++++--------------------
>  2 files changed, 120 insertions(+), 115 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 1082fa92c..88215d533 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -69,12 +69,8 @@ enum {
>          */
>         BTRFS_INODE_NO_XATTRS,
>         /*
> -        * Set when we are in a context where we need to start a transact=
ion and
> -        * have dirty pages with the respective file range locked. This i=
s to
> -        * ensure that when reserving space for the transaction, if we ar=
e low
> -        * on available space and need to flush delalloc, we will not flu=
sh
> -        * delalloc for this inode, because that could result in a deadlo=
ck (on
> -        * the file range, inode's io_tree).
> +        * When set, skip delalloc flushing for this inode when flushing =
is
> +        * triggered from space reclaim context.
>          */
>         BTRFS_INODE_NO_DELALLOC_FLUSH,
>         /*
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index d2a410191..5c926e299 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -58,7 +58,8 @@ static int copy_inline_to_page(struct btrfs_inode *inod=
e,
>                                char *inline_data,
>                                const u64 size,
>                                const u64 datal,
> -                              const u8 comp_type)
> +                              const u8 comp_type,
> +                              struct btrfs_trans_handle **trans_out)
>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>         const u32 block_size =3D fs_info->sectorsize;
> @@ -84,6 +85,26 @@ static int copy_inline_to_page(struct btrfs_inode *ino=
de,
>         if (ret)
>                 goto out;
>
> +       /*
> +        * Start the transaction before creating and dirtying the folio. =
Otherwise,
> +        * btrfs_start_transaction() could wait for a transaction commit =
while
> +        * flushoncommit writeback waits for the destination range locked=
 by the
> +        * caller.
> +        *
> +        * This ordering also prevents transaction space reservation from=
 triggering
> +        * data async reclaim after the folio has been dirtied. btrfs_clo=
ne()
> +        * returns after copying the inline extent to a folio, so its cal=
ler can
> +        * unlock the range and flush the folio before cloning the remain=
ing range.
> +        *
> +        * 1 unit to update the inode item.
> +        */
> +       *trans_out =3D btrfs_start_transaction(inode->root, 1);
> +       if (IS_ERR(*trans_out)) {
> +               ret =3D PTR_ERR(*trans_out);
> +               *trans_out =3D NULL;
> +               goto out_unlock;
> +       }
> +
>         folio =3D __filemap_get_folio(mapping, file_offset >> PAGE_SHIFT,
>                                         FGP_LOCK | FGP_ACCESSED | FGP_CRE=
AT,
>                                         btrfs_alloc_write_mask(mapping));
> @@ -101,15 +122,8 @@ static int copy_inline_to_page(struct btrfs_inode *i=
node,
>                 goto out_unlock;
>
>         /*
> -        * After dirtying the page our caller will need to start a transa=
ction,
> -        * and if we are low on metadata free space, that can cause flush=
ing of
> -        * delalloc for all inodes in order to get metadata space release=
d.
> -        * However we are holding the range locked for the whole duration=
 of
> -        * the clone/dedupe operation, so we may deadlock if that happens=
 and no
> -        * other task releases enough space. So mark this inode as not be=
ing
> -        * possible to flush to avoid such deadlock. We will clear that f=
lag
> -        * when we finish cloning all extents, since a transaction is sta=
rted
> -        * after finding each extent to clone.
> +        * Prevent data async reclaim from flushing this inode while the =
destination
> +        * range is locked. The flag is cleared when btrfs_clone() return=
s.
>          */
>         set_bit(BTRFS_INODE_NO_DELALLOC_FLUSH, &inode->runtime_flags);
>
> @@ -140,16 +154,29 @@ static int copy_inline_to_page(struct btrfs_inode *=
inode,
>         if (datal < block_size)
>                 folio_zero_range(folio, datal, block_size - datal);
>
> +       /*
> +        * A transaction commit may start writeback before all extwriters=
 have
> +        * left the transaction. Update i_size while the folio is still l=
ocked
> +        * and before marking it dirty, so that writeback cannot treat it=
 as
> +        * being beyond EOF.
> +        */
> +       if (file_offset + datal > i_size_read(&inode->vfs_inode))
> +               i_size_write(&inode->vfs_inode, file_offset + datal);
> +
>         btrfs_folio_set_uptodate(fs_info, folio, file_offset, block_size)=
;
>         btrfs_folio_set_dirty(fs_info, folio, file_offset, block_size);
>  out_unlock:
> -       if (!IS_ERR(folio)) {
> +       if (!IS_ERR_OR_NULL(folio)) {
>                 folio_unlock(folio);
>                 folio_put(folio);
>         }
>         if (ret)
>                 btrfs_delalloc_release_space(inode, data_reserved, file_o=
ffset,
>                                              block_size, true);
> +       if (ret && *trans_out) {
> +               btrfs_end_transaction(*trans_out);
> +               *trans_out =3D NULL;
> +       }
>         btrfs_delalloc_release_extents(inode, block_size);
>  out:
>         extent_changeset_free(data_reserved);
> @@ -170,7 +197,8 @@ static int clone_copy_inline_extent(struct btrfs_inod=
e *inode,
>                                     const u64 size,
>                                     const u8 comp_type,
>                                     char *inline_data,
> -                                   struct btrfs_trans_handle **trans_out=
)
> +                                   struct btrfs_trans_handle **trans_out=
,
> +                                   bool *copied_inline_to_page)
>  {
>         struct btrfs_root *root =3D inode->root;
>         struct btrfs_fs_info *fs_info =3D root->fs_info;
> @@ -180,12 +208,12 @@ static int clone_copy_inline_extent(struct btrfs_in=
ode *inode,
>         struct btrfs_drop_extents_args drop_args =3D { 0 };
>         int ret;
>         struct btrfs_key key;
> -       bool copied_inline_to_page =3D false;
>
>         if (new_key->offset > 0) {
>                 ret =3D copy_inline_to_page(inode, new_key->offset,
> -                                         inline_data, size, datal, comp_=
type);
> -               copied_inline_to_page =3D (ret =3D=3D 0);
> +                                         inline_data, size, datal, comp_=
type,
> +                                         &trans);
> +               *copied_inline_to_page =3D (ret =3D=3D 0);
>                 goto out;
>         }
>
> @@ -290,73 +318,6 @@ static int clone_copy_inline_extent(struct btrfs_ino=
de *inode,
>         if (unlikely(ret))
>                 btrfs_abort_transaction(trans, ret);
>  out:
> -       if (!ret && !trans) {
> -               if (copied_inline_to_page &&
> -                   new_key->offset + datal > i_size_read(&inode->vfs_ino=
de)) {
> -                       /*
> -                        * If we copied the inline extent data to a page/=
folio
> -                        * beyond the i_size of the destination inode, th=
en we
> -                        * need to increase the i_size before we start a
> -                        * transaction to update the inode item. This is =
to
> -                        * prevent a deadlock when the flushoncommit moun=
t
> -                        * option is used, which happens like this:
> -                        *
> -                        * 1) Task A clones an inline extent from inode X=
 to an
> -                        *    offset of inode Y that is beyond Y's curren=
t
> -                        *    i_size. This means we copied the inline ext=
ent's
> -                        *    data to a folio of inode Y that is beyond i=
ts EOF,
> -                        *    using the call above to copy_inline_to_page=
();
> -                        *
> -                        * 2) Task B starts a transaction commit and call=
s
> -                        *    btrfs_start_delalloc_flush() to flush delal=
loc;
> -                        *
> -                        * 3) The delalloc flushing sees the new dirty fo=
lio of
> -                        *    inode Y and when it attempts to flush it, i=
t ends
> -                        *    up at extent_writepage() and sees that the =
offset
> -                        *    of the folio is beyond the i_size of inode =
Y, so
> -                        *    it attempts to invalidate the folio by call=
ing
> -                        *    folio_invalidate(), which ends up at btrfs'=
 folio
> -                        *    invalidate callback - btrfs_invalidate_foli=
o().
> -                        *    There it tries to lock the folio's range in=
 inode
> -                        *    Y's extent io tree, but it blocks since it'=
s
> -                        *    currently locked by task A - during reflink=
 we
> -                        *    lock the inodes and the source and destinat=
ion
> -                        *    ranges after flushing all delalloc and wait=
ing for
> -                        *    ordered extent completion - after that we d=
on't
> -                        *    expect to have dirty folios in the ranges, =
the
> -                        *    exception is if we have to copy an inline e=
xtent's
> -                        *    data (because the destination offset is not=
 zero);
> -                        *
> -                        * 4) Task A then does the 'goto out' below and a=
ttempts
> -                        *    to start a transaction to update the inode =
item,
> -                        *    and then it's blocked since the current
> -                        *    transaction is in the TRANS_STATE_COMMIT_ST=
ART
> -                        *    state. Therefore task A has to wait for the
> -                        *    current transaction to become unblocked (it=
s
> -                        *    state >=3D TRANS_STATE_UNBLOCKED).
> -                        *
> -                        * This leads to a deadlock - the task committing=
 the
> -                        * transaction waiting for the delalloc flushing =
which
> -                        * is blocked during folio invalidation on the in=
ode's
> -                        * extent lock and the reflink task waiting for t=
he
> -                        * current transaction to be unblocked so that it=
 can
> -                        * start a new one to update the inode item (whil=
e
> -                        * holding the extent lock).
> -                        */
> -                       i_size_write(&inode->vfs_inode, new_key->offset +=
 datal);
> -               }
> -               /*
> -                * No transaction here means we copied the inline extent =
into a
> -                * page of the destination inode.
> -                *
> -                * 1 unit to update inode item
> -                */
> -               trans =3D btrfs_start_transaction(root, 1);
> -               if (IS_ERR(trans)) {
> -                       ret =3D PTR_ERR(trans);
> -                       trans =3D NULL;
> -               }
> -       }
>         if (ret && trans)
>                 btrfs_end_transaction(trans);
>         if (!ret)
> @@ -376,8 +337,8 @@ static int clone_copy_inline_extent(struct btrfs_inod=
e *inode,
>         btrfs_release_path(path);
>
>         ret =3D copy_inline_to_page(inode, new_key->offset,
> -                                 inline_data, size, datal, comp_type);
> -       copied_inline_to_page =3D (ret =3D=3D 0);
> +                                 inline_data, size, datal, comp_type, &t=
rans);
> +       *copied_inline_to_page =3D (ret =3D=3D 0);
>
>         goto out;
>  }
> @@ -392,10 +353,14 @@ static int clone_copy_inline_extent(struct btrfs_in=
ode *inode,
>   * @olen_aligned:    Block-aligned value of olen
>   * @destoff:         Offset within @inode to start clone
>   * @no_time_update:  Whether to update mtime/ctime on the target inode
> + * @inline_end:      Set to the sector-aligned destination end offset if=
 inline
> + *                   data was copied to a folio, otherwise set to 0. On =
success,
> + *                   the caller must unlock and flush that range before =
cloning
> + *                   any remaining range.
>   */
>  static int btrfs_clone(struct btrfs_inode *src, struct btrfs_inode *inod=
e,
>                        const u64 off, const u64 olen, const u64 olen_alig=
ned,
> -                      const u64 destoff, bool no_time_update)
> +                      const u64 destoff, bool no_time_update, u64 *inlin=
e_end)
>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>         BTRFS_PATH_AUTO_FREE(path);
> @@ -410,6 +375,8 @@ static int btrfs_clone(struct btrfs_inode *src, struc=
t btrfs_inode *inode,
>         u64 last_dest_end =3D destoff;
>         u64 prev_extent_end =3D off;
>
> +       *inline_end =3D 0;
> +
>         ret =3D -ENOMEM;
>         buf =3D kvmalloc(fs_info->nodesize, GFP_KERNEL);
>         if (!buf)
> @@ -420,6 +387,7 @@ static int btrfs_clone(struct btrfs_inode *src, struc=
t btrfs_inode *inode,
>                 return ret;
>
>         path->reada =3D READA_FORWARD;
> +
>         /* Clone data */

In the future please avoid adding/removing stray lines.

>         key.objectid =3D btrfs_ino(src);
>         key.type =3D BTRFS_EXTENT_DATA_KEY;
> @@ -435,6 +403,7 @@ static int btrfs_clone(struct btrfs_inode *src, struc=
t btrfs_inode *inode,
>                 u64 datao =3D 0, datal =3D 0;
>                 u8 comp;
>                 u64 drop_start;
> +               bool copied_inline_to_page =3D false;
>
>                 /* Note the key will change type as we walk through the t=
ree */
>                 ret =3D btrfs_search_slot(NULL, src->root, &key, path, 0,=
 0);
> @@ -583,7 +552,8 @@ static int btrfs_clone(struct btrfs_inode *src, struc=
t btrfs_inode *inode,
>
>                         ret =3D clone_copy_inline_extent(inode, path, &ne=
w_key,
>                                                        drop_start, datal,=
 size,
> -                                                      comp, buf, &trans)=
;
> +                                                      comp, buf, &trans,
> +                                                      &copied_inline_to_=
page);
>                         if (ret)
>                                 goto out;
>                 }
> @@ -614,6 +584,11 @@ static int btrfs_clone(struct btrfs_inode *src, stru=
ct btrfs_inode *inode,
>                                                 destoff, olen, no_time_up=
date);
>                 if (ret)
>                         goto out;
> +               /* Do not start another transaction with the dirty range =
locked. */
> +               if (copied_inline_to_page) {
> +                       *inline_end =3D last_dest_end;
> +                       goto out;
> +               }
>                 if (new_key.offset + datal >=3D destoff + len)
>                         break;
>
> @@ -663,13 +638,66 @@ static int btrfs_clone(struct btrfs_inode *src, str=
uct btrfs_inode *inode,
>                 ret =3D clone_finish_inode_update(trans, inode, destoff +=
 len,
>                                                 destoff, olen, no_time_up=
date);
>         }
> -
>  out:

Same here.

I've edited the patch to remove the addition and removal of those 2 empty l=
ines.

Pushing it to the for-next branch on github soon, thanks.

Reviewed-by: Filipe Manana <fdmanana@suse.com>


>         clear_bit(BTRFS_INODE_NO_DELALLOC_FLUSH, &inode->runtime_flags);
>
>         return ret;
>  }
>
> +static int btrfs_clone_range(struct btrfs_inode *src, struct btrfs_inode=
 *inode,
> +                            u64 off, u64 olen, u64 olen_aligned, u64 des=
toff,
> +                            bool no_time_update)
> +{
> +       struct extent_state *cached_state =3D NULL;
> +       const u32 bs =3D inode->root->fs_info->sectorsize;
> +       const u64 end =3D round_up(destoff + olen_aligned, bs) - 1;
> +
> +       while (1) {
> +               u64 inline_end;
> +               u64 cloned;
> +               int ret;
> +
> +               /*
> +                * Lock destination range to serialize with concurrent re=
adahead(), and
> +                * we are safe from concurrency with relocation of source=
 extents
> +                * because we have already locked the inode's i_mmap_lock=
 in exclusive
> +                * mode.
> +                */
> +               btrfs_lock_extent(&inode->io_tree, destoff, end, &cached_=
state);
> +               ret =3D btrfs_clone(src, inode, off, olen, olen_aligned, =
destoff,
> +                                 no_time_update, &inline_end);
> +               btrfs_unlock_extent(&inode->io_tree, destoff, end, &cache=
d_state);
> +               if (ret || inline_end =3D=3D 0 || inline_end =3D=3D end +=
 1)
> +                       return ret;
> +
> +               /*
> +                * Flush the folio containing the cloned inline data and =
wait for
> +                * ordered extent completion before processing later exte=
nts or holes.
> +                * Otherwise a transaction commit could persist those ext=
ents beyond
> +                * a gap in the file extent tree.
> +                *
> +                * Writeback needs to lock the dirty folio's range, so re=
lease the entire
> +                * destination range lock before flushing it. The inode a=
nd i_mmap locks
> +                * remain held while we flush and clone the rest.
> +                *
> +                * Unlocking the range and flushing the dirty folio also =
avoids
> +                * deadlocks with flushoncommit or data async reclaim whe=
n starting
> +                * transactions to clone the remaining range.
> +                */
> +               cloned =3D inline_end - destoff;
> +               ret =3D btrfs_wait_ordered_range(inode, destoff, cloned);
> +               if (ret)
> +                       return ret;
> +               if (fatal_signal_pending(current))
> +                       return -EINTR;
> +
> +               off +=3D cloned;
> +               olen -=3D cloned;
> +               olen_aligned -=3D cloned;
> +               destoff =3D inline_end;
> +       }
> +}
> +
>  static void btrfs_double_mmap_lock(struct btrfs_inode *inode1, struct bt=
rfs_inode *inode2)
>  {
>         if (inode1 < inode2)
> @@ -687,21 +715,11 @@ static void btrfs_double_mmap_unlock(struct btrfs_i=
node *inode1, struct btrfs_in
>  static int btrfs_extent_same_range(struct btrfs_inode *src, u64 loff, u6=
4 len,
>                                    struct btrfs_inode *dst, u64 dst_loff)
>  {
> -       struct extent_state *cached_state =3D NULL;
>         struct btrfs_fs_info *fs_info =3D src->root->fs_info;
>         const u32 bs =3D fs_info->sectorsize;
> -       const u64 end =3D round_up(dst_loff + len, bs) - 1;
>         int ret;
>
> -       /*
> -        * Lock destination range to serialize with concurrent readahead(=
), and
> -        * we are safe from concurrency with relocation of source extents
> -        * because we have already locked the inode's i_mmap_lock in excl=
usive
> -        * mode.
> -        */
> -       btrfs_lock_extent(&dst->io_tree, dst_loff, end, &cached_state);
> -       ret =3D btrfs_clone(src, dst, loff, len, ALIGN(len, bs), dst_loff=
, true);
> -       btrfs_unlock_extent(&dst->io_tree, dst_loff, end, &cached_state);
> +       ret =3D btrfs_clone_range(src, dst, loff, len, ALIGN(len, bs), ds=
t_loff, true);
>
>         btrfs_btree_balance_dirty(fs_info);
>
> @@ -753,7 +771,6 @@ static int btrfs_extent_same(struct btrfs_inode *src,=
 u64 loff, u64 olen,
>  static noinline int btrfs_clone_files(struct file *file, struct file *fi=
le_src,
>                                         u64 off, u64 olen, u64 destoff)
>  {
> -       struct extent_state *cached_state =3D NULL;
>         struct btrfs_inode *inode =3D BTRFS_I(file_inode(file));
>         struct btrfs_inode *src =3D BTRFS_I(file_inode(file_src));
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> @@ -793,16 +810,7 @@ static noinline int btrfs_clone_files(struct file *f=
ile, struct file *file_src,
>                         return ret;
>         }
>
> -       /*
> -        * Lock destination range to serialize with concurrent readahead(=
), and
> -        * we are safe from concurrency with relocation of source extents
> -        * because we have already locked the inode's i_mmap_lock in excl=
usive
> -        * mode.
> -        */
> -       end =3D round_up(destoff + len, bs) - 1;
> -       btrfs_lock_extent(&inode->io_tree, destoff, end, &cached_state);
> -       ret =3D btrfs_clone(src, inode, off, olen, len, destoff, false);
> -       btrfs_unlock_extent(&inode->io_tree, destoff, end, &cached_state)=
;
> +       ret =3D btrfs_clone_range(src, inode, off, olen, len, destoff, fa=
lse);
>         if (ret < 0)
>                 return ret;
>
> @@ -824,6 +832,7 @@ static noinline int btrfs_clone_files(struct file *fi=
le, struct file *file_src,
>          * Invalidate page cache so that future reads will see the cloned=
 data
>          * immediately and not the previous data.
>          */
> +       end =3D round_up(destoff + len, bs) - 1;
>         ret =3D filemap_invalidate_inode(&inode->vfs_inode, false, destof=
f, end);
>         if (ret < 0)
>                 return ret;
>
> base-commit: 45c13f3f9e3bb15fd89ff2864c6f627a3b4b4229
> --
> 2.43.0
>
>
