Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36727 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbbGNSlX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 14:41:23 -0400
Date: Tue, 14 Jul 2015 18:41:22 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: counting fragments takes more time than defragmenting
Message-ID: <20150714184122.GL10539@carfax.org.uk>
References: <20150604084245.GR23272@merlins.org>
 <20150624032008.GF20517@merlins.org>
 <CAA7pwKOA1yyA8kyB+a3iTOp8TnkRzAErF1Mo=2t5M3pFn2tjUw@mail.gmail.com>
 <pan$5335b$94315604$8405c6ac$de90de30@cox.net>
 <CAA7pwKNtS6UB+tXdB9c4D9J2gOk56gM-O1q+19A6SZcdcdFVtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sMZCuqyhuhd4ycTi"
In-Reply-To: <CAA7pwKNtS6UB+tXdB9c4D9J2gOk56gM-O1q+19A6SZcdcdFVtw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--sMZCuqyhuhd4ycTi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 14, 2015 at 01:57:07PM +0200, Patrik Lundquist wrote:
> On 24 June 2015 at 12:46, Duncan <1i5t5.duncan@cox.net> wrote:
> >
> > Regardless of whether 1 or huge -t means maximum defrag, however, the
> > nominal data chunk size of 1 GiB means that 30 GiB file you mentioned
> > should be considered ideally defragged at 31 extents.  This is a
> > departure from ext4, which AFAIK in theory has no extent upper limit, so
> > should be able to do that 30 GiB file in a single extent.
> >
> > But btrfs or ext4, 31 extents ideal or a single extent ideal, 150 extents
> > still indicates at least some remaining fragmentation.
> 
> So I converted the VMware VMDK file to a VirtualBox VDI file:
> 
> -rw------- 1 plu plu 28845539328 jul 13 13:36 Windows7-disk1.vmdk
> -rw------- 1 plu plu 28993126400 jul 13 14:04 Windows7.vdi
> 
> $ filefrag Windows7.vdi
> Windows7.vdi: 15 extents found
> 
> $ btrfs filesystem defragment -t 3g Windows7.vdi
> $ filefrag Windows7.vdi
> Windows7.vdi: 24 extents found
> 
> How can it be less than 28 extents with a chunk size of 1 GiB?

   I _think_ the fragment size will be limited by the block group
size. This is not the same as the chunk size for some RAID levels --
for example, RAID-0, a block group can be anything from 2 to n chunks
(across the same number of devices), where each chunk is 1 GiB, so
potentially you could have arbitrary-sized block groups. The same
would apply to RAID-10, -5 and -6.

   (Note, I haven't verified this, but it makes sense based on what I
know of the internal data structures).

   Hugo.

-- 
Hugo Mills             | Go not to the elves for counsel, for they will say
hugo@... carfax.org.uk | both no and yes.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--sMZCuqyhuhd4ycTi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVpVfRAAoJEFheFHXiqx3kf0UQAKu7sNIG2LINanvZQShMdYOT
kEYgVOs3loU2Q7w9TBDur15Jex0Vt0aevakYRcOjzB9nKG6bXSNpUphvxPKk4BRv
xvVQYHygOOXHRARxyB/+8kgkQO+K+7DLv83jrx2hcn8L7z54aYEqige5Cb2pIKth
JP0uV+FgLz83k758dQweFc04j/jMS0XclEVWBeI/kabJ1MJMlvE/hd/drQPLBNW0
sEC86cW0UNbFyavmm5cx7D6EZbAnNHADFqqc0SwaKcHQAWNEJbLDmvrXwCSWLapk
f5Qb75jWfGRojFKPUfIWJqsdE2ybKfUjIzm3Db7BQsQJPUeJqVSTHn6MWJkIOIBW
m1iWPucAKOOJBViVmTeaUgPhwUjnZYK3Ery6vwUB20YA4ZKRwM1F3YgS10MtT8GU
M3XErJmkmXR0Km6xOKCAUKK9hUjbPTmZqrMqUh3h2CgS8f1/grP75lQ/BFCpefx2
n//dZRE7QA3Z5MksBMQvy8j2NF++WQ1PNvf4/iT8gi6BJEoC3kE/2dyV7YmZPtLU
gt3KqjFcQX/E2yKUhPzmIE9sW/1IT8SpxapaodCrBpj96YNRXtMxCqkd9m42gO6c
FWVb7vb/LGK6f4NM5EZEsv3nVIZgjRsFcz2Nkav3jKE9JCvQ7lwSm3DQrMld7hq/
ZYvz7Zti+47Z5bOhxWgJ
=8TmV
-----END PGP SIGNATURE-----

--sMZCuqyhuhd4ycTi--
