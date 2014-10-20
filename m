Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48212 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751814AbaJTNJk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 09:09:40 -0400
Date: Mon, 20 Oct 2014 09:02:44 -0400
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: strange 3.16.3 problem
Message-ID: <20141020130243.GB29401@hungrycats.org>
References: <201410181454.19375.russell@coker.com.au>
 <pan$9907e$9b197fe7$2a806862$700ddfa7@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
In-Reply-To: <pan$9907e$9b197fe7$2a806862$700ddfa7@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2014 at 04:38:28AM +0000, Duncan wrote:
> Russell Coker posted on Sat, 18 Oct 2014 14:54:19 +1100 as excerpted:
>=20
> > # find . -name "*546"
> > ./1412233213.M638209P10546 # ls -l ./1412233213.M638209P10546 ls: cannot
> > access ./1412233213.M638209P10546: No such file or directory
>=20
> Does your mail server do a lot of renames?  Is one perhaps stuck?  If so,=
=20
> that sounds like the same thing "Zygo Blaxell" is reporting in the=20
> "3.16.3..3.17.1 hang in renameat2()" thread, OP on Sun, 19 Oct 2014=20
> 15:25:26 -400, Msg-ID: <20141019192525.GA29401@hungrycats.org>, as linked=
=20
> here:
>=20
> <http://permalink.gmane.org/gmane.comp.file-systems.btrfs/39539>
>=20
> I pointed him at this thread too.  I hadn't seen you mention a hung=20
> rename, but the other symptoms sound similar.

Not really.  It looks like Russell having a NFS client-side problem,
I'm having a server-side one (maybe).  Also, all Russell's system calls
seem to be returning promptly, while some of mine are not.  Even if
there were timeouts, an NFS server timeout gives a different error than
'No such file or directory'.  Finally, the one and only thing I _can_
do with my bug is 'ls' on the renamed files (for me, the find would get
stuck before returning any output).

For Russell's issue...most of the stuff I can think of has been
tried already.  I didn't see if there was any attempt try to ls the
file from the NFS server as well as the client side.  If ls is OK on
the server but not the client, it's an NFS issue (possibly interacting
with some btrfs-specific quirk); otherwise, it's likely a corrupted
filesystem (mail servers seem to be unusually good at making these).

Most of the I/O time on mail servers tends to land in the fsync() system
call, and some nasty fsync() btrfs bugs were fixed in 3.17 (i.e. after
3.16, and not in the 3.16.x stable update for x <=3D 5 (the last one
I've checked)).  That said, I'm not familiar with how fsync() translates
over NFS, so it might not be relevant after all.

If the NFS server's view of the filesystem is OK, check the NFS protocol
version from /proc/mounts on the client.  Sometimes NFS clients will
get some transient network error during connection and fall back to some
earlier (and potentially buggier) NFS version.  I've seen very different
behavior in some important corner cases from v4 and v3 clients, for
example, and if the client is falling all the way back to v2 the bugs
and their workarounds start to get just plain _weird_ (e.g. filenames
which produce specific values from some hash function or that contain
specific character sequences are unusable).  v2 is so old it may even
have issues with 64-bit inode numbers.


--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRFB+sACgkQgfmLGlazG5yR/QCfUtw9oFkhlwALCnInLrsAOo80
lCAAnRuwHsrDspvAZbQV5XG942uDO4ef
=+Fjs
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
