From: Bruce Guenter <bruce@untroubled.org>
Subject: Re: Slow snapshot deletion
Date: Fri, 12 Aug 2011 12:21:44 -0600
Message-ID: <20110812182144.GA10102@untroubled.org>
References: <20110728200444.GA30801@untroubled.org>
 <1311884805-sup-7662@shiny>
 <1311886250-sup-5126@shiny>
 <20110804163536.GA25185@untroubled.org>
 <20110811150456.GA558@untroubled.org>
 <20110812004036.GA3960@hostway.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110812004036.GA3960@hostway.ca>
List-ID: <linux-btrfs.vger.kernel.org>


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 11, 2011 at 05:40:36PM -0700, Simon Kirby wrote:
> By chance, does "vmstat 1" or top show a high system cpu% while this is
> happening,

Absolutely, usually around 80-90%

> and if so, does cat /proc/<pid>/stack of the PIDs in R state
> sometimes show things under btrfs_run_delayed_refs like
> setup_cluster_no_bitmap() and rb_next()?

No, I am not seeing what you describe.  The stack traces are usually
showing what I originally quoted.  I don't know if I've seen
setup_cluster_no_bitmap or rb_* at all.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAEBAgAGBQJORW84AAoJEFFRvcnBTTxnJ60QAJiyyXYOqLB+L8hvAfzJOxOH
I+K4GVWKRJa9r7KHItvfrzs6FND6LU4QNgQmbuviHYW+OcUCFIR6YsDAzWtxg6ZU
aZMTnUlAtKi0wjh5UPl2tGqMTPAnhUTLChRyG2KqyfcuFYcrlNSujP2movSvA5AS
OgT2Azxa0qiHuCpsv8Ih9PUgm17mWNHisUvZe/rdVABBStNqqbaOiVRgtAtH56iV
UupwGhbLlzXRDJx4znlhXbpa9swCOt2bgmY70buKwWZNChcaBDq3uD2g8gkiNurc
cEsJl5l4hvW8xvbWVIdPyYz1WaoHmBhRPXyhOmR0i7LVaoMRsdockk+OLDmBndQT
y/cJLY4LEsJpr9SOcfh/eVBnzJWrvkLvqv/eFb0MxGjZmDT6K+0+oJviiYHZC/Pi
AOdYmFI/SV35GaVgqYE6U9GWNaTrtYXnZFWf3pVGkJGkVq18Ba9RdMXqgDdZrKli
2ctcVSviAmDcq2wtgch48Nr2HE8UxgPmwxridPo3as3EpaElG8KXGp81ufZvzRL9
cl5vpPFRzqM5BV/HYmZYEIlSfZUZqtiVlflmGVeLaXOx2RJ3jy+NI6kAHXSem1bz
Crv+oZVYuWh4TzSaz/VbLLCxzKSjwys8ofOoYLJn3tIsP9PMUeN3VB/R96pmx+wZ
NWw1tflhvpqrwUbNCBMR
=LHgW
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
