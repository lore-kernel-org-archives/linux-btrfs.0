Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8E437646A
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 10:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780654255; cv=none; b=VE/N4ARMH1jR8SBkh3hN2JT9taxQr8DB7eD+ht2RuvBrTB36ml/qOLcgD37au/m/7TIaI3TPY7pV4wfTIIGMHVRzpn7cwWJSATEMo7aCrD6NhhZMoONDNOO4CvG/TJOadjPcEvYxf6rMdUmq+KAgWU+l5L7C/Lm2qIiSfW9VsMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780654255; c=relaxed/simple;
	bh=duT8YyBFVMpExNcX24JCr7JcyaNeZCmo3kVbrRvhYdg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xb4HVfBU/bEieOT2x2/hmYdW+w4IZ0lUap3OYxfF0HuPAa5UfmJzGHbfPuZrNkgZxlKeDYe96i/rE43+3XEA4+06N6mqs1YzQzR8G8ISbAmDQ8gPvyeIaOJJk/I3V2UBRqLymfaKNbXnHzYbvjJC6casftFvFGT6PE/i6fYBKlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FCrGJrtz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FCrGJrtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415181F00893
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 10:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780654254;
	bh=tega+pEasYeniVYsNR4WAXQobha8lPKnlkjpLIxegvM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FCrGJrtzDcH5uovaZvJdr8unrOEaFcpe/+fLOh/0dN4d+/lN3ifqnE2Kvd2qTbUTT
	 gEH+yXazeX0pa5WZ/PRSIRFmfRQm79YbgdgqEbAmZsnXyxzh4n9oneUFd2naZerFj5
	 XjIIcC/Yipoeetc3tT1hInaxbnYyaNrBtU/b4QDbjKNEp/MfWAwCmxAT/dp8yMHNVG
	 XAd+y1/e/LTcr3hrDMEzHuOKF/WcIVTKN8FK+l6H3Lba6aZRpSP/A5moug5pkjE2zh
	 zKFNFwS6YEu84gTmrVkJPzBXwFGOrkyMe9KehAniP0wZImNMtsnNo83dhvGw5oARpL
	 3Svqsaa8IQLSw==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-687e7edaafeso3413540a12.1
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2026 03:10:54 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy8ksH78yVLJjU7N+lkIamjz2Jl5grZGkchF3H1AamYJ2hZLxbL
	kLQi63x16V05NYgU71e6e2LgkD2XoU+PEsbhmJfu6tp5aBWj2l5Ovmg5rkth8pKafO7Xmyel2S8
	jGCHPzN6e6Hfr6qI6KUcPuYpEpexeBQk=
X-Received: by 2002:a17:907:96a6:b0:bee:959e:9ac8 with SMTP id
 a640c23a62f3a-bf37037f945mr104440866b.4.1780654252825; Fri, 05 Jun 2026
 03:10:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1780645090.git.wqu@suse.com> <30dc9cbbaef57713552d7d00f1137c7c2b5be53e.1780645090.git.wqu@suse.com>
In-Reply-To: <30dc9cbbaef57713552d7d00f1137c7c2b5be53e.1780645090.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 5 Jun 2026 11:10:15 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5HP-aRh4eotU_qbwdA2ppFCYDdBqRSuwW=uB2H6mukvQ@mail.gmail.com>
X-Gm-Features: AVVi8CeM7xItwH0qPPmL1Lztmj9xbY9klYE7jzcI0a2JkYrStVlMw2rETLXvuEo
Message-ID: <CAL3q7H5HP-aRh4eotU_qbwdA2ppFCYDdBqRSuwW=uB2H6mukvQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] btrfs: wait for OE to be fully removed before falling
 back to buffered
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 5, 2026 at 10:08=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> Currently if a direct write failed for whatever reasons, e.g. page fault
> failure or IO error, then we fallback to buffered IO.
>
> But it's possible that the direct write attempt has created some ordered
> extent, and they may not be fully removed from the inode io tree yet:
>
>  btrfs_direct_write:
>  |- __iomap_dio_rw()
>  |  |- btrfs_dio_iomap_begin()
>  |  |  |- btrfs_get_blocks_direct_write()
>  |  |     |- btrfs_create_dio_extent()
>  |  |        Now an OE is created for the whole range
>  |  |
>  |  |- iomap_dio_iter()
>  |  |  Failed with -EFAULT, which is pretty common inside
>  |  |  btrfs as we have set iov_iter->nofault flag.
>  |  |
>  |  |- btrfs_dio_iomap_end()
>  |     |- btrfs_finish_ordered_extent()
>  |        |- btrfs_queue_ordered_fn()
>  |           The real removal of the OE is queued into a workqueue.
>  |
>  |- btrfs_buffered_write()
>  |- btrfs_fdatawrite_range()
>     |- cow_file_range()
>        |- btrfs_alloc_ordered_extent()
>           If the previous OE is not yet removed, a conflicting OE
>           will be inserted and trigger a panic.
>
> Fix it by calling btrfs_wait_ordered_range() before buffered writes.

No, this should not be needed, we already wait for ordered extents elsewher=
e:

btrfs_buffered_write() -> copy_one_range() ->
lock_and_cleanup_extent_if_need() -> lock_and_cleanup_extent_if_need()

Was this a theoretical fix or did you actually find this happening in pract=
ice?

>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/direct-io.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index c97396ca476d..8efe3a722206 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -1025,6 +1025,16 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, str=
uct iov_iter *from)
>         }
>
>         pos =3D iocb->ki_pos;
> +       /*
> +        * Direct writes may have created an OE, then submitted nothing.
> +        * Although iomap_end() should have marked the OE as finished, it=
's
> +        * not yet removed from io-tree.
> +        * Thus we have to wait for them to be removed.
> +        */
> +       ret =3D btrfs_wait_ordered_range(BTRFS_I(inode), pos, iov_iter_co=
unt(from));
> +       if (ret < 0)
> +               goto out;
> +
>         written_buffered =3D btrfs_buffered_write(iocb, from);
>         if (written_buffered < 0) {
>                 ret =3D written_buffered;
> --
> 2.54.0
>
>
