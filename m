Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB7441D139
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 16:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785168299; cv=none; b=O9+e1DGRkS39oYqM5zNCA+D3D4RnNcA8Bf0g7JaaGTbQKYgNWgKeAa5KdoxJ+x7TbmoodifrMiIyWuPKg6MItuLoueDEq5ztyy84fF6qERk43MFnnyflmh8J+wPk27pJkEGaIZRG5RlkPpxOiyNcTJFkt5N/xIlJj6UMGjHBLXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785168299; c=relaxed/simple;
	bh=W0BlL1wqbf3+/VeHuTNPOgFjkDU2URWKrcur84PNYc8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SixuL+SpPB0lT+Mxiz/hZf0pIEYe/O5kxnMuPyTcGzycoKWF3px+VumpwpiEbzJjzV/g2Vr/rviSj6mcCjsg88BGju+skR9Pg5rlhhuvJ79pMkbZaxWc2RkbSm3xWgyFVwVNuVvrcHtByjUPrhiaZr1dqpMHA/Hd6FohexyQAU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNFe4r3k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNFe4r3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7321F00A3A
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 16:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785168298;
	bh=mL5BHW0Isa5RyCN9mBkx1g/7K/F8cN2NK7KBf3uG9u8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mNFe4r3kA6OgShDdgtGiYBrHWPaiWgY4Xuc0d9JFNnIPjrS6HAKPE9VJo4LdeKauW
	 iQUWWQkI6SrXH3noFyQCmS08g55KO7es+kYbZHAaRZoRwoo+L6ny9ua5uOOPdRFiLw
	 7CZ5t/rKi3csI2XpBfImtPN91QrJo903VmqIaEuMbcEH7muQvlWxHjY1HwAty4fJXZ
	 orD7GHJ4iD3+QEL7mtWySCG3RZbfIkeoV6pJoTCWauBpf23kWU2J4tdxVZg09NQ4c5
	 yH+nWcXB08c28p1RnYJrki0MoJqJRAXamsPqRogyam6vhBMwEoJk8sjzUC/Uq6HHrp
	 wbrzkbm3Jvtjw==
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5bf9466412fso1830327e0c.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 09:04:57 -0700 (PDT)
X-Gm-Message-State: AOJu0YzQm4oAuawJqcKVIXS32bRSIVMdPiUfJ7/B8oFveqtXMGSbItFJ
	GQ5PkEnqydiNeAV3xEXcwM2bA0yMgUq56XspxDyXPIiuLSp45omh/oUFzlajYPybV8f78Z7GV0n
	hZi9CeGp76MczKbS0w+RZOaxO7mgXzWM=
X-Received: by 2002:a05:6122:548:b0:5bd:bcb1:453b with SMTP id
 71dfb90a1353d-5c306d2120cmr4279032e0c.10.1785168297169; Mon, 27 Jul 2026
 09:04:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1784673567.git.boris@bur.io>
In-Reply-To: <cover.1784673567.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 27 Jul 2026 17:04:21 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5w=nZD=ZrP4CEeOLZ+hK=VCSOAihHfXWggGcYM47cq5g@mail.gmail.com>
X-Gm-Features: AUfX_mxW6y5ndS7tzDw8Ts2849fEfw1u_a4pojFfLz8n3hnDBCuGa9LYrFft4bw
Message-ID: <CAL3q7H5w=nZD=ZrP4CEeOLZ+hK=VCSOAihHfXWggGcYM47cq5g@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] allocate extent_buffer GFP_NOFAIL with unlocked retry
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 3:04=E2=80=AFAM Boris Burkov <boris@bur.io> wrote:
>
> From sampled fleet data measuring lock holders that go into direct
> reclaim with a waiter present when they eventually unlock, we have
> observed ~15% of those are btrfs extent_buffer allocations in
> btrfs_search_slot() done while holding btree locks. This is the single
> largest category. Additionally, a large source of hung_task timeouts is
> both btree waiters and direct reclaiming btree allocations, which
> further motivates the desire to drive down this source of stalls and
> contention.
>
> The aim of this series is to allow us to allocate the extent_buffer,
> btrfs_folio_state, and the extent_buffer folios with GFP_NOWAIT then
> fallback with EAGAIN to outside the critical section to retry with
> GFP_NOFS | GFP_NOFAIL without any locks held.
>
> This is analogous to how we must drop locks to read an extent_buffer and
> then EAGAIN.
>
> The series does not manage to completely eliminate allocations from this
> lock holding path, as we also allocate inside xarray functions for the
> extent_buffer xarray and the btree_inode mapping xarray, the latter of
> which is done via filemap_add_folio() with no reserve type API. Luckily,
> those particular allocations are small cached slab allocations and have
> nearly no contribution to the production reclaim fueled contention.
>
> Changelog:
> v2:
> - rebase
> - dropped the inhibit array allocation patch
>
>
> Boris Burkov (4):
>   btrfs: factor init_extent_buffer from __alloc_extent_buffer
>   btrfs: add struct btrfs_eb_prealloc
>   btrfs: enable unlocked NOFAIL retry for eb allocations
>   btrfs: use GFP_NOWAIT for tree block readahead

Apart from the comments left in the second patch:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>
>  fs/btrfs/ctree.c       |  36 ++++++-
>  fs/btrfs/disk-io.c     |   6 +-
>  fs/btrfs/disk-io.h     |   2 +
>  fs/btrfs/extent-tree.c |   6 +-
>  fs/btrfs/extent_io.c   | 213 ++++++++++++++++++++++++++++-------------
>  fs/btrfs/extent_io.h   |  23 +++++
>  fs/btrfs/subpage.c     |   7 +-
>  fs/btrfs/subpage.h     |   3 +-
>  fs/btrfs/tree-log.c    |   3 +-
>  9 files changed, 220 insertions(+), 79 deletions(-)
>
> --
> 2.55.0
>
>
