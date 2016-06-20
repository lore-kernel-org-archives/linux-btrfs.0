Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34543 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbcFTTLl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 15:11:41 -0400
Date: Mon, 20 Jun 2016 15:11:12 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160620191112.GL15597@hungrycats.org>
References: <20160620034427.GK15597@hungrycats.org>
 <20160620231351.1833a341@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rmUrFcWP4LYae1gV"
In-Reply-To: <20160620231351.1833a341@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rmUrFcWP4LYae1gV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 20, 2016 at 11:13:51PM +0500, Roman Mamedov wrote:
> On Sun, 19 Jun 2016 23:44:27 -0400
> Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:
> From a practical standpoint, [aside from not using Btrfs RAID5], you'd be
> better off shutting down the system, booting a rescue OS, copying the con=
tent
> of the failing disk to the replacement one using 'ddrescue', then removin=
g the
> bad disk, and after boot up your main system wouldn't notice anything has=
 ever
> happened, aside from a few recoverable CRC errors in the "holes" on the a=
reas
> which ddrescue failed to copy.

I'm aware of ddrescue and myrescue, but in this case the disk has failed,
past tense.  At this point the remaining choices are to make btrfs native
raid5 recovery work, or to restore from backups.

> But in general it's commendable that you're experimenting with doing thin=
gs
> "the native way", as this is provides feedback to the developers and coul=
d help
> make the RAID implementation better. I guess that's the whole point of the
> exercise and the report, and hope this ends up being useful for everyone.

The intent was both to provide a cautionary tale for anyone considering
deploying a btrfs raid5 system today, and to possibly engage some
developers to help solve the problems.

The underlying causes seem to be somewhat removed from where the symptoms
are appearing, and at the moment I don't understand this code well enough
to know where to look for them.  Any assistance would be greatly appreciate=
d.


> --=20
> With respect,
> Roman



--rmUrFcWP4LYae1gV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldoP9AACgkQgfmLGlazG5yp1gCfQ6TzhMWOn2l0YgAeyZNsjCrW
ElwAnRD8D0NfSCxpy5QHlNntzGge7RBh
=iAYU
-----END PGP SIGNATURE-----

--rmUrFcWP4LYae1gV--
