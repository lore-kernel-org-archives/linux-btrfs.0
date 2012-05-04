From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: BTRFS Benchmarking
Date: Fri, 4 May 2012 23:39:05 +0100
Message-ID: <20120504223905.GH9860@carfax.org.uk>
References: <CAPPqfY0iGPjRDC0YG814uiv4+9jLU54w6D5Yh=okTqG7VtwXOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h3LYUU6HlUDSAOzy"
Cc: linux-btrfs@vger.kernel.org
To: Olivier Doucet <webmaster@ajeux.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPPqfY0iGPjRDC0YG814uiv4+9jLU54w6D5Yh=okTqG7VtwXOA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--h3LYUU6HlUDSAOzy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 04, 2012 at 06:03:50PM +0200, Olivier Doucet wrote:
> hello everyone,
> 
> I made an overall benchmark of BTRFS against EXT4 and XFS. I'm quite
> unhappy with BTRFS results, so maybe tuning was not perfect.
> 
> http://www.slideshare.net/ezameku/btrfs-benchmark
> 
> All data is vectorial, so download the PDF and you can zoom ;)
> 
> If you have any feedback on how to improve BTRFS results (and others
> fs too !), I would be glad to update my data.
> 
> Test protocol
> Server : dual CPU Intel L5640 with HT enabled
> Operating system : CentOS 6.2 (64bits version) with custom tools/kernels
> Kernel : 3.3.0
> Btrfs progs: version 0.19
> Drive : Seagate 3TB drive (ST33000652SS) SAS attached via an LSI HBA.
> Drive was accessed through LVM ;
> 
> MKFS options
> BTRFS    : none
> XFS         : none
> EXT4       : none
> 
> Mount options
> BTRFS          : "noatime,nodiratime"
> BTRFS compress : "noatime,nodiratime,compress=lzo"
> EXT4           : "noatime,nodiratime"
> XFS            : "noatime,nodiratime"
> 
> Benchmark is done with Sysbench (fileio test).
> Each benchmark was done for 60 seconds, and generated one point on the
> graph each second (to see variations).
> Right scale is block size.
> 
> Data read / written is from /dev/urandom, so cannot be compressed much
> (that was expected behaviour).
> 
> All second pages has no legend, I'm sorry for that :
> - data is 95 percentile aggregate.
> - colours are the same.

   Can you tell us what the unit of the Y-axis is? Is it MB/s or IOPs
or time for a fixed amount data or... ?

   We've just been discussing this on IRC, and we've come up with two
completely different interpretations of the data, so we're actually
not sure how to interpret this.

   For example, in the seqwr/512 test, is btrfs doing really well at
small numbers of threads, getting steadily worse, or is it doing
really badly, and improves hugely as the number of threads goes up?

   Hugo.

> Overview of results
> 
> On sequential read, there is no variations between FS.
> On sequential write, BTRFS has lower values than EXT4/XFS. On random
> write also.

   I guess what we're after is -- is a lower value better or worse?

   Thanks,
   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- SCSI is usually fixed by remembering that it needs three ---     
        terminations: One at each end of the chain. And the goat.        
                                                                         

--h3LYUU6HlUDSAOzy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPpFqIIKyzvlFcI40RAkP1AJwPlbHR+reyIoLtEpV07WK6kZF0IQCcC7gJ
6ArvNxQzSNi5l2D04n447Uk=
=nXpt
-----END PGP SIGNATURE-----

--h3LYUU6HlUDSAOzy--
