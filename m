Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56634 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3JEAFw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Oct 2013 20:05:52 -0400
Date: Sat, 5 Oct 2013 01:05:46 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: ray clancy <n6re@mminternet.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid0
Message-ID: <20131005000546.GL28147@carfax.org.uk>
References: <524EE99A.8000603@mminternet.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bPg9NdpM9EETxvqt"
In-Reply-To: <524EE99A.8000603@mminternet.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--bPg9NdpM9EETxvqt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 04, 2013 at 04:15:22PM +0000, ray clancy wrote:
> How can I verify the read speed of a btrfs raid0 pair in archlinux.?
> 
> I assume raid0 means striped activity in a paralleled mode at lease
> similar to raid0 in mdadm.
> 
> How can I measure the btrfs read speed since it is copy-on-write
> which is not the norm in mdadm raid0.?

   Testing read speed... you're not writing, so there's no
copy-on-write involved there. Just test reading the way you would for
anything else.

> Perhaps I cannot use the same approach in btrfs to determine the
> performance.
> 
> Secondly, I see a methodology for raid10 using the
> command....mkfs.btrfs -m raid10 -d raid10 /dev/sda/dev/sdb /dev/sdc
> /dev/sdd...
> 
> Can I apply the parameters above for -m and -d for raid0?

   I'd certainly recommend it for testing RAID-0. :)

   Actually, a slightly more realistic test would be to use RAID-0 for
data and RAID-1 for metadata, because that's what most [default] users
of the FS will end up with.

> If using raid0 for two devices and add another device, is it striped
> as raid0 also or does the system change it to raid1.

   No, it'll remain as RAID-0. If you rebalance, then the data will
get striped across three devices instead of two.

> What happens to the speed of the system when a new device is added?
> Is it increased ?

   Assuming the FS is reading from all the devices, yes.

> Much I have at hand for mdadm software raido and it doubles the read
> speed.  What parallel exists in raid0 btrfs?  Or is it completely
> off base to expect a speed increase?

   In theory, you should be able to get the sum of the bandwidths of
all the devices (assuming sequential streaming reads). We don't have
any good benchmarks of this kind of thing, so when you do your tests,
please (a) make sure you do a decent experimental design, and (b)
publish the results. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- I always felt that as a C programmer, I ---             
                         was becoming typecast.                          

--bPg9NdpM9EETxvqt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUk9X2lheFHXiqx3kAQJNTg//StQaDSzUM7suwe8HB4o6JIW2abg/arIX
Z/46V9h8S30NOKDH9pwWXkADVBQ4kLhJ7IJypchOfB0m6J1g7/DHsVH0l1lBVWCa
26PhjF5a8uauH0o9n98AX6dJhslE8tUEvRZFE/o3LDw5JHEKo8QDJWfhWfl0qIze
8kODvn+nPcv4qVjR6IvCvMs94SghNPcQf9cAo/6NtPHfeHvc5EVbH6GJJoM2yLpw
mj6HAv5CJxwSQQspKSXCODPydYMMkNRYfr0XvToNYkawyAy6uGDKQpnLGUNjHH0d
akHPdnp9lbGDYj7sUMVSicaQK3KBZNs14BTSm5m1ygKGc0tY1tNQOaJQm+04Ayff
WAA2lWUhZO2tFEC7tQZv5i7q/765HXl7T+APt1PU5TW74pY5WwU8TWBz6vktDB5e
5WtXUr5I50+wO7pP0AK0sZkhw4nrtzTHWlfG57ig3N9UCYdKXD0aS8vlLiLWWNDl
jzPln6ai/HG95KtT18IAXdCvPJznvSiuYHiLi4EEbGzJH4CdMmMH/YJG6zeFwZk+
epv+BhvVghkrzSfs6iNB7FVUK6r/OIR6O3BkflXeTNqWiSFqAsw2YvFBfvEK0ukU
ueVzURDJz4S0Yb4ifunE96w4AbmNbD1vTxIjS6o7nf7Vlsp047siHrDrse6k+rSk
GzCKhZwwrEs=
=jRYB
-----END PGP SIGNATURE-----

--bPg9NdpM9EETxvqt--
