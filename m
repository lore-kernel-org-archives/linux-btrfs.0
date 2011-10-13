From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Honest timeline for btrfsck
Date: Thu, 13 Oct 2011 12:37:25 +0100
Message-ID: <20111013113725.GF21931@carfax.org.uk>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
 <CA+JuuGo-iREXO4cZKT61tHZMTAr_edBv=O51-uSA7Bgynbgu6w@mail.gmail.com>
 <4E8F1128.4000508@redhat.com>
 <201110132228.07805.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aZoGpuMECXJckB41"
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201110132228.07805.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--aZoGpuMECXJckB41
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 13, 2011 at 10:28:01PM +1100, Chris Samuel wrote:
> On Saturday 08 October 2011 01:48:08 Josef Bacik wrote:
> 
> > [...]  Fsck has the
> > potential to make any users problems worse, and given the
> > increasing number of people putting production systems on btrfs
> > with no backups the idea of releasing a unpolished and not fully
> > tested fsck into the world is terrifying, and would likely cause
> > long term "I heard that file system's fsck tool eats babies" sort
> > of reputation.
> 
> ...and, for instance, it was one of the criticisms levelled at
> reiserfs (v3) that its fsck implementation was rather brain dead
> in some ways - it couldn't distinguish files contained in an image
> of a reiserfs filesystem from those in the reiserfs filesystem that
> the image file was in, plus it could discover files from a previous 
> reiserfs filesystem after it had been reformatted (as reiserfs).
> 
> http://en.wikipedia.org/wiki/ReiserFS#fsck
> 
> Chris worked on reiserfs, so he probably doesn't really want to
> go through all that again..

   Fortunately, that particular problem is not an issue with btrfs, as
it has the UUID of the filesystem in every metadata block. Only if you
manage to take a partial image of the FS and copy it into the FS it's
an image of would you get that particular issue -- and even then, the
clone would have older generation numbers in its blocks than the FS
containing it.

   On the other hand, btrfs does have some new complications of its
own, which lead to additional difficulties. Cloning a btrfs filesystem
with dd, for example, doesn't change the UUID, which can confuse some
of the tools -- but btrfs isn't unique in that (see the recent "Linux
Plumbers" thread).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "He's a nutcase, you know. There's no getting away from it -- ---  
                     he'll end up with a knighthood"                     

--aZoGpuMECXJckB41
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOls11IKyzvlFcI40RAvrZAJ9rc2ettyUJLaAG4i5E0yCwX2gYRQCeOfaX
ZUAHOjZQ7zXchU83C91AeT4=
=QtOk
-----END PGP SIGNATURE-----

--aZoGpuMECXJckB41--
