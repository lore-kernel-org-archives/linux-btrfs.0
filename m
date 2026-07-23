Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8D343BDC4
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 10:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784803178; cv=none; b=b/J0MHd6tjjpOWNulnSCS8XsmiIlXMdQ3unbjYytKyZju2xK4oibDokofHH+QVeSQxqKnkYkhLpcRpbDTHc04OTcpDrE72vwmJ+kG7pcrg4o7gACxKbQpJp+4wYVKm32u0VqcLJ18jq4F72hUBc5mT61mnHvz2fJvhTU4lPVK5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784803178; c=relaxed/simple;
	bh=EVUiZY/HK2V0VRNfE7lIy6EtYCs06nT1gs6mGhMKIKw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I8wdMnRQs01e5fdPy1NCVDidDTb6Lsqd1EhUk7TvHjwjUVF2irJ7W3Q0cefZnK1W3FPdmPwMUDeybb/15dCDm7UMpLDPwRpTKLwD3qSXY8hkguXWdLUViYe8SGJuVkfuC6NLjQEhJKuQoODcN7XDg5FzzAi6rwc2lZlHhINQQoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB8C1F00A3A
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 10:39:36 +0000 (UTC)
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-74ace427b29so155368137.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 03:39:36 -0700 (PDT)
X-Gm-Message-State: AOJu0YwCjYB1eyo6q920WXbPH9LfCrM9CXbI16zVUR2CnWPq+l33unlt
	Uepn/hpaU6K4qLy9OEapW7OyKg0WIgNF29QClxJHhEQb41Kt+Bpa4CFd4Y+H5Uld7t6pFp2bGgn
	Rp4JusO/B2ns2StqzTO++SzNl2slNA3Y=
X-Received: by 2002:a05:6102:a46:b0:745:31e9:f3d9 with SMTP id
 ada2fe7eead31-74d5d9c777amr970955137.1.1784803175098; Thu, 23 Jul 2026
 03:39:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c6dfdac9fc51c94183e51a861eec269185239660.1784787211.git.wqu@suse.com>
In-Reply-To: <c6dfdac9fc51c94183e51a861eec269185239660.1784787211.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 23 Jul 2026 11:38:57 +0100
X-Gmail-Original-Message-ID: <CAL3q7H55GkjjCougzD3w2qarX0x6XoQu5G680xv3iuqTMgQ0YA@mail.gmail.com>
X-Gm-Features: AUfX_myDOUqv0CUO73j-PuIKXYovKulV78DAJeiXptrrNU6W2nrjmJ1-YhP9XwE
Message-ID: <CAL3q7H55GkjjCougzD3w2qarX0x6XoQu5G680xv3iuqTMgQ0YA@mail.gmail.com>
Subject: Re: [PATCH RFC v2] btrfs: disable direct reads to avoid dirty folios
 without fs knowing
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 7:16=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> There is a bug report that a reproducer which doing the following
> workloads in two threads:
>
> - Direct read into memory mapped from page cache
> - Sync the above range
>
> This can lead to dirty folios without fs knowing, this can be a huge

Can you please explain where, and why, the folio is dirtied?

How does a direct IO read dirties a folio or a sync_file_range(2) call?

Thanks.

> problem for btrfs, as even on the very basic bs =3D=3D ps cases without
> large folios, such reproducer can screw up the ordered extent accounting
> already:
>
>  ------------[ cut here ]------------
>  WARNING: fs/btrfs/ordered-data.c:390 at can_finish_ordered_extent.isra.0=
+0x56/0x1f0 [btrfs], CPU#1: kworker/u42:0/68
>  CPU: 1 UID: 0 PID: 68 Comm: kworker/u42:0 Tainted: G            E       =
7.2.0-rc4-custom+ #415 PREEMPT(full)  74dbeafab12c410178747d5bec9fb200ae569=
49f
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2=
022
>  Workqueue: btrfs-endio simple_end_io_work [btrfs]
>  RIP: 0010:can_finish_ordered_extent.isra.0+0x56/0x1f0 [btrfs]
>  Call Trace:
>   <TASK>
>   btrfs_finish_ordered_extent+0x39/0xd0 [btrfs 7d1ffd99bb9696179883f257e5=
fd838e2d1a0ca3]
>   end_bbio_data_write+0x1ff/0x280 [btrfs 7d1ffd99bb9696179883f257e5fd838e=
2d1a0ca3]
>   btrfs_bio_end_io+0x76/0xf0 [btrfs 7d1ffd99bb9696179883f257e5fd838e2d1a0=
ca3]
>   process_one_work+0x198/0x380
>   worker_thread+0x1c8/0x330
>   kthread+0xee/0x120
>   ret_from_fork+0x28f/0x310
>   ret_from_fork_asm+0x11/0x20
>   </TASK>
>  ---[ end trace 0000000000000000 ]---
>  BTRFS critical (device dm-3): bad ordered extent accounting, root=3D5 in=
o=3D257 OE offset=3D3465216 OE len=3D2826240 to_dec=3D319488 left=3D135168
>
> Unfortunately we have removed cow fixup mechanism, which is to work
> around such dirty folios by re-dirtying them and reserve space for them,
> across several kernel releases, meaning we can not easily revert a
> single commit to bring it back.
> And without doubt, that old cow fixup mechanism is not support larger
> folios.
>
> As a hot fix, disable btrfs direct reads for non-experimental builds for
> now, so this can buy some time before we find out a proper way to address
> this.
>
> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Link: https://lore.kernel.org/linux-btrfs/f12f70e5-d84d-4a9f-ac94-693be4c=
863ac@linux.ibm.com/
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Fallback to buffered IO to avoid failing existing direct IO users
>
> - Allow direct writes
>
> Reason for RFC:
> I'm not 100% sure if disabling direct IOs can fill all the holes.
>
> We still allow mmapping page cache into user spaces, thus I'm not sure
> if this is the only hole.
> ---
>  fs/btrfs/direct-io.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index ed1779ccb4de..32b29a4faaf2 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -1093,6 +1093,11 @@ ssize_t btrfs_direct_read(struct kiocb *iocb, stru=
ct iov_iter *to)
>         if (check_direct_read(inode_to_fs_info(inode), to, iocb->ki_pos))
>                 return 0;
>
> +#ifndef CONFIG_BTRFS_EXPERIMENTAL
> +       /* To avoid dirty folios without fs knowing through */
> +       return 0;
> +#endif
> +
>         btrfs_inode_lock(BTRFS_I(inode), BTRFS_ILOCK_SHARED);
>  again:
>         /*
> --
> 2.54.0
>
>
