Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab3KXEYT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Nov 2013 23:24:19 -0500
Date: Sun, 24 Nov 2013 15:24:03 +1100
From: NeilBrown <neilb@suse.de>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH] block: submit_bio_wait() conversions
Message-ID: <20131124152403.2206a8cc@notabene.brown>
In-Reply-To: <1385265810-16095-1-git-send-email-kmo@daterainc.com>
References: <1385265810-16095-1-git-send-email-kmo@daterainc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OI_i1A26nP+M3CNhEyD2Asr"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/OI_i1A26nP+M3CNhEyD2Asr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Nov 2013 20:03:30 -0800 Kent Overstreet <kmo@daterainc.com> wrot=
e:

> It was being open coded in a few places.
>=20
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Joern Engel <joern@logfs.org>
> Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Chris Mason <chris.mason@fusionio.com>

Acked-by: NeilBrown <neilb@suse.de>

for the drivers/md/md.c bits, however...

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b6b7a28..8700de3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -776,16 +776,10 @@ void md_super_wait(struct mddev *mddev)
>  	finish_wait(&mddev->sb_wait, &wq);
>  }
> =20
> -static void bi_complete(struct bio *bio, int error)
> -{
> -	complete((struct completion*)bio->bi_private);
> -}
> -
>  int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
>  		 struct page *page, int rw, bool metadata_op)
>  {
>  	struct bio *bio =3D bio_alloc_mddev(GFP_NOIO, 1, rdev->mddev);
> -	struct completion event;
>  	int ret;
> =20
>  	rw |=3D REQ_SYNC;
        ^^^^^^^^^^^^^^^

you could remove this line as well, as submit_bio_wait sets this flag for u=
s.


> @@ -801,11 +795,7 @@ int sync_page_io(struct md_rdev *rdev, sector_t sect=
or, int size,
>  	else
>  		bio->bi_sector =3D sector + rdev->data_offset;
>  	bio_add_page(bio, page, size, 0);
> -	init_completion(&event);
> -	bio->bi_private =3D &event;
> -	bio->bi_end_io =3D bi_complete;
> -	submit_bio(rw, bio);
> -	wait_for_completion(&event);
> +	submit_bio_wait(rw, bio);
> =20
>  	ret =3D test_bit(BIO_UPTODATE, &bio->bi_flags);
>  	bio_put(bio);

Thanks,
NeilBrown

--Sig_/OI_i1A26nP+M3CNhEyD2Asr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpF/Yznsnt1WYoG5AQI7CA/9E4jsGi8VCKjBEKA5M9Lk2z0Zldf7gk+q
s5JtZPZStkQBgiZzo4tz7OKZznMhzrEnViYLxbT8rgupSaIvCrJs0Yzu+JH2euzD
KbPjEx8aadMoo/cuScgyu5LlSoPpf9jS6kJcBCLLkNUpCGlw+SHDYSZej04ExUS1
4isVSNJ9GzzeyHPo7C6s0ucN6VCLHBpIBBUvZ9Ptkj4UxRNcIml3oeN9APp2klxM
AAZQLwgW0a8nerDyqo6H/ekh53s+TwfRRa7uosmNB3YyNHeFKGvyJqF83i3AIKBJ
eh3v6ApDjRsmnVr5YIeZnkI/qG50GpA6SjhdMhGatnPQt2DVlh5PuxB0BQYc6g0a
ks4e/80t1XB6rJQMnszdNLkd48xSTlQfn/pLAW2tItT9VlLNNH9+2q6P9xQ+qIF/
WQVWc7PTBXx6r4IWLM+bEI0T5D6u4IH3CAb4d4ZixfR204+DTY1HvfKe5f9s+ZXS
/U2QxWYnRPFRgpdobdgDHMc24F0XQyebXIcBVaDWC2DELxWYyDrgFAP4eOaafBu7
pJinkEpKAnUvMmU65ehpKxME71i4sSUu51ujTwJakytZ+oxaJ/70TnejqzTdi54s
v3xi7jDPxAzY2OepfknGGCb6/0KZin4rwap0PxxwR4hodKppKwJTy9qI/mCqheF+
Iel+AL7Bg2Y=
=f7aL
-----END PGP SIGNATURE-----

--Sig_/OI_i1A26nP+M3CNhEyD2Asr--
