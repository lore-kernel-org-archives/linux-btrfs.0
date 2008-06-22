From: "Joshua J. Berry" <des@condordes.net>
Subject: Re: [PATCH] COW and checksumming ioctls
Date: Sun, 22 Jun 2008 11:13:45 -0700
Message-ID: <200806221113.57846.des@condordes.net>
References: <1213921608.27507.152.camel@BVR-FS.beaverton.ibm.com> <20080621072730.GA20871@infradead.org> <1214143806.10187.538.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3214060.G0AR6LP4nD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1214143806.10187.538.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3214060.G0AR6LP4nD
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 22 June 2008 07:10:06 Chris Mason wrote:
> On Sat, 2008-06-21 at 03:27 -0400, Christoph Hellwig wrote:
> > Synthetic xattrs are a really utterly horrible interface.  Xattrs on
> > disk are nice and simple, but the Linux invention of making some up
> > on the fly, starting with the Posix ACL interface makes the
> > implementation not just utterly complicated but also confuses backup
> > programs.
>
> The idea is that backup programs already know how to do xattrs and can
> easily be changed to preserve them.  Every ioctl interface we
> create/make up has to be handed coded into the backup program.
>
> I know xattrs are ugly, but we need to weigh the cost of the perfect
> interface with the availability of a common one.  Dave Chinner had
> talked about using xattrs to control file behavior in XFS as well, not
> sure if that ever happened.

+1 for xattrs.  From a user perspective, they're simpler than futzing aroun=
d=20
with special btrfs programs to set/unset attributes, and as Chris points ou=
t,=20
having backup programs pick them up is a good thing.

If virtual xattrs are so complicated/messy to implement, perhaps they shoul=
d=20
be made simpler.  I honestly can't think of a better interface for somethin=
g=20
like this.

=2D- Josh


=2D-=20
Joshua J. Berry

"I haven't lost my mind -- it's backed up on tape somewhere."
    -- /usr/games/fortune


--nextPart3214060.G0AR6LP4nD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhelmUACgkQaIxeYlQMsxsI7gCdFtGQWsL0lDUiwN8tyv35X6bu
d4YAniJC6otPnPDAXI3exyJnQsnNBauP
=l4Iw
-----END PGP SIGNATURE-----

--nextPart3214060.G0AR6LP4nD--
