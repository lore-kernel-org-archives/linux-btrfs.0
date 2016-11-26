Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46160 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750976AbcKZSyE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 Nov 2016 13:54:04 -0500
Date: Sat, 26 Nov 2016 13:54:02 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
Message-ID: <20161126185402.GK8685@hungrycats.org>
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
 <94606bda-dab0-e7c9-7fc6-1af9069b64fc@inwind.it>
 <f814eb1b-844b-2ace-c948-3be20da2fd29@cn.fujitsu.com>
 <a75c9a72-148c-9fbd-dfb8-7cde58bee9c9@inwind.it>
 <20161125043119.GG8685@hungrycats.org>
 <cd7ee5cc-d384-7c9c-d656-cef2569b749a@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ee6FjwWxuMujAVRe"
In-Reply-To: <cd7ee5cc-d384-7c9c-d656-cef2569b749a@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ee6FjwWxuMujAVRe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 26, 2016 at 02:12:56PM +0100, Goffredo Baroncelli wrote:
> On 2016-11-25 05:31, Zygo Blaxell wrote:
> >>> Do you mean, read the corrupted data won't repair it?
> >>>
> >>> IIRC that's the designed behavior.
> >> :O
> >>
> >> You are right... I was unaware of that....
> > This is correct.
> >=20
> > Ordinary reads shouldn't touch corrupt data, they should only read
> > around it.  Scrubs in read-write mode should write corrected data over
> > the corrupt data.  Read-only scrubs can only report errors without
> > correcting them.
> >=20
> > Rewriting corrupt data outside of scrub (i.e. on every read) is a
> > bad idea.  Consider what happens if a RAM controller gets too hot:
> > checksums start failing randomly, but the data on disk is still OK.
> > If we tried to fix the bad data on every read, we'd probably just trash
> > the filesystem in some cases.
>=20
>=20
>=20
> I cant agree. If the filesystem is mounted read-only this behavior may
> be correct; bur in others cases I don't see any reason to not correct
> wrong data even in the read case. If your ram is unreliable you have
> big problem anyway.

If you don't like RAM corruption, pick any other failure mode.  Laptops
have to deal with things like vibration and temperature extremes which
produce the same results (spurious csum failures and IO errors under
conditions where writing will only destroy data that would otherwise
be recoverable).

> The likelihood that the data contained in a disk is "corrupted" is
> higher than the likelihood that the RAM is bad.
>
> BTW Btrfs in RAID1 mode corrects the data even in the read case. So

Have you tested this?  I think you'll find that it doesn't.

> I am still convinced that is the RAID5/6 behavior "strange".
>=20
> BR
> G.Baroncelli
> --=20
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
>=20

--ee6FjwWxuMujAVRe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg52kkACgkQgfmLGlazG5zv6ACdE1oPHMxAREcZ1QnFMtQdjE38
ktoAn3J4Kf/9SttGWuWl1RH7jpwK/Stn
=oPq2
-----END PGP SIGNATURE-----

--ee6FjwWxuMujAVRe--
