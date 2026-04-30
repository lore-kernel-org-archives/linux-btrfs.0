Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0C740B6EC
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 12:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777553619; cv=none; b=FVUcCDwg19TKSjnvdIXFDyBLaT6QvW4sK0f8vmkwLiKLKLxxa6PQ/iHP3fwAPHKFjNitlhpx51TIOvs9et6u2swII9tDljp9KX9/+K5fuK6L+5KqnzpCcbZywI2GYHhINBM/2EKz79i7dHnbIpzE+nl5+2yx3vcYRdAXlzZ1W7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777553619; c=relaxed/simple;
	bh=MrZROx1R2EGjiSat4enmcn6Hqeoz4Tpe6kImgFwNXZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rpdCwhQOzQyUJDfMXkhQPgKLojHMM+F79MqeLM/gC5W8d5/tTop/pU039eX9hwpGuS5FmQY/dQ2rxLL24S13INYah2j/8XYGdjCXS0AHM8tZmmmt4eKz3Y1z4xtQNx2Dh3gjcUazNKBoo6Ur15rfgiLfHnwChVVKTWq6ReyRB/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qaGD9F1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qaGD9F1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96423C2BCF6
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 12:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777553619;
	bh=MrZROx1R2EGjiSat4enmcn6Hqeoz4Tpe6kImgFwNXZ0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qaGD9F1xBOMEwB/ULuhGjlWsggud4YUt/POVHjDe8xOU1+VrxLeRstl3NenAa9SGo
	 L7VmH/rnbt8vFN3T15uzlkKAYah3qYGp5Q8V73LRIpZfYzHGT0RusFjx5JlFPiyRml
	 j3ikStniYx3GBb038XHahvcoVkdjnS8uCITiljcSifovcby+TISnvUBYqNYrf/0AbZ
	 sShjfT1/RHuD6WvgLJFM4v1rC4lJU0D2QJBt9dsQsNesKcarWCOKX4ozf6+FaDToMd
	 zuZDVM04YBxcPqa9Lgthmfo9nFNOHMdDIAE6shIEnU9PvhARqcgLvYG2stV8RA+rrN
	 HmYBGPp7VRp7g==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-67b7c77865dso315939a12.2
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 05:53:39 -0700 (PDT)
X-Gm-Message-State: AOJu0YwmkoGbABHSUpU/ar4RENvA9ZHqSZt3MbbVPvM5hrvzZWaXHNAl
	ZfC38w+NIxL5XA3MK3z7TVy9e+hDaLu4kZMZZzRxTPTCSTyTIDUj2/6AjDC/6DKHTwfZRJsU3w6
	6Gh/YTbJXdT0gReuCFvmpZYDKjkTorwE=
X-Received: by 2002:a17:907:9412:b0:bad:92f5:daea with SMTP id
 a640c23a62f3a-bbac4bd3a3cmr182270366b.14.1777553617986; Thu, 30 Apr 2026
 05:53:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777510825.git.wqu@suse.com> <d02693a5159193f02dda9c7b500e00e7ed41a171.1777510825.git.wqu@suse.com>
In-Reply-To: <d02693a5159193f02dda9c7b500e00e7ed41a171.1777510825.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 30 Apr 2026 13:53:01 +0100
X-Gmail-Original-Message-ID: <CAL3q7H73=ZMyu+t4pcfoCnU_wCAL-=8hhG=ijg-242nsY1DeFQ@mail.gmail.com>
X-Gm-Features: AVHnY4KmOOS80ZXBZxH_4YzbStus7_3B6-Sjhza97TTsP3XAQ4RQVMEAIzcgrqY
Message-ID: <CAL3q7H73=ZMyu+t4pcfoCnU_wCAL-=8hhG=ijg-242nsY1DeFQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] btrfs: only release the dirty pages io tree after
 successful writes
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 30, 2026 at 2:07=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [BUG]
> With the recent commit "btrfs: warn about extent buffer that can not be
> released",

It's a bit odd to refer to that patch as it comes after in the series.

> we can trigger the following warning running test cases like
> generic/388 at unmount:
>
>  BTRFS critical (device dm-2 state E): emergency shutdown
>  BTRFS error (device dm-2 state E): cow_file_range failed, root=3D5 inode=
=3D265 start=3D135168 len=3D118784 cur_offset=3D135168 cur_alloc_size=3D0: =
-5
>  BTRFS error (device dm-2 state E): error while writing out transaction: =
-30
>  BTRFS warning (device dm-2 state E): Skipping commit of aborted transact=
ion.
>  BTRFS error (device dm-2 state EA): Transaction 9 aborted (error -30)
>  BTRFS: error (device dm-2 state EA) in cleanup_transaction:2068: errno=
=3D-30 Readonly filesystem
>  BTRFS info (device dm-2 state EA): forced readonly
>  BTRFS error (device dm-2 state EA): failed to run delalloc range, root=
=3D5 ino=3D265 folio=3D135168 submit_bitmap=3D0 start=3D135168 len=3D118784=
: -5
>  BTRFS info (device dm-2 state EA): last unmount of filesystem 8b3d8748-4=
710-4b5a-84d9-b072cb03be2d
>  ------------[ cut here ]------------
>  WARNING: disk-io.c:3306 at invalidate_btree_folios+0xfd/0x1ca [btrfs], C=
PU#4: umount/60183

This stack trace is also outdated because the function is now named
invalidate_and_check_btree_folios().

Otherwise:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>  CPU: 4 UID: 0 PID: 60183 Comm: umount Tainted: G        W  OE       7.0.=
0-rc6-custom+ #365 PREEMPT(full)  5804053f02137e627472d94b5128cc9fcb110e88
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2=
022
>  RIP: 0010:invalidate_btree_folios+0xfd/0x1ca [btrfs]
>  Call Trace:
>   <TASK>
>   close_ctree+0x534/0x57a [btrfs eeeee2af86b856a32e0b81b75d427a17a62ffe29=
]
>   generic_shutdown_super+0x89/0x1a0
>   kill_anon_super+0x16/0x40
>   btrfs_kill_super+0x16/0x20 [btrfs eeeee2af86b856a32e0b81b75d427a17a62ff=
e29]
>   deactivate_locked_super+0x2d/0xb0
>   cleanup_mnt+0xdc/0x140
>   task_work_run+0x5a/0xa0
>   exit_to_user_mode_loop+0x123/0x4b0
>   do_syscall_64+0x288/0x7d0
>   entry_SYSCALL_64_after_hwframe+0x4b/0x53
>   </TASK>
>  ---[ end trace 0000000000000000 ]---
>  BTRFS warning (device dm-2 state EA): unable to release extent buffer 30=
507008 owner 1 gen 9 refs 2 flags 0x7
>  BTRFS warning (device dm-2 state EA): unable to release extent buffer 30=
588928 owner 9 gen 9 refs 2 flags 0x7
>  BTRFS warning (device dm-2 state EA): unable to release extent buffer 30=
605312 owner 257 gen 9 refs 2 flags 0x7
>  BTRFS warning (device dm-2 state EA): unable to release extent buffer 30=
621696 owner 7 gen 9 refs 2 flags 0x7
>  BTRFS warning (device dm-2 state EA): unable to release extent buffer 30=
638080 owner 258 gen 9 refs 2 flags 0x7
>  BTRFS warning (device dm-2 state EA): unable to release extent buffer 30=
654464 owner 2 gen 9 refs 2 flags 0x7
>  BTRFS warning (device dm-2 state EA): unable to release extent buffer 30=
670848 owner 10 gen 9 refs 2 flags 0x7
>
> I'm using a stripped down version, which seems to trigger the warning
> more reliably:
>
>   _fsstress_pid=3D""
>   workload()
>   {
>         dmesg -C
>         mkfs.btrfs -f -K $dev > /dev/null
>         echo 1 > /sys/kernel/debug/clear_warn_once
>         mount $dev $mnt
>         $fsstress -w -n 1024 -p 4 -d $mnt &
>         _fsstress_pid=3D$!
>         sleep 0
>         $godown $mnt
>         pkill --echo -PIPE fsstress > /dev/null
>         wait $_fsstress_pid
>         unset _fsstress_pid
>         umount $mnt
>
>         if dmesg | grep -q "WARNING"; then
>                 fail
>         fi
>   }
>
>   for (( i =3D 0; i < $runtime; i++ )); do
>         echo "=3D=3D=3D $i/$runtime =3D=3D=3D"
>         workload
>   done
>
> [CAUSE]
> Inside btrfs_write_and_wait_transaction(), we first try to write all
> dirty ebs, then wait for them to finish.
>
> After that we call btrfs_extent_io_tree_release() to free all
> extent states from dirty_pages io tree.
>
> However if we hit an error from btrfs_write_marked_extent(), then we
> still call btrfs_extent_io_tree_release() to clear that dirty_pages io
> tree, which may contain dirty records that we haven't yet submitted.
>
> Furthermore, the later transaction cleanup path will utilize that
> dirty_pages io tree to properly cleanup those dirty ebs, but since it's
> already empty, no dirty ebs are properly cleaned up, thus will later
> trigger the warnings inside invalidate_btree_folios().
>
> [FIX]
> Normally such dirty ebs won't cause problems, as when the iput() is
> called on the btree inode, the dirty ebs will be forcibly written back,
> and since the fs is already in an error status, such writeback will not
> reach disk and finish immediately.
>
> But it's still better to get rid of such dirty ebs, if we ended up with
> dirty ebs but the fs is not in an error status, then such writeback at
> iput() time will be too late, as all workers are already stopped but
> writeback will utilize workers, which will lead to NULL pointer
> dereferences.
>
> Instead of unconditionally calling btrfs_extent_io_tree_release(), only
> call it if btrfs_write_and_wait_transaction() finished successfully, so
> that @dirty_pages extent io tree is kept untouched for transaction
> cleanup.
>
> CC: stable@vger.kernel.org # 6.1+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c     | 1 +
>  fs/btrfs/transaction.c | 9 ++++-----
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 308955f0592a..f28cef8217de 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4679,6 +4679,7 @@ static void btrfs_destroy_marked_extents(struct btr=
fs_fs_info *fs_info,
>                         free_extent_buffer_stale(eb);
>                 }
>         }
> +       btrfs_extent_io_tree_release(dirty_pages);
>  }
>
>  static void btrfs_destroy_pinned_extent(struct btrfs_fs_info *fs_info,
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 248adb785051..194f581b36f3 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1293,14 +1293,13 @@ static int btrfs_write_and_wait_transaction(struc=
t btrfs_trans_handle *trans)
>         blk_finish_plug(&plug);
>         ret2 =3D btrfs_wait_extents(fs_info, dirty_pages);
>
> -       btrfs_extent_io_tree_release(&trans->transaction->dirty_pages);
> -
>         if (ret)
>                 return ret;
> -       else if (ret2)
> +       if (ret2)
>                 return ret2;
> -       else
> -               return 0;
> +
> +       btrfs_extent_io_tree_release(&trans->transaction->dirty_pages);
> +       return 0;
>  }
>
>  /*
> --
> 2.54.0
>
>
