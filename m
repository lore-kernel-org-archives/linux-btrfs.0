Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22D34F7CB8
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 16:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664101; cv=none; b=pDrPDS7AeWQap3o/H7/4VALeKPjZ0bZvy33ayvkhyMRCse1cdHxtZ8uqkR1roINwEBRjPzJwOllcp87AoPCeTO7hyvCMTmeG3Z3UpLU4oBKCkpsZLC+5ZHTogOZ5sAQhCfLeLR4CRtValrO99j8bHX+NhCG4k2i3B+AAA8coRpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664101; c=relaxed/simple;
	bh=6/cASXodS9LYymq/6Zq4WeSBQIUXsJIS+pITtYteUkk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z0M8vo+3n+DBD6+btCjWwHpdgoxRsL02TpaBLmbpRU2do8ClNQ6wWpoYYP2QtBTAsyxDU2/ZmvO2hGeLJfSvYi4i/lUyNQTOZu7fPIEJehOHbraNJDG4Z/aJ3xoWTlAVHrwxxCw77X8o1XXauZN6iG75qngWCJbepGqjJj1LeRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bThg6MAR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bThg6MAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFD61F00898
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 16:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789664099;
	bh=DfCDwRIk6zy0V5xQbBgaLpJ3tSjS2s4dUvyJ4TCvGIU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bThg6MARYtT7+ixm85ZMSHqz0IYPKic1sHPpHilOEtrl9yrzqw6XexgiSvB6yT7Tt
	 Mmb2Bdyy604onvvSnBnCd4ZA9LPzxRP+ZjDIav0aCi5lAI6BkCJr/f6tLVGdm9AYaS
	 Yl07nW5QMkeI1aebupK0YiSG6kzwuU/03Wq4kF/hbu+ew5/MrXne0sbETRBgeoWFPT
	 fprZ0L6zb17RUdJ2stWzRj4t3iSBvfl4Wf/l0hNLofaSYn7azfRRGoY35E/m6sj25+
	 2aWdSlTXpgIZrsYFS1qN0VkR+k7ndXVU/cnO0baU8X1+pLSQqyrHl1UOElNLcrzodi
	 fJs7O7Ge6sgXg==
Received: by mail-vs2-f12.google.com with SMTP id ada2fe7eead31-78565b4db77so618092137.0
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 09:54:59 -0700 (PDT)
X-Gm-Message-State: AFuF++nEI8PtZ3aaOngttZF8k7RK6JNxl/sjRhHoATILP/x5nvDqrv/i
	xpESz8TXMYIYGntWhQ2k2m9Uhw1hFtwR155h/Rp/dG0acM5rx1MmTprioL3q9FZ1yIZpUh+8wpG
	ScqijYsZHkZ/9cKzZ0ONSZIzyAzxDiWE=
X-Received: by 2002:a05:6102:a46:b0:7a1:f7c3:3a4b with SMTP id
 ada2fe7eead31-7a1f7c33f66mr2379834137.24.1789664098708; Thu, 17 Sep 2026
 09:54:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1789494885.git.boris@bur.io> <069b34c29713b4574ad37cfe55e728d555e019b2.1789494885.git.boris@bur.io>
In-Reply-To: <069b34c29713b4574ad37cfe55e728d555e019b2.1789494885.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 17 Sep 2026 17:54:21 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7CimeRqMOiq3Gde9tt81iaoMdGzS3VLZiObh6ue3e4uA@mail.gmail.com>
X-Gm-Features: AcwNN1WdXGlVE4IJex6F8pcQiXkDDh7NE3IUXuCuI4jyhOV6830UcpZHEvXOOJY
Message-ID: <CAL3q7H7CimeRqMOiq3Gde9tt81iaoMdGzS3VLZiObh6ue3e4uA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] btrfs: downgrade the reflink source inode lock for
 tree walking
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 7:08=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> When doing a reflink, we are not writing to the src inode or modifying
> it in any way, so it is counter-intuitive to have to lock it
> exclusively. This has the cost of blocking other shared lock users of
> the src file for the duration of all the writeback and reflinking.

This last sentence is a bit outdated, as we very often no longer wait
for the duration of all writeback, since it usually happens before
locking.

Other than that:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>
> There are two important gotchas to do with direct io that must be
> addressed to make this idea work.
>
> The first gotcha is that dio writes that come in under EOF try to take
> inode->i_rwsem shared, which would result in messed up views of the
> extents in the reflinked file. Therefore, add "being used as a reflink
> src" as another inode flag exception for the dio write shared tests that
> already exist to check for other dangerous conditions. In order to
> ensure that this flag is visible to the dio writer, reflink must first
> take i_rwsem exclusive, then set the flag, then downgrade to shared.
>
> The second is that dio reads increment inode->i_dio_count which blocks
> inode_dio_wait() in __generic_remap_file_range_prep(). Therefore, we
> must remain exclusive to dio reads through finishing the prep or risk
> starving the clone on a stream of dio readers. There is still O(extents)
> work in btrfs_clone() which can be done without holding the lock
> exclusive, so we should downgrade to shared and admit dio readers (and
> other shared lock users like lseek) after we are finished with
> inode_dio_wait().
>
> By running concurrent clones and lseeks or dio reads on a src file with
> 32k extents on a vm, I can demonstrate 100ms+ stalls on the readers
> without this patch and they go away entirely with the patch.
>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/btrfs_inode.h |  6 ++++++
>  fs/btrfs/direct-io.c   |  7 +++++++
>  fs/btrfs/reflink.c     | 17 +++++++++++++++--
>  3 files changed, 28 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 46c62f980c24..03c00c99099d 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -99,6 +99,12 @@ enum {
>          * range).
>          */
>         BTRFS_INODE_COW_WRITE_ERROR,
> +       /*
> +        * Set by reflink while it holds the source's VFS inode lock shar=
ed.
> +        * Direct IO writes also take that lock shared; one that finds th=
is bit
> +        * set after acquiring it must retry with the exclusive lock.
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
> index fe765ab27c82..72c1e0db57b7 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -939,6 +939,7 @@ loff_t btrfs_remap_file_range(struct file *src_file, =
loff_t off,
>         struct btrfs_inode *dst_inode =3D BTRFS_I(file_inode(dst_file));
>         bool same_inode =3D dst_inode =3D=3D src_inode;
>         u64 wb_start, wb_len;
> +       bool src_downgraded =3D false;
>         int ret;
>
>         if (btrfs_is_shutdown(src_inode->root->fs_info))
> @@ -976,6 +977,12 @@ loff_t btrfs_remap_file_range(struct file *src_file,=
 loff_t off,
>         if (ret < 0 || len =3D=3D 0)
>                 goto out_unlock;
>
> +       if (!same_inode) {
> +               set_bit(BTRFS_INODE_REFLINK_SRC, &src_inode->runtime_flag=
s);
> +               downgrade_write(&src_inode->vfs_inode.i_rwsem);
> +               src_downgraded =3D true;
> +       }
> +
>         if (remap_flags & REMAP_FILE_DEDUP)
>                 ret =3D btrfs_extent_same(src_inode, off, len, dst_inode,=
 destoff);
>         else
> @@ -986,8 +993,14 @@ loff_t btrfs_remap_file_range(struct file *src_file,=
 loff_t off,
>                 btrfs_inode_unlock(src_inode, BTRFS_ILOCK_MMAP);
>         } else {
>                 btrfs_double_mmap_unlock(src_inode, dst_inode);
> -               unlock_two_nondirectories(&src_inode->vfs_inode,
> -                                         &dst_inode->vfs_inode);
> +               if (src_downgraded) {
> +                       clear_bit(BTRFS_INODE_REFLINK_SRC, &src_inode->ru=
ntime_flags);
> +                       inode_unlock_shared(&src_inode->vfs_inode);
> +                       inode_unlock(&dst_inode->vfs_inode);
> +               } else {
> +                       unlock_two_nondirectories(&src_inode->vfs_inode,
> +                                                 &dst_inode->vfs_inode);
> +               }
>         }
>
>         /*
> --
> 2.55.0
>
>
