Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794419917;
	b=3zGynqpYMwpZLpBjaHmdPmmD/ULzVF+Zv3c4PU0UV/H5E6vSPh/b/Nv1O2Gw2iPsheSH
	 pOFmwVTW4w9cdQVHKq3yOfLHRCj8OZEGJAOfyeVh0tR1TUAoQtsIvOg++KiiqNxUG+kJq
	 hnbEXaLhvlybGv2y+bR4iCcRkN0BXTg8CRqEUChVJym3Kn2z891PVfKFNK2XwTYxw1kp7
	 +85wf34Odqy2cZYSmLAyNdWjgywFKF4W7DdDbExodBGAJI5zJqreyTaA0+0EE1rpqLbdr
	 4vwfxW82zqmCK2oa87LgbDoxyyrV5MMUA3v2eiUp5wM6o9MQegAVgyKtOb9zRQcc7Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794419917;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=45oiK5Uovs91ezmf98ECIxhFeJ06uJno3Y2TbfBMJ68=;
	b=by6+eJxd+3NCSr3inu9VPNpVBXOF2FqUIpJlD0DkMjI1bfi7seZAPhTQWPAWytuTrG6M
	 6bZrIT40BWBJcVCyjjTr4NL1O5xJds8RaJqFn9z0BGF4ZpqbarHP07CJRd5rDqoVijE6H
	 6BKOwJUjQDj/cUoDtEuGlLjsU+k9sbmSxhK27u4GrYQcTv7xK0hnmkrDlZCfENrFF5Z2j
	 8XHuukHGAWHtXGeJ4RTgMQ8r6QMPmATVYu4QgglEPDQGkGr0ZkyFNicMmo6tN/uKxRRB6
	 WGrEf4ZmHnXDk+E7zt7d0YEOk3YNs2lY3hdMYPpe2WfdmBM+NPwy9RJ7cIZvQZYgU1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S1o2yzo+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5BD606A896
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2026 17:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S1o2yzo+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966CC1F00A07
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2026 17:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794419916;
	bh=45oiK5Uovs91ezmf98ECIxhFeJ06uJno3Y2TbfBMJ68=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=S1o2yzo+RnXVY75Kz++nRoxtF4Vfy8X2UNW5StBp9SQFi4nIUV3zgrn3RWQQcNPDW
	 ut6amV0lG5woDDOPWsc4QUct34tl7oGhQiBjvMC344MMrwYWZnu5j2lUS5thQWDCP2
	 iOUdtDP1Xmkt4DOAA5D3VTfGTwDBhrZckdMEZAqkeUNCF8uhJwCMDpQaOpxnp+6KGt
	 7YPubbS6jUBe/vapK3RBRWHPwZ1oLMkxXNgY4MVGl8RUPErxA024QniwDTECQsrWYg
	 Q8Za3sA8y/RXMZpSYwBasqraMcJo2haGpYe3YmoankgSb64ukzWSanZhTLf6ghkLfr
	 aR48YI6+RBQvA==
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-98c7798ce74so928236241.1
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2026 09:58:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErE+k+IMeSYolJd5EnUiRH8/IE7+mWBPHh6deVPoALqPLbQ4/5t5BYp8Rtfz+e7xY8gXiUprtv7tOjeI9g==@vger.kernel.org
X-Gm-Message-State: APuU4Z8/0NH7ok2GZ+bb/onF3ltEt4gpiK9kRe/qwjWa8M7qIEIY8vLA
	+FkUPnivPngtmp1cgTz0BrARDsRSeJtQR4DOgCRcZu7Tp/towNHuTraU4c8grBd9yxvmr+rz5D9
	9j8jRrb7h3eazpPsPLyVqdkL6GvYGwR4=
X-Received: by 2002:a05:6102:f88:b0:7cc:2712:cafb with SMTP id
 ada2fe7eead31-7d4fb294ca9mr1167666137.15.1794419915738; Wed, 11 Nov 2026
 09:58:35 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111124152.546406-1-joseph.qi@linux.alibaba.com>
In-Reply-To: <20261111124152.546406-1-joseph.qi@linux.alibaba.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 11 Nov 2026 17:57:59 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5YSfxCVRTkmdc=W0UpWU10h=+dafiL0++jyzGwgQPy5g@mail.gmail.com>
X-Gm-Features: AclHuK9up2bHAWsxlv1bUqwiFajrzfaKA8whphnS9xlAkaR64tJ_1QWH2kLi-NI
Message-ID: <CAL3q7H5YSfxCVRTkmdc=W0UpWU10h=+dafiL0++jyzGwgQPy5g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: don't wait for ordered extents in nowait buffered writes
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 12:58=E2=80=AFPM Joseph Qi <joseph.qi@linux.alibaba=
.com> wrote:
>
> lock_and_cleanup_extent() honours @nowait when taking the extent lock,
> but then waits for an overlapping ordered extent regardless of it:
>
>   btrfs_start_ordered_extent()
>     wait_event(entry->wait, BTRFS_ORDERED_COMPLETE)
>
> BTRFS_ORDERED_COMPLETE is only set by btrfs_remove_ordered_extent(),
> which runs from the ordered extent completion work, so this sleeps
> uninterruptibly until that work gets to run, and it starts a
> transaction.  A pwritev2(RWF_NOWAIT) buffered write must not block like
> that.
>
> This used to be limited to writes starting below i_size, because the
> ordered extent lookup was guarded by a start_pos < i_size test.  Commit
> ec78575dde99 ("btrfs: always wait for ordered extents to avoid OE races")
> dropped that guard so that appends also wait for the ordered extent left
> behind by a short direct write whose i_size was reverted, which made the
> wait, and the blocking with it, unconditional.
>
> btrfs_write_check() rejects a NOWAIT write with -EAGAIN unless the inode
> has BTRFS_INODE_NODATACOW or BTRFS_INODE_PREALLOC, so the inode has to
> have one of those: a chattr +C file, a preallocated file, or a nodatacow
> mount.  Those are the usual setups for database files and VM images,
> which is also where NOWAIT writes get used.
>
> Given such an inode, an append write does reach the wait.  With i_size S
> and a direct write of L bytes of which only W get submitted:
>
>   task A: O_DIRECT append, short write  task B: pwritev2(RWF_NOWAIT) appe=
nd
>   ------------------------------------  ---------------------------------=
--
>   btrfs_split_ordered_extent() gives
>   the submitted part [S, S+W) its own
>   OE, so dio_data->ordered is left
>   covering [S+W, S+L)
>   btrfs_dio_iomap_end():
>     i_size_write(max(S, S+W))
>       <- i_size reverted
>     btrfs_mark_ordered_extent_truncated()
>     btrfs_finish_ordered_extent()
>       btrfs_queue_ordered_fn()
>         -> endio_write_workers
>       <- the OE is still in the tree
>   iomap_dio_complete()
>   btrfs_inode_unlock()
>                                         btrfs_buffered_write() at S+W
>                                           btrfs_inode_lock(BTRFS_ILOCK_TR=
Y)
>                                             <- succeeds, A dropped it
>                                           btrfs_write_check()
>                                             <- passes
>                                           copy_one_range()
>                                             lock_and_cleanup_extent()
>                                               btrfs_try_lock_extent()
>                                                 <- succeeds
>                                               btrfs_lookup_ordered_range(=
)
>                                                 <- finds A's [S+W, S+L)
>                                               btrfs_start_ordered_extent(=
)
>                                                 wait_event()
>                                                   <- blocks here
>   endio_write_workers eventually runs
>   finish_ordered_fn()
>     btrfs_finish_ordered_io()
>       btrfs_remove_ordered_extent()
>         <- sets BTRFS_ORDERED_COMPLETE,
>            B finally wakes up
>                                         -EAGAIN propagates back through
>                                         copy_one_range() to userspace
>
> Because i_size was reverted to S+W, start_pos equals i_size, which is
> exactly the case the dropped start_pos < i_size guard used to skip.
>
> Return -EAGAIN without starting the ordered extent instead.
> copy_one_range() passes that straight back and btrfs_buffered_write()
> returns it to userspace when nothing was written yet, so a nowait caller
> retries from a blocking context without IOCB_NOWAIT and takes the
> waiting branch then.  btrfs_try_lock_ordered_range(), which
> btrfs_check_nocow_lock() uses for the same purpose, already behaves this
> way.
>
> Fixes: ec78575dde99 ("btrfs: always wait for ordered extents to avoid OE =
races")
> Cc: stable@vger.kernel.org
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Pushed it to the for-next branch on github, thanks.

> ---
>  fs/btrfs/file.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index f978c6524aa03..e84e9e129169e 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -916,7 +916,14 @@ lock_and_cleanup_extent(struct btrfs_inode *inode, s=
truct folio *folio,
>                                     cached_state);
>                 folio_unlock(folio);
>                 folio_put(folio);
> -               btrfs_start_ordered_extent(ordered);
> +               /*
> +                * Waiting for the ordered extent blocks uninterruptibly,=
 which
> +                * a nowait caller must not do.  Leave it alone and let t=
he
> +                * caller retry where blocking is acceptable, like
> +                * btrfs_try_lock_ordered_range() does.
> +                */
> +               if (!nowait)
> +                       btrfs_start_ordered_extent(ordered);
>                 btrfs_put_ordered_extent(ordered);
>                 return -EAGAIN;
>         }
> --
> 2.39.3
>
>
