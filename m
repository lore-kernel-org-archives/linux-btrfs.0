Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794933398;
	b=RC3R2nKtBUsZkitGFi520aG6IeZs5znNyUyRRTGOhdCKsMqGWg+QNQHMZd+vjiJUneuw
	 LPGdh8Il6e5oFmIoLce4WZ2lrshXTK2sG9IUk3mkLUGzjBj+pB8ovgj2YniaLOpJc/S6z
	 AzXMwt1h3dlG7lK4u84WnW6eXgG+vGBLRG9JTCB6HHFS3kzoqwLLCr3Bcw+xXF9JSkjmr
	 9JlASCv+XRMz00uUfeHvE0bMfXQdEkM4atkCu7pS9P14pLb6qyJYFSE75Q0ECF0EFbHbw
	 Le6WreuuzyGAiX/KFb7xPPPDAAco5EkGP/6aOxqzElIr7YVAU1UsJudteMOmH1VazrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794933398;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=Zb5lYLuxjmg3shX7epwrm7jj0zA0SmJFcWL0jUgwwXM=;
	b=VkNcB33GFJcX9Q36+dmrE5I9y+HqhusxBquajLiZshSHqQWOcTkujADMEOCCMw4RuS6G
	 EfdG2/4g1EM33UZuKSiPHwpbUX7fWZkBdNyXLamoiCI/X9TRfwBO85Z7hn23YsJKzWL1C
	 GJvXoQRRq0YH/eixfH+SmApXKPf8AEE4JuTpbDi5iP8/FqbpnThndSvn0MazwmQ/vY+3B
	 2C4GSaOFbdipYSFBTpEQgdb6hmS5fnwAkYL7r3KVsG5Gre0GqMBHwD6WOuO49yKvTo/0J
	 gA28tjnm5ThDIIHSaY/OcYBUSHUqi7+lgg/i0kibAXpGdFyLqL1NR/ZEM9HIiEIhVXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="LM2Rh/YI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACC8606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 16:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LM2Rh/YI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FDA1F000C4
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 16:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794933398;
	bh=Zb5lYLuxjmg3shX7epwrm7jj0zA0SmJFcWL0jUgwwXM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LM2Rh/YIjXZ08VB7J6bNbAaTRoBEXGF5QxZJAg8gfSI4cXdh0ZU8QU3yyMIfxQ+Zk
	 iXQ+7F0g7b9SS1NY3L4X+newtbw65sVtJA6HYH/hmw53WfnC5jw93junCALWJDc8gw
	 oQSwMQg1IqpK8GsgxGnmEr1j/64uZMQrr4DlZ+MX3V0HRUzVwVClNu1rMVEzFjlznz
	 PvASuoXGiZUVys9FXbdZPavMIe6hbESXHDVqOyMHfyiduSMbWxlK6/fMCudnu3ZREr
	 ZPnF6oA+FU2oaHX8dKm9XLVe+f62hLd7rtWpRPFSBXjSdbiKwFksMINRwvY9MGYGrM
	 AswvSe/bq8/xA==
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-7d2ca055399so1204978137.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 08:36:38 -0800 (PST)
X-Gm-Message-State: APuU4Z/fUVoBAYpHAznXFTNPxkh3ffqVGGiVCslHUeK3ym06yLf1FEIM
	Ds+sQg2QwZvey3VHYpxR9buPQokjtd8BPJZLPBQeKr2X7/tY3VmuRAdpMAtXiwRG5j2+MTVuQre
	bavhBCRQn0PKsFr/Mt2gHB0cvx1luskM=
X-Received: by 2002:a05:6102:54a7:b0:7d2:75bf:2fdb with SMTP id
 ada2fe7eead31-7d64d483390mr4099149137.2.1794933397332; Tue, 17 Nov 2026
 08:36:37 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1794867985.git.wqu@suse.com> <217e66b15e1646812cc86be582be67b7e558b270.1794867985.git.wqu@suse.com>
In-Reply-To: <217e66b15e1646812cc86be582be67b7e558b270.1794867985.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 17 Nov 2026 16:36:00 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4Q1pEzYnXf16sNR2JSwj=V0nbMf2YE2iwrQPEKuPJ2WA@mail.gmail.com>
X-Gm-Features: Aa3M54oDDrtqtMTndAZooAX4PnHXfQW-MFixPJvXSIrQumD-9mXy2DSd9zEqMoo
Message-ID: <CAL3q7H4Q1pEzYnXf16sNR2JSwj=V0nbMf2YE2iwrQPEKuPJ2WA@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: scrub: fix use-after-free when waking up the
 repair waiter
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 10:34=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> The read-repair worker of a scrub_stripe can race with stripe freeing:
>
>  CPU0 (repair worker)                CPU1 (scrub)
>  scrub_stripe_read_repair_worker()   scrub_raid56_parity_stripe()
>  |                                   |-wait_event()
>  |                                   | ^^^ checks the condition without
>  |                                   |     taking repair_wait.lock
>  |-set_bit(REPAIR_DONE)              |
>  | ^^^ the waiter can see it now     | ^^^ sees the bit, doesn't sleep
>  |                                   |
>  |                                   \-scrub_simple_mirror()
>  |                                     \-...
>  |                                   scrub_stripe()
>  |                                   |-release_scrub_stripe()
>  |                                   \-kfree(sctx->raid56_data_stripes)
>  |                                     ^^^ stripe freed
>  |
>  \-wake_up()
>    \-_raw_spin_lock_irqsave()
>      ^^^ repair_wait.lock is in freed memory
>      Too late.

There's something odd and very confusing with the diagram.
The way it's structured it gives the idea that
scrub_raid56_parity_stripe() calls scrub_simple_mirror() for example.
But it's scrub_stripe() that calls scrub_raid56_parity_stripe() and
scrub_simple_mirror().

I also find it confusing the mention of scrub_simple_mirror(), since
it doesn't add any value.

Something like this instead (the indentation may be screwed up by gmail):

scrub_stripe()
    scrub_raid56_parity_stripe()
         wait_event()
            ^^ ...
    release_scrub_stripe()
         (...)

This way, the flow is clearer.

Also, the notation you are using is confusing.
On the left side set_bit() and wake_up() are called by
scrub_stripe_read_repair_worker(), but one if prefixed with |- while
the other with \-.
On the right side,

>
> The same applies to flush_scrub_stripes(), where the stripes are freed by
> scrub_free_ctx() at the end of the scrub.
>
> Fix it by waiting with a completion instead. complete_all() wakes the
> waiter under the completion's lock and does not touch it afterwards, and
> wait_for_completion() returns only after taking that lock, so the stripe
> can be freed as soon as the wait returns.
>
> The completion is re-armed by scrub_reset_stripe(), which is called
> before every refill of a stripe, i.e. after the previous waiter has
> returned. The SCRUB_STRIPE_FLAG_REPAIR_DONE flag has no user left, remove
> it.
>
> This is the same problem fixed for the RAID56 rbio in commit
> 26eb4d70f96d ("btrfs: raid56: fix use-after-free when waking up the rbio
> I/O waiter").

We can't place the commit ID here, it's not stable yet since it's in
github's for-next only and will change as it's rebased and so on.

The code itself looks good.

Thanks.

>
> Fixes: 9ecb5ef543d3 ("btrfs: scrub: introduce the main read repair worker=
 for scrub_stripe")
> Cc: stable@vger.kernel.org # 6.4+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/scrub.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 98362c91bce4..4b37ae143f61 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -80,9 +80,6 @@ enum scrub_stripe_flags {
>         /* Set when @mirror_num, @dev, @physical and @logical are set. */
>         SCRUB_STRIPE_FLAG_INITIALIZED,
>
> -       /* Set when the read-repair is finished. */
> -       SCRUB_STRIPE_FLAG_REPAIR_DONE,
> -
>         /*
>          * Set for data stripes if it's triggered from P/Q stripe.
>          * During such scrub, we should not report errors in data stripes=
, nor
> @@ -153,7 +150,9 @@ struct scrub_stripe {
>         /* From btrfs_chunk_map::stripe_len. Should not exceed BTRFS_STRI=
PE_LEN. */
>         u32 stripe_len;
>         wait_queue_head_t io_wait;
> -       wait_queue_head_t repair_wait;
> +
> +       /* Completed when the read-repair is finished. */
> +       struct completion repair_done;
>
>         /*
>          * Indicate the states of the stripe.  Bits are defined in
> @@ -359,7 +358,7 @@ static int init_scrub_stripe(struct btrfs_fs_info *fs=
_info,
>         stripe->state =3D 0;
>
>         init_waitqueue_head(&stripe->io_wait);
> -       init_waitqueue_head(&stripe->repair_wait);
> +       init_completion(&stripe->repair_done);
>         atomic_set(&stripe->pending_io, 0);
>         spin_lock_init(&stripe->write_error_lock);
>
> @@ -1234,8 +1233,7 @@ static void scrub_stripe_read_repair_worker(struct =
work_struct *work)
>         }
>
>         scrub_stripe_report_errors(sctx, stripe, &errors);
> -       set_bit(SCRUB_STRIPE_FLAG_REPAIR_DONE, &stripe->state);
> -       wake_up(&stripe->repair_wait);
> +       complete_all(&stripe->repair_done);
>  }
>
>  static void scrub_read_endio(struct btrfs_bio *bbio)
> @@ -1762,6 +1760,7 @@ static void scrub_reset_stripe(struct scrub_stripe =
*stripe)
>         stripe->nr_meta_extents =3D 0;
>         stripe->nr_data_extents =3D 0;
>         stripe->state =3D 0;
> +       reinit_completion(&stripe->repair_done);
>
>         for (int i =3D 0; i < stripe->nr_sectors; i++) {
>                 stripe->sectors[i].csum =3D NULL;
> @@ -1960,8 +1959,7 @@ static int flush_scrub_stripes(struct scrub_ctx *sc=
tx)
>         for (int i =3D 0; i < nr_stripes; i++) {
>                 stripe =3D &sctx->stripes[i];
>
> -               wait_event(stripe->repair_wait,
> -                          test_bit(SCRUB_STRIPE_FLAG_REPAIR_DONE, &strip=
e->state));
> +               wait_for_completion(&stripe->repair_done);
>         }
>
>         /* Submit for dev-replace. */
> @@ -2236,8 +2234,7 @@ static int scrub_raid56_parity_stripe(struct scrub_=
ctx *sctx,
>         for (int i =3D 0; i < data_stripes; i++) {
>                 stripe =3D &sctx->raid56_data_stripes[i];
>
> -               wait_event(stripe->repair_wait,
> -                          test_bit(SCRUB_STRIPE_FLAG_REPAIR_DONE, &strip=
e->state));
> +               wait_for_completion(&stripe->repair_done);
>         }
>         /* For now, no zoned support for RAID56. */
>         ASSERT(!btrfs_is_zoned(sctx->fs_info));
> --
> 2.56.0
>
>
