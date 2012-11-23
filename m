Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56373 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab2KWUyy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Nov 2012 15:54:54 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so4023387bkw.19
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Nov 2012 12:54:53 -0800 (PST)
Date: Fri, 23 Nov 2012 23:54:32 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: bo.li.liu@oracle.com
Cc: btrfs <linux-btrfs@vger.kernel.org>, Marios Titas <redneb8888@gmail.com>,
        dsterba@suse.cz, Chris Mason <chris.mason@fusionio.com>
Subject: Re: per-file NOCOW in 3.7
Message-ID: <20121123235432.1fd1099e@sf>
In-Reply-To: <20121122011653.GC3327@gmail.com>
References: <CAAdM647=qHnkfk=3c2hhGk61_-Jge02yxbj6nNVAqmEf+BJA-g@mail.gmail.com>
	<20121121172511.GC3102@twin.jikos.cz>
	<20121122011653.GC3327@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BatWFtm.54vuUQNTma3S4=T"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/BatWFtm.54vuUQNTma3S4=T
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> > > According to the tentative changelog in the wiki, 3.7 will properly
> > > support per-file NOCOW. I think this is misleading. In particular, it
> > > still does not work correctly in the case when the NOCOW flag of a new
> > > flag is being inherited from the directory. I think it would be better
> > > to remove that item from the changelog until the the fix [1] is
> > > merged.
> > > [1] https://patchwork.kernel.org/patch/1438431/
> >=20
> > You're right, the patch is not in 3.7-rc nor in btrfs-next, and fixes a
> > real bug.
> >=20
> > Technically it is a regresssion within the 3.7 cycle (so it could even
> > go to a late -rc), in any case it's a small change that could also go
> > through the stable tree.
> >=20
> > david
>=20
> Well, I'll resend it for merge with Marios's reported-by and your Reviewe=
d-by.
>=20
> Don't worry, it's a good fix though.

I'm using your patch on 2 boxes for 2 months.
It is the only way to get decent performance
on my workload.

Thanks for the patch!

Tested-by: Sergei Trofimovich <slyich@gmail.com>

--=20

  Sergei

--Sig_/BatWFtm.54vuUQNTma3S4=T
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlCv4osACgkQcaHudmEf86qD8ACfdAFgzY9ndAvmXu3hWckDj5u/
iqIAnRnhDRUsszKiQ814rQMD57+zyup2
=83ft
-----END PGP SIGNATURE-----

--Sig_/BatWFtm.54vuUQNTma3S4=T--
