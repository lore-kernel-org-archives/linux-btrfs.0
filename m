From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: [patch 0/2] Control filesystem balances (kernel side)
Date: Mon, 1 Nov 2010 13:05:58 +0000
Message-ID: <20101101130558.GB4709@vlad.carfax.org.uk>
References: <20101030000726.286517546@carfax.org.uk>
 <201010301944.35962.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010301944.35962.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 30, 2010 at 07:44:35PM +0200, Goffredo Baroncelli wrote:
> On Saturday, 30 October, 2010, Hugo Mills wrote:
> >    One fundamental question, though -- is the progress monitor
> > function best implemented as an ioctl, as I've done here, or should it
> > be two or three sysfs files? I'm thinking of /proc/mdstat...
> > Obviously, /proc/mdstat would never get into /sys, but exposing the
> > "expected" and "remaining" values as files has an attractive
> > simplicity to it.
> 
> I like the idea that these info should be put under sysfs. Something like
> 
> /sys/btrfs/<filesystem-uuid>/

/sys/fs/btrfs/<uuid> I think. Also:
/sys/fs/btrfs/<label> as a symlink to the <uuid> directory.

>                              balance	-> info on balancing

For the one-value-per-file rule of sysfs, this should probably be
balance_expected and balance_completed, each holding a count of block
groups.

>                              devices	-> list of device (a directory of
>                                            links or a file which contains 
>                                            the list of devices)
>                              subvolumes/ -> info on subvolume(s)
>                              label       -> label of the filesystem
>                              <other btrfs filesystem related knoba>

   The other one that struck me earlier today as being useful was
tracking the progress of a dev delete operation. But that'll come
later.

> Obviously we need another btrfs command to extract an uuid from a btrfs 
> filesystem like:
> 
> # btrfs filesystem get-uuid /path/to/a/btrfs/filesystem
> f9b9c413-0dc8-4e3f-94f2-86faa702f519

   Possibly a slightly more general "fi metadata" with switches for
UUID and label?

# btrfs fi metadata [-u|--uuid] /path
# btrfs fi metadata [-l|--label] /path

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- Is a diversity twice as good as a university? ---          

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFMzrs2IKyzvlFcI40RAgwKAJ49tegu6ODpsYSBduCpndMi+5tcgQCg0kxB
NB+Rr8H3xoHGEY4NeflZbXY=
=foV4
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
