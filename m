From: Tracy Reed <treed@ultraviolet.org>
Subject: Re: kernel bug in file-item.c
Date: Wed, 29 Apr 2009 12:32:07 -0700
Message-ID: <20090429193207.GK26602@tracyreed.org>
References: <49F73F69.4010205@oel.state.nj.us> <1240946633.15136.55.camel@think.oraclecorp.com> <49F87A7F.7090804@oel.state.nj.us> <1241027618.20099.48.camel@think.oraclecorp.com> <49F89AB4.2090001@oel.state.nj.us> <1241029841.20099.53.camel@think.oraclecorp.com> <49F89E91.3020604@oel.state.nj.us> <1241030419.20099.55.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tpXmNJJzF/fVXUEg"
Cc: mroconnor@oel.state.nj.us, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1241030419.20099.55.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>


--tpXmNJJzF/fVXUEg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2009 at 02:40:19PM -0400, Chris Mason spake thusly:
> Well, then I'm surprised btrfs doesn't crash more violently and more
> often ;)

Note that this will be a problem that btrfs must properly manage. And
it must be done MUCH better than a certain previously semi-popular
filesystem did. The expectation needs to be set that due to the much
more complicated in-memory structures being used by modern filesystems
that your hardware must be rock solid or you will get filesystem
corruption. I ran the other filesystem on hundreds of machines with no
problem (all solid hardware) but I regularly run into people (just
this morning, for example) who swear that *every*single*time* they
created a filesystem with that other fs it was corrupted in a short
amount of time. It just doesn't add up. First impressions and early
rumors can doom a filesystem (although clearly other factors such as
personalities and politics can be at play as well).

> Do you think you're hitting a memtest bug or is the HW really bad?

A bug in memtest? It's been rock solid for years hasn't it? Maybe some
new memory configuration or MMU might freak it out. Seems quite
unlikely compared to the chances of actually having bad RAM.

--=20
Tracy Reed
http://tracyreed.org

--tpXmNJJzF/fVXUEg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFJ+Ks39PIYKZYVAq0RAqhCAJ9CH3BJCGtrloW+RRPue0bDm+10QgCgkwp4
Mx4FySgzIJFSBAuW3V3icbA=
=hKt+
-----END PGP SIGNATURE-----

--tpXmNJJzF/fVXUEg--
