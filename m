Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbcDEWt5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Apr 2016 18:49:57 -0400
From: NeilBrown <neilb@suse.de>
To: Lars Ellenberg <lars.ellenberg@linbit.com>, Jens Axboe <axboe@kernel.dk>
Date: Wed, 06 Apr 2016 08:49:46 +1000
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] [RFC] fix potential access after free: return value of blk_check_plugged() must be used schedule() safe
In-Reply-To: <20160405133657.GA3078@soda.linbit>
References: <20160405133657.GA3078@soda.linbit>
Message-ID: <877fgbpt6d.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 05 2016, Lars Ellenberg wrote:

> blk_check_plugged() will return a pointer
> to an object linked on current->plug->cb_list.
>
> That list may "at any time" be implicitly cleared by
> blk_flush_plug_list()
>  flush_plug_callbacks()
> either as a result of blk_finish_plug(),
> or implicitly by schedule() [and maybe other implicit mechanisms?]

I think the only risk here is preemption, so
  preempt_disable() / preempt_enable()
or as you say a spinlock, is sufficient protection.
I would suggest preempt_{dis,en}able for the raid5 code.
Maybe for raid1/raid10 too just for consistency.

>
> If there is no protection against an implicit unplug
> between the call to blk_check_plug() and using its return value,
> that implicit unplug may have already happened,
> even before the plug is actually initialized or populated,
> and we may be using a pointer to already free()d data.
>
> I suggest that both raid1 and raid10 can easily be fixed
> by moving the call to blk_check_plugged() inside the spinlock.
>
> For md/raid5 and btrfs/raid56,
> I'm unsure how (if) this needs to be fixed.
>
> The other current in-tree users of blk_check_plugged()
> are mm_check_plugged(), and mddev_check_plugged().
>
> mm_check_plugged() is already used safely inside a spinlock.
>
> with mddev_check_plugged() I'm unsure, at least on a preempt kernel.

I think this is only an issue on a preempt kernel, and in that case: yes
=2D mddev_check_plugged() needs protection.  Maybe preempt enable/disable
could be done in blk_check_plugged() so those calls which don't
dereference the pointer don't need further protection.
Or maybe blk_check_plugged should have WARN_ON_ONCE(!in_atomic());

>
> Did I overlook any magic that protects against such implicit unplug?

Just the fortunate lack of preemption probably.

>
> Also, why pretend that a custom plug struct (such as raid1_plug_cb)
> may have its member "struct blk_plug_cb cb" at an arbitrary offset?
> As it is, raid1_check_plugged() below is actually just a cast.

Fair point.  I generally prefer container_of to casts because it is more
obviously correct, and type checked.
However as blk_check_plugged performs the allocation, the blk_plug_cb
must be at the start of the containing structure, so the complex tests
for handling NULL are just noise.
I'd be happy for that to be changed.

Thanks,
NeilBrown



>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> ---
>  drivers/md/raid1.c  | 19 +++++++++++++------
>  drivers/md/raid10.c | 21 +++++++++++++--------
>  drivers/md/raid5.c  |  5 +++++
>  fs/btrfs/raid56.c   |  5 +++++
>  4 files changed, 36 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 39fb21e..55dc960 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1044,6 +1044,18 @@ static void raid1_unplug(struct blk_plug_cb *cb, b=
ool from_schedule)
>  	kfree(plug);
>  }
>=20=20
> +static struct raid1_plug_cb *raid1_check_plugged(struct mddev *mddev)
> +{
> +	/* return (struct raid1_plug_cb*)blk_check_plugged(...); */
> +	struct blk_plug_cb *cb;
> +	struct raid1_plug_cb *plug =3D NULL;
> +
> +	cb =3D blk_check_plugged(raid1_unplug, mddev, sizeof(*plug));
> +	if (cb)
> +		plug =3D container_of(cb, struct raid1_plug_cb, cb);
> +	return plug;
> +}
> +
>  static void raid1_make_request(struct mddev *mddev, struct bio * bio)
>  {
>  	struct r1conf *conf =3D mddev->private;
> @@ -1060,7 +1072,6 @@ static void raid1_make_request(struct mddev *mddev,=
 struct bio * bio)
>  					  & (REQ_DISCARD | REQ_SECURE));
>  	const unsigned long do_same =3D (bio->bi_rw & REQ_WRITE_SAME);
>  	struct md_rdev *blocked_rdev;
> -	struct blk_plug_cb *cb;
>  	struct raid1_plug_cb *plug =3D NULL;
>  	int first_clone;
>  	int sectors_handled;
> @@ -1382,12 +1393,8 @@ read_again:
>=20=20
>  		atomic_inc(&r1_bio->remaining);
>=20=20
> -		cb =3D blk_check_plugged(raid1_unplug, mddev, sizeof(*plug));
> -		if (cb)
> -			plug =3D container_of(cb, struct raid1_plug_cb, cb);
> -		else
> -			plug =3D NULL;
>  		spin_lock_irqsave(&conf->device_lock, flags);
> +		plug =3D raid1_check_plugged(mddev);
>  		if (plug) {
>  			bio_list_add(&plug->pending, mbio);
>  			plug->pending_cnt++;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index e3fd725..d7d4397 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1052,6 +1052,18 @@ static void raid10_unplug(struct blk_plug_cb *cb, =
bool from_schedule)
>  	kfree(plug);
>  }
>=20=20
> +static struct raid10_plug_cb *raid10_check_plugged(struct mddev *mddev)
> +{
> +	/* return (struct raid1_plug_cb*)blk_check_plugged(...); */
> +	struct blk_plug_cb *cb;
> +	struct raid10_plug_cb *plug =3D NULL;
> +
> +	cb =3D blk_check_plugged(raid10_unplug, mddev, sizeof(*plug));
> +	if (cb)
> +		plug =3D container_of(cb, struct raid10_plug_cb, cb);
> +	return plug;
> +}
> +
>  static void __make_request(struct mddev *mddev, struct bio *bio)
>  {
>  	struct r10conf *conf =3D mddev->private;
> @@ -1066,7 +1078,6 @@ static void __make_request(struct mddev *mddev, str=
uct bio *bio)
>  	const unsigned long do_same =3D (bio->bi_rw & REQ_WRITE_SAME);
>  	unsigned long flags;
>  	struct md_rdev *blocked_rdev;
> -	struct blk_plug_cb *cb;
>  	struct raid10_plug_cb *plug =3D NULL;
>  	int sectors_handled;
>  	int max_sectors;
> @@ -1369,14 +1380,8 @@ retry_write:
>=20=20
>  			atomic_inc(&r10_bio->remaining);
>=20=20
> -			cb =3D blk_check_plugged(raid10_unplug, mddev,
> -					       sizeof(*plug));
> -			if (cb)
> -				plug =3D container_of(cb, struct raid10_plug_cb,
> -						    cb);
> -			else
> -				plug =3D NULL;
>  			spin_lock_irqsave(&conf->device_lock, flags);
> +			plug =3D raid10_check_plugged(mddev);
>  			if (plug) {
>  				bio_list_add(&plug->pending, mbio);
>  				plug->pending_cnt++;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8ab8b65..4e3b02b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5034,6 +5034,11 @@ static void release_stripe_plug(struct mddev *mdde=
v,
>  	}
>=20=20
>  	cb =3D container_of(blk_cb, struct raid5_plug_cb, cb);
> +/* FIXME
> + * Nothing protects current from being scheduled, which means cb, aka pl=
ug,
> + * may implicitly be "unplugged" any time now, before it even is initial=
ized,
> + * and will then be a pointer to free()d space.
> + */
>=20=20
>  	if (cb->list.next =3D=3D NULL) {
>  		int i;
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 0b7792e..17757d4 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1774,6 +1774,11 @@ int raid56_parity_write(struct btrfs_root *root, s=
truct bio *bio,
>  	cb =3D blk_check_plugged(btrfs_raid_unplug, root->fs_info,
>  			       sizeof(*plug));
>  	if (cb) {
> +/* FIXME
> + * Nothing protects current from being scheduled, which means cb, aka pl=
ug,
> + * may implicitly be "unplugged" any time now, before it even is initial=
ized,
> + * and will then be a pointer to free()d space.
> + */
>  		plug =3D container_of(cb, struct btrfs_plug_cb, cb);
>  		if (!plug->info) {
>  			plug->info =3D root->fs_info;
> --=20
> 1.9.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXBEEKAAoJEDnsnt1WYoG537wP/2yVaYsUd4Yi3A16GJVM+s5g
0F1XkfqUvBKLbSJvqd5R5mxe1deYsguvPjHL1fA11GiBo/RWH4MtGv0MGHTyhqcb
JmqSPT0BPCv40mZrP4BOF15onkXRjDMcIHWU/im/luqkM/E0v2/zH0t+8RT8GYHf
chFPUDyZTmhV9SiMP5C+ym/HOGtHq1AKeGLDv8h1gFo5cFOntlYHZYrozSsn6eHV
l5f3DNu8X3JAJ7V6eXBqf3k6n7IDu7+7oJi/LzjLqfnkwBNRgoeSlvsnoCaAbyiP
IDu+NPzNQAHyXa5+kIv4ZtefFEAhad34CV3jJEkvGtGyAJPI9PT083wNMT7UZeS2
toNGjItuNv86X6+5+OOUUUGccdVq41gzhRqKNgsNr0s54IKH3FpiFyyq8kiU0Q7v
FIqE/8VgU4FM9A2K2NBaN6BFd0ygVsq6ak3FoLvycXbk35HCy12UnCLcxX08obXR
wzMXELbH7qfmQOSjpTVFJlSGB5Xnw024BhIGEhrtEIA4XVlLFzSVbaWu2HNa7dlH
Sm1dCN78z4K7TZKMdqIQtWo3JNm9hOiw9VPCPLbm1OPsELFvy8UKFa1jAcEg94cn
amSPSeHZVFVvE4u/wcTzluLXXNYG73nSyCZiGeWwBNjAs5BodHQKoBclvtDHrDMU
LpiYXMuCn29ktvcfR6qZ
=sEMx
-----END PGP SIGNATURE-----
--=-=-=--
