From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH v2 2/2] Cancel filesystem balance.
Date: Fri, 12 Nov 2010 11:36:55 +0000
Message-ID: <20101112113655.GA2377@selene>
References: <cover.1289522188.git.hugo@carfax.org.uk>
 <9b18b334410714aba2867f96e949f19243536ddc.1289522188.git.hugo@carfax.org.uk>
 <4CDC9971.6080903@cn.fujitsu.com>
 <4CDCC258.1050402@csamuel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
	Goffredo Baroncelli <kreijack@libero.it>,
	Chris Mason <chris.mason@oracle.com>,
	liubo <liubo2009@cn.fujitsu.com>
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CDCC258.1050402@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 12, 2010 at 03:28:08PM +1100, Chris Samuel wrote:
> On 12/11/10 12:33, Li Zefan wrote:
> 
> > Is there any blocker that prevents us from canceling balance
> > by just Ctrl+C ?
> 
> Given that there's been at least 1 report of it taking 12 hours
> to balance a non-trivial amount of data I suspect putting this
> operation into the background by default and having the cancel
> option might be a better plan.

   Only 12 hours? Last time I tried it, it took 19. :)

   It would certainly be easy enough to fork a copy of the userspace
tool to run the ioctl in the background. Probably a little more work
to make the balance a kernel thread. I'd prefer the former, for
ease of implementation.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Great oxymorons of the world, no.  3: Military Intelligence ---   

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM3SbWIKyzvlFcI40RArO7AKC6XiNLVYwBAWg3qB+I/A56KeqLuQCgo3x6
hwfZwz7oKAEiuk3JHagQK/k=
=aWU/
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
