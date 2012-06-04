Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56456 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab2FDLtI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 07:49:08 -0400
Date: Mon, 4 Jun 2012 12:49:01 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Maxim Mikheev <mikhmv@gmail.com>
Cc: Arne Jansen <sensille@gmx.net>, Liu Bo <liubo2009@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Help with data recovering
Message-ID: <20120604114901.GA15986@carfax.org.uk>
References: <4FCA189F.9050000@gmail.com>
 <4FCC0DD7.9050807@cn.fujitsu.com>
 <4FCC12BA.9070701@gmail.com>
 <4FCC1A6F.8050805@cn.fujitsu.com>
 <4FCC1AE1.8050802@gmail.com>
 <4FCC2496.6070805@cn.fujitsu.com>
 <4FCC6F44.2030503@gmx.net>
 <4FCC9C63.7000605@gmail.com>
 <4FCC9CD5.2050309@gmx.net>
 <4FCC9F6C.5090305@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
In-Reply-To: <4FCC9F6C.5090305@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 04, 2012 at 07:43:40AM -0400, Maxim Mikheev wrote:
> Hi Arne,
> 
> Can you advice how can I recover data?
> I tried almost everything what I found on https://btrfs.wiki.kernel.org
> 
> /btrfs-restore restored some files but it is not what was stored.

   Can you post the complete output of find-root please?

> I have seen this command
> 
> --------------------------------------------------
> In case of a corrupted superblock, start by asking btrfsck to use an
> alternate copy of the superblock instead of the superblock #0. This
> is achieved via the -s option followed by the number of the
> alternate copy you wish to use. In the following example we ask for
> using the superblock copy #2 of /dev/sda7:
> 
> # ./btrfsck -s 2 /dev/sd7
> 
> -----------------------------------------
> but it gave me:
> $ sudo btrfsck -s 2 /dev/sdb
> btrfsck: invalid option -- 's'
> usage: btrfsck dev
> Btrfs Btrfs v0.19

   What exact version of the package do you have? Did you compile from
a recent git, or do you have a distribution -progs package installed?
If the latter, what date does it have in the version number?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                 --- This year,  I'm giving up Lent. ---                 

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPzKCtIKyzvlFcI40RAmDPAJ4iptFlyYC+NFTMz2ugabkdyoVPUQCgtJQI
mjc+6+WrK2scU/Bd7fNJaAA=
=40H3
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
