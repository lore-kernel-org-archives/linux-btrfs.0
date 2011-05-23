From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Mixed RAID 1 and 0 in different subvolumes?
Date: Mon, 23 May 2011 22:05:19 +0100
Message-ID: <20110523210518.GA30819@carfax.org.uk>
References: <20110523200621.GA25362@mandarb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Omen Wild <omen+btrfs@mandarb.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110523200621.GA25362@mandarb.com>
List-ID: <linux-btrfs.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 23, 2011 at 01:06:21PM -0700, Omen Wild wrote:
> Is there a way to mix RAID 1 and 0 in different subvolumes?  I am a new
> user to btrfs and would like to protect the important files with
> mirroring, but have a bulk area that is striped for speed and size.

   Not yet.

> For example I want / and /home to be mirrored, but /media can just be
> striped as it is all data I can easily recreate.
> 
> I see an item in the Project_ideas wiki entry called "Online raid
> config" which looks exactly like what I am after.  I know some of the
> items in that list are being worked on.  Is anyone working on this one?

   It's certainly on my list of things to look at, if nobody else gets
there first.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- You know... I'm sure this code would seem a lot better if I ---   
                         never tried running it.                         

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN2swOIKyzvlFcI40RAhBGAJ40XhQLPXavU+tCxUqKCigRfAigRQCbBgn8
78fK1hyC2dmfk1tc0NMOZ7U=
=5yPO
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
