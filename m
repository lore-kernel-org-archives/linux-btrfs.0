Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37633 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaLCIht (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Dec 2014 03:37:49 -0500
Date: Wed, 3 Dec 2014 08:37:46 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Moving an entire subvol?
Message-ID: <20141203083746.GQ32735@carfax.org.uk>
References: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com>
 <CAJCQCtT3EeGUOpZ9q78BcWv_Cc_5UGY=uPVJX+bqex9Zo_bWYg@mail.gmail.com>
 <CAH-HCWUSX+N2Byo4vpCxac89TSX2YGoP39VgFsq6952k9V9cmQ@mail.gmail.com>
 <20141202083419.GK32735@carfax.org.uk>
 <CAH-HCWV_EhhQ11UT4Ysb0OT4tJfmEuWBek_z8MPeHwBZ0R7H3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6SWS31fp4apnN2Tf"
In-Reply-To: <CAH-HCWV_EhhQ11UT4Ysb0OT4tJfmEuWBek_z8MPeHwBZ0R7H3Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--6SWS31fp4apnN2Tf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 03, 2014 at 08:02:31AM +0530, Shriramana Sharma wrote:
> On Tue, Dec 2, 2014 at 2:04 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >
> >> Is that correct: what btr sub list shows as "top level" is indeed the
> >> parent subvolume?
> >
> >    No, it's the top-level subvolume. (See my earlier mail about
> > nomenclature). "Parent subvolume" has a number of meanings, none of
> > which should be "the subvolume with subvolid 5".
> 
> Um I searched my inbox but didn't find a specific definition from you
> for "top-level". You only said it's better to avoid calling it "root"
> to avoid confounding it with the subvol that may be mounted at root
> i.e. /.

   It was the first line I wrote in my first reply to your thread
about subvol 5 vs subvol 0. I had hoped to be both definitive and
comprehensive.

> IIUC the "top-level subvolume" can only be subvolid 5 which accords
> with your later comment:
> 
> > that putting files in the top-level subvol can't do what most people
> > want to do with it. Hence the recommended subvol management layout at
> > [1] https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Subvolumes
> 
> ... which means that I am not able to understand the output of btr sub
> list which gives the subvolid of whichever subvol is currently the
> "parent" (as in outer nesting) subvol. Observe:
> 
> $ btr sub list .
> ID 257 gen 10 top level 5 path test1
> ID 258 gen 10 top level 5 path test2
> ID 259 gen 9 top level 258 path test2/foo
> $ sudo mv test2/foo test1/
> $ btr sub list .
> ID 257 gen 10 top level 5 path test1
> ID 258 gen 10 top level 5 path test2
> ID 259 gen 9 top level 257 path test1/foo
> $
> 
> So now what is the meaning of "top level"?

   Urgh. I haven't seriously looked at that piece of output in a
while. That's broken, in my opinion. Here, "top level" means
"containing subvolume ID".

   Hugo.

-- 
Hugo Mills             | "I don't like the look of it, I tell you." "Well,
hugo@... carfax.org.uk | stop looking at it, then."
http://carfax.org.uk/  |
PGP: 65E74AC0          |                                             The Goons

--6SWS31fp4apnN2Tf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUfsvaAAoJEFheFHXiqx3kQPUQALvUORbSrlgBPNaxDp9wL3Fz
E+rV81AWU8F2o0tXlq1voDTQ1GY+Qk14FoT6n6sbMIBx9frzaZCE/+QdDWkjxsxU
V1sqwL0KwkrZwUUWhX9B64wTlKX1rjlhVVvvBEkpgtveDfJH9RDwnWLUN23sDG3M
h8mUsN8i9xBjhfQy2eRjjzRlWlnROwFC0rB+R+XANsx8yz0rowA2qcxgXk8vT5fI
jh+uFv81HdilC1cd3GThRDgvx8eKsPF3po/mYf1t+kUvwAnp+cY5FmTouf8pxbR7
pMH8iQeeTRgtue1K0qkSgm6i5imBWn7yAsZHdG10YYDP4TnpH5kKYJtmic+PC1fr
4gWA5wqkgAWR3VEUKA07eGkrwA72HDywwmMXYj2UAS2dd949lm/e5jVpq36E/SuY
PpidbfK3m882FVwV0+4Tj+ZAHiHlDJ9CP8L2DISiE3b8tVEXPRpinVPxqxKmXEKQ
Ahx3+mfWGO3tm5JSZEBlugq9zW9EMxzbOacJohMuojfXx/1dkkDjwRm2EKeOhlG0
HxVZjWjyZvDeDtWLgcdC3trL7xdOwllHl9hm51/aZVF9lr4LKwxABsSzKAsFGIJC
iLnLYlSdyxsEs0A5Vwr7r97mJCjhkBy8kLHjDULrfVELZcdc9OfYXJwt1Foh5zNX
Lp8f2EDaqkAXO5T9hIc6
=7SEH
-----END PGP SIGNATURE-----

--6SWS31fp4apnN2Tf--
