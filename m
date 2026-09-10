Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF74341068
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 14:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789050758; cv=none; b=F5pH/Jxn8kpKoNFMUcoWquMe0h8LVqSfCouvhHGQJsIZL0iuGNc0xziBAMDCltWkKng2+xBHRfg99sD0Y+1G0xKxM9zR5vO9qGSgiit1TJJEaiIv6teBdWcqmGXl3W7iznLYHnwp0qsYOFlw3U3KCanenxwi9wpMs37M1K3qd/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789050758; c=relaxed/simple;
	bh=uKZLkzDrYPq6ZLspcN9h8TR+ZlInMmnliZCjSnDQA6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HXQsDpPGlUqoVxWTppB3FRpM8HXa4/WVqCF3vhZdZF0LMUi6NeZtmuLmHyf5zB82cYKRBqORVoR2jiGz/5h2psuSVFuHYKkR4hUonfa9B2KkwK8NHX0N/Y4MSd/0ayVNgL2X5eOuxTKqBcM6hQziq3w3TVK+FLGeYBDyOw3sZ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FuiTY0NE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FuiTY0NE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6F71F00893
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 14:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789050755;
	bh=zcXqClrBCWpXzcqkk13GtdyOgJEyGrgDA3ufGkLUMNQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FuiTY0NEYATYyJ/r5NejdmgTPc7FWnF1wSb50jeyJ8svzOJ3uSyP7+j9RYGJQ6rdA
	 xSWRFmcY30Jjc5oiNO6bTYYSupxg1RaVIlLl2StYMhyPr2KcvNGjcW/aAQallutLHf
	 CB0NnV0Sl12gn9jrq6kAyeOkP/G6Mb5TxQc2hPCd6DMy8walapVJFKoVKE3yPq2OU0
	 +p8+Cz9kFIb9Fu+tyF0RPPT8c7UCNuTeH9P1JFWZ+PCO5ads5a9zHOqTocR0l3U51o
	 l5SIJ6mot9Jw0G7BfUPYIuOAizI57EJqGLxLP+TYrW3NNI0F+ZWacgKD9oHE8X9MdY
	 hD5gMk3lLOLIQ==
Received: by mail-vs2-f12.google.com with SMTP id 71dfb90a1353d-5c83be8db39so441021e0c.3
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 07:32:35 -0700 (PDT)
X-Gm-Message-State: AFuF++lYZoPktsFSxVcfYBbKL6AcRci1a5LHTlC6cXvHG747ztJw39cC
	/8DoCJC8vatmyJRh2rTLy55rVMkb+lRTOuSkhfd1MMVJN/5a2bkzj/Fo1nxY/ntOlNJoOca5vuW
	lq2KHW3w8rpH2Oy+cRIwKijyBARYPI9g=
X-Received: by 2002:a05:6122:d1c:b0:5c6:6189:c756 with SMTP id
 71dfb90a1353d-5c83343fb7fmr5088182e0c.2.1789050754907; Thu, 10 Sep 2026
 07:32:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <65fa79581e1d29d6d6fabae71d23e741bff0ddf9.1788974902.git.boris@bur.io>
In-Reply-To: <65fa79581e1d29d6d6fabae71d23e741bff0ddf9.1788974902.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 10 Sep 2026 15:31:57 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5hG8MKbf4O5LhUJxg38BToPuOY69gjfc2tQdeUM5PYjA@mail.gmail.com>
X-Gm-Features: AcwNN1VoeMKXKEiqWMnliu6riSLGugeKOEMCmhtfFNphyDAg7qRONSmg75ZRz-0
Message-ID: <CAL3q7H5hG8MKbf4O5LhUJxg38BToPuOY69gjfc2tQdeUM5PYjA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: downgrade the reflink source inode lock
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 9, 2026 at 8:54=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> When doing a reflink, we are not writing to the src inode or modifying
> it in any way, so it is counter-intuitive to have to lock it
> exclusively. This has the cost of blocking other shared lock users of
> the src file for the duration of all the writeback and reflinking.
>
> One sort of counter-intuitive exception is that dio writes that come in
> under EOF try to take inode->i_rwsem shared, which would result in
> messed up views of the extents in the reflinked file. Therefore, add
> "being used as a reflink src" as another inode flag exception for the
> dio write shared tests that already exist to check for other dangerous
> conditions. In order to ensure that this flag is visible to the dio
> writer, reflink must first take i_rwsem exclusive, then set the flag,
> then downgrade to shared.
>
> I tested this with a concurrent reader on a 4G dirty source file
> concurrent with a reflink and saw the read operation go from a ~1s
> latency to milliseconds.

You mean a direct IO read operation happening in parallel with a
reflink using the same file as a source right?
And reflinking the entire file?

Because we only take the VFS lock (rwsem in struct inode) for direct IO rea=
ds.

However during reads (both direct IO and buffered) we always lock the
extent range in the inode's extent io tree, and the reflink also locks
the range.
So taking the rwsem in shared mode won't help much unless we are not
reflinking the whole file and direct IO reads happen on a different
range.
I think that should be explicit in the change log.


>
> Note: if a writer arrives mid-clone it queues on the rwsem and later
> readers will block behind it due to the rwsem fairness implementation.
> Therefore this change does not rule out all possible reader blocking.

There is also an issue pointed out by sashiko that seems valid to me:

https://sashiko.dev/#/patchset/65fa79581e1d29d6d6fabae71d23e741bff0ddf9.178=
8974902.git.boris%40bur.io

As every direct IO read and write increment i_dio_count with a call to
inode_dio_begin() in iomap.

Thanks.

>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/btrfs_inode.h |  9 +++++++++
>  fs/btrfs/direct-io.c   |  7 +++++++
>  fs/btrfs/reflink.c     | 15 +++++++++++++--
>  3 files changed, 29 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 46c62f980c24..fd137a466c9d 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -99,6 +99,15 @@ enum {
>          * range).
>          */
>         BTRFS_INODE_COW_WRITE_ERROR,
> +       /*
> +        * DIO writes take the VFS inode lock in shared mode rather than
> +        * exclusive like other writing operations. We want to hold the l=
ock on
> +        * the src inode shared for reflink, but that does still need to =
be
> +        * exclusive with DIO writes. Therefore, note such reflink src ho=
lders
> +        * on the inode. If a DIO write sees this bit set, it should take=
 the
> +        * VFS inode lock exclusive.
> +        */
> +       BTRFS_INODE_REFLINK_SRC,
>         /*
>          * Indicate this is a directory that points to a subvolume for wh=
ich
>          * there is no root reference item. That's a case like the follow=
ing:
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 3075d7992713..ed3914257d39 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -913,6 +913,13 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struc=
t iov_iter *from)
>                 goto relock;
>         }
>
> +       if ((ilock_flags & BTRFS_ILOCK_SHARED) &&
> +           test_bit(BTRFS_INODE_REFLINK_SRC, &BTRFS_I(inode)->runtime_fl=
ags)) {
> +               btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
> +               ilock_flags &=3D ~BTRFS_ILOCK_SHARED;
> +               goto relock;
> +       }
> +
>         ret =3D generic_write_checks(iocb, from);
>         if (ret <=3D 0) {
>                 btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index d2a4101912bd..e33926243030 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -943,6 +943,16 @@ loff_t btrfs_remap_file_range(struct file *src_file,=
 loff_t off,
>         } else {
>                 lock_two_nondirectories(&src_inode->vfs_inode, &dst_inode=
->vfs_inode);
>                 btrfs_double_mmap_lock(src_inode, dst_inode);
> +
> +               /*
> +                * Reflink is a read operation on the src inode and a wri=
te on
> +                * the dst, so lock them accordingly. One wrinkle is that=
 direct
> +                * writes try to take inode->i_rwsem shared so we must do=
 an
> +                * acquire exclusive; set bit; downgrade to shared dance =
to
> +                * synchronize with that one weird writer.
> +                */
> +               set_bit(BTRFS_INODE_REFLINK_SRC, &src_inode->runtime_flag=
s);
> +               downgrade_write(&src_inode->vfs_inode.i_rwsem);
>         }
>
>         ret =3D btrfs_remap_file_range_prep(src_file, off, dst_file, dest=
off,
> @@ -960,8 +970,9 @@ loff_t btrfs_remap_file_range(struct file *src_file, =
loff_t off,
>                 btrfs_inode_unlock(src_inode, BTRFS_ILOCK_MMAP);
>         } else {
>                 btrfs_double_mmap_unlock(src_inode, dst_inode);
> -               unlock_two_nondirectories(&src_inode->vfs_inode,
> -                                         &dst_inode->vfs_inode);
> +               clear_bit(BTRFS_INODE_REFLINK_SRC, &src_inode->runtime_fl=
ags);
> +               inode_unlock_shared(&src_inode->vfs_inode);
> +               inode_unlock(&dst_inode->vfs_inode);
>         }
>
>         /*
> --
> 2.55.0
>
>
