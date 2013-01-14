Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54075 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab3ANSN4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 13:13:56 -0500
Date: Mon, 14 Jan 2013 18:13:53 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can moving data to a subvolume not take as long as a fully copy?
Message-ID: <20130114181353.GB19051@carfax.org.uk>
References: <20130114173250.GA23026@merlins.org>
 <20130114174155.GA19051@carfax.org.uk>
 <20130114180041.GC23026@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GXT8AkipAZwA99QD"
In-Reply-To: <20130114180041.GC23026@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--GXT8AkipAZwA99QD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 14, 2013 at 10:00:41AM -0800, Marc MERLIN wrote:
> On Mon, Jan 14, 2013 at 05:41:55PM +0000, Hugo Mills wrote:
> > On Mon, Jan 14, 2013 at 09:32:50AM -0800, Marc MERLIN wrote:
> > > I made a mistake and copied data in the root of a new btrfs filesystem.
> > > I created a subvolume, and used mv to put everything in there.
> > > Something like:
> > > cd /mnt
> > > btrfs subvolume create dir
> > > mv * dir
> > > 
> > > Except it's been running for over a day now (ok, it's 5TB of data)
> > > 
> > > Looks like mv is really copying all the data as if it were an entirely
> > > different filesystem.
> > > 
> > > Is there not a way to short circuit this and only update the metadata?
> > 
> >    I guess the best way of doing this in this case is to teach mv to
> > do cp --reflink=always then unlink the origin.
> > 
> >    Clearly that won't work over mount boundaries (where a copy of the
> > data is the best you're going to get), but that's not what you've got
> > here.
> 
> Mmmh, this made me think:
> It seems that I could have done cp --reflink without duplicating the data
> and running out of space.
> Then, I could have deleted the originals?
> 
> Is that correct?

   Yup, exactly what I just said above. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Your problem is that you've got too much taste to be ---       
                            a web developer.                             

--GXT8AkipAZwA99QD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUPRK4L9z9OVl50rAAQIrdQ/+Lk/NGJXnah02VngPAYoCF2h7JXoEjzML
ElRqbf6+qAYnwVq6YD3irurmtONgPZYXcQOduAXXkmPQff/zO6IGZXhXhl36sMlM
kDNJTmmPV+TSq+tPRjlscTTbSss0DhsNggy45ETZBeUhKAz3tArmuFLhJZ2TzrEk
9IPWGiHXZ2rBejAeU/wc34SIMFqW0g/VlS/fkxvsNp2xLMqRiJ5gNp4l5wEcxeXK
yqolSxROtMeDvnPQouxncPVaVZXwOVNfSHJlIaeMk2lNRYkKc1JwZUQhfEuWRuxL
ybk/gNI5gE37Mgo7EiCsz0XEkkMweLZM6aBNpaHtUq6AmiSjIXp7/oLiK8lgcsd5
obh4bCTLA04JXfDwJofAKKDebV6CbI7dPteSc5FpX3J0Z+OxNUy5YVB7IqoQVEnn
EvcZiXHy3r8QfiuUeKAWe2HWtrg3u4rniNEefrybhbPZuSI3xNkePKeKProgJMBd
rx4Y6gz/m9HGTl0mbwPL4d+D8mD7vF70ZzC08/XOca3t6TAeQfamJqG9ARl1F4S4
dVJkzY5vUy+EPjFhNYN0xlBsJmx+magrdYiUS/H8OsNuVI62QuU+HaP/CR7OnSLY
pmmfpQ979NCCfEyHbzvuV5T4gJAptqMCKBRL42fFMi4Y/46k0SjW3paBU/VOvO8h
gUKJlOTsy44=
=yMGw
-----END PGP SIGNATURE-----

--GXT8AkipAZwA99QD--
