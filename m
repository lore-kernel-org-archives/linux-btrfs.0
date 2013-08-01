Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53272 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab3HALIw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Aug 2013 07:08:52 -0400
Date: Thu, 1 Aug 2013 12:08:49 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Andrew Stubbs <andrew.stubbs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to merge two partitions?
Message-ID: <20130801110849.GZ20517@carfax.org.uk>
References: <51FA3E2E.30405@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qicHaSekiYEWE95x"
In-Reply-To: <51FA3E2E.30405@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qicHaSekiYEWE95x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 01, 2013 at 11:53:34AM +0100, Andrew Stubbs wrote:
> If I have two partitions, /dev/sda1 and /dev/sda2, one btrfs, and
> one ext4 (but I could convert it first), how can I merge them into
> one filesystem without moving all the data onto an external device
> and then moving it all back again? (I do have a backup, of course,
> but transferring the data takes hours, maybe days.)

   That's going to be the easiest option by far.

> I'm left with this layout for historical reasons, and now the
> smaller partition is close to running out of space.
> 
> I thought of using "btrfs device add" and just living with the
> untidy underlying devices, but an experiment with loopback
> filesystems shows that any data on the new device is silently
> obliterated (it might be nice if the docs mentioned this!)

   You would expect data in a different filesystem format to be
integrated into an existing set of data structures? That would be...
magic. :)

> I've thought of shrinking the larger partition, creating a third
> partition, and adding that to the smaller filesystem. This would
> solve the free-space issue, but doesn't feel great.
> 
> I've thought of using a temporary third partition as an
> intermediary, but I don't have space to move all the data in one go.
> 
> I've thought of using a clever partition manager to move the start
> of the second partition, transfer some data, move it some more,
> transfer some more data, but this seems like an equally lengthy
> process.

   That's the other option I'd go for.

> I could move the data from the smaller partition into the larger
> one, then delete the first partition, and move the whole larger
> partition forward, extend it, and fix up the fstab. That might be
> less painful.
> 
> Is there a cunning btrfs trick to do this? Can a btrfs filesystem be
> extended "backwards", if you see what I mean?

   No, using gparted to move it backwards into the free space is your
best option here.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- I don't know. I can't tell the future, I just work there. ---    

--qicHaSekiYEWE95x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUfpBwVheFHXiqx3kAQL87w/+Nh1K6KcB1Hk1SGhikJuV5W8j2CV9nBws
87ufv/9zMApioV5NZveplHNkanNRukojZUiXXdr+IOHzpjs5MyqAf7RqXTuvdv01
q5kg461nrQjgCwugum5txsSg1CsZERijt/ti+7AycgriJgwYujYyizs4/pyA2tSl
GfK0e162Gdr7+0bnj69YZjfgjXiPenmqNkrA5wv5TDXBrVotjzgUTjhQA2U5qIFP
x+aAGmfEsp3iQUVJ9IGXJV0Jm3bxjyaYUXjARmA0RO8FunM2OLG1MI7O5gUfIiQf
8PMHjjJNSiC8kwkomqgKMRFJop17ZWMsUKsQ4TCqw6u+4VVUYa8otRIKJPhhoB98
OCiTRpMymzQ7Hk9yLBX4cE8TbH/Ih7sKp1ZMvXeib/ZT+hRfqG9fszwHQgDzYzw+
tB/Nuy4gFCBPSyfPSQecVwU5iFgM0vhExglDCtjV+3yWl5g7jKcW+9/gCk7sZQ7g
QG8lHNlobXNzFfDswMykopu/hIc/7dy/Tp232nd6CpOE0icfIybn00PSMeYFK4YJ
J3qaFaYTHuR2SJOk7j55rdhT29aDo2ZMqbI80zHNaCcuGG1KJQ7g7h/nF8dVP1hw
IpqyGBAr/VWajEjIETdwJL4y5hZIYj0KkJjaA7PZVB6b9X81Wc73jKn4N8wnKJeY
a0X0JRAHmFQ=
=OMbd
-----END PGP SIGNATURE-----

--qicHaSekiYEWE95x--
