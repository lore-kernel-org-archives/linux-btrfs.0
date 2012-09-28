Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40873 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab2I1I6r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Sep 2012 04:58:47 -0400
Date: Fri, 28 Sep 2012 09:58:40 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Roman Mamedov <rm@romanrm.ru>
Cc: kreijack@inwind.it, kreijack@libero.it,
        =?iso-8859-1?Q?S=E9bastien?= Maury <sebastien.maury@inserm.fr>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs fi df output [Was Re: BTRF - Storage Usage]
Message-ID: <20120928085840.GE6136@carfax.org.uk>
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr>
 <5064B96B.7060502@libero.it>
 <5064BEEB.1090707@libero.it>
 <20120928091759.6d096016@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qOrJKOH36bD5yhNe"
In-Reply-To: <20120928091759.6d096016@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qOrJKOH36bD5yhNe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 28, 2012 at 09:17:59AM +0600, Roman Mamedov wrote:
> On Thu, 27 Sep 2012 23:02:35 +0200
> Goffredo Baroncelli <kreijack@libero.it> wrote:
> 
> > Sorry for the space error:
> > Below a more correct example
> > 
> > $ btrfs filesystem disk-free /
> > Summary:
> >     Total:             	        135.00GB
> >     Allocated:             	 10.51GB
> >     Unallocated:            	124.49GB
> >     Free_(Estimated)              86.56GB
> >     Average_disk_efficiency:         62 %
> 
> How do you estimate "Free" here? Sorry I didn't check the source code in git,
> but from the "Details" below nothing leads me to believe that this FS is
> doomed to only be able to usefully utilize only ~86GB of the partition, and not
> more.
> 
> Are you ready to answer the flood of questions from people why their disk is
> only 62% efficient, and how to tune it to 100%? :-)

   Data_to_disk_ratio, maybe?

> Why use underscores instead of spaces?

   So that you can use, say, "read" in the shell to extract data from
each line. To that end, there should be a space between the value and
the unit throughout.

> > Details:
> >     Chunk-type    Mode       Allocated        Used        Free
> >     ----------    ----       ---------    --------   ---------

   Minor thing: The underlines are largely superfluous. Few basic CL
tools I can think of use them.

> >     Data          Single        4.01GB      2.16GB      1.87GB
> >     System        DUP          16.00MB      4.00KB      7.99MB
> >     System        Single        4.00MB        0.00      4.00MB
> >     Metadata      DUP           6.00GB    429.16MB      2.57GB
> >     Metadata      Single        8.00MB        0.00      8.00MB

   I think we need another column here, to indicate how much *actual*
disk space is used by each row, so adding up that column will give you
the "Allocated" value in the first clause. I think that's probably the
biggest cause of confusion. "Raw alloc.", maybe, and use the term
"raw" somewhere in the first clause to hammer the point home.

   My only concern here is that we're a bit too close to the existing
solution (albeit merging the two sets of output), which has proven
itself over time to be somewhat confusing. I think the Alloc_Raw
column is the minimum necessary to link the two in some easily
determinable way. Adding totals to Alloc_Raw, and Used (but not Free
or Alloc) would help, I think. I don't think it's useful to add them
to the Free or Alloc columns, because those figures change as the FS
allocates chunks, and we'll end up with people querying the fact that
the total of Free doesn't add up to any of the figures in the
summary.

   Say, something like this:

Summary_(Raw):
  Total:                    135.00 GiB
  Allocated:            	 10.51 GiB
  Unallocated:            	124.49 GiB
  Free_(Estimated):          86.56 GiB
  Average_disk_efficiency:      62 %

Details:
  Chunk_type  Mode    Alloc_Raw  Alloc      Used        Free
  Data        Single   4.01 GiB   4.01 GiB    2.16 GiB  1.87 GiB
  System      DUP     32.00 MiB  16.00 MiB    4.00 KiB  7.99 MiB
  System      Single   4.00 MiB   4.00 MiB    0.00 B    4.00 MiB
  Metadata    DUP     12.00 GiB   6.00 GiB  429.16 MiB  2.57 GiB
  Metadata    Single   8.00 MiB   8.00 MiB    0.00 B    8.00 MiB
  Total               16.04 GiB               2.59 GiB

   The other thing is that there should be a switch (or possibly two)
to give highly machine-readable versions of the output -- no units
(units as bytes by default, with other units settable by a switch),
tab-separated, possibly a different option for each of the above
output clauses.

   Ultimately, I think the bikeshed should be turquoise.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Python is executable pseudocode; perl ---              
                        is executable line-noise.                        

--qOrJKOH36bD5yhNe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUGVmv79z9OVl50rAAQLibw/+J/LlGXN/MUlWWacPeZxECFQeiHReHdw1
ISfrCjn/9Lm3DX32WeYLwLwlK6RSdbmsZrOXhrEEzfGxWXjl571CGfTTTgUYULc1
dk5Xoyx20DH+3N/EBzas6gAZm066f/uPeAsneMASSqrzqxUksIE3c8U8pAQ/IUlh
8/qM6ZN+k3SWwcSTnbAOIGMad0VppJB0N3vfSLSaniAhmDulWrkS0VLPw3nUTtfR
CbY9faAAaS8MkQwzmXNkFQnkgJmUgk99Oe/vzAwol/7mwuHsW/ETEGx+d8lpW9bj
btYVE/lz79SuHAJRm8NqmFaExwz+QzMtNWWHG4l6Q7gvuGtAnTCG4O3tHc6GwbnE
hDPt1JAF7WNeOJTskiRYqNl1rFHr84K8IAz4u1uqYWRWnGaIpCJcv0Kuv1sU4mkx
kl+1aqgVhfWGwKvHQ2T7iJ26rp2QQVUa+lVn6YmJNWedyYTWgpGGt+alt3AS0pQw
4WbzmMHQd3sLgwWaxNBslYzV3NFgjmxOIt4gdMPFYApwWtGM0HUgSIczpcRLMnIT
yU/MXjMx46jD2egBLUSw3txCkjwjBEa4jdu8yikH0G7SPRy6WOLA35imyWu91zvx
WnGK8CvkWB24QaBXua8Qo2X4s7qQAxg9oXjzxdVDCLModKXdPbBN5mC/v6ExXrzn
addVsg+77so=
=Rt9c
-----END PGP SIGNATURE-----

--qOrJKOH36bD5yhNe--
