Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794304184;
	b=NXWgzHcNEumw2YB5/gKrqNdg08RggZ333T+Q4ne2pFP3q8mzEg1R8mFSOh/SthGQOjWF
	 LyIMRVT696egUCQVf/Vw7ivkmp4JLsK4zoHm0gXoP/GYoX8qLJIdmA+WoHfX/GMkzhu6G
	 Oy9xXwrAHgjRbrfRYIwE0X1GHQMv3oSPTawSOg2NQY411JryRCpk9Se7+mjK0Lc32+AZO
	 H4Dl3hlFmYbypGO8mqUE/rffjt32pFLYtAuX32/0nc0gDnjxBvdeox06LKgPC3+luoVpY
	 LVAb8GRt0etumXyRxeWSsWgGikLpQcO5fHlwA2aOA77F7keMO/fN0sy4u/wyKOLUMEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794304184;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=oNfUXd2xnmUZCki7dWgTDcG4rfZ3klzhlFljaWY6ARA=;
	b=YJxaSrUenU9CWon2cZCwNTdJzNmBmqcFFJj5m2TXB846134OuDqblj2OS/g/TYWoGq3e
	 4h/FFKXcvayGaattn3tDI1RC9KzhWasgUQhUw2kNuSrrDa99Pies2IrIHkB13IAoqCWYu
	 o68Sil8ZCQCmjsSPSZPUrj4aXfjDRzE5lmjMW7br2Eg95wHTZLzd/CpOieO5eCb4rmtGC
	 VzGZb+BB28Cq/H1Pv5hS6lSEHcFjuCcXaHeczw62URlVEqSUXenrkZ6Jy0LQEhANCvWqs
	 kmYPivKhYhnVoveOpAlLo/TJL6IQ6Wo9fgQ9cNoTdkZxOuOHFbFReCQ0X94TevCpaOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xinw6iOr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBE4606B9CD
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 09:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xinw6iOr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CE41F0089F
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 09:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794304183;
	bh=oNfUXd2xnmUZCki7dWgTDcG4rfZ3klzhlFljaWY6ARA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Xinw6iOraNhlUHyN+ZDlz3aNzClOt0gSNXyVWxfnhh7VNTkq4tBe0MXgiU5o6qILf
	 gsb3rGm2qllXims3qQ6232VGAXjFnRuHt8BavkpyEG8mzIq3Ha7AoPIsshLsMaOqQi
	 QvFhmeTTOnwkyzpBV5akkwCHJHv5vqBNGIg/X/y60mM+1ukHKL1JKglqPoAX72x4++
	 rA99SzRSVRJgOBzyygTphJw7KhlArZonHnmDzwBmcFxuE05qZsfcWcfXUW79L1W5IH
	 CeXgxHqIBRJg4DQePX2gYOL2xE9j6TCnhzdjkzMW4W+Yb8RMJ7f92vx52qjH3PhDzK
	 vZXYsDpx1ePfQ==
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-74ab99038afso1604891137.3
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 01:49:43 -0800 (PST)
X-Gm-Message-State: APuU4Z8Boqe3hTdKywMpJ+pK8lYrZJkN5THVJKuaUduOoFBvwrys0N2q
	7vArSnv98dMWPEtuqMeKViREKSSv+O3ZqF5roglURIefsYYN65P8A4pU1i3cgrDiKTH40B2Z/BK
	4TeAkj7Kld0u3IgWOIIZ+6XaYM8lqqW8=
X-Received: by 2002:a05:6102:fa0:b0:7d2:8dd0:2ed with SMTP id
 ada2fe7eead31-7d301baca4fmr655976137.10.1794304182804; Tue, 10 Nov 2026
 01:49:42 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <93ad6002c98614b7a35c87b2792bce8dadb1e6b2.1794300081.git.wqu@suse.com>
In-Reply-To: <93ad6002c98614b7a35c87b2792bce8dadb1e6b2.1794300081.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 10 Nov 2026 09:49:06 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6JQk7X0Y-BtJmUHp+qhEMFYB=1=qxYkCihXVpcFGBPtg@mail.gmail.com>
X-Gm-Features: AclHuK_eOFFYNPTQ3PturQ-WA5XRfH4SjjPYZPcyWkKD-7rHQ6mLPimFZfSqAOE
Message-ID: <CAL3q7H6JQk7X0Y-BtJmUHp+qhEMFYB=1=qxYkCihXVpcFGBPtg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: set write error flags before clearing writeback on
 failed buffered writes
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 8:43=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [BUG]
> After commit f13e01b89daf ("btrfs: ensure fast fsync waits for ordered
> extents after a write failure"), a failed COW write sets the inode's
> BTRFS_INODE_COW_WRITE_ERROR flag.
>
> That flag makes the next fast fsync wait for ordered extents to complete,
> so that it never logs the failed extents.
>
> However for buffered writes the flag can be set too late, and a fast
> fsync can still log file extent items for the failed write.
>
> [CAUSE]
> In end_bbio_data_write() the folios' writeback is cleared before the erro=
r
> is recorded:
>
>  CPU0 (endio, failed buffered bio)  CPU1 (fast fsync)
>  end_bbio_data_write()
>  |-btrfs_folio_clear_writeback()
>  | ^^^ wakes up the fsync           btrfs_sync_file()
>  |                                  |-filemap_fdatawait_range()
>  |                                  | ^^^ Returns after the writeback
>  |                                  | finished
>  |                                  |
>  |                                  |-test_and_clear_bit(COW_WRITE_ERROR)
>  |                                  | ^^^ Still 0, skips
>  |                                  |     btrfs_wait_ordered_range()
>  |                                  |
>  |                                  \-btrfs_log_changed_extents()
>  |                                    ^^^ logs the extent maps of the
>  |                                        failed ordered extent
>  |-mapping_set_error()
>  \-btrfs_finish_ordered_extent()
>    \-set_bit(COW_WRITE_ERROR)
>      ^^^ Too late.
>
> A power loss after the log tree is persisted makes log replay point the
> file to blocks that didn't receive its data.
>
> The mapping error is recorded late too, so the fsync can miss it as well.
>
> [FIX]
> Record the error before anything a fast fsync can wait for.
>
> Introduce btrfs_ordered_extent_io_failed(), which marks the ordered
> extent with BTRFS_ORDERED_IOERR, sets the mapping error and sets
> BTRFS_INODE_COW_WRITE_ERROR for COW ordered extents.
>
> Call it from end_bbio_data_write() before clearing writeback, along with
> mapping_set_error() with the real error code.
>
> Also call it from btrfs_finish_ordered_extent() before
> can_finish_ordered_extent(), which sets BTRFS_ORDERED_IO_DONE, so that th=
e
> flag is also visible to anyone woken up by IO_DONE.
> Compressed writes already finish the ordered extent before clearing
> writeback and are not affected.
>
> Assisted-by: LLM (exposing the bug and coding)
> Fixes: f13e01b89daf ("btrfs: ensure fast fsync waits for ordered extents =
after a write failure")

If you look at when that commit was made, we cleared the writeback bit
from the folio after calling btrfs_finish_ordered_extent(), so all was
fine.
The commit that introduced the bug is:

a11d6912fdd9 ("btrfs: remove folio parameter from ordered io related functi=
ons")

And we already have an in-progress patch to solve this:

https://lore.kernel.org/linux-btrfs/20261103-b4-btrfs-data-integrity-v2-3-5=
77dc2690061@toxicpanda.com/


> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/extent_io.c    | 13 ++++++++++---
>  fs/btrfs/ordered-data.c | 40 +++++++++++++++++++++++++++++-----------
>  fs/btrfs/ordered-data.h |  1 +
>  3 files changed, 40 insertions(+), 14 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index b2739838c646..53fced2756b5 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -545,6 +545,16 @@ static void end_bbio_data_write(struct btrfs_bio *bb=
io)
>         u32 bio_size =3D 0;
>
>         ASSERT(!bio_flagged(bio, BIO_CLONED));
> +
> +       /*
> +        * Record the error before clearing writeback, as a fast fsync wa=
iting
> +        * for writeback checks the error right after being woken up.
> +        */
> +       if (error) {
> +               mapping_set_error(bbio->inode->vfs_inode.i_mapping, error=
);
> +               btrfs_ordered_extent_io_failed(bbio->ordered);
> +       }
> +
>         bio_for_each_folio_all(fi, bio) {
>                 struct folio *folio =3D fi.folio;
>                 u64 start =3D folio_pos(folio) + fi.offset;
> @@ -554,9 +564,6 @@ static void end_bbio_data_write(struct btrfs_bio *bbi=
o)
>                 btrfs_folio_clear_writeback(fs_info, folio, start, len);
>         }
>
> -       if (error)
> -               mapping_set_error(bbio->inode->vfs_inode.i_mapping, error=
);
> -
>         btrfs_finish_ordered_extent(bbio->ordered, bbio->file_offset, bio=
_size, !error);
>         bio_put(bio);
>  }
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index df74c75d6c29..0a851203e589 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -423,18 +423,18 @@ static void btrfs_queue_ordered_fn(struct btrfs_ord=
ered_extent *ordered)
>         btrfs_queue_work(fs_info->endio_write_workers, &ordered->work);
>  }
>
> -void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
> -                                u64 file_offset, u64 len, bool uptodate)
> +/*
> + * Record that the IO of @ordered failed.
> + *
> + * Must be called before anything a fast fsync can wait on is signaled: =
the
> + * writeback bit of the folios for buffered IO, or BTRFS_ORDERED_IO_DONE=
 for
> + * direct IO. Otherwise the fast fsync can miss the error.
> + */
> +void btrfs_ordered_extent_io_failed(struct btrfs_ordered_extent *ordered=
)
>  {
>         struct btrfs_inode *inode =3D ordered->inode;
> -       bool ret;
>
> -       trace_btrfs_finish_ordered_extent(inode, file_offset, len, uptoda=
te);
> -
> -       spin_lock(&inode->ordered_tree_lock);
> -       ret =3D can_finish_ordered_extent(ordered, file_offset, len,
> -                                       uptodate);
> -       spin_unlock(&inode->ordered_tree_lock);
> +       btrfs_mark_ordered_extent_error(ordered);
>
>         /*
>          * If this is a COW write it means we created new extent maps for=
 the
> @@ -442,7 +442,7 @@ void btrfs_finish_ordered_extent(struct btrfs_ordered=
_extent *ordered,
>          * before submitting a bio or during IO.
>          *
>          * We have marked the ordered extent with BTRFS_ORDERED_IOERR, an=
d we
> -        * are queuing its completion below. During completion, at
> +        * will queue its completion. During completion, at
>          * btrfs_finish_one_ordered(), we will drop the extent maps for t=
he
>          * unwritten extents.
>          *
> @@ -464,8 +464,26 @@ void btrfs_finish_ordered_extent(struct btrfs_ordere=
d_extent *ordered,
>          * Set a flag in the inode so that the next fast fsync will wait =
for
>          * ordered extents to complete before starting to log.
>          */
> -       if (!uptodate && !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
> +       if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
>                 set_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flag=
s);
> +}
> +
> +void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
> +                                u64 file_offset, u64 len, bool uptodate)
> +{
> +       struct btrfs_inode *inode =3D ordered->inode;
> +       bool ret;
> +
> +       trace_btrfs_finish_ordered_extent(inode, file_offset, len, uptoda=
te);
> +
> +       /* Must be done before BTRFS_ORDERED_IO_DONE can be set below. */
> +       if (!uptodate)
> +               btrfs_ordered_extent_io_failed(ordered);
> +
> +       spin_lock(&inode->ordered_tree_lock);
> +       ret =3D can_finish_ordered_extent(ordered, file_offset, len,
> +                                       uptodate);
> +       spin_unlock(&inode->ordered_tree_lock);
>
>         if (ret)
>                 btrfs_queue_ordered_fn(ordered);
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index 8d5d5ba1e02f..1bb8f9c8c472 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -226,6 +226,7 @@ bool btrfs_try_lock_ordered_range(struct btrfs_inode =
*inode, u64 start, u64 end,
>  struct btrfs_ordered_extent *btrfs_split_ordered_extent(
>                         struct btrfs_ordered_extent *ordered, u64 len);
>  void btrfs_mark_ordered_extent_error(struct btrfs_ordered_extent *ordere=
d);
> +void btrfs_ordered_extent_io_failed(struct btrfs_ordered_extent *ordered=
);
>  void btrfs_mark_ordered_extent_truncated(struct btrfs_ordered_extent *or=
dered,
>                                          u64 truncate_len);
>  int __init ordered_data_init(void);
> --
> 2.56.0
>
>
