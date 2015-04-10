Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbbDJBYx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Apr 2015 21:24:53 -0400
Date: Fri, 10 Apr 2015 11:24:31 +1000
From: NeilBrown <neilb@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH/RFC] fscache/cachefiles versus btrfs
Message-ID: <20150410112431.0e9c337d@notabene.brown>
In-Reply-To: <29536.1428571388@warthog.procyon.org.uk>
References: <20150409174916.5a2efef5@notabene.brown>
	<29536.1428571388@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/i0mcU6N_vGSQ8c9srrzJZYK"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/i0mcU6N_vGSQ8c9srrzJZYK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 09 Apr 2015 10:23:08 +0100 David Howells <dhowells@redhat.com> wrot=
e:

> NeilBrown <neilb@suse.de> wrote:
>=20
> >  Is there a better way?  Could a better way be created?  Maybe
> >  SEEK_DATA_RELIABLE ??
>=20
> fiemap() maybe?
>=20
> > Also, if you do try to use fscache on btrfs with 3.19, then nothing gets
> > cached (as expected) and with a heavy load you can lose a race and get =
an
> > asserting fail in fscache_enqueue_operation
>=20
> Do you have the patches here applied?
>=20
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=
=3Dfscache-fixes
>=20

Do I don't.  I had looked through them and while they did seem to be
addressing similar sorts of races, nothing seems like an obvious match.
I haven't been able to reproduce the BUG_ON myself.  I only have a report
of it repeatedly affecting someone else:

  https://bugzilla.opensuse.org/show_bug.cgi?id=3D908706

I'll probably have to be happy with fixing usage on btrfs, and hope the oth=
er
bug is fixed already or doesn't become a problem.

Thanks,
NeilBrown

--Sig_/i0mcU6N_vGSQ8c9srrzJZYK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVScmUjnsnt1WYoG5AQKtiQ//RyQZL+xjc9VlH+3En/EhfGjsuN7zI2Gi
74P9oEqevkbsKPZXOIuGSuvcMtXG5xNfbUT7pESXkAHNd7s/0HXRjgLS6uJCtLGX
VxV+OplszX1E5Ikgm6zaTJkgYNlHXr4V046L8gUjSGZd2paC6GIK85aR4RUNHFLC
lL1Dt7mwzF6vUbSO5+5aLyMBYfazv2gvFgW5+c1kZgd7DrFxE83/kvOuXYRYX9eb
rJcds6x6/tJI2hJseMd1s10Bz9FmnUycooiobOVonbESs9TDDwTMYzj2cUiewmCc
qhaAduZ0LcMdb30VW6Py7LDQkoSsuqDaVRKWP5JXKTVKAcWwW1qbDsLcA5NZ5gtI
/TDiDnDw5T+i2isvRz5Lr+1Msx8axfuq3g3AAlnRdb+VOMeg2uNI2ecY6tecWF7z
JTaojkOPb64z6qBJOpBs1sEQwmbecAQViSgYEoPqUcH38w0HFyJrCwq1Bvid+HsX
xhD49ZgRA2AZ8wwsE9qkVC3hFfQfkWFHCk7uXpP69HhliQSwG1BPM35BT4sN75AQ
ne/hEfS59nO7rLenNucijOMEMG9WhMR/euO7nJgSxNRj3z3iM82ah/+tkH3gXsos
4cjOR8+ycOoVWNVXK/oItayjKzkjMky0hOyeKoHj1Iq9XNDhKWdZojIFpW4EFslB
hhu7pl53NzE=
=UO3h
-----END PGP SIGNATURE-----

--Sig_/i0mcU6N_vGSQ8c9srrzJZYK--
