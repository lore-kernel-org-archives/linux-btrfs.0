Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbcD0ECQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 00:02:16 -0400
From: NeilBrown <neilb@suse.de>
To: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@fb.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Apr 2016 14:02:03 +1000
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-btrfs@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Alan Cox <alan@linux.intel.com>,
        Liu Bo <bo.li.liu@oracle.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 3/3] block: avoid to call .bi_end_io() recursively
In-Reply-To: <1461729114-22989-1-git-send-email-ming.lei@canonical.com>
Message-ID: <87mvofwvgk.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1461729114-22989-1-git-send-email-ming.lei@canonical.com>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 27 2016, Ming Lei wrote:

> There were reports about heavy stack use by recursive calling
> .bi_end_io()([1][2][3]). For example, more than 16K stack is
> consumed in a single bio complete path[3], and in [2] stack
> overflow can be triggered if 20 nested dm-crypt is used.
>
> Also patches[1] [2] [3] were posted for addressing the issue,
> but never be merged. And the idea in these patches is basically
> similar, all serializes the recursive calling of .bi_end_io() by
> percpu list.
>
> This patch still takes the same idea, but uses bio_list to
> implement it, which turns out more simple and the code becomes
> more readable meantime.
>
> One corner case which wasn't covered before is that
> bi_endio() may be scheduled to run in process context(such
> as btrfs), and this patch just bypasses the optimizing for
> that case because one new context should have enough stack space,
> and this approach isn't capable of optimizing it too because
> there isn't easy way to get a per-task linked list head.
>
> xfstests(-g auto) is run with this patch and no regression is
> found on ext4, xfs and btrfs.
>
> [1] http://marc.info/?t=3D121428502000004&r=3D1&w=3D2
> [2] http://marc.info/?l=3Ddm-devel&m=3D139595190620008&w=3D2
> [3] http://marc.info/?t=3D145974644100001&r=3D1&w=3D2
>
> Cc: Shaun Tancheff <shaun.tancheff@seagate.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  block/bio.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++=
--
>  1 file changed, 55 insertions(+), 2 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index 807d25e..6b4ca7b 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -68,6 +68,8 @@ static DEFINE_MUTEX(bio_slab_lock);
>  static struct bio_slab *bio_slabs;
>  static unsigned int bio_slab_nr, bio_slab_max;
>=20=20
> +static DEFINE_PER_CPU(struct bio_list *, bio_end_list) =3D { NULL };
> +
>  static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_siz=
e)
>  {
>  	unsigned int sz =3D sizeof(struct bio) + extra_size;
> @@ -1737,6 +1739,58 @@ static inline bool bio_remaining_done(struct bio *=
bio)
>  	return false;
>  }
>=20=20
> +static void __bio_endio(struct bio *bio)
> +{
> +	if (bio->bi_end_io)
> +		bio->bi_end_io(bio);
> +}
> +
> +/* disable local irq when manipulating the percpu bio_list */
> +static void unwind_bio_endio(struct bio *bio)
> +{
> +	struct bio_list *bl;
> +	unsigned long flags;
> +
> +	/*
> +	 * We can't optimize if bi_endio() is scheduled to run from
> +	 * process context because there isn't easy way to get a
> +	 * per-task bio list head or allocate a per-task variable.
> +	 */
> +	if (!in_interrupt()) {
> +		/*
> +		 * It has to be a top calling when it is run from
> +		 * process context.
> +		 */
> +		WARN_ON(this_cpu_read(bio_end_list));
> +		__bio_endio(bio);
> +		return;
> +	}
> +
> +	local_irq_save(flags);
> +	bl =3D __this_cpu_read(bio_end_list);
> +	if (!bl) {
> +		struct bio_list bl_in_stack;
> +
> +		bl =3D &bl_in_stack;
> +		bio_list_init(bl);
> +		__this_cpu_write(bio_end_list, bl);

The patch seems to make sense, but this bit bothers me.
You are expecting bl_in_stack to still be usable after this block of
code completes.  While it probably is, I don't think it is a good idea
to depend on it.
If you move the "struct bio_list bl_in_stack" to the top of the function
I would be a lot happier.

Or you could change the code to:

   if (bl) {
       bio_list_add(bl, bio);
   } else {
       struct bio_list bl_in_stack;
       ... use bl_in_stack,
       while loop
       set bio_end_list to NULL
   }

and the code flow would all be must clearer.

Thanks,
NeilBrown

> +	} else {
> +		bio_list_add(bl, bio);
> +		goto out;
> +	}
> +
> +	while (bio) {
> +		local_irq_restore(flags);
> +		__bio_endio(bio);
> +		local_irq_save(flags);
> +> +		bio =3D bio_list_pop(bl);
> +	}
> +	__this_cpu_write(bio_end_list, NULL);
> + out:
> +	local_irq_restore(flags);
> +}
> +
>  /**
>   * bio_endio - end I/O on a bio
>   * @bio:	bio
> @@ -1765,8 +1819,7 @@ again:
>  		goto again;
>  	}
>=20=20
> -	if (bio->bi_end_io)
> -		bio->bi_end_io(bio);
> +	unwind_bio_endio(bio);
>  }
>  EXPORT_SYMBOL(bio_endio);
>=20=20
> --=20
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXIDm7AAoJEDnsnt1WYoG5AUIQAK7bsEqTkc/oM0PdAZ4HlIdN
UFASBnri3AGRLSjYkmxyPxSW6Q0wJswDDrPF2dnNw995TcEhTVrYFdoLpTw/iHn+
7M10mJ71a6NG4SaZlZ+zU0Vmfd6e+Z4+hRCAqjQBAvCsYw0SnkREw4wo+7sIXJpE
JqNrFuISX4sPKcjkaCNOm+YIK+RTXfwKF9mmgD+WWNGIx9APNVkjgpCxAd+hE00s
VB+Jh8V2KGRsK7Fu8e1C1LUfNihuQRLLyk92KiSt4Joe2FevuxwRergUXsQaz//y
Aa63Ym4LOEiYHAWWS8OLMVSVw0vkt4Cf7gAVB6blbOknXF0kptROzJp5apFUBSet
r2e1lfTgChlX4+upQNx1QW/PBxOxbupbv/hZw91HEKSjgUTX6gn7Is0P/iUUEJ0S
dhYcMU37yVaxe9j+MAISZrInhp2UvYh6yknpG9rp0/3eyC4rfxpAoksqn0MVLty+
tk0iAi6L2SH1583fYyhOAWBnMlEJdvDcTMmU98pVtGZuQWY0onO/4Hx102CoABwp
u8KwZXtEkYH0LMiHHkvxcJVhs/c+hD2Zwu3Rhbj/63vD2hkyDOKqpQKVELXrYdkN
ugf8OS9XsjPuNW8DtL1u4/XMRU4pFahrqTWtSMsQLKdL9zAbt2bfmF/ySFi4hn+K
6sH04v3tXJZiDZJeQEBT
=ixO0
-----END PGP SIGNATURE-----
--=-=-=--
