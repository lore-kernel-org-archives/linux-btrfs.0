Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794934210;
	b=y2ZLTj2hPbPZnknsny/EvcrZmyZnWi6CPY44BU/Q01irKA2o2aQk30IrBvNZlT63DLoQ
	 oAGn6W+PFRZHz/jl8b0QxLbHzbjL7FpC52Ns/X8ycmEcsubF0mApEr8kw9ZWDPxDm2kba
	 RLJYF9S+zbD37yfBAMmgzgR4GcqUW9BkHXfwLRNJiMawwRXWRUMzFIsuFHdndqMZ1UazL
	 rqis5G3d9pjxFZF/rFys+xEWbVLZ4irMcjZwirECCrxHvhdauSlPT/twOrbjDF0K/cARS
	 xOOgcaVIQSRyvVc78m4mYMA2IHZhj5ATOtSUw1OgkxOcAubsUdrZg6vulR1YMPsvaXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794934210;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=QkvX4elFR9Vic1Ho+taO35n2YuvBLAyPlVWWxJZnQJI=;
	b=QMMVhnT8rjJT/zEmUoFHT46rhpvvGxL0zT8Pwrdb85lPUOhDbweoKGDGehCHe2JhJPV2
	 adklA3Mi4Vcg6Fq8ZzdAPa79mVBYnIs3dC6FpDhAOADNMMFC7SsMutDg/WGghPTZirADd
	 KswB4smco4cjsKuAOyajEaaYJINFiRSXecZwE708wJTcu08KhWS1m3kf+VOeGR8FUN7QN
	 Xz8tEUisXApFEYQfdHi1jLdL6bkzN5OIhhGlNZPGcoBDJChYGS9bcBxNzBa00StWoVaDm
	 1Yl9dsKsNz0IEiZqhj60SNdTXK0AM1qoUKCV7dfb6+EMY1wRW6NuB5JsfYdnN3t8fCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ipKYnhkR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665A3606A32C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 16:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ipKYnhkR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4205D1F000C8
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794934210;
	bh=QkvX4elFR9Vic1Ho+taO35n2YuvBLAyPlVWWxJZnQJI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ipKYnhkRlHelaOjj9rxT0k7fbDKABqeB8R8g3tw1tNMBc7CDD/sICLztHWcdzlchT
	 EEsTOqSXcqOb582JTfjuKXoGBs5RXcpkxJSpNOfoBUYmVo+35bycqnpy2GPtqVFgDA
	 IMJI7Gfz7hyHacJfsHr5efCXeEgAqVuETxYWjcu3oYTTItUff3GEmJ/Qc7QMxwl51R
	 Dsdww5KJBiKtXZtUzD9H/OnKcj5wdUkogAUMRtGYqbQfADiapX0llR3kqARhdgFXah
	 YfKjnCkD+tpNDCXa4no5+jptcFEn9fCONInJN+Z3XfXt/f4G691V/O8r21DYF1aFxL
	 Ng25UV7yvcgWw==
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-7cc0ccc2fddso1480876137.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 08:50:10 -0800 (PST)
X-Gm-Message-State: APuU4Z++g82kVh4VxNHWTcnffXePCgHaW8iBbt2QVaNJovgOtWLE6GZ6
	MZLC9ODTIHdA2kBA2PSpb60D/OUk9JmEcD0NGH79iu0OuhOcbBh6lDDCxcgqx3duMn51WmdyFQQ
	gmpXT75ZDkTIAKyxfPgP7EDFymBqSAjs=
X-Received: by 2002:a05:6102:e08:b0:7cc:9d47:9c9 with SMTP id
 ada2fe7eead31-7d64d8e11e0mr4550359137.35.1794934209294; Tue, 17 Nov 2026
 08:50:09 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1794867985.git.wqu@suse.com> <51527ea5f9f456a7ebe70b7fcaf626fac3dab945.1794867985.git.wqu@suse.com>
In-Reply-To: <51527ea5f9f456a7ebe70b7fcaf626fac3dab945.1794867985.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 17 Nov 2026 16:49:32 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6xiDZVeWmS2K64KmKLLa=9yWBt9JTgk-BsfdASmqjrhg@mail.gmail.com>
X-Gm-Features: Aa3M54otklqmyjuiqPETTuLmAR1yAHFWg6zaYtAGhR1ghAuYv4TK9wYjR_Cc8ns
Message-ID: <CAL3q7H6xiDZVeWmS2K64KmKLLa=9yWBt9JTgk-BsfdASmqjrhg@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: scrub: fix use-after-free when waking up the
 stripe I/O waiter
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 10:34=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> The scrub_write_endio() can race with scrub finishing, which can lead to
> use-after-free:
>
>  CPU0 (write endio)                  CPU1 (scrub)
>  scrub_write_endio()                 flush_scrub_stripes()
>  |                                   |-wait_scrub_stripe_io()
>  |                                   | \-wait_event()
>  |                                   |   ^^^ checks the condition without
>  |                                   |       taking io_wait.lock
>  |-atomic_dec_and_test()             |
>  | ^^^ pending_io hits 0             |
>  |                                   | ^^^ sees 0, doesn't sleep
>  |                                   |
>  |                                   btrfs_scrub_dev()
>  |                                   \-scrub_put_ctx()
>  |                                     \-scrub_free_ctx()
>  |                                       ^^^ stripe freed
>  |
>  \-wake_up()
>    \-_raw_spin_lock_irqsave()
>      ^^^ io_wait.lock is in freed memory
>          Too late.

I have the same comment here regarding the diagram.
It confuses me, it gives the wrong idea that flush_scrub_stripes()
either calls btrfs_scrub_dev() or that they are called from the same
function.

This can be clearer by using indentation and not skipping functions in
the call chain:

btrfs_scrub_dev()
   scrub_enumerate_chunks()
      scrub_chunk()
         scrub_stripe()
            flush_scrub_stripes()
               wait_scrub_stripe_io()
                  wait_event()
                     (...)

   scrub_put_ctx()
      scrub_free_ctx()


>
> Fix it by waiting with a completion instead. complete_all() wakes the
> waiter under the completion's lock and does not touch it afterwards, and
> wait_for_completion_io() returns only after taking that lock, so the
> stripe can be freed as soon as the wait returns.
>
> There are locations that we submit multiple bios in one go, with extra
> care the pending_io can reach 0 during the submission, to address it:
>
> - Re-arm the completion when the first pending_io ref is taken, in
>   scrub_stripe_get_io(). Any previous round of IO is waited for before th=
e
>   next one starts.
>
> - Hold one extra ref for batched submission
>   This includes:
>   * scrub_write_sectors()
>   * scrub_stripe_submit_repair_read() for non-zoned cases
>
>   This is the same pattern used in other scrub path.
>
> The completion is initialized as completed, so waiting on a stripe withou=
t
> any pending IO returns immediately as before.
>
> This is the same problem fixed for the RAID56 rbio in commit
> 26eb4d70f96d ("btrfs: raid56: fix use-after-free when waking up the rbio
> I/O waiter").

Just like for the previous patch, I have the same comment regarding
the commit ID not being stable here; it can change after rebasing and
so on.

The code looks good.
Thanks.

>
> Fixes: 9ecb5ef543d3 ("btrfs: scrub: introduce the main read repair worker=
 for scrub_stripe")
> Fixes: 058e09e6fe7c ("btrfs: scrub: introduce a writeback helper for scru=
b_stripe")
> Cc: stable@vger.kernel.org # 6.4+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/scrub.c | 97 ++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 69 insertions(+), 28 deletions(-)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 4b37ae143f61..a8c62a3aea0c 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -149,7 +149,9 @@ struct scrub_stripe {
>         atomic_t pending_io;
>         /* From btrfs_chunk_map::stripe_len. Should not exceed BTRFS_STRI=
PE_LEN. */
>         u32 stripe_len;
> -       wait_queue_head_t io_wait;
> +
> +       /* Completed by the last endio when pending_io drops to zero. */
> +       struct completion io_done;
>
>         /* Completed when the read-repair is finished. */
>         struct completion repair_done;
> @@ -357,9 +359,11 @@ static int init_scrub_stripe(struct btrfs_fs_info *f=
s_info,
>         stripe->stripe_len =3D BTRFS_STRIPE_LEN;
>         stripe->state =3D 0;
>
> -       init_waitqueue_head(&stripe->io_wait);
>         init_completion(&stripe->repair_done);
> +       init_completion(&stripe->io_done);
>         atomic_set(&stripe->pending_io, 0);
> +       /* No pending IO by default, thus nothing to wait. */
> +       complete_all(&stripe->io_done);
>         spin_lock_init(&stripe->write_error_lock);
>
>         stripe->buffer =3D kvmalloc(BTRFS_STRIPE_LEN, GFP_KERNEL);
> @@ -381,9 +385,25 @@ static int init_scrub_stripe(struct btrfs_fs_info *f=
s_info,
>         return -ENOMEM;
>  }
>
> +static void scrub_stripe_get_io(struct scrub_stripe *stripe)
> +{
> +       /* The first pending IO re-arms the completion. */
> +       if (atomic_inc_return(&stripe->pending_io) =3D=3D 1)
> +               reinit_completion(&stripe->io_done);
> +}
> +
> +/* Drop one pending IO, return true if it was the last one. */
> +static bool scrub_stripe_put_io(struct scrub_stripe *stripe)
> +{
> +       if (!atomic_dec_and_test(&stripe->pending_io))
> +               return false;
> +       complete_all(&stripe->io_done);
> +       return true;
> +}
> +
>  static void wait_scrub_stripe_io(struct scrub_stripe *stripe)
>  {
> -       wait_event(stripe->io_wait, atomic_read(&stripe->pending_io) =3D=
=3D 0);
> +       wait_for_completion_io(&stripe->io_done);
>  }
>
>  static void scrub_put_ctx(struct scrub_ctx *sctx);
> @@ -891,8 +911,7 @@ static void scrub_repair_read_endio(struct btrfs_bio =
*bbio)
>
>         scrub_read_endio_common(bbio);
>
> -       if (atomic_dec_and_test(&stripe->pending_io))
> -               wake_up(&stripe->io_wait);
> +       scrub_stripe_put_io(stripe);
>  }
>
>  static int calc_next_mirror(int mirror, int num_copies)
> @@ -941,6 +960,18 @@ static struct btrfs_bio *alloc_scrub_bbio(struct btr=
fs_fs_info *fs_info,
>         return bbio;
>  }
>
> +static void scrub_submit_repair_read_bio(struct scrub_stripe *stripe,
> +                                        struct btrfs_bio *bbio, int mirr=
or,
> +                                        bool wait)
> +{
> +       ASSERT(bbio->bio.bi_iter.bi_size);
> +
> +       scrub_stripe_get_io(stripe);
> +       btrfs_submit_bbio(bbio, mirror);
> +       if (wait)
> +               wait_scrub_stripe_io(stripe);
> +}
> +
>  static void scrub_stripe_submit_repair_read(struct scrub_stripe *stripe,
>                                             int mirror, int blocksize, bo=
ol wait)
>  {
> @@ -953,15 +984,19 @@ static void scrub_stripe_submit_repair_read(struct =
scrub_stripe *stripe,
>         ASSERT(atomic_read(&stripe->pending_io) =3D=3D 0,
>                "atomic_read(&stripe->pending_io)=3D%d", atomic_read(&stri=
pe->pending_io));
>
> +       /*
> +        * Hold an extra ref during submission, so the IO can not be repo=
rted as
> +        * finished before all bios are submitted.
> +        * If we wait for every bio, no extra ref as it would block the w=
ait.
> +        */
> +       if (!wait)
> +               scrub_stripe_get_io(stripe);
> +
>         for_each_set_bit(i, &old_error_bitmap, stripe->nr_sectors) {
>                 /* The current sector cannot be merged, submit the bio. *=
/
>                 if (bbio && ((i > 0 && !test_bit(i - 1, &old_error_bitmap=
)) ||
>                              bbio->bio.bi_iter.bi_size >=3D blocksize)) {
> -                       ASSERT(bbio->bio.bi_iter.bi_size);
> -                       atomic_inc(&stripe->pending_io);
> -                       btrfs_submit_bbio(bbio, mirror);
> -                       if (wait)
> -                               wait_scrub_stripe_io(stripe);
> +                       scrub_submit_repair_read_bio(stripe, bbio, mirror=
, wait);
>                         bbio =3D NULL;
>                 }
>
> @@ -973,13 +1008,10 @@ static void scrub_stripe_submit_repair_read(struct=
 scrub_stripe *stripe,
>
>                 scrub_bio_add_sector(bbio, stripe, i);
>         }
> -       if (bbio) {
> -               ASSERT(bbio->bio.bi_iter.bi_size);
> -               atomic_inc(&stripe->pending_io);
> -               btrfs_submit_bbio(bbio, mirror);
> -               if (wait)
> -                       wait_scrub_stripe_io(stripe);
> -       }
> +       if (bbio)
> +               scrub_submit_repair_read_bio(stripe, bbio, mirror, wait);
> +       if (!wait)
> +               scrub_stripe_put_io(stripe);
>  }
>
>  static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
> @@ -1242,8 +1274,7 @@ static void scrub_read_endio(struct btrfs_bio *bbio=
)
>
>         scrub_read_endio_common(bbio);
>
> -       if (atomic_dec_and_test(&stripe->pending_io)) {
> -               wake_up(&stripe->io_wait);
> +       if (scrub_stripe_put_io(stripe)) {
>                 INIT_WORK(&stripe->work, scrub_stripe_read_repair_worker)=
;
>                 queue_work(stripe->bg->fs_info->scrub_workers, &stripe->w=
ork);
>         }
> @@ -1269,8 +1300,7 @@ static void scrub_write_endio(struct btrfs_bio *bbi=
o)
>         }
>         bio_put(&bbio->bio);
>
> -       if (atomic_dec_and_test(&stripe->pending_io))
> -               wake_up(&stripe->io_wait);
> +       scrub_stripe_put_io(stripe);
>  }
>
>  static void scrub_submit_write_bio(struct scrub_ctx *sctx,
> @@ -1283,7 +1313,7 @@ static void scrub_submit_write_bio(struct scrub_ctx=
 *sctx,
>                       stripe->logical;
>
>         fill_writer_pointer_gap(sctx, stripe->physical + bio_off);
> -       atomic_inc(&stripe->pending_io);
> +       scrub_stripe_get_io(stripe);
>         btrfs_submit_repair_write(bbio, stripe->mirror_num, dev_replace);
>         if (!btrfs_is_zoned(fs_info))
>                 return;
> @@ -1322,6 +1352,15 @@ static void scrub_write_sectors(struct scrub_ctx *=
sctx, struct scrub_stripe *str
>         struct btrfs_bio *bbio =3D NULL;
>         int sector_nr;
>
> +       /*
> +        * Hold an extra ref during submission, so the IO can not be repo=
rted as
> +        * finished before all bios are submitted.
> +        * For zoned, we wait for every bio, no extra ref as it would blo=
ck the
> +        * wait.
> +        */
> +       if (!btrfs_is_zoned(fs_info))
> +               scrub_stripe_get_io(stripe);
> +
>         for_each_set_bit(sector_nr, &write_bitmap, stripe->nr_sectors) {
>                 /* We should only writeback sectors covered by an extent.=
 */
>                 ASSERT(scrub_bitmap_test_bit_has_extent(stripe, sector_nr=
));
> @@ -1340,6 +1379,8 @@ static void scrub_write_sectors(struct scrub_ctx *s=
ctx, struct scrub_stripe *str
>         }
>         if (bbio)
>                 scrub_submit_write_bio(sctx, stripe, bbio, dev_replace);
> +       if (!btrfs_is_zoned(fs_info))
> +               scrub_stripe_put_io(stripe);
>  }
>
>  /*
> @@ -1786,7 +1827,8 @@ static void scrub_submit_extent_sector_read(struct =
scrub_stripe *stripe)
>         int mirror =3D stripe->mirror_num;
>         int i;
>
> -       atomic_inc(&stripe->pending_io);
> +       /* The extra ref is dropped after all bios are submitted. */
> +       scrub_stripe_get_io(stripe);
>
>         for_each_set_bit(i, &has_extent, stripe->nr_sectors) {
>                 /* We're beyond the chunk boundary, no need to read anymo=
re. */
> @@ -1798,7 +1840,7 @@ static void scrub_submit_extent_sector_read(struct =
scrub_stripe *stripe)
>                     ((i > 0 && !test_bit(i - 1, &has_extent)) ||
>                      bbio->bio.bi_iter.bi_size >=3D stripe_len)) {
>                         ASSERT(bbio->bio.bi_iter.bi_size);
> -                       atomic_inc(&stripe->pending_io);
> +                       scrub_stripe_get_io(stripe);
>                         btrfs_submit_bbio(bbio, mirror);
>                         bbio =3D NULL;
>                 }
> @@ -1844,12 +1886,11 @@ static void scrub_submit_extent_sector_read(struc=
t scrub_stripe *stripe)
>
>         if (bbio) {
>                 ASSERT(bbio->bio.bi_iter.bi_size);
> -               atomic_inc(&stripe->pending_io);
> +               scrub_stripe_get_io(stripe);
>                 btrfs_submit_bbio(bbio, mirror);
>         }
>
> -       if (atomic_dec_and_test(&stripe->pending_io)) {
> -               wake_up(&stripe->io_wait);
> +       if (scrub_stripe_put_io(stripe)) {
>                 INIT_WORK(&stripe->work, scrub_stripe_read_repair_worker)=
;
>                 queue_work(stripe->bg->fs_info->scrub_workers, &stripe->w=
ork);
>         }
> @@ -1877,7 +1918,7 @@ static void scrub_submit_initial_read(struct scrub_=
ctx *sctx,
>         /* Read the whole range inside the chunk boundary. */
>         for (unsigned int cur =3D 0; cur < nr_sectors; cur++)
>                 scrub_bio_add_sector(bbio, stripe, cur);
> -       atomic_inc(&stripe->pending_io);
> +       scrub_stripe_get_io(stripe);
>
>         /*
>          * For dev-replace, either user asks to avoid the source dev, or
> --
> 2.56.0
>
>
