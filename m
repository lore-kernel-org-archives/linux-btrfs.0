From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: "open_ctree failed", unable to mount the fs
Date: Fri, 7 Jan 2011 19:09:30 +0000
Message-ID: <20110107190930.GA24059@carfax.org.uk>
References: <4D27631B.9020700@wpkg.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D27631B.9020700@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 07, 2011 at 08:01:47PM +0100, Tomasz Chmielewski wrote:
> I got a "power cycle", after which I'm no longer able to mount btrfs
> filesystem:
> 
> 
> device fsid xxxxx-yyyyy devid 1 transid 169686 /dev/vda3
> device fsid xxxxx-yyyyy devid 1 transid 169686 /dev/vda3
> parent transid verify failed on 3260289024 wanted 169686 found 169685
> parent transid verify failed on 3260289024 wanted 169686 found 169685
> parent transid verify failed on 3260289024 wanted 169686 found 169685
> btrfs: open_ctree failed
> 
> 
> Tried to get that mounted with 2.6.35 and 2.6.37, without success.
> 
> Is there a way to fix it?

   The forthcoming[1] btrfsck tool should handle that particular
error, I believe.

   To prevent it from happening again, ensure that you have working
barriers on your disks, or that you turn off write caching on the
drives at every boot.

   Hugo.

[1] out "real soon now"

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- Well, sir, the floor is yours.  But remember, the ---        
                              roof is ours!                              

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNJ2TqIKyzvlFcI40RAm3TAJ9jOxFGCboxO4iyEbAti8dnjDAvfACdG9vg
uM63j8QBYKFmBysPFdc1ilY=
=Zabc
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
