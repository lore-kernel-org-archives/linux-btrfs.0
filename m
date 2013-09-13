Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42351 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab3IMOMH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 10:12:07 -0400
Date: Fri, 13 Sep 2013 15:11:59 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20130913141159.GI25694@carfax.org.uk>
References: <20130912153629.16487.88969@localhost.localdomain>
 <52330E18.5040405@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h22Fi9ANawrtbNPX"
In-Reply-To: <52330E18.5040405@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--h22Fi9ANawrtbNPX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 13, 2013 at 09:07:36AM -0400, Ric Wheeler wrote:
> On 09/12/2013 11:36 AM, Chris Mason wrote:
> >Mark Fasheh's offline dedup work is also here.  In this case offline
> >means the FS is mounted and active, but the dedup work is not done
> >inline during file IO.   This is a building block where utilities  are
> >able to ask the FS to dedup a series of extents.  The kernel takes
> >care of verifying the data involved really is the same.  Today this
> >involves reading both extents, but we'll continue to evolve the patches.
> 
> Nice feature!
> 
> Just a note, the "offline" label is really confusing. In other
> storage products, they typically call this "out of band" since you
> are online but not during the actual write in a synchronous way :)

   I knew there was a specific term for this, but couldn't remember
what it was. I've now updated the btrfs website's description(s) of
the feature to include "out-of-band" and "in-band".

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Once is happenstance; twice is coincidence; three times ---     
                            is enemy action.                             

--h22Fi9ANawrtbNPX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUjMdL1heFHXiqx3kAQKSDw//Yn/vpAPBkTsSUTB7DbamrEP8b8stR0lS
kOkiA7N3mnSr36MLi8NZyrsvvxPU1LenwqgpQe1dQEsiOkVuZHIQY+T1OlM8nMMI
ZzcsLw/4Y/fJEJ02ZG2VKk4YOdXS68YYph1RaWTZwPvCrUvtWrIlLy/8vm0qOFQJ
MiHAswH1WWL3l14eR9+CMdime8+zOQPaMRvezZwlFff/EMQEHIlnvy/yvdpbEehQ
gztV8RepbM8lFJQDS7g4fGd37ACByhH0ko9/OHmHOBRqvEfAa1hxkZ/DGySeH39t
rnsv+D3OyjS4v/xcShTkdPrq7XVlZBaMqddEA3Q5C74V+2mIktRYc1mTgO4ngHYz
3zgd/A393BvvYuFFbWLNVUuPAzCQhPV3YXwpwtjM/kiG69JYbqy3ttlBN1yODlr8
EJwlik7cwLWTNtsHP54QtbDFbtiSGXmXqmCNmMy+a6qI+4uJImInWFW3wmq5rldI
TGn11ddHDd8QSUTZiZZMgQRIgaKScdpH89D4uU20dX/j2Pncvh5UzbdynV8GEgQi
HX2vzwHgNDhr4Q5Cfalq2txBV2RK2ZtXgxqw0BVmKDbZWprZ8dgPaiBnKf9OUCSK
iv8O1LuO66/n3bU7fmQUTU0nMTR1fOrTDaUQxthb4Zo7sq7TJBvZr7Sq36NA3lSn
SE5o7xAInrY=
=mKzG
-----END PGP SIGNATURE-----

--h22Fi9ANawrtbNPX--
