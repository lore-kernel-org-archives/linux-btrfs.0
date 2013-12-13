Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:32795 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3LMUf5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 15:35:57 -0500
Date: Fri, 13 Dec 2013 20:35:54 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-send-receive vs rsync for (incremental/full) backups
Message-ID: <20131213203554.GP9738@carfax.org.uk>
References: <l8fo25$a4h$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8HhMLSHvAouSipEr"
In-Reply-To: <l8fo25$a4h$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--8HhMLSHvAouSipEr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 13, 2013 at 07:44:16PM +0000, Martin wrote:
> OK... So for backing up across a local network to a second physical host...
> 
> Is btrfs-send-receive stable enough now to be used?

   It seems to be OK for me at the moment -- I'm not running it across
a network (yet), but I am using it between different filesystems on
the same host, using pipes.

> How does send-receive compare to using rsync for backups?

   It's more fiddly to get right, and needs a bit more thought about
how to set it up sanely. I have a python library that I use to write
my backup scripts. I'll have to write it up one of these days...

> Any comments please from those using such things?

   Works for me, so far, as far as I know. Although we've got recent
reports of *something* still going wrong with systemd journal files.
No investigation of that yet, though.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- In one respect at least, the Martians are a happy people: ---    
                          they have no lawyers.                          

--8HhMLSHvAouSipEr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUqtvqlheFHXiqx3kAQL8aA//Sns0Y5jQkBtFckwxTi8a95S52iqcXfO3
ysxWpTQbkkeeoFE1sD9hJH2Z4Gf/ng8cbeEuBS8GEKR55ckTVabzkgl7F3LWTJil
s1WtPIYB7+9GinMhv+WQCAUOK2HYFehX1zid04R368Xv8P1fWc47M0hC/d3Ta6rD
655ivjMnMFRJghFT/J+WT9yrzYnWW98sYXBrYuDv+NHv4mypZ9gGA+Lbq4WwiMcs
FcK2ol0C6Bz6BllbKcPYMyfBs2fiK7lB/Acgqtl7I+PCXbSGDSs41GWDoYZ/jXBO
tYYuoMyNBaXkFFgPAX7B+qPO2fdh1lDmHmz7axWiFfh9iux8dwH9eZui3DKE3RJd
iUCtLuvNWtn/JMgY5QUSxr8NCQPo62W8aPVBrpvxKTRk521SZMal6KOinnFh/4Js
alBn2p4y9YGUFlB3xdWWc1WL129R1xWVOBv1jB9QSO+e0g4ldOlvZn/JO7bHH52K
ZqduDR9RU+mzzeX9X47OQtfXLb7fCHpjmM//POphpw/XF8w1nCAFcjh61fTijHQF
E7e0COKNNvN+FfsPMWo/A720/Da3RhLdUVuqUECp4b4BIs7vmSaVH1F69/9riNBL
83/9iPomPVYE2KcfxfDo+wtjeBvFrGfxYuKTYBKuJvHQTxGgY7iD3vRT6+wf2L7a
Lamra+wdHEk=
=XYvT
-----END PGP SIGNATURE-----

--8HhMLSHvAouSipEr--
