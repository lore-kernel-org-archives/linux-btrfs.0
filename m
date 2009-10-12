From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: ENOSPC at 94% full -- and causing BUGs elsewhere?
Date: Mon, 12 Oct 2009 15:09:35 +0100
Message-ID: <20091012140935.GA8550@vlad.carfax.org.uk>
References: <20091003122109.GB3116@selene> <20091003215531.GG4350@dhcp231-156.rdu.redhat.com> <20091004120630.GA19916@think>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Hugo Mills <hugo-lkml@carfax.org.uk>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091004120630.GA19916@think>
List-ID: <linux-btrfs.vger.kernel.org>


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 04, 2009 at 08:06:30AM -0400, Chris Mason wrote:
> On Sat, Oct 03, 2009 at 05:55:32PM -0400, Josef Bacik wrote:
> > On Sat, Oct 03, 2009 at 01:21:09PM +0100, Hugo Mills wrote:
> > >    I've just had the following on my home server. I believe that it's
> > > btrfs that's responsible, as the machine wasn't doing much other than
> > > reading/writing on a btrfs filesystem. The process that was doing so
> > > is now stuck in D+ state, and can't be killed. The timing of the oops
> > > at the end is also suggestive of being involved in the same incident.
> > > This is the only btrfs filesystem on the machine.
> > 
> > Patches have gone to Linus to fix the enospc problems.  You can try running the
> > enospc branch of Chris's git tree and it should behave better for you.  Thanks,
> 
> The right tree for this is the master branch of btrfs-unstable for
> 2.6.31.

   Thanks, Josef and Chris. I've now found the time to check out and
build the btrfs-unstable tree, and it is indeed handling the ENOSPC
condition much more cleanly.

   However, it seems to have got into a position where I have lots of
free space reported by df (over 10% of the size of the volume -- 185
GiB free of 1474 GiB total), but still refuses to write anything to
the filesystem. Do you have any suggestions for what I could try?

   The original ENOSPC error I reported above happened at
approximately 85/1370 GiB free; I then added 100 GiB more space
online, had another failure (same kernel: 2.6.31 mainline), and then
rebooted into master from btrfs-unstable.

   Just for the record, I'm now using this kernel:

Linux vlad 2.6.31-47417-gac6889c #1 Sun Oct 11 14:27:06 BST 2009 x86_64 GNU/Linux

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I'll take your bet, but make it ten thousand francs. I'm only ---  
                       a _poor_ corrupt official.                        

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD4DBQFK0zifIKyzvlFcI40RAg+nAJdRzXpw/qsL9IttaUj1kqicvj1cAKChuxwm
5BI42Ad/7hXQR+YY2q+w1w==
=/ts2
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
