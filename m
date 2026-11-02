Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=174.142.148.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793587061;
	b=0rLZBEjZM7zanGqfEkLbxHBI7GubEr/EvBth3NvAw07/HioDYFCwmizOgs3CwbREUyL4
	 b7DMNuYATmxmPYpsfF4Jd05gOVN17fMksQ0oBx5jNF9u7pjyFpZklHK/N/NFdaZqz8j42
	 fthftlainehij9UaZGf8Gvrodu6PyWm7RjZGDp/LUmld2zw+ANVIED1BLaMbbBdnViCtW
	 lnxoSinL3xZdfZgtgvK0+TLtnOC4/mMl+pxT3huhnNwuVqivJX2aWVI91Fn6EvWeGBpHc
	 S1xOaxHr5tBXte2z7YLlDX5AF22ZqqGIeaNM2cKEO2lvcIHVRhp7tcFeaiqlkLsrXpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793587061;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=yKtn0THsh/EqjwUTNUjdpUBT5vowFP8psRWqGxPIf/Q=;
	b=behDgNXJC0DrHKC88UBqEO1PXzCS8GJ7nzkn7q9+74UksB0x4sibotX+57ibxmfu4b0Z
	 0Gy7EmbSgu+MUhoTTwU0ejzE4TxS92jrm7kF6TyUpe2wNcH9m4gZkivftIEmGocNFEvbh
	 aYsk1G+AJHHyEkGDT1UHTrFkKZugzbKsCM+iPLMWNJirpvwQ9XyvBPfz2+7dJSMnhkXzn
	 T2vj73kEMRpLkMdeZgZPoK0cEWnDtsn8L+/C25uE8wmpG3xmK7dN3IoQkYn419I6O6CUt
	 n7EVZHUNEZGTJ5gr+tz6kKhNmBaCP/gOHhiC6xektwWJHHKvXxK8ucVJQ/sRSYkWgQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=umail.furryterror.org;
	spf=pass smtp.mailfrom=drax.hungrycats.org;
	arc=none smtp.remote-ip=174.142.148.226
Received: from drax.kayaks.hungrycats.org (drax.kayaks.hungrycats.org [174.142.148.226])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25FC5606A324;
	Mon,  2 Nov 2026 02:37:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25FC5606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=drax.hungrycats.org
Received: by drax.kayaks.hungrycats.org (Postfix, from userid 1002)
	id 1F4CB1C91D64; Sun, 01 Nov 2026 21:37:33 -0500 (EST)
Date: Sun, 1 Nov 2026 21:37:33 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>, Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] btrfs: don't drop the error of the last split bio
Message-ID: <auf3bY9j9y6Fsuho@hungrycats.org>
References: <20261030-b4-btrfs-data-integrity-v1-0-f4d4196731e6@toxicpanda.com>
 <20261030-b4-btrfs-data-integrity-v1-1-f4d4196731e6@toxicpanda.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20261030-b4-btrfs-data-integrity-v1-1-f4d4196731e6@toxicpanda.com>

On Fri, Oct 30, 2026 at 02:38:07PM +0000, Josef Bacik wrote:
> When a btrfs_bio had to be split, btrfs_bio_end_io() saves the first error
> of any of its parts in the status field of the original btrfs_bio. The
> part that completes last is supposed to load it into bi_status of the
> original bio before calling the end_io handler, but that is only done if
> that last part was successful:
>=20
> 	if (atomic_dec_and_test(&bbio->pending_ios)) {
> 		/* Load split bio's error which might be set above. */
> 		if (status =3D=3D BLK_STS_OK)
> 			bbio->bio.bi_status =3D READ_ONCE(bbio->status);
>=20
> If the last part failed, the assumption is that bi_status was set at the
> top of the function. That is true if the last part is what is left of the
> original bio. If it is a split bio, the assignment was done to the split
> bio, which was freed right after. If the original bio has completed before
> without an error, its bi_status is BLK_STS_OK and stays like that:
>=20
>   original bio (tail)                 split bio (head)
>=20
>   btrfs_bio_end_io(orig, OK)
>     orig->bio.bi_status =3D OK
>     pending_ios 2 -> 1
>                                       btrfs_bio_end_io(split, IOERR)
>                                         split->bio.bi_status =3D IOERR
>                                         bio_put(split)
>                                         cmpxchg(&orig->status, OK, IOERR)
>                                         pending_ios 1 -> 0
>                                         orig->end_io(), bi_status is OK
>=20
> The end_io handler covers the whole range, so for a buffered read all the
> folios are marked uptodate, including the ones that were never filled, and
> read(2) returns their content instead of -EIO. For a write the ordered
> extent is completed as if all the data had reached the device.
>=20
> This can be reproduced with raid0 data on two devices, one of them slower
> than the other and with a bad block, by reading a file whose last stripe
> is on the fast device.

I've been running an identical patch because the same bug causes
undetected data corruption on raid56.

A read that fails csum verification completes only after read repair has
tried every mirror.  This takes far longer than the healthy splits of the
same bio, so the failing split completes last almost every time.

On a degraded raid56 read, the result is corruption that is not reported
to userspace.  raid56 reads are split at stripe boundaries, so any read
that crosses a boundary can return a sector that failed its csum check
to userspace as zeros, with no error.  The csum failure is logged in
dmesg because the device stats are updated (so the corruption is not
strictly silent), but the read succeeds.  A 4K read of the same sector
is not split, and correctly returns EIO.

The data in that sector is unrecoverable either way.  The change only
affects what userspace is told when it reads the data, i.e. EIO instead
of a read that returns junk while claiming success.

Reproducer: on a raid5 filesystem, corrupt one stripe row's parity,
leaving the data intact, then withhold one data member of that row and
mount degraded.  Reconstructing the missing column then yields wrong
bytes for that column.  Every other column still works.  Reads of 64K or
more over that range return zeros and succeed, while 4K reads return EIO.

Tested-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>

> The saved status has the first error of all the parts, or BLK_STS_OK if
> there was none, so always use it.
>=20
> Fixes: d48e1dea3931 ("btrfs: fix error propagation of split bios")
> CC: stable@vger.kernel.org # 6.12+
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/bio.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 2c6234f6182f..fc0b021cdefb 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -127,9 +127,12 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_st=
atus_t status)
>  		cmpxchg(&bbio->status, BLK_STS_OK, status);
> =20
>  	if (atomic_dec_and_test(&bbio->pending_ios)) {
> -		/* Load split bio's error which might be set above. */
> -		if (status =3D=3D BLK_STS_OK)
> -			bbio->bio.bi_status =3D READ_ONCE(bbio->status);
> +		/*
> +		 * Load the first error, if any. It may come from a split bio,
> +		 * including the one we were called for, in which case nothing
> +		 * stored it in the original bio yet.
> +		 */
> +		bbio->bio.bi_status =3D READ_ONCE(bbio->status);
> =20
>  		if (bbio_has_ordered_extent(bbio)) {
>  			struct btrfs_ordered_extent *ordered =3D bbio->ordered;
>=20
> --=20
> 2.55.0
>=20
>=20
