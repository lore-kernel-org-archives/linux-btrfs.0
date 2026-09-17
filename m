Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C22851EE0F
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 16:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663658; cv=none; b=LbEeguA+iBJpwbL7agR/0MIB5Dc96AL9wkRQvZ4T4X/U/p93h+tjRlqQm63WLs9mQbSb+68Qprkffjzd4QLQ12w/GUcmxzue4gZNz+Rfi3ecKDJurltzjsqX7td4rEU9nnu6BIUDfEkt761oBDFNLMgooU8mCVGE2ztP0d9YGJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663658; c=relaxed/simple;
	bh=3u6GA+oE3iO7INq7Q0zu10naOYEk9fVzTk/9kffSo4c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EMuO3oRq25oq+BbB1V/oqE8iT+V5PdGWj2ACodRD+rBVSR+2cC/YiZXw4q3nUWsaNzPQ9Y8E1ZK98JNc+XXQqsF04wcFo1+u7haiNuwpm5724rLunU2PUUPYHhjnw1bVlX0HkvR9ZCIW/d3mRtjUMuhR7mS91L2jVIvV9dJMPbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dskt5mBx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dskt5mBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4B11F00893
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 16:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663656;
	bh=1kpCsYVX7rZNUAjvAppLO7cDj6aItvN6dQrcAcKBQSE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Dskt5mBxrdV9RlseKIJqpa1F1sI7eV0d8L7vlBAdvztN/Ff5Rm/aj64cVLbLjKxbi
	 nRA28lrvmb2hRs0xYtuE71tcJ6hP6t+y18/7YpOk+aa57yIeB0TqhukWSgG2oEdWbZ
	 sNrrbYi1ithT3Zo4WWeKTF+mNm00IsU25WFnT8rbwRGbQaf16BZLqz7modtmNgdv5N
	 /dgLNxSaZYcl0srKszrwepAOLdSq4b2oFIiTwjIEyJzpMUo+xEy7SoOYZ35NWgXZCn
	 jWEz+cIpjb+XV5Lt2ZC7j0toV5A7NpLWT+UiiyK40nhyLrsA0Ib9NHy8gGNO8WO0MU
	 bN2H6AHhE+egg==
Received: by mail-vs2-f12.google.com with SMTP id ada2fe7eead31-785692e5a3aso584612137.2
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 09:47:36 -0700 (PDT)
X-Gm-Message-State: AFuF++k80kFkj92dBOabmaAu0DUhdKsHWFqUpv69hMN+n4r3T9IVJcm9
	VMl9aJegT11FN2r1Y8qS/FMgD0cnXU/8nrs2MdqprjdtoEYcmqlbuv603f7azWFA22qJMKAEr5x
	dH2pPov/EO0TyPPHN8wInFtcuUPt+V2g=
X-Received: by 2002:a05:6102:6a8a:b0:79f:d90a:cf65 with SMTP id
 ada2fe7eead31-7a02dadb9f1mr7310684137.9.1789663655794; Thu, 17 Sep 2026
 09:47:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1789494885.git.boris@bur.io> <be489f34105166f30d55d071f7acf7a4c46772fa.1789494885.git.boris@bur.io>
In-Reply-To: <be489f34105166f30d55d071f7acf7a4c46772fa.1789494885.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 17 Sep 2026 17:46:59 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6dC8BwSa=aZx761mox4DSacSwBPJ4wBk_A6Nei3apWDw@mail.gmail.com>
X-Gm-Features: AcwNN1XkbWMYncQyHOe-VLcooLqEza6Q1BI8ZzGa7m0l5PPMMl0AkY22p7zs9C8
Message-ID: <CAL3q7H6dC8BwSa=aZx761mox4DSacSwBPJ4wBk_A6Nei3apWDw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] btrfs: pre-flush reflink source before taking
 inode locks
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 7:05=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> Consider the following sketch of a shell script:

Could you leave a blank line separating regular text from command lines or =
code?
It improves readability.

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

What significant infrastructure investment does fsync uses?
What is being done in this patch is nearly the same. With fsync, it's
a bit less trivial because there are two modes (full and fast).

I don't think there's a need to mention that or at least not in a way
that is a bit confusing.
Just saying that it follows a similar approach to fsync is enough.

>
> Therefore, do an optimistic btrfs_wait_ordered_range() without the locks
> while relying on the calls to btrfs_wait_ordered_range() under the
> locks in btrfs_remap_file_range_prep() to ensure correctness. In the
> worst case with concurrent writes while unlocked, we can end up doing
> the writeback twice, which I think is a reasonable price to pay to avoid
> victimizing innocent readers in a common case.
>
> With and without this patch, the above reproducer runs the reflink in
> the same ~0.5s on my system. Without the patch, the direct read blocks
> for basically the full duration of the reflink while with the patch it
> returns in a few milliseconds.
>
> Signed-off-by: Boris Burkov <boris@bur.io>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
>  fs/btrfs/reflink.c | 28 ++++++++++++++++++++++++----
>  1 file changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index d2a4101912bd..24c0b226bc31 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -833,6 +833,17 @@ static noinline int btrfs_clone_files(struct file *f=
ile, struct file *file_src,
>         return 0;
>  }
>
> +static u64 calc_remap_wb_len(struct btrfs_inode *src_inode, loff_t off, =
loff_t len,
> +                            unsigned int remap_flags)
> +{
> +       const u32 bs =3D src_inode->root->fs_info->sectorsize;
> +       const loff_t isize =3D i_size_read(&src_inode->vfs_inode);
> +
> +       if (len =3D=3D 0 && !(remap_flags & REMAP_FILE_DEDUP))
> +               return ALIGN(isize, bs) - ALIGN_DOWN(off, bs);
> +       return ALIGN(len, bs);
> +}
> +
>  static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_=
in,
>                                        struct file *file_out, loff_t pos_=
out,
>                                        loff_t *len, unsigned int remap_fl=
ags)
> @@ -876,10 +887,7 @@ static int btrfs_remap_file_range_prep(struct file *=
file_in, loff_t pos_in,
>          *    not for the ordered extents to complete. We need to wait fo=
r them
>          *    to complete so that new file extent items are in the fs tre=
e.
>          */
> -       if (*len =3D=3D 0 && !(remap_flags & REMAP_FILE_DEDUP))
> -               wb_len =3D ALIGN(inode_in->vfs_inode.i_size, bs) - ALIGN_=
DOWN(pos_in, bs);
> -       else
> -               wb_len =3D ALIGN(*len, bs);
> +       wb_len =3D calc_remap_wb_len(inode_in, pos_in, *len, remap_flags)=
;
>
>         /*
>          * Workaround to make sure NOCOW buffered write reach disk as NOC=
OW.
> @@ -930,6 +938,7 @@ loff_t btrfs_remap_file_range(struct file *src_file, =
loff_t off,
>         struct btrfs_inode *src_inode =3D BTRFS_I(file_inode(src_file));
>         struct btrfs_inode *dst_inode =3D BTRFS_I(file_inode(dst_file));
>         bool same_inode =3D dst_inode =3D=3D src_inode;
> +       u64 wb_start, wb_len;
>         int ret;
>
>         if (btrfs_is_shutdown(src_inode->root->fs_info))
> @@ -938,6 +947,17 @@ loff_t btrfs_remap_file_range(struct file *src_file,=
 loff_t off,
>         if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
>                 return -EINVAL;
>
> +       /*
> +        * Optimistically write out the src inode before taking locks.
> +        * Consistency is properly ensured by the btrfs_wait_ordered_rang=
e()
> +        * inside btrfs_remap_file_range_prep().
> +        */
> +       wb_start =3D ALIGN_DOWN(off, src_inode->root->fs_info->sectorsize=
);
> +       wb_len =3D calc_remap_wb_len(src_inode, off, len, remap_flags);
> +       ret =3D btrfs_wait_ordered_range(src_inode, wb_start, wb_len);
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
