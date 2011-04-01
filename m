From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: btrfs balancing start - and stop?
Date: Fri, 1 Apr 2011 12:59:35 +0100
Message-ID: <20110401115935.GA2984@carfax.org.uk>
References: <4D95B3AA.2090106@NewsNow.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Cc: linux-btrfs@vger.kernel.org
To: Struan Bartlett <struan.bartlett@NewsNow.co.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D95B3AA.2090106@NewsNow.co.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 01, 2011 at 12:14:50PM +0100, Struan Bartlett wrote:
> My company is testing btrfs (kernel 2.6.38) on a slave MySQL
> database server with a 195Gb filesystem (of which about 123Gb is
> used). So far, we're quite impressed with the performance. Our
> database loads are high, and if  filesystem performance wasn't good,
> MySQL replication wouldn't be able to keep up and the slave latency
> would begin to climb. This though, is generally not happening, which
> is good.
> 
> However, we recently tried running 'btrfs fi balance' on the
> filesystem, and found this deteriorated performance significantly,
> and the MySQL replication latency did begin to climb. Several hours
> later, with the btrfs-cleaner thread apparently still busy, and our
> replication latency running to a couple of hours, and no sign of the
> balancing operation finishing, we decided we needed to terminate the
> balancing operation, which we did by rebooting the server.
> 
> That, however, is suboptimal in a production environment, and so
> I've some questions.
> 
> 1) Is the balancing operation expected to take many hours (or days?)
> on a filesystem such as this? Or are there known issues with the
> algorithm that are yet to be addressed?

   A balance rewrites all the data on the filesystem, so it can take a
very long time (I think the longest reported time I've seen from
anyone was 48 hours, on several terabytes of data). However, this will
be highly dependent on the amount of I/O bandwidth available to the
FS, and on the size of the data to be written.

> 2) Is it supposed to be desirable to run balancing operations
> periodically anyway? Our server is running on hardware mirrored
> disks, so our btrfs filesystem is simply created in spare space on
> the LVM volume group, using a single LV block device. Does balancing
> help improve performance/optimise free space in this setup anyway?

   Not that I'm aware of, particularly in the light of the recent
patch that frees up unused block groups. Others here may have a more
informed take on this, though.

> 3) If there's an ioctl for launching a balancing operation, would it
> be an idea to add one for pausing a balancing operation? If
> balancing may take 'significant' lengths of time, and if it's
> intended that balancing be done periodically, it might be helpful if
> one could start balancing when loads are lower, and make sure one
> can stop them when resources are needed (in our case, when slave
> latency exceeds acceptable limits).

   There's patches for a cancel operation on the mailing list.
Further, I've got (as yet) unreleased patches for various forms of
partial balance, at least one of which would allow a balance to be
restarted after it was cancelled. The only reason I've not released
them is because I want to do a final check of what I send to the list
to ensure that I'm not making an idiot of myself (and wasting people's
time) with malformed patches. I hope to have time for this on Sunday.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- Guards!  Help! We're being rescued! ---               

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNlb4nIKyzvlFcI40RAqoSAJ4+UsFvQIlCNsIo+Jnvdlud6Vl0MgCgs31V
67rYz0xDoH3Z3M7MDK/zPkA=
=Wwyp
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
