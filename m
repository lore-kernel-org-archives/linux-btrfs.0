Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56747 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161027AbeBOTL5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:11:57 -0500
Date: Thu, 15 Feb 2018 19:11:55 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Ellis H. Wilson III" <ellisw@panasas.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Metadata / Data on Heterogeneous Media
Message-ID: <20180215191155.GP3807@carfax.org.uk>
References: <1b2df382-0402-a806-9ebf-996fabf22ba4@panasas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Eclf2LUqbhpvYoNt"
In-Reply-To: <1b2df382-0402-a806-9ebf-996fabf22ba4@panasas.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Eclf2LUqbhpvYoNt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 15, 2018 at 12:15:49PM -0500, Ellis H. Wilson III wrote:
> In discussing the performance of various metadata operations over
> the past few days I've had this idea in the back of my head, and
> wanted to see if anybody had already thought about it before
> (likely, I would guess).
> 
> It appears based on this page:
> https://btrfs.wiki.kernel.org/index.php/Btrfs_design
> that data and metadata in BTRFS are fairly well isolated from one
> another, particularly in the case of large files.  This appears
> reinforced by a recent comment from Qu ("...btrfs strictly
> split metadata and data usage...").
> 
> Yet, while there are plenty of options to RAID0/1/10/etc across
> generally homogeneous media types, there doesn't appear to be any
> functionality (at least that I can find) to segment different BTRFS
> internals to different types of devices.  E.G., place metadata trees
> and extent block groups on SSD, and data trees and extent block
> groups on HDD(s).
> 
> Is this something that has already been considered (and if so,
> implemented, which would make me extremely happy)?  Is it feasible
> it is hasn't been approached yet?  I admit my internal knowledge of
> BTRFS is fleeting, though I'm trying to work on that daily at this
> time, so forgive me if this is unapproachable for obvious
> architectural reasons.

   Well, it's been discussed, and I wrote up a theoretical framework
which should cover a wide range of use-cases:

https://www.spinics.net/lists/linux-btrfs/msg33916.html

   I never got round to implementing it, though -- I ran into issues
over storing the properties/metadata needed to configure it.

   Hugo.

-- 
Hugo Mills             | Dullest spy film ever: The Eastbourne Ultimatum
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       The Thick of It

--Eclf2LUqbhpvYoNt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJahdt7AAoJEFheFHXiqx3kWPkQALNrXFU8ehBlbZvtx+Ktbn5O
Oq9iq+Iopn0ssDm6yH5aF+nsHPMU8nY6NGxgJrjG+YNpbXq5icn3HXJwgzIFfHMN
ivdhdqV2carP7dcjhJRXjfX78UElRUwZN+zUFY8vj4xvJ1di25QHVWhOke8Tq3aJ
LWczEXPdyJ4kSbrCNbLov+q24x2WB7dZjyFgJT6SxFwDj3M97DNJ0SOAMSLaGe56
HL+9rmqwgcxD5MAWVLnfdK+w5S5198VBpkavUlR1BgVO3QJJv8pgZYhd6piGyCpS
4BQXzRI8A1JcDHHSyyQmsEIF0Z4fp0zA8OainsTEo6KTxlhfMJtrGOE0InlBflzr
dt/NnnHL5cWY93W+8zHrnirOG8zB6l3u1Zu/ScGhVWEhGvvberOrlnbJJ+w5bSQV
+29mSUX1rBX6Chnj6SJlAFEFrGqlXdKGEZN70C59/ApLBxne8sRTLSRRbGyxvpMt
/Na0/DHmynJXUYy6qVbUC7QdPI2vY3254Xi2MHdzxkpT7LctZl6fQemGGHOG42ZT
gBEpy3cO9MOdTdnz8XAXylM0wSZn2YopmSS8xtcatPaM8iu7xO7jqm7+vAlLE8aE
tHfUTm7KFWHh+2/nfNXbDvQlImtbPfF6vuuSAxriKWE6xi0W7WwsKMOdc5zMA45U
7D9xbNeDmBsTJxIDjKEf
=IaB8
-----END PGP SIGNATURE-----

--Eclf2LUqbhpvYoNt--
