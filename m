Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mylinuxtime.de ([148.251.109.235]:60741 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaFEI7o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 04:59:44 -0400
Date: Thu, 5 Jun 2014 10:59:37 +0200
From: Christian Hesse <mail@eworm.de>
To: David Sterba <dsterba@suse.cz>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: fix compiler warning
Message-ID: <20140605105937.33bdd84d@leda.localdomain>
In-Reply-To: <20140604164437.GA1903@twin.jikos.cz>
References: <1401794959-25907-1-git-send-email-mail@eworm.de>
	<538EC135.6060105@cn.fujitsu.com>
	<20140604091926.37ad5ef2@leda.localdomain>
	<20140604164437.GA1903@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/gTAR.7MRBTTD8NTnPAuQCLn"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/gTAR.7MRBTTD8NTnPAuQCLn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

David Sterba <dsterba@suse.cz> on Wed, 2014/06/04 18:44:
> On Wed, Jun 04, 2014 at 09:19:26AM +0200, Christian Hesse wrote:
> > > It seems to be related to default gcc flags from distribution?
> >=20
> > Probably. I did compile with optimization, so adding -O2 may do the tri=
ck:
> >=20
> > make CFLAGS=3D"${CFLAGS} -O2" all
>=20
> The warning appears with -O2, so the question is if gcc is not able to
> reason about the values (ie. a false positive) or if there's a bug that
> I don't see.

I do not see a bug either. So probably this is a false positive...

Looks like the warning is triggered as soon as -ftree-vrp is added to CFLAG=
S.
=46rom gcc man page:

-ftree-vrp
       Perform Value Range Propagation on trees.  This is similar to the
       constant propagation pass, but instead of values, ranges of values a=
re
       propagated.  This allows the optimizers to remove unnecessary range
       checks like array bound checks and null pointer checks.  This is
       enabled by default at -O2 and higher.  Null pointer check elimination
       is only done if -fdelete-null-pointer-checks is enabled.

Is it possibly that gcc optimized away any checks?
--=20
Schoene Gruesse
Chris
                         O< ascii ribbon campaign
                   stop html mail - www.asciiribbon.org

--Sig_/gTAR.7MRBTTD8NTnPAuQCLn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTkDF9AAoJEFTtyRYJvJGDbcYP/Rqrjvqu7IDJ93QZXZU5kEXf
kFetkWVdKIAVVHNweKF428UjIk6YnZk83hk3UOZlr/CvjN3qiDrh3rd1skBpkBoU
aFHZ/yDr3MK5rIbKAKlQln9sVYRkZgSFk2enkk3yAVaGnWfs72ztOEhTuJNVxs1g
u2ZuRkdAr3Qi9AAJxAEXOO0GmAMQFtH6aRE7f8C7yp9xpgyUl1smQPZsXTE0goDt
tuAwrRbm5kb7dPQ7w+WkUBbJJOyjvyOYWZkO3Ouutwo9ohAZRwlELOaqYPkhgT5u
yRnz8HYMCS1PlQfm/3KHOiGBFlQIjbzmKKHjVWH0Yqo0xRLW8N0v3QpbttQwon9q
lILE30ZSoX8sRzaExkuRk4Uwn9ZesdB1SrQYWU55wKTU7Gu93KOkwNdIh3GGSVxd
OpcCEv5blP+2E9ZW0QFlaEWfN4DLA0YpttwWGUS+SScNEWR0Fg8SKGCbImVWYhJp
MPu7cqEeom3ma3YamJcQRx7m+z+WbHGwLSwsxpQZ3sL/Dl2OZGzXVkztGtbb+ECB
BdLWaTv7VaUQXTXIobGt/9Yzz3AmhZy4HrK0xn/J3dfh3QK80rLfeydNrpq5lBQr
nP6rSdmRP/spSMiOHXeupSN082gSv8P/Vsh8/hQtmhrecASSl5CpDZtE08snny4m
N4yei+PlBuowsTjlx2AP
=mHHG
-----END PGP SIGNATURE-----

--Sig_/gTAR.7MRBTTD8NTnPAuQCLn--
