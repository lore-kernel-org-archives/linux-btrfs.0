Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45872 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaBJTGL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 14:06:11 -0500
Date: Mon, 10 Feb 2014 19:05:45 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Josef Bacik <jbacik@fb.com>
Cc: cwillu <cwillu@cwillu.com>,
        "lin >> linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: What to do about df and btrfs fi df
Message-ID: <20140210190545.GL6490@carfax.org.uk>
References: <52F9014F.6070901@fb.com>
 <20140210170606.GK6490@carfax.org.uk>
 <CAE5mzvgFLfQoaNx1eWB2z_kJW-pe1bFY_3LxDMV9XbtKApo=xw@mail.gmail.com>
 <52F91A4A.4080807@fb.com>
 <CAE5mzvhc0FCL81=ajAFyzHK6L1vP2uuQrjf6UfMX-vDxH+-pKQ@mail.gmail.com>
 <52F91D53.5060902@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sCNd3Ivk/oijKKf1"
In-Reply-To: <52F91D53.5060902@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--sCNd3Ivk/oijKKf1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 10, 2014 at 01:41:23PM -0500, Josef Bacik wrote:
> 
> 
> On 02/10/2014 01:36 PM, cwillu wrote:
> >IMO, used should definitely include metadata, especially given that we
> >inline small files.
> >
> >I can convince myself both that this implies that we should roll it
> >into b_avail, and that we should go the other way and only report the
> >actual used number for metadata as well, so I might just plead
> >insanity here.
> >
> 
> I could be convinced to do this.  So we have
> 
> total: (total disk bytes) / (raid multiplier)
> used: (total used in data block groups) +
> 	(total used in metadata block groups)
> avail: total - (total used in data block groups +
> 		total metadata block groups)
> 
> That seems like the simplest to code up.  Then we can argue about
> whether to use the total metadata size or just the used metadata
> size for b_avail.  Seem reasonable?

   My vote on that bikeshed: total metadata size. But I'll accept any
other answer. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Well, you don't get to be a kernel hacker simply by looking ---   
                    good in Speedos. -- Rusty Russell                    

--sCNd3Ivk/oijKKf1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUvkjCFheFHXiqx3kAQKzthAAj9lQDYzOgkx3OfyVNKcuiHe0MGyat8Ff
WA4z48puvST/TGi3a+dKdarqXcotBYncyUP+miIWxNjmAn7O9Q40DVpprFzQzn4L
aTL0sioPcB8hmqJXqUUNT8qToIJgENEpIJvSAbzfIoBtxElcyQ7uODqfHxm9PzlP
pxw3j4RM2vQ+3EFH3Ci0FTmFs8Ym66EbfylUg+TRH6wgOrbmNJOB2EUgPeuYhxOu
HpIoXEEjhwTO1WohrvJKzpL5JBoHrNbBkfqujebnN3lVtuTb7LtkjtP3ud2viXdr
3oAmQHlGzWQ5BJPWKykZ3j0CjUUcMTmFKIPv96RW2defjTPGnzPLPSmHqw2zRKl/
MREeFzDeJBNwpUAQ39ctmoeKA4zxwbi/u6bXIhSad9bioAZEOec0bexsZ2Cac8TB
RxyGvf//hwGabhfRqiNcB0uEHjTjEuX/TyDvc7k3AtSIj60rZDV6+3bhj7wht908
Y16aQRyoLMRbm7v//7IYPRbK1EqbWt+hKRIdSs4TElfCt3acZeF5Grmyx+hmMvXd
rOuRjvWiTy1pY6wZgVFQIsh24Ff2MC2LNNVErKOi0Jdxe78xYWPAViK5DAulBR/i
wcQKVNW9AEltYssoEc5eDnPmRi7Tsg4by8LT3ilgUY7ayxkJyaXn+9lqQx0lsgTA
mc3UDNeiReQ=
=C5cj
-----END PGP SIGNATURE-----

--sCNd3Ivk/oijKKf1--
