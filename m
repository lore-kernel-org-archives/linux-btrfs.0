Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58190 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbaGBQbL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 12:31:11 -0400
Date: Wed, 2 Jul 2014 17:31:07 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Zhe Zhang <zhe.zhang.research@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Question about debugfs on btrfs
Message-ID: <20140702163107.GL1738@carfax.org.uk>
References: <CAMXuLLrQoEB0sfY5P4ZCYn3a8Urk-RC3N_a2AoQrnKG-OeYNuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XbHSybK3LHOYQtWI"
In-Reply-To: <CAMXuLLrQoEB0sfY5P4ZCYn3a8Urk-RC3N_a2AoQrnKG-OeYNuQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XbHSybK3LHOYQtWI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 02, 2014 at 12:23:01PM -0400, Zhe Zhang wrote:
> Hi,
> 
> I'm trying to use a functionality like "debugfs blocks" or
> "dump_extents" on a btrfs partition. The current debugfs user space
> program doesn't seem to support it (from e2fsprogs). I cannot find
> debugfs in btrfs-progs either. Any advice on how to do it?

   I don't know what the ext* debugfs does, but the odds of it
actually working on btrfs are pretty slim, given that they're
completely different filesystems. :)

   If you want a human-readable view of the filesystem's metadata,
then btrfs-debug-tree is the tool you need.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Someone's been throwing dead sheep down my Fun Well ---       

--XbHSybK3LHOYQtWI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU7Qzy1heFHXiqx3kAQIpRA//S+94aq/HLosDkdG7KUJ/XEuCYhRoZp6h
Au0fsGARVha7CPW59JJPq3weGaKHnK1/ONVsM6rfLHzfWInQNi1kfBteTrWL7R7B
JJYH9aZs+f6i2wXaOO5BkJWPR2wZrUGyjnYNcLIAqP29rEVnmG3g+pqbQZdqjpr2
tuf8Bmj17zOwsFWqRwv1rrBQW0h7CjQU8DVn/vsOrJlMBuIl6HOYPdgLSkZNb32m
IqBxpUZqqIH5QiuG2h573XPg99ZDBgq5hJv9IfpTio2PC0Qw+Bo9byS25mAt0R6i
G6kNxYuelz4pwQktJyUZX5jIynCqtE/xVUBfSXFoMIEJPAEx2dkD5q3YiFDpguwg
z6QatDErO5aG8fVx4NHivziQHwSiB6O9ThydnPuasEV+FylaC75apUFEXutys6OA
UNYYgoIViHs5G6zum4h9GNScI6cu5TcLXV+8rAigcEpOPYyVOaKx8Ii4p0iU3HxJ
MrGrz5PvSBQMzS4CFgEU6BKDiF7iYWpdq7lC8rfdTVvtDHO7BCgsjdPOI1r2IAMf
EJpAGgwYlIXjx0OJ4MIcbdO5DIEwNZZjfAFtEqcaGUvDwld/yHadS1oLOinwVSl0
WXTDFbOKSVx1GVO+lWeHSzk6PxZ3WaDOCGoo2CRXzO9Su/iP6EyhH4hbX3Bvv+UK
PSmnNjLRuRA=
=I6KJ
-----END PGP SIGNATURE-----

--XbHSybK3LHOYQtWI--
