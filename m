Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A4436D510
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 12:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778503065; cv=none; b=i65J+vsUWudG8y8GrYi5dPtN5pMwhDFu1CxWUmQtSpUJ2IaiwBzjJe+lLWKaRYmN01seUJSqRftZR3Vnf3+UejT1xRHh8Pf0NHM5K3wmIrPQw6YyW3ruUw5CAKhMLlbLIIE3fc35z75d8Z+TQ23suwZWGlHkMNkQYchONgd/vlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778503065; c=relaxed/simple;
	bh=WBgA+jlV8rM2kjCiCXH3s7tQ2NtovrNIyRVOsUP8eig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z3jypA08eAL2JBzUrrZigv5DNNVF4+32bYi8wYJyLIAJGxKhEbN3ipFjpza2KQM1kaVtdsGt8zlAyPRTyEE4a2/8cq4K5OuKY23/dOfhLk74pwJ6vpXQHBXR/wMvorrrvceMN1+EQjiSSY4DIqV8DIl3meRHZGLyNDdy6YNgDPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZDCmmdbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZDCmmdbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AFCC2BCF7
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 12:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778503064;
	bh=WBgA+jlV8rM2kjCiCXH3s7tQ2NtovrNIyRVOsUP8eig=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZDCmmdbg8RZembcofBwCvyQd5AOGWfdQ3kcHqxaVhphsrjYd9bS42Usdn9HF0H1M6
	 4Cspr92xjBjn3apQBE4Cu4c1eJMV2pPvYAhdD3wN3DmfCUmcJWVP0d3Qh457BPi4zT
	 OgWxsZyvjoX/yNRZZEpJeTkXWP2Zi4VUMgl+B1O1aMW5gcHyzYK+BQKO3SuDkUorh9
	 Q/BSgfD1BpEEZvRcfqr1Q+XCxKBeVvHpjT4t0+e4Hk3MKptShioBy3CL2lRQZ1uWGv
	 kScKZrLYvnWvcIXEXKeRFpmWBnZFzKEXUkhUT5DfE2XUCSyTXb+FCmZWQ6QdLhE6oq
	 0B4JVMPkdmGWA==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-67b32c695efso8517629a12.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 05:37:44 -0700 (PDT)
X-Gm-Message-State: AOJu0YxxJTc4WTPFoc5y5THd8aUKe/5VAfCh2X/+SR73iwVLYycHyvfu
	S04iCVLQnyYWkPF5TADPkGncIva0QEZry+1hcvlsUDcsNr/W5zYrGZoQbBZ8BNsdMbeLDI+E/nE
	6Pd4J1cwcYIm6UGz+XgmbHE+RdmAu5JA=
X-Received: by 2002:a17:907:d13:b0:bc1:1808:7fe1 with SMTP id
 a640c23a62f3a-bc85d2aef0bmr998846866b.21.1778503063480; Mon, 11 May 2026
 05:37:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2c932910eb227ef5e9829fdc86d10a11e3170a99.1778435133.git.boris@bur.io>
In-Reply-To: <2c932910eb227ef5e9829fdc86d10a11e3170a99.1778435133.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 11 May 2026 13:37:05 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7esm_4ATxg=VXqY9HtMFZZZ-Km24SEQJjNK1-o9EunMg@mail.gmail.com>
X-Gm-Features: AVHnY4KRJQuvtpoB-tDKTjDkgiTXPqBs3ZZuy4DhjCznPJ6qluVZHbJ93lXgTps
Message-ID: <CAL3q7H7esm_4ATxg=VXqY9HtMFZZZ-Km24SEQJjNK1-o9EunMg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: always drop root->inodes lock in find_first_inode_to_shrink()
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 10, 2026 at 6:46=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> find_first_inode_to_shrink() locks root->inodes, then loops over them,
> skipping those where it can't lock the extent_tree, or which have no
> extent_maps or it can't igrab. When it doesn't pick an inode, it
> attempts to share the cpu/lock with cond_resched_lock().
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
> ---
>  fs/btrfs/extent_map.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
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

We call cond_resched_lock() in other places, including
btrfs_find_first_inode(), which uses the same lock.
Why do that only here?

Thanks.


>         }
>         xa_unlock(&root->inodes);
>
> --
> 2.54.0
>
>
