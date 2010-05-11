From: Bruce Guenter <bruce@untroubled.org>
Subject: Re: Disk space accounting and subvolume delete
Date: Tue, 11 May 2010 09:45:18 -0600
Message-ID: <20100511154518.GA11710@untroubled.org>
References: <20100510182352.GA21154@untroubled.org>
 <AANLkTilDHeJ_aRQSKWUTJgIBhlpLHyNRTy4x4ai_MGJI@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTilDHeJ_aRQSKWUTJgIBhlpLHyNRTy4x4ai_MGJI@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 11, 2010 at 08:10:38AM +0800, Yan, Zheng  wrote:
> This is because the snapshot deleting ioctl only removes the a link.

Right, I understand that.  That part is not unexpected, as it works just
like unlink would.  However...

> The corresponding tree is dropped in the background by a kernel thread.

The surprise is that 'sync', in any form I was able to try, does not
wait until all or even most of the I/O is completed.  Apparently the
standards spec for sync(2) says it is not required to wait for I/O to
complete, but AFAIK all other Linux FS do wait (the man page for sync(2)
implies as much, as does the info page for sync in glibc).

The only way I've found so far to force this behavior is to unmount, and
that's rather intrusive to other users of the FS.

> We could probably add another ioctl that waits until the tree has been
> completely dropped.

Since the expected behavior for sync is to wait until all pending I/O
has been completed, I would argue this should be the default action for
sync.  Am I misunderstanding something?

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkvpe44ACgkQ6W+y3GmZgOh0awCdGDcTnryaH9jLTIHNTTCyTV0p
sDUAn34lqPSg3e6CzW/haTewk1QG3q2a
=30hN
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
