Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43049 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbcCRSDb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 14:03:31 -0400
Date: Fri, 18 Mar 2016 18:03:29 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: The *right* algorithm for determining the amount of free space
Message-ID: <20160318180329.GB1802@carfax.org.uk>
References: <20160311221703.GJ17196@carfax.org.uk>
 <20160318175802.GE21722@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
In-Reply-To: <20160318175802.GE21722@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 18, 2016 at 06:58:02PM +0100, David Sterba wrote:
> On Fri, Mar 11, 2016 at 10:17:03PM +0000, Hugo Mills wrote:
> >    I know I promised this a while ago and didn't get round to it, but
> > Henk's tinkering reminded me of it. I note specifically that the
> > algorithm used to give the free space to plain old df gives incorrect
> > results -- probably because it's not using the algorithm below.
> 
> So the algorithm is supposed to implement btrfs_calc_avail_data_space,
> the raid5/6 parts are missing from there, otherwise the structure of the
> function follows the proposed algorithm.

   Well, the current code gets the free space estimation wrong even
with RAID-1. It's not usually *very* wrong, but it's still not right,
somewhere.

> >    There is an algorithm that (seems to) give the correct number of
> > block groups which can be allocated, given a current allocation state
> > of the FS. I haven't been able to prove it correct, but it seems to
> > work. Here's some pseudocode for it:
> 
> It does sound correct to me. Thanks for writing it up.

   Hugo.

-- 
Hugo Mills             | Great films about cricket: The Umpire Strikes Back
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJW7ELxAAoJEFheFHXiqx3kvXIP/iaphyafLvnYRSYybiciVv6D
st0FUG3Ej5Jl0BA/b9lHouGLP2k3lFDMXhCAXhPJRxQ8+ECjwPfdjbSEcALo8ltx
ghLzoGIwkk54n6hOU8toDFWbtcxv2fngxq7MJ9NkonRtAJNyRXASDtvua+evRq//
KKPDhDXv1AYuSP/Ng0qtaUJv2sE87ZchppEk6tCWoLgDZAo7vp33IALassFhpJw7
gwK85nkCqx0+XGwgfhljlKjPxgr8nbkq1Bhx9JajEuwh3l/9y4HAV+Yvvic6IBC5
IiRvGvl822+Ijq4VEdLFJL1eiYntGKS5AjGim8G3PLPmD5sej24zN/8CIhKdYWTo
OQ7l/6R9EbtkI0JIEbpvTqOPKw6NhJCMGenmoHJ9G7RmFGuKUKoGRw8HChugDjH9
HNT+xnBwHpcsPwbYY3Sn9DMimDlUHeV4MX83orQgec/TF59YFnGpeIVzgyqcjtfY
cqqoRHcpC+xL4huBCXNMfD2Nn51LL9URjOsQse3x00q60xhqKncz30JonLQCTIVn
irqNqpnKfMZhsppmAd3OMWnZS2mRrB/VOTFSUqg86xGFWRAwoGZXzhyH/1d8c+j9
YPBxO4aoEZwcZR45YGOgyr3nonXJ84vBoouLqbBb1zoxdL0Y3fSD02Y+VN9SqC1R
Gkg5oH/U/RzB7sNHARBy
=7Jnc
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
