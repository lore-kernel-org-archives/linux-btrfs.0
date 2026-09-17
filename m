Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C4F5218BE
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 16:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663748; cv=none; b=Wdv6pwGrV/mbnmPjSvJ4XdJ/4LBucfZP+E6b6+DAEKD30Grzm8i8jrVx4G/j7DBJN0OeZflKd/IB98ryvU/ObrGjedWHi9CQ9Nsg+VseWAwTKI0AMliyknZp8jWwaJsjIfzdjsRbbOSqsPnyl9jKImsfl9nAVDQbhTUbhoOisl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663748; c=relaxed/simple;
	bh=QminicbzHkg5v7EplPy0vIBCmaGo4Jikzlu5sYZxKOQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iwVTWO2yZfTowK+H1TCxQD0dAJOSsCFlOAQ29TFQLbE4sXFxQJlba9niMHgaQWGKuy2SekOHnAX6yupvfdzQVaxlvXMPUD1hKc4yx3CgpVNZSbgn4TPuCmllsIVJUmATxcsgaBXQMPM7oja1hk4bX65S2oDPeTQrYMbEeu0K6DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Le2tpVzn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Le2tpVzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3681F00893
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 16:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663746;
	bh=wEyNmHxyXlKrn7yytdhdSxJDgeUKETROLN5Anv6BEyk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Le2tpVzn/A8lnASMFF0ex1w3i13rfZ96pLhW33URge88NETsGN6fwLlyfeLXldE8F
	 Wl69InZt528LFUkQfOvlY/GD0pLxdyRqc4jvbvBHfRf4TwJ+ilOiuvcb4P6pWKzcRg
	 2x50oKS123W5B9XiwkyCUFJ7yK/3lNh4wk/ZItDKVtyW+7361Bs1N0OIcydua7nqmv
	 kKJPRryHmwZIfxVKi2zHVNMFej7GuA/W1zFni7Qe4gC61NB2QoAP5IsOgDQCf5dXUv
	 U1y2IzXhkKx8gwiesNXGh4f6lX87qwa+VTJeLChMjzRrX0cvs5/joZhwZv0eXDuMsK
	 bWqOdp/qO95pw==
Received: by mail-ua2-f12.google.com with SMTP id a1e0cc1a2514c-97e7c72bfebso307936241.3
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 09:49:06 -0700 (PDT)
X-Gm-Message-State: AFuF++msHf2+n5xonXUKwOyw2Beqzde8aARdZYalkTVrK5PVegtjcTQx
	MN2pSPWho1kAPizr/pLziKz0BWpucNSxZ5cSAsvFGdb1CoizTc8s1gQmxIZEVm4V8X6sbPxhxhT
	5dOggiFmopB1vzEVFsoysOH+wJRrpCeo=
X-Received: by 2002:a05:6102:8099:b0:785:d308:cc0a with SMTP id
 ada2fe7eead31-7a028d61bbfmr7737621137.9.1789663745593; Thu, 17 Sep 2026
 09:49:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1789494885.git.boris@bur.io> <6ffbf81411eae05272e54ce49460e030eb81f91f.1789494885.git.boris@bur.io>
In-Reply-To: <6ffbf81411eae05272e54ce49460e030eb81f91f.1789494885.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 17 Sep 2026 17:48:28 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5--3_DbLSvSMaqy-gXw7GO2LJvRuKXPnaoA81mCQH+Cg@mail.gmail.com>
X-Gm-Features: AcwNN1VHtFYgpbY6j8WwhVvr3UJD0lmm2i-xT3Q-neNPpDCa62GN3ng_6phxpBQ
Message-ID: <CAL3q7H5--3_DbLSvSMaqy-gXw7GO2LJvRuKXPnaoA81mCQH+Cg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] btrfs: skip unlocked reflink source flush if the
 inode has writers
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 8:05=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> The optimistic unlocked flushing is counter-productive if there is an
> active writer dirtying pages, as it results in doubly writing back any
> pages that get dirtied again before the locked flush. Therefore,
> pessimize it slightly and don't do the unlocked flushing if we have
> outstanding writable file descriptors or memory mappings. Since the
> inode isn't locked, this is only advisory, any new mapping or fd that
> sneaks in after the check but before the locking can still cause extra
> writeback. But it trivially helps quite a bit in simple cases with a
> long open file descriptor or mapping.
>
> I tested this with two similar workloads. One was keeping and fd open
> and doing continuous writes into the src file while cloning it and doing
> lseek on it and the other was slightly meaner, constantly opening and
> closing the fd to try to race this check.
>
> Workload 1 shows a huge regression in write amplification and writers
> and readers who experience userspace wall time stalls of 100ms+ with
> just the pre-flush, but recovers to normal with this check.
>
> Workload 2 is a smaller regression which is mostly helped but not fully
> resolved with this check. So we must weigh this regression against the
> benefit of the unlocked flush in the allegedly more common simpler case.
>
> Workload 1: fd kept open, 60s of clone/write/lseek looping.
> kernel        clones  clone mean s  device MiB/clone  writer stalls  read=
er stalls
> for-next         564         0.095               119             10      =
       10
> pre-flush (p1)   179         0.338               405             94      =
       93
> skip (p1+p2)     540         0.100               116              9      =
        9
>
> Workload 2: same writer, but closing and reopening the fd around each
> 64 MiB write with some random sleeping to encourage racing.
> kernel        clones  clone mean s  device MiB/clone  writer stalls  read=
er stalls
> for-next         740         0.070                83              9      =
        9
> pre-flush (p1)   255         0.224               246             27      =
       26
> skip (p1+p2)     518         0.107               121             11      =
       11
>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/reflink.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index 24c0b226bc31..fe765ab27c82 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -950,13 +950,19 @@ loff_t btrfs_remap_file_range(struct file *src_file=
, loff_t off,
>         /*
>          * Optimistically write out the src inode before taking locks.
>          * Consistency is properly ensured by the btrfs_wait_ordered_rang=
e()
> -        * inside btrfs_remap_file_range_prep().
> +        * inside btrfs_remap_file_range_prep(). This optimization causes
> +        * redundant writeback if there is a concurrent writer to the src=
 file
> +        * so try to catch anyone holding the file open for writes and sk=
ip
> +        * the optimization in that case.
>          */
>         wb_start =3D ALIGN_DOWN(off, src_inode->root->fs_info->sectorsize=
);
>         wb_len =3D calc_remap_wb_len(src_inode, off, len, remap_flags);
> -       ret =3D btrfs_wait_ordered_range(src_inode, wb_start, wb_len);
> -       if (ret < 0)
> -               return ret;
> +       if (atomic_read(&src_inode->vfs_inode.i_writecount) <=3D 0 &&

Instead of reading the counter directly, use inode_is_open_for_write() plea=
se.

With that change:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +           !mapping_writably_mapped(src_inode->vfs_inode.i_mapping)) {
> +               ret =3D btrfs_wait_ordered_range(src_inode, wb_start, wb_=
len);
> +               if (ret < 0)
> +                       return ret;
> +       }
>
>         if (same_inode) {
>                 btrfs_inode_lock(src_inode, BTRFS_ILOCK_MMAP);
> --
> 2.55.0
>
>
