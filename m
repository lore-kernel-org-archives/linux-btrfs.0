Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B918F3839BD
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785232010; cv=none; b=qKyGUZMCPvVrQTuzOcmjt5XCJZJrGwZVaGVoWSa45LmXe7uNNiI1IZTRBsXIS09nnrMVqmXpukfIRxsXHSR53iSYnAm8Hqt0K5jjX0XyfmK5yd18ECFkmm3ji0WcpAX/jcMBvzrB+XnA5JMcNY7LMjs6xQrJtgCtNvuil0l7U8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785232010; c=relaxed/simple;
	bh=odO/ghkGYhRoWhjlFrtxDaraqD/wom2FafFzPJ2+SSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iRW7LVBP3Gu7F85JTvTMppAuaHydFfaTLGixPYCanB4RZTIl0nRDxFvSCh+bo4YrST8vGxNax5l6vrDJJnlDGIexV0qWZmNEAos71DbxAW6ue3yU4JuU+XybHDqGrS/5LnWmMCPdvzPi7RO0UqZ8q1cPcxgbSEt9i8ntE523dPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H3yW6dIn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H3yW6dIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671C11F00A3A
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785232009;
	bh=xiqVjun1azCUNs0SLQ+gpy+QnqG9tNWslAYG/JItMaY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=H3yW6dInFo7f1FoEBGgbdiB4OciOF7WPKY0h4hJma+0uqC+q9opCOV36GDoTM8QKe
	 /vM65640yElSZT3z6wquxMYKaFyQzgMPXAEUr92pAvcKoJt2i3HzoquH8k9fosTYvI
	 Uq3EgpYDaB7cPhPvEpJbWWu/fIebIBh1tZ/4FbM528Adc2Nghc1gfO5RDTp1W7+7b5
	 phoKaGb7EB/ksGTiGjbaOABUaASD5c9zFVtF/iKXvemWEbL5kKnWTcpCc7mNo6ZhHu
	 Ea1id9FdN+x+2XuuL+ivqWdbipZcKi5XVBT1bIx/hkLOjw4LxRjL3jQbiW9I375aSP
	 Qs3sqrX+gCQ9w==
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-738a5cc517eso2500963137.2
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 02:46:49 -0700 (PDT)
X-Gm-Message-State: AOJu0YyBeo4IXfQRhq9wUFlNJlrZt58rUlZzX1+9km/YHT3k+eG0I8IC
	QnLl9D2zPzjsX8i+yhZaX0tsZr/eJ6eoND1VxBiOnWBBFrOMArMSuOS/n6jjnnxFDXE+wt8MCLr
	uIr5lY03ZsKSk9dqvHPanQpfJULh/RfU=
X-Received: by 2002:a05:6102:358c:b0:730:db02:1d08 with SMTP id
 ada2fe7eead31-7549fd6e3c3mr774806137.10.1785232008688; Tue, 28 Jul 2026
 02:46:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785229591.git.wqu@suse.com> <884ce3562fa3f10bfdec3b490e2d9d6a0f98153b.1785229591.git.wqu@suse.com>
In-Reply-To: <884ce3562fa3f10bfdec3b490e2d9d6a0f98153b.1785229591.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 28 Jul 2026 10:46:12 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6qr0Vy8G_MB1YOYo6c+sdU92cVN0mmctL=OojWeZFjgw@mail.gmail.com>
X-Gm-Features: AUfX_mxhvTln9D347ueI333GRU7O6bd2Csp3JOfcZrgZbWezrjfya8YFlOYYr9w
Message-ID: <CAL3q7H6qr0Vy8G_MB1YOYo6c+sdU92cVN0mmctL=OojWeZFjgw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] btrfs: use aligned range for locking in reflink
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 10:44=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> In btrfs_extent_same_range() and btrfs_clone_files(), the range passed
> into btrfs_lock_extent() is not aligned at its end, because we can
> reflink until the EOF, which may not be block aligned.
>
> Although this is not a big deal, for the sake of consistency, and to
> prepare for the upcoming stricter alignment check, pass an aligned range
> end to btrfs_lock_extent() and btrfs_unlock_extent().
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
>  fs/btrfs/reflink.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index ec6a760519d9..d2a4101912bd 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -687,10 +687,10 @@ static void btrfs_double_mmap_unlock(struct btrfs_i=
node *inode1, struct btrfs_in
>  static int btrfs_extent_same_range(struct btrfs_inode *src, u64 loff, u6=
4 len,
>                                    struct btrfs_inode *dst, u64 dst_loff)
>  {
> -       const u64 end =3D dst_loff + len - 1;
>         struct extent_state *cached_state =3D NULL;
>         struct btrfs_fs_info *fs_info =3D src->root->fs_info;
>         const u32 bs =3D fs_info->sectorsize;
> +       const u64 end =3D round_up(dst_loff + len, bs) - 1;
>         int ret;
>
>         /*
> @@ -799,7 +799,7 @@ static noinline int btrfs_clone_files(struct file *fi=
le, struct file *file_src,
>          * because we have already locked the inode's i_mmap_lock in excl=
usive
>          * mode.
>          */
> -       end =3D destoff + len - 1;
> +       end =3D round_up(destoff + len, bs) - 1;
>         btrfs_lock_extent(&inode->io_tree, destoff, end, &cached_state);
>         ret =3D btrfs_clone(src, inode, off, olen, len, destoff, false);
>         btrfs_unlock_extent(&inode->io_tree, destoff, end, &cached_state)=
;
> --
> 2.54.0
>
>
