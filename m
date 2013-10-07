Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51950 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab3JGMG0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 08:06:26 -0400
Date: Mon, 7 Oct 2013 13:06:23 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Laurent Humblet <laurent.humblet@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Some questions after devices addition to existing raid 1 btrfs
 filesystem
Message-ID: <20131007120623.GM28147@carfax.org.uk>
References: <CAFirYm_jn=O50=aOvRswBJio3f37xOY-BLeXTzfzHzRKzX3wrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kc9HNjpzOXVc7FFU"
In-Reply-To: <CAFirYm_jn=O50=aOvRswBJio3f37xOY-BLeXTzfzHzRKzX3wrQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Kc9HNjpzOXVc7FFU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 07, 2013 at 01:45:29PM +0200, Laurent Humblet wrote:
> I have added 2x2Tb to my existing 2x2Tb raid 1 btrfs filesystem and
> then ran a balance:
> 
> # btrfs filesystem show
>         Total devices 4 FS bytes used 1.74TB
>         devid    3 size 1.82TB used 0.00 path /dev/sdd
>         devid    4 size 1.82TB used 0.00 path /dev/sde
>         devid    2 size 1.82TB used 1.75TB path /dev/sdc
>         devid    1 size 1.82TB used 1.75TB path /dev/sdb
> # btrfs filesystem balance btrfs_root/
> # btrfs filesystem show
>         Total devices 4 FS bytes used 1.74TB
>         devid    3 size 1.82TB used 892.00GB path /dev/sdd
>         devid    4 size 1.82TB used 892.00GB path /dev/sde
>         devid    2 size 1.82TB used 891.03GB path /dev/sdc
>         devid    1 size 1.82TB used 891.04GB path /dev/sdb
> 
> It took 59 hours to complete the balance.
> 
> I checked on a couple of files and all seems fine but I have some questions:
> - is there some kind of 'overall filesystem health/integrity check'
> that I should do on the filesystem now that the balance is done?

   See btrfs scrub start

> - also, I ran the command while some of the btrfs subvolumes were
> mounted (as well as the btrfs_root/ of course), does this impact on
> the balance job?

   No.

> - the mounted btrfs devices were mounted using -o
> space_cache,inode_cache but the btrfs_root/ was not, also, does this
> impact on the balance job?

   No.

> - about those options, a few months ago, I oftent had
> btrfs-cache-1/btrfs-endio-met processes taking some cpu/hd time.  I
> was advised to mount -o space_cache,inode_cache, which seems to have
> quiet the processes down.  Are those options still necessary now?

   No, once you've mounted with them once (and had the caches rebuilt)
they're not necessary to use any more.

> - as the job took 60+ hours but the CPU rarely went above 10%, the
> computer seemed still usable.  I left it do its job of course but
> could I have accessed or write anything on the subvolumes while the
> balance was running and if yes, would this have any impact on the
> filesystem?

   Absolutely, yes, you could have done. It would probably be slower
than normal to access the files while the balance is happening,
because the balance is using up I/O bandwidth, but other than that
there should be no impact.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                        --- argc, argv, argh! ---                        

--Kc9HNjpzOXVc7FFU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUlKjv1heFHXiqx3kAQKW+w//YXf0JeMQIFM7i/PM0ir4afQytVZMlf5Z
9DYh7ZoaifRSasZA5Rse2xQZYoaUdXFGfO8kKTCiFYkIQl8jQal8piFe6XYBxZvc
qwsgQG7sHrZy9/gZ/SwNFeoSkAkHT54uzcxFRKjokseIlPCq99ph3ukPSbZ6SHQD
Ym0yscMdgu4Nsa3PGjPfBx8TG7pMYKdWerfiORBtdfr3lgT4JFVB1OXi+sWyO5V3
aAtNG9F118GfENfOfeYGAXVzrqnxkeRe9NlodzSYineXPjUegvcW9jGQMuTcZYYb
h4GvfPHtjPxMpUH8mXsaay8RnFz+VZKzlmT6RDiiiXmnXOwJOyYOW8ZChy/zSWbc
y0PlW1xSl8i7nx2Aj1C2gwnbdnEHurRHE6k0e/wifq+JAIon+gG/6xnuEsn4R7DC
s2hoVpYRrJ3Q+L9AMh2bvZqW+jgVDugajpCERz1cmgprZN/7GtVPRvaM7hJz+bLO
OqeYkxsKSTvnLpd6c39Hx/RK+hQR6ZoY62KpKQg8ZfLJW9ZdtjYQn0Hb2B9TXvDg
8ymZAleMDyx0IvGEO476mcNSfDv4vx4EzxqGvDAVfNPj7/mQDg7PwXJAx9u0rEZs
iKMdveiEdlzfSTddiOI35HQOHSsMi0KfHJUT4TxpY5MmN7hW3SzpEAG0th0AYmk5
tN5tvL6YjDE=
=0hzV
-----END PGP SIGNATURE-----

--Kc9HNjpzOXVc7FFU--
