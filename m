Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35486 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbcCGSrX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 13:47:23 -0500
Date: Mon, 7 Mar 2016 18:47:18 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Marc Haber <mh+linux-btrfs@zugschlus.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-image run time
Message-ID: <20160307184718.GC17196@carfax.org.uk>
References: <20160307172717.GJ6939@torres.zugschlus.de>
 <20160307173811.GK6939@torres.zugschlus.de>
 <CAJCQCtRe4NXm5kC4svvO1det4NFN2fxUjDPSe7DFpOvXiL9X6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sr1nOIr3CvdE5hEN"
In-Reply-To: <CAJCQCtRe4NXm5kC4svvO1det4NFN2fxUjDPSe7DFpOvXiL9X6w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Sr1nOIr3CvdE5hEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 07, 2016 at 11:09:57AM -0700, Chris Murphy wrote:
> On Mon, Mar 7, 2016 at 10:38 AM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> > On Mon, Mar 07, 2016 at 06:27:17PM +0100, Marc Haber wrote:
> >> how long is btrfs-image taking to run on a 400 GiB filesystem?
> >>
> >> I have /bin/btrfs-image -s -t 8 -s /dev/mapper/mydevice - | pixz -9 >
> >> file.on.other.fs running for four hours now
> >
> > Strike my question please, I didn't see that I had the -s doubled.
> > With one -s I now see actual progress.
> 
> Could be worth a bug report and a patch to keep it from using
> duplicate switches.

   No, the duplicate -s is a valid part of the API.

   One -s will replace the filenames with random data. A second one
will attempt to find a replacement name that matches the CRC32 hash of
the filename. That's why it takes so long.

   Hugo.

-- 
Hugo Mills             | What do you give the man who has everything?
hugo@... carfax.org.uk | Penicillin is a good start...
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--Sr1nOIr3CvdE5hEN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJW3cy2AAoJEFheFHXiqx3kveUP/3bQVYRovO4F190xq0Qk8AAa
quse6PY7kk2nUh1D/17EhRWcn2hvm14Ws9/fchlxZMoJza2RDCLiVB9zMIEYTAIa
1wJRANxbgiHe/PzFY7OZmZP+Z3zjXSoYab6zQ+3v5csa4G+kq8rht6hzGzk3d0oo
g26X3d7j78L96a+kfVIuZSQc7C6H7bCf+JLcKgMOIl/5GkgABjqae22ZTqbqWgCJ
R0P3CoSpWJNEreFcI53iQZdtp1ODskgrShk4V6igJpaPjLIujyTU1dNB/i8gbbPw
RE83bihl8SG9EB18U2dw1wnLbkzHNTSZiV9Wo+g9IYeIpbI8LCC81F6wxac8mPFV
2Hd2y/In2DjipuIX3VrSZeoNN1Baahs4ryikC32AiDbTlrewQAunHpsAc5LDIk3w
5UB5mcBuiKw+TiqJuInNe922iTRx9MMKjNBYNr52dXgq99hH/CXAYSOg/2iBshiQ
G/oA4XHTs8PcmMJhEByspGpSkKVyDA18RNhloUQQiSQWtwm4vVyZBt49isG2Hwp9
i0Eym1/62EbBEk8sLfxh+jaaVdhLGqsWsG+VVC/D3rAzHXfYlnpR6pvKf13wtyvW
E9btU24SzFbl+tbBXnbYNtur9yQdEqFoW0fzR+oSZHApw3DINPM/6p9Qsf92y7ck
DHDoLjnV0ONziQ9fvuR+
=mR4k
-----END PGP SIGNATURE-----

--Sr1nOIr3CvdE5hEN--
