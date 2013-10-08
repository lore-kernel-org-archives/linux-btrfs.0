Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39789 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab3JHRKp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Oct 2013 13:10:45 -0400
Date: Tue, 8 Oct 2013 18:10:43 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Shilong Wang <wangshilong1991@gmail.com>, David Sterba <dsterba@suse.cz>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 10/12] Btrfs-progs: add '--block-size' option to
 control print result
Message-ID: <20131008171043.GO28147@carfax.org.uk>
References: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1381130508-8458-11-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <20131008153439.GE4322@twin.jikos.cz>
 <CAP9B-Qm_PmpNiKk_jmvQvti5djvbtk-hbZgT9NjFqaYWGrpGeg@mail.gmail.com>
 <20131008170157.GN28147@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qse+WBH4guesipZ+"
In-Reply-To: <20131008170157.GN28147@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qse+WBH4guesipZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 08, 2013 at 06:01:57PM +0100, Hugo Mills wrote:
> On Wed, Oct 09, 2013 at 12:54:03AM +0800, Shilong Wang wrote:
> > Hi David,
> > 
> > 2013/10/8 David Sterba <dsterba@suse.cz>:
> > > On Mon, Oct 07, 2013 at 03:21:46PM +0800, Wang Shilong wrote:
> > >> You can use it like:
> > >>       btrfs qgroup show --block-size=m <mnt>
> > >>
> > >> Here, block size supports k/K/m/M/g/G/t/T/p/P/e/E.
> 
> k = SI prefix, kilo
> K = ? (IEEE prefix kibi?)

   ... or SI unit, kelvin

> t = ?

   SI-accepted unit, tonne

> e = ?

   SI-accepted unit, charge on the electron

   Hugo. :)

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- I spent most of my money on drink, women and fast cars. The ---   
                      rest I wasted.  -- James Hunt                      

--qse+WBH4guesipZ+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUlQ8k1heFHXiqx3kAQJouQ/9HkjmjNOc9FeP+YJUxbcJhdL4UjrhX6rv
VUw6XXOVJalmPUb2J7v0w6d++v7TIavm7gAc35grwAUZBGauiK8YGsSA1d4nGjEz
DPR4ch+DG+GYauMb7fIR2Q3vpQkkzaEYwDChIcnmUTpjYPFeuWTqMpTryaqapNQm
4/+W3H6zGfs03ofjkIUSwd9j6RoJE1KEuXn+iPL8u4H8ZL7VuGyWY+GscYC3U1Tx
dmf0kCTZcjCxh39gjxmRuhzb/VEA/QzfKY3Lz69uisxU9oyhYubzfM4V0n6qjhv2
p9oAtKbDg9XRDHrcxuQUSIaDdNaP997cIoYRRCyqojO2w6AEnix/NDTJ1bJWGo03
0/DXbuzkK0v/7IMMpQe2iGit9kcGyiKJ9Br5EVZbHWrlMpDWYrtkNNHhLcsiPP7z
jVBYtQ3EUiuAohpxCWsYkG/qYY7HoUnvqfzIMI+a/qmL5qOhXU0JIrWnHHEaLHFp
upCAcv2WrvcHdXolRjkrnxRDOQm41tPHjZP07b40Ua1AaBKKz28iKZr82oLs3zCV
ilQwMKuW7SWDVP4tkm4q3b3yjLldsOgPYK9l/rSrmH/aHzYHyQ70IwAPOqNnNrPT
ydWaS336C5K221fxj8cOqua6F/j5SuoxSaIpl8imwRUBe3JNCNCAjSz6jjf+uEY4
zQIme5zW4kk=
=hVMn
-----END PGP SIGNATURE-----

--qse+WBH4guesipZ+--
