Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33154 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751026AbcFXCRS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 22:17:18 -0400
Date: Thu, 23 Jun 2016 22:17:17 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160624021717.GR15597@hungrycats.org>
References: <20160620034427.GK15597@hungrycats.org>
 <20160620231351.1833a341@natsu>
 <20160620191112.GL15597@hungrycats.org>
 <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org>
 <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
 <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <CAJCQCtT57k7Mirq=d6wTewY6EzvJE0g28EbmG9wLk+6cTASEEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vr2UxLU0KdcKBaxP"
In-Reply-To: <CAJCQCtT57k7Mirq=d6wTewY6EzvJE0g28EbmG9wLk+6cTASEEg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Vr2UxLU0KdcKBaxP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 23, 2016 at 05:37:09PM -0600, Chris Murphy wrote:
> > I expect that parity is in this data block group, and therefore is
> > checksummed the same as any other data in that block group.
>=20
> This appears to be wrong. Comparing the same file, one file only, one
> two new Btrfs volumes, one volume single, one volume raid5, I get a
> single csum tree entry:
>=20
> raid5
>     item 0 key (EXTENT_CSUM EXTENT_CSUM 12009865216) itemoff 16155 itemsi=
ze 128
>         extent csum item
>=20
> single
>=20
>     item 0 key (EXTENT_CSUM EXTENT_CSUM 2168717312) itemoff 16155 itemsiz=
e 128
>         extent csum item
>=20
> They're both the same size. They both contain the same data. So it
> looks like parity is not separately checksummed.

I'm inclined to agree because I didn't find any code that *writes* parity
csums...but if there are no parity csums, what does this code do?

scrub.c:
	static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
	[...]
			ret =3D btrfs_lookup_csums_range(csum_root,
						extent_logical,
						extent_logical + extent_len - 1,
						&sctx->csum_list, 1);
			if (ret)
				goto out;

                        ret =3D scrub_extent_for_parity(sparity, extent_log=
ical,
                                                      extent_len,
                                                      extent_physical,
                                                      extent_dev, flags,
                                                      generation,
                                                      extent_mirror_num);


--Vr2UxLU0KdcKBaxP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldsmC0ACgkQgfmLGlazG5wnlgCfQhBfP5IyS63gfCm3W4TY8xRn
S0QAn26Dxb7bjZfgpWFO9mHnTLvINuRP
=rPKr
-----END PGP SIGNATURE-----

--Vr2UxLU0KdcKBaxP--
