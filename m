Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54739 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3KSJGG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 04:06:06 -0500
Date: Tue, 19 Nov 2013 09:06:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: deadhorseconsulting <deadhorseconsulting@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Actual effect of mkfs.btrfs -m raid10 </dev/sdX> ... -d raid10
 </dev/sdX> ...
Message-ID: <20131119090602.GV4315@carfax.org.uk>
References: <CAEWPe=pwpxdYUDk7BzfjR8h-Jq9wtQE+gxxQChjOZzsXJO4vHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fxBYc4U7HLIDBZ2G"
In-Reply-To: <CAEWPe=pwpxdYUDk7BzfjR8h-Jq9wtQE+gxxQChjOZzsXJO4vHQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--fxBYc4U7HLIDBZ2G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 18, 2013 at 11:12:03PM -0600, deadhorseconsulting wrote:
> In theory (going by the man page and available documentation, not 100%
> clear) does the following command indeed actually work as advertised
> and specify how metadata should be placed and kept only on the
> "devices" specified after the "-m" flag?
> 
> Thus given the following example:
> mkfs.btrfs -L foo -m raid10 <ssd> <ssd> <ssd> <ssd> -d raid10 <rust>
> <rust> <rust> <rust>
> 
> Would btrfs stripe/mirror and only keep metadata on the 4 specified SSD devices?
> Likewise then stripe/mirror and only keep data on the specified 4 spinning rust?

   No. The devices are general purpose. The -d and -m options only
specify the type of redundancy, not the devices to use. There's a
project[1] to look at this kind of more intelligent chunk allocator,
but it's not been updated in a while.

[1] https://btrfs.wiki.kernel.org/index.php/Project_ideas#Device_IO_Priorities

> In trying and creating this type of setup it appears that data is also
> being stored on the devices specified as "metadata devices". This is
> observed through via a "btrfs filesystem show". after committing a
> large amount of data to the filesystem The data devices have balanced
> data as expected with plenty of free space but the SSD device are
> reported as either nearly used or completely used.

   This will happen with RAID-10. The allocator will write stripes as
wide as it can: in this case, the first stripes will run across all 8
devices, until the SSDs are full, and then will write across the
remaining 4 devices.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                --- If it ain't broke,  hit it again. ---                

--fxBYc4U7HLIDBZ2G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUosp+VheFHXiqx3kAQLXDw/9GymmBqYy/7pIf/17XgW6iaDkM7RRkK4S
VavZUN1apWpgo9BguyNJ9tQENfcZcJb1T4ENj3DikYjF6vSfXaNwHVlarZ+3coXa
0CXI53JOc0TIyzlvTkcYOirtq13Jp5rBswpeNaqM9FO/9c3RamL4bL338337UntJ
Pu42NcRUXIXxeId2nHCFLXLPEQMnS4CA1tAhOW8591doANFUkXySMxh8nl6n/IoC
9CAf8YWwnyMqIKpE31GJChJ+XDaRT34x9+7v3dZ8nUYnoBWa2M0MrO3cneiMQoAh
WtE2AleKGEuvuwDJKBHXhV5qBZdFEsfbbVhBUibXMzXWadZJEeEDML0/y9DFVUMD
wbjv5DOd/+8OoiRmhjjc1FOiy2OzcrjLmmPbN7AVn9jb1+pAIiLhnzgtDPJjT9S6
upCksmroH2S7FXJib7jwVekU8f9K+Okt3Oi8yCZArmadVUlDpstGCMuMojwzaP6m
8qMool2ikpx7dhTf+6i4d+uoBV+ObiWZtikKe3MR62zqCFvmONzWShJ8lz0rII6i
J0bes1HedC6e/Jw4e7tEo0SeV59tAEBR36vf32mFhyBQUxUFFH6CZUsCeBI45QYI
80q31HJ5tghar1HLo6ospOb13Il0JCEhxvRWDNAqH8kCFnqHqqCa6DgtgIHYW6Y/
Eie9a7c0Erw=
=Dr4Q
-----END PGP SIGNATURE-----

--fxBYc4U7HLIDBZ2G--
