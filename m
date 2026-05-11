Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D092D97B9
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 18:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778524620; cv=none; b=IntKagiPYEz10qLKZlvFXuwKN6CZ4VwGekoXsBi7OCk0r90mHBQUESsIV5pkD0ajNKzsPo8SBqMU5uYXWFYgt5+CCCSLRdzyhUQkuK/Ie01lvUoegYMLALkR/zLAxvAh9r1NxTZaCIO2oLFTVzWJXfwBpApc1uwe4NY0wRNWCuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778524620; c=relaxed/simple;
	bh=wNEgdHhfVeUnIkKrO8aOZzLTB0Som4tMGODndJ15oJY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PZMh7CO504+KAhK7bpV1WIB/CZXxLnUJUeK/tfoaWd3zYylDm15KxyO507RX7dqntvW6sHzNE4RPsFHdrdNd7fESUc43sRO4tnHDI7ch6sZL+pI1oZDZ96caX1pFrWRDHWCglYaizRLpddMJImIZd2UtynngZJnw0rr7mNeiyfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pphXe+Ak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pphXe+Ak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD9AC2BCB0
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 18:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778524619;
	bh=wNEgdHhfVeUnIkKrO8aOZzLTB0Som4tMGODndJ15oJY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pphXe+AkvayBaYPJab/v/tfVBQJ54gv6eM0he9p0jfQcIInjFd1s4vxBNgxdtNwHF
	 f0WjwRmn5iUkiSpyV3uL+fx9fF5qIpIjhfia1jvYP5C79Q81fvRgIBxyx8YdhIjaKu
	 JdMv97Aj+TTBhi4U5zqyiq2+Qp+0Kae03bMnQ2T+e1eb0B0t62hdPe1mDxs+Wb7gkP
	 fGGNwQKN6gT8VeZsLQP4x92Fp+CGAHXjtTYSOeCAngTFx5Rwbhh/zTGsoFHOtijEwx
	 7qksdkkRICWul+YVYX8bKCGJaxEt0490FkaON2kNze7oI/NF4Hq0CGu/Hd+aKzDMWJ
	 Hlnef+gcOjJCw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bcff2d08ca8so185157666b.3
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 11:36:59 -0700 (PDT)
X-Gm-Message-State: AOJu0YwbxX6yuO4BGh0Q0bJ1J01HlJnh9SKddckfA2i22gSj8NXdpSgH
	g6mHtvZWi33/MiGF3h6LO0zIjdN9gma41rbe0xHpBWpD/g7/rrrqDGhwoKa0mWGVKUGFm7D5byk
	m0lMw+AQjhoA3NgOpgIWo5dR3b1NXDgE=
X-Received: by 2002:a17:907:972a:b0:bcc:2f39:7def with SMTP id
 a640c23a62f3a-bcc2f397e3amr597406266b.5.1778524618526; Mon, 11 May 2026
 11:36:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c02edfd2e71891c095d0b70e530f41ed3d97a874.1778523510.git.boris@bur.io>
In-Reply-To: <c02edfd2e71891c095d0b70e530f41ed3d97a874.1778523510.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 11 May 2026 19:36:21 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6CiZ3Bh84E7onsOjx_FDLz-m=rx7ix2CVbSM7G-j4ZLw@mail.gmail.com>
X-Gm-Features: AVHnY4JYR1Qu1onzAgWr3cgFMmr5mVRir3WK_zAa2kZdaJ2lFB8aRVUaXJihDd8
Message-ID: <CAL3q7H6CiZ3Bh84E7onsOjx_FDLz-m=rx7ix2CVbSM7G-j4ZLw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: always drop root->inodes lock before cond_resched()
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 11, 2026 at 7:24=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> find_first_inode() and find_first_inode_to_shrink() lock root->inodes,
> then loop over them, occasionally skipping some inodes. When they skip
> an inode, they attempt to share the cpu/lock with cond_resched_lock().
>
> However, that has a subtle problem associated with it.
> cond_resched_lock() only drops the lock if it needs to actually call
> schedule(). With CONFIG_PREEMPT_NONE, this means the full timeslice as
> detected at ticks. With 8+ cpus and default tunables, this is 2.8ms. So
> regardless of HZ, we will run for at least 2.8ms in this loop without
> dropping the lock, assuming it finds no suitable inodes. If HZ is
> small enough, it might be even worse as the tick granularity becomes
> bigger than the timeslice.
>
> The knock-on effect of this is that callers to
> btrfs_del_inode_from_root() like kswapd trying to shrink the inode slab
> or userspace threads calling evict() will spin on xa_lock(&root->inodes)
> for 2.8ms, so the extent map shrinker dominates the lock even though
> ostensibly it is intending to share it. This produces memory pressure as
> there is only one kswapd and it runs sequentially so it can get stuck in
> the inode slab shrinking.
>
> To fix it, simply replace cond_resched_lock() with an open coded variant
> which unconditionally does unlock/lock around cond_resched. Sharing the
> lock is decoupled from sharing the cpu, and all the users of the lock
> now share it fairly.
>
> I was able to reproduce this on test systems by producing a lot of empty
> files (to make a big root->inodes xarray), then producing memory
> pressure by reading large files larger than ram, triggering kswapd and
> the extent_map shrinker. The lock contention is visible with perf or
> lockstat. This patch also relieved a user-apparent bottleneck on a
> production system from the original report.
>
> Tested-by: Rik van Riel <riel@surriel.com>
> Signed-off-by: Boris Burkov <boris@bur.io>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
> Changelog:
> v2:
> - apply the pattern to btrfs_find_first_inode() as well.
>
> ---
>  fs/btrfs/extent_map.c | 4 +++-
>  fs/btrfs/inode.c      | 4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index 514d7b59cbe5..fce9c5cc0122 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -1246,7 +1246,9 @@ static struct btrfs_inode *find_first_inode_to_shri=
nk(struct btrfs_root *root,
>                 write_unlock(&tree->lock);
>  next:
>                 from =3D btrfs_ino(inode) + 1;
> -               cond_resched_lock(&root->inodes.xa_lock);
> +               xa_unlock(&root->inodes);
> +               cond_resched();
> +               xa_lock(&root->inodes);
>         }
>         xa_unlock(&root->inodes);
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 0e72408c8612..201010ced09d 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -10540,7 +10540,9 @@ struct btrfs_inode *btrfs_find_first_inode(struct=
 btrfs_root *root, u64 min_ino)
>                         break;
>
>                 from =3D btrfs_ino(inode) + 1;
> -               cond_resched_lock(&root->inodes.xa_lock);
> +               xa_unlock(&root->inodes);
> +               cond_resched();
> +               xa_lock(&root->inodes);
>         }
>         xa_unlock(&root->inodes);
>
> --
> 2.54.0
>
>
