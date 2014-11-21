Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40328 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750712AbaKUR4Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 12:56:25 -0500
Date: Fri, 21 Nov 2014 12:56:23 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS messes up snapshot LV with origin
Message-ID: <20141121175623.GU17395@hungrycats.org>
References: <CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>
 <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
 <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
 <546B68F8.6080008@ubuntu.com>
 <FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
 <546BA96D.4050805@ubuntu.com>
 <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
 <546CB531.2060509@ubuntu.com>
 <20141121042814.GR17395@hungrycats.org>
 <pan$29e1e$f368f5df$85fe86e7$dd12c3b5@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mgIE+9cwyCTt+85Z"
In-Reply-To: <pan$29e1e$f368f5df$85fe86e7$dd12c3b5@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--mgIE+9cwyCTt+85Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 06:22:57AM +0000, Duncan wrote:
> After all, an LVM block-level snapshot takes the same space as a file=20
> containing the same raw data, and if there's room for the data in an LVM=
=20
> snapshot, given a different layout, there's room for exactly the same=20
> amount of data as a file on a different filesystem, piped thru some=20
> compressor if necessary due to tight datasize constraints.

That isn't true at all.  A repairing fsck can take less than 1% of the
overall volume size, and a full conversion from another filesystem type
can take less than 10%.  Usually I can find enough space by blowing away
the swap LV for a few hours.

I do NOT usually have 13TB of slack space lying around in a 26TB disk
array, nor do I have enough bandwidth to move those 13TB to another
machine without great inconvenience.

> But while other filesystems might allow un-UUIDs (heh, UUUIDs or U3IDs=20
> =3D:^), because they're no longer unique, requiring them to be unique jus=
t=20
> as the label says cannot be considered a bug.  It's simply stricter=20
> enforcement of the rules, which are, after all, plainly stated in the=20
> descriptive name.

It's not a bug as long as I can completely control which devices are
searched for UUIDs, and the system behaves sanely when multiple UUIDs
are found through automatic discovery; otherwise, it's not only a bug,
it's a DoS attack security vulnerability.  Consider what happens if
someone looks at /sys/fs/btrfs, reads the non-secret UUIDs, builds a fake
filesystem with those UUIDs, puts the fake filesystem on a USB stick,
and plugs it back into the victim machine...

> --=20
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--mgIE+9cwyCTt+85Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRvfMcACgkQgfmLGlazG5x2OgCgpEddkt6F0fYHrGMaMseTiRFZ
9kIAn2Oif2EKrIRfThd41lxYIkV9gEuy
=JeYA
-----END PGP SIGNATURE-----

--mgIE+9cwyCTt+85Z--
