From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Any chance to recovery btrfs raid-0 after accidental format of
 one volume?
Date: Wed, 7 Sep 2011 00:12:35 +0100
Message-ID: <20110906231235.GA30208@carfax.org.uk>
References: <CAKdoYmDNjBDgHjLNaf5HmrRxGkYPXjssZoGa3Tb4p3uc2DcOcg@mail.gmail.com>
 <CAKdoYmAsSa5Qdp_S_XrhVjHyDhGwmNcH=Vw0wFq0oRMvm0medA@mail.gmail.com>
 <CAKdoYmDv0GcEKOnkjMuZG40VtR2KzzzwVu33srr8a-taJ_VhQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Cc: linux-btrfs@vger.kernel.org
To: Dante <danteinbrisbane@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKdoYmDv0GcEKOnkjMuZG40VtR2KzzzwVu33srr8a-taJ_VhQQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 07, 2011 at 09:00:21AM +1000, Dante wrote:
> > > Bad case of user error here but I managed to reformat one half of a
> > > btrfs volume that was set up with metadata raid-1 and data raid-0.
> 
> > It won't help you - but did you format it with mkfs.btrfs, while it was mounted?
> 
> No I formatted as ext4 while off-line.
> 
> Thanks for the feedback.
> 
> I guess I just kiss the files goodbye and move on.

   In this instance, it's almost certainly going to be faster to
recover from your backups than it is to attempt to reconstruct the few
files that you can from the bits that aren't missing.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Don't worry, he's not drunk. He's like that all the time. ---    

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOZqjjIKyzvlFcI40RAuqeAJ49a7kgK6nLRJqS6zNGXlPdxGKtNACfRGmP
5QlVWsjxa87PiqhL0eXPr84=
=M4WN
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
