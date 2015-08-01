Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46860 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbHAUmv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Aug 2015 16:42:51 -0400
Date: Sat, 1 Aug 2015 20:42:49 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: ext4 convert bugs, wiki warning?
Message-ID: <20150801204249.GB14352@carfax.org.uk>
References: <CAJCQCtQJpEVPk_qAUj68qRxoftUyPww0Pm0aYHhkaM51+uOO=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
In-Reply-To: <CAJCQCtQJpEVPk_qAUj68qRxoftUyPww0Pm0aYHhkaM51+uOO=g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 01, 2015 at 11:29:40AM -0600, Chris Murphy wrote:
> Does someone with wiki edit capability want to put up a warning about
> btrfs-convert problems? I don't think it needs to be a lengthy write
> up since the scope of the problem is not clear yet. But since there's
> definitely reproduced problems that have been going on for some time
> now maybe it'd be a good idea to put up a warning until this is more
> stable?
> 
> I'm thinking of just a yellow warning "sidebar" like thing that maybe
> just says there's been a regression and it's breaking file systems,
> sometimes irreparably?

   You mean a warning like the very first sentence, in bold, that's
already on the wiki page?

https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3

   Hugo.

-- 
Hugo Mills             | You've read the project plan. Forget that. We're
hugo@... carfax.org.uk | going to Do Stuff and Have Fun doing it.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                           Jeremy Frey

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVvS9JAAoJEFheFHXiqx3kOjYQAKqjVpKAka0XUWW+ZY250pfe
aSg+vcKJn6o+0vsP+bRYIbHEzchkFE/UQwDKGl4+PJkMyq3XfHvJutwZIldrByDl
KQhOo+XwkduPajt4E4Xi/QqBYHO3q430eDUZA2+ca9SCaCjZI3Htg3HBY6sJSDAi
OubXqcxLRjfTVyxkMb/b2R1ARZ3AVlCh0IY22Q8sLjTW/rm7vqEtZwnJj2oPRktm
zmnp+Qnh29FdEso/0LKkZaAxJ1Rl9/sraSV6Lq67SEp/4LSkFKc7q7ZP/78kr8he
9aLVZUfFcLe7MHAmOMSp1z4JP3WuP0cBq8nNfrMbiYcJLfxHW0fD0kgp06YME8P8
E/ImANf09D3cDPCrJedjtspFU78f1notyT7hiqLcLyN6T0UZoGocyC7HxO9BIHDD
H2H193pRawuER37JCubOjyAAd4Lb8a+ZFIQCxq6+im1oxoSQ/juTQhHdT3ASLrlG
BTY8+l7HWpD+kfVMkm4EcqoSy03wbruH6JuU61yvt+pZEQjH8wg/F7SxFaLK5Sv4
rxKRbysgP+tVd4wuToNEIrmol9nFPDeIcq6bOvx9Blu4l0nfLGJfh5pKm2i1166b
jChN81dAfVzw9uLg9EB0ion42/xGQZz/HGzSDKQ0b+D5Hfhog2z4whxjc06IE/o2
uhVe6JZa0UwucIqe48eX
=TnbS
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
