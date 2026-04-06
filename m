Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BA738E5EB
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2026 18:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775498920; cv=none; b=KsSNpbRybFBTTiJKUUfJc+knhDX1EEuMMx0Fw9U/RmLUXPlAZ/XT1LcZg6uiPH1kyf0Mh8IR2HdJCqdf2trUvFgFwm7hBIBC1bbIOaONh0VT2xiGmjkSAPH59zsQBdT85QvkX2FgZKbbU2U9fTHWHRhOFJSNPsFiX5KOTPPAEsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775498920; c=relaxed/simple;
	bh=HgHqrCCbVUalxrJKRj2EAOKq3gwsFEsdePWpyCqf1gY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DkDmM69WpJktlvj4bW6viJpGxudpAxGgUJYF9aVIyzVf1q6JPqFH7bm8ofRErmYK9z8xm9Matg8LLVEy8fkBQmpc8R63urUojFdQvw27mUEkjH3Vw0rPSvM/8KbE/62T1wBTFIfTqpKVOT4mziUNc5koQTwWAnXTRucwLN6IB3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LXvsuq0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LXvsuq0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E697AC4CEF7
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2026 18:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775498919;
	bh=HgHqrCCbVUalxrJKRj2EAOKq3gwsFEsdePWpyCqf1gY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LXvsuq0+P+PLolqKELai8PXmBqtXnReSQm+Tl/dJsXaZq8/XpTkY+HrwtrSaCA44a
	 A7IPmqI0JUUXBKF+094WBN6u8+AplX0tG6VaqBmPHrlzN2I0NS+TBnnBojyUtqN5fb
	 SjEwYTPY5Kx2Yf121r2KRXnMka85CGuUrHxCpVIOpPoUQU7NELRkMMngRYJSwP30do
	 /tFGeTJ2eIBEJwYwj3+TeYhbsrKfacUw4BHMDlzO13JZaY7Rw1CwfYQanNPaXLp6eQ
	 a4N2Tq9B0I+xCq6wnwnlevnmzioXM3qRdyoj5uuxcnJPf6u2bM6KSGP+U1DEsD0rey
	 p3pb5o0nWdv8Q==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-66e129e457dso4110029a12.1
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2026 11:08:39 -0700 (PDT)
X-Gm-Message-State: AOJu0YwEirLx7I/q5weue1Gzae7zS2zlqa4VvQomrOnmIxS+ERID7JAu
	OhLli9rLKjDKGQgNq68Mxj2fFH5gIrKKepVzDjoBvrzgk+1+wEs/9Qax9Pq1ocoSk5N1V+l1xmc
	17kS7UdfTej89KznjZ3KxCxjQh4Bv3Dg=
X-Received: by 2002:a17:907:3f11:b0:b9c:9dcb:36d9 with SMTP id
 a640c23a62f3a-b9c9dcb3a2cmr421553766b.49.1775498918369; Mon, 06 Apr 2026
 11:08:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1775255085.git.boris@bur.io> <115dd08f8ba76b0a2a6fdd19a8ac4d4fb335cc49.1775255085.git.boris@bur.io>
In-Reply-To: <115dd08f8ba76b0a2a6fdd19a8ac4d4fb335cc49.1775255085.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 6 Apr 2026 19:08:00 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7sP3kEagziA5r7ANAV35p6D6jWbQ5WL9QVnquWYD60-Q@mail.gmail.com>
X-Gm-Features: AQROBzCItvE99B0jqKtDC_5s6I0o9SH9emCHNu0v81kX6lJTLx5LG4E3qkgVOQQ
Message-ID: <CAL3q7H7sP3kEagziA5r7ANAV35p6D6jWbQ5WL9QVnquWYD60-Q@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] btrfs: cap shrink_delalloc iterations to 128M
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 3, 2026 at 11:30=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> Even with more accurate delayed_refs reservations, preemptive reclaim is
> not perfect and we might generate tickets, especially in cases with a
> very large flood of writeback outstanding.
>
> Ultimately, if we do get into a situation with tickets pending and async
> reclaim blocking the system, we want to try to make as much progress as
> quickly as possible to unblock tasks. We want space reclaim to be
> effective, and to have a good chance at making progress, but not to
> block arbitrarily as this leads to untenable syscall latencies, long
> commits, and even hung task warnings.
>
> I traced such cases of heavy writeback async reclaim hung tasks and
> observed that we were blocking for long periods of time in
> shrink_delalloc(). This was particularly bad when doing writeback of
> incompressible data with the compress-force mount option.
>
> e.g.
> dd if=3D/dev/urandom of=3Durandom.seed bs=3D1G count=3D1
> dd if=3Durandom.seed of=3Durandom.big bs=3D1G count=3D300
>
> shrink_delalloc() computes to_reclaim as delalloc_bytes >> 3. With
> hundreds of gigs of delalloc (again imagine a large dirty_ratio and lots
> of ram), this is still 10-20+ GiB. Particularly in the wait phases, this
> can be quite slow, and generates even more delayed-refs as mentioned in
> the previous patch, so it doesn't even help that much with the immediate
> space shortfall.
>
> We do satisfy some tickets, but we are ultimately keep the system in
> essentially the same state, and with long stalling reclaim calls into
> shrink_delalloc().
>
> It would be much better to start some good chunk of I/O and also to work
> through the new delayed_refs and keep things moving through the system
> while releasing the conservative over-estimated metadata reservations.
>
> To acheive this, tighten up the delalloc work to be in units of the
> maximum extent size. If we issue 128MiB of delalloc, we don't leave too
> much (any?) extent merging on the table, but don't ever block on
> pathological 10GiB+ chunks of delalloc. If we do detect that we
> satisfied a ticket, break out of shrink_delalloc() and run some of the
> new delayed_refs as well before going again. This way we strike a nice
> balance of making delalloc progress, but not at the cost of every other
> sort of reservation, as they all feed into each other.
>
> This means iterating over to_reclaim by 128MiB at a time until it is
> drained or we satisfy a ticket, rather than trying 3 times to do the
> whole thing.
>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/space-info.c | 31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index f0436eea1544..15c5be97a123 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -727,7 +727,7 @@ static void shrink_delalloc(struct btrfs_space_info *=
space_info,
>         u64 ordered_bytes;
>         u64 items;
>         long time_left;
> -       int loops;
> +       u64 orig_tickets_id;
>
>         delalloc_bytes =3D percpu_counter_sum_positive(&fs_info->delalloc=
_bytes);
>         ordered_bytes =3D percpu_counter_sum_positive(&fs_info->ordered_b=
ytes);
> @@ -735,9 +735,7 @@ static void shrink_delalloc(struct btrfs_space_info *=
space_info,
>                 return;
>
>         /* Calc the number of the pages we need flush for space reservati=
on */
> -       if (to_reclaim =3D=3D U64_MAX) {
> -               items =3D U64_MAX;
> -       } else {
> +       if (to_reclaim !=3D U64_MAX) {
>                 /*
>                  * to_reclaim is set to however much metadata we need to
>                  * reclaim, but reclaiming that much data doesn't really =
track
> @@ -751,7 +749,6 @@ static void shrink_delalloc(struct btrfs_space_info *=
space_info,
>                  * aggressive.
>                  */
>                 to_reclaim =3D max(to_reclaim, delalloc_bytes >> 3);
> -               items =3D calc_reclaim_items_nr(fs_info, to_reclaim) * 2;
>         }
>
>         trans =3D current->journal_info;
> @@ -764,12 +761,17 @@ static void shrink_delalloc(struct btrfs_space_info=
 *space_info,
>         if (ordered_bytes > delalloc_bytes && !for_preempt)
>                 wait_ordered =3D true;
>
> -       loops =3D 0;
> -       while ((delalloc_bytes || ordered_bytes) && loops < 3) {
> -               u64 temp =3D min(delalloc_bytes, to_reclaim) >> PAGE_SHIF=
T;
> -               long nr_pages =3D min_t(u64, temp, LONG_MAX);
> +       spin_lock(&space_info->lock);
> +       orig_tickets_id =3D space_info->tickets_id;
> +       spin_unlock(&space_info->lock);
> +
> +       while ((delalloc_bytes || ordered_bytes) && to_reclaim) {
> +               u64 iter_reclaim =3D min_t(u64, to_reclaim, SZ_128M);
> +               long nr_pages =3D min_t(u64, delalloc_bytes, iter_reclaim=
) >> PAGE_SHIFT;
>                 int async_pages;
>
> +               items =3D calc_reclaim_items_nr(fs_info, iter_reclaim) * =
2;

We can also move the 'items' declaration inside this loop instead of top le=
vel.

Otherwise:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +
>                 btrfs_start_delalloc_roots(fs_info, nr_pages, true);
>
>                 /*
> @@ -811,7 +813,7 @@ static void shrink_delalloc(struct btrfs_space_info *=
space_info,
>                            atomic_read(&fs_info->async_delalloc_pages) <=
=3D
>                            async_pages);
>  skip_async:
> -               loops++;
> +               to_reclaim -=3D iter_reclaim;
>                 if (wait_ordered && !trans) {
>                         btrfs_wait_ordered_roots(fs_info, items, NULL);
>                 } else {
> @@ -834,6 +836,15 @@ static void shrink_delalloc(struct btrfs_space_info =
*space_info,
>                         spin_unlock(&space_info->lock);
>                         break;
>                 }
> +               /*
> +                * If a ticket was satisfied since we started, break out
> +                * so the async reclaim state machine can process delayed
> +                * refs before we flush more delalloc.
> +                */
> +               if (space_info->tickets_id !=3D orig_tickets_id) {
> +                       spin_unlock(&space_info->lock);
> +                       break;
> +               }
>                 spin_unlock(&space_info->lock);
>
>                 delalloc_bytes =3D percpu_counter_sum_positive(
> --
> 2.53.0
>
>
