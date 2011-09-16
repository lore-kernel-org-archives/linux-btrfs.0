From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Raid0 and drive failure.
Date: Fri, 16 Sep 2011 16:10:44 +0100
Message-ID: <20110916151044.GF11031@carfax.org.uk>
References: <CAC_HdUrrEzUYp3K=ZAG9sQK=6totXmoy5FswGg=huTuxb6vtnw@mail.gmail.com>
 <CAAeznTp1eX8m--Mw-RFNY8VmU8O08kRNQeOmHAZo=cGNxvV7Tg@mail.gmail.com>
 <CAC_HdUrh+LhBfHTMKE8VTkuwEgJbcX2mBP3pJFYivk228-VctA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wtjvnLv0o8UUzur2"
Cc: Leonidas Spyropoulos <artafinde@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Henti Smith <henti@geekware.co.za>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAC_HdUrh+LhBfHTMKE8VTkuwEgJbcX2mBP3pJFYivk228-VctA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--wtjvnLv0o8UUzur2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 16, 2011 at 05:06:03PM +0200, Henti Smith wrote:
> On Fri, Sep 16, 2011 at 4:49 PM, Leonidas Spyropoulos
> <artafinde@gmail.com> wrote:
> > On Sep 16, 2011 1:25 PM, "Henti Smith" <henti@geekware.co.za> wrote:
> >> This is likely a newbie question, but I just need to confirm. If you
> >> have 3 x 100GB drives in RAID0 and one drive dies this will result in
> >> total data loss correct?
> >>
> > Yes the data are lost. Read more on how raid 0 works.
> 
> I have read on how raid 0 works, I was merely asking about the
> implementation of raid0 on btrfs.
> 
> >> Is there no way to loose only the data that resides (even partly) on
> >> the missing drive but retain the rest of the data ?
> 
> This is the more pertinent question, which it seem btrfs can't do currently.

   btrfs stripes its RAID-0 data across all available disks, so you'd
lose approximately 1/3 of the data for each file. In some cases, you
might get lucky and have a small file that resides entirely on the two
undamaged disks. In that case, it *might* be possible to recover your
data, but I think in general the amount of effort involved to get that
degree of recovery is probably far outweighted by the use of your
backups to restore all of the missing data...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- "Are you the man who rules the Universe?" "Well,  I ---       
                              try not to."                               

--wtjvnLv0o8UUzur2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOc2b0IKyzvlFcI40RAoQrAKCQPTtP1RtxGK7/PQOpduPOKm7gOgCgn/9r
gMebG/cBp3FWnACitCNcyDw=
=yABz
-----END PGP SIGNATURE-----

--wtjvnLv0o8UUzur2--
