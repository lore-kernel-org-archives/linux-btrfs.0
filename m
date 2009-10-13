From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: ENOSPC at 94% full -- and causing BUGs elsewhere?
Date: Tue, 13 Oct 2009 15:50:07 +0100
Message-ID: <20091013145007.GA5393@vlad.carfax.org.uk>
References: <20091003122109.GB3116@selene> <20091003215531.GG4350@dhcp231-156.rdu.redhat.com> <20091004120630.GA19916@think> <20091012140935.GA8550@vlad.carfax.org.uk> <20091013103145.GC8830@think>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
To: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo-lkml@carfax.org.uk>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091013103145.GC8830@think>
List-ID: <linux-btrfs.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 13, 2009 at 06:31:45AM -0400, Chris Mason wrote:
> On Mon, Oct 12, 2009 at 03:09:35PM +0100, Hugo Mills wrote:
> > On Sun, Oct 04, 2009 at 08:06:30AM -0400, Chris Mason wrote:
> > > On Sat, Oct 03, 2009 at 05:55:32PM -0400, Josef Bacik wrote:
> > > > On Sat, Oct 03, 2009 at 01:21:09PM +0100, Hugo Mills wrote:
> > > > >    I've just had the following on my home server. I believe that it's
> > > > > btrfs that's responsible, as the machine wasn't doing much other than
> > > > > reading/writing on a btrfs filesystem. The process that was doing so
> > > > > is now stuck in D+ state, and can't be killed. The timing of the oops
> > > > > at the end is also suggestive of being involved in the same incident.
> > > > > This is the only btrfs filesystem on the machine.
> > > > 
> > > > Patches have gone to Linus to fix the enospc problems.  You can try running the
> > > > enospc branch of Chris's git tree and it should behave better for you.  Thanks,
> > > 
> > > The right tree for this is the master branch of btrfs-unstable for
> > > 2.6.31.
> > 
> >    Thanks, Josef and Chris. I've now found the time to check out and
> > build the btrfs-unstable tree, and it is indeed handling the ENOSPC
> > condition much more cleanly.
> > 
> >    However, it seems to have got into a position where I have lots of
> > free space reported by df (over 10% of the size of the volume -- 185
> > GiB free of 1474 GiB total), but still refuses to write anything to
> > the filesystem. Do you have any suggestions for what I could try?
> 
> You've probably got most of that 10GB free allocated as metadata.  You
> could try btrfs-vol -b.

   I moved some 13 GiB of data off the filesystem, and ran 
btrfs-vol -b. As I reported on IRC, I then got this in my syslog:

Oct 13 13:16:19 vlad kernel: btrfs: relocating block group 1401224691712 flags 1
Oct 13 13:17:02 vlad kernel: btrfs: found 123 extents
Oct 13 13:17:10 vlad kernel: btrfs: found 123 extents
Oct 13 13:17:11 vlad kernel: btrfs: found 28 extents
Oct 13 13:17:21 vlad kernel: btrfs: found 28 extents
Oct 13 13:17:25 vlad kernel: btrfs: found 28 extents
Oct 13 13:17:26 vlad kernel: btrfs: found 27 extents
Oct 13 13:17:36 vlad kernel: btrfs: found 27 extents
Oct 13 13:17:39 vlad kernel: btrfs: found 27 extents
Oct 13 13:17:48 vlad kernel: btrfs: found 27 extents
... repeat forever (or at least for 50 minutes or so).

   The btrfs-vol -b process didn't respond to ^C, so on advice of
yanzheng on IRC I rebooted the machine. I'm currently running a
btrfsck on the filesystem, and will try btrfs-vol -b again when that's
done.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Do not meddle in the affairs of system administrators,  for ---   
                  they are subtle,  and quick to anger.                  

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFK1JOfIKyzvlFcI40RAjE0AJsF4ojFpT6qb/nYw4NMEkQlNTW9NwCfZ5q/
GQB+xBc6QiGway24yZHLKwQ=
=rrhd
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
