Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35013 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaBXIaB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 03:30:01 -0500
Date: Mon, 24 Feb 2014 08:29:38 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs userland interface isn't 32/64bit clean (breaks lsattr and
 btrfs send)
Message-ID: <20140224082938.GF23877@carfax.org.uk>
References: <20140224055103.GA15937@merlins.org>
 <pan$78eb$fa967f30$1d30da9e$2510275d@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y1L3PTX8QE8cb2T+"
In-Reply-To: <pan$78eb$fa967f30$1d30da9e$2510275d@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Y1L3PTX8QE8cb2T+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 24, 2014 at 06:32:14AM +0000, Duncan wrote:
> Marc MERLIN posted on Sun, 23 Feb 2014 21:51:03 -0800 as excerpted:
> 
> > In the end I pinned it down to this:
> > 3.13.5's kernel/userland interface fails if my kernel is 64bit and my
> > userland 32bit.
> 
> This is a known issue.  There's patches in the pipeline for 32-bit 
> userspace on a 64-bit kernel, already.

   If you mean my recent patch, that's only for receive. I've not
noticed any other issues on my 32/64 system, but I've not done much
with it either (with btrfs, it's only really used for btrfs receive --
everything else is ext4).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Welcome to Hollywood, a land just off the coast ---         
                            of Planet Earth.                             

--Y1L3PTX8QE8cb2T+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUwsC8lheFHXiqx3kAQLejQ//RQFqYlHfdOPo3ThNbVWNTCLgzJa3DeaW
YClao9bOlQAHtkuLajh4a8TICa1Xes7uvCggaBQJjKZILSMH0mxJ1ZbDTlfsOPOD
6Z5ZC9E69eU2n96kn+/gz9I+z3O98ru1QjhlpHsnTzQ1NBVFonTm4CS1smuk4Lsb
Rz9ze+RukWmVce5V5o0BJ5OYnRcmP2HDLE2U1ER7p+68F72BS+0HyRyjBeZrm3Em
kPRMYQTQTZ1oOMsbR22whAEg7mF0kNQ05GzsEfF2gsjHBu8c+idGwSYiso1MkGG+
6wQu7b5wShOaUiQQD/ZZgIDX7LsF4/nIcSAhAncc77kS8iUesipY0kcmzOgxVsNT
kTBSfbDzzUaCphkvgvKHyDAtTRzPe0YdNK7xxu12d0VVEg2fadsKAVcGh2U9Xxbp
BMTZfwx9KH3sLimAQW5qLWRChHgLJE3F1A4SbO87LaKatHnfN3CcId7dDN6IWivM
UDH6d7d3YtRhzSeCGHyGw7Vg/gh42H/cP+w5vi1L3kw8KJgUXNFsfXGcwEEQoy89
P3WDkzh5TbWSu/WsfDJH7lR84hp8Mka13U59Uoh4X6kSuU0XYJeROJyIXQ8jLSCz
8vwtIg+BAWu3DpnkdyE2pS5FscIcxqvke1hlTAJcoLFwTUSylYlceN1+BjhAJZTg
aEvjc8VxpzI=
=BGxT
-----END PGP SIGNATURE-----

--Y1L3PTX8QE8cb2T+--
