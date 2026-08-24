Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6286738B135
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 20:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787602489; cv=none; b=axYgUw/A1053cdE3ckn5OvRt9oIZ0HmTefAeKZ+hdwWC8w/tDk+N7pc9vQJZVd5iaZPUoBT6LjPp8lHuuaXmE4qa8SqEqn8qZcZ+D9mCKy59bCgR3OcNzuilDjbiQ55Q1xuGx4iJS6mLw29Z8jZnMcoTKYmN5RkJw+UeHXruA9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787602489; c=relaxed/simple;
	bh=Je1SsfqOrHg+6/5GNQ7ooeks+40covW1zMWcLF81EHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UKCclcmyL95MIhANLmG2KcwDukfRvYPFITmMbhwnd7/7luEktXMcwb/cJcmx73FRkvqzPNCJTTPahEZGbltgnbdoUE+H8EzAotWAVLtrSbCYwo1jNqzcSinRHi02RLMHvMec12kKl744Rdeu1MyJmL4BdqOJf/f67UZ1P9ACVvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mv/uGDnN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mv/uGDnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1935C1F00AC4
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 20:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787602488;
	bh=L204L1ClcHSyVEfXLI6ykFv6RPcybXCIuBUEQvwiQso=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mv/uGDnNG6kiRSZCjsiABGzxQjFHLPoQekuLzFVgRv7We/H5I9ouO/n/sNzDF1r7k
	 srhEkt84yRXPdyRLTQ0WOzai6NhhuK1fOVTxWXgbo6xeyuJglZ5/77oP0JMiUS+661
	 vd7Oet4+QYCzWGYQR7a8cAaHxPd0EXE/70u1eojJ6w3JBtQCsXZg8R4yufc5p90Q9P
	 7Njrp4Y1GpWOHQFreDAtx9b5qcfByodXmrf9r5TIgANkpmpbcmmFSqYvnVIAcL9VzP
	 rbIgXk5gf6VkJJzuq8EMDRkMZqzdG9zc2B9+ZNbHoqcBYb/dKIxLjPUWIRGaczeNlm
	 UoZQkqGlSnFzg==
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-74ad03fa605so2179761137.0
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 13:14:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoR2h6vPv5UCugV0ff6yvRQCVm/HB6YFUBRTj1F+pE6vmrfIjNbJwLoHkpshJyGhqWHkwxLdWeOIXQZqw==@vger.kernel.org
X-Gm-Message-State: AFuF++nHYXGEjJvMYTJC0WsGya61MkoGk72JI52aqW62MzOy9BkCWMii
	TtgX0lr4Sd9xmzJqwzZcFa4/doK3dtatK9lOvDh/23kJodPYZIGgQzSYe7ZWV82aLW0jDhT4d7e
	1qgRQFh7fINACOj6bUdckd1FKT9duhjY=
X-Received: by 2002:a05:6102:8098:b0:77f:a253:862c with SMTP id
 ada2fe7eead31-77fa253afdbmr1599092137.12.1787602487252; Mon, 24 Aug 2026
 13:14:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824-b4-btrfs-em-shrinker-v2-1-a6fc80447e70@debian.org>
In-Reply-To: <20260824-b4-btrfs-em-shrinker-v2-1-a6fc80447e70@debian.org>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 24 Aug 2026 21:14:10 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4OC_UqJCEo-o=uNSwZsCPJPuw8062_Mv+5NPaVqPJfsQ@mail.gmail.com>
X-Gm-Features: AcwNN1VVp8r7M_YRqNUzXUA1g1LRCbESt6cQtUtGnl6OHZYgPLIDFVuBJFMfNdY
Message-ID: <CAL3q7H4OC_UqJCEo-o=uNSwZsCPJPuw8062_Mv+5NPaVqPJfsQ@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: skip the extent map tree lock for inodes
 without extent maps
To: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, fdmanana@suse.com, boris@bur.io, 
	wqu@suse.com, layton@kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 12:59=E2=80=AFPM Breno Leitao <leitao@debian.org> w=
rote:
>
> find_first_inode_to_shrink() takes inode->extent_tree.lock in write mode
> on every inode it walks, only to find out whether that inode has any
> extent maps. Most inodes have none, so the lock is taken and dropped
> again without any work being done.
>
> Check whether the tree is empty before taking the lock. tree->root is
> only modified with the tree lock held for write, so the unlocked read is
> a harmless race: a false empty just defers the inode to a later scan,
> which already happens whenever the write_trylock() below fails, and a
> false non-empty falls through to the existing check under the lock.
>
> Across the Meta production fleet the extent map shrinker is ~0.35% of
> non-idle kernel CPU. Attributing callees to their caller,
> find_first_inode_to_shrink() is ~65% of that, and the write_trylock() it
> does is ~30% of the whole shrinker.
>
> Micro benchmark: a 6 GiB btrfs on a loop device, 100000 empty files kept
> open, plus 200 1 MiB files created last so they get the highest inode
> numbers and every scan has to walk all the empty ones first. Each round
> drops the page cache, re-reads the data files to recreate the extent
> maps, then triggers the shrinker with "echo 2 > /proc/sys/vm/drop_caches"=
.
> 15 rounds per run on arm64 (Neoverse V2), 8 CPUs, no lock debugging.
> Cost of find_first_inode_to_shrink() from the ftrace function profiler,
> in ns per inode walked, median of runs:
>
>                           base   patched    delta
>     idle                  46.4      40.1   -13.6%
>     4 concurrent readers  47.8      38.4   -19.7%
>
> A separate build with CONFIG_LOCK_STAT, same test, for the extent map
> tree rwlock. The shrinker is not the only user of that lock, every
> extent map insert and lookup takes it too, which is why the acquisition
> count drops by two thirds rather than to nothing:
>
>                               base   patched    delta
>     write acquisitions      628016    228000   -63.7%
>     hold time total (us)     47512     22717   -52.2%
>     acq cacheline bounces     1574      1288   -18.2%
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

The current subject:

"btrfs: skip the extent map tree lock for inodes without extent maps"

It is a bit too generic, giving no clue that it concerns the shrinker.
If you agree, I'll change it to:

"btrfs: skip extent tree lock in the shrinker for inodes without extent map=
s"

Thanks.

> ---
> Changes in v2:
> - Better justification for the patch.
> - Mark this unlocked read as racy
> - use the proper RB_EMPTY_ROOT() primitive
> - Link to v1: https://patch.msgid.link/20260821-b4-btrfs-em-shrinker-v1-1=
-286f3fb15873@debian.org
> ---
>  fs/btrfs/extent_map.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index 6ad7b39ae358b..86d9c6f5ff4bd 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -1219,6 +1219,14 @@ static struct btrfs_inode *find_first_inode_to_shr=
ink(struct btrfs_root *root,
>
>                 tree =3D &inode->extent_tree;
>
> +               /*
> +                * Most inodes have no extent maps, so check without the =
lock.
> +                * The race is harmless: a false empty just defers the in=
ode to
> +                * a later scan, and a false non-empty is caught under th=
e lock.
> +                */
> +               if (data_race(RB_EMPTY_ROOT(&tree->root)))
> +                       goto next;
> +
>                 /*
>                  * We want to be fast so if the lock is busy we don't wan=
t to
>                  * spend time waiting for it (some task is about to do IO=
 for
>
> ---
> base-commit: 6a746cd265aed59107ebdaa9ce039bb832922969
> change-id: 20260820-b4-btrfs-em-shrinker-7382d7f0dd05
>
> Best regards,
> --
> Breno Leitao <leitao@debian.org>
>
>
