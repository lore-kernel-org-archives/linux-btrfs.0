Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35425 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaIIT4a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Sep 2014 15:56:30 -0400
Date: Tue, 9 Sep 2014 20:56:26 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC on mostly empty file system
Message-ID: <20140909195626.GB5783@carfax.org.uk>
References: <3150960.nnNb4J6vhp@wuerfel>
 <4255785.FLXNWijYCD@wuerfel>
 <CAFvQSYQX9e__9vUedcqN2onUA4v2yyt2wz7wGdzAkTHzLL+ggw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
In-Reply-To: <CAFvQSYQX9e__9vUedcqN2onUA4v2yyt2wz7wGdzAkTHzLL+ggw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 09, 2014 at 09:49:12PM +0200, Clemens Eisserer wrote:
> Hi Arnd,
> 
> > Ok, one more data point:
> 
> Why don't you provide the data point you were specifically asked for,
> "btrfs fi df" ;)

   btrfs fi show is important as well -- it's hard to work out the
state of the FS from just one of them.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- You can get more with a kind word and a two-by-four than you ---   
                       can with just a kind word.                        

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVA9balheFHXiqx3kAQIdZxAAjVB6QKIsPwMyf/NYAXVl/5EIMtSvPk2y
WfBAikdAm/ZdWvwAjgSPJzoCYKwPZMc/aoWe843Vz5D7hRXLtJhd/LurfbrgBbse
Lnu/gqtf3MBc0dS2nVbQXwtg/MsR8fGBfIp//r30IvX5zdX+BJAhIaQNliRN5ERe
hqTId1jqx/z84HlM3cp0Hog13y31+7kYiqvDcvwz0X9RJrzrVJooe7235/TK0K1d
vyw9MwVfy2W51HqA3ySOs1j+3Fk5o5pFKp6hkcRjyuh9Pn18e1L0pSZQBI+HCoh/
xbij8W/44Xwl15/VJj1/7PtIgUKFxPJ6Q5s85wf8YZlJ0NaP72YDgIRILzeKMeFY
WaOJ5uDCMyQpH3ijB851d7Bog2Jli3hqAZsuMeQlW5BzREAfmP28Jq3BvCUScpv2
hvjrlLF7HZKDMAL875bFf3LxaUfOREsR5yXpaj4/EjtNx88I9ekAUvn6LmvtxQKi
DS0b3n4ylttlIl1SEOZ4LN+qkIFSPCnaFoUTT81/L4MDiUY/j7eCGvP/T2oYZM+X
WgUiypavV5my7kPxm9G1R//KXzEUrUYzyIVkbM+Aj4N268ft9aBv+PvVLRPziE9z
OBFkhp2vrf2J4bo7XAqsyTmIX1rXTVd0ztoOd13w27PEa+7vXR8J+cUaYKTwhEVy
MAy3tdI0Jjs=
=ZSJz
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
