Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:44254 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933710AbbDIJbQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Apr 2015 05:31:16 -0400
Received: from moh2-ve3.go2.pl (moh2-ve3.go2.pl [193.17.41.208])
	by tur.go2.pl (Postfix) with ESMTP id AE06B309FE
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2015 11:02:23 +0200 (CEST)
Received: from moh2-ve3.go2.pl (unknown [10.0.0.208])
	by moh2-ve3.go2.pl (Postfix) with ESMTP id 5D5C7958019
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2015 11:02:16 +0200 (CEST)
Received: from unknown (unknown [10.0.0.42])
	by moh2-ve3.go2.pl (Postfix) with SMTP
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2015 11:02:16 +0200 (CEST)
Date: Thu, 9 Apr 2015 11:02:10 +0200
From: Piotr Szymaniak <szarpaj@grubelek.pl>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: snapshot space use
Message-ID: <20150409090210.GZ9470@wloczykij>
References: <201504091039.33442.russell@coker.com.au>
 <5525CBA1.5000408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dEhLd0jN5MocHkcT"
In-Reply-To: <5525CBA1.5000408@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--dEhLd0jN5MocHkcT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 09, 2015 at 08:45:21AM +0800, Qu Wenruo wrote:
> *snip*
> NOTE: quota is not so stable and has some problem, but should give
> you enough info.

Those are related to actually using quota or can also hit you when you
want to use it just for things like this snapshot space use?


Piotr Szymaniak.
--=20
  - Oo,  jeste=C5=9B  bystrzejszy,  ni=C5=BC  si=C4=99  wydaje.  Przechodzi=
=C5=82e=C5=9B  jakie=C5=9B
szkolenie antyterrorystyczne?
  - W pewnym sensie tak. By=C5=82em =C5=BConaty.
 -- Nelson DeMille, "The Lion's Game"

--dEhLd0jN5MocHkcT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVJkASAAoJEEMpAov1cw9lFccQAJe7uv2ThAkwLCqtK/RZEM5q
WH7qZSTXqwlQgvByanZKGRqJR8DmBj0C3jgaUW5DbSxwu6gXI7/tRuWZ5Wvlkitf
HYHKWkjKOiNUPlGS4MWRxojPFfxzkgkSFDNRnPbp7d5u97dlvG4/odOQvJl8sZPo
48huJGpGjycLb1rIRbYzLt4lgUPz6h09Yidzp9Lm5ZSNJfYmZdQC7AI0G9LGegoY
1l3upw2Af1u61JAlowF+2hZOinC/o6D2ETFttT4ga/dZuS4Jqll2u1kgJVbNr6Vi
vSynIzFAtA4IHNsgntitIeDE2v67fbdVvI6Za2xPFRoMWVO963NGG632wTT6yyC/
G4cwNsBqLkplE9WVpDBLQWcjbBxnXoPGNmhydyH7CQs0JSa+XM6oY+XwrZaUd/Qm
OKygZ6Acqh0EQhADYasSPJHx/FIYPnsuIFzXRQK3SPzioeF57q1U//b6LenRxDDP
m8XjUh7sskPe9+MuesY7AXh6GGKbUJJuFmNuHQpydo7g4mKlC+C54r2ku/DfboDB
pMt13twHk7Av4mSHWpVUKIkPWs9xSfie7NQ170bqjdy9iJSn1Md8wMOtvauwbmrY
qYnqOdFdeQcTiBA4nADMdXQ7dm9q4krbp4Tf9YTNu5ex04pCtVpvWtgAIsXqulAZ
vu1786Cl11rVnmwgCRuw
=ylUw
-----END PGP SIGNATURE-----

--dEhLd0jN5MocHkcT--
