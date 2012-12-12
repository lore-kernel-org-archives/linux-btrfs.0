Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53064 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2LLT3q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 14:29:46 -0500
Date: Wed, 12 Dec 2012 19:29:42 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: subvolume show
Message-ID: <20121212192942.GC19051@carfax.org.uk>
References: <50C8CB70.4060901@czarc.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
In-Reply-To: <50C8CB70.4060901@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 12, 2012 at 01:22:40PM -0500, Gene Czarcinski wrote:
> I was looking through some of the archives and notice a patch
> submitted to implement:
>       btrfs  subvolume  show  <path-to-subvolume>
> command.
> 
> I also noticed that is does not appear to be in the git.
> 
> This looks like a useful capability.  I was trying to find out what
> the UUID was for a newly created subvolume and have not found out
> how to do that.

   Subvolumes don't have independent UUIDs, that's probably why...

   They have unique IDs, which you can see with "btrfs sub list
/mountpoint", and use those IDs to identify which subvolume to mount
with -o subvolid=...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- emacs: Emacs Makes A Computer Slow. ---               

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUMjbJr9z9OVl50rAAQKhgxAAok3g43U/L29+MPnSlju0YJDfA/6fyBJF
koiT/YYqP0FyW/o1qfmbjp4tkEN0M9E3Qg6x/HaA/GqUyL7O8HxK2tZPnJI6NVjJ
FKPjhrKB1m+M8mTSL/OAwR6rCIHS3egnii8aj5QaJBbUJ+AlR3vMWCeH8xZIz/5e
LJJhdQTP+LkABIsmM5X65Qa4TjQAm/sjAB5oFgRA3rTC0RyO3z+b3rwcPMKlehfy
P4W2JC/yCsu5LICOj2ZWnXXyRsKhKZP9jhP7xUbmt0U6Hz5smb7gM6/PuwD8DCud
JzIeva8M23MEk7fQRLJP8vGdxcKk/zm7fVAS3Znj4PUS8Aj3ThaZaedFedmpglO3
Ij3Emug2+LssWuj9xSrSBI+TvLAt0XyZUPVy/oEqaeTGQO8+cmTFJOL3cg2I59Zf
77/vIpqYEUmxveGWaMxBtsZOdUu3L+TiujQyNPjJnA5ZsO0J4TaPWRJW2UyBIP2N
NfvGpBj3YOk5K8cO6xT31Qqi2FFnhZ8cxiD5QIJPcBwNQNDZ2l7p5yRZr/KIv0o5
8aurEGFvX5SVR94bqDQxzl5gmCadpNCjY+L5477xE4xtW1DR6Pv43c5VEOX3PMIp
gCySEU7frnjz/UsiAqYcg7S9q2D55bzWV9VKJm4jo6Z/R3P9J/PqxptgVcZj2cIY
ioeQsxJjSVs=
=8+Kc
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
