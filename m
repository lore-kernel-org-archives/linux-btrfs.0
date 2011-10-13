From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: is space really freed after deleting large subvolume?
Date: Thu, 13 Oct 2011 17:21:04 +0100
Message-ID: <20111013162104.GG21931@carfax.org.uk>
References: <CAJ1PRSmDmd4mrUaQAhjCt1SMtVaBVxq3dCVjCuT20Y4Wf+Ch+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6BvahUXLYAruDZOj"
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com " <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRSmDmd4mrUaQAhjCt1SMtVaBVxq3dCVjCuT20Y4Wf+Ch+Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--6BvahUXLYAruDZOj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 13, 2011 at 06:14:03PM +0200, krzf83@gmail.com  wrote:
> I'm wondering is space really freed after deleting large subvolume?

   Yes, although if you have snapshots, you may not recover very much
space, as [some of] the data on the subvolume may still be in use by
other snapshots.

> Will space be immediately available to other data like other
> subvolumes?

   No, subvolume deletion is done in the background, and the space
recovered will be returned for use relatively slowly. This is because
the FS has to go through the metadata, updating reference counts for
each extent in the subvolume to work out whether the space can be
recovered or not.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Klytus! Are your men on the right pills? Maybe you should ---    
                         execute their trainer!                          

--6BvahUXLYAruDZOj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOlw/wIKyzvlFcI40RAtvXAJ9UWkykEguJDof8XQmqVSa3CIIsrwCgzYlp
lRIkpja4qa8fJipEwAafZIY=
=/zSd
-----END PGP SIGNATURE-----

--6BvahUXLYAruDZOj--
