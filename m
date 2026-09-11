Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B3F3F5BC5
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 09:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789118287; cv=none; b=bn5h3mLdsGb8vkLmi+pSmgcf0ZVfxyvB3Jsr2xpkLm6D1tBexQQ4CqQw1a1tOVQElB+xf3LI/x4N6pWUIiQUmfVfVlszUQaKa7/0d4JgQOnzWuzPNDBJyMyLp9NzNx6H/XcrxcieTY5n9GdcCNTvlpJVp7V8c56Ly2TDPLJ4gfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789118287; c=relaxed/simple;
	bh=rOb84Hlt41ijKUyv/q0Acyk0bqwalsZuNe+CxqJpgxQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CYoS+yEWGRAIFONlGAmn68ZMjOKQm3EqInM5gysHKydmKJk7shJ+FMv8SFQnWjayCSrunwaRNU8pvcvhONImbm2hAHgd4T6VAJpRyKrtaXq+9QDClgt8jFotMd2bgQ9sLiQ5rzNVdllvxlnp2IFNMBr/Bv9euu3jMWHFYnr2cLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQajJPrN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQajJPrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462381F00898
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 09:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789118285;
	bh=CpPKtsJcD9wAKa0gctwWHXgOQxYlTCG/iVNoXsdmi90=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gQajJPrNNlQBtneNWXyAkMrSzmUlZXhBbZ3EGHmFAv8sdjHp4JIUqrD47xHDZvD9e
	 5ZuXF9Y8EdqGKUs0V6t0mxLqocjNUC6OxzgYCWL2XX+17Zp1u6RfomXzYSaN6pBnWr
	 pUiAFscTenMBplfxYvrez4E9DKU+d+O+ET7F6YecsfopwUtDAsued4lt4xYJwqlGiW
	 YqFww/jx8VgzHd6HsfWQaC9/ckw5cZK9ZU3BX9O81vWeEBn8FpZDJ8mddAohJRpXgZ
	 5cekg1sx+vhnblQifgISK1tQc1Dg02NRDhYVm1DuB4BK7Sa8HNyT6EI+UgjmTQXJ9j
	 Hs43zEvQHf2Zw==
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-7466771f1caso189158137.0
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 02:18:05 -0700 (PDT)
X-Gm-Message-State: AFuF++nZeQHRNgTWFyc2XzYCorMkXG/+9cvelJoW1cIzFNxVt1f1LAZo
	SaF3pfU50AaHbBUbddOyEUD7pj1f7VWTJAm8/FfyUgiBC/TRFBp5+OjolyVr/ciBK+AVkTXNha0
	NJNd0w6/moB0CkYBv6o/oJ6GXTiRnQt4=
X-Received: by 2002:a05:6102:80a9:b0:793:b8b8:e0db with SMTP id
 ada2fe7eead31-793b8b94faamr428917137.5.1789118284354; Fri, 11 Sep 2026
 02:18:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1789085863.git.boris@bur.io> <4ef5a4ea85bf903e058b0a8c88549e15745729c0.1789085863.git.boris@bur.io>
In-Reply-To: <4ef5a4ea85bf903e058b0a8c88549e15745729c0.1789085863.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 11 Sep 2026 10:17:27 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7_JXnHXZrBGpdK55CQtxiTA6H7KN0yemUirNU6RdNwPA@mail.gmail.com>
X-Gm-Features: AcwNN1XynAVYtD7-99duzo9jqiBw8NvzBH1joTAAAdJkXar52Thue4b6Lej5Sec
Message-ID: <CAL3q7H7_JXnHXZrBGpdK55CQtxiTA6H7KN0yemUirNU6RdNwPA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] btrfs: pre-flush reflink source before taking
 inode locks
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 11, 2026 at 1:39=E2=80=AFAM Boris Burkov <boris@bur.io> wrote:
>
> Consider the following sketch of a shell script:
>   dd if=3D/dev/urandom of=3D/mnt/src bs=3D1M count=3D4096
>   cp --reflink=3Dalways /mnt/src /mnt/dst &
>   sleep 0.1   # let the clone reach its flush
>   time dd if=3D/mnt/src of=3D/dev/null bs=3D4K count=3D1 iflag=3Ddirect
>
> The current logic in reflink ensures the existence and stability of both
> the src and destination inode by locking them both and then flushing all
> dirty pages / ordered_extents under the inode lock. This blocks
> concurrent usage by even readers of the inode locks, like direct reads
> or seeks for the duration of writeback on the entirety of the two files.
>
> We observe this particular contention frequently in the Meta fleet.
>
> It is also a relatively common pattern to write the src file, then reflin=
k
> it while it is still dirty, so that typical path naturally hits this
> contention. This workload motivates a relatively simple optimization:
> trigger the unavoidable src flushing outside the locked region.
>
> It is tempting to try to move the writeback out of the locks entirely
> but this is fraught with all kinds of consistency errors under various
> patterns of concurrent writes. fsync is able to manage such a pattern,
> but with significant infrastructure investment I don't think is
> justified for reflink.
>
> Therefore, do an optimistic single backwards pass which completes latent
> OEs while relying on the calls to btrfs_wait_ordered_range() under the
> locks in btrfs_remap_file_range_prep() ensure correctness. In the worst
> case with concurrent writes while unlocked, we can end up doing the
> writeback twice, which I think is a reasonable price to pay to avoid
> victimizing innocent readers in a common case.
>
> With and without this patch, the above reproducer runs the reflink in
> the same ~0.5s on my system. Without the patch, the direct read blocks
> for basically the full duration of the reflink while with the patch it
> returns in a few milliseconds.
>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/reflink.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
>
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index d2a4101912bd..7bab391f1be4 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -923,6 +923,46 @@ static bool file_sync_write(const struct file *file)
>         return false;
>  }
>
> +/*
> + * Do a single backwards pass waiting for ordered extents on the inode.
> + *
> + * Backwards is helpful because it avoids picking up concurrent appended=
 OEs
> + * and the intent of the function is to wait on pre-existing OEs without=
 going
> + * to the extreme of locking the ordered_tree and snapshotting its conte=
nts.
> + *
> + * This is only useful as an optimization for waiting for ordered extent=
s outside
> + * locks. It DOES NOT ensure that the range is free of ordered extents.
> + *
> + * Returns -EIO if any waited on OE had the ORDERED_IOERR bit set and 0 =
otherwise.
> + */
> +static int wait_existing_ordered_extents(struct btrfs_inode *inode)
> +{
> +       u64 orig_end =3D i_size_read(&inode->vfs_inode);
> +       u64 end =3D orig_end;

What's the point of orig_end if it's not used elsehwere?
Just this:

u64 end =3D i_size_read(&inode->vfs_inode);


> +       int ret =3D 0;
> +
> +       while (true) {
> +               struct btrfs_ordered_extent *ordered;
> +
> +               ordered =3D btrfs_lookup_first_ordered_extent(inode, end)=
;
> +               if (!ordered)
> +                       break;
> +               if (ordered->file_offset > end) {
> +                       btrfs_put_ordered_extent(ordered);
> +                       break;
> +               }
> +               btrfs_start_ordered_extent(ordered);
> +               end =3D ordered->file_offset;
> +               if (test_bit(BTRFS_ORDERED_IOERR, &ordered->flags))
> +                       ret =3D -EIO;
> +               btrfs_put_ordered_extent(ordered);
> +               if (!end)
> +                       break;
> +               end--;
> +       }
> +       return ret;

Why do we need another function to wait for ordered extents just for reflin=
ks?

We have btrfs_wait_ordered_range() that does exactly the same...

Besides that, this waits for all ordered extents. If a reflink
operates on a small range, we end up waiting for any ordered extents,
which slows down such ranged reflinks.
btrfs_wait_ordered_range() allows to pass a range.

> +}
> +
>  loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
>                 struct file *dst_file, loff_t destoff, loff_t len,
>                 unsigned int remap_flags)
> @@ -938,6 +978,14 @@ loff_t btrfs_remap_file_range(struct file *src_file,=
 loff_t off,
>         if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
>                 return -EINVAL;
>
> +       ret =3D filemap_flush(src_inode->vfs_inode.i_mapping);

So again, this flushes the entire file, which adds overhead for
reflinks operating on a small range and causes unnecessary IO.

Further, using filemap_flush() is not enough in case we have compression.
The flush call only starts the compression work in an async worker, we
need a second flush call to wait for the compression to finish and for
writeback to start (creating ordered extents).
That's why we have btrfs_fdatawrite_range(), which does the double
flush in case we have compression, and also supports specifying a
range.

Thanks.

> +       if (ret < 0)
> +               return ret;
> +
> +       ret =3D wait_existing_ordered_extents(src_inode);
> +       if (ret < 0)
> +               return ret;
> +
>         if (same_inode) {
>                 btrfs_inode_lock(src_inode, BTRFS_ILOCK_MMAP);
>         } else {
> --
> 2.55.0
>
>
