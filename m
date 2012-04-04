From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: hard links
Date: Wed, 4 Apr 2012 20:53:39 +0100
Message-ID: <20120404195339.GE32070@carfax.org.uk>
References: <4F7C78FE.2020508@arndnet.de>
 <4F7CA218.5070902@gmail.com>
 <4F7CA37B.50006@arndnet.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lkTb+7nhmha7W+c3"
Cc: nspmangalore@gmail.com, linux-btrfs@vger.kernel.org
To: Arnd Hannemann <arnd@arndnet.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F7CA37B.50006@arndnet.de>
List-ID: <linux-btrfs.vger.kernel.org>


--lkTb+7nhmha7W+c3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 04, 2012 at 09:39:39PM +0200, Arnd Hannemann wrote:
> Am 04.04.2012 21:33, schrieb Shyam Prasad N:
> > On 04/04/2012 10:08 PM, Arnd Hannemann wrote:
> >> Hi,
> >>
> >> today I experimented with hard links on btrfs and by this used all available inode space of a file.
> >> Interestingly if this happens even a rename of such an filename to  an _equal length_ filename
> >> fails:
> >>
> >> arnd@kallisto:/mnt/btrfs/tmp$ mv a b
> >> mv: cannot move `a' to `b': Too many links
> >>
> >> Is this expected behavior?
> >> There should be no reason to let this particular case fail?
> >>
> 
> > What do you mean by 'used all available inode space'? What did you do exactly?
> 

   There's no inode limit specifically. The limit is on the number of
hardlinks to the same file stored in the same directory (and it's very
small). This is a known limitation of btrfs. Someone's working on a
fix (can't remember who, off-hand), but it's not been published yet.

> I created hard links of a file in the same directory until no additional one
> can be created.
> 
> Eg.:
> touch a
> for i in {1..1000}; do ln a $i; done;

   This is a little odd, but I don't really know what the internals of
mv try to do...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Nothing right in my left brain. Nothing left in ---         
                             my right brain.                             

--lkTb+7nhmha7W+c3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPfKbDIKyzvlFcI40RAlYbAJ9TbhGdtx3VSDHIht6pVovTBpCsmgCfTwZo
v7IHqsc3G8oZTO51s6lHAK4=
=rAsL
-----END PGP SIGNATURE-----

--lkTb+7nhmha7W+c3--
